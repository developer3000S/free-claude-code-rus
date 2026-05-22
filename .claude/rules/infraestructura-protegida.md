# Regla #17 — Infraestructura `.claude/` Protegida

## Principio Fundamental

**La infraestructura ICFES en `.claude/` (CLAUDE.md, settings.json, hooks/, rules/, agents/ ICFES, skills/ ICFES, scripts/) es zona protegida. Toda modificación que la afecte DEBE pasar por backup verificable + verificación post-cambio + reversibilidad explícita. NO se acepta degradación silenciosa de las invariantes ICFES.**

Esta regla NO tiene excepciones. Aplica a cambios manuales del usuario, instalaciones de plataformas externas (claude-flow, ruflo, ruv-swarm, flow-nexus), reinstalaciones (`init`, `init --force`, `init --wizard`) y migraciones (`doctor --fix`, scripts de upgrade).

---

## Origen: lecciones de la sesión Ruflo (2026-04-25)

El 2026-04-25 una instalación de Ruflo (`ruflo init` o equivalente) reemplazó silenciosamente:

| Archivo | Estado pre-Ruflo | Estado post-Ruflo (silencioso) | Detección |
|---|---|---|---|
| `.claude/settings.json` | 2 hooks ICFES (`pre-write-rmd-gate.sh`, `post-exams2-validation.sh`) | 12 hooks Ruflo (`hook-handler.cjs`) sin invocar los ICFES | 8 días después (sesión 2026-05-03) |
| `CLAUDE.md` (raíz) | Identidad ICFES con regla "16 reglas críticas" | "# Claude Code Configuration - RuFlo V3" genérico | Misma sesión |
| `.claude/CLAUDE.md` | Índice ICFES de 16 reglas | Intacto (suerte: no fue tocado) | Misma sesión |
| `.gitignore` | Sin entradas Ruflo | Con `.claude-flow/data/`, `.codex/`, `CLAUDE.local.md` | Diff visible |

**Impacto:** durante 8 días, 7 de 16 reglas críticas estuvieron documentadas pero su enforcement automático estaba roto (gate workflow, validación matemática post-render, preview visual, recordatorio tildes, validación semántica Nivel 4, correctitud Nivel 5, Stress Test Visual). Cualquier `.Rmd` creado en ese período pudo saltarse el gate y la validación post-exams2.

---

## Versionado Git (ADR-002, 2026-05-18)

A partir de v3.14.0, **`.claude/` está bajo control de versiones Git** con exclusiones
mínimas para configuración local (`.claude/.gitignore`).

### Qué se versiona (~413 archivos)

| Directorio | Contenido |
|-----------|-----------|
| `rules/` | 18 reglas obligatorias (.md) |
| `scripts/` | Scripts de validación (R + Python) |
| `hooks/` | 3 hooks ICFES |
| `skills/` | ~60 skills (ICFES + externos) |
| `agents/` | ~80 agentes (ICFES + externos) |
| `commands/` | Slash commands |
| `docs/` | Documentación extensa |
| `schemas/` | JSON schemas |
| `CLAUDE.md` | Índice central (600+ líneas) |
| `detractor-config.yaml` | Configuración |

### Qué NO se versiona (`.claude/.gitignore`)

| Exclusión | Razón |
|-----------|-------|
| `settings.json` | MCP servers locales, rutas absolutas |
| `settings.local.json` | Overrides personales |
| `settings.json.pre-*` | Backups de sesiones |
| `helpers/` | Ruflo/claude-flow externo (40+ archivos, ~9500 líneas) |

### Beneficios del versionado

1. **Trazabilidad**: `git log -- .claude/` muestra historial completo de cambios
2. **Reversibilidad**: `git checkout` reemplaza tarballs manuales
3. **Colaboración**: otros devs reciben la misma infraestructura al clonar
4. **CI/CD**: scripts de validación disponibles en GitHub Actions
5. **Defensa anti-Ruflo**: `git diff` detecta cualquier modificación silenciosa

---

## Invariantes ICFES inviolables

Estos hechos DEBEN ser ciertos en cualquier momento. Si una intervención los rompe, hay que revertirla o re-establecerlos antes de cerrar la sesión.

### I-1 — Identidad ICFES en `CLAUDE.md` raíz

**Invariante:** la primera línea no-vacía de `CLAUDE.md` (raíz) debe identificar el repo como ICFES.

**Verificación:**
```bash
head -1 CLAUDE.md | grep -qE "(ICFES|Repositorio ICFES R/exams)"
```

**Si falla:** restaurar el bloque ICFES priority desde `git log` (commits que tocaron `CLAUDE.md`) o desde `git show <commit>:CLAUDE.md`.

### I-2 — Índice de 17 reglas en `.claude/CLAUDE.md`

**Invariante:** `.claude/CLAUDE.md` debe ser el índice ICFES con las **17 reglas críticas** (16 originales + esta regla #17).

**Verificación:**
```bash
grep -c "^[0-9]\{1,2\}\. \*\*" .claude/CLAUDE.md  # debe retornar >= 17
grep -q "Sistema de Generación Automatizada de Ejercicios ICFES" .claude/CLAUDE.md
```

**Si falla:** comparar contra `git show HEAD:.claude/CLAUDE.md` y restaurar.

### I-3 — Hooks ICFES enganchados en `settings.json`

**Invariante:** `.claude/settings.json` debe cargar al menos los dos hooks ICFES en sus matchers correctos.

**Verificación:**
```bash
python3 -c "
import json, sys
s = json.load(open('.claude/settings.json'))
pre = [h['command'] for m in s['hooks']['PreToolUse']
       if m['matcher'] in ('Write|Edit|MultiEdit', 'Write|Edit')
       for h in m['hooks']]
post = [h['command'] for m in s['hooks']['PostToolUse']
        if m['matcher'] == 'Bash'
        for h in m['hooks']]
assert any('pre-write-rmd-gate.sh' in c for c in pre), 'gate ICFES desenganchado'
assert any('post-exams2-validation.sh' in c for c in post), 'post-exams2 desenganchado'
print('I-3 OK')
"
```

**Si falla:** restaurar desde `.claude/settings.json.pre-icfes-rehook-*` o re-aplicar la edición convivencia (ver ADR-001).

### I-4 — Reglas ICFES presentes y no-vacías

**Invariante:** las 17 reglas deben existir como archivos en `.claude/rules/`.

**Verificación:**
```bash
test $(ls .claude/rules/*.md 2>/dev/null | wc -l) -ge 16
```

**Si falla:** restaurar desde `.claude.pre-ruflo-20260425-123652.tar.gz` o `git checkout`.

### I-5 — Agentes ICFES presentes

**Invariante:** los 9 agentes del workflow ICFES (clasificador, pedagogo, detractor, validador-visual, diagnosticador, corrector-coherencia, adversario, **orquestador-schoice**, **orquestador-cloze**) deben existir.

**Verificación:**
```bash
for a in clasificador-icfes pedagogo-icfes agente-detractor validador-visual \
         diagnosticador-errores corrector-coherencia adversario orquestador-schoice orquestador-cloze; do
  test -f ".claude/agents/${a}.md" || { echo "FALTA: $a"; exit 1; }
done
echo 'I-5 OK'
```

### I-6 — Hooks ejecutables y sintaxis válida

**Invariante:** los `.sh` ICFES deben ser ejecutables y `bash -n` debe pasar.

**Verificación:**
```bash
for h in .claude/hooks/{pre-write-rmd-gate,post-exams2-validation,pre-commit-ortografia}.sh; do
  test -x "$h" && bash -n "$h" || { echo "FAIL: $h"; exit 1; }
done
echo 'I-6 OK'
```

### I-7 — Backup pre-Ruflo preservado

**Invariante:** mientras existan riesgos de re-instalación, el tarball `.claude.pre-ruflo-20260425-123652.tar.gz` debe existir como red de seguridad.

**Verificación:**
```bash
test -f .claude.pre-ruflo-20260425-123652.tar.gz
```

**Si falla:** alertar y NO continuar. El backup es la única forma de restaurar el estado pre-Ruflo si todo lo demás fracasa.
**Nota (v3.14.0):** con `.claude/` ahora versionado en Git, el tarball es redundante pero se preserva.

### I-8 — `.claude/` versionado en Git (v3.14.0+)

**Invariante:** `.claude/` DEBE estar bajo control de versiones. El `.gitignore` raíz NO debe contener `.claude`.

**Verificación:**
```bash
grep -q '^\.claude$' .gitignore && echo "FAIL: .claude en gitignore raiz" || echo "I-8 OK"
test -f .claude/.gitignore && echo "I-8b OK" || echo "FAIL: falta .claude/.gitignore"
```

**Si falla:** revertir a commit donde I-8 era verdadera.

### I-9 — `.claude/.gitignore` excluye solo configuración local

**Invariante:** el `.gitignore` interno de `.claude/` debe excluir `settings.json`, `settings.local.json`, `settings.json.pre-*` y `helpers/`. Todo lo demás (rules, scripts, hooks, skills, agents, commands, docs, schemas) debe versionarse.

**Verificación:**
```bash
grep -q 'settings.json' .claude/.gitignore && \
grep -q 'helpers/' .claude/.gitignore && \
echo "I-9 OK" || echo "FAIL: I-9"
```

---

## Procedimiento obligatorio antes de cualquier instalación/upgrade externo

Aplica antes de ejecutar cualquiera de:

- `npx @claude-flow/cli@latest init|init --force|init --wizard|doctor --fix`
- `npx ruflo@latest init`, `ruflo init`
- `npx ruv-swarm init`
- Comandos similares de plataformas que escriban en `.claude/`

### Paso 1 — Snapshot completo

```bash
TS=$(date +%Y%m%d-%H%M%S)
tar -czf ".claude.pre-${PLATAFORMA}-${TS}.tar.gz" .claude/
cp .claude/settings.json ".claude/settings.json.pre-${PLATAFORMA}-${TS}"
cp CLAUDE.md "CLAUDE.md.pre-${PLATAFORMA}-${TS}"
echo "Backup creado: .claude.pre-${PLATAFORMA}-${TS}.tar.gz"
```

### Paso 2 — Ejecutar la instalación

```bash
npx <plataforma>@latest <comando>
```

### Paso 3 — Verificar invariantes I-1 a I-7

Ejecutar el script `tests/testthat/test_infraestructura_claude.R` (creado por esta misma regla) o el equivalente:

```bash
Rscript tests/testthat/test_infraestructura_claude.R
```

Si **alguna invariante falla** → revertir con paso 4. NO continuar con la instalación nueva como si todo estuviera bien.

### Paso 4 — Reversibilidad si algo falla

```bash
# Plan A: revertir un solo archivo
cp ".claude/settings.json.pre-${PLATAFORMA}-${TS}" .claude/settings.json
cp "CLAUDE.md.pre-${PLATAFORMA}-${TS}" CLAUDE.md

# Plan B: revertir todo .claude/
rm -rf .claude/
tar -xzf ".claude.pre-${PLATAFORMA}-${TS}.tar.gz"

# Plan C (último recurso): si el snapshot se corrompió
git checkout -- .claude/ CLAUDE.md
```

---

## Conflictos entre plataformas externas y reglas ICFES

Cuando una herramienta externa (Ruflo, claude-flow, ruv-swarm, flow-nexus) recomienda algo que contradice una regla ICFES:

**ICFES prevalece. Sin excepciones.**

Esta regla está documentada en:
- `CLAUDE.md` raíz (sección "Reglas absolutas para este repo").
- `.claude/CLAUDE.md` (regla #17).
- `~/.claude/CLAUDE.md` global (sección "Adversario Documentado" + "Regla Obligatoria Global: Routing de Modelos").
- `ADR-001-convivencia-ruflo-icfes.md`.

Patrones específicos de conflicto y su resolución:

| Recomendación externa | Regla ICFES violada | Decisión |
|---|---|---|
| Ruflo: "usa hierarchical-mesh + 15 agentes" | #14 routing de modelos por complejidad | Ignorar; usar el routing ICFES |
| Ruflo: "init --force re-genera todo" | I-1 a I-7 | NO ejecutar sin snapshot previo |
| claude-flow doctor --fix | Puede tocar settings.json | Solo `doctor` (sin --fix) hasta validar diff |
| Ruflo skill X duplica skill ICFES | #6, #8, #16 | Mantener el ICFES, marcar el Ruflo como "no usar" |
| auto-memory bridge sin paquete | (memoria N2) | Vivir sin él hasta tener tiempo de instalar limpiamente |

---

## Convivencia con Ruflo (estado actual, 2026-05-03)

Decisión documentada en `ADR-001-convivencia-ruflo-icfes.md`:

- **Ruta seleccionada: B (convivencia)**.
- Hooks Ruflo + hooks ICFES coexisten en `settings.json` (3 PreToolUse Write|Edit|MultiEdit + 2 PostToolUse Bash).
- `CLAUDE.md` raíz mezclado: ICFES priority arriba (47 líneas) + Ruflo V3 abajo (244 líneas, marcado como descriptivo).
- MCP `ruflo` desregistrado (fallaba al conectarse). Quedan `ruv-swarm` y `flow-nexus` para funciones similares.
- Daemon Ruflo desactivado (bloque `claudeFlow.daemon` removido de `settings.json`).
- Memoria persistente Ruflo NO inicializada (paquete npm faltante; los `MEMORY.md` siguen siendo la fuente).
- Backup pre-Ruflo (`.claude.pre-ruflo-20260425-123652.tar.gz`) preservado como red de seguridad.

---

## Antipatrones PROHIBIDOS

### 1. Ejecutar `init --force` o `doctor --fix` sin backup

```bash
# ❌ PROHIBIDO
npx @claude-flow/cli@latest init --force

# ✓ CORRECTO
TS=$(date +%Y%m%d-%H%M%S)
tar -czf ".claude.pre-init-${TS}.tar.gz" .claude/
npx @claude-flow/cli@latest init --force
Rscript tests/testthat/test_infraestructura_claude.R
```

### 2. Sobrescribir `CLAUDE.md` con plantilla genérica de plataforma

Si una herramienta externa propone reemplazar `CLAUDE.md`, **rechazar** o aplicar el patrón de mezcla (ver `ADR-001-convivencia-ruflo-icfes.md` §"Mezcla de CLAUDE.md raíz").

### 3. Confiar en wrappers genéricos para invocar hooks ICFES

Verificación obligatoria:
```bash
grep -E "rmd-gate|post-exams2|ortografia|\.claude/hooks/" .claude/helpers/<wrapper>.cjs 2>/dev/null
```
Si retorna 0 coincidencias → el wrapper NO está invocando los hooks ICFES; hay que engancharlos directamente en `settings.json` (ver ADR-001).

### 4. Eliminar el tarball pre-Ruflo

`.claude.pre-ruflo-20260425-123652.tar.gz` (1.2 MB) es la única red de seguridad para volver al estado pre-Ruflo. **No lo borres** sin reemplazarlo por otro snapshot equivalente.

### 5. Modificar `.claude/helpers/hook-handler.cjs` u otros archivos Ruflo internos

Esos archivos pueden ser sobrescritos por cualquier `npx claude-flow update`. Si necesitas funcionalidad nueva, hazlo en el lado ICFES (settings.json + hooks/*.sh), no en el lado Ruflo.

---

## Test de regresión asociado

Esta regla tiene un test automático que verifica las 7 invariantes:

`tests/testthat/test_infraestructura_claude.R`

Se ejecuta automáticamente en `tests/run_all_tests.R` y en pre-push. Si falla, el commit/push se bloquea hasta que las invariantes se restauren.

---

## Referencias

- `ADR-001-convivencia-ruflo-icfes.md` — decisión arquitectónica.
- `.claude/docs/patrones-errores-conocidos.md` Errores 11-15 — casos concretos detectados en sesión 2026-05-03.
- `.claude/docs/INDICE_LECCIONES.md` — mapa unificado.
- Backup pre-Ruflo: `.claude.pre-ruflo-20260425-123652.tar.gz`.
- Backup pre-rehook: `.claude/settings.json.pre-icfes-rehook-20260503-171742`.

---

**Versión:** 1.0
**Fecha:** 2026-05-03
**Estado:** ACTIVO Y OBLIGATORIO
**Excepciones:** NINGUNA
**Aplica a:** todo el ecosistema `.claude/` y archivos raíz `CLAUDE.md`, `CLAUDE.local.md`.
