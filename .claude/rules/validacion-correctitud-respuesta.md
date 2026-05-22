# Regla: Validación de Correctitud de Respuesta (Nivel 5)

## Principio Fundamental

**El sistema DEBE verificar automáticamente que la respuesta marcada como correcta ES realmente la correcta matemáticamente, que los distractores son únicos y diferentes de la respuesta correcta, y que los valores están en rangos válidos. NO hay excepciones.**

---

## Contexto

Los Niveles 1-4 de validación verifican:
- **Nivel 1 (Sintáctico)**: El código R ejecuta sin errores
- **Nivel 2 (Numérico)**: Sin NA/NaN/Inf
- **Nivel 3 (Estructural)**: Metadatos completos, exsolution correcto
- **Nivel 4 (Semántico)**: Descripciones de errores coherentes con datos

**Brecha crítica**: Ninguno de estos niveles verifica que la opción marcada como correcta tenga el valor correcto calculado, ni que los distractores sean únicos en tiempo de ejecución.

---

## Sub-niveles de Validación

### 5A: Evaluación de exsolution dinámico

Cuando `exsolution` contiene `` `r expr` ``, el Nivel 3 lo salta. El Nivel 5A:
1. Extrae la expresión R del inline
2. La evalúa en el entorno del ejercicio
3. Valida el resultado como si fuera estático

**Código de error**: `ERR_ANS_A`
**Severidad**: Bloqueante

### 5B: Cross-check respuesta marcada vs valor correcto

Busca en el entorno del ejercicio:
- Vector `sol` (posiciones correctas)
- `opciones_mezcladas` / `opciones` (valores de las opciones)
- `valor_correcto` / `mediana_calc` / `respuesta_correcta` (valor esperado)

Verifica que `opciones[which(sol==1)]` corresponda al valor correcto.

**Código de error**: `ERR_ANS_B`
**Severidad**: Bloqueante

### 5C: Unicidad de opciones en runtime

- Para SCHOICE normal: todas las opciones deben ser diferentes (`digest::digest()`)
- Para ejercicios `_neg_`: patrón (N-1) iguales + 1 diferente

**Código de error**: `ERR_ANS_C`
**Severidad**: Bloqueante

### 5D: Validación de rangos matemáticos

- Mediana dentro de [min(datos), max(datos)]
- Cuartiles ordenados: min ≤ Q1 ≤ Q2 ≤ Q3 ≤ max
- Probabilidades en [0, 1]
- Porcentajes en [0, 100]

**Código de error**: `ERR_ANS_D`
**Severidad**: Bloqueante

### 5E: Distractor ≠ respuesta correcta

Verifica con `digest::digest()` que ningún distractor sea idéntico a la respuesta correcta.

**Código de error**: `ERR_ANS_E`
**Severidad**: Bloqueante

### Nivel 4 — Capa D: Determinismo de calcula()

Verifica que `calcula()` de CADA error en el pool sea una función pura:

1. **Análisis estático**: Escanea `deparse(calcula)` buscando `sample(`, `runif(`, `rnorm(`, etc.
2. **Test empírico**: Ejecuta `calcula()` dos veces con los mismos argumentos y compara resultados.

Si el error es el seleccionado → `ERR_SEM_D` (bloqueante).
Si el error está en el pool pero no seleccionado → `WARN_SEM_D` (bug latente).

**Código de error**: `ERR_SEM_D` / `WARN_SEM_D`
**Severidad**: ERR bloqueante, WARN informativo

**Bug original (2026-02-14)**: EST-MTC-03 usaba `sample(datos_ord)` dentro de `calcula()`.
El `set.seed()` del multi-semilla enmascaraba el problema: cada semilla producía un resultado
determinista, pero ese resultado NO correspondía a los datos que el estudiante veía en la tabla.
La Capa D habría detectado `sample(` en el análisis estático y bloqueado el ejercicio.

---

## Validación Multi-semilla

El script `validar_multisemilla.R` ejecuta el .Rmd N veces con diferentes semillas:

```
Para semilla en 1:N (dispersas con primos):
  1. set.seed(semilla)
  2. Ejecutar todos los chunks R
  3. Validar Nivel 5A-5E completo
  4. Validar coherencia general y semántica
  5. Registrar fallos

Reportar:
  - Semillas que fallaron
  - Tipo de error por semilla
  - Tasa de éxito (debe ser 100%)
```

### Modos

| Modo | Semillas | Uso |
|------|----------|-----|
| Rápido | 20 | Hook automático (FASE 2G) |
| Exhaustivo | 100 | Pre-promoción |

### Ejecución

```bash
# Rápido (hook automático)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --n 20

# Exhaustivo (pre-promoción)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --modo exhaustivo
```

---

## Integración con el Hook

La FASE 2G se ejecuta automáticamente en `post-exams2-validation.sh`:

```
FASE 2A: Coherencia matemática (Niveles 1-4)
FASE 2B: Preview visual (PDF → PNG)
FASES 2C-2F: Arsenal estático
FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5) ← NUEVO
```

La FASE 2G solo se ejecuta si las fases anteriores no tienen errores.

---

## Códigos de Error

| Código | Nivel | Descripción | Severidad |
|--------|-------|-------------|-----------|
| `ERR_ANS_A` | 5A | exsolution dinámico evalúa a formato inválido | Bloqueante |
| `ERR_ANS_B` | 5B | Respuesta marcada no coincide con valor correcto | Bloqueante |
| `ERR_ANS_C` | 5C | Opciones duplicadas en SCHOICE | Bloqueante |
| `ERR_ANS_D` | 5D | Valor fuera de rango matemático válido | Bloqueante |
| `ERR_ANS_E` | 5E | Distractor idéntico a respuesta correcta | Bloqueante |
| `ERR_SEM_D` | 4D | calcula() contiene función aleatoria o no es determinista | Bloqueante |
| `WARN_SEM_D` | 4D | calcula() de error no seleccionado tiene aleatoriedad (bug latente) | Informativo |

---

## Variables Detectadas Automáticamente

El Nivel 5 busca estas convenciones de nombres en el entorno:

### Vectores de solución
- `sol`, `solucion`, `solucion_vector`

### Valor correcto
- `valor_correcto`, `mediana_calc`, `respuesta_correcta`
- `media_correcta`, `mediana_correcta`, `moda_correcta`

### Opciones
- `opciones_mezcladas`, `opciones_graficos`, `opciones_valores`
- `opciones`, `opciones_num`, `opciones_texto`

### Datos
- `datos_ord`, `datos`

### Cuartiles
- `cuartiles_correctos` (lista con `q1`, `mediana`, `q3`)

### Probabilidades y porcentajes
- Variables con `prob` en el nombre → rango [0, 1]
- Variables con `porcentaje`, `pct`, `percent` → rango [0, 100]

---

## Tests

Suite: `tests/testthat/test_correctitud_respuesta.R`

- 14 tests cubriendo todos los sub-niveles (5A-5E)
- Tests de detección de errores Y de aprobación de archivos válidos
- Test de integración con múltiples errores simultáneos

---

**Versión**: 1.0
**Fecha**: 2026-02-14
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: NINGUNA
