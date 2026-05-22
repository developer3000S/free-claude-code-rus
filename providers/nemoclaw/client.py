"""Nemoclaw provider implementation."""

from __future__ import annotations

import json
import uuid
from collections.abc import AsyncIterator
from typing import Any

import httpx

from providers.base import BaseProvider, ProviderConfig
from providers.defaults import NEMOCLAW_DEFAULT_BASE
from providers.model_listing import extract_openai_model_ids
from providers.rate_limit import GlobalRateLimiter


class NemoclawProvider(BaseProvider):
    """Nemoclaw adapter for ``POST /v1/chat`` with ``{"input": ...}`` payloads."""

    def __init__(self, config: ProviderConfig):
        super().__init__(config)
        self._provider_name = "NEMOCLAW"
        self._api_key = config.api_key
        self._base_url = (config.base_url or NEMOCLAW_DEFAULT_BASE).rstrip("/")
        self._global_rate_limiter = GlobalRateLimiter.get_scoped_instance(
            "nemoclaw",
            rate_limit=config.rate_limit,
            rate_window=config.rate_window,
            max_concurrency=config.max_concurrency,
        )
        self._client = httpx.AsyncClient(
            base_url=self._base_url,
            proxy=config.proxy or None,
            timeout=httpx.Timeout(
                config.http_read_timeout,
                connect=config.http_connect_timeout,
                read=config.http_read_timeout,
                write=config.http_write_timeout,
            ),
        )

    async def cleanup(self) -> None:
        """Release HTTP client resources."""
        await self._client.aclose()

    def _request_headers(self) -> dict[str, str]:
        return {
            "Authorization": f"Bearer {self._api_key}",
            "Content-Type": "application/json",
        }

    def _build_input(self, request: Any) -> str:
        parts: list[str] = []
        system_text = _extract_text_from_content(getattr(request, "system", None))
        if system_text:
            parts.append(f"system: {system_text}")
        for message in getattr(request, "messages", []):
            role = getattr(message, "role", "user")
            text = _extract_text_from_content(getattr(message, "content", ""))
            if text:
                parts.append(f"{role}: {text}")
        return "\n\n".join(parts)

    def _build_request_body(self, request: Any) -> dict[str, str]:
        return {"input": self._build_input(request)}

    async def list_model_ids(self) -> frozenset[str]:
        """Return model ids from Nemoclaw's OpenAI-compatible ``/v1/models`` endpoint."""
        response = await self._client.get("/v1/models", headers=self._request_headers())
        response.raise_for_status()
        return extract_openai_model_ids(
            response.json(),
            provider_name=self._provider_name,
        )

    @staticmethod
    def _extract_response_text(payload: Any) -> str:
        if isinstance(payload, dict):
            for key in ("output", "response", "text"):
                value = payload.get(key)
                if isinstance(value, str):
                    return value
            message = payload.get("message")
            if isinstance(message, str):
                return message
            if isinstance(message, dict):
                text = message.get("text")
                if isinstance(text, str):
                    return text
        return ""

    async def stream_response(
        self,
        request: Any,
        input_tokens: int = 0,
        *,
        request_id: str | None = None,
        thinking_enabled: bool | None = None,
    ) -> AsyncIterator[str]:
        """Return a single-response Nemoclaw chat result as Anthropic SSE."""
        del thinking_enabled
        message_id = f"msg_{uuid.uuid4()}"
        model = getattr(request, "model", "") or ""
        yield _format_sse_event(
            "message_start",
            {
                "type": "message_start",
                "message": {
                    "id": message_id,
                    "type": "message",
                    "role": "assistant",
                    "content": [],
                    "model": model,
                    "stop_reason": None,
                    "stop_sequence": None,
                    "usage": {"input_tokens": input_tokens, "output_tokens": 1},
                },
            },
        )

        req_tag = f" request_id={request_id}" if request_id else ""
        try:
            body = self._build_request_body(request)
            async with self._global_rate_limiter.concurrency_slot():
                response = await self._global_rate_limiter.execute_with_retry(
                    self._client.post,
                    "/v1/chat",
                    json=body,
                    headers=self._request_headers(),
                )
            response.raise_for_status()
            text = self._extract_response_text(response.json()) or " "
            yield _format_sse_event(
                "content_block_start",
                {
                    "type": "content_block_start",
                    "index": 0,
                    "content_block": {"type": "text", "text": ""},
                },
            )
            yield _format_sse_event(
                "content_block_delta",
                {
                    "type": "content_block_delta",
                    "index": 0,
                    "delta": {"type": "text_delta", "text": text},
                },
            )
            yield _format_sse_event(
                "content_block_stop",
                {"type": "content_block_stop", "index": 0},
            )
            yield _format_sse_event(
                "message_delta",
                {
                    "type": "message_delta",
                    "delta": {"stop_reason": "end_turn", "stop_sequence": None},
                    "usage": {"input_tokens": input_tokens, "output_tokens": 1},
                },
            )
            yield _format_sse_event("message_stop", {"type": "message_stop"})
        except Exception as error:
            if not isinstance(error, httpx.HTTPStatusError):
                self._log_stream_transport_error(
                    self._provider_name,
                    req_tag,
                    error,
                    request_id=request_id,
                )
            error_message = _append_request_id(
                _user_error_message(
                    error,
                    provider_name=self._provider_name,
                    read_timeout_s=self._config.http_read_timeout,
                ),
                request_id,
            )
            yield _format_sse_event(
                "content_block_start",
                {
                    "type": "content_block_start",
                    "index": 0,
                    "content_block": {"type": "text", "text": ""},
                },
            )
            yield _format_sse_event(
                "content_block_delta",
                {
                    "type": "content_block_delta",
                    "index": 0,
                    "delta": {"type": "text_delta", "text": error_message},
                },
            )
            yield _format_sse_event(
                "content_block_stop",
                {"type": "content_block_stop", "index": 0},
            )
            yield _format_sse_event(
                "message_delta",
                {
                    "type": "message_delta",
                    "delta": {"stop_reason": "end_turn", "stop_sequence": None},
                    "usage": {"input_tokens": input_tokens, "output_tokens": 1},
                },
            )
            yield _format_sse_event("message_stop", {"type": "message_stop"})


def _extract_text_from_content(content: Any) -> str:
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts: list[str] = []
        for block in content:
            text = _block_attr(block, "text")
            if isinstance(text, str) and text:
                parts.append(text)
        return "".join(parts)
    return ""


def _block_attr(block: Any, attr: str) -> Any:
    if isinstance(block, dict):
        return block.get(attr)
    return getattr(block, attr, None)


def _append_request_id(message: str, request_id: str | None) -> str:
    base = message.strip() or "Provider request failed unexpectedly."
    if request_id:
        return f"{base} (request_id={request_id})"
    return base


def _format_sse_event(event_type: str, data: dict[str, Any]) -> str:
    return f"event: {event_type}\ndata: {json.dumps(data)}\n\n"


def _user_error_message(
    error: Exception, *, provider_name: str, read_timeout_s: float
) -> str:
    if isinstance(error, httpx.ReadTimeout):
        return f"Provider request timed out after {read_timeout_s:g}s."
    if isinstance(error, httpx.ConnectTimeout):
        return "Could not connect to provider."
    if isinstance(error, httpx.HTTPStatusError):
        status = error.response.status_code
        if status == 405:
            return (
                f"Upstream provider {provider_name} rejected the request method "
                "or endpoint (HTTP 405)."
            )
        if status in (502, 503, 504):
            return "Provider is temporarily unavailable. Please retry."
        if status in (401, 403):
            return "Provider authentication failed. Check API key."
        if status == 429:
            return "Provider rate limit reached. Please retry shortly."
        if status == 400:
            return "Invalid request sent to provider."
        return "Provider API request failed."
    message = str(error).strip()
    return message or "Provider request failed unexpectedly."
