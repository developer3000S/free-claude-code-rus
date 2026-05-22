"""Application services for the Claude-compatible API."""

from __future__ import annotations

import traceback
import uuid
from collections.abc import AsyncIterator, Callable
from typing import Any

import httpx
from fastapi import HTTPException
from fastapi.responses import StreamingResponse
from loguru import logger

from config.settings import Settings
from core.anthropic import get_token_count, get_user_facing_error_message
from core.anthropic.sse import ANTHROPIC_SSE_RESPONSE_HEADERS
from core.trace import api_messages_request_snapshot, trace_event, traced_async_stream
from providers.base import BaseProvider
from providers.exceptions import (
    APIError,
    AuthenticationError,
    InvalidRequestError,
    OverloadedError,
    ProviderError,
    RateLimitError,
    ServiceUnavailableError,
)

from .model_router import ModelRouter, RoutedMessagesRequest
from .models.anthropic import MessagesRequest, TokenCountRequest
from .models.responses import TokenCountResponse
from .optimization_handlers import try_optimizations
from .web_tools.egress import WebFetchEgressPolicy
from .web_tools.request import (
    is_web_server_tool_request,
    openai_chat_upstream_server_tool_error,
)
from .web_tools.streaming import stream_web_server_tool_response

TokenCounter = Callable[[list[Any], str | list[Any] | None, list[Any] | None], int]

ProviderGetter = Callable[[str], BaseProvider]

# Providers that use ``/chat/completions`` + Anthropic-to-OpenAI conversion (not native Messages).
_OPENAI_CHAT_UPSTREAM_IDS = frozenset({"nvidia_nim", "opencode", "opencode_go", "zai"})


def anthropic_sse_streaming_response(
    body: AsyncIterator[str],
) -> StreamingResponse:
    """Return a :class:`StreamingResponse` for Anthropic-style SSE streams."""
    return StreamingResponse(
        body,
        media_type="text/event-stream",
        headers=ANTHROPIC_SSE_RESPONSE_HEADERS,
    )


def _http_status_for_unexpected_service_exception(_exc: BaseException) -> int:
    """HTTP status for uncaught non-provider failures (stable client contract)."""
    return 500


def _log_unexpected_service_exception(
    settings: Settings,
    exc: BaseException,
    *,
    context: str,
    request_id: str | None = None,
) -> None:
    """Log service-layer failures without echoing exception text unless opted in."""
    if settings.log_api_error_tracebacks:
        if request_id is not None:
            logger.error("{} request_id={}: {}", context, request_id, exc)
        else:
            logger.error("{}: {}", context, exc)
        logger.error(traceback.format_exc())
        return
    if request_id is not None:
        logger.error(
            "{} request_id={} exc_type={}",
            context,
            request_id,
            type(exc).__name__,
        )
    else:
        logger.error("{} exc_type={}", context, type(exc).__name__)


_CONVERSION_RETRYABLE_MARKERS = (
    "image blocks are not supported",
    "OpenAI chat conversion does not support",
    "use a native Anthropic transport provider",
    "use a vision-capable native Anthropic provider",
)


def _is_retryable_provider_error(exc: BaseException) -> bool:
    """Return True for errors that warrant trying the next provider in a chain."""
    if isinstance(exc, InvalidRequestError):
        # Provider-specific conversion limitations (e.g. an OpenAI-chat transport
        # rejecting image blocks) should fall through to a different provider that
        # can handle the feature, rather than failing the whole request.
        message = str(exc)
        return any(marker in message for marker in _CONVERSION_RETRYABLE_MARKERS)
    if isinstance(
        exc,
        (
            RateLimitError,
            OverloadedError,
            AuthenticationError,
            ServiceUnavailableError,
        ),
    ):
        return True
    if isinstance(exc, APIError):
        return exc.status_code >= 500 or exc.status_code in (
            401,
            403,
            404,
            408,
            410,
            429,
        )
    return isinstance(
        exc,
        (
            httpx.ConnectError,
            httpx.ConnectTimeout,
            httpx.ReadTimeout,
            httpx.WriteTimeout,
            httpx.PoolTimeout,
            httpx.RemoteProtocolError,
            httpx.ReadError,
        ),
    )


async def _continue_stream(
    stream: AsyncIterator[str], first_chunk: str
) -> AsyncIterator[str]:
    """Prepend ``first_chunk`` to an in-flight async stream."""
    yield first_chunk
    async for chunk in stream:
        yield chunk


def _require_non_empty_messages(messages: list[Any]) -> None:
    if not messages:
        raise InvalidRequestError("messages cannot be empty")


class ClaudeProxyService:
    """Coordinate request optimization, model routing, token count, and providers."""

    def __init__(
        self,
        settings: Settings,
        provider_getter: ProviderGetter,
        model_router: ModelRouter | None = None,
        token_counter: TokenCounter = get_token_count,
    ):
        self._settings = settings
        self._provider_getter = provider_getter
        self._model_router = model_router or ModelRouter(settings)
        self._token_counter = token_counter

    def create_message(self, request_data: MessagesRequest) -> object:
        """Create a message response or streaming response."""
        try:
            _require_non_empty_messages(request_data.messages)

            chain = self._model_router.resolve_messages_request_chain(request_data)
            primary = chain.primary

            # Single-candidate chains preserve the historical eager-raise contract:
            # if the sole provider is an openai-chat upstream that cannot handle the
            # request's web tool blocks, fail fast here rather than deferring to the
            # streaming generator. Multi-candidate chains let the fallback machinery
            # try the next provider instead.
            if (
                len(chain.candidates) == 1
                and primary.resolved.provider_id in _OPENAI_CHAT_UPSTREAM_IDS
            ):
                tool_err = openai_chat_upstream_server_tool_error(
                    primary.request,
                    web_tools_enabled=self._settings.enable_web_server_tools,
                )
                if tool_err is not None:
                    raise InvalidRequestError(tool_err)

            if self._settings.enable_web_server_tools and is_web_server_tool_request(
                primary.request
            ):
                input_tokens = self._token_counter(
                    primary.request.messages,
                    primary.request.system,
                    primary.request.tools,
                )
                trace_event(
                    stage="routing",
                    event="api.optimization.web_server_tool",
                    source="api",
                    model=primary.request.model,
                )
                egress = WebFetchEgressPolicy(
                    allow_private_network_targets=self._settings.web_fetch_allow_private_networks,
                    allowed_schemes=self._settings.web_fetch_allowed_scheme_set(),
                )
                return anthropic_sse_streaming_response(
                    stream_web_server_tool_response(
                        primary.request,
                        input_tokens=input_tokens,
                        web_fetch_egress=egress,
                        verbose_client_errors=self._settings.log_api_error_tracebacks,
                    ),
                )

            optimized = try_optimizations(primary.request, self._settings)
            if optimized is not None:
                trace_event(
                    stage="routing",
                    event="api.optimization.short_circuit",
                    source="api",
                    model=primary.request.model,
                )
                return optimized
            logger.debug("No optimization matched, routing to provider")

            # Emit request-level trace events eagerly so observers see the same
            # ingress timeline whether or not the body iterator is consumed.
            request_id = f"req_{uuid.uuid4().hex[:12]}"
            trace_event(
                stage="ingress",
                event="api.request.received",
                source="api",
                message_count=len(primary.request.messages),
                snapshot=api_messages_request_snapshot(primary.request),
            )
            if self._settings.log_raw_api_payloads:
                logger.debug(
                    "FULL_PAYLOAD [{}]: {}",
                    request_id,
                    primary.request.model_dump(),
                )

            if len(chain.candidates) == 1:
                # Single-candidate chain: preserve the historical eager-bind behaviour
                # so synchronous provider errors surface as HTTP 500 here.
                return self._stream_single_candidate(primary, request_id)

            return anthropic_sse_streaming_response(
                self._stream_with_fallback(chain.candidates, request_id),
            )

        except ProviderError:
            raise
        except Exception as e:
            _log_unexpected_service_exception(
                self._settings, e, context="CREATE_MESSAGE_ERROR"
            )
            raise HTTPException(
                status_code=_http_status_for_unexpected_service_exception(e),
                detail=get_user_facing_error_message(e),
            ) from e

    def _stream_single_candidate(
        self, routed: RoutedMessagesRequest, request_id: str
    ) -> StreamingResponse:
        """Eager single-candidate path. Mirrors the pre-chain behaviour."""
        resolved = routed.resolved
        provider = self._provider_getter(resolved.provider_id)
        provider.preflight_stream(
            routed.request, thinking_enabled=resolved.thinking_enabled
        )
        trace_event(
            stage="routing",
            event="api.route.resolved",
            source="api",
            provider_id=resolved.provider_id,
            provider_model=resolved.provider_model,
            provider_model_ref=resolved.provider_model_ref,
            gateway_model=routed.request.model,
            thinking_enabled=resolved.thinking_enabled,
        )
        with logger.contextualize(request_id=request_id):
            logger.info(
                "API_REQUEST: request_id={} model={} messages={}",
                request_id,
                routed.request.model,
                len(routed.request.messages),
            )
            input_tokens = self._token_counter(
                routed.request.messages,
                routed.request.system,
                routed.request.tools,
            )
            streamed = traced_async_stream(
                provider.stream_response(
                    routed.request,
                    input_tokens=input_tokens,
                    request_id=request_id,
                    thinking_enabled=resolved.thinking_enabled,
                ),
                stage="egress",
                source="api",
                complete_event="api.response.stream_completed",
                interrupted_event="api.response.stream_interrupted",
                chunk_event=None,
                extra={
                    "request_id": request_id,
                    "provider_id": resolved.provider_id,
                    "gateway_model": routed.request.model,
                },
            )
            return anthropic_sse_streaming_response(streamed)

    async def _stream_with_fallback(
        self,
        candidates: tuple[RoutedMessagesRequest, ...],
        request_id: str,
    ) -> AsyncIterator[str]:
        """Iterate candidates in order, falling back on retryable upstream errors.

        Only fires fallback before any SSE bytes commit to the client. Each provider
        is asked to ``raise_pre_stream_errors`` so an upstream 429/5xx/auth/conversion
        failure surfaces as an exception we can catch and route to the next candidate.
        """
        last_error: BaseException | None = None
        total = len(candidates)
        single = total == 1
        for i, routed in enumerate(candidates):
            resolved = routed.resolved
            is_last = i == total - 1
            candidate_tag = f"{resolved.provider_id}/{resolved.provider_model}"

            if resolved.provider_id in _OPENAI_CHAT_UPSTREAM_IDS:
                tool_err = openai_chat_upstream_server_tool_error(
                    routed.request,
                    web_tools_enabled=self._settings.enable_web_server_tools,
                )
                if tool_err is not None:
                    last_error = InvalidRequestError(tool_err)
                    if is_last:
                        raise last_error
                    logger.warning(
                        "FALLBACK_SKIP: candidate={} ({}/{}) incompatible with Anthropic web tools, trying next",
                        candidate_tag,
                        i + 1,
                        total,
                    )
                    continue

            try:
                provider = self._provider_getter(resolved.provider_id)
                provider.preflight_stream(
                    routed.request,
                    thinking_enabled=resolved.thinking_enabled,
                )
            except ProviderError as e:
                last_error = e
                if is_last or not _is_retryable_provider_error(e):
                    raise
                logger.warning(
                    "FALLBACK_PREFLIGHT: candidate={} ({}/{}) {} status={}, trying next",
                    candidate_tag,
                    i + 1,
                    total,
                    type(e).__name__,
                    getattr(e, "status_code", "n/a"),
                )
                continue
            except Exception as e:
                last_error = e
                if is_last:
                    raise
                logger.warning(
                    "FALLBACK_PREFLIGHT: candidate={} ({}/{}) raised {}, trying next",
                    candidate_tag,
                    i + 1,
                    total,
                    type(e).__name__,
                )
                continue

            trace_event(
                stage="routing",
                event="api.route.resolved",
                source="api",
                provider_id=resolved.provider_id,
                provider_model=resolved.provider_model,
                provider_model_ref=resolved.provider_model_ref,
                gateway_model=routed.request.model,
                thinking_enabled=resolved.thinking_enabled,
                candidate_index=i + 1,
                candidate_total=total,
            )
            logger.info(
                "API_REQUEST: request_id={} candidate={}/{} provider={} model={} messages={}",
                request_id,
                i + 1,
                total,
                resolved.provider_id,
                routed.request.model,
                len(routed.request.messages),
            )
            with logger.contextualize(request_id=request_id):
                input_tokens = self._token_counter(
                    routed.request.messages,
                    routed.request.system,
                    routed.request.tools,
                )
                stream = provider.stream_response(
                    routed.request,
                    input_tokens=input_tokens,
                    request_id=request_id,
                    thinking_enabled=resolved.thinking_enabled,
                    raise_pre_stream_errors=not single,
                )

                try:
                    first_chunk = await stream.__anext__()
                except StopAsyncIteration:
                    return
                except ProviderError as e:
                    last_error = e
                    if is_last or not _is_retryable_provider_error(e):
                        raise
                    logger.warning(
                        "FALLBACK_STREAM: candidate={} ({}/{}) {} status={}, trying next",
                        candidate_tag,
                        i + 1,
                        total,
                        type(e).__name__,
                        getattr(e, "status_code", "n/a"),
                    )
                    continue
                except Exception as e:
                    last_error = e
                    if is_last or not _is_retryable_provider_error(e):
                        raise
                    logger.warning(
                        "FALLBACK_STREAM: candidate={} ({}/{}) raised {}, trying next",
                        candidate_tag,
                        i + 1,
                        total,
                        type(e).__name__,
                    )
                    continue

                logger.info(
                    "STREAM_COMMIT: request_id={} candidate={}/{} provider={} model={}",
                    request_id,
                    i + 1,
                    total,
                    resolved.provider_id,
                    resolved.provider_model,
                )
                streamed = traced_async_stream(
                    _continue_stream(stream, first_chunk),
                    stage="egress",
                    source="api",
                    complete_event="api.response.stream_completed",
                    interrupted_event="api.response.stream_interrupted",
                    chunk_event=None,
                    extra={
                        "request_id": request_id,
                        "provider_id": resolved.provider_id,
                        "gateway_model": routed.request.model,
                    },
                )
                async for chunk in streamed:
                    yield chunk
                return

        if last_error is not None:
            raise last_error

    def count_tokens(self, request_data: TokenCountRequest) -> TokenCountResponse:
        """Count tokens for a request after applying configured model routing."""
        request_id = f"req_{uuid.uuid4().hex[:12]}"
        with logger.contextualize(request_id=request_id):
            try:
                _require_non_empty_messages(request_data.messages)
                routed = self._model_router.resolve_token_count_request(request_data)
                tokens = self._token_counter(
                    routed.request.messages, routed.request.system, routed.request.tools
                )
                trace_event(
                    stage="routing",
                    event="api.route.resolved",
                    source="api",
                    kind="count_tokens",
                    provider_id=routed.resolved.provider_id,
                    provider_model=routed.resolved.provider_model,
                    provider_model_ref=routed.resolved.provider_model_ref,
                    gateway_model=routed.request.model,
                )
                trace_event(
                    stage="ingress",
                    event="api.count_tokens.completed",
                    source="api",
                    message_count=len(routed.request.messages),
                    input_tokens=tokens,
                    snapshot=api_messages_request_snapshot(routed.request),
                )
                return TokenCountResponse(input_tokens=tokens)
            except ProviderError:
                raise
            except Exception as e:
                _log_unexpected_service_exception(
                    self._settings,
                    e,
                    context="COUNT_TOKENS_ERROR",
                    request_id=request_id,
                )
                raise HTTPException(
                    status_code=_http_status_for_unexpected_service_exception(e),
                    detail=get_user_facing_error_message(e),
                ) from e
