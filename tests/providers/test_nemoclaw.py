"""Tests for Nemoclaw provider adapter."""

from unittest.mock import AsyncMock, MagicMock, patch

import httpx
import pytest

from providers.base import ProviderConfig
from providers.nemoclaw import NEMOCLAW_DEFAULT_BASE, NemoclawProvider


class MockMessage:
    def __init__(self, role: str, content):
        self.role = role
        self.content = content


class MockRequest:
    def __init__(self, **kwargs):
        self.model = "nemoclaw/default"
        self.system = "Follow system instructions."
        self.messages = [
            MockMessage("user", "Hello"),
            MockMessage("assistant", [{"type": "text", "text": "Hi there"}]),
            MockMessage("user", [{"type": "text", "text": "How are you?"}]),
        ]
        for key, value in kwargs.items():
            setattr(self, key, value)


@pytest.fixture(autouse=True)
def mock_rate_limiter():
    with patch("providers.nemoclaw.client.GlobalRateLimiter") as mock:
        instance = mock.get_scoped_instance.return_value
        instance.wait_if_blocked = AsyncMock(return_value=False)

        async def _passthrough(fn, *args, **kwargs):
            return await fn(*args, **kwargs)

        instance.execute_with_retry = AsyncMock(side_effect=_passthrough)
        yield instance


def test_default_base_url():
    assert NEMOCLAW_DEFAULT_BASE == "https://api.nemoclaw.com"


def test_init_uses_default_base_url_and_strips_trailing_slash():
    config = ProviderConfig(
        api_key="test-nemoclaw-key",
        base_url=f"{NEMOCLAW_DEFAULT_BASE}/",
    )
    with patch("httpx.AsyncClient"):
        provider = NemoclawProvider(config)

    assert provider._base_url == NEMOCLAW_DEFAULT_BASE


def test_build_request_body_maps_anthropic_messages_to_single_input():
    provider = NemoclawProvider(ProviderConfig(api_key="test-nemoclaw-key"))
    request = MockRequest()

    body = provider._build_request_body(request)

    assert set(body) == {"input"}
    assert body["input"] == (
        "system: Follow system instructions.\n\n"
        "user: Hello\n\n"
        "assistant: Hi there\n\n"
        "user: How are you?"
    )


@pytest.mark.asyncio
async def test_stream_response_wraps_json_output_into_anthropic_sse():
    provider = NemoclawProvider(ProviderConfig(api_key="test-nemoclaw-key"))
    request = MockRequest()
    response = MagicMock()
    response.raise_for_status = MagicMock()
    response.json = MagicMock(return_value={"output": "Nemoclaw says hi"})

    with patch.object(
        provider._client,
        "post",
        new_callable=AsyncMock,
        return_value=response,
    ) as mock_post:
        events = [event async for event in provider.stream_response(request)]

    args, _ = mock_post.call_args
    assert args == ("/v1/chat",)
    kwargs = mock_post.call_args.kwargs
    assert kwargs["json"] == provider._build_request_body(request)
    assert kwargs["headers"]["Authorization"] == "Bearer test-nemoclaw-key"
    blob = "".join(events)
    assert "event: message_start" in blob
    assert "event: content_block_start" in blob
    assert "event: content_block_delta" in blob
    assert '"text": "Nemoclaw says hi"' in blob
    assert "event: message_delta" in blob
    assert blob.rstrip().endswith('event: message_stop\ndata: {"type": "message_stop"}')


@pytest.mark.asyncio
async def test_stream_response_returns_canonical_error_on_http_failure():
    provider = NemoclawProvider(ProviderConfig(api_key="test-nemoclaw-key"))
    request = MockRequest()
    response = MagicMock(status_code=500)
    response.raise_for_status = MagicMock(
        side_effect=httpx.HTTPStatusError(
            "upstream down",
            request=MagicMock(),
            response=response,
        )
    )

    with patch.object(
        provider._client,
        "post",
        new_callable=AsyncMock,
        return_value=response,
    ):
        events = [event async for event in provider.stream_response(request)]

    blob = "".join(events)
    assert "event: message_start" in blob
    assert "event: content_block_delta" in blob
    assert "Provider API request failed" in blob
    assert blob.rstrip().endswith('event: message_stop\ndata: {"type": "message_stop"}')
