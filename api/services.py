"""Application services for the Claude-compatible API."""

from __future__ import annotations

import contextlib
import json
import traceback
import uuid
from collections.abc import AsyncIterator, Callable
from typing import Any

from fastapi import HTTPException
from fastapi.responses import JSONResponse, StreamingResponse
from loguru import logger

from config.settings import Settings
from core.anthropic import get_token_count, get_user_facing_error_message
from core.anthropic.sse import ANTHROPIC_SSE_RESPONSE_HEADERS
from core.trace import api_messages_request_snapshot, trace_event, traced_async_stream
from providers.base import BaseProvider
from providers.exceptions import InvalidRequestError, ProviderError

from .model_router import ModelRouter
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


def _parse_sse_event(raw: str) -> tuple[str | None, dict | None]:
    """Parse one SSE event chunk into ``(event_name, data_dict)``.

    Returns ``(None, None)`` if the chunk is malformed or has no JSON payload.
    """
    event_name: str | None = None
    data_str: str | None = None
    for line in raw.splitlines():
        if line.startswith("event:"):
            event_name = line[6:].strip()
        elif line.startswith("data:"):
            piece = line[5:].strip()
            data_str = piece if data_str is None else data_str + piece
    if not event_name or data_str is None:
        return None, None
    try:
        return event_name, json.loads(data_str)
    except json.JSONDecodeError:
        return event_name, None


async def aggregate_sse_to_anthropic_response(
    sse_stream: AsyncIterator[str],
) -> dict[str, Any]:
    """Consume an Anthropic SSE stream and assemble a single Messages JSON response.

    Used to satisfy ``stream: false`` requests when the upstream gateway always
    streams. Builds content blocks (text / tool_use / thinking) from the
    block_start/delta/stop events and merges usage from message_delta.
    """
    message: dict[str, Any] = {
        "id": f"msg_{uuid.uuid4().hex[:24]}",
        "type": "message",
        "role": "assistant",
        "model": "",
        "content": [],
        "stop_reason": None,
        "stop_sequence": None,
        "usage": {"input_tokens": 0, "output_tokens": 0},
    }
    blocks: dict[int, dict[str, Any]] = {}
    tool_arg_buffers: dict[int, list[str]] = {}
    buffer = ""
    async for chunk in sse_stream:
        buffer += chunk
        while "\n\n" in buffer:
            event_text, buffer = buffer.split("\n\n", 1)
            name, data = _parse_sse_event(event_text)
            if name is None or data is None:
                continue
            if name == "message_start":
                msg = data.get("message", {})
                if isinstance(msg, dict):
                    for k in ("id", "model"):
                        if msg.get(k):
                            message[k] = msg[k]
                    usage = msg.get("usage")
                    if isinstance(usage, dict):
                        message["usage"]["input_tokens"] = usage.get(
                            "input_tokens", message["usage"]["input_tokens"]
                        )
                        message["usage"]["output_tokens"] = usage.get(
                            "output_tokens", message["usage"]["output_tokens"]
                        )
            elif name == "content_block_start":
                idx = data.get("index", 0)
                block = data.get("content_block", {})
                if isinstance(block, dict):
                    blocks[idx] = dict(block)
                    if block.get("type") == "tool_use":
                        tool_arg_buffers[idx] = []
                        blocks[idx].setdefault("input", {})
                    elif block.get("type") == "thinking":
                        blocks[idx].setdefault("thinking", "")
                    else:
                        blocks[idx].setdefault("text", "")
            elif name == "content_block_delta":
                idx = data.get("index", 0)
                delta = data.get("delta", {})
                if not isinstance(delta, dict):
                    continue
                block = blocks.setdefault(idx, {"type": "text", "text": ""})
                dtype = delta.get("type")
                if dtype == "text_delta":
                    block["text"] = block.get("text", "") + delta.get("text", "")
                elif dtype == "thinking_delta":
                    block["thinking"] = block.get("thinking", "") + delta.get(
                        "thinking", ""
                    )
                elif dtype == "input_json_delta":
                    tool_arg_buffers.setdefault(idx, []).append(
                        delta.get("partial_json", "")
                    )
            elif name == "content_block_stop":
                idx = data.get("index", 0)
                if idx in tool_arg_buffers:
                    joined = "".join(tool_arg_buffers.pop(idx))
                    if joined:
                        try:
                            blocks[idx]["input"] = json.loads(joined)
                        except json.JSONDecodeError:
                            blocks[idx]["input"] = {"_raw": joined}
            elif name == "message_delta":
                delta = data.get("delta", {})
                if isinstance(delta, dict):
                    if "stop_reason" in delta:
                        message["stop_reason"] = delta["stop_reason"]
                    if "stop_sequence" in delta:
                        message["stop_sequence"] = delta["stop_sequence"]
                usage = data.get("usage", {})
                if isinstance(usage, dict) and "output_tokens" in usage:
                    message["usage"]["output_tokens"] = usage["output_tokens"]
            elif name == "message_stop":
                pass
    message["content"] = [blocks[k] for k in sorted(blocks.keys())]
    if message["stop_reason"] is None:
        message["stop_reason"] = "end_turn"
    return message


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

    async def create_message_non_streaming(
        self, request_data: MessagesRequest
    ) -> JSONResponse:
        """Aggregate the streaming response and return a single Messages JSON.

        Used to satisfy clients that send ``stream: false`` (or omit ``stream``,
        which Anthropic treats as non-streaming). The gateway always produces an
        SSE stream internally; this method consumes it and returns the assembled
        Anthropic Messages object as a JSON response.
        """
        streaming = self.create_message(request_data)
        if not isinstance(streaming, StreamingResponse):
            return streaming  # already a non-streaming response (e.g. optimization short-circuit)
        body = streaming.body_iterator
        try:
            message = await aggregate_sse_to_anthropic_response(body)
        finally:
            close = getattr(body, "aclose", None)
            if close is not None:
                with contextlib.suppress(Exception):
                    await close()
        return JSONResponse(message)

    def create_message(self, request_data: MessagesRequest) -> object:
        """Create a message response or streaming response."""
        try:
            _require_non_empty_messages(request_data.messages)

            routed = self._model_router.resolve_messages_request(request_data)
            if routed.resolved.provider_id in _OPENAI_CHAT_UPSTREAM_IDS:
                tool_err = openai_chat_upstream_server_tool_error(
                    routed.request,
                    web_tools_enabled=self._settings.enable_web_server_tools,
                )
                if tool_err is not None:
                    raise InvalidRequestError(tool_err)

            if self._settings.enable_web_server_tools and is_web_server_tool_request(
                routed.request
            ):
                input_tokens = self._token_counter(
                    routed.request.messages, routed.request.system, routed.request.tools
                )
                trace_event(
                    stage="routing",
                    event="api.optimization.web_server_tool",
                    source="api",
                    model=routed.request.model,
                )
                egress = WebFetchEgressPolicy(
                    allow_private_network_targets=self._settings.web_fetch_allow_private_networks,
                    allowed_schemes=self._settings.web_fetch_allowed_scheme_set(),
                )
                return anthropic_sse_streaming_response(
                    stream_web_server_tool_response(
                        routed.request,
                        input_tokens=input_tokens,
                        web_fetch_egress=egress,
                        verbose_client_errors=self._settings.log_api_error_tracebacks,
                    ),
                )

            optimized = try_optimizations(routed.request, self._settings)
            if optimized is not None:
                trace_event(
                    stage="routing",
                    event="api.optimization.short_circuit",
                    source="api",
                    model=routed.request.model,
                )
                return optimized
            logger.debug("No optimization matched, routing to provider")

            provider = self._provider_getter(routed.resolved.provider_id)
            provider.preflight_stream(
                routed.request,
                thinking_enabled=routed.resolved.thinking_enabled,
            )

            trace_event(
                stage="routing",
                event="api.route.resolved",
                source="api",
                provider_id=routed.resolved.provider_id,
                provider_model=routed.resolved.provider_model,
                provider_model_ref=routed.resolved.provider_model_ref,
                gateway_model=routed.request.model,
                thinking_enabled=routed.resolved.thinking_enabled,
            )

            request_id = f"req_{uuid.uuid4().hex[:12]}"
            with logger.contextualize(request_id=request_id):
                trace_event(
                    stage="ingress",
                    event="api.request.received",
                    source="api",
                    message_count=len(routed.request.messages),
                    snapshot=api_messages_request_snapshot(routed.request),
                )

                if self._settings.log_raw_api_payloads:
                    logger.debug(
                        "FULL_PAYLOAD [{}]: {}", request_id, routed.request.model_dump()
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
                        thinking_enabled=routed.resolved.thinking_enabled,
                    ),
                    stage="egress",
                    source="api",
                    complete_event="api.response.stream_completed",
                    interrupted_event="api.response.stream_interrupted",
                    chunk_event=None,
                    extra={
                        "request_id": request_id,
                        "provider_id": routed.resolved.provider_id,
                        "gateway_model": routed.request.model,
                    },
                )
                return anthropic_sse_streaming_response(streamed)

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
