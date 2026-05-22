# Product E2E Smoke Tests

`smoke/` is local-only. It can launch subprocesses, call real providers, touch
local model servers, and optionally send/delete bot messages. Hermetic contracts
belong under `tests/` and must stay green with plain `uv run pytest`.

## Taxonomy

- `smoke/prereq/`: liveness checks that prove the server, routes, auth, CLI
  scripts, provider pings, local `/models`, and bot permissions are reachable.
  These are prerequisites only.
- `smoke/product/`: end-to-end product scenarios. Feature smoke coverage comes
  from these tests, not from route/header/provider pings.
- `smoke/features.py`: source-of-truth feature map:
  feature -> subfeature -> scenario -> env -> expected behavior -> failure class.

## Required Local Commands

```powershell
uv run pytest smoke --collect-only -q
uv run pytest smoke -n 0 -s --tb=short
```

The second command skips everything unless `FCC_LIVE_SMOKE=1` is set, but still
writes skip entries to `.smoke-results/`.

## Product Smoke Run

```powershell
$env:FCC_LIVE_SMOKE = "1"
uv run pytest smoke -n 0 -s --tb=short
```

Provider product E2E runs once per configured provider, independent of `MODEL`,
`MODEL_OPUS`, `MODEL_SONNET`, and `MODEL_HAIKU`. Defaults come from the provider
catalog/docs and can be overridden with `FCC_SMOKE_MODEL_<PROVIDER>`, for example
`FCC_SMOKE_MODEL_DEEPSEEK=deepseek-v4-pro` (or `deepseek-v4-flash`). If no provider smoke model is
configured, live product smoke fails as `missing_env` unless you explicitly set
`FCC_ALLOW_NO_PROVIDER_SMOKE=1`.

## Targets

Default targets do not send real bot messages or load voice backends:

| Target | Product scenarios | Required environment |
| --- | --- | --- |
| `api` | messages, count_tokens full payload, errors, `/stop`, optimizations | configured provider only for streaming messages |
| `auth` | x-api-key, bearer, anthropic-auth-token, invalid/missing auth | none; test sets an isolated token |
| `cli` | `fcc-init`, server entrypoint, Claude CLI adaptive thinking, session cleanup | Claude CLI binary and provider only for real CLI |
| `clients` | VS Code and JetBrains protocol payloads | configured provider |
| `config` | env precedence, removed-env migration, proxy/timeouts | none |
| `extensibility` | provider registry and platform factory construction | none |
| `messaging` | fake Discord/Telegram full flow, commands, trees, persistence, voice cancel | none |
| `providers` | multi-turn text, adaptive thinking history, tools, disconnect, errors | configured providers, optional `FCC_SMOKE_MODEL_*` |
| `tools` | forced tool_use and tool_result continuation | tool-capable configured provider |
| `rate_limit` | disconnect cleanup and follow-up request | configured provider |
| `lmstudio` | local `/models` plus native `/messages` through proxy | running LM Studio server |
| `llamacpp` | local `/models` plus native `/messages` through proxy | running llama-server |
| `ollama` | local `/api/tags` plus native Anthropic messages through proxy | running Ollama server |

Heavy/side-effectful targets are opt-in:

| Target | Product scenarios | Required environment |
| --- | --- | --- |
| `nvidia_nim_cli` | Claude Code CLI feature matrix across NIM models | `NVIDIA_NIM_API_KEY`, Claude CLI |
| `openrouter_free_cli` | Claude Code CLI feature matrix across OpenRouter free models | `OPENROUTER_API_KEY`, Claude CLI |
| `telegram` | getMe, send, edit, delete, optional manual inbound | token and chat/user ID |
| `discord` | channel access, send, edit, delete, optional manual inbound | token and channel ID |
| `voice` | generated WAV through local Whisper or NVIDIA NIM transcription | `VOICE_NOTE_ENABLED=true`, `FCC_SMOKE_RUN_VOICE=1` |

## Examples

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_PROVIDER_MATRIX = "open_router,nvidia_nim,deepseek,lmstudio,llamacpp,ollama"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "ollama"
$env:OLLAMA_BASE_URL = "http://localhost:11434"
uv run pytest smoke/prereq smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "telegram,discord,voice"
$env:FCC_SMOKE_RUN_VOICE = "1"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "nvidia_nim_cli"
$env:FCC_SMOKE_NIM_MODELS = "z-ai/glm-5.1,moonshotai/kimi-k2.6,minimaxai/minimax-m2.7,nvidia/nemotron-3-super-120b-a12b,deepseek-ai/deepseek-v4-pro,deepseek-ai/deepseek-v4-flash"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "openrouter_free_cli"
$env:FCC_SMOKE_OPENROUTER_FREE_MODELS = "nvidia/nemotron-3-super-120b-a12b:free,openai/gpt-oss-120b:free,minimax/minimax-m2.5:free,inclusionai/ring-2.6-1t:free,poolside/laguna-m.1:free"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "messaging,config,extensibility"
uv run pytest smoke/product -n 0 -s --tb=short
```

## Environment

- `FCC_ENV_FILE`: explicit dotenv path for startup/config scenarios.
- `FCC_LIVE_SMOKE=1`: enables live smoke execution.
- `FCC_ALLOW_NO_PROVIDER_SMOKE=1`: permits no-provider live smoke for harness work.
- `FCC_SMOKE_TARGETS`: comma-separated targets, or `all`.
- `FCC_SMOKE_PROVIDER_MATRIX`: comma-separated provider prefixes to require.
- `FCC_SMOKE_MODEL_NVIDIA_NIM`, `FCC_SMOKE_MODEL_OPEN_ROUTER`,
  `FCC_SMOKE_MODEL_DEEPSEEK`, `FCC_SMOKE_MODEL_LMSTUDIO`,
  `FCC_SMOKE_MODEL_LLAMACPP`, `FCC_SMOKE_MODEL_OLLAMA`: optional per-provider
  smoke model overrides. Values may include the provider prefix or just the model
  name for that provider.
- `FCC_SMOKE_NIM_MODELS`: optional comma-separated NVIDIA NIM CLI matrix models
  that replace the default characterization set.
- `FCC_SMOKE_NIM_EXTRA_MODELS`: optional comma-separated NVIDIA NIM CLI matrix
  models appended to the default or replacement set.
- `FCC_SMOKE_OPENROUTER_FREE_MODELS`: optional comma-separated OpenRouter free
  CLI matrix models that replace the default characterization set.
- `FCC_SMOKE_OPENROUTER_FREE_EXTRA_MODELS`: optional comma-separated OpenRouter
  free CLI matrix models appended to the default or replacement set.
- `FCC_SMOKE_TIMEOUT_S`: per-request/subprocess timeout, default `45`.
- `FCC_SMOKE_CLAUDE_BIN`: Claude CLI executable name, default `claude`.
- `FCC_SMOKE_TELEGRAM_CHAT_ID`: Telegram chat/user ID for send/edit/delete.
- `FCC_SMOKE_DISCORD_CHANNEL_ID`: Discord channel ID for send/edit/delete.
- `FCC_SMOKE_INTERACTIVE=1`: enables manual inbound Telegram/Discord checks.
- `FCC_SMOKE_RUN_VOICE=1`: allows voice transcription backends to load/run.

## Windows / nested `uv run`

Run smoke the same way you run tests (`uv run pytest smoke` from the repo). Child
processes use the **same Python interpreter** as the test runner, not nested
`uv run`, so Windows does not try to replace `free-claude-code.exe` while it is
locked.

## Failure Classes

Smoke artifacts are written to `.smoke-results/` and redact env values whose
names contain `KEY`, `TOKEN`, `SECRET`, `WEBHOOK`, or `AUTH`.

- `missing_env`: required credentials, binary, provider config, local server, or
  opt-in flag is absent.
- `upstream_unavailable`: a real provider, bot API, or local model server is not
  reachable.
- `probe_timeout`: the smoke driver reached the target, but the CLI/probe did
  not complete within the smoke timeout.
- `product_failure`: the app accepted the scenario but returned the wrong shape,
  crashed, leaked state, or violated the product contract.
- `harness_bug`: the smoke test or driver made an invalid assumption.
- `target_disabled`: skipped because `FCC_SMOKE_TARGETS` intentionally selected
  a different target.

````markdown
# Сmoke-тесты продукта (E2E)

`smoke/` — только для локального запуска. Он может порождать подпроцессы, обращаться к реальным провайдерам, подключаться к локальным серверам моделей и опционально отправлять/удалять сообщения ботов. Геметичные контракты должны находиться в `tests/` и оставаться зелёными при обычном запуске `uv run pytest`.

## Таксономия

- `smoke/prereq/`: проверки живости (liveness), которые подтверждают доступность сервера, маршрутов, авторизации, CLI-скриптов, пингов провайдеров, локального `/models` и прав бота. Это только предпосылки.
- `smoke/product/`: сценарии end-to-end продукта. Покрытие фич делается этими тестами, а не путингами маршрутов/заголовков/провайдеров.
- `smoke/features.py`: единственный источник правды для карты фич: feature -> subfeature -> scenario -> env -> ожидаемое поведение -> класс ошибки.

## Необходимые локальные команды

```powershell
uv run pytest smoke --collect-only -q
uv run pytest smoke -n 0 -s --tb=short
```

Вторая команда пропускает всё, если не установлена `FCC_LIVE_SMOKE=1`, но всё равно записывает skip-записи в `.smoke-results/`.

## Запуск продуктового smoke

```powershell
$env:FCC_LIVE_SMOKE = "1"
uv run pytest smoke -n 0 -s --tb=short
```

E2E-прогоны продукта выполняются один раз для каждого сконфигурированного провайдера, независимо от `MODEL`, `MODEL_OPUS`, `MODEL_SONNET` и `MODEL_HAIKU`. Значения по умолчанию берутся из каталога/доков провайдеров и могут быть переопределены с помощью `FCC_SMOKE_MODEL_<PROVIDER>`, например `FCC_SMOKE_MODEL_DEEPSEEK=deepseek-v4-pro` (или `deepseek-v4-flash`). Если модель для smoke не настроена, live product smoke помечается как `missing_env`, если вы явно не установите `FCC_ALLOW_NO_PROVIDER_SMOKE=1`.

## Цели (Targets)

По умолчанию цели не отправляют реальные сообщения ботов и не загружают голосовые бэкенды:

| Target | Product scenarios | Required environment |
| --- | --- | --- |
| `api` | messages, count_tokens full payload, errors, `/stop`, optimizations | сконфигурированный провайдер (только для потоковых сообщений) |
| `auth` | x-api-key, bearer, anthropic-auth-token, invalid/missing auth | нет; тест создаёт изолированный токен |
| `cli` | `fcc-init`, точка входа сервера, адаптивное мышление Claude CLI, очистка сессий | бинарь Claude CLI и провайдер (только для реального CLI) |
| `clients` | полезные нагрузки протоколов VS Code и JetBrains | сконфигурированный провайдер |
| `config` | приоритет env, миграция удалённых переменных, прокси/таймауты | нет |
| `extensibility` | реестр провайдеров и фабрика платформ | нет |
| `messaging` | фейковый полный поток Discord/Telegram, команды, деревья, персистентность, отмена голоса | нет |
| `providers` | мультиходовый текст, история адаптивного мышления, инструменты, отключения, ошибки | сконфигурированные провайдеры, опционально `FCC_SMOKE_MODEL_*` |
| `tools` | принудительное использование инструментов и продолжение с результатом инструмента | провайдер с поддержкой инструментов |
| `rate_limit` | очистка при отключении и последующий запрос | сконфигурированный провайдер |
| `lmstudio` | локальный `/models` плюс нативный `/messages` через прокси | запущенный сервер LM Studio |
| `llamacpp` | локальный `/models` плюс нативный `/messages` через прокси | запущенный `llama-server` |
| `ollama` | локальный `/api/tags` плюс нативные Anthropic сообщения через прокси | запущенный сервер Ollama |

Тяжёлые/побочные цели — по явному согласию:

| Target | Product scenarios | Required environment |
| --- | --- | --- |
| `nvidia_nim_cli` | матрица фич Claude Code CLI по моделям NIM | `NVIDIA_NIM_API_KEY`, Claude CLI |
| `openrouter_free_cli` | матрица фич Claude Code CLI по бесплатным моделям OpenRouter | `OPENROUTER_API_KEY`, Claude CLI |
| `telegram` | getMe, send, edit, delete, опциональный ручной inbound | токен и chat/user ID |
| `discord` | доступ к каналу, send, edit, delete, опциональный ручной inbound | токен и channel ID |
| `voice` | сгенерированный WAV через локальный Whisper или транскрипция NVIDIA NIM | `VOICE_NOTE_ENABLED=true`, `FCC_SMOKE_RUN_VOICE=1` |

## Примеры

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_PROVIDER_MATRIX = "open_router,nvidia_nim,deepseek,lmstudio,llamacpp,ollama"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "ollama"
$env:OLLAMA_BASE_URL = "http://localhost:11434"
uv run pytest smoke/prereq smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "telegram,discord,voice"
$env:FCC_SMOKE_RUN_VOICE = "1"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "nvidia_nim_cli"
$env:FCC_SMOKE_NIM_MODELS = "z-ai/glm-5.1,moonshotai/kimi-k2.6,minimaxai/minimax-m2.7,nvidia/nemotron-3-super-120b-a12b,deepseek-ai/deepseek-v4-pro,deepseek-ai/deepseek-v4-flash"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "openrouter_free_cli"
$env:FCC_SMOKE_OPENROUTER_FREE_MODELS = "nvidia/nemotron-3-super-120b-a12b:free,openai/gpt-oss-120b:free,minimax/minimax-m2.5:free,inclusionai/ring-2.6-1t:free,poolside/laguna-m.1:free"
uv run pytest smoke/product -n 0 -s --tb=short
```

```powershell
$env:FCC_LIVE_SMOKE = "1"
$env:FCC_SMOKE_TARGETS = "messaging,config,extensibility"
uv run pytest smoke/product -n 0 -s --tb=short
```

## Окружение

- `FCC_ENV_FILE`: явный путь к dotenv для сценариев старта/конфигурации.
- `FCC_LIVE_SMOKE=1`: включает выполнение live smoke.
- `FCC_ALLOW_NO_PROVIDER_SMOKE=1`: разрешает выполнение без провайдера для работы с harness.
- `FCC_SMOKE_TARGETS`: через запятую цели, или `all`.
- `FCC_SMOKE_PROVIDER_MATRIX`: через запятую префиксы провайдеров, которые требуются.
- `FCC_SMOKE_MODEL_NVIDIA_NIM`, `FCC_SMOKE_MODEL_OPEN_ROUTER`,
  `FCC_SMOKE_MODEL_DEEPSEEK`, `FCC_SMOKE_MODEL_LMSTUDIO`,
  `FCC_SMOKE_MODEL_LLAMACPP`, `FCC_SMOKE_MODEL_OLLAMA`: опциональные переопределения модели для каждого провайдера. Значения могут включать префикс провайдера или только имя модели.
- `FCC_SMOKE_NIM_MODELS`: опциональный перечень моделей NVIDIA NIM для CLI-матрицы (через запятую), заменяющий набор по умолчанию.
- `FCC_SMOKE_NIM_EXTRA_MODELS`: опциональный перечень дополнительных моделей NVIDIA NIM, добавляемых к набору по умолчанию или замене.
- `FCC_SMOKE_OPENROUTER_FREE_MODELS`: опциональный перечень бесплатных моделей OpenRouter для CLI-матрицы, заменяющий набор по умолчанию.
- `FCC_SMOKE_OPENROUTER_FREE_EXTRA_MODELS`: опциональный перечень дополнительных бесплатных моделей OpenRouter, добавляемых к набору по умолчанию или замене.
- `FCC_SMOKE_TIMEOUT_S`: таймаут на запрос/подпроцесс, по умолчанию `45`.
- `FCC_SMOKE_CLAUDE_BIN`: имя исполняемого файла Claude CLI, по умолчанию `claude`.
- `FCC_SMOKE_TELEGRAM_CHAT_ID`: Telegram chat/user ID для send/edit/delete.
- `FCC_SMOKE_DISCORD_CHANNEL_ID`: Discord channel ID для send/edit/delete.
- `FCC_SMOKE_INTERACTIVE=1`: включает ручные inbound-проверки Telegram/Discord.
- `FCC_SMOKE_RUN_VOICE=1`: позволяет загружать/запускать голосовые бэкенды.

## Windows / вложенный `uv run`

Запускайте smoke так же, как и тесты (`uv run pytest smoke` из репозитория). Дочерние процессы используют **тот же интерпретатор Python**, что и тестовый раннер, а не вложенный `uv run`, поэтому Windows не попытается заменить `free-claude-code.exe`, пока тот заблокирован.

## Классы ошибок

Артефакты smoke сохраняются в `.smoke-results/` и редактируют (redact) значения env, чьи имена содержат `KEY`, `TOKEN`, `SECRET`, `WEBHOOK` или `AUTH`.

- `missing_env`: отсутствуют требуемые креденшелы, бинарь, конфиг провайдера, локальный сервер или опция включения.
- `upstream_unavailable`: недоступен реальный провайдер, API бота или локальный сервер модели.
- `probe_timeout`: драйвер smoke достиг цели, но CLI/проб не завершился в пределах таймаута.
- `product_failure`: приложение приняло сценарий, но вернуло неверную форму, упало, протекло состояние или нарушило контракт продукта.
- `harness_bug`: тест smoke или драйвер сделали неверное предположение.
- `target_disabled`: пропущено, потому что `FCC_SMOKE_TARGETS` целенаправленно выбрал другую цель.

`product_failure` и `harness_bug` считаются ошибками. `missing_env`, `upstream_unavailable` и `probe_timeout` считаются пропусками, за исключением случаев, когда пользователь явно указал провайдера в `FCC_SMOKE_PROVIDER_MATRIX`; в этом случае выбранные, но отсутствующие провайдеры приводят к ошибке.

````
