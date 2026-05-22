# Regla: Testing Obligatorio y Automático

## Principio Fundamental

**TODOS los cambios al código deben pasar por validación de tests automáticamente. NO hay excepciones.**

Esta regla garantiza que el sistema NUNCA se rompa debido a cambios en el código.

---

## 🎯 Objetivos

1. **Prevenir Regresiones:** Detectar errores antes de que lleguen a producción
2. **Garantizar Calidad:** Mantener 100% de cobertura en todo momento
3. **Automatización Total:** Tests se ejecutan sin intervención manual
4. **Tolerancia Cero:** Ningún cambio se acepta si rompe tests

---

## 🔄 Flujo Automático de Testing

### FASE 1: Antes de Editar/Escribir Código

**Hook:** `PreToolUse` (Edit/Write)

```
Claude detecta → Edit/Write tool
    ↓
VERIFICAR: ¿El cambio afecta componentes críticos?
    ↓
SI → Ejecutar tests relacionados ANTES del cambio
    ↓
Reportar cobertura actual al usuario
```

**Componentes críticos:**
- Scripts de validación (`.claude/scripts/`)
- Hooks (`.claude/hooks/`)
- Reglas (`.claude/rules/`)
- Skills (`.claude/skills/`)
- Tests existentes (`tests/`)
- Ejemplos funcionales (`A-Produccion/Ejemplos-Funcionales-Rmd/`)

### FASE 2: Después de Cambios en Código

**Hook:** `PostToolUse` (Edit/Write)

```
Claude completa → Edit/Write
    ↓
EJECUTAR automáticamente:
    1. Tests unitarios relacionados
    2. Tests de regresión
    ↓
SI TODOS PASAN → Continuar
SI ALGUNO FALLA → REVERTIR cambio automáticamente
    ↓
Reportar resultado al usuario
```

### FASE 3: Antes de Commit

**Hook:** `PreToolUse` (Bash con git commit)

```
Usuario/Claude intenta → git commit
    ↓
BLOQUEAR si:
    - Hay tests fallando
    - Cobertura < 100%
    - No se ejecutaron tests después del último cambio
    ↓
EJECUTAR suite completa:
    Rscript tests/run_all_tests.R
    ↓
SI FALLA → RECHAZAR commit + Mostrar errores
SI PASA → PERMITIR commit
```

### FASE 4: Antes de Push

**Hook:** `PreToolUse` (Bash con git push)

```
Usuario/Claude intenta → git push
    ↓
VERIFICAR:
    1. Todos los commits tienen tests pasando
    2. CI/CD está configurado
    3. No hay cambios sin commit
    ↓
EJECUTAR suite completa final
    ↓
SI FALLA → RECHAZAR push + Instrucciones de corrección
SI PASA → PERMITIR push
```

---

## 🛠️ Implementación de Hooks

### Estrategia: Git Hooks Nativos + Instrucciones Claude

Se usan **git hooks nativos** (en `.git/hooks/`) en lugar de hooks de Claude Code para evitar problemas de parsing y timeouts.

### 1. Git Pre-Commit Hook (Nativo)

**Ubicación:** `.git/hooks/pre-commit`

```bash
#!/bin/bash
# Git Pre-Commit Hook - Testing Obligatorio
# Ejecuta validaciones antes de permitir commit:
# 1. Ortografía española en archivos .Rmd
# 2. Tests de regresión (opcional, activar con PRECOMMIT_TESTS=1)

# Validación ortográfica obligatoria
RMD_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep '\.Rmd$' || true)
if [ -n "$RMD_FILES" ]; then
    for f in $RMD_FILES; do
        Rscript .claude/scripts/corregir_ortografia_espanol.R "$f" 2>/dev/null | grep -q "ERRORES" && {
            echo "❌ COMMIT RECHAZADO: Errores ortográficos en $f"
            exit 1
        }
    done
fi

# Tests opcionales (activar con PRECOMMIT_TESTS=1)
if [ "${PRECOMMIT_TESTS:-0}" = "1" ]; then
    Rscript tests/run_all_tests.R || exit 1
fi

exit 0
```

### 2. Git Pre-Push Hook (Nativo)

**Ubicación:** `.git/hooks/pre-push`

```bash
#!/bin/bash
# Git Pre-Push Hook - Validación Final
# Ejecuta suite completa de tests antes de push

# Tests obligatorios (desactivar con PREPUSH_SKIP_TESTS=1)
if [ "${PREPUSH_SKIP_TESTS:-0}" != "1" ]; then
    Rscript tests/run_all_tests.R || {
        echo "❌ PUSH RECHAZADO: Tests fallaron"
        exit 1
    }
fi

exit 0
```

### 3. Instrucciones para Claude (Regla Activa)

Claude DEBE seguir estas instrucciones antes de git commit/push:

```
ANTES DE GIT COMMIT:
1. Si hay archivos .Rmd modificados → Verificar ortografía
2. Si hay cambios en .claude/ o tests/ → Ejecutar tests de regresión
3. Usar mensaje de commit descriptivo con Co-Authored-By

ANTES DE GIT PUSH:
1. Ejecutar: Rscript tests/run_all_tests.R
2. Solo proceder si todos los tests pasan
3. Verificar que no hay cambios sin commit
```

### Comandos de Control

```bash
# Activar tests en pre-commit (por sesión)
PRECOMMIT_TESTS=1 git commit -m "mensaje"

# Activar tests en pre-commit (permanente)
git config hooks.precommit-tests true

# Desactivar tests en pre-push (por sesión)
PREPUSH_SKIP_TESTS=1 git push

# Desactivar tests en pre-push (permanente)
git config hooks.prepush-tests false
```

---

## 📋 Configuración Claude Code

**Archivo:** `.claude/settings.json`

Los hooks de Claude Code se limitan a recordatorios y validación post-exams2:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'TILDES: más ángulo función gráfica dispersión...'",
            "statusMessage": "Recordatorio de tildes"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/post-exams2-validation.sh",
            "timeout": 120,
            "statusMessage": "Validando matemática + preview visual..."
          }
        ]
      }
    ]
  }
}
```

**Nota:** Los tests pre-commit/push se manejan via git hooks nativos, no via Claude Code hooks.

---

## 🤖 Comportamiento de Claude

### Cuando Claude Edita Código

```
1. Claude detecta necesidad de Edit/Write
2. Hook PRE ejecuta tests relevantes
3. SI PASAN → Claude procede con cambio
4. Hook POST ejecuta tests de validación
5. SI FALLAN → Claude muestra error + revierte cambio automáticamente
6. Claude reporta al usuario: "Tests pasaron" o "Tests fallaron (revertido)"
```

### Cuando Usuario Hace Commit

```
1. Usuario ejecuta: git commit -m "mensaje"
2. Hook PRE-COMMIT bloquea ejecución
3. Ejecuta: Rscript tests/run_all_tests.R
4. SI FALLA → Commit rechazado + mostrar errores
5. SI PASA → Commit permitido
```

### Cuando Claude Ayuda con Commit

```
1. Claude ejecuta comando git
2. Hook intercepta comando
3. Ejecuta suite completa
4. Claude informa resultado al usuario
5. Solo procede si tests pasan
```

---

## 🚨 Mensajes de Bloqueo

### Cuando Tests Fallan en Edit

```
❌ ============================================
❌ CAMBIO BLOQUEADO - TESTS FALLARON
❌ ============================================

Archivo: .claude/scripts/validar_coherencia_matematica.R

Tests fallidos:
- test_validacion_matematica.R::test_that("Validación detecta exshuffle")

Error: expected TRUE, got FALSE

ACCIÓN REQUERIDA:
1. No se aplicó el cambio (código intacto)
2. Revisar por qué el test falló
3. Corregir la lógica
4. Volver a intentar
```

### Cuando Tests Fallan en Commit

```
❌ ============================================
❌ COMMIT RECHAZADO - TESTS FALLARON
❌ ============================================

Suite: Validación Matemática
Status: ✗ FALLIDO

Acciones requeridas:
1. Ejecutar: Rscript tests/run_all_tests.R
2. Identificar tests fallidos
3. Corregir código
4. Volver a ejecutar tests
5. Solo entonces: git commit

⚠️ PROHIBIDO: git commit --no-verify
```

---

## 📊 Métricas de Monitoreo

Claude debe reportar automáticamente:

```
═══════════════════════════════════════
  REPORTE DE TESTING AUTOMÁTICO
═══════════════════════════════════════

Última ejecución: 2026-02-04 14:30:25
Duración: 28.4 segundos

Suites ejecutadas: 6/6
✓ Exitosas: 6
✗ Fallidas: 0

Cobertura actual: 100%
Estado del sistema: ✅ SALUDABLE

Cambios validados hoy: 12
Commits bloqueados: 0
Regresiones prevenidas: 0
```

---

## 🎯 Garantías del Sistema

Con este sistema implementado, se garantiza:

1. ✅ **Ningún cambio rompedor llega a main**
2. ✅ **100% de cobertura se mantiene permanentemente**
3. ✅ **Tests se ejecutan automáticamente sin intervención**
4. ✅ **Errores se detectan ANTES de commit**
5. ✅ **Claude no puede hacer cambios que rompan tests**
6. ✅ **Usuario no puede hacer commit con tests fallando**
7. ✅ **CI/CD valida adicionalmente en remoto**

---

## ⚠️ Casos Especiales

### Actualizar Tests Mismos

```
Si se modifica un archivo test_*.R:
1. Hook ejecuta suite COMPLETA
2. Valida que el test modificado funciona
3. Valida que otros tests no se rompieron
4. Solo permite cambio si todo pasa
```

### Emergencias (PROHIBIDO)

```
❌ NUNCA usar: git commit --no-verify
❌ NUNCA deshabilitar hooks temporalmente
❌ NUNCA comentar tests que fallan

✅ SIEMPRE corregir el código
✅ SIEMPRE mantener tests funcionando
✅ SIEMPRE reportar problemas al usuario
```

---

## 📚 Referencias

- **Documentación completa:** `.claude/docs/ECOSISTEMA_TESTING.md`
- **Script ejecutor:** `tests/run_all_tests.R`
- **Suites individuales:** `tests/testthat/test_*.R`
- **CI/CD:** `.github/workflows/ci-testing.yml`
- **Hooks:** `.claude/hooks/`

---

**Versión:** 1.0
**Fecha:** 2026-02-04
**Estado:** ACTIVO Y OBLIGATORIO
**Excepciones:** NINGUNA
