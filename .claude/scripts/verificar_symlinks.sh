#!/bin/bash
# =============================================================================
# verificar_symlinks.sh
# Verifica la integridad de todos los symlinks en el proyecto
# =============================================================================

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

echo "═══════════════════════════════════════"
echo "  VERIFICACIÓN DE SYMLINKS"
echo "═══════════════════════════════════════"
echo ""

# Contador de symlinks
total_symlinks=0
broken_symlinks=0
valid_symlinks=0

# Encontrar todos los symlinks (excluyendo dependencias)
echo "📋 Escaneando symlinks en el proyecto..."

# Obtener lista de symlinks
SYMLINKS=$(find . -type l 2>/dev/null | grep -v -E '(node_modules|renv|\.cursor|\.venv|\.mcps|Auxiliares)')

if [ -z "$SYMLINKS" ]; then
    echo "No se encontraron symlinks en el proyecto."
    exit 0
fi

# Procesar cada symlink
echo "$SYMLINKS" | while read -r symlink; do
    ((total_symlinks++))

    # Verificar si el symlink está roto
    if [ ! -e "$symlink" ]; then
        ((broken_symlinks++))
        echo "❌ ROTO: $symlink"
        target=$(readlink "$symlink" 2>/dev/null || echo "desconocido")
        echo "   → Apunta a: $target (no existe)"
    else
        ((valid_symlinks++))
        target=$(readlink "$symlink")
        echo "✅ OK: $symlink"
        echo "   → $target"
    fi
done

# Contar totales fuera del while
total_symlinks=$(echo "$SYMLINKS" | wc -l)
broken_symlinks=$(echo "$SYMLINKS" | while read s; do [ ! -e "$s" ] && echo "$s"; done | wc -l)
valid_symlinks=$((total_symlinks - broken_symlinks))

echo ""
echo "═══════════════════════════════════════"
echo "  RESUMEN"
echo "═══════════════════════════════════════"
echo "Total de symlinks: $total_symlinks"
echo "Symlinks válidos:  $valid_symlinks"
echo "Symlinks rotos:    $broken_symlinks"
echo ""

if [ $broken_symlinks -gt 0 ]; then
    echo "❌ Se encontraron $broken_symlinks symlinks rotos"
    echo ""
    echo "Para reparar symlinks rotos:"
    echo "1. Verificar que el archivo original existe en SOURCES/"
    echo "2. Recrear el symlink con: ln -s <ruta-relativa> <nombre-symlink>"
    echo "3. Volver a ejecutar este script"
    exit 1
else
    echo "✅ Todos los symlinks están intactos"
    exit 0
fi
