# 🧪 Tests de Validación de Comandos - Workflow ICFES

Este documento contiene los tests de validación para verificar la integridad del sistema de comandos después de la consolidación.

---

## 📋 Test Suite: Consolidación de Comandos de Análisis

**Fecha de ejecución:** 2025-12-20  
**Objetivo:** Verificar que la consolidación de `/analizar-ejercicio` en `/analizar-icfes` no rompe el workflow

---

## Test 1: Workflow Completo con `/analizar-icfes`

**Objetivo:** Verificar que el workflow oficial funciona correctamente con el comando estándar

### Pasos de Ejecución

```bash
# 1. Verificar que el comando existe
ls -la .claude/commands/analizar-icfes.md

# 2. Verificar contenido del comando
cat .claude/commands/analizar-icfes.md | head -15

# 3. Verificar que tiene las 6 dimensiones
grep -E "(Nivel|Competencia|Componente|Pensamiento|Contenido|Eje)" .claude/commands/analizar-icfes.md
```

### Criterios de Éxito

- ✅ Archivo `.claude/commands/analizar-icfes.md` existe
- ✅ Comando documenta las 6 dimensiones ICFES
- ✅ Incluye decisión de Flujo A/B
- ✅ Referencia al Mermaid Chart presente

### Resultado Esperado

```

1. **Nivel de Dificultad**: (1-4).
2. **Competencia**: (Interpretación, Formulación, Argumentación).
3. **Componente**: (Numérico, Geométrico, Aleatorio).
4. **Pensamiento**: (Numérico, Espacial, Métrico, Variacional, Aleatorio).
5. **Contenido**: (Álgebra, Geometría, Estadística).
6. **Eje**: (Matemático, Aplicado).
```

---

## Test 2: Verificar Deprecación de `/analizar-ejercicio`

**Objetivo:** Confirmar que el comando deprecado muestra aviso correcto

### Pasos de Ejecución

```bash
# 1. Verificar que el archivo existe (no eliminado)
ls -la .claude/commands/analizar-ejercicio.md

# 2. Verificar que tiene marca de deprecación
grep "DEPRECADO" .claude/commands/analizar-ejercicio.md

# 3. Verificar que sugiere alternativa
grep "analizar-icfes" .claude/commands/analizar-ejercicio.md

# 4. Verificar metadata de deprecación
grep -E "(deprecated|replacement)" .claude/commands/analizar-ejercicio.md
```

### Criterios de Éxito

- ✅ Archivo existe (no eliminado)
- ✅ Contiene aviso "DEPRECADO" visible
- ✅ Sugiere usar `/analizar-icfes`
- ✅ Metadata YAML incluye `deprecated: true`
- ✅ Metadata YAML incluye `replacement: /analizar-icfes`

### Resultado Esperado

```yaml
---
description: ⚠️ DEPRECADO - Usar /analizar-icfes en su lugar
deprecated: true
replacement: /analizar-icfes
---
```

---

## Test 3: Integridad de Referencias en Documentación

**Objetivo:** Verificar que no hay referencias rotas y que el workflow usa el comando correcto

### Pasos de Ejecución

```bash
# 1. Buscar referencias a analizar-ejercicio (solo debe estar en deprecación)
grep -r "analizar-ejercicio" .claude/ --include="*.md" | grep -v "DEPRECADO"

# 2. Buscar referencias a analizar-icfes (debe estar en workflow)
grep -r "analizar-icfes" .claude/ --include="*.md"

# 3. Verificar workflow oficial
grep "analizar" .claude/docs/TROUBLESHOOTING.md

# 4. Verificar comandos dependientes
grep "analizar" .claude/commands/generar-schoice.md
grep "analizar" .claude/commands/generar-cloze.md
```

### Criterios de Éxito

- ✅ Referencias a `/analizar-ejercicio` solo en documentación de deprecación
- ✅ Referencias a `/analizar-icfes` en workflow oficial (docs/TROUBLESHOOTING.md)
- ✅ Referencias a `/analizar-icfes` en generar-schoice.md
- ✅ Referencias a `/analizar-icfes` en generar-cloze.md
- ✅ NO hay referencias a `/analizar-ejercicio` en workflow activo

### Resultado Esperado

```
# Referencias a /analizar-icfes encontradas en:
.claude/docs/TROUBLESHOOTING.md:1. /analizar-icfes [imagen]
.claude/commands/generar-schoice.md:Confirma que el ejercicio fue clasificado con `/analizar-icfes`.
.claude/commands/generar-cloze.md:Confirma que el ejercicio fue clasificado con `/analizar-icfes`.
```

---

## Test 4: Verificar Documentación de Deprecación

**Objetivo:** Confirmar que existe documentación completa de comandos deprecados

### Pasos de Ejecución

```bash
# 1. Verificar que existe el archivo de comandos deprecados
ls -la .claude/docs/COMANDOS_DEPRECADOS.md

# 2. Verificar que documenta analizar-ejercicio
grep "analizar-ejercicio" .claude/docs/COMANDOS_DEPRECADOS.md

# 3. Verificar que incluye tabla comparativa
grep -A 10 "Diferencias Clave" .claude/docs/COMANDOS_DEPRECADOS.md

# 4. Verificar que incluye instrucciones de migración
grep -A 5 "Migración" .claude/docs/COMANDOS_DEPRECADOS.md
```

### Criterios de Éxito

- ✅ Archivo `.claude/docs/COMANDOS_DEPRECADOS.md` existe
- ✅ Documenta `/analizar-ejercicio` como deprecado
- ✅ Incluye tabla comparativa de dimensiones
- ✅ Incluye instrucciones de migración
- ✅ Incluye fecha de deprecación
- ✅ Incluye fecha estimada de eliminación

---

## Test 5: Verificar Actualización de README

**Objetivo:** Confirmar que la estructura documentada está actualizada

### Pasos de Ejecución

```bash
# 1. Verificar que README menciona COMANDOS_DEPRECADOS.md
grep "COMANDOS_DEPRECADOS" .claude/docs/README.md

# 2. Verificar que analizar-icfes está marcado como estándar
grep "analizar-icfes" .claude/docs/README.md

# 3. Verificar estructura de directorios
grep -A 20 "\.claude/" .claude/docs/README.md
```

### Criterios de Éxito

- ✅ README incluye referencia a `COMANDOS_DEPRECADOS.md`
- ✅ README marca `analizar-icfes.md` como comando estándar
- ✅ Estructura de directorios actualizada
- ✅ Nota sobre deprecación presente

---

## 📊 Resumen de Ejecución de Tests

| Test | Estado | Notas |
|------|--------|-------|
| Test 1: Workflow con /analizar-icfes | ⏳ Pendiente | - |
| Test 2: Deprecación de /analizar-ejercicio | ⏳ Pendiente | - |
| Test 3: Integridad de referencias | ⏳ Pendiente | - |
| Test 4: Documentación de deprecación | ⏳ Pendiente | - |
| Test 5: Actualización de README | ⏳ Pendiente | - |

---

## 🚀 Ejecución Automatizada

Para ejecutar todos los tests de una vez:

```bash
# Ejecutar desde la raíz del proyecto
bash .claude/tests/run_all_tests.sh
```

---

**Última actualización:** 2025-12-20

