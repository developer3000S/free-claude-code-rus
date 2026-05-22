# Auditoría Ruflo + Harness — Fase 1 (Diagnóstico read-only)

**Repo:** `/home/bootcamp/Proyectos-2026/RepositorioMatematicasICFES_R_Exams`
**Fecha:** 2026-05-03
**Snapshot pre-Ruflo:** `.claude.pre-ruflo-20260425-123652.tar.gz` (288 entradas, capturado 2026-04-25 12:36:52)

---

## 1) Diff Ruflo vs pre-Ruflo (qué cambió)

### 1.1 `.claude/CLAUDE.md` — INTACTO ✅

El `CLAUDE.md` ICFES original (índice de 16 reglas críticas) **sigue presente y vigente** en `.claude/CLAUDE.md`. **NO fue sobrescrito** por Ruflo. Las primeras líneas siguen siendo `# Sistema de Generación Automatizada de Ejercicios ICFES R/exams`.

**28 referencias `@.claude/rules/*`** desde este archivo siguen activas.

### 1.2 `CLAUDE.md` raíz — REEMPLAZADO POR RUFLO ⚠️

| | Antes | Después |
|---|---|---|
| Encabezado | (no preservado en backup — el tarball solo guardó `.claude/`) | `# Claude Code Configuration - RuFlo V3` |
| Líneas | desconocido | 244 |

**Riesgo:** el `CLAUDE.md` raíz es lo primero que Claude Code carga. Hoy contiene reglas genéricas Ruflo (DDD, swarm, hierarchical-mesh, Agent Booster), **no** las reglas ICFES. Como `CLAUDE.md` raíz **no estaba dentro del backup pre-Ruflo**, no hay forma de restaurarlo desde el tarball — sólo desde git history (`fb634dd0`, `b4e0ec51`, `97b28873` son los últimos commits que lo tocaron).

> **Mitigación parcial existente:** `.claude/CLAUDE.md` (proyecto) sí contiene el índice ICFES y se carga junto con el raíz, así que las reglas ICFES siguen alcanzables — pero ahora compiten con las reglas genéricas Ruflo del raíz.

### 1.3 `.claude/settings.json` — REEMPLAZADO ⚠️ (alto impacto)

| | Pre-Ruflo (`.pre-ruflo-...`) | Actual |
|---|---|---|
| `PreToolUse Write\|Edit` | `pre-write-rmd-gate.sh` + recordatorio de tildes | `hook-handler.cjs pre-edit` (Ruflo) |
| `PreToolUse Bash` | (ninguno) | `hook-handler.cjs pre-bash` |
| `PostToolUse Bash` | `post-exams2-validation.sh` (FASE 2A-2H, 120s) | `hook-handler.cjs post-bash` (5s) |
| `PostToolUse Write\|Edit` | (ninguno) | `hook-handler.cjs post-edit` |
| `UserPromptSubmit` | (ninguno) | `hook-handler.cjs route` |
| `SessionStart/End/Stop/PreCompact/Subagent*/Notification` | (ninguno) | varios `hook-handler.cjs` + `auto-memory-hook.mjs` |

**Hallazgo crítico:** el wrapper `.claude/helpers/hook-handler.cjs` **no invoca** los hooks ICFES (`pre-write-rmd-gate.sh`, `post-exams2-validation.sh`, `pre-commit-ortografia.sh`).
Verificación: `grep -E "rmd-gate|post-exams2|ortografia|\.claude/hooks/" .claude/helpers/hook-handler.cjs` → **0 coincidencias**.

> **Esto significa que ahora mismo, en este repo:**
> - El gate `pre-write-rmd-gate.sh` que bloquea creación de `.Rmd` sin `ejercicio_state.json` **NO está corriendo**.
> - El hook `post-exams2-validation.sh` que ejecuta FASES 2A-2H (validación matemática, preview visual, multi-semilla, arsenal) **NO se dispara después de `exams2*()`**.
> - El recordatorio de tildes en Pre Write/Edit **se perdió**.
> - La regla #16 del `CLAUDE.md` ICFES ("Workflow State Enforcement: gate mecánico PreToolUse + estado persistente") **está documentada pero inactiva**.

### 1.4 Archivos/directorios nuevos agregados por Ruflo (resumen)

- `.claude/agents/` — pasó de 7 agentes ICFES (clasificador-icfes, pedagogo-icfes, agente-detractor, validador-visual, diagnosticador-errores, corrector-coherencia, adversario) a **7 ICFES + 24 subdirectorios genéricos Ruflo** (analysis, architecture, browser, consensus, core, custom, data, development, devops, documentation, flow-nexus, github, goal, optimization, payments, sona, sparc, specialized, sublinear, swarm, templates, testing, v3) → **60+ agentes adicionales**.
- `.claude/skills/` — 60 skills (ICFES + Ruflo mezclados).
- `.claude/commands/` — agregados subdirs `analysis/`, `automation/`, `github/`, `hooks/`, `monitoring/`, `optimization/`, `sparc/` + 3 `.md` Ruflo.
- `.claude/helpers/` — **nuevo directorio entero** (~33 archivos: `hook-handler.cjs`, `auto-memory-hook.mjs`, `intelligence.cjs`, `learning-*.sh`, `swarm-*.sh`, etc.).
- `.claude/backups/optimizacion-20251230_092633/` — backup pre-Ruflo de hace meses (consolidación previa).
- `.claude/deprecated/` — material movido por Ruflo.
- `.claude-flow/` (raíz proyecto) — **nuevo**: `agents/`, `data/`, `hooks/`, `learning/`, `logs/`, `metrics/`, `security/`, `sessions/`, `workflows/` + `config.yaml` + `CAPABILITIES.md` (estado de runtime).
- `.agents/` (raíz proyecto) — **nuevo**: `config.toml`, `skills/`.
- `.gitignore` — Ruflo agregó entradas `.claude-flow/data/`, `.claude-flow/logs/`, `.codex/`, `.env*`, `CLAUDE.local.md` (es razonable, no destructivo).

### 1.5 Archivos ICFES preservados ✅

- `.claude/rules/` — **15 reglas íntegras** (`ciclo-validacion.md`, `codigo-rmd.md`, `contextos-narrativos-creativos.md`, `detractor-obligatorio.md`, `documentacion-verificada.md`, `ejercicios-metacognitivos.md`, `flujo-b-obligatorio.md`, `graficador-secuencial.md`, `graficos-como-opciones.md`, `modelo-routing-obligatorio.md`, `ortografia-espanol.md`, `testing-obligatorio.md`, `validacion-correctitud-respuesta.md`, `validacion-neg-opciones-repetidas.md`, `workflow-state-enforcement.md`).
- `.claude/hooks/post-exams2-validation.sh` — 18 838 bytes, ejecutable, `bash -n` OK.
- `.claude/hooks/pre-write-rmd-gate.sh` — 6 685 bytes, ejecutable, `bash -n` OK.
- `.claude/hooks/pre-commit-ortografia.sh` — 669 bytes, ejecutable (modo 711), `bash -n` OK.
- `.claude/schemas/`, `.claude/scripts/`, `.claude/docs/` — preservados.
- `tests/testthat/` — 12 suites presentes; `tests/run_all_tests.R` íntegro.
- `A-Produccion/` — 202 archivos `.Rmd` y 5 `ejercicio_state.json` en PreDesarrollo+Desarrollo, intactos.

---

## 2) Reglas ICFES en riesgo

| # | Regla | Documentada (`.claude/CLAUDE.md`) | Archivo `rules/` | Mecanismo de enforcement | Estado real |
|---|---|---|---|---|---|
| 1 | Ejercicios metacognitivos | ✅ | ✅ | Skills generar-* | Activo (skills viven) |
| 2 | Flujo B obligatorio | ✅ | ✅ | Skill, manual | Activo |
| 3 | Graficador secuencial 98% | ✅ | ✅ | Skills tikz/python/r | Activo |
| 4 | Gráficos como opciones | ✅ | ✅ | Manual | Activo |
| 5 | 5 Coherencias | ✅ | (en ciclo-validacion.md) | `post-exams2-validation.sh` (FASE 2A) | **🔴 INACTIVO — hook no carga** |
| 6 | Validación visual iterativa | ✅ | ✅ | `post-exams2-validation.sh` (FASE 2B) | **🔴 INACTIVO — hook no carga** |
| 7 | Ortografía española | ✅ | ✅ | Recordatorio Pre Write/Edit + `pre-commit-ortografia.sh` | **🔴 Recordatorio perdido**; hook git ✓ |
| 8 | Testing automático | ✅ | ✅ | git hooks `.git/hooks/pre-commit`, `pre-push` + `tests/run_all_tests.R` | A verificar (no auditado en F1) |
| 9 | Detractor obligatorio | ✅ | ✅ | Skill | Activo |
| 10 | Validación `_neg_` | ✅ | ✅ | testthat | Activo (en tests) |
| 11 | Contextos narrativos creativos | ✅ | ✅ | Skill+detractor | Activo |
| 12 | Validación semántica Nivel 4 | ✅ | (dentro de ejercicios-metacognitivos.md) | `validar_coherencia_matematica.R` (vía hook PostBash) | **🔴 INACTIVO — hook no carga** |
| 13 | Correctitud respuesta Nivel 5 | ✅ | ✅ | Multi-semilla en hook PostBash + `validar_multisemilla.R` | **🔴 INACTIVO — hook no carga** |
| 14 | Routing modelos Opus/Sonnet/Haiku | ✅ | ✅ | Política + `model_recommendation` en skills | Activo (declarativo) |
| 15 | Stress Test Visual FASE 2H | ✅ | (en stress-test-visual SKILL.md) | `post-exams2-validation.sh` FASE 2H | **🔴 INACTIVO — hook no carga** |
| 16 | Workflow State Enforcement | ✅ | ✅ | `pre-write-rmd-gate.sh` PreToolUse Write/Edit | **🔴 INACTIVO — hook no carga** |

**Resumen:** 7 de 16 reglas críticas (5, 6, 7, 12, 13, 15, 16) están **documentadas pero su enforcement automático está roto** porque Ruflo reemplazó los handlers de hooks por su `hook-handler.cjs` y este no invoca los `.sh` ICFES. Las otras 9 sobreviven porque dependen de skills/manuales/git-hooks, no de los Claude Code hooks de `settings.json`.

---

## 3) Estado de hooks (verificación física)

### 3.1 Archivos de hook ICFES (`.claude/hooks/*.sh`)

| Archivo | Permisos | Tamaño | `bash -n` | Cargado en `settings.json`? |
|---|---|---|---|---|
| `pre-write-rmd-gate.sh` | 755 | 6 685 B | ✅ OK | **❌ NO** (lo cargaba pre-Ruflo) |
| `post-exams2-validation.sh` | 755 | 18 838 B | ✅ OK | **❌ NO** (lo cargaba pre-Ruflo) |
| `pre-commit-ortografia.sh` | 711 | 669 B | ✅ OK | N/A (es git hook, no Claude hook) |

> Los binarios están vivos. El problema es que `settings.json` ya no los referencia.

### 3.2 Hooks Ruflo en `settings.json` actual

12 hooks Ruflo cargados (PreToolUse×2, PostToolUse×2, UserPromptSubmit, SessionStart×2, SessionEnd, Stop, PreCompact×2, SubagentStart, SubagentStop, Notification). Todos ejecutan `node .claude/helpers/hook-handler.cjs <fase>` o `auto-memory-hook.mjs`. Ninguno invoca los `.sh` ICFES.

### 3.3 `settings.local.json`

Solo contiene `permissions` (no agrega hooks). Ningún re-enganche de los hooks ICFES vía settings local.

---

## 4) Inventario Ruflo (qué está realmente activo)

| Subsistema | Declarado | Evidencia de uso | Estado |
|---|---|---|---|
| MCP server `claude-flow` | sí (en `.mcp.json` o `~/.claude.json`) | `claude mcp list` colgó/timeout | **Indeterminado** |
| Hook system (`hook-handler.cjs`) | sí, 12 hooks en `settings.json` | Esta misma sesión muestra `[INFO] Routing task:` en `UserPromptSubmit` | **Activo** (pero rompe los ICFES) |
| Auto-memory bridge (`auto-memory-hook.mjs`) | sí, en SessionStart/Stop | system-reminder de SessionStart confirma "Memory package not available — skipping" | **Parcialmente activo** (sin paquete de memoria) |
| `.claude-flow/` runtime | sí | Existe en el repo: `agents/ data/ hooks/ learning/ logs/ metrics/ sessions/ workflows/` | **Activo** |
| `.agents/` (config) | sí | `config.toml` + `skills/` presentes | **Presente** (uso a verificar) |
| Agentes Ruflo (60+ en `.claude/agents/{analysis,architecture,...}`) | sí | Listados en system-reminder del prompt | **Disponibles** (uso bajo demanda) |
| Skills Ruflo (en `.claude/skills/`) | sí | 60 skills mezclados ICFES+Ruflo | **Disponibles** |
| Comandos Ruflo (`.claude/commands/{automation,sparc,...}`) | sí | Listados en system-reminder | **Disponibles** |
| Daemon `claude-flow daemon` | sin verificar | `~/.claude-flow/update-state.json` existe; en proyecto `.claude-flow/` también | **Daemon: sin confirmar; runtime data: sí** |

---

## 5) Inventario "Harness" (clarificación de ambigüedad)

**No hay "harness" propio en este repo.** Los términos "harness" que aparecen en el contexto son:

1. **Skills globales del proyecto Todo-Pajaro** (en `~/.claude/`, no en este repo): `harness-cleanup`, `mapa-impacto`, `checkpoint`, `alinear-completo`. Estos NO aplican aquí.
2. **Harness de claude-flow / Ruflo CLI**: comandos como `npx @claude-flow/cli@latest doctor --fix`, `daemon start`, etc. Documentados en el `CLAUDE.md` raíz (post-Ruflo) pero el daemon no se ha invocado en este audit.

> **Pregunta para el usuario:** cuando dices "Harness", ¿te refieres a (a) traer aquí los skills de harness de Todo-Pajaro, (b) configurar el harness CLI de claude-flow/Ruflo (`doctor`, `daemon`, `init --wizard`), o (c) algo más? **Sin tu respuesta, no puedo seguir a Fase 2 con criterio.**

---

## 6) Subproyectos en este repo

"Subproyectos" = directorios de ejercicio bajo `A-Produccion/`. Estado:

- `01-En-PreDesarrollo/` + `02-En-Desarrollo/` — 5 `ejercicio_state.json` activos.
- `03-En-Produccion/` — ejercicios validados (inmutables); no requieren state.
- 202 `.Rmd` totales bajo `A-Produccion/`.
- Cualquier creación nueva de `.Rmd` en PreDesarrollo/Desarrollo **debería** disparar `pre-write-rmd-gate.sh` → hoy **no lo dispara** (regla 16 rota).

---

## 7) Conclusiones operativas

1. **Riesgo alto e inmediato:** los 7 mecanismos de enforcement automático ICFES (gate de workflow, validación matemática post-render, preview visual, multi-semilla, stress test visual, validación semántica nivel 4, correctitud nivel 5, recordatorio de tildes) están **silenciosamente rotos** desde el 2026-04-25. Cualquier `.Rmd` nuevo escrito desde esa fecha pudo crearse sin gate y sin validación post-render automática.
2. **Buena noticia:** ningún archivo ICFES fue borrado. Todo está restaurable. Los binarios `.sh` siguen siendo válidos (bash OK, ejecutables).
3. **Conflicto de fuentes de verdad:** el `CLAUDE.md` raíz dice cosas Ruflo (DDD, swarm, hierarchical-mesh) que **contradicen** las reglas ICFES de `.claude/CLAUDE.md`. Claude Code carga ambos; el conflicto es ambiguo y potencialmente dañino.
4. **El handler Ruflo (`hook-handler.cjs`, 278 líneas) podría perfectamente ejecutar los `.sh` ICFES como pre/post adicionales** — es la ruta menos invasiva (Ruta B de tu prompt original).

---

## 8) Recomendaciones para Fase 2

Pregunto al usuario:

**P1 — `CLAUDE.md` raíz:** ¿restauramos el contenido ICFES desde `git show fb634dd0:CLAUDE.md` (o el commit previo que tocó este archivo) y dejamos al `CLAUDE.md` raíz como fuente de verdad ICFES? ¿O mezclamos ambos? ¿O dejamos el de Ruflo y movemos las reglas ICFES exclusivamente al `.claude/CLAUDE.md`?

**P2 — Hooks ICFES:** ¿prefieres
   (a) **restaurar** `settings.json` desde `.pre-ruflo-20260425-123652` (pierdes Ruflo hooks, recuperas ICFES),
   (b) **convivencia**: agregar los hooks ICFES de vuelta al `settings.json` actual junto a los de Ruflo (ambos disparan), o
   (c) **integración**: modificar `hook-handler.cjs` para que invoque los `.sh` ICFES en las fases correspondientes?

**P3 — "Harness":** ¿definición exacta? Ver §5.

**P4 — "Automatizar":** ¿qué procesos ICFES quieres automatizar más allá de lo que ya estaba (`.Rmd → render → validar → diagnosticar → corregir`)? Por ejemplo: ¿quieres que el gate dispare `swarm_init` Ruflo en vez de bloquear? ¿O que `post-exams2` use un agente `sparc-coder` para auto-corregir?

**P5 — Subproyectos:** ¿quieres que la automatización aplique a los 5 ejercicios activos en PreDesarrollo+Desarrollo, o solo a nuevos `.Rmd`?

---

## 9) Ítems no auditados en Fase 1 (deuda)

- Estado real del MCP server claude-flow (timeout en `claude mcp list`).
- Estado del daemon `claude-flow` (si está corriendo).
- Si los git hooks `.git/hooks/pre-commit` y `pre-push` siguen ejecutando `tests/run_all_tests.R`.
- Si `auto-memory-hook.mjs` está importando correctamente `MEMORY.md` a AgentDB (la sesión actual mostró "Memory package not available").
- Cobertura real de las 12 suites testthat (no se ejecutaron).

Estos pueden ir a Fase 1.5 si lo apruebas, o esperarse a Fase 2.

---

**FASE 1 COMPLETA — sin modificaciones al repo.**
**Esperando tus respuestas a P1–P5 antes de proponer plan de Fase 2.**
