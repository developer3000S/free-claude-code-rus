# Regla: Enforcement del Workflow via Estado Persistente

## Principio Fundamental

**TODO ejercicio .Rmd DEBE pasar por el workflow completo. Un gate mecánico (PreToolUse hook) BLOQUEA la creación de .Rmd si los pasos previos no están registrados en `ejercicio_state.json`.**

Esta regla NO tiene excepciones. No hay forma de crear o editar un .Rmd en `01-En-PreDesarrollo/` ni en `02-En-Desarrollo/` sin haber completado los pasos previos obligatorios.

---

## Mecanismo: 3 Capas

### Capa 1 — Gate (hook PreToolUse)

**Archivo**: `.claude/hooks/pre-write-rmd-gate.sh`

Se ejecuta automáticamente cada vez que Claude intenta crear o editar un archivo `.Rmd`. Verifica:

1. ¿El archivo está en `01-En-PreDesarrollo/` o `02-En-Desarrollo/`?
2. ¿Existe `ejercicio_state.json` en el directorio del ejercicio?
3. ¿`analisis_icfes` está completado?
4. ¿`flujo_b.requerido` está determinado (no null)?
5. ¿Si `flujo_b.requerido = true`, está `flujo_b.completado = true`?

Si alguna verificación falla → **exit 2** (bloquea el tool call) con instrucciones claras en stderr.

**Excepción 1**: Si `generacion_rmd.completado = true` → es una edición de corrección, se permite sin verificar.

**Excepción 2**: Archivos en `Ejemplos-Funcionales/` son inmutables → siempre permitidos.

**Fail open**: Si el JSON es inválido o no se puede leer el directorio → se permite (nunca bloquear por error del sistema).

### Capa 2 — Estado (ejercicio_state.json)

**Archivo**: `ejercicio_state.json` en la raíz de cada directorio de ejercicio.

Registra el progreso de los 11 pasos del workflow con timestamps ISO 8601 y datos extra por paso. Schema formal en `.claude/schemas/ejercicio_state.schema.json`.

Se gestiona con el CLI:

```bash
.claude/scripts/workflow-state.sh <comando> [argumentos]
```

### Capa 3 — Nudge (mensajes de bloqueo)

Cuando el gate bloquea, muestra mensajes informativos con los **comandos exactos** a ejecutar para desbloquear. No solo dice "falta X" sino "ejecute esto".

---

## Comandos del CLI (`workflow-state.sh`)

| Comando | Descripción |
|---------|-------------|
| `init <dir> --tipo schoice\|cloze [--nombre N]` | Crea `ejercicio_state.json` en el directorio |
| `complete <dir> <paso> [--key value ...]` | Marca un paso como completado con timestamp |
| `check <dir> <paso>` | Exit 0 si completado, exit 1 si pendiente |
| `status <dir>` | Muestra todos los pasos con iconos ✅/⬜ |
| `next <dir>` | Muestra el siguiente paso pendiente con comando sugerido |
| `help` | Muestra la ayuda completa |

### Campos extra por paso

Algunos pasos admiten campos informativos adicionales al usar `complete`:

```bash
# flujo_b: registrar si requiere gráficos
workflow-state.sh complete <dir> flujo_b --requerido false

# generacion_rmd: registrar el nombre del archivo
workflow-state.sh complete <dir> generacion_rmd --archivo "mediana_metacognitivo_v1.Rmd"

# detractor_fase2c: registrar el veredicto
workflow-state.sh complete <dir> detractor_fase2c --veredicto "APROBAR"

# validar_diversidad: registrar versiones únicas obtenidas
workflow-state.sh complete <dir> validar_diversidad --versiones_unicas 287
```

---

## Secuencia Obligatoria (11 Pasos)

| # | Paso | Comando sugerido | Gate |
|---|------|-----------------|------|
| 1 | `analisis_icfes` | `/analizar-icfes` | Bloquea si incompleto |
| 2 | `flujo_b` | Preguntar al usuario | Bloquea si null o incompleto |
| 3 | `generacion_rmd` | `/generar-schoice` o `/generar-cloze` | Se desbloquea después de 1+2 |
| 4 | `retroalimentacion` | `/skill-retroalimentacion` | — |
| 5 | `renderizado_4_formatos` | `exams2html/pdf/docx/nops` | — |
| 6 | `arsenal_post_render` | (automático via hook) | — |
| 7 | `detractor_fase2c` | `/adversario archivo.Rmd` | — |
| 8 | `coherencias_5` | Documentar 5 coherencias | — |
| 9 | `validar_diversidad` | `/validar-diversidad` | — |
| 10 | `validar_icfes` | `/validar-icfes` | — |
| 11 | `aprobacion_usuario` | Pedir aprobación al usuario | — |

**El gate activo es en el paso 3**: los pasos 1 y 2 deben estar resueltos para poder crear el .Rmd. Los pasos 4-11 no tienen gate mecánico, pero son igualmente obligatorios por las reglas del ciclo de validación.

---

## Gate Blocking

### Lo que BLOQUEA (exit 2):

| Situación | Mensaje |
|-----------|---------|
| No existe `ejercicio_state.json` | Instrucciones para `init` + pasos 1 y 2 |
| `analisis_icfes.completado = false` | "Ejecutar /analizar-icfes primero" |
| `flujo_b.requerido = null` | "Preguntar al usuario si requiere gráficos" |
| `flujo_b.requerido = true` y `flujo_b.completado = false` | "Completar Flujo B antes de generar .Rmd" |

### Lo que PERMITE (exit 0):

| Situación | Razón |
|-----------|-------|
| Archivo fuera de `01-En-PreDesarrollo/` o `02-En-Desarrollo/` | Fuera del workflow |
| Archivo en `Ejemplos-Funcionales/` | Inmutable, siempre permitir |
| Archivo no es `.Rmd` | El gate solo aplica a .Rmd |
| `generacion_rmd.completado = true` | Es edición de corrección |
| Todos los prerequisitos OK | Estado válido |

---

## Ante Dudas: Preguntar al Usuario (flujo_b.requerido)

El campo `flujo_b.requerido` puede ser `null`, `true` o `false`. El valor `null` es el estado inicial y significa "por determinar".

**Protocolo cuando `flujo_b.requerido = null`:**

1. Claude NO puede asumir si requiere o no gráficos.
2. Claude DEBE preguntar explícitamente al usuario:
   > "¿Este ejercicio requiere gráficos? (Flujo B). Responder sí o no para continuar."
3. Según la respuesta, registrar:
   ```bash
   # Si no requiere gráficos:
   workflow-state.sh complete <dir> flujo_b --requerido false

   # Si sí requiere gráficos:
   workflow-state.sh complete <dir> flujo_b --requerido true
   # → Luego ejecutar /auto-refinar-grafico y marcar:
   # workflow-state.sh complete <dir> flujo_b
   ```

**Antipatrón PROHIBIDO:**

```
❌ Asumir flujo_b.requerido sin preguntar al usuario
❌ Crear el .Rmd sin haber determinado si requiere gráficos
```

---

## Recuperación de Sesión

Si Claude Code se reinicia o se pierde el contexto, el estado persiste en `ejercicio_state.json`. Para retomar:

```bash
# Ver en qué punto está el ejercicio
.claude/scripts/workflow-state.sh status <dir>

# Ver el próximo paso pendiente
.claude/scripts/workflow-state.sh next <dir>

# Verificar un paso específico (útil en scripts)
.claude/scripts/workflow-state.sh check <dir> analisis_icfes && echo "OK"
```

El estado sobrevive entre conversaciones, reinicios de Claude Code y cambios de directorio.

---

## Flujo Completo con Gate

```
Usuario: "Crea ejercicio sobre mediana"
    ↓
Claude: workflow-state.sh init ./mi-ejercicio --tipo cloze
    ↓
Claude: /analizar-icfes
Claude: workflow-state.sh complete ./mi-ejercicio analisis_icfes
    ↓
Claude: "¿Requiere gráficos?"  ← OBLIGATORIO preguntar
Usuario: "No"
Claude: workflow-state.sh complete ./mi-ejercicio flujo_b --requerido false
    ↓
Claude: Write(mi-ejercicio.Rmd, ...)  ← GATE: verifica estado ✅ OK
    ↓
Claude: workflow-state.sh complete ./mi-ejercicio generacion_rmd --archivo "mi-ejercicio.Rmd"
    ↓
[pasos 4-11 continúan...]
```

---

## Integración con Reglas Existentes

Esta regla (16) refuerza y depende de:

| Regla | Relación |
|-------|----------|
| `flujo-b-obligatorio.md` | Gate verifica flujo_b antes de permitir .Rmd |
| `ciclo-validacion.md` | Pasos 5-8 corresponden a FASES 1-2C del ciclo |
| `ejercicios-metacognitivos.md` | El gate garantiza que el análisis previo existe |
| `detractor-obligatorio.md` | Paso 7 (detractor_fase2c) es parte del workflow |
| `testing-obligatorio.md` | Pasos 9-10 (diversidad, ICFES) son validaciones |

---

**Versión**: 1.0
**Fecha**: 2026-03-21
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: Ver sección "Lo que PERMITE"
**Scripts asociados**:
  - `.claude/scripts/workflow-state.sh` — CLI de gestión
  - `.claude/hooks/pre-write-rmd-gate.sh` — Gate PreToolUse
  - `.claude/schemas/ejercicio_state.schema.json` — Schema JSON
