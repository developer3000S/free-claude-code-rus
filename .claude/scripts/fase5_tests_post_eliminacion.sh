#!/bin/bash
# Tests de Validación Post-Eliminación - Fase 5
# Ejecuta tests para verificar que la eliminación no rompió el sistema

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Contadores
TESTS_PASADOS=0
TESTS_FALLADOS=0
TOTAL_TESTS=6

# Función de test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Test: $test_name ... "
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}PASADO${NC}"
        ((TESTS_PASADOS++))
        return 0
    else
        echo -e "${RED}FALLADO${NC}"
        ((TESTS_FALLADOS++))
        return 1
    fi
}

echo "╔════════════════════════════════════════════════════════════╗"
echo "║   TESTS DE VALIDACIÓN POST-ELIMINACIÓN                    ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# TEST 1: Verificar que el archivo fue eliminado
run_test "Archivo deprecado eliminado" \
    "[ ! -f .claude/commands/analizar-ejercicio.md ]"

# TEST 2: Verificar que /analizar-icfes existe
run_test "Comando estándar /analizar-icfes existe" \
    "[ -f .claude/commands/analizar-icfes.md ]"

# TEST 3: Verificar que workflow usa /analizar-icfes
run_test "Workflow usa /analizar-icfes" \
    "grep -q 'analizar-icfes' .claude/TROUBLESHOOTING.md"

# TEST 4: Verificar que generar-schoice usa /analizar-icfes
run_test "generar-schoice usa /analizar-icfes" \
    "grep -q 'analizar-icfes' .claude/commands/generar-schoice.md"

# TEST 5: Verificar que generar-cloze usa /analizar-icfes
run_test "generar-cloze usa /analizar-icfes" \
    "grep -q 'analizar-icfes' .claude/commands/generar-cloze.md"

# TEST 6: Verificar que no hay referencias rotas
run_test "No hay referencias rotas a /analizar-ejercicio" \
    "! grep -r 'analizar-ejercicio' .claude/commands/ --include='*.md' 2>/dev/null | grep -v 'DEPRECADO' | grep -q ."

# Resumen
echo ""
echo "════════════════════════════════════════════════════════════"
echo "RESUMEN DE TESTS"
echo "════════════════════════════════════════════════════════════"
echo -e "Tests pasados: ${GREEN}${TESTS_PASADOS}/${TOTAL_TESTS}${NC}"
echo -e "Tests fallados: ${RED}${TESTS_FALLADOS}/${TOTAL_TESTS}${NC}"
echo ""

if [[ $TESTS_FALLADOS -eq 0 ]]; then
    echo -e "${GREEN}✅ TODOS LOS TESTS PASARON${NC}"
    exit 0
else
    echo -e "${RED}❌ ALGUNOS TESTS FALLARON${NC}"
    echo "Revisar los tests fallados antes de continuar"
    exit 1
fi

