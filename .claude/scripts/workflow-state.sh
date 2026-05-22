#!/usr/bin/env bash
# workflow-state.sh — CLI para gestión de estado del workflow de ejercicios ICFES
# Versión: 2.0 — Fecha: 2026-03-21
# Usa python3 para manipulación JSON (jq no disponible en el entorno)

set -uo pipefail

# ---------------------------------------------------------------------------
# Constantes
# ---------------------------------------------------------------------------
STATE_FILE="ejercicio_state.json"
SCHEMA_VERSION="2.0"

PASOS_ORDEN=(
    analisis_icfes
    flujo_b
    generacion_rmd
    retroalimentacion
    renderizado_4_formatos
    arsenal_post_render
    detractor_fase2c
    coherencias_5
    validar_diversidad
    validar_icfes
    aprobacion_usuario
)

declare -A PASO_COMANDO=(
    [analisis_icfes]="/analizar-icfes"
    [flujo_b]="Determinar si requiere gráficos"
    [generacion_rmd]="/generar-schoice o /generar-cloze"
    [retroalimentacion]="/skill-retroalimentacion"
    [renderizado_4_formatos]="exams2html/pdf/docx/nops"
    [arsenal_post_render]="(automático via hook)"
    [detractor_fase2c]="/adversario archivo.Rmd"
    [coherencias_5]="Documentar 5 coherencias"
    [validar_diversidad]="/validar-diversidad"
    [validar_icfes]="/validar-icfes"
    [aprobacion_usuario]="Pedir aprobación al usuario"
)

# ---------------------------------------------------------------------------
# Utilidades
# ---------------------------------------------------------------------------
die() {
    echo "ERROR: $*" >&2
    exit 1
}

now_iso() {
    python3 -c "import datetime; print(datetime.datetime.now().astimezone().isoformat())"
}

resolve_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        die "El directorio no existe: $dir"
    fi
    cd "$dir" && pwd
}

state_path() {
    local dir
    dir=$(resolve_dir "$1")
    echo "${dir}/${STATE_FILE}"
}

require_state() {
    local sf="$1"
    if [[ ! -f "$sf" ]]; then
        die "No se encontró $STATE_FILE en el directorio. Ejecute: workflow-state.sh init <dir>"
    fi
}

# ---------------------------------------------------------------------------
# Comando: init
# ---------------------------------------------------------------------------
cmd_init() {
    local dir=""
    local tipo=""
    local nombre=""

    # Parsear argumentos
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --tipo)
                shift
                tipo="${1:-}"
                ;;
            --nombre)
                shift
                nombre="${1:-}"
                ;;
            *)
                if [[ -z "$dir" ]]; then
                    dir="$1"
                fi
                ;;
        esac
        shift
    done

    [[ -z "$dir" ]] && die "Uso: init <dir> --tipo schoice|cloze [--nombre N]"
    [[ -z "$tipo" ]] && die "Argumento --tipo requerido: schoice o cloze"
    [[ "$tipo" != "schoice" && "$tipo" != "cloze" ]] && die "--tipo debe ser 'schoice' o 'cloze'"

    local abs_dir
    abs_dir=$(resolve_dir "$dir")
    local sf="${abs_dir}/${STATE_FILE}"

    if [[ -f "$sf" ]]; then
        echo "ADVERTENCIA: Ya existe $sf" >&2
        echo "¿Sobreescribir? (s/N): " >&2
        read -r resp
        [[ "$resp" != "s" && "$resp" != "S" ]] && { echo "Cancelado."; exit 0; }
    fi

    # Nombre por defecto: nombre del directorio
    if [[ -z "$nombre" ]]; then
        nombre=$(basename "$abs_dir")
    fi

    local ts
    ts=$(now_iso)

    python3 - "$sf" "$nombre" "$tipo" "$ts" "$SCHEMA_VERSION" <<'PYEOF'
import json, sys

sf     = sys.argv[1]
nombre = sys.argv[2]
tipo   = sys.argv[3]
ts     = sys.argv[4]
ver    = sys.argv[5]

state = {
    "version": ver,
    "ejercicio": nombre,
    "tipo": tipo,
    "timestamp_inicio": ts,
    "timestamp_ultima_actualizacion": ts,
    "pasos": {
        "analisis_icfes": {
            "completado": False,
            "timestamp": None,
            "resultado": None
        },
        "flujo_b": {
            "requerido": None,
            "completado": False,
            "timestamp": None
        },
        "generacion_rmd": {
            "completado": False,
            "timestamp": None,
            "archivo": None
        },
        "retroalimentacion": {
            "completado": False,
            "timestamp": None
        },
        "renderizado_4_formatos": {
            "completado": False,
            "timestamp": None
        },
        "arsenal_post_render": {
            "completado": False,
            "timestamp": None
        },
        "detractor_fase2c": {
            "completado": False,
            "timestamp": None,
            "veredicto": None
        },
        "coherencias_5": {
            "completado": False,
            "timestamp": None
        },
        "validar_diversidad": {
            "completado": False,
            "timestamp": None,
            "versiones_unicas": None
        },
        "validar_icfes": {
            "completado": False,
            "timestamp": None
        },
        "aprobacion_usuario": {
            "completado": False,
            "timestamp": None
        }
    }
}

with open(sf, 'w', encoding='utf-8') as fh:
    json.dump(state, fh, indent=2, ensure_ascii=False)
    fh.write('\n')

print(f"Estado creado: {sf}")
PYEOF
}

# ---------------------------------------------------------------------------
# Comando: complete
# ---------------------------------------------------------------------------
cmd_complete() {
    local dir=""
    local paso=""
    local -a extras=()

    # Parsear posicionales y --key value
    local positional=0
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --*)
                local key="${1#--}"
                shift
                local val="${1:-}"
                extras+=("$key" "$val")
                ;;
            *)
                if [[ $positional -eq 0 ]]; then
                    dir="$1"
                    positional=1
                elif [[ $positional -eq 1 ]]; then
                    paso="$1"
                    positional=2
                fi
                ;;
        esac
        shift
    done

    [[ -z "$dir" || -z "$paso" ]] && die "Uso: complete <dir> <paso> [--key value ...]"

    local sf
    sf=$(state_path "$dir")
    require_state "$sf"

    local ts
    ts=$(now_iso)

    # Pasar extras como JSON array de pares
    local extras_json
    extras_json=$(python3 -c "
import json, sys
args = sys.argv[1:]
pairs = []
i = 0
while i < len(args):
    pairs.append([args[i], args[i+1]])
    i += 2
print(json.dumps(pairs))
" "${extras[@]+"${extras[@]}"}")

    python3 - "$sf" "$paso" "$ts" "$extras_json" <<'PYEOF'
import json, sys

sf         = sys.argv[1]
paso       = sys.argv[2]
ts         = sys.argv[3]
extras_raw = sys.argv[4]

extras = json.loads(extras_raw)  # lista de pares [key, val_str]

with open(sf, 'r', encoding='utf-8') as fh:
    state = json.load(fh)

if paso not in state["pasos"]:
    print(f"ERROR: Paso desconocido '{paso}'", file=sys.stderr)
    print(f"Pasos válidos: {', '.join(state['pasos'].keys())}", file=sys.stderr)
    sys.exit(1)

state["pasos"][paso]["completado"] = True
state["pasos"][paso]["timestamp"]  = ts
state["timestamp_ultima_actualizacion"] = ts

# Aplicar extras: intentar parsear como JSON, sino guardar como string
for key, val_str in extras:
    try:
        val = json.loads(val_str)
    except (json.JSONDecodeError, ValueError):
        val = val_str
    state["pasos"][paso][key] = val

with open(sf, 'w', encoding='utf-8') as fh:
    json.dump(state, fh, indent=2, ensure_ascii=False)
    fh.write('\n')

print(f"✅ Paso '{paso}' marcado como completado.")
PYEOF
}

# ---------------------------------------------------------------------------
# Comando: check
# ---------------------------------------------------------------------------
cmd_check() {
    local dir="${1:-}"
    local paso="${2:-}"
    [[ -z "$dir" || -z "$paso" ]] && die "Uso: check <dir> <paso>"

    local sf
    sf=$(state_path "$dir")
    require_state "$sf"

    python3 - "$sf" "$paso" <<'PYEOF'
import json, sys

sf   = sys.argv[1]
paso = sys.argv[2]

with open(sf, 'r', encoding='utf-8') as fh:
    state = json.load(fh)

if paso not in state["pasos"]:
    print(f"ERROR: Paso desconocido '{paso}'", file=sys.stderr)
    sys.exit(2)

completado = state["pasos"][paso].get("completado", False)
sys.exit(0 if completado else 1)
PYEOF
}

# ---------------------------------------------------------------------------
# Comando: status
# ---------------------------------------------------------------------------
cmd_status() {
    local dir="${1:-}"
    [[ -z "$dir" ]] && die "Uso: status <dir>"

    local sf
    sf=$(state_path "$dir")
    require_state "$sf"

    python3 - "$sf" <<'PYEOF'
import json, sys

sf = sys.argv[1]

with open(sf, 'r', encoding='utf-8') as fh:
    state = json.load(fh)

print(f"")
print(f"  Ejercicio : {state.get('ejercicio', '?')}")
print(f"  Tipo      : {state.get('tipo', '?')}")
print(f"  Inicio    : {state.get('timestamp_inicio', '?')[:19]}")
print(f"  Actualiz. : {state.get('timestamp_ultima_actualizacion', '?')[:19]}")
print(f"")
print(f"  {'#':<3} {'Paso':<30} {'Estado'}")
print(f"  {'-'*3} {'-'*30} {'-'*20}")

ORDEN = [
    "analisis_icfes",
    "flujo_b",
    "generacion_rmd",
    "retroalimentacion",
    "renderizado_4_formatos",
    "arsenal_post_render",
    "detractor_fase2c",
    "coherencias_5",
    "validar_diversidad",
    "validar_icfes",
    "aprobacion_usuario",
]

for i, paso in enumerate(ORDEN, 1):
    info = state["pasos"].get(paso, {})
    completado = info.get("completado", False)
    icono = "✅" if completado else "⬜"

    # Información extra relevante
    extra = ""
    if paso == "flujo_b":
        req = info.get("requerido")
        if req is None:
            extra = "(requerido: por determinar)"
        elif req is True:
            extra = "(requerido: sí)"
        else:
            extra = "(requerido: no)"
    elif paso == "generacion_rmd":
        arch = info.get("archivo")
        if arch:
            extra = f"({arch})"
    elif paso == "detractor_fase2c":
        verd = info.get("veredicto")
        if verd:
            extra = f"(veredicto: {verd})"
    elif paso == "validar_diversidad":
        vu = info.get("versiones_unicas")
        if vu is not None:
            extra = f"({vu} versiones únicas)"

    label = paso.replace("_", " ")
    print(f"  {i:<3} {icono} {label:<28} {extra}")

total = sum(1 for p in ORDEN if state["pasos"].get(p, {}).get("completado", False))
print(f"")
print(f"  Progreso: {total}/{len(ORDEN)} pasos completados")
print(f"")
PYEOF
}

# ---------------------------------------------------------------------------
# Comando: next
# ---------------------------------------------------------------------------
cmd_next() {
    local dir="${1:-}"
    [[ -z "$dir" ]] && die "Uso: next <dir>"

    local sf
    sf=$(state_path "$dir")
    require_state "$sf"

    # Obtener siguiente paso y su mensaje
    python3 - "$sf" <<'PYEOF'
import json, sys

sf = sys.argv[1]

with open(sf, 'r', encoding='utf-8') as fh:
    state = json.load(fh)

ORDEN = [
    "analisis_icfes",
    "flujo_b",
    "generacion_rmd",
    "retroalimentacion",
    "renderizado_4_formatos",
    "arsenal_post_render",
    "detractor_fase2c",
    "coherencias_5",
    "validar_diversidad",
    "validar_icfes",
    "aprobacion_usuario",
]

COMANDOS = {
    "analisis_icfes":       "/analizar-icfes",
    "flujo_b":              "Determinar si requiere gráficos",
    "generacion_rmd":       "/generar-schoice o /generar-cloze",
    "retroalimentacion":    "/skill-retroalimentacion",
    "renderizado_4_formatos": "exams2html/pdf/docx/nops",
    "arsenal_post_render":  "(automático via hook)",
    "detractor_fase2c":     "/adversario archivo.Rmd",
    "coherencias_5":        "Documentar 5 coherencias",
    "validar_diversidad":   "/validar-diversidad",
    "validar_icfes":        "/validar-icfes",
    "aprobacion_usuario":   "Pedir aprobación al usuario",
}

pasos = state["pasos"]

for paso in ORDEN:
    info = pasos.get(paso, {})
    completado = info.get("completado", False)

    if completado:
        continue

    # Caso especial flujo_b
    if paso == "flujo_b":
        req = info.get("requerido")
        if req is None:
            print(f"⬜ Siguiente: flujo_b")
            print(f"   Acción   : Preguntar al usuario si el ejercicio requiere gráficos")
            print(f"   Luego    : workflow-state.sh complete <dir> flujo_b --requerido true|false")
            sys.exit(0)
        elif req is True and not completado:
            print(f"⬜ Siguiente: flujo_b")
            print(f"   Acción   : Completar el Flujo B (Graficador Experto)")
            print(f"   Comando  : /auto-refinar-grafico")
            sys.exit(0)
        # req is False → skip (no requiere gráficos), continuar al siguiente
        continue

    print(f"⬜ Siguiente: {paso.replace('_', ' ')}")
    print(f"   Comando  : {COMANDOS.get(paso, '?')}")
    print(f"   Marcar   : workflow-state.sh complete <dir> {paso}")
    sys.exit(0)

print("✅ COMPLETO — Todos los pasos del workflow están finalizados.")
PYEOF
}

# ---------------------------------------------------------------------------
# Comando: help
# ---------------------------------------------------------------------------
cmd_help() {
    cat <<'HELP'

workflow-state.sh — Gestión de estado del workflow de ejercicios ICFES

USO:
  workflow-state.sh <comando> [argumentos]

COMANDOS:

  init <dir> --tipo schoice|cloze [--nombre N]
      Crea ejercicio_state.json en <dir>.
      --tipo   : Tipo de ejercicio (obligatorio)
      --nombre : Nombre del ejercicio (por defecto: nombre del directorio)

  complete <dir> <paso> [--key value ...]
      Marca un paso como completado con timestamp automático.
      Se pueden agregar datos extra con --key value.
      Ejemplo: workflow-state.sh complete ./mi-ejercicio flujo_b --requerido false
      Ejemplo: workflow-state.sh complete ./mi-ejercicio validar_diversidad --versiones_unicas 287

  check <dir> <paso>
      Verifica si un paso está completado.
      Exit 0 = completado, Exit 1 = pendiente.
      Útil en scripts: workflow-state.sh check ./dir analisis_icfes && echo "OK"

  status <dir>
      Muestra todos los pasos con íconos ✅/⬜ y datos extras relevantes.

  next <dir>
      Muestra el siguiente paso pendiente con el comando sugerido.

  help
      Muestra este mensaje.

PASOS DEL WORKFLOW (en orden):
  1.  analisis_icfes         → /analizar-icfes
  2.  flujo_b                → Determinar si requiere gráficos
  3.  generacion_rmd         → /generar-schoice o /generar-cloze
  4.  retroalimentacion      → /skill-retroalimentacion
  5.  renderizado_4_formatos → exams2html/pdf/docx/nops
  6.  arsenal_post_render    → (automático via hook)
  7.  detractor_fase2c       → /adversario archivo.Rmd
  8.  coherencias_5          → Documentar 5 coherencias
  9.  validar_diversidad     → /validar-diversidad
  10. validar_icfes          → /validar-icfes
  11. aprobacion_usuario     → Pedir aprobación al usuario

CAMPOS ESPECIALES POR PASO:
  flujo_b           : --requerido true|false|null
  generacion_rmd    : --archivo nombre_archivo.Rmd
  detractor_fase2c  : --veredicto APROBAR|"APROBAR CON CAMBIOS"|RECHAZAR
  validar_diversidad: --versiones_unicas N

EJEMPLO COMPLETO:
  workflow-state.sh init ./mi-ejercicio --tipo schoice --nombre "mediana_metacognitivo_v1"
  workflow-state.sh status ./mi-ejercicio
  workflow-state.sh complete ./mi-ejercicio analisis_icfes --resultado "Clasificado N2/Interpretación"
  workflow-state.sh complete ./mi-ejercicio flujo_b --requerido false
  workflow-state.sh next ./mi-ejercicio
  workflow-state.sh complete ./mi-ejercicio generacion_rmd --archivo "mediana_metacognitivo_v1.Rmd"

HELP
}

# ---------------------------------------------------------------------------
# Dispatcher principal
# ---------------------------------------------------------------------------
main() {
    local cmd="${1:-help}"
    shift || true

    case "$cmd" in
        init)     cmd_init "$@" ;;
        complete) cmd_complete "$@" ;;
        check)    cmd_check "$@" ;;
        status)   cmd_status "$@" ;;
        next)     cmd_next "$@" ;;
        help|--help|-h) cmd_help ;;
        *)
            echo "ERROR: Comando desconocido: '$cmd'" >&2
            echo "Ejecute: workflow-state.sh help" >&2
            exit 1
            ;;
    esac
}

main "$@"
