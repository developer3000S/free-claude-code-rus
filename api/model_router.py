"""Model routing for Claude-compatible requests."""

from __future__ import annotations

from dataclasses import dataclass

from loguru import logger

from config.provider_ids import SUPPORTED_PROVIDER_IDS
from config.settings import Settings

from .gateway_model_ids import decode_gateway_model_id
from .models.anthropic import MessagesRequest, TokenCountRequest


@dataclass(frozen=True, slots=True)
class ResolvedModel:
    original_model: str
    provider_id: str
    provider_model: str
    provider_model_ref: str
    thinking_enabled: bool


@dataclass(frozen=True, slots=True)
class RoutedMessagesRequest:
    request: MessagesRequest
    resolved: ResolvedModel


@dataclass(frozen=True, slots=True)
class RoutedTokenCountRequest:
    request: TokenCountRequest
    resolved: ResolvedModel


@dataclass(frozen=True, slots=True)
class RoutedMessagesRequestChain:
    """Ordered list of routed candidates to try in fallback order."""

    candidates: tuple[RoutedMessagesRequest, ...]

    @property
    def primary(self) -> RoutedMessagesRequest:
        return self.candidates[0]


class ModelRouter:
    """Resolve incoming Claude model names to configured provider/model pairs."""

    def __init__(self, settings: Settings):
        self._settings = settings

    def resolve(self, claude_model_name: str) -> ResolvedModel:
        chain = self.resolve_chain(claude_model_name)
        return chain[0]

    def resolve_chain(self, claude_model_name: str) -> tuple[ResolvedModel, ...]:
        """Resolve a Claude model name to an ordered chain of fallback candidates.

        Direct provider model ids (``provider/model`` or ``anthropic/provider/model``)
        always resolve to a single-entry chain. MODEL_OPUS/SONNET/HAIKU expand into
        the full comma-separated fallback list configured in settings.
        """
        (
            direct_provider_id,
            direct_provider_model,
            force_thinking_enabled,
        ) = self._direct_provider_model(claude_model_name)
        if direct_provider_id is not None and direct_provider_model is not None:
            thinking_enabled = (
                force_thinking_enabled
                if force_thinking_enabled is not None
                else self._settings.resolve_thinking(direct_provider_model)
            )
            return (
                ResolvedModel(
                    original_model=claude_model_name,
                    provider_id=direct_provider_id,
                    provider_model=direct_provider_model,
                    provider_model_ref=claude_model_name,
                    thinking_enabled=thinking_enabled,
                ),
            )

        thinking_enabled = self._settings.resolve_thinking(claude_model_name)
        chain_refs = self._settings.resolve_model_chain(claude_model_name)
        if not chain_refs:
            chain_refs = (self._settings.model,)

        resolved_chain: list[ResolvedModel] = []
        for provider_model_ref in chain_refs:
            provider_id = Settings.parse_provider_type(provider_model_ref)
            provider_model = Settings.parse_model_name(provider_model_ref)
            resolved_chain.append(
                ResolvedModel(
                    original_model=claude_model_name,
                    provider_id=provider_id,
                    provider_model=provider_model,
                    provider_model_ref=provider_model_ref,
                    thinking_enabled=thinking_enabled,
                )
            )
        if len(resolved_chain) > 1:
            logger.debug(
                "MODEL CHAIN: '{}' -> {}",
                claude_model_name,
                [c.provider_model_ref for c in resolved_chain],
            )
        elif resolved_chain[0].provider_model != claude_model_name:
            logger.debug(
                "MODEL MAPPING: '{}' -> '{}'",
                claude_model_name,
                resolved_chain[0].provider_model,
            )
        return tuple(resolved_chain)

    def _direct_provider_model(
        self, model_name: str
    ) -> tuple[str | None, str | None, bool | None]:
        decoded = decode_gateway_model_id(model_name)
        if decoded is not None:
            if decoded.provider_id not in SUPPORTED_PROVIDER_IDS:
                return None, None, None
            return (
                decoded.provider_id,
                decoded.provider_model,
                decoded.force_thinking_enabled,
            )

        provider_id, separator, provider_model = model_name.partition("/")
        if not separator:
            return None, None, None
        if provider_id not in SUPPORTED_PROVIDER_IDS:
            return None, None, None
        if not provider_model:
            return None, None, None
        return provider_id, provider_model, None

    def resolve_messages_request(
        self, request: MessagesRequest
    ) -> RoutedMessagesRequest:
        """Return an internal routed request context (first candidate only)."""
        return self.resolve_messages_request_chain(request).primary

    def resolve_messages_request_chain(
        self, request: MessagesRequest
    ) -> RoutedMessagesRequestChain:
        """Return the ordered fallback chain of routed request contexts."""
        chain = self.resolve_chain(request.model)
        candidates: list[RoutedMessagesRequest] = []
        for resolved in chain:
            routed = request.model_copy(deep=True)
            routed.model = resolved.provider_model
            candidates.append(RoutedMessagesRequest(request=routed, resolved=resolved))
        return RoutedMessagesRequestChain(candidates=tuple(candidates))

    def resolve_token_count_request(
        self, request: TokenCountRequest
    ) -> RoutedTokenCountRequest:
        """Return an internal token-count request context."""
        resolved = self.resolve(request.model)
        routed = request.model_copy(
            update={"model": resolved.provider_model}, deep=True
        )
        return RoutedTokenCountRequest(request=routed, resolved=resolved)
