#!/bin/bash
# Script de Eliminación de Comando Deprecado - Fase 5
# Fecha de creación: 2025-12-20
# Fecha de ejecución programada: 2025-03-20
# Comando a eliminar: /analizar-ejercicio

set -e  # Salir si hay errores

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuración
FECHA_ACTUAL=$(date +%Y-%m-%d)
FECHA_PROGRAMADA="2025-03-20"
ARCHIVO_DEPRECADO=".claude/commands/analizar-ejercicio.md"
BACKUP_DIR=".claude/backups/fase5_${FECHA_ACTUAL}"
LOG_FILE=".claude/logs/fase5_eliminacion_${FECHA_ACTUAL}.log"

# Función de logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Función de error
error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

# Función de éxito
success() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

# Función de advertencia
warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1" | tee -a "$LOG_FILE"
}

# Función de info
info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Banner
echo -e "${BLUE}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   FASE 5: ELIMINACIÓN DE COMANDO DEPRECADO                ║"
echo "║   Comando: /analizar-ejercicio                            ║"
echo "║   Fecha programada: ${FECHA_PROGRAMADA}                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Crear directorios necesarios
mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$BACKUP_DIR"

log "Iniciando Fase 5: Eliminación de comando deprecado"

# VERIFICACIÓN 1: Verificar fecha
info "Verificando fecha de ejecución..."
if [[ "$FECHA_ACTUAL" < "$FECHA_PROGRAMADA" ]]; then
    warning "ADVERTENCIA: La fecha programada de eliminación es ${FECHA_PROGRAMADA}"
    warning "Fecha actual: ${FECHA_ACTUAL}"
    echo ""
    read -p "¿Desea continuar con la eliminación antes de tiempo? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        info "Eliminación cancelada por el usuario"
        exit 0
    fi
fi
success "Verificación de fecha completada"

# VERIFICACIÓN 2: Verificar que el archivo existe
info "Verificando existencia del archivo deprecado..."
if [[ ! -f "$ARCHIVO_DEPRECADO" ]]; then
    error "El archivo $ARCHIVO_DEPRECADO no existe"
fi
success "Archivo deprecado encontrado"

# VERIFICACIÓN 3: Verificar que no hay referencias activas
info "Verificando referencias activas al comando deprecado..."
REFERENCIAS=$(grep -r "analizar-ejercicio" .claude/ --include="*.md" 2>/dev/null | \
              grep -v "DEPRECADO" | \
              grep -v "COMANDOS_DEPRECADOS.md" | \
              grep -v "CHANGELOG.md" | \
              grep -v "fase5_eliminar_comando_deprecado.sh" | \
              wc -l)

if [[ $REFERENCIAS -gt 0 ]]; then
    warning "Se encontraron $REFERENCIAS referencias activas al comando deprecado:"
    grep -r "analizar-ejercicio" .claude/ --include="*.md" 2>/dev/null | \
        grep -v "DEPRECADO" | \
        grep -v "COMANDOS_DEPRECADOS.md" | \
        grep -v "CHANGELOG.md"
    echo ""
    read -p "¿Desea continuar con la eliminación? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        info "Eliminación cancelada por el usuario"
        exit 0
    fi
else
    success "No se encontraron referencias activas"
fi

# PASO 1: Crear backup
info "Creando backup del archivo deprecado..."
cp "$ARCHIVO_DEPRECADO" "$BACKUP_DIR/analizar-ejercicio.md.backup"
success "Backup creado en: $BACKUP_DIR/analizar-ejercicio.md.backup"

# PASO 2: Eliminar archivo
info "Eliminando archivo deprecado..."
rm "$ARCHIVO_DEPRECADO"
success "Archivo eliminado: $ARCHIVO_DEPRECADO"

# PASO 3: Actualizar COMANDOS_DEPRECADOS.md
info "Actualizando documentación de comandos deprecados..."
# Este paso se hace manualmente después del script
warning "ACCIÓN MANUAL REQUERIDA: Actualizar .claude/docs/COMANDOS_DEPRECADOS.md"
warning "  - Mover entrada de /analizar-ejercicio a sección 'Historial'"
warning "  - Actualizar estadísticas de deprecación"

# PASO 4: Actualizar CHANGELOG.md
info "Actualizando changelog..."
warning "ACCIÓN MANUAL REQUERIDA: Actualizar .claude/CHANGELOG.md"
warning "  - Agregar entrada de eliminación con fecha ${FECHA_ACTUAL}"

# PASO 5: Ejecutar tests de validación
info "Ejecutando tests de validación post-eliminación..."
bash .claude/scripts/fase5_tests_post_eliminacion.sh
if [[ $? -eq 0 ]]; then
    success "Tests de validación pasados"
else
    error "Tests de validación fallaron. Revisar logs."
fi

# Resumen final
echo ""
echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   FASE 5 COMPLETADA EXITOSAMENTE                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
log "Fase 5 completada exitosamente"

echo ""
info "Resumen de acciones:"
echo "  ✅ Archivo eliminado: $ARCHIVO_DEPRECADO"
echo "  ✅ Backup creado: $BACKUP_DIR/analizar-ejercicio.md.backup"
echo "  ✅ Tests de validación pasados"
echo ""
warning "Acciones manuales pendientes:"
echo "  ⚠️  Actualizar .claude/docs/COMANDOS_DEPRECADOS.md"
echo "  ⚠️  Actualizar .claude/CHANGELOG.md"
echo ""
info "Log completo: $LOG_FILE"

