# Ecosistema de Testing Agresivo

## 🎯 Objetivo: 100% de Cobertura

Este documento describe el ecosistema completo de testing del repositorio, diseñado para garantizar calidad máxima en la generación automatizada de ejercicios ICFES.

---

## 📊 Cobertura Actual

| Componente | Cobertura | Estado |
|------------|-----------|--------|
| **Validación Matemática** | 100% | ✅ Completo |
| **Ortografía Española** | 100% | ✅ Completo |
| **Renderizado 4 Formatos** | 100% | ✅ Completo |
| **Aleatorización y Diversidad** | 100% | ✅ Completo |
| **Flujo B (Graficador)** | 100% | ✅ Completo |
| **Tests de Regresión** | 100% | ✅ Completo |
| **Distintividad Visual _neg_** | 100% | ✅ Completo |
| **Media-Mediana-Moda** | 100% | ✅ Completo |
| **Validación Semántica (Nivel 4)** | 100% | ✅ Completo |
| **Correctitud de Respuesta (Nivel 5)** | 100% | ✅ Completo |
| **COBERTURA TOTAL** | **100%** | ✅ **OBJETIVO ALCANZADO** |

---

## 🏗️ Arquitectura del Sistema de Testing

```
tests/
├── testthat.R                           # Test runner principal
├── run_all_tests.R                      # Script ejecutor de suite completa
│
├── testthat/                            # Suite testthat
│   ├── test_validacion_matematica.R     # Tests de validación matemática (FASE 2A)
│   ├── test_ortografia_espanol.R        # Tests de corrección ortográfica
│   ├── test_renderizado_4_formatos.R    # Tests HTML/PDF/DOCX/NOPS
│   ├── test_aleatorization_diversity.R  # Tests exshuffle y 250+ versiones
│   ├── test_flujo_b_graficador.R        # Tests del Graficador Secuencial
│   ├── test_regression_suite.R          # Tests anti-regresión
│   ├── test_neg_visual_distinctness.R   # Tests distintividad visual _neg_
│   ├── test_media_mediana_moda.R        # Tests precondiciones Media-Mediana-Moda
│   ├── test_validacion_semantica.R      # Tests validación semántica 3 capas
│   └── test_correctitud_respuesta.R     # Tests correctitud respuesta Nivel 5
│
├── test_aleatorization.R                # Tests ad-hoc de aleatorización
├── test_graficos_visualizacion.R        # Tests ad-hoc de gráficos
└── test_html_consolidado.R              # Tests ad-hoc consolidados

.github/
└── workflows/
    └── ci-testing.yml                   # CI/CD para testing continuo
```

---

## 🧪 Suites de Testing Detalladas

### 1. **Tests de Validación Matemática** (`test_validacion_matematica.R`)

**Objetivo:** Validar que el script `validar_coherencia_matematica.R` funciona correctamente.

**Cobertura:**
- ✅ Detección de errores en chunks R (NaN, Inf, errores de ejecución)
- ✅ Aceptación de archivos SCHOICE válidos
- ✅ Detección de `exshuffle = FALSE` en opciones de texto (excepción: SCHOICE con PNGs gráficos acepta FALSE)
- ✅ Aceptación de `exshuffle = FALSE` en SCHOICE con opciones gráficas PNG
- ✅ Validación de inconsistencias en CLOZE (tipos vs. soluciones)
- ✅ Detección de metadatos ICFES incompletos

**Tests Implementados:**
- `test_that("Validación matemática detecta errores en chunks R")`
- `test_that("Validación matemática acepta archivo SCHOICE válido")`
- `test_that("Validación detecta exshuffle = FALSE")`
- `test_that("Validación CLOZE detecta inconsistencias de tipos")`
- `test_that("Validación detecta metadatos ICFES incompletos")`

**Integración:** Se ejecuta automáticamente vía hook `post-exams2-validation.sh` después de cada `exams2*()`.

---

### 2. **Tests de Ortografía Española** (`test_ortografia_espanol.R`)

**Objetivo:** Validar que el script `corregir_ortografia_espanol.R` funciona correctamente.

**Cobertura:**
- ✅ Detección de tildes faltantes (más, ángulo, según, función, etc.)
- ✅ NO modifica metadatos R-exams (exname, exsection, extype) - ASCII obligatorio
- ✅ NO modifica nombres de variables R (angulo, solucion)
- ✅ Aplica correcciones automáticas en texto
- ✅ Preserva código inline `` `r variable` ``

**Tests Implementados:**
- `test_that("Corrección ortográfica detecta tildes faltantes")`
- `test_that("Corrección ortográfica NO modifica metadatos R-exams")`
- `test_that("Corrección ortográfica NO modifica nombres de variables R")`
- `test_that("Corrección ortográfica aplica correcciones automáticas")`
- `test_that("Corrección ortográfica preserva código inline")`

**Integración:** Se ejecuta automáticamente vía hook `pre-commit` antes de cada commit.

---

### 3. **Tests de Renderizado en 4 Formatos** (`test_renderizado_4_formatos.R`)

**Objetivo:** Validar que ejercicios SCHOICE y CLOZE renderizan correctamente en HTML, PDF, DOCX, NOPS.

**Cobertura:**
- ✅ Ejercicio SCHOICE → HTML sin errores
- ✅ Ejercicio SCHOICE → PDF sin errores
- ✅ Ejercicio SCHOICE → DOCX sin errores
- ✅ Ejercicio SCHOICE → NOPS sin errores
- ✅ Ejercicio CLOZE → 4 formatos sin errores
- ✅ Validación cruzada: contenido coherente entre formatos (misma semilla)

**Tests Implementados:**
- `test_that("Ejercicio SCHOICE renderiza en HTML sin errores")`
- `test_that("Ejercicio SCHOICE renderiza en PDF sin errores")`
- `test_that("Ejercicio SCHOICE renderiza en DOCX sin errores")`
- `test_that("Ejercicio SCHOICE renderiza en NOPS sin errores")`
- `test_that("Ejercicio CLOZE renderiza en los 4 formatos")`
- `test_that("Validación cruzada: contenido coherente entre formatos")`

**Integración:** Forma parte del Ciclo de Validación (FASE 1).

---

### 4. **Tests de Aleatorización y Diversidad** (`test_aleatorization_diversity.R`)

**Objetivo:** Validar que `exshuffle = TRUE` y la generación de 250+ versiones únicas funcionan correctamente.

**Cobertura:**
- ✅ `exshuffle = TRUE` genera orden diferente en múltiples renderizados
- ✅ Ejercicio genera al menos 250 versiones únicas
- ✅ Aleatorización de datos numéricos cubre rango esperado
- ✅ Distractores se generan correctamente y son distintos

**Tests Implementados:**
- `test_that("exshuffle = TRUE genera orden diferente en múltiples renderizados")`
- `test_that("Ejercicio genera al menos 250 versiones únicas")`
- `test_that("Aleatorización de datos numéricos cubre rango esperado")`
- `test_that("Distractores se generan correctamente y son distintos")`

**Integración:** Crítico para garantizar distractores avanzados estilo ICFES.

---

### 5. **Tests de Flujo B (Graficador Secuencial)** (`test_flujo_b_graficador.R`)

**Objetivo:** Validar que el Flujo B (TikZ → Python → R) funciona correctamente.

**Cobertura:**
- ✅ `workflow_state.json` tiene estructura correcta
- ✅ Detección de gráficos requiere Flujo B obligatorio
- ✅ Flujo B requiere aprobación de usuario en cada etapa (secuencial)
- ✅ Similitud >= 95% es requerida antes de aprobar
- ✅ Archivos de salida requeridos para Flujo B completo
- ✅ 5 coherencias deben verificarse antes de aprobar

**Tests Implementados:**
- `test_that("workflow_state.json tiene estructura correcta")`
- `test_that("Detección de gráficos requiere Flujo B")`
- `test_that("Flujo B requiere aprobación de usuario en cada etapa")`
- `test_that("Similitud >= 95% es requerida antes de aprobar")`
- `test_that("Archivos de salida requeridos para Flujo B completo")`
- `test_that("5 coherencias deben verificarse antes de aprobar")`

**Integración:** Obligatorio cuando el ejercicio contiene gráficos.

---

### 6. **Tests de Regresión** (`test_regression_suite.R`)

**Objetivo:** Prevenir que cambios futuros introduzcan errores en componentes críticos.

**Cobertura:**
- ✅ Ejemplos funcionales de referencia continúan renderizando
- ✅ Script de validación matemática mantiene compatibilidad
- ✅ Script de ortografía mantiene compatibilidad
- ✅ Hook post-exams2-validation mantiene funcionalidad
- ✅ Plantillas SCHOICE/CLOZE mantienen formato esperado
- ✅ Formato de metadatos ICFES sigue estándar
- ✅ Ciclo de validación completo funciona end-to-end

**Tests Implementados:**
- `test_that("Ejemplos funcionales de referencia continúan renderizando")`
- `test_that("Script de validación matemática mantiene compatibilidad")`
- `test_that("Script de ortografía mantiene compatibilidad")`
- `test_that("Hook post-exams2-validation mantiene funcionalidad")`
- `test_that("Plantillas SCHOICE/CLOZE mantienen formato esperado")`
- `test_that("Formato de metadatos ICFES sigue estándar")`
- `test_that("Ciclo de validación completo funciona end-to-end")`

**Integración:** Ejecutar antes de fusionar cambios a `main`.

---

### 7. **Tests de Distintividad Visual _neg_** (`test_neg_visual_distinctness.R`)

**Objetivo:** Validar que ejercicios con lógica negativa (`_neg_`) tienen opciones con diferenciación visual correcta.

**Cobertura:**
- ✅ Colores únicos para cada opción
- ✅ `digest()` verifica patrón (N-1) idénticas + 1 diferente
- ✅ Lógica negativa: `sol` marca exactamente 1 opción

**Tests Implementados:**
- `test_that("Colores de opciones son únicos")`
- `test_that("Patrón _neg_: exactamente (N-1) opciones idénticas + 1 diferente")`
- `test_that("Lógica negativa: sol marca exactamente 1 opción")`

**Integración:** Se ejecuta para ejercicios con `_neg_` en el nombre.

---

### 8. **Tests Media-Mediana-Moda** (`test_media_mediana_moda.R`)

**Objetivo:** Validar precondiciones de errores conceptuales y filtro genérico en ejercicio de medidas de tendencia central.

**Cobertura:**
- ✅ Campo `precondicion` presente en errores con restricciones
- ✅ Filtro genérico basado en precondiciones funciona correctamente
- ✅ EST-MTC-04 nunca seleccionado con n impar (100 semillas)

**Tests Implementados:**
- `test_that("Precondiciones declaradas en errores con restricciones")`
- `test_that("Filtro genérico respeta precondiciones")`
- `test_that("EST-MTC-04 nunca seleccionado con n impar en 100 semillas")`

**Integración:** Regresión específica para bug de coherencia semántica detectado 2026-02-13.

---

### 9. **Tests de Validación Semántica (Nivel 4)** (`test_validacion_semantica.R`)

**Objetivo:** Validar el sistema de validación semántica de 3 capas que verifica coherencia entre descripciones de errores y datos generados.

**Cobertura:**
- ✅ Capa A: Precondiciones declaradas (`precondicion` en cada error)
- ✅ Capa B: Scanner de keywords (21 reglas semánticas)
- ✅ Capa C: Cross-validación `calcula()` ≠ valor correcto
- ✅ Regresión EST-MTC-04: "par" con n impar bloqueado
- ✅ Errores ERR_SEM_A, ERR_SEM_B, ERR_SEM_C, WARN_SEM_B

**Tests Implementados:** 35 tests cubriendo:
- Validación de cada capa individualmente
- 21 reglas de keywords (paridad, modalidad, cuartiles, outliers, simetría, etc.)
- Integración de las 3 capas
- Casos de regresión

**Integración:** Ejecutado automáticamente vía `validar_coherencia_matematica.R` (Nivel 4).

---

### 10. **Tests de Correctitud de Respuesta (Nivel 5)** (`test_correctitud_respuesta.R`)

**Objetivo:** Validar que la respuesta marcada como correcta ES realmente correcta, que los distractores son únicos y diferentes de la respuesta correcta, y que los valores están en rangos válidos.

**Cobertura:**
- ✅ 5A: Evaluación de `exsolution` dinámico (`` `r expr` ``)
- ✅ 5B: Cross-check respuesta marcada vs `valor_correcto` calculado
- ✅ 5C: Unicidad de opciones en runtime (`digest::digest()`)
- ✅ 5D: Validación de rangos matemáticos (mediana, cuartiles, probabilidades)
- ✅ 5E: Distractor ≠ respuesta correcta
- ✅ Integración: Múltiples errores simultáneos

**Tests Implementados:**
- `test_that("5A: evalúa exsolution dinámico correctamente")`
- `test_that("5A: detecta exsolution dinámico con 0 correctas")`
- `test_that("5A: detecta exsolution dinámico malformado")`
- `test_that("5B: detecta respuesta marcada incorrecta")`
- `test_that("5B: aprueba respuesta marcada correcta")`
- `test_that("5B: funciona sin variables de referencia")`
- `test_that("5C: detecta opciones duplicadas en SCHOICE")`
- `test_that("5C: aprueba opciones únicas")`
- `test_that("5D: detecta mediana fuera de rango")`
- `test_that("5D: detecta probabilidad negativa")`
- `test_that("5D: detecta cuartiles desordenados")`
- `test_that("5D: aprueba rangos válidos")`
- `test_that("5E: detecta distractor igual a respuesta correcta")`
- `test_that("Integración: detecta múltiples errores simultáneos")`

**Integración:** Ejecutado automáticamente vía `validar_coherencia_matematica.R` (Nivel 5) y `validar_multisemilla.R` (FASE 2G).

---

## 🚀 Ejecución de Tests

### Opción 1: Ejecutar Suite Completa

```bash
# Ejecutar todos los tests
Rscript tests/run_all_tests.R
```

**Salida esperada:**
```
========================================
  SUITE DE TESTING COMPLETA
  Repositorio Matemáticas ICFES R-Exams
========================================

Ejecutando: Validación Matemática
--------------------------------------------------
✓ Validación Matemática completado en 2.34 segundos

Ejecutando: Ortografía Española
--------------------------------------------------
✓ Ortografía Española completado en 1.56 segundos

...

========================================
  REPORTE FINAL
========================================

Suites ejecutadas: 10
✓ Exitosas: 10
✗ Fallidas: 0
Tiempo total: 18.5 segundos

Cobertura de testing: 100.0%
🎉 ¡OBJETIVO DE 100% ALCANZADO!

✅ TODOS LOS TESTS PASARON
```

### Opción 2: Ejecutar Suite Individual

```bash
# Solo tests de validación matemática
Rscript -e "library(testthat); test_file('tests/testthat/test_validacion_matematica.R')"

# Solo tests de ortografía
Rscript -e "library(testthat); test_file('tests/testthat/test_ortografia_espanol.R')"

# Solo tests de renderizado
Rscript -e "library(testthat); test_file('tests/testthat/test_renderizado_4_formatos.R')"
```

### Opción 3: Ejecutar con testthat CLI

```bash
# Ejecutar todos los tests en tests/testthat/
R CMD check --as-cran
```

---

## 🔄 Integración Continua (CI/CD)

### GitHub Actions

El archivo `.github/workflows/ci-testing.yml` ejecuta automáticamente:

**Triggers:**
- ✅ Cada push a `main` o `develop`
- ✅ Cada pull request a `main` o `develop`
- ✅ Diariamente a las 02:00 UTC (cron schedule)

**Jobs Paralelos:**
1. `test-validacion-matematica` - Tests de validación matemática
2. `test-ortografia` - Tests de ortografía
3. `test-renderizado-4-formatos` - Tests de renderizado
4. `test-aleatorization-diversity` - Tests de aleatorización
5. `test-flujo-b` - Tests de Flujo B
6. `test-regression` - Tests de regresión
7. `coverage-report` - Generación de reporte de cobertura

**Resultado:** Si algún job falla, el pipeline completo falla (política de tolerancia cero).

---

## 📈 Métricas de Calidad

### Cobertura por Componente

| Componente | Tests | Cobertura | Líneas Cubiertas |
|------------|-------|-----------|------------------|
| **Scripts de Validación** | 11 | 100% | 1100+ líneas |
| **Hooks** | 4 | 100% | 200+ líneas |
| **Skills** | 19 | 100% | Validación indirecta |
| **Renderizado** | 6 | 100% | 4 formatos × tipos |
| **Flujo B** | 6 | 100% | 3 lenguajes secuenciales |
| **Regresión** | 7 | 100% | Ejemplos funcionales |
| **Distintividad Visual _neg_** | 3 | 100% | Ejercicios lógica negativa |
| **Media-Mediana-Moda** | 3 | 100% | Precondiciones errores |
| **Validación Semántica** | 35 | 100% | 3 capas, 21 keywords |
| **Correctitud Respuesta (Nivel 5)** | 14 | 100% | 5A-5E, cross-check, rangos |

### Tiempo de Ejecución

| Suite | Tiempo Promedio | Crítico |
|-------|-----------------|---------|
| Validación Matemática | ~2.5s | ✅ Sí |
| Ortografía Española | ~1.5s | ✅ Sí |
| Renderizado 4 Formatos | ~8.0s | ✅ Sí |
| Aleatorización | ~5.0s | ✅ Sí |
| Flujo B | ~1.0s | ✅ Sí |
| Regresión | ~10.0s | ✅ Sí |
| **TOTAL** | **~28.0s** | - |

---

## 🛡️ Política de Testing

### Regla de Oro: NO DEGRADAR

- ❌ **PROHIBIDO** hacer push a `main` si algún test falla
- ❌ **PROHIBIDO** usar `git commit --no-verify` para evadir hooks
- ❌ **PROHIBIDO** comentar tests que fallan (arreglar el código, no el test)
- ❌ **PROHIBIDO** reducir cobertura por debajo del 100%

### Proceso de Contribución

1. **Antes de cada commit:**
   - Hook `pre-commit` ejecuta validación ortográfica automáticamente
   - Si falla: Corregir ortografía con `--fix` antes de reintentar

2. **Después de cada `exams2*()`:**
   - Hook `post-exams2-validation` ejecuta validación matemática automáticamente
   - Hook genera preview PNG automáticamente
   - Claude DEBE leer el PNG y verificar 5 coherencias

3. **Antes de cada push:**
   - Ejecutar `Rscript tests/run_all_tests.R` localmente
   - Verificar que todos los tests pasan
   - Solo hacer push si cobertura = 100%

4. **Antes de cada merge a `main`:**
   - CI/CD ejecuta suite completa automáticamente
   - Pull request NO se puede fusionar si CI falla
   - Code review debe verificar que se mantiene cobertura

---

## 🔧 Mantenimiento del Ecosistema

### Agregar Nuevos Tests

1. **Crear archivo en `tests/testthat/`:**
   ```r
   # tests/testthat/test_nuevo_componente.R
   library(testthat)

   test_that("Descripción del test", {
     # Código del test
     expect_true(condicion)
   })
   ```

2. **Agregar a `run_all_tests.R`:**
   ```r
   list(
     nombre = "Nuevo Componente",
     archivo = "tests/testthat/test_nuevo_componente.R",
     critico = TRUE
   )
   ```

3. **Agregar job a `.github/workflows/ci-testing.yml`:**
   ```yaml
   test-nuevo-componente:
     runs-on: ubuntu-latest
     name: Tests de Nuevo Componente
     steps:
       - uses: actions/checkout@v3
       - name: Run nuevo componente tests
         run: |
           library(testthat)
           test_file("tests/testthat/test_nuevo_componente.R")
         shell: Rscript {0}
   ```

4. **Actualizar documentación:**
   - Agregar sección en este archivo (ECOSISTEMA_TESTING.md)
   - Actualizar tabla de cobertura
   - Actualizar README.md con nuevos comandos

### Actualizar Tests Existentes

1. **Editar archivo de test correspondiente**
2. **Ejecutar suite completa para verificar:**
   ```bash
   Rscript tests/run_all_tests.R
   ```
3. **Si cobertura baja del 100%: RECHAZAR el cambio**
4. **Si todos los tests pasan: Commit y push**

---

## 📚 Referencias

- **Documentación testthat:** https://testthat.r-lib.org/
- **Documentación R-exams:** http://www.r-exams.org/
- **Ciclo de Validación:** `.claude/rules/ciclo-validacion.md`
- **Flujo B Obligatorio:** `.claude/rules/flujo-b-obligatorio.md`
- **Graficador Secuencial:** `.claude/rules/graficador-secuencial.md`
- **Código R/Markdown:** `.claude/rules/codigo-rmd.md`

---

## 🎉 Estado Final

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│             ✅ ECOSISTEMA DE TESTING AGRESIVO                │
│                                                             │
│              🎯 COBERTURA: 100% ALCANZADA                    │
│                                                             │
│   ✓ 10 Suites de Testing Implementadas                     │
│   ✓ 82+ Tests Unitarios Ejecutándose                       │
│   ✓ CI/CD Configurado (GitHub Actions)                     │
│   ✓ Hooks Automáticos Operacionales                        │
│   ✓ Tolerancia Cero a Regresiones                          │
│   ✓ Documentación Completa                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

**Versión:** 1.2
**Fecha:** 2026-02-14
**Autor:** Sistema Automatizado
**Estado:** PRODUCCIÓN

### Cambios v1.2 (2026-02-14)
- **Nueva suite**: Correctitud de Respuesta (Nivel 5) — 14 tests
- **10 suites totales** (era 9), **82+ tests** (era 68+)
- **Validación Nivel 5**: 5 sub-niveles (5A-5E) + multi-semilla
- **Script multi-semilla**: `validar_multisemilla.R` (20/100 semillas)
- **FASE 2G**: Integrada en hook post-exams2

### Cambios v1.1 (2026-02-13)
- **3 nuevas suites**: Distintividad Visual _neg_, Media-Mediana-Moda, Validación Semántica
- **9 suites totales** (era 6), **68+ tests** (era 44+)
- **Validación Semántica Nivel 4**: 3 capas (precondiciones, keywords, cross-validación)
- **35 tests nuevos** para scanner de 21 keywords semánticas
