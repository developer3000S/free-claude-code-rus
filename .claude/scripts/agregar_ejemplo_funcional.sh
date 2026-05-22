#!/bin/bash
# Script: agregar_ejemplo_funcional.sh
# Propósito: Automatizar copia de ejercicio validado a Ejemplos-Funcionales-Rmd/
# Uso: ./agregar_ejemplo_funcional.sh [ruta_ejercicio.Rmd] [codigo_id]

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de logging
info() { echo -e "${BLUE}ℹ${NC} $1"; }
success() { echo -e "${GREEN}✓${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; exit 1; }

# Verificar argumentos
if [ $# -lt 2 ]; then
    error "Uso: $0 [ruta_ejercicio.Rmd] [codigo_id]

Ejemplo:
  $0 A-Produccion/02-En-Desarrollo/ejercicio/ejercicio.Rmd EST-INT-04

Códigos válidos:
  [AREA]-[COMP]-[NUM]
  AREA: EST (Estadística), ALG (Álgebra), GEO (Geometría), FUN (Funciones)
  COMP: INT (Interpretación), FOR (Formulación), ARG (Argumentación)
  NUM: 01, 02, 03, ..."
fi

RMD_ORIGEN="$1"
CODIGO_ID="$2"
DEST_DIR="A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd"
CATALOGO="$DEST_DIR/CATALOGO.md"

# Verificar que existe el archivo origen
if [ ! -f "$RMD_ORIGEN" ]; then
    error "Archivo no encontrado: $RMD_ORIGEN"
fi

# Verificar que tiene extensión .Rmd
if [[ ! "$RMD_ORIGEN" =~ \.Rmd$ ]]; then
    error "El archivo debe tener extensión .Rmd"
fi

# Verificar formato de código
if [[ ! "$CODIGO_ID" =~ ^[A-Z]{3}-[A-Z]{3}-[0-9]{2}$ ]]; then
    error "Código inválido: $CODIGO_ID
Formato esperado: [AREA]-[COMP]-[NUM]
Ejemplo: EST-INT-01"
fi

# Verificar que no existe ya el código
if grep -q "### $CODIGO_ID:" "$CATALOGO" 2>/dev/null; then
    warning "El código $CODIGO_ID ya existe en el catálogo"
    read -p "¿Desea sobrescribir? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        info "Operación cancelada"
        exit 0
    fi
fi

info "Procesando ejercicio..."
info "  Origen: $RMD_ORIGEN"
info "  Código: $CODIGO_ID"

# Extraer nombre base del archivo
NOMBRE_BASE=$(basename "$RMD_ORIGEN")

# Copiar archivo
info "Copiando archivo a Ejemplos-Funcionales-Rmd/..."
cp "$RMD_ORIGEN" "$DEST_DIR/"
success "Archivo copiado: $DEST_DIR/$NOMBRE_BASE"

# Extraer metadatos del .Rmd
info "Extrayendo metadatos..."

# Función para extraer metadato
extraer_meta() {
    local archivo="$1"
    local campo="$2"
    grep -m 1 "^exextra\[$campo\]:" "$archivo" | sed "s/^exextra\[$campo\]: *//" || echo "N/A"
}

NIVEL=$(grep -m 1 "^exextra\[Nivel\]:" "$RMD_ORIGEN" | sed 's/^exextra\[Nivel\]: *//' || echo "N/A")
COMPETENCIA=$(extraer_meta "$RMD_ORIGEN" "Competencia")
COMPONENTE=$(extraer_meta "$RMD_ORIGEN" "Componente")
TIPO=$(grep -m 1 "^extype:" "$RMD_ORIGEN" | sed 's/^extype: *//' | tr '[:lower:]' '[:upper:]' || echo "N/A")

info "  Nivel: $NIVEL"
info "  Competencia: $COMPETENCIA"
info "  Componente: $COMPONENTE"
info "  Tipo: $TIPO"

# Pedir título descriptivo
read -p "Título descriptivo del ejercicio: " TITULO
if [ -z "$TITULO" ]; then
    error "El título no puede estar vacío"
fi

# Pedir características técnicas
info "Características técnicas (una por línea, línea vacía para terminar):"
CARACTERISTICAS=()
while true; do
    read -p "  - " CARACT
    if [ -z "$CARACT" ]; then
        break
    fi
    CARACTERISTICAS+=("$CARACT")
done

# Pedir patrones útiles
info "¿Para qué es útil este patrón? (una por línea, línea vacía para terminar):"
PATRONES=()
while true; do
    read -p "  - " PATRON
    if [ -z "$PATRON" ]; then
        break
    fi
    PATRONES+=("$PATRON")
done

# Pedir versiones únicas
read -p "Versiones únicas validadas (default: 250+): " VERSIONES
VERSIONES=${VERSIONES:-"250+"}

# Generar entrada para CATALOGO.md
info "Generando entrada para CATALOGO.md..."

ENTRADA="
---

### $CODIGO_ID: $TITULO

**Archivo**: \`$NOMBRE_BASE\`

**Metadatos**:
- **Nivel**: $NIVEL
- **Competencia**: $COMPETENCIA
- **Componente**: $COMPONENTE
- **Tipo**: $TIPO
- **Características técnicas**:
"

for caract in "${CARACTERISTICAS[@]}"; do
    ENTRADA+="  - $caract
"
done

ENTRADA+="
**Patrón útil para**:
"

for patron in "${PATRONES[@]}"; do
    ENTRADA+="- $patron
"
done

ENTRADA+="
**Versiones únicas**: $VERSIONES

"

# Mostrar preview
info "Preview de entrada a agregar:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "$ENTRADA"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

read -p "¿Agregar al catálogo? (S/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Nn]$ ]]; then
    info "Operación cancelada"
    exit 0
fi

# Detectar sección correcta según tipo
if [ "$TIPO" == "SCHOICE" ]; then
    SECCION="## 📚 SCHOICE - Ejercicios de Selección Única"
elif [ "$TIPO" == "CLOZE" ]; then
    SECCION="## 📚 CLOZE - Ejercicios Compuestos"
else
    warning "Tipo desconocido: $TIPO, agregando a SCHOICE por defecto"
    SECCION="## 📚 SCHOICE - Ejercicios de Selección Única"
fi

# Insertar entrada en CATALOGO.md
# Buscar la línea después de la sección y agregar ahí
TEMP_FILE=$(mktemp)

# Leer archivo y agregar entrada después de la sección
awk -v seccion="$SECCION" -v entrada="$ENTRADA" '
{
    print $0
    if ($0 == seccion) {
        # Encontramos la sección, imprimir entrada al final
        found = 1
    }
}
END {
    if (found) {
        print entrada
    }
}
' "$CATALOGO" > "$TEMP_FILE"

# Verificar que se agregó
if ! grep -q "$CODIGO_ID:" "$TEMP_FILE"; then
    error "No se pudo agregar la entrada al catálogo"
fi

# Reemplazar archivo original
mv "$TEMP_FILE" "$CATALOGO"
success "Entrada agregada a CATALOGO.md"

# Actualizar estadísticas
info "Actualizando estadísticas..."

# Contar ejercicios por tipo
TOTAL_RMD=$(find "$DEST_DIR" -maxdepth 1 -name "*.Rmd" | wc -l)
TOTAL_SCHOICE=$(grep -c "^extype: schoice" "$DEST_DIR"/*.Rmd 2>/dev/null || echo 0)
TOTAL_CLOZE=$(grep -c "^extype: cloze" "$DEST_DIR"/*.Rmd 2>/dev/null || echo 0)

info "  Total ejercicios: $TOTAL_RMD"
info "  SCHOICE: $TOTAL_SCHOICE"
info "  CLOZE: $TOTAL_CLOZE"

# Actualizar sección de estadísticas en CATALOGO.md
sed -i "s/^- \*\*Total ejercicios\*\*:.*/- **Total ejercicios**: $TOTAL_RMD/" "$CATALOGO"
sed -i "s/^- \*\*SCHOICE\*\*:.*/- **SCHOICE**: $TOTAL_SCHOICE/" "$CATALOGO"
sed -i "s/^- \*\*CLOZE\*\*:.*/- **CLOZE**: $TOTAL_CLOZE/" "$CATALOGO"

success "Estadísticas actualizadas"

# Resumen final
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
success "Ejercicio agregado exitosamente a Ejemplos-Funcionales-Rmd/"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
info "Código de identificación: $CODIGO_ID"
info "Archivo: $DEST_DIR/$NOMBRE_BASE"
info "Entrada en catálogo: Agregada a sección $TIPO"
echo ""
info "Próximos pasos:"
echo "  1. Verificar entrada en CATALOGO.md"
echo "  2. git add $DEST_DIR/"
echo "  3. git commit -m 'feat(ejemplos): Agregar $CODIGO_ID - $TITULO'"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
