"""Tuning Engines provider implementation."""

from typing import Any

from providers.base import ProviderConfig
from providers.openai_compat import OpenAIChatTransport

from .request import build_request_body

TUNING_ENGINES_BASE_URL = "https://api.tuningengines.com/v1"


class TuningEnginesProvider(OpenAIChatTransport):
    """Tuning Engines provider using OpenAI-compatible chat completions."""

    def __init__(self, config: ProviderConfig):
        super().__init__(
            config,
            provider_name="TUNING_ENGINES",
            base_url=config.base_url or TUNING_ENGINES_BASE_URL,
            api_key=config.api_key,
        )

    def _build_request_body(
        self, request: Any, thinking_enabled: bool | None = None
    ) -> dict:
        """Build request body for Tuning Engines."""
        if thinking_enabled is None:
            thinking_enabled = self._is_thinking_enabled(request)
        return build_request_body(
            request,
            thinking_enabled=thinking_enabled,
        )
