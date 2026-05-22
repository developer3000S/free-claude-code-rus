# ADR-001: Convivencia Ruflo + ICFES en `.claude/`

## Estado

**Aceptado** — 2026-05-03

## Contexto

El 2026-04-25, una instalación de Ruflo (claude-flow v3) reemplazó silenciosamente la configuración `.claude/` ICFES del repositorio `RepositorioMatematicasICFES_R_Exams`. El cambio dejó las 16 reglas críticas documentadas pero su enforcement automático roto:

| Componente | Antes (ICFES) | Después (Ruflo) |
|---|---|---|
| `CLAUDE.md` raíz | Identidad ICFES + 16 reglas | "Claude Code Configuration - RuFlo V3" genérico |
| `.claude/CLAUDE.md` | Índice ICFES (intacto, suerte) | Sin cambios |
| `.claude/settings.json` | 2 hooks (`pre-write-rmd-gate.sh`, `post-exams2-validation.sh`) | 12 hooks Ruflo via `hook-handler.cjs`, ICFES desconectados |
| `.claude/agents/` | 7 agentes ICFES | 7 ICFES + 24 subdirs Ruflo (60+ agentes adicionales) |
| `.claude/skills/` | ~25 skills ICFES | ~60 skills mezclados |
| `.claude/helpers/` | (no existía) | 33 archivos Ruflo (`hook-handler.cjs`, `auto-memory-hook.mjs`, ...) |
| MCP servers (`~/.claude.json`) | 22 funcionando | 22 + `ruflo` (fallando) + `ruv-swarm` + `flow-nexus` |
| `claudeFlow.daemon` config | (no existía) | Bloque presente con `autoStart: false` y workers |
| Memoria persistente | `MEMORY.md` archivos directos | `auto-memory-hook.mjs` con bridge AgentDB sin paquete instalado |

**Detección:** 2026-05-03, 8 días después del cambio. Durante ese período, 7 de 16 reglas críticas operaron sin enforcement automático.

**Backup disponible:** `.claude.pre-ruflo-20260425-123652.tar.gz` (snapshot completo de `.claude/` pre-Ruflo).

## Decisión

Se evaluaron 3 rutas:

- **Ruta A — Restaurar ICFES y desinstalar Ruflo.** Pro: limpio, sin conflicto. Contra: pierde funcionalidad nueva (swarm, memoria, agentes adicionales, skills nuevos) y rompe el `CLAUDE.md` raíz post-Ruflo si es útil para Claude Code.
- **Ruta B — Convivencia (seleccionada).** Mantener Ruflo como capa de coordinación + reanclar enforcement ICFES en paralelo. Pro: cero pérdida funcional, recuperación de enforcement. Contra: complejidad mayor en `settings.json` (3 hooks PreToolUse Write|Edit|MultiEdit + 2 hooks PostToolUse Bash).
- **Ruta C — Migración plena a Ruflo.** Portar las 16 reglas, los 2 hooks y las 12 suites de tests al modelo Ruflo (agentes, hooks_route, swarm). Pro: arquitectura coherente. Contra: 2-3 semanas de trabajo, riesgo alto de regresiones, dependencia fuerte de un proveedor externo cuyo CLI ya está fallando.

**Decisión adoptada: Ruta B (convivencia)** con las siguientes sub-decisiones:

- **P1 = B (mezcla en `CLAUDE.md` raíz):** ICFES priority arriba (47 líneas con identidad, fuente de verdad, reglas absolutas, pointer a `@.claude/CLAUDE.md`); contenido Ruflo V3 abajo marcado como descriptivo.
- **P2 = B (convivencia hooks):** mantener handlers Ruflo (`hook-handler.cjs`) y agregar en paralelo `pre-write-rmd-gate.sh` + recordatorio tildes en PreToolUse Write|Edit|MultiEdit y `post-exams2-validation.sh` (timeout 120s) en PostToolUse Bash.
- **P3 = B (harness CLI Ruflo):** aceptar Ruflo CLI a medias. El CLI npm está roto (`npm error Invalid Version`) pero los hooks/agentes/skills locales funcionan; suficiente para el workflow ICFES.
- **P4 = N1 + N2 (objetivo de automatización):** N1 recuperar enforcement automático ICFES (resuelto por P2), N2 activar memoria persistente Ruflo (no resoluto, paquete faltante; los `MEMORY.md` siguen funcionando).
- **P5 = A (alcance solo `.Rmd` futuros):** no tocar los 5 ejercicios activos en `01-En-PreDesarrollo/` y `02-En-Desarrollo/`. El gate empieza a actuar en próximas creaciones.

**Hallazgos posteriores resueltos:**

- **Hallazgo 1 — MCP `ruflo` no conecta:** desregistrado con `claude mcp remove ruflo` (toca `~/.claude.json`, fuera del repo). Cubierto por `ruv-swarm` y `flow-nexus`.
- **Hallazgo 2 — `claude-flow doctor` rompe:** aceptado a medias. CLI no usado en día a día.
- **Hallazgo 3 — Memoria persistente sin paquete:** vivir sin embeddings ONNX. Los `MEMORY.md` siguen siendo la fuente.
- **Hallazgo 4 — Daemon Ruflo:** bloque `claudeFlow.daemon` removido de `settings.json` (config muerto).

## Consecuencias

### Positivas

- ✅ 17 reglas críticas ICFES con enforcement activo (las 16 originales + #17 infraestructura).
- ✅ Ruflo (hooks `hook-handler.cjs`, swarm, agentes, statusline, auto-memory bridge parcial) intacto y funcional.
- ✅ `CLAUDE.md` raíz con identidad ICFES priority + info Ruflo descriptiva.
- ✅ `settings.json` con convivencia (5 entradas en hooks Pre/Post Write|Edit y Bash).
- ✅ Backup `.claude.pre-ruflo-20260425-123652.tar.gz` preservado como red de seguridad.
- ✅ `.claude/settings.json.pre-icfes-rehook-20260503-171742` como segunda red.
- ✅ 7/7 suites de tests pasan en modo quick (39.9s, 100% cobertura).
- ✅ Test de regresión `test_infraestructura_claude.R` agregado (regla #17) verifica las 7 invariantes I-1 a I-7.

### Negativas

- ⚠️ `settings.json` más cargado (288 → 296 líneas con convivencia).
- ⚠️ Latencia post-render máxima ~125s (5s Ruflo + 120s ICFES). Aceptable, era la latencia pre-Ruflo.
- ⚠️ MCP `ruflo` quedó desregistrado; si en el futuro se quiere usar, hay que arreglar el paquete npm primero.
- ⚠️ `auto-memory-hook.mjs` reporta "Memory package not available" en cada SessionStart. Ruido cosmético, no afecta funcionalidad.
- ⚠️ Hay 80+ archivos Ruflo sin commitear (`.agents/`, `.claude-flow/`, `.claude/agents/{60 dirs}`, etc.) — pendiente decidir si commitear, ignorar o seleccionar (ver Hallazgo 3C de la sesión).

### Neutras

- 🟡 Convivencia significa que TODO archivo Ruflo (helpers, agents, skills) puede ser sobrescrito por `npx ruflo init` o `npx claude-flow init` futuros. La regla #17 obliga a hacer backup antes de cualquier `init`.
- 🟡 La regla "ICFES > Ruflo en conflictos" debe respetarse en cada decisión técnica futura.

## Implementación

| Acción | Archivo | Commit |
|---|---|---|
| Mezclar `CLAUDE.md` raíz | `CLAUDE.md` | `e8bcc2b3` (2026-05-03) |
| Re-enganchar hooks ICFES | `.claude/settings.json` | `fb6ba030` (2026-05-03) |
| Limpiar bloque `daemon` | `.claude/settings.json` | `857980e9` (2026-05-03) |
| Desregistrar MCP `ruflo` | `~/.claude.json` (fuera repo) | (no versionado) |
| Crear regla #17 | `.claude/rules/infraestructura-protegida.md` | (esta sesión) |
| Crear este ADR | `.claude/docs/ADR/001-convivencia-ruflo-icfes.md` | (esta sesión) |
| Crear test regresión | `tests/testthat/test_infraestructura_claude.R` | (esta sesión) |

## Alternativas rechazadas

### Ruta A — Restaurar ICFES puro

Rechazada porque:
- Pierde Ruflo `hook-handler.cjs` que esta sesión usó (UserPromptSubmit routing, SessionStart memoria).
- Pierde 60+ agentes Ruflo que pueden ser útiles a futuro.
- El `CLAUDE.md` raíz Ruflo tiene info de descubrimiento de tools que Claude Code aprovecha en runtime.

### Ruta C — Migración plena a Ruflo

Rechazada porque:
- 2-3 semanas de trabajo de migración con riesgo alto de regresiones en las 12 suites de tests.
- Acoplamiento fuerte a una plataforma externa cuyo CLI npm está fallando (Hallazgo 2).
- No hay paridad funcional: los hooks ICFES validan multi-semilla, stress visual, validación semántica Nivel 4 — funciones que el `hook-handler.cjs` Ruflo no tiene.
- ICFES es el dominio del repo, no Ruflo. La fuente de verdad debe ser ICFES.

## Reversibilidad

Si la convivencia falla en el futuro:

```bash
# Plan A: revertir solo settings.json
cp .claude/settings.json.pre-icfes-rehook-20260503-171742 .claude/settings.json

# Plan B: revertir todo .claude/ pre-Ruflo
rm -rf .claude/
tar -xzf .claude.pre-ruflo-20260425-123652.tar.gz

# Plan C: revertir CLAUDE.md raíz al pre-Ruflo
git log --all --oneline -- CLAUDE.md  # buscar commit pre-Ruflo
git show <commit>:CLAUDE.md > CLAUDE.md
```

Después de cualquier reversión: ejecutar `Rscript tests/testthat/test_infraestructura_claude.R` para verificar que I-1 a I-7 pasan.

## Referencias

- `.claude/rules/infraestructura-protegida.md` — regla #17 (codifica esta decisión).
- `tests/testthat/test_infraestructura_claude.R` — test de regresión.
- `.claude/docs/patrones-errores-conocidos.md` — Errores 11-15 (casos concretos del drift).
- `.claude/docs/INDICE_LECCIONES.md` — mapa unificado de lecciones.
- Reporte completo de la auditoría: `/tmp/ruflo-harness-audit.md` (no versionado).

---

**Autor:** Álvaro Ángel Molina
**Fecha:** 2026-05-03
**Versión ADR:** 1.0
**Próxima revisión:** cuando se intente otro `npx ... init` que afecte `.claude/`.
