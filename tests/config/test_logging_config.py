"""Tests for config/logging_config.py."""

import json
import logging
from pathlib import Path

from loguru import logger

from config.logging_config import (
    HideProbeAccessLog,
    configure_logging,
    install_uvicorn_access_log_filter,
)


def test_configure_logging_creates_parent_directories(tmp_path) -> None:
    """Nested log path: parent directories are created before truncating."""
    log_file = tmp_path / "nested" / "dir" / "app.log"
    configure_logging(str(log_file), force=True)
    assert log_file.is_file()


def test_configure_logging_writes_json_to_file(tmp_path):
    """configure_logging writes JSON lines to the specified file."""
    log_file = str(tmp_path / "test.log")
    configure_logging(log_file, force=True)

    # Emit a log via stdlib (intercepted to loguru)
    logger = logging.getLogger("test.module")
    logger.info("Test message for JSON")

    # Force flush - loguru may buffer
    from loguru import logger as loguru_logger

    loguru_logger.complete()

    content = Path(log_file).read_text(encoding="utf-8")
    lines = [line for line in content.strip().split("\n") if line]
    assert len(lines) >= 1

    # Each line should be valid JSON
    for line in lines:
        record = json.loads(line)
        assert "text" in record or "message" in record or "record" in record


def test_configure_logging_idempotent(tmp_path):
    """configure_logging is idempotent - safe to call twice with force."""
    log_file = str(tmp_path / "test.log")
    configure_logging(log_file, force=True)
    configure_logging(log_file, force=True)  # Should not raise

    logger = logging.getLogger("test.idempotent")
    logger.info("After second configure")


def test_configure_logging_skips_when_already_configured(tmp_path):
    """Without force, second call is a no-op (avoids reconfig on hot reload)."""
    log_file = str(tmp_path / "test.log")
    configure_logging(log_file, force=True)
    # Second call without force - should skip; no exception, log file unchanged
    configure_logging(str(tmp_path / "other.log"), force=False)
    # Logs still go to first file
    logger = logging.getLogger("test.skip")
    logger.info("Still goes to first file")
    from loguru import logger as loguru_logger

    loguru_logger.complete()
    assert (tmp_path / "test.log").exists()
    assert "Still goes to first file" in (tmp_path / "test.log").read_text(
        encoding="utf-8"
    )


def test_telegram_bot_token_redacted_in_message_field(tmp_path) -> None:
    log_file = str(tmp_path / "redact.log")
    configure_logging(log_file, force=True, verbose_third_party=False)
    token = "123456:ABCDEF-ghij-klm"
    logger.info("Calling {}", f"https://api.telegram.org/bot{token}/getMe")
    logger.complete()
    text = Path(log_file).read_text(encoding="utf-8")
    assert token not in text
    assert "bot<redacted>/" in text or "redacted" in text


def test_bearer_substring_redacted_in_log_file(tmp_path) -> None:
    log_file = str(tmp_path / "bearer.log")
    configure_logging(log_file, force=True, verbose_third_party=False)
    secret = "ya29.secret-token-abc"
    logger.info("Request headers: Authorization: Bearer {}", secret)
    logger.complete()
    text = Path(log_file).read_text(encoding="utf-8")
    assert secret not in text
    assert "Bearer" in text


def test_httpx_logger_quieted_when_not_verbose_third_party(tmp_path) -> None:
    log_file = str(tmp_path / "quiet.log")
    configure_logging(log_file, force=True, verbose_third_party=False)
    assert logging.getLogger("httpx").level >= logging.WARNING
    assert logging.getLogger("httpcore").level >= logging.WARNING


def test_httpx_resets_to_notset_when_verbose_third_party(tmp_path) -> None:
    log_file = str(tmp_path / "verbose.log")
    configure_logging(log_file, force=True, verbose_third_party=True)
    assert logging.getLogger("httpx").level == logging.NOTSET


def _access_record(method: str, path: str) -> logging.LogRecord:
    """Build a uvicorn-style access log record for filter inspection."""
    return logging.LogRecord(
        name="uvicorn.access",
        level=logging.INFO,
        pathname=__file__,
        lineno=1,
        msg='%s - "%s %s HTTP/%s" %d',
        args=("127.0.0.1:1234", method, path, "1.1", 200),
        exc_info=None,
    )


def test_hide_probe_access_log_drops_head_root() -> None:
    """HEAD / preflight probes are filtered out."""
    flt = HideProbeAccessLog()
    assert flt.filter(_access_record("HEAD", "/")) is False


def test_hide_probe_access_log_drops_head_health() -> None:
    """HEAD /health probes are filtered out."""
    flt = HideProbeAccessLog()
    assert flt.filter(_access_record("HEAD", "/health")) is False


def test_hide_probe_access_log_drops_head_health_with_trailing_slash() -> None:
    """Trailing slashes on probe paths still match the filter."""
    flt = HideProbeAccessLog()
    assert flt.filter(_access_record("HEAD", "/health/")) is False


def test_hide_probe_access_log_keeps_get_requests() -> None:
    """GET /admin and other real traffic must remain visible."""
    flt = HideProbeAccessLog()
    assert flt.filter(_access_record("GET", "/admin")) is True
    assert flt.filter(_access_record("GET", "/")) is True


def test_hide_probe_access_log_keeps_head_to_other_paths() -> None:
    """HEAD requests to non-probe paths are still logged."""
    flt = HideProbeAccessLog()
    assert flt.filter(_access_record("HEAD", "/v1/messages")) is True


def test_hide_probe_access_log_tolerates_unexpected_args() -> None:
    """Records with non-tuple or short args are kept untouched."""
    flt = HideProbeAccessLog()
    record = logging.LogRecord(
        name="uvicorn.access",
        level=logging.INFO,
        pathname=__file__,
        lineno=1,
        msg="opaque",
        args=None,
        exc_info=None,
    )
    assert flt.filter(record) is True


def test_install_uvicorn_access_log_filter_is_idempotent() -> None:
    """Installing the filter twice does not duplicate it on the uvicorn logger."""
    access_logger = logging.getLogger("uvicorn.access")
    original = [
        f for f in access_logger.filters if not isinstance(f, HideProbeAccessLog)
    ]
    access_logger.filters = list(original)
    try:
        install_uvicorn_access_log_filter()
        install_uvicorn_access_log_filter()
        installed = [
            f for f in access_logger.filters if isinstance(f, HideProbeAccessLog)
        ]
        assert len(installed) == 1
    finally:
        access_logger.filters = list(original)
