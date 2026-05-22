#!/bin/bash
# Plan de Rollback - Fase 5
# Restaura el comando /analizar-ejercicio si la eliminación causa problemas

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuración
FECHA_ACTUAL=$(date +%Y-%m-%d)
ARCHIVO_DESTINO=".claude/commands/analizar-ejercicio.md"
LOG_FILE=".claude/logs/fase5_rollback_${FECHA_ACTUAL}.log"

# Función de logging
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
    exit 1
}

success() {
    echo -e "${GREEN}[OK]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[ADVERTENCIA]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Banner
echo -e "${YELLOW}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   PLAN DE ROLLBACK - FASE 5                               ║"
echo "║   Restaurar comando /analizar-ejercicio                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Crear directorio de logs
mkdir -p "$(dirname "$LOG_FILE")"

log "Iniciando rollback de Fase 5"

# PASO 1: Buscar backup más reciente
info "Buscando backup más reciente..."

# Buscar en directorio de backups de fase 5
BACKUP_FASE5=$(find .claude/backups/fase5_* -name "analizar-ejercicio.md.backup" 2>/dev/null | sort -r | head -1)

# Buscar en backups manuales
BACKUP_MANUAL=$(find .claude/backups/ -name "manual_backup_*.md" 2>/dev/null | sort -r | head -1)

# Determinar cuál usar
if [[ -n "$BACKUP_FASE5" ]]; then
    BACKUP_FILE="$BACKUP_FASE5"
    info "Backup de Fase 5 encontrado: $BACKUP_FILE"
elif [[ -n "$BACKUP_MANUAL" ]]; then
    BACKUP_FILE="$BACKUP_MANUAL"
    info "Backup manual encontrado: $BACKUP_FILE"
else
    error "No se encontró ningún backup. Rollback no es posible."
fi

success "Backup seleccionado: $BACKUP_FILE"

# PASO 2: Verificar que el archivo no existe actualmente
info "Verificando estado actual del archivo..."
if [[ -f "$ARCHIVO_DESTINO" ]]; then
    warning "El archivo $ARCHIVO_DESTINO ya existe"
    echo ""
    read -p "¿Desea sobrescribirlo con el backup? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        info "Rollback cancelado por el usuario"
        exit 0
    fi
    # Crear backup del archivo actual antes de sobrescribir
    BACKUP_ACTUAL=".claude/backups/pre_rollback_$(date +%Y%m%d_%H%M%S).md"
    cp "$ARCHIVO_DESTINO" "$BACKUP_ACTUAL"
    info "Backup del archivo actual creado: $BACKUP_ACTUAL"
fi

# PASO 3: Restaurar archivo desde backup
info "Restaurando archivo desde backup..."
cp "$BACKUP_FILE" "$ARCHIVO_DESTINO"
success "Archivo restaurado: $ARCHIVO_DESTINO"

# PASO 4: Verificar integridad del archivo restaurado
info "Verificando integridad del archivo restaurado..."

# Verificar que contiene marca de deprecación
if grep -q "DEPRECADO" "$ARCHIVO_DESTINO"; then
    success "Archivo contiene marca de deprecación"
else
    warning "Archivo no contiene marca de deprecación (puede ser versión antigua)"
fi

# Verificar que es un archivo markdown válido
if [[ "$ARCHIVO_DESTINO" == *.md ]]; then
    success "Archivo tiene extensión .md correcta"
else
    error "Archivo no tiene extensión .md"
fi

# PASO 5: Ejecutar tests de validación
info "Ejecutando tests de validación post-rollback..."

# Test 1: Archivo existe
if [[ -f "$ARCHIVO_DESTINO" ]]; then
    success "Test 1: Archivo existe"
else
    error "Test 1 FALLADO: Archivo no existe"
fi

# Test 2: Archivo no está vacío
if [[ -s "$ARCHIVO_DESTINO" ]]; then
    success "Test 2: Archivo no está vacío"
else
    error "Test 2 FALLADO: Archivo está vacío"
fi

# Test 3: Archivo es legible
if [[ -r "$ARCHIVO_DESTINO" ]]; then
    success "Test 3: Archivo es legible"
else
    error "Test 3 FALLADO: Archivo no es legible"
fi

# PASO 6: Actualizar documentación
warning "ACCIONES MANUALES REQUERIDAS:"
echo "  1. Actualizar .claude/CHANGELOG.md con entrada de rollback"
echo "  2. Actualizar .claude/docs/COMANDOS_DEPRECADOS.md si es necesario"
echo "  3. Notificar a usuarios sobre el rollback (si aplica)"
echo "  4. Investigar razón del rollback y documentar"

# Resumen final
echo ""
echo -e "${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║   ROLLBACK COMPLETADO EXITOSAMENTE                        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
log "Rollback completado exitosamente"

echo ""
info "Resumen de acciones:"
echo "  ✅ Backup encontrado: $BACKUP_FILE"
echo "  ✅ Archivo restaurado: $ARCHIVO_DESTINO"
echo "  ✅ Tests de validación pasados: 3/3"
echo ""
info "Log completo: $LOG_FILE"
echo ""
warning "IMPORTANTE: Investigar la razón del rollback antes de intentar"
warning "            la eliminación nuevamente."

