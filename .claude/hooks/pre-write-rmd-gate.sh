#!/usr/bin/env bash
# pre-write-rmd-gate.sh — Hook PreToolUse que bloquea Write/Edit de .Rmd
# sin estado de workflow válido en ejercicio_state.json
#
# Versión: 1.0 — Fecha: 2026-03-21
# Protocolo Claude Code hooks: JSON via stdin, exit 2 = bloquear, exit 0 = permitir

set -uo pipefail

STATE_FILE="ejercicio_state.json"

# ---------------------------------------------------------------------------
# Leer JSON del stdin de forma robusta
# ---------------------------------------------------------------------------
INPUT=$(cat)

# Extraer file_path con python3
FILE_PATH=$(python3 - "$INPUT" <<'PYEOF' 2>/dev/null
import json, sys

raw = sys.argv[1]
try:
    data = json.loads(raw)
    fp = data.get("tool_input", {}).get("file_path", "")
    print(fp)
except Exception:
    print("")
PYEOF
)

# Si no se pudo extraer ruta → permitir (no bloquear operaciones no-archivo)
if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

# ---------------------------------------------------------------------------
# Filtro 1: Solo archivos .Rmd
# ---------------------------------------------------------------------------
if [[ "$FILE_PATH" != *.Rmd && "$FILE_PATH" != *.rmd ]]; then
    exit 0
fi

# ---------------------------------------------------------------------------
# Filtro 2: Ejemplos Funcionales son inmutables → siempre permitir
# ---------------------------------------------------------------------------
if [[ "$FILE_PATH" == *"Ejemplos-Funcionales"* ]]; then
    exit 0
fi

# ---------------------------------------------------------------------------
# Filtro 3: Solo archivos en los directorios del workflow
# ---------------------------------------------------------------------------
if [[ "$FILE_PATH" != *"A-Produccion/01-En-PreDesarrollo"* && \
      "$FILE_PATH" != *"A-Produccion/02-En-Desarrollo"* ]]; then
    exit 0
fi

# ---------------------------------------------------------------------------
# Resolver directorio padre del .Rmd
# ---------------------------------------------------------------------------
RMD_DIR=$(python3 -c "
import os, sys
fp = sys.argv[1]
# Intentar ruta absoluta directamente; si no existe, puede ser nueva
d = os.path.dirname(os.path.abspath(fp))
print(d)
" "$FILE_PATH" 2>/dev/null)

if [[ -z "$RMD_DIR" ]]; then
    # No se puede determinar directorio → permitir
    exit 0
fi

STATE_PATH="${RMD_DIR}/${STATE_FILE}"

# ---------------------------------------------------------------------------
# Filtro 4: Verificar existencia de ejercicio_state.json
# ---------------------------------------------------------------------------
if [[ ! -f "$STATE_PATH" ]]; then
    cat >&2 <<BLOCKMSG

⛔ GATE: Archivo .Rmd bloqueado — falta ejercicio_state.json

No se puede crear/editar:
  $(basename "$FILE_PATH")

El workflow requiere un estado registrado ANTES de generar el .Rmd.

PASOS REQUERIDOS:
  1. Inicializar el estado del ejercicio:
     .claude/scripts/workflow-state.sh init "$(dirname "$FILE_PATH")" --tipo schoice|cloze

  2. Ejecutar el análisis ICFES:
     /analizar-icfes

  3. Marcar el análisis como completado:
     .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" analisis_icfes

  4. Determinar si requiere gráficos (preguntar al usuario):
     .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" flujo_b --requerido false
     (o --requerido true si necesita el Flujo B)

  5. Recién entonces crear el .Rmd.

BLOCKMSG
    exit 2
fi

# ---------------------------------------------------------------------------
# Filtro 5: Verificar estado interno con python3
# ---------------------------------------------------------------------------
DECISION=$(python3 - "$STATE_PATH" <<'PYEOF' 2>/dev/null
import json, sys

sf = sys.argv[1]

try:
    with open(sf, 'r', encoding='utf-8') as fh:
        state = json.load(fh)
except Exception as e:
    # JSON inválido → permitir y no bloquear (evitar loops)
    print("ALLOW:json_invalido")
    sys.exit(0)

pasos = state.get("pasos", {})

# Si generacion_rmd ya está completada → es edición de corrección, permitir
gen_rmd = pasos.get("generacion_rmd", {})
if gen_rmd.get("completado", False):
    print("ALLOW:edicion_correccion")
    sys.exit(0)

# Verificar analisis_icfes
analisis = pasos.get("analisis_icfes", {})
if not analisis.get("completado", False):
    print("BLOCK:sin_analisis")
    sys.exit(0)

# Verificar flujo_b.requerido
flujo_b = pasos.get("flujo_b", {})
req = flujo_b.get("requerido")

if req is None:
    print("BLOCK:flujo_b_sin_determinar")
    sys.exit(0)

if req is True and not flujo_b.get("completado", False):
    print("BLOCK:flujo_b_incompleto")
    sys.exit(0)

# Todo OK
print("ALLOW:prerequisitos_ok")
PYEOF
)

# ---------------------------------------------------------------------------
# Actuar según decisión
# ---------------------------------------------------------------------------
case "$DECISION" in
    ALLOW:*)
        exit 0
        ;;

    BLOCK:sin_analisis)
        cat >&2 <<BLOCKMSG

⛔ GATE: Archivo .Rmd bloqueado — análisis ICFES pendiente

Se encontró ejercicio_state.json pero el análisis inicial no está completado.

ACCIÓN REQUERIDA:
  1. Ejecutar el análisis ICFES:
     /analizar-icfes

  2. Marcar como completado:
     .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" analisis_icfes

BLOCKMSG
        exit 2
        ;;

    BLOCK:flujo_b_sin_determinar)
        cat >&2 <<BLOCKMSG

⛔ GATE: Archivo .Rmd bloqueado — flujo_b no determinado

El análisis ICFES está completo, pero falta determinar si el ejercicio
requiere gráficos (Flujo B).

ACCIÓN REQUERIDA:
  Preguntar al usuario: "¿Este ejercicio requiere gráficos?"

  Si NO requiere gráficos:
    .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" flujo_b --requerido false

  Si SÍ requiere gráficos:
    .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" flujo_b --requerido true
    → Luego completar el Flujo B antes de continuar.

BLOCKMSG
        exit 2
        ;;

    BLOCK:flujo_b_incompleto)
        cat >&2 <<BLOCKMSG

⛔ GATE: Archivo .Rmd bloqueado — Flujo B pendiente

El ejercicio requiere gráficos (flujo_b.requerido = true) pero el Flujo B
no está completado.

ACCIÓN REQUERIDA:
  1. Completar el Flujo B (Graficador Experto):
     /auto-refinar-grafico

  2. Una vez completado, marcar:
     .claude/scripts/workflow-state.sh complete "$(dirname "$FILE_PATH")" flujo_b

  3. Recién entonces crear el .Rmd.

Ver: .claude/rules/flujo-b-obligatorio.md

BLOCKMSG
        exit 2
        ;;

    *)
        # Decisión desconocida o vacía → no bloquear (fail open)
        exit 0
        ;;
esac
