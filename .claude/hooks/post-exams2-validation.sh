#!/bin/bash
# =============================================================================
# post-exams2-validation.sh (v6.1)
# Hook PostToolUse: ARSENAL COMPLETO DE VALIDACIONES POST-RENDERIZADO
#
# Se activa AUTOMÁTICAMENTE después de CADA comando Bash que contenga exams2*
# Ejecuta TODAS las validaciones SIN EXCEPCIÓN:
#
# FASE 2A: Coherencia Matemática (.R script)
# FASE 2B: Preview Visual (PDF → PNG)
# FASE 2C: Opciones Únicas (gráficos diferentes)
# FASE 2D: Ortografía Española (tildes)
# FASE 2E: Metadatos ICFES (6 dimensiones)
# FASE 2F: Estructura Metacognitiva (Solution completa)
# FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5)
# FASE 2H: Stress Test Visual (10 semillas, renderizado real + PNGs)
# FASE 2I: Detección \pandocbounded en .tex y `![]()` sin width en .Rmd (Errores 16-17)
# FASE 2J: Letter-independence en Solution (Error 19)
# FASE 2K: Anti-multiply-defined labels — headings sin {-} en Solution (Error 21)
#
# GARANTÍA: Toda renderización activa TODAS las fases
# PERMANENTE: No hay forma de saltarse estas validaciones
# =============================================================================

set -o pipefail

# Leer JSON de stdin
INPUT=$(cat)

# Extraer el comando ejecutado usando Python
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    cmd = data.get('tool_input', {}).get('command', '')
    print(cmd)
except:
    pass
" 2>/dev/null)

# Si no hay comando, salir silenciosamente
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Solo proceder si el comando contiene exams2
if ! echo "$COMMAND" | grep -q 'exams2'; then
  exit 0
fi

# Extraer directorio de trabajo
CWD=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('cwd', ''))
except:
    pass
" 2>/dev/null)

if [ -z "$CWD" ]; then
  CWD="$(pwd)"
fi

# Extraer nombre del archivo .Rmd del comando
RMD_FILE=$(echo "$COMMAND" | grep -oP 'exams2\w+\(\s*"[^"]*\.Rmd"' | head -1 | grep -oP '"[^"]*\.Rmd"' | tr -d '"')

if [ -z "$RMD_FILE" ]; then
  RMD_FILE=$(echo "$COMMAND" | grep -oP "exams2\w+\(\s*'[^']*\.Rmd'" | head -1 | grep -oP "'[^']*\.Rmd'" | tr -d "'")
fi

if [ -z "$RMD_FILE" ]; then
  exit 0
fi

# Determinar ruta del proyecto
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null)}"
if [ -z "$PROJECT_DIR" ]; then
  exit 0
fi

# Construir ruta completa del .Rmd
if [[ "$RMD_FILE" = /* ]]; then
  RMD_PATH="$RMD_FILE"
else
  RMD_PATH="$CWD/$RMD_FILE"
fi

if [ ! -f "$RMD_PATH" ]; then
  exit 0
fi

RMD_BASENAME=$(basename "$RMD_FILE" .Rmd)

# =============================================================================
# ENCABEZADO DEL ARSENAL
# =============================================================================

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  ARSENAL COMPLETO DE VALIDACIONES POST-RENDERIZADO            ║"
echo "║  Activado automáticamente - NO HAY FORMA DE SALTARLO          ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo "║  Archivo: $(printf '%-52s' "$RMD_BASENAME.Rmd")║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

ERRORES_TOTALES=0
ADVERTENCIAS_TOTALES=0

# =============================================================================
# FASE 2A: VALIDACIÓN DE COHERENCIA MATEMÁTICA
# =============================================================================

SCRIPT_MATH="$PROJECT_DIR/.claude/scripts/validar_coherencia_matematica.R"

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│ FASE 2A: Coherencia Matemática                                │"
echo "└───────────────────────────────────────────────────────────────┘"

if [ -f "$SCRIPT_MATH" ]; then
  MATH_OUTPUT=$(cd "$CWD" && Rscript "$SCRIPT_MATH" "$RMD_FILE" 2>&1)
  MATH_EXIT=$?

  if [ $MATH_EXIT -eq 0 ]; then
    echo "  ✓ APROBADO"
    echo "$MATH_OUTPUT" | grep -E "✓|APROBADO" | head -5
  else
    echo "  ❌ ERRORES DETECTADOS"
    echo "$MATH_OUTPUT" | tail -10
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
  fi
else
  echo "  ⚠️  Script no encontrado: validar_coherencia_matematica.R"
  ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
fi

echo ""

# =============================================================================
# FASE 2B: GENERACIÓN DE PREVIEW VISUAL
# =============================================================================

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│ FASE 2B: Preview Visual (PDF → PNG)                           │"
echo "└───────────────────────────────────────────────────────────────┘"

# Buscar PDF generado
PDF_DIR=$(echo "$COMMAND" | grep -oP 'dir\s*=\s*"[^"]*"' | head -1 | grep -oP '"[^"]*"' | tr -d '"')
if [ -z "$PDF_DIR" ]; then
  PDF_DIR=$(echo "$COMMAND" | grep -oP "dir\s*=\s*'[^']*'" | head -1 | grep -oP "'[^']*'" | tr -d "'")
fi

PDF_FOUND=""
SEARCH_DIRS=()

if [ -n "$PDF_DIR" ]; then
  if [[ "$PDF_DIR" = /* ]]; then
    SEARCH_DIRS+=("$PDF_DIR")
  else
    SEARCH_DIRS+=("$CWD/$PDF_DIR")
  fi
fi

SEARCH_DIRS+=("$CWD/output_pdf" "$CWD/output_pdf_test" "$CWD/output" "$CWD")

for DIR in "${SEARCH_DIRS[@]}"; do
  if [ -d "$DIR" ]; then
    CANDIDATE=$(find "$DIR" -maxdepth 1 -name "*.pdf" -type f -mmin -5 2>/dev/null | head -1)
    if [ -n "$CANDIDATE" ] && [ -f "$CANDIDATE" ]; then
      PDF_FOUND="$CANDIDATE"
      break
    fi
  fi
done

if [ -n "$PDF_FOUND" ]; then
  PREVIEW_PNG="$CWD/preview_${RMD_BASENAME}.png"

  if command -v magick &>/dev/null; then
    magick -density 150 "$PDF_FOUND" -quality 90 "$PREVIEW_PNG" 2>/dev/null
    MAGICK_EXIT=$?

    if [ $MAGICK_EXIT -eq 0 ]; then
      NUM_PAGES=$(ls -1 "${CWD}/preview_${RMD_BASENAME}"*.png 2>/dev/null | wc -l)
      echo "  ✓ Preview generado: $NUM_PAGES página(s)"
      ls -1 "${CWD}/preview_${RMD_BASENAME}"*.png 2>/dev/null | while read f; do
        echo "    → $(basename "$f")"
      done
    else
      echo "  ❌ Error al convertir PDF a PNG"
      ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
    fi
  else
    echo "  ⚠️  magick no instalado - preview manual requerido"
    ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
  fi
else
  echo "  ⚠️  PDF no encontrado - ejecutar exams2pdf() primero"
  ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
fi

echo ""

# =============================================================================
# FASES 2C-2F: ARSENAL COMPLETO DE VALIDACIÓN
# =============================================================================

SCRIPT_ARSENAL="$PROJECT_DIR/.claude/scripts/arsenal_validacion_completa.R"

if [ -f "$SCRIPT_ARSENAL" ]; then
  echo "┌───────────────────────────────────────────────────────────────┐"
  echo "│ FASES 2C-2F: Arsenal Completo                                 │"
  echo "└───────────────────────────────────────────────────────────────┘"

  ARSENAL_OUTPUT=$(cd "$CWD" && Rscript "$SCRIPT_ARSENAL" "$RMD_FILE" 2>&1)
  ARSENAL_EXIT=$?

  # Mostrar salida filtrada
  echo "$ARSENAL_OUTPUT" | grep -E "FASE|✓|❌|⚠️|ERROR|ADVERTENCIA|Total|VALIDACIÓN"

  # Preferir el conteo reportado por el script; si no lo reporta, fallback a +1 por exit!=0
  ARSENAL_ERRORES=$(echo "$ARSENAL_OUTPUT" | grep "Total ERRORES:" | grep -oP '\d+' | tail -1)
  ARSENAL_ADVERTENCIAS=$(echo "$ARSENAL_OUTPUT" | grep "Total ADVERTENCIAS:" | grep -oP '\d+' | tail -1)

  if [ -n "$ARSENAL_ERRORES" ]; then
    ERRORES_TOTALES=$((ERRORES_TOTALES + ARSENAL_ERRORES))
  elif [ $ARSENAL_EXIT -ne 0 ]; then
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
  fi

  if [ -n "$ARSENAL_ADVERTENCIAS" ]; then
    ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + ARSENAL_ADVERTENCIAS))
  fi
else
  echo "  ⚠️  Script arsenal no encontrado"
  ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
fi

echo ""

# =============================================================================
# FASE 2G: VALIDACIÓN MULTI-SEMILLA RÁPIDA (Nivel 5)
# =============================================================================

SCRIPT_MULTISEMILLA="$PROJECT_DIR/.claude/scripts/validar_multisemilla.R"

if [ -f "$SCRIPT_MULTISEMILLA" ] && [ $ERRORES_TOTALES -eq 0 ]; then
  echo "┌───────────────────────────────────────────────────────────────┐"
  echo "│ FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5)          │"
  echo "└───────────────────────────────────────────────────────────────┘"

  MULTISEED_OUTPUT=$(cd "$CWD" && Rscript "$SCRIPT_MULTISEMILLA" "$RMD_FILE" --n 20 2>&1)
  MULTISEED_EXIT=$?

  echo "$MULTISEED_OUTPUT" | grep -E "Semillas|Fallos|Tasa|RESULTADO|ERR_ANS|ERR_SEM"

  if [ $MULTISEED_EXIT -ne 0 ]; then
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
    echo "  ❌ Multi-semilla: FALLOS detectados en alguna(s) semilla(s)"
  else
    echo "  ✓ Multi-semilla: 20/20 semillas aprobadas"
  fi
elif [ $ERRORES_TOTALES -gt 0 ]; then
  echo "  ⚠️  Multi-semilla omitida (hay errores previos que resolver primero)"
fi

echo ""

# =============================================================================
# FASE 2H: STRESS TEST VISUAL MULTI-SEMILLA
# =============================================================================

SCRIPT_STRESS_TEST="$PROJECT_DIR/SOURCES/scripts_validacion/stress_test_visual.R"

if [ -f "$SCRIPT_STRESS_TEST" ] && [ $ERRORES_TOTALES -eq 0 ]; then
  echo "┌───────────────────────────────────────────────────────────────┐"
  echo "│ FASE 2H: Stress Test Visual (10 semillas, renderizado + PNGs) │"
  echo "└───────────────────────────────────────────────────────────────┘"

  STRESS_OUTPUT_DIR="$CWD/stress_test_output"
  STRESS_OUTPUT=$(cd "$CWD" && Rscript "$SCRIPT_STRESS_TEST" "$RMD_FILE" --n 10 --output-dir "$STRESS_OUTPUT_DIR" 2>&1)
  STRESS_EXIT=$?

  echo "$STRESS_OUTPUT" | grep -E "Semillas|Anomalías|VEREDICTO|PASA|FALLA|ADVERTENCIA|sospechosas"

  if [ $STRESS_EXIT -ne 0 ]; then
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
    echo "  ❌ Stress Test Visual: ANOMALÍAS detectadas"
    echo ""
    echo "  Claude DEBE:"
    echo "  1. Read(\"$STRESS_OUTPUT_DIR/reporte.json\") para ver anomalías"
    echo "  2. Read() CADA PNG en $STRESS_OUTPUT_DIR/pngs/ de semillas sospechosas"
    echo "  3. Verificar visualmente los problemas reportados"
  else
    echo "  ✓ Stress Test Visual: Sin anomalías críticas"
  fi
elif [ $ERRORES_TOTALES -gt 0 ]; then
  echo "  ⚠️  Stress Test Visual omitido (hay errores previos que resolver primero)"
fi

echo ""

# =============================================================================
# FASE 2I: ANTI-PANDOCBOUNDED + COHERENCIA SOLUTION (Errores 16-17, regla #18)
# =============================================================================

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│ FASE 2I: Anti-\\pandocbounded + coherencia Solution (E16-E17)  │"
echo "└───────────────────────────────────────────────────────────────┘"

PANDOC_BUG_FOUND=0
SOL_BUG_FOUND=0

# 2I.1 — Markdown sin width en el .Rmd (estático)
if [ -f "$RMD_FILE" ]; then
  # Patrón: !\[...\](...\.png) sin {width=...} inmediatamente después
  IMG_HITS=$(grep -nE '!\[[^]]*\]\([^)]+\.(png|jpe?g|svg|pdf)\)' "$RMD_FILE" | \
             grep -vE '!\[[^]]*\]\([^)]+\.(png|jpe?g|svg|pdf)\)\{[^}]*width' || true)
  # Excluir comentarios R puros
  IMG_HITS=$(echo "$IMG_HITS" | grep -vE '^[0-9]+:\s*#' || true)
  if [ -n "$IMG_HITS" ]; then
    PANDOC_BUG_FOUND=1
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
    echo "  ❌ ERROR 16: Markdown sin atributo {width=...} (causará \\pandocbounded en PDF)"
    echo "$IMG_HITS" | sed 's/^/     /'
    echo ""
    echo "     Fix: reemplazar \`![](file.png)\` por \`cat(\"![](file.png){width=80%}\\\\n\")\` en bloque R"
    echo "     Ver .claude/rules/markdown-imagenes-pdf.md"
  fi
fi

# 2I.2 — \pandocbounded en .tex generados durante este render
TEX_FILES=$(find "$CWD" -maxdepth 4 -name "*.tex" -newer "$RMD_FILE" 2>/dev/null)
if [ -n "$TEX_FILES" ]; then
  for tex in $TEX_FILES; do
    if grep -l 'pandocbounded' "$tex" >/dev/null 2>&1; then
      PANDOC_BUG_FOUND=1
      ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
      echo "  ❌ ERROR 16: \\pandocbounded encontrado en $(basename "$tex")"
    fi
  done
fi

# 2I.3 — exshuffle: TRUE + Solution con letra explícita (estático)
if [ -f "$RMD_FILE" ]; then
  HAS_EXSHUFFLE_TRUE=$(grep -E '^[[:space:]]*exshuffle[[:space:]]*:[[:space:]]*TRUE' "$RMD_FILE" | head -1)
  HAS_LETRA_REF=$(grep -nE '`r[[:space:]]+letra_correcta[[:space:]]*`|Opci[oó]n[[:space:]]+\*\*[A-D]\*\*|Opci[oó]n[[:space:]]+[A-D][[:space:]]*\(?CORRECTA' "$RMD_FILE" | head -3)

  if [ -n "$HAS_EXSHUFFLE_TRUE" ] && [ -n "$HAS_LETRA_REF" ]; then
    SOL_BUG_FOUND=1
    ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
    echo "  ❌ ERROR 17: exshuffle:TRUE combinado con Solution que referencia letra explícita"
    echo "     exshuffle: $HAS_EXSHUFFLE_TRUE"
    echo "     Solution refs:"
    echo "$HAS_LETRA_REF" | sed 's/^/       /'
    echo ""
    echo "     Fix: cambiar a \`exshuffle: FALSE\` + mezcla interna con sample()"
    echo "     Ver .claude/rules/codigo-rmd.md regla #6 + graficos-como-opciones.md"
  fi
fi

if [ $PANDOC_BUG_FOUND -eq 0 ] && [ $SOL_BUG_FOUND -eq 0 ]; then
  echo "  ✓ FASE 2I: sin patrones de Error 16/17 detectados"
fi

echo ""

# =============================================================================
# FASE 2J: LETTER-INDEPENDENCE EN SOLUTION (Error 19, regla #19)
# =============================================================================
# Defensa permanente: Solution NUNCA debe referenciar letra/posicion de opcion.
# Aplica INDEPENDIENTEMENTE del valor de exshuffle (Moodle puede re-shufflear).

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│ FASE 2J: Letter-independence en Solution (E19, regla #19)     │"
echo "└───────────────────────────────────────────────────────────────┘"

LETRA_BUG_FOUND=0

if [ -f "$RMD_FILE" ]; then
  # Extraer SOLO la seccion Solution (entre 'Solution' y 'Meta-information')
  SOL_BLOCK=$(awk '
    /^Solution[[:space:]]*$/ { in_sol = 1; next }
    /^Meta-information[[:space:]]*$/ { in_sol = 0 }
    in_sol == 1 { print NR ":" $0 }
  ' "$RMD_FILE")

  if [ -n "$SOL_BLOCK" ]; then
    # P1+P2: backtick-r letra_correcta o letras[...]
    P1_HITS=$(echo "$SOL_BLOCK" | grep -E '`r[[:space:]]+(letra_correcta|letras\[)' || true)
    if [ -n "$P1_HITS" ]; then
      LETRA_BUG_FOUND=1
      ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
      echo "  ❌ ERR_SOL_LETRA_R: Solution interpola letra_correcta o letras[...]"
      echo "$P1_HITS" | sed 's/^/     /'
    fi

    # P3: cat("**Opcion ", l, ...) — emision dinamica con variable de letra
    P3_HITS=$(echo "$SOL_BLOCK" | grep -E 'cat\([^)]*"\*?\*?Opci[oó]n[[:space:]]+",[[:space:]]*l[[:space:],)]' || true)
    if [ -n "$P3_HITS" ]; then
      LETRA_BUG_FOUND=1
      ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
      echo "  ❌ ERR_SOL_LETRA_CAT: chunk R emite 'Opción ' con variable de letra"
      echo "$P3_HITS" | sed 's/^/     /'
    fi

    # P4: literal "Opcion A/B/C/D" en Markdown (no dentro de backticks de codigo)
    # Filtrar lineas que parecen ser parte de codigo R (cat con error$codigo, etc)
    P4_HITS=$(echo "$SOL_BLOCK" | grep -E '(^|[^`])(\*\*)?Opci[oó]n[[:space:]]+[A-D]\b' || true)
    # Excluir matches dentro de strings de codigo R que construyen prosa generica
    P4_HITS=$(echo "$P4_HITS" | grep -vE 'descripcion_corta|descripcion_larga|err\$' || true)
    if [ -n "$P4_HITS" ]; then
      LETRA_BUG_FOUND=1
      ERRORES_TOTALES=$((ERRORES_TOTALES + 1))
      echo "  ❌ ERR_SOL_LETRA_LITERAL: Solution menciona 'Opción [A-D]' literal"
      echo "$P4_HITS" | sed 's/^/     /'
    fi

    if [ $LETRA_BUG_FOUND -gt 0 ]; then
      echo ""
      echo "     Fix obligatorio (regla #19, sin excepciones):"
      echo "       1. Quitar 'Opción \`r letra_correcta\`' de headers de Solution"
      echo "       2. Identificar la opción correcta por contenido o codigo de error"
      echo "          (ej: cita de descripcion_corta + codigo GRAF-ARG-NN)"
      echo "       3. En for loop de distractores, NO emitir 'Opcion <letra>'"
      echo "          Reemplazar por '<codigo> — <nombre>'"
      echo ""
      echo "     Ver .claude/rules/solution-letter-independence.md"
      echo "     Razon: Moodle (y otros LMS) puede re-shufflear las opciones"
      echo "            INDEPENDIENTEMENTE de exshuffle:FALSE de R-exams, rompiendo"
      echo "            la coherencia letra <-> contenido para el estudiante."
    else
      echo "  ✓ FASE 2J: Solution es letter-independent (regla #19)"
    fi
  else
    echo "  ⊘ FASE 2J: no se encontro seccion Solution en el .Rmd"
  fi
fi

echo ""

# =============================================================================
# FASE 2K: ANTI-MULTIPLY-DEFINED LABELS EN SOLUTION (Error 21)
# =============================================================================
# Detecta headings Markdown (###) en cat() dentro de la seccion Solution
# que causan "multiply-defined labels" cuando exams2pdf() genera n > 1.
#
# PROBLEMA: El pipeline R-exams para PDF (knitr → HTML → tth → LaTeX)
# convierte <h3> a \subsection{} que genera \label{} en LaTeX.
# Con n copias del examen en un solo PDF, los labels se duplican.
#
# EL MODIFICADOR {-} DE PANDOC NO FUNCIONA: tth no lo reconoce.
# Fix REAL: reemplazar "### Titulo {-}" por "**Titulo**" (negrita markdown)
# que no genera labels LaTeX en ningun formato.
# =============================================================================

echo "┌───────────────────────────────────────────────────────────────┐"
echo "│ FASE 2K: Anti-multiply-defined labels (E21)                   │"
echo "└───────────────────────────────────────────────────────────────┘"

LABEL_BUG_FOUND=0

if [ -f "$RMD_FILE" ]; then
  SOL_BLOCK_2K=$(awk '
    /^Solution[[:space:]]*$/ { in_sol = 1; next }
    /^Meta-information[[:space:]]*$/ { in_sol = 0 }
    in_sol == 1 { print NR ":" $0 }
  ' "$RMD_FILE")

  if [ -n "$SOL_BLOCK_2K" ]; then
    # Detectar lineas con ### headings en cat() dentro de Solution
    # El modificador {-} NO previene el bug en pipeline tth → detectar AMBOS casos
    HEADING_HITS=$(echo "$SOL_BLOCK_2K" | grep -E 'cat\("###' | grep -vE '^[[:space:]]*#' || true)

    if [ -n "$HEADING_HITS" ]; then
      LABEL_BUG_FOUND=1
      ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
      echo "  ⚠️  WARN_LATEX_LABEL: headings ### en cat() dentro de Solution"
      echo "     Estos headings causan \"multiply-defined labels\" LaTeX"
      echo "     cuando exams2pdf() genera mas de 1 copia (n > 1)."
      echo "     NOTA: {-} NO soluciona este bug (tth no lo reconoce)."
      echo ""
      echo "     Headings detectados:"
      echo "$HEADING_HITS" | sed 's/^/       /'
      echo ""
      echo "     Fix REAL (verificado 2026-05-17):"
      echo "       cat(\"### Titulo {-}\\n\\n\") → cat(\"**Titulo**\\n\\n\")"
      echo "       La negrita markdown NO genera labels LaTeX."
    fi
  fi
fi

# Tambien verificar .log de LaTeX si existe (deteccion posterior al hecho)
if [ -z "$HEADING_HITS" ] && [ -n "$PDF_FOUND" ]; then
  LOG_DIR=$(dirname "$PDF_FOUND")
  LOG_CANDIDATE=$(find "$LOG_DIR" -maxdepth 1 -name "*.log" -type f -mmin -5 2>/dev/null | head -1)
  if [ -n "$LOG_CANDIDATE" ] && grep -q 'multiply[ -]defined' "$LOG_CANDIDATE" 2>/dev/null; then
    LABEL_BUG_FOUND=1
    ADVERTENCIAS_TOTALES=$((ADVERTENCIAS_TOTALES + 1))
    echo "  ⚠️  WARN_LATEX_LABEL: multiply-defined labels detectado en .log"
    echo "     Reemplazar headings ### en Solution por **texto** (negrita)"
  fi
fi

if [ $LABEL_BUG_FOUND -eq 0 ]; then
  echo "  ✓ FASE 2K: sin headings ### en Solution (sin riesgo E21)"
fi

echo ""

# =============================================================================
# RESUMEN FINAL Y ACCIONES OBLIGATORIAS
# =============================================================================

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  RESUMEN FINAL DEL ARSENAL                                    ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
printf "║  Errores totales:      %-37s║\n" "$ERRORES_TOTALES"
printf "║  Advertencias totales: %-37s║\n" "$ADVERTENCIAS_TOTALES"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

if [ $ERRORES_TOTALES -gt 0 ]; then
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║  ❌ VALIDACIÓN FALLIDA - CORRECCIÓN OBLIGATORIA               ║"
  echo "╠═══════════════════════════════════════════════════════════════╣"
  echo "║  Claude DEBE:                                                 ║"
  echo "║  1. Corregir TODOS los errores reportados arriba              ║"
  echo "║  2. Volver a renderizar                                       ║"
  echo "║  3. El arsenal se ejecutará automáticamente de nuevo          ║"
  echo "║                                                               ║"
  echo "║  PROHIBIDO: Continuar sin resolver errores                    ║"
  echo "║  PROHIBIDO: Marcar como 'completado' con errores              ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
elif [ $ADVERTENCIAS_TOTALES -gt 0 ]; then
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║  ⚠️  VALIDACIÓN CON ADVERTENCIAS                              ║"
  echo "╠═══════════════════════════════════════════════════════════════╣"
  echo "║  Claude DEBE:                                                 ║"
  echo "║  1. Revisar TODAS las advertencias                            ║"
  echo "║  2. Ejecutar Read() sobre CADA preview PNG generado           ║"
  echo "║  3. Verificar las 5 coherencias VISUALMENTE                   ║"
  echo "║  4. Documentar hallazgos con checklist                        ║"
  echo "║  5. Solicitar aprobación del usuario                          ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
else
  echo "╔═══════════════════════════════════════════════════════════════╗"
  echo "║  ✓ ARSENAL COMPLETO APROBADO                                  ║"
  echo "╠═══════════════════════════════════════════════════════════════╣"
  echo "║  Claude DEBE aún:                                             ║"
  echo "║  1. Ejecutar Read() sobre CADA preview PNG                    ║"
  echo "║  2. Verificar las 5 coherencias VISUALMENTE                   ║"
  echo "║  3. Documentar con checklist                                  ║"
  echo "║  4. Solicitar aprobación del usuario                          ║"
  echo "║                                                               ║"
  echo "║  PROHIBIDO: Decir 'todo correcto' sin mostrar imágenes        ║"
  echo "╚═══════════════════════════════════════════════════════════════╝"
fi

echo ""
echo "───────────────────────────────────────────────────────────────"
echo "Previews a inspeccionar:"
ls -1 "${CWD}/preview_${RMD_BASENAME}"*.png 2>/dev/null || echo "  (ninguno generado)"
echo "───────────────────────────────────────────────────────────────"
echo ""

# =============================================================================
# NUDGE: SIGUIENTE PASO DEL WORKFLOW (si existe ejercicio_state.json)
# =============================================================================
STATE_FILE="${CWD}/ejercicio_state.json"
if [ -f "$STATE_FILE" ]; then
  # Auto-marcar renderizado y arsenal como completados
  WORKFLOW_SCRIPT="$PROJECT_DIR/.claude/scripts/workflow-state.sh"
  if [ -f "$WORKFLOW_SCRIPT" ] && [ $ERRORES_TOTALES -eq 0 ]; then
    bash "$WORKFLOW_SCRIPT" complete "$CWD" renderizado_4_formatos 2>/dev/null
    bash "$WORKFLOW_SCRIPT" complete "$CWD" arsenal_post_render 2>/dev/null
  fi

  NEXT_STEP=$(bash "$WORKFLOW_SCRIPT" next "$CWD" 2>/dev/null)
  if [ -n "$NEXT_STEP" ]; then
    echo "╔═══════════════════════════════════════════════════════════════╗"
    echo "║  SIGUIENTE PASO OBLIGATORIO DEL WORKFLOW                     ║"
    echo "╠═══════════════════════════════════════════════════════════════╣"
    printf "║  %-60s║\n" "$NEXT_STEP"
    echo "╚═══════════════════════════════════════════════════════════════╝"
    echo ""
  fi
fi

exit 0
