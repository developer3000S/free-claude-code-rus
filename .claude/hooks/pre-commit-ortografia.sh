#!/bin/bash
# Hook BLOQUEANTE: Rechaza commits con errores ortográficos
# Instalación: cp .claude/hooks/pre-commit-ortografia.sh .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
#
# Estrategia en dos capas:
#   Capa 1 (Python): diccionario extenso ~500+ palabras, detecta errores en strings R
#   Capa 2 (R): fallback para compatibilidad, diccionario ~140 palabras
#
# Ver: .claude/rules/ortografia-espanol.md
#      .claude/scripts/corregir_ortografia_espanol.py (v2.0, 2026-05-18)
#      .claude/scripts/corregir_ortografia_espanol.R (v1.0 legacy)

RMD_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.Rmd$')
[ -z "$RMD_FILES" ] && exit 0

ERRORES=0

for f in $RMD_FILES; do
    [ ! -f "$f" ] && continue

    # Capa 1: checker Python (diccionario extenso, ~500+ palabras)
    PYSCRIPT=".claude/scripts/corregir_ortografia_espanol.py"
    if [ -f "$PYSCRIPT" ]; then
        if python3 "$PYSCRIPT" "$f" 2>/dev/null | grep -q "ERRORES ORTOGRÁFICOS ENCONTRADOS"; then
            ERRORES=1
            echo "   ❌ $f: errores ortográficos (Python)"
        fi
    fi

    # Capa 2: checker R (legacy, solo informativo — NO bloquea)
    RSCRIPT=".claude/scripts/corregir_ortografia_espanol.R"
    if [ -f "$RSCRIPT" ] && [ $ERRORES -eq 0 ]; then
        if Rscript "$RSCRIPT" "$f" 2>/dev/null | grep -q "ERRORES"; then
            echo "   ⚠ $f: posibles errores adicionales (verificar con R checker legacy)"
        fi
    fi
done

if [ $ERRORES -eq 1 ]; then
    echo ""
    echo "❌ COMMIT RECHAZADO: Errores ortográficos detectados"
    echo "   Corregir con: python3 .claude/scripts/corregir_ortografia_espanol.py <archivo> --fix"
    echo "   O:           Rscript .claude/scripts/corregir_ortografia_espanol.R <archivo> --fix"
    exit 1
fi
exit 0
