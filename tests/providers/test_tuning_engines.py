"""Tests for Tuning Engines provider."""

from contextlib import asynccontextmanager
from unittest.mock import AsyncMock, MagicMock, patch

import pytest

from providers.base import ProviderConfig
from providers.tuning_engines import TUNING_ENGINES_BASE_URL, TuningEnginesProvider


class MockMessage:
    def __init__(self, role, content):
        self.role = role
        self.content = content


class MockRequest:
    def __init__(self, **kwargs):
        self.model = "llama-3.3-70b-fp8"
        self.messages = [MockMessage("user", "Hello")]
        self.max_tokens = 100
        self.temperature = 0.5
        self.top_p = 0.9
        self.system = "System prompt"
        self.stop_sequences = None
        self.tools = []
        self.extra_body = {}
        self.thinking = MagicMock()
        self.thinking.enabled = True
        for key, value in kwargs.items():
            setattr(self, key, value)


@pytest.fixture
def tuning_engines_config():
    return ProviderConfig(
        api_key="test_tuning_engines_key",
        base_url=TUNING_ENGINES_BASE_URL,
        rate_limit=10,
        rate_window=60,
        enable_thinking=True,
    )


@pytest.fixture(autouse=True)
def mock_rate_limiter():
    """Mock the global rate limiter to prevent waiting."""

    @asynccontextmanager
    async def _slot():
        yield

    with patch("providers.openai_compat.GlobalRateLimiter") as mock:
        instance = mock.get_scoped_instance.return_value

        async def _passthrough(fn, *args, **kwargs):
            return await fn(*args, **kwargs)

        instance.execute_with_retry = AsyncMock(side_effect=_passthrough)
        instance.concurrency_slot.side_effect = _slot
        yield instance


@pytest.fixture
def tuning_engines_provider(tuning_engines_config):
    return TuningEnginesProvider(tuning_engines_config)


def test_init(tuning_engines_config):
    """Test provider initialization."""
    with patch("providers.openai_compat.AsyncOpenAI") as mock_openai:
        provider = TuningEnginesProvider(tuning_engines_config)
        assert provider._api_key == "test_tuning_engines_key"
        assert provider._base_url == TUNING_ENGINES_BASE_URL
        mock_openai.assert_called_once()


def test_base_url_constant():
    """TUNING_ENGINES_BASE_URL points to the Tuning Engines inference endpoint."""
    assert TUNING_ENGINES_BASE_URL == "https://api.tuningengines.com/v1"


def test_build_request_body_basic(tuning_engines_provider):
    """Basic request body conversion works for Tuning Engines."""
    req = MockRequest()
    body = tuning_engines_provider._build_request_body(req)

    assert body["model"] == "llama-3.3-70b-fp8"
    assert body["messages"][0]["role"] == "system"


def test_build_request_body_preserves_caller_extra_body(tuning_engines_provider):
    """Caller-provided extra_body should be preserved."""
    req = MockRequest(extra_body={"custom_param": "value"})
    body = tuning_engines_provider._build_request_body(req)

    assert body["extra_body"]["custom_param"] == "value"


@pytest.mark.asyncio
async def test_stream_response_text(tuning_engines_provider):
    """Text content deltas are emitted as text blocks."""
    req = MockRequest()

    mock_chunk = MagicMock()
    mock_chunk.choices = [
        MagicMock(
            delta=MagicMock(
                content="Hello back!",
                reasoning_content=None,
                tool_calls=None,
            ),
            finish_reason="stop",
        )
    ]
    mock_chunk.usage = MagicMock(completion_tokens=5, prompt_tokens=10)

    async def mock_stream():
        yield mock_chunk

    with patch.object(
        tuning_engines_provider._client.chat.completions,
        "create",
        new_callable=AsyncMock,
    ) as mock_create:
        mock_create.return_value = mock_stream()

        events = [event async for event in tuning_engines_provider.stream_response(req)]

        assert any(
            '"text_delta"' in event and "Hello back!" in event for event in events
        )


@pytest.mark.asyncio
async def test_cleanup(tuning_engines_provider):
    """cleanup closes the OpenAI client."""
    tuning_engines_provider._client = AsyncMock()

    await tuning_engines_provider.cleanup()

    tuning_engines_provider._client.close.assert_called_once()
