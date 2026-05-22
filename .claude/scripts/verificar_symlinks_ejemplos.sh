#!/bin/bash
# Script: verificar_symlinks_ejemplos.sh
# Propósito: Verificar integridad de symlinks en Ejemplos-Funcionales-Rmd/
# Uso: ./verificar_symlinks_ejemplos.sh

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorio a verificar
EJEMPLOS_DIR="A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  VERIFICACIÓN DE SYMLINKS - Ejemplos-Funcionales-Rmd/${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Ir al directorio raíz del proyecto
cd "$(git rev-parse --show-toplevel)" || exit 1

# Verificar que existe el directorio
if [ ! -d "$EJEMPLOS_DIR" ]; then
    echo -e "${RED}✗${NC} Directorio no encontrado: $EJEMPLOS_DIR"
    exit 1
fi

echo -e "${BLUE}ℹ${NC} Verificando symlinks en $EJEMPLOS_DIR/"
echo ""

# Contadores
TOTAL_SYMLINKS=0
SYMLINKS_OK=0
SYMLINKS_ROTOS=0
ARCHIVOS_REGULARES=0

# Encontrar todos los archivos .Rmd (symlinks y regulares)
while IFS= read -r -d '' archivo; do
    archivo_rel="${archivo#./}"

    if [ -L "$archivo" ]; then
        # Es un symlink
        TOTAL_SYMLINKS=$((TOTAL_SYMLINKS + 1))

        # Verificar si apunta a un archivo válido
        if [ -f "$archivo" ]; then
            target=$(readlink "$archivo")
            echo -e "${GREEN}✓${NC} $archivo_rel"
            echo -e "  ${BLUE}→${NC} $target"
            SYMLINKS_OK=$((SYMLINKS_OK + 1))
        else
            target=$(readlink "$archivo")
            echo -e "${RED}✗${NC} $archivo_rel ${RED}[ROTO]${NC}"
            echo -e "  ${RED}→${NC} $target ${RED}(no existe)${NC}"
            SYMLINKS_ROTOS=$((SYMLINKS_ROTOS + 1))
        fi
    elif [ -f "$archivo" ]; then
        # Es un archivo regular (no symlink)
        ARCHIVOS_REGULARES=$((ARCHIVOS_REGULARES + 1))
        echo -e "${YELLOW}⚠${NC} $archivo_rel ${YELLOW}[ARCHIVO REGULAR - considerar convertir a symlink]${NC}"
    fi
done < <(find "$EJEMPLOS_DIR" -maxdepth 1 -name "*.Rmd" -print0)

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  RESUMEN${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "Total symlinks:       $TOTAL_SYMLINKS"
echo -e "${GREEN}Symlinks OK:${NC}          $SYMLINKS_OK"
echo -e "${RED}Symlinks rotos:${NC}       $SYMLINKS_ROTOS"
echo -e "${YELLOW}Archivos regulares:${NC}   $ARCHIVOS_REGULARES"
echo ""

# Resultado final
if [ $SYMLINKS_ROTOS -gt 0 ]; then
    echo -e "${RED}✗ HAY SYMLINKS ROTOS - REQUIERE ATENCIÓN${NC}"
    exit 1
elif [ $ARCHIVOS_REGULARES -gt 0 ]; then
    echo -e "${YELLOW}⚠ Hay archivos regulares que podrían convertirse a symlinks${NC}"
    echo -e "${YELLOW}  (Los archivos legacy pueden quedarse como están)${NC}"
    exit 0
else
    echo -e "${GREEN}✓ TODOS LOS SYMLINKS ESTÁN INTACTOS${NC}"
    exit 0
fi
