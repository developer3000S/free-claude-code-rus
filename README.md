<div align="center">

# 🤖 Free Claude Code

Use Claude Code CLI, VS Code, JetBrains ACP, or chat bots through your own Anthropic-compatible proxy.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Python 3.14](https://img.shields.io/badge/python-3.14-3776ab.svg?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/downloads/)
[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json&style=for-the-badge)](https://github.com/astral-sh/uv)
[![Tested with Pytest](https://img.shields.io/badge/testing-Pytest-00c0ff.svg?style=for-the-badge)](https://github.com/Developer3000S/free-claude-code-rus/actions/workflows/tests.yml)
[![Type checking: Ty](https://img.shields.io/badge/type%20checking-ty-ffcc00.svg?style=for-the-badge)](https://pypi.org/project/ty/)
[![Code style: Ruff](https://img.shields.io/badge/code%20formatting-ruff-f5a623.svg?style=for-the-badge)](https://github.com/astral-sh/ruff)
[![Logging: Loguru](https://img.shields.io/badge/logging-loguru-4ecdc4.svg?style=for-the-badge)](https://github.com/Delgan/loguru)

Free Claude Code routes Anthropic Messages API traffic from Claude Code to any provider. It keeps Claude Code's client-side protocol stable while letting you choose free, paid, or local models.

[Quick Start](#quick-start) · [Providers](#choose-a-provider) · [Clients](#connect-claude-code) · [Integrations](#optional-integrations) · [Development](#development)

</div>

<div align="center">
  <img src="assets/pic.png" alt="Free Claude Code in action" width="700">
</div>

## Star History

<div align="center">
  <a href="https://star-history.com/#Developer3000S/free-claude-code-rus&Date">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date&theme=dark">
      <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date">
      <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date" width="700">
    </picture>
  </a>
</div>

## What You Get

- Drop-in proxy for Claude Code's Anthropic API calls.
- Eleven provider backends: NVIDIA NIM, Kimi, Wafer, OpenRouter, DeepSeek, LM Studio, llama.cpp, Ollama, OpenCode Zen, OpenCode Go, and Z.ai.
- Per-model routing: send Opus, Sonnet, Haiku, and fallback traffic to different providers.
- Native Claude Code `/model` picker support through the proxy's `/v1/models` endpoint (Claude Code must opt in to Gateway model discovery; see [Model Picker](#model-picker)).
- Streaming, tool use, reasoning/thinking block handling, and local request optimizations.
- Optional Discord or Telegram bot wrapper for remote coding sessions.
- Optional Usage through the VSCode extension.
- Optional voice-note transcription through local Whisper or NVIDIA NIM.
- Local **Admin UI** at `/admin` to edit supported proxy settings, validate changes, and check providers (loopback access only).

## Quick Start

### 1. Install the latest version of [Claude Code](https://code.claude.com/docs/en/overview)

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Install Runtime Requirements

Install the latest version of [uv](https://docs.astral.sh/uv/getting-started/installation/) (0.9+) and Python 3.14.0 stable.

macOS/Linux:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv python install 3.14.0
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
uv self update
uv python install 3.14.0
```

If you previously installed 3.14 with an older uv and see alpha-only behavior (e.g. `except TypeError, ValueError` fails), run `uv self update` then `uv python install 3.14.0 --reinstall` and recreate the venv with `uv sync`.

### 3. Install The Proxy

```bash
uv tool install --force git+https://github.com/Developer3000S/free-claude-code-rus.git
```

Use the same command to update to the latest version.

### 4. Start The Proxy

```bash
fcc-server
```

After startup, Uvicorn prints the proxy bind address and the app logs the admin URL:

```text
INFO:     Admin UI: http://127.0.0.1:8082/admin (local-only)
```

Many terminals make these clickable. Use your configured `PORT` if it is not `8082`.

### 5. Open The Admin UI And Configure NVIDIA NIM

Open the **Admin UI** URL from the terminal output.

Need an NVIDIA NIM API key? Use the **[NVIDIA NIM provider](#nvidia-nim-provider)** section below, then scroll back up here.

<div align="center">
  <img src="assets/admin-page.png" alt="Local admin UI for proxy settings" width="700">
</div>

Paste your NVIDIA NIM API key into `NVIDIA_NIM_API_KEY`, then click **Validate** and **Apply**.

The default model is already set to `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`. You can change it later from the same Admin UI.

### 6. Run Claude Code

```bash
fcc-claude
```

`fcc-claude` reads the current configured port and auth token each time it starts, sets the Claude Code environment variables (including a 190k-token `CLAUDE_CODE_AUTO_COMPACT_WINDOW` for auto-compaction), and then launches the real `claude` command.

## Choose A Provider

Pick one provider, enter its key or local URL in the Admin UI, and set `MODEL` to a provider-prefixed model slug. `MODEL` is the fallback. `MODEL_OPUS`, `MODEL_SONNET`, and `MODEL_HAIKU` can override routing for Claude Code's model tiers.

<a id="nvidia-nim-provider"></a>

### 1. [NVIDIA NIM](https://build.nvidia.com/)

Get a key at [build.nvidia.com/settings/api-keys](https://build.nvidia.com/settings/api-keys).

In the Admin UI, paste it into `NVIDIA_NIM_API_KEY`. The default `MODEL` is `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`.

Popular examples:

- `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`
- `nvidia_nim/z-ai/glm5.1`
- `nvidia_nim/moonshotai/kimi-k2.5`
- `nvidia_nim/minimaxai/minimax-m2.5`

Browse models at [build.nvidia.com](https://build.nvidia.com/explore/discover).

### 2. [Kimi](https://platform.moonshot.ai/)

Get a key at [platform.moonshot.ai/console/api-keys](https://platform.moonshot.ai/console/api-keys).

In the Admin UI, paste it into `KIMI_API_KEY`, then set `MODEL` to a Kimi slug such as `kimi/kimi-k2.5`.

Browse models at [platform.moonshot.ai](https://platform.moonshot.ai).

### 3. [Wafer](https://wafer.ai/)

Get a key from [wafer.ai](https://wafer.ai). In the Admin UI, paste it into `WAFER_API_KEY`, then set `MODEL` to a Wafer Pass model such as `wafer/DeepSeek-V4-Pro`.

Popular examples:

- `wafer/DeepSeek-V4-Pro`
- `wafer/MiniMax-M2.7`
- `wafer/Qwen3.5-397B-A17B`
- `wafer/GLM-5.1`

This provider uses Wafer's Anthropic-compatible endpoint at `https://pass.wafer.ai/v1/messages`.

### 4. [OpenRouter](https://openrouter.ai/)

Get a key at [openrouter.ai/keys](https://openrouter.ai/keys).

In the Admin UI, paste it into `OPENROUTER_API_KEY`, then set `MODEL` to an OpenRouter slug such as `open_router/stepfun/step-3.5-flash:free`.
````markdown
<div align="center">

# 🤖 Free Claude Code

Используйте Claude Code CLI, VS Code, JetBrains ACP или чат-боты через собственный прокси, совместимый с Anthropic.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Python 3.14](https://img.shields.io/badge/python-3.14-3776ab.svg?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/downloads/)
[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json&style=for-the-badge)](https://github.com/astral-sh/uv)
[![Tested with Pytest](https://img.shields.io/badge/testing-Pytest-00c0ff.svg?style=for-the-badge)](https://github.com/Developer3000S/free-claude-code-rus/actions/workflows/tests.yml)
[![Type checking: Ty](https://img.shields.io/badge/type%20checking-ty-ffcc00.svg?style=for-the-badge)](https://pypi.org/project/ty/)
[![Code style: Ruff](https://img.shields.io/badge/code%20formatting-ruff-f5a623.svg?style=for-the-badge)](https://github.com/astral-sh/ruff)
[![Logging: Loguru](https://img.shields.io/badge/logging-loguru-4ecdc4.svg?style=for-the-badge)](https://github.com/Delgan/loguru)

Free Claude Code перенаправляет трафик Anthropic Messages API от Claude Code к любому провайдеру. Он сохраняет стабильный клиентский протокол Claude Code и позволяет вам выбирать бесплатные, платные или локальные модели.

[Quick Start](#quick-start) · [Providers](#choose-a-provider) · [Clients](#connect-claude-code) · [Integrations](#optional-integrations) · [Development](#development)

</div>

<div align="center">
  <img src="assets/pic.png" alt="Free Claude Code in action" width="700">
</div>

## История звёзд

<div align="center">
  <a href="https://star-history.com/#Developer3000S/free-claude-code-rus&Date">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date&theme=dark">
      <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date">
      <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=Developer3000S/free-claude-code-rus&type=Date" width="700">
    </picture>
  </a>
</div>

## Что вы получаете

- Прокси-подстановщик для вызовов Anthropic API от Claude Code.
- Одиннадцать бэкендов-провайдеров: NVIDIA NIM, Kimi, Wafer, OpenRouter, DeepSeek, LM Studio, llama.cpp, Ollama, OpenCode Zen, OpenCode Go и Z.ai.
- Маршрутизация по моделям: направляйте трафик Opus, Sonnet, Haiku и резервный трафик к разным провайдерам.
- Поддержка встроенного селектора моделей Claude Code через эндпоинт прокси `/v1/models` (Claude Code должен включить обнаружение моделей Gateway; см. [Model Picker](#model-picker)).
- Потоковая передача, использование инструментов, обработка блоков рассуждений/мышления и локальные оптимизации запросов.
- Дополнительная обёртка-бот для удалённых сессий кодирования в Discord или Telegram.
- Возможность использования через расширение VSCode.
- Опциональная транскрипция голосовых заметок через локальный Whisper или NVIDIA NIM.
- Локальный **Admin UI** по адресу `/admin` для редактирования настроек прокси, проверки изменений и проверки провайдеров (только loopback-доступ).

## Быстрый старт

### 1. Установите последнюю версию [Claude Code](https://code.claude.com/docs/en/overview)

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Установите зависимости времени выполнения

Установите последнюю версию [uv](https://docs.astral.sh/uv/getting-started/installation/) (0.9+) и Python 3.14.0 stable.

macOS/Linux:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv python install 3.14.0
```

Windows PowerShell:

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
uv self update
uv python install 3.14.0
```

Если вы ранее устанавливали 3.14 с более старой версией `uv` и наблюдаете поведение альфа-версии (например, `except TypeError, ValueError` не работает), выполните `uv self update`, затем `uv python install 3.14.0 --reinstall` и пересоздайте виртуальное окружение с `uv sync`.

### 3. Установите прокси

```bash
uv tool install --force git+https://github.com/Developer3000S/free-claude-code-rus.git
```

Той же командой можно обновить до последней версии.

### 4. Запустите прокси

```bash
fcc-server
```

После старта Uvicorn выводит адрес привязки прокси, а приложение логирует URL админки:

```text
INFO:     Admin UI: http://127.0.0.1:8082/admin (local-only)
```

Во многих терминалах эти ссылки кликабельны. Используйте настроенный `PORT`, если он не `8082`.

### 5. Откройте Admin UI и настройте NVIDIA NIM

Откройте URL **Admin UI**, который показал терминал.

Нужен ключ NVIDIA NIM? Смотрите раздел **[NVIDIA NIM provider](#nvidia-nim-provider)** ниже, затем вернитесь вверх.

<div align="center">
  <img src="assets/admin-page.png" alt="Local admin UI for proxy settings" width="700">
</div>

Вставьте ваш ключ NVIDIA NIM в поле `NVIDIA_NIM_API_KEY`, затем нажмите **Validate** и **Apply**.

По умолчанию модель установлена в `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`. Вы можете изменить её позже в Admin UI.

### 6. Запустите Claude Code

```bash
fcc-claude
```

`fcc-claude` при запуске читает текущий конфиг порта и токен авторизации, устанавливает переменные окружения для Claude Code (включая 190k-токенный `CLAUDE_CODE_AUTO_COMPACT_WINDOW` для авто-компакции) и затем запускает реальную команду `claude`.

## Выбор провайдера

Выберите провайдера, вставьте его ключ или локальный URL в Admin UI и установите `MODEL` в префиксированный модел-слиг провайдера. `MODEL` используется как запасной. `MODEL_OPUS`, `MODEL_SONNET` и `MODEL_HAIKU` могут переопределять маршрутизацию для уровней моделей Claude Code.

<a id="nvidia-nim-provider"></a>

### 1. [NVIDIA NIM](https://build.nvidia.com/)

Получите ключ на [build.nvidia.com/settings/api-keys](https://build.nvidia.com/settings/api-keys).

В Admin UI вставьте ключ в `NVIDIA_NIM_API_KEY`. По умолчанию `MODEL` — `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`.

Популярные примеры:

- `nvidia_nim/nvidia/nemotron-3-super-120b-a12b`
- `nvidia_nim/z-ai/glm5.1`
- `nvidia_nim/moonshotai/kimi-k2.5`
- `nvidia_nim/minimaxai/minimax-m2.5`

Просматривайте модели на [build.nvidia.com](https://build.nvidia.com/explore/discover).

### 2. [Kimi](https://platform.moonshot.ai/)

Получите ключ на [platform.moonshot.ai/console/api-keys](https://platform.moonshot.ai/console/api-keys).

В Admin UI вставьте ключ в `KIMI_API_KEY`, затем установите `MODEL`, например `kimi/kimi-k2.5`.

Просматривайте модели на [platform.moonshot.ai](https://platform.moonshot.ai).

### 3. [Wafer](https://wafer.ai/)

Получите ключ на [wafer.ai](https://wafer.ai). В Admin UI вставьте его в `WAFER_API_KEY`, затем установите `MODEL`, например `wafer/DeepSeek-V4-Pro`.

Популярные примеры:

- `wafer/DeepSeek-V4-Pro`
- `wafer/MiniMax-M2.7`
- `wafer/Qwen3.5-397B-A17B`
- `wafer/GLM-5.1`

Этот провайдер использует Anthropic-совместимый эндпоинт Wafer: `https://pass.wafer.ai/v1/messages`.

### 4. [OpenRouter](https://openrouter.ai/)

Получите ключ на [openrouter.ai/keys](https://openrouter.ai/keys).

В Admin UI вставьте ключ в `OPENROUTER_API_KEY`, затем установите `MODEL`, например `open_router/stepfun/step-3.5-flash:free`.

Просматривайте [все модели](https://openrouter.ai/models) или [бесплатные модели](https://openrouter.ai/collections/free-models).

### 5. [DeepSeek](https://platform.deepseek.com/)

Получите ключ на [platform.deepseek.com/api_keys](https://platform.deepseek.com/api_keys).

В Admin UI вставьте ключ в `DEEPSEEK_API_KEY`, затем установите `MODEL`, например `deepseek/deepseek-chat`.

Этот провайдер использует Anthropic-совместимый эндпоинт DeepSeek, а не OpenAI chat-completions.

### 6. [LM Studio](https://lmstudio.ai/)

Запустите локальный сервер LM Studio и загрузите модель. В Admin UI укажите `LM_STUDIO_BASE_URL`, затем установите `MODEL`, предварив идентификатор модели префиксом `lmstudio/`.

Предпочитайте модели с поддержкой использования инструментов для рабочих процессов Claude Code.

### 7. [llama.cpp](https://github.com/ggml-org/llama.cpp)

Запустите `llama-server` с Anthropic-совместимым `/v1/messages` эндпоинтом и достаточным объёмом контекста для запросов Claude Code.

В Admin UI укажите `LLAMACPP_BASE_URL`, затем установите `MODEL` с префиксом `llamacpp/`.

Для локальных моделей для кодирования размер контекста важен. Если llama.cpp возвращает HTTP 400 для обычных запросов Claude Code, увеличьте `--ctx-size` и убедитесь, что сборка сервера/модели поддерживает необходимые функции.

### 8. [Ollama](https://ollama.com/)

Запустите Ollama и скачайте модель:

```bash
ollama pull llama3.1
ollama serve
```

В Admin UI укажите `OLLAMA_BASE_URL`, затем установите `MODEL` в соответствии с тегом из `ollama list`, предварив `ollama/`.

`OLLAMA_BASE_URL` — это корень сервера Ollama; не добавляйте `/v1`. Примеры моделей: `ollama/llama3.1`, `ollama/llama3.1:8b`.

### 9. [OpenCode Zen](https://opencode.ai/)

Получите API-ключ на [opencode.ai/auth](https://opencode.ai/auth).

В Admin UI вставьте ключ в `OPENCODE_API_KEY`, затем установите `MODEL`, например `opencode/gpt-5.3-codex`. Тот же ключ используется и для **OpenCode Go** (см. ниже); используйте префикс `opencode_go/` для Go.

OpenCode Zen — это курируемый шлюз моделей, дающий доступ к моделям Anthropic, OpenAI, Google, DeepSeek и другим через единый API-ключ и OpenAI-совместимый эндпоинт `https://opencode.ai/zen/v1`.

Популярные примеры:

- `opencode/gpt-5.3-codex`
- `opencode/claude-sonnet-4`
- `opencode/deepseek-v4-flash-free` (бесплатно)
- `opencode/gemini-3-flash`
- `opencode/big-pickle` (бесплатно)
- `opencode/glm-5.1`

Просматривайте доступные модели на [opencode.ai](https://opencode.ai).

### 10. [OpenCode Go](https://opencode.ai/)

Получите API-ключ на [opencode.ai/auth](https://opencode.ai/auth) (тот же, что и для OpenCode Zen).

В Admin UI используйте `OPENCODE_API_KEY`, затем установите `MODEL`, например `opencode_go/minimax-m2.7`.

OpenCode Go — это подписной шлюз с собственной подборкой моделей и OpenAI-совместимым эндпоинтом `https://opencode.ai/zen/go/v1`. Он использует тот же API-ключ, что и Zen; отличаются только префикс слига (`opencode_go/` vs `opencode/`) и путь к апстриму.

Популярные примеры:

- `opencode_go/minimax-m2.7`

Просматривайте доступные модели на [opencode.ai](https://opencode.ai).

### 11. [Z.ai](https://z.ai/)

Получите API-ключ на [Z.ai/manage-apikey/apikey-list](https://z.ai/manage-apikey/apikey-list).

В Admin UI вставьте ключ в `ZAI_API_KEY`, затем установите `MODEL`, например `zai/glm-5.1`.

Z.ai предоставляет модели GLM через OpenAI-совместимый Coding Plan эндпоинт `https://api.z.ai/api/coding/paas/v4`.

Популярные примеры:

- `zai/glm-5.1`
- `zai/glm-5-turbo`

Просматривайте модели на [Z.ai](https://z.ai).

### 12. Смешивание провайдеров по уровням моделей

Каждый уровень модели может использовать отдельного провайдера, задав `MODEL_OPUS`, `MODEL_SONNET` и `MODEL_HAIKU` в Admin UI. Оставьте поле пустым, чтобы унаследовать `MODEL`.

Например, можно направлять Opus к `nvidia_nim/moonshotai/kimi-k2.5`, Sonnet к `open_router/deepseek/deepseek-r1-0528:free`, Haiku к `lmstudio/unsloth/GLM-4.7-Flash-GGUF`, а резервную `MODEL` оставить как `zai/glm-5.1`.

## Подключение Claude Code

### 1. Claude Code CLI

Для работы в терминале используйте установленный лаунчер:

```bash
fcc-claude
```

Держите `fcc-server` запущенным во время работы. Admin UI управляет конфигурацией прокси, перезапускает сервер при изменении настроек времени выполнения, а `fcc-claude` при старте читает текущие порт и токен авторизации, управляемые Admin UI. Также устанавливается `CLAUDE_CODE_AUTO_COMPACT_WINDOW` в `190000` для авто-компакции.

### 2. Расширение VS Code

Откройте настройки, найдите `claude-code.environmentVariables`, выберите **Edit in settings.json** и добавьте:

```json
"claudeCode.environmentVariables": [
  { "name": "ANTHROPIC_BASE_URL", "value": "http://localhost:8082" },
  { "name": "ANTHROPIC_AUTH_TOKEN", "value": "freecc" },
  { "name": "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY", "value": "1" },
  { "name": "CLAUDE_CODE_AUTO_COMPACT_WINDOW", "value": "190000" }
]
```

Перезагрузите расширение. Если расширение покажет экран входа, один раз выберите путь Anthropic Console; после активации переменных окружения локальный прокси продолжит обрабатывать трафик моделей.

### 3. JetBrains ACP

Отредактируйте конфигурацию установленного Claude ACP:

- Windows: `C:\\Users\\%USERNAME%\\AppData\\Roaming\\JetBrains\\acp-agents\\installed.json`
- Linux/macOS: `~/.jetbrains/acp.json`

Установите переменные окружения для `acp.registry.claude-acp`:

```json
"env": {
  "ANTHROPIC_BASE_URL": "http://localhost:8082",
  "ANTHROPIC_AUTH_TOKEN": "freecc",
  "CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY": "1",
  "CLAUDE_CODE_AUTO_COMPACT_WINDOW": "190000"
}
```

Перезапустите IDE после изменения файла.

### 4. Model Picker

<div align="center">
  <img src="assets/cc-model-picker.png" alt="Claude Code model picker showing gateway models" width="700">
</div>

## Дополнительные интеграции

Для каждой интеграции ниже изменяйте **управляемые настройки прокси** только через **Admin UI** по адресу `/admin`: отредактируйте поля, нажмите **Validate**, затем **Apply**. В футере видно, где хранится управляемая конфигурация; это README не описывает правку этого файла вручную.

### 1. Боты Discord и Telegram

Обёртка-бот запускает сессии Claude Code удалённо, стримит прогресс, поддерживает ветвления разговоров через ответы и может останавливать или очищать задачи.

**Discord**

1. Создайте бота в [Discord Developer Portal](https://discord.com/developers/applications).
2. Включите **Message Content Intent**.
3. Пригласите бота с правами чтения, отправки и доступа к истории сообщений.
4. Скопируйте токен бота и числовой ID канала(ов), где бот должен отвечать.

**Telegram**

1. Создайте бота через [@BotFather](https://t.me/BotFather) и скопируйте токен.
2. Получите ваш числовой user ID через [@userinfobot](https://t.me/userinfobot), чтобы доступ был только у вас.

**Настройка в Admin UI**

1. При запущенном `fcc-server` откройте URL Admin UI из вывода терминала.
2. В боковом меню выберите **Messaging**.
3. Установите **Messaging Platform** в **discord** или **telegram**.
4. Для Discord вставьте **Discord Bot Token** и **Allowed Discord Channels**. Для Telegram вставьте **Telegram Bot Token** и **Allowed Telegram User ID**.
5. Укажите **Allowed Directory** — абсолютный путь на машине, где запущен прокси (корень рабочего пространства, который бот может использовать).
6. Нажмите **Validate**, затем **Apply**. Перезапустите сервер, если UI попросит.

<div align="center">
  <img src="assets/admin-messaging.png" alt="Admin UI Messaging view with bot and voice settings" width="700">
</div>

<p align="center"><em>Admin UI → Messaging (platform, bots, and Voice)</em></p>

**Полезные команды**

- `/stop` отменяет задачу; ответ на сообщение задачи остановит только ту ветку.
- `/clear` сбрасывает сессии; ответ — очистит одну ветку.
- `/stats` показывает состояние сессий.

### 2. Голосовые заметки

Голосовые заметки работают в Discord и Telegram после установки соответствующих опциональных дополнений к прокси. Повторно выполните `uv tool install --force` с нужными extras (та же Git-ссылка, что в Быстром старте):

```bash
# NVIDIA NIM transcription (Riva gRPC)
uv tool install --force "free-claude-code-rus[voice] @ git+https://github.com/Developer3000S/free-claude-code-rus.git"

# Local Whisper (CPU or CUDA)
uv tool install --force "free-claude-code-rus[voice_local] @ git+https://github.com/Developer3000S/free-claude-code-rus.git"

# Both backends
uv tool install --force "free-claude-code-rus[voice,voice_local] @ git+https://github.com/Developer3000S/free-claude-code-rus.git"
```

Для локального Whisper с CUDA добавьте `--torch-backend cu130` к команде установки `voice_local`. Перезапустите `fcc-server` после переустановки.

В **Admin UI** откройте **Messaging** и прокрутите до **Voice**. Включите **Voice Notes**, выберите **Whisper Device** (`cpu`, `cuda` или `nvidia_nim`), укажите **Whisper Model** и при необходимости вставьте **Hugging Face Token**. Для транскрипции через `nvidia_nim` установите extras `voice` и укажите **NVIDIA NIM API Key** на вкладке **Providers**. Скриншот выше показывает блок **Voice** в этом же представлении.

## Как это работает

<div align="center">
  <img src="assets/how-it-works.svg" alt="Free Claude Code request flow architecture" width="900">
</div>

Диаграмма: [`assets/how-it-works.mmd`](assets/how-it-works.mmd).

Ключевые компоненты:

- FastAPI предоставляет Anthropic-совместимые маршруты, такие как `/v1/messages`, `/v1/messages/count_tokens` и `/v1/models`.
- Маршрутизация моделей разрешает имя модели Claude в `MODEL_OPUS`, `MODEL_SONNET`, `MODEL_HAIKU` или `MODEL`.
- NIM, OpenCode Zen, OpenCode Go и Z.ai используют OpenAI-style потоковую передачу чата, преобразованную в Anthropic SSE.
- Wafer, OpenRouter, DeepSeek, LM Studio, llama.cpp и Ollama используют транспорт в стиле Anthropic Messages.
- Прокси нормализует блоки рассуждений, вызовы инструментов, метаданные использования токенов и ошибки провайдеров в формат, который ожидает Claude Code.
- Оптимизации запросов отвечают на тривиальные проверки Claude Code локально, чтобы экономить задержку и квоты.

## Разработка

### 1. Структура проекта

```text
free-claude-code-rus/
├── server.py              # ASGI точка входа
├── api/                   # FastAPI маршруты, слой сервисов, маршрутизация, оптимизации
├── core/                  # Общие помощники для протокола Anthropic и утилиты SSE
├── providers/             # Транспорты провайдеров, реестр, rate limiting
├── messaging/             # Адаптеры Discord/Telegram, сессии, голос
├── cli/                   # Точки входа пакета и управление процессом Claude
├── config/                # Настройки, каталог провайдеров, логирование
└── tests/                 # Юнит- и контрактные тесты
```

### 2. Запуск из исходников

Используйте этот путь, если разрабатываете или хотите запустить из checkout:

```bash
git clone https://github.com/Developer3000S/free-claude-code-rus.git
cd free-claude-code-rus
uv run uvicorn server:app --host 0.0.0.0 --port 8082
```

### 3. Команды

```bash
uv run ruff format
uv run ruff check
uv run ty check
uv run pytest
```

Выполняйте их в указанном порядке перед пушем. CI применяет те же проверки.

### 4. Скрипты пакета

`pyproject.toml` устанавливает:

- `fcc-server`: запускает прокси с настроенным хостом и портом.
- `fcc-init`: необязательный продвинутый скелет для `~/.fcc/.env`; для обычной конфигурации используйте **Admin UI**.
- `fcc-claude`: запускает Claude Code с настроенным локальным URL прокси, токеном авторизации, флагом обнаружения моделей и 190k `CLAUDE_CODE_AUTO_COMPACT_WINDOW` для авто-компакции.
- `free-claude-code-rus`: алиас совместимости для `fcc-server`.

### 5. Расширение

- Добавляйте OpenAI-совместимых провайдеров, расширяя `OpenAIChatTransport`.
- Добавляйте провайдеров Anthropic Messages, расширяя `AnthropicMessagesTransport`.
- Регистрируйте метаданные провайдеров в `config.provider_catalog` и внедряйте в фабрику `providers.registry`.
- Добавляйте платформы обмена сообщениями, реализуя интерфейс `MessagingPlatform` в `messaging/`.

## Contributing

- [`.env.example`](.env.example) перечисляет имена переменных окружения как справочный список для контрибьюторов; для изменения управляемых настроек используйте **Admin UI**.
- Сообщайте об ошибках и запросах на фичи в [Issues](https://github.com/Developer3000S/free-claude-code-rus/issues).
- Держите изменения маленькими и сопровождёнными тестами.
- Не предлагайте PR с интеграцией Docker.
- Не открывайте PR только с изменением README; вместо этого создайте issue.
- Перед открытием PR выполните полный набор проверок.
- Синтаксис `except X, Y` возвращён в финальной версии Python 3.14 (не в альфе). Учитывайте это при создании PR.

## Лицензия

MIT License. См. [LICENSE](LICENSE) для деталей.

````
