"""
Claude Code Proxy - Entry Point

Minimal entry point that builds the ASGI app via :func:`api.app.create_app`.
Run with: uv run uvicorn server:app --host 0.0.0.0 --port 8082 --timeout-graceful-shutdown 5
"""

from api.app import create_app, create_asgi_app

app = create_asgi_app()

__all__ = ["app", "create_app"]

if __name__ == "__main__":
    import uvicorn

    from cli.process_registry import kill_all_best_effort
    from config.logging_config import install_uvicorn_access_log_filter
    from config.settings import get_settings

    settings = get_settings()
    try:
        # Hide noisy HEAD / and HEAD /health liveness probes while keeping the
        # rest of uvicorn's access log visible on stdout.
        install_uvicorn_access_log_filter()
        # timeout_graceful_shutdown ensures uvicorn doesn't hang on task cleanup.
        uvicorn.run(
            app,
            host=settings.host,
            port=settings.port,
            log_level="debug",
            access_log=True,
            timeout_graceful_shutdown=5,
        )
    finally:
        # Safety net: cleanup subprocesses if lifespan shutdown doesn't fully run.
        kill_all_best_effort()
