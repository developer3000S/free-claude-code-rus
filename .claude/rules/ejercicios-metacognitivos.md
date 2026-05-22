# Regla: Ejercicios Metacognitivos con Progressive Disclosure

## Principio Fundamental

**TODO ejercicio .Rmd (SCHOICE o CLOZE) generado o modificado DEBE ser metacognitivo, aplicando el patrón Progressive Disclosure.**

Esta regla NO tiene excepciones. Ejercicios puramente procedimentales ("calcule X") son insuficientes para desarrollar aprendizaje profundo.

---

## Definición: Ejercicio Metacognitivo

Un ejercicio metacognitivo va más allá del cálculo correcto e incluye:

1. **Identificación de errores** conceptuales en otros razonamientos
2. **Justificación explícita** del por qué una estrategia funciona
3. **Reflexión** sobre el proceso de solución
4. **Verificación** activa de la propia respuesta
5. **Transferencia** a contextos relacionados

### Fundamento Científico

Basado en Schraw & Dennison (1994) y meta-análisis de Dunlosky et al. (2013):

- **Efecto cuantificado**: d = 0.62 (tamaño de efecto grande)
- Estudiantes con alta metacognición tienen mejor desempeño académico
- La metacognición incluye: monitoreo de comprensión, calibración, corrección autogenerada

---

## Definición: Progressive Disclosure

El ejercicio revela información **gradualmente**, requiriendo diferentes niveles cognitivos en secuencia:

```
Nivel 1: Comprensión básica (¿qué pasó?)
    ↓
Nivel 2: Análisis (¿por qué pasó?)
    ↓
Nivel 3: Evaluación (¿es correcto?)
    ↓
Nivel 4: Síntesis/Creación (¿cómo corregirlo?)
```

### Aplicación Práctica

**SCHOICE con Progressive Disclosure:**

```
Pregunta principal: [Evaluar error de otro estudiante]
    ↓
Opciones: [Cada opción = un tipo de error diferente]
    ↓
Solución: [Análisis del error + procedimiento correcto + reflexión]
```

**CLOZE con Progressive Disclosure:**

```
Parte 1 (schoice): Identificar el error conceptual
    ↓
Parte 2 (num): Calcular la respuesta correcta
    ↓
Parte 3 (mchoice): Evaluar afirmaciones relacionadas
    ↓
Parte 4 (schoice V/F): Transferir a caso específico
```

---

## Estructura Obligatoria: SCHOICE Metacognitivo

### Patrón 1: Análisis de Error Ajeno

```markdown
**Enunciado**: [Contexto realista]
[Otro estudiante] resolvió [problema] y obtuvo [respuesta_erronea].

¿Cuál error conceptual cometió [estudiante] para obtener esa respuesta?

A) [Error tipo 1 - descripción clara del error]
B) [Error tipo 2 - descripción clara del error]  ← Correcta
C) [Error tipo 3 - descripción clara del error]
D) [Error tipo 4 - descripción clara del error]

**Solution**:
- Análisis detallado del error identificado
- Procedimiento correcto paso a paso
- Reflexión metacognitiva
- Estrategia para evitar el error
```

### Patrón 2: Evaluación de Afirmación

```markdown
**Enunciado**: [Contexto realista]
[Persona] afirma: "[Afirmación matemática potencialmente incorrecta]"

¿Por qué esta afirmación es [CORRECTA/INCORRECTA]?

A) [Justificación superficial]
B) [Justificación con causa raíz correcta]  ← Correcta
C) [Confusión conceptual]
D) [Error de terminología]

**Solution**:
- Análisis de la afirmación
- Justificación matemática rigurosa
- Contraejemplo o demostración
- Reflexión sobre el concepto
```

### Patrón 3: Comparación de Procedimientos

```markdown
**Enunciado**: [Contexto realista]
Tres estudiantes resolvieron [problema]:

- Estudiante A: [Procedimiento A]
- Estudiante B: [Procedimiento B]
- Estudiante C: [Procedimiento C]

¿Cuál estudiante aplicó correctamente [concepto]?

A) Solo A
B) Solo B  ← Correcta
C) A y C
D) Ninguno

**Solution**:
- Análisis de cada procedimiento
- Identificación de errores en cada uno
- Procedimiento correcto
- Generalización del concepto
```

---

## Estructura Obligatoria: CLOZE Metacognitivo

### Mínimo 4 Partes con Progressive Disclosure

```r
# Parte 1 (schoice): IDENTIFICAR
# DOK 2-3, Bloom: Analizar
"¿Cuál error conceptual cometió [persona]?"

# Parte 2 (num): CALCULAR
# DOK 2, Bloom: Aplicar
"¿Cuál es el valor correcto?"

# Parte 3 (mchoice): EVALUAR
# DOK 3, Bloom: Evaluar
"Seleccione las afirmaciones correctas sobre [concepto]."

# Parte 4 (schoice V/F): TRANSFERIR
# DOK 3, Bloom: Analizar/Evaluar
"La siguiente afirmación es verdadera o falsa: [caso específico]"
```

### Metadatos Obligatorios CLOZE Metacognitivo

```yaml
extype: cloze
exclozetype: schoice|num|mchoice|schoice
exextra[DOK]: 3
exextra[Bloom]: Evaluar
exextra[SOLO]: Relacional-Extendido
```

---

## Pool de Errores Conceptuales (OBLIGATORIO)

Todo ejercicio metacognitivo DEBE incluir un pool de errores conceptuales documentados:

```r
errores_conceptuales <- list(
  list(
    codigo = "XXX-YYY-01",          # Código único
    nombre = "Nombre descriptivo",   # Para referencia
    descripcion_corta = "...",       # Para opciones
    descripcion_larga = "...",       # Para solución
    causa_raiz = "...",              # Diagnóstico pedagógico
    precondicion = function(params) TRUE,  # Cuándo aplica este error
    calcula = function(datos_ord, datos_presentados = NULL) { ... }  # Produce el distractor
  ),
  # Mínimo 4-6 errores por ejercicio
)
```

### Función `calcula()` — Determinismo OBLIGATORIO

**`calcula()` DEBE ser una función pura (determinista).** Llamada con los mismos
argumentos SIEMPRE debe producir el mismo resultado.

**Firma estándar**: `function(datos_ord, datos_presentados = NULL)`

- `datos_ord`: datos ordenados de menor a mayor
- `datos_presentados`: datos en el orden que el estudiante ve en la tabla (opcional)

**PROHIBIDO dentro de `calcula()`:**

```r
# ❌ PROHIBIDO — funciones aleatorias
sample()       # Genera orden aleatorio no reproducible
runif()        # Valor aleatorio continuo
rnorm()        # Valor aleatorio normal
rbinom()       # Valor aleatorio binomial
# ... cualquier función r*() de distribuciones

# ❌ PROHIBIDO — Bug real detectado (EST-MTC-03, 2026-02-14)
# calcula() usaba sample(datos_ord) para simular "datos sin ordenar"
# Resultado: mediana_erronea ≠ posición central de datos_presentados
# El estudiante veía un valor que NO correspondía a su tabla
calcula = function(datos_ord) {
  datos_desordenados <- sample(datos_ord)  # BUG: orden aleatorio
  datos_desordenados[(n + 1) / 2]          # valor impredecible
}
```

**Patrón correcto cuando el error depende del orden de presentación:**

```r
# ✅ CORRECTO — usa datos_presentados (el orden real de la tabla)
calcula = function(datos_ord, datos_presentados = NULL) {
  if (is.null(datos_presentados)) stop("Requiere datos_presentados")
  n <- length(datos_presentados)
  datos_presentados[(n + 1) / 2]  # valor determinista y coherente
}
```

**Validación automática (Capa D):** El script `validar_coherencia_matematica.R`
escanea el cuerpo de `calcula()` buscando funciones aleatorias (análisis estático)
Y ejecuta la función dos veces verificando idempotencia (test empírico).
Código de error: `ERR_SEM_D` (bloqueante) / `WARN_SEM_D` (bug latente).

### Campo `precondicion` (OBLIGATORIO)

Cada error DEBE declarar cuándo es aplicable. Esto previene incoherencias
entre la descripción del error y las propiedades de los datos generados.

- Recibe `params`: lista con propiedades de los datos (`n`, `datos_ord`, etc.)
- Devuelve `TRUE` si el error aplica, `FALSE` si no
- La mayoría de errores usan `function(params) TRUE` (siempre aplican)
- Errores condicionales DEBEN declarar su condición explícitamente
- Si un error NO tiene `precondicion` (retrocompatibilidad), se asume `TRUE`

```r
# Ejemplo: error que solo aplica cuando n es par
list(
  codigo = "EST-MTC-04",
  nombre = "Un solo valor central (n par)",
  descripcion_corta = "Para un número par de datos, tomó solo uno de los dos valores centrales",
  precondicion = function(params) params$n %% 2 == 0,  # Solo n par
  calcula = function(datos_ord) {
    n <- length(datos_ord)
    if (n %% 2 != 0) stop("EST-MTC-04 no debe usarse con n impar")
    datos_ord[n / 2]
  }
)
```

### Selección de errores con precondiciones (Patrón genérico)

```r
# Filtrar errores aplicables según precondiciones
params <- list(n = n, datos_ord = datos_ord)
errores_aplicables_idx <- which(sapply(errores_conceptuales, function(err) {
  if (is.null(err$precondicion)) return(TRUE)
  err$precondicion(params)
}))
error_idx <- sample(errores_aplicables_idx, 1)
```

Este patrón reemplaza cualquier filtrado hardcoded (como `if (n %% 2 == 0) ...`).

### Taxonomía de Códigos de Error

| Prefijo | Área | Ejemplo |
|---------|------|---------|
| ALG | Álgebra | ALG-OPE-01 (Inversión operación) |
| ARI | Aritmética | ARI-FRA-01 (Suma fracciones incorrecta) |
| EST | Estadística | EST-MTC-01 (Confusión promedio-valor) |
| GEO | Geometría | GEO-ARE-01 (Confusión área-perímetro) |
| FUN | Funciones | FUN-PEN-01 (Confusión pendiente-intercepto) |

---

## Pool de Reflexiones Metacognitivas (OBLIGATORIO)

Todo ejercicio DEBE incluir reflexiones aleatorias:

```r
reflexiones_metacognitivas <- list(
  "Identificar errores ajenos nos ayuda a evitar cometerlos. La metacognición es fundamental.",
  "Analizar por qué una respuesta es incorrecta fortalece la comprensión profunda.",
  "Los errores más frecuentes son: [lista específica del tema].",
  "Cuando identificamos el tipo de error, podemos diseñar estrategias para evitarlo."
)

reflexion <- reflexiones_metacognitivas[[sample(length(reflexiones_metacognitivas), 1)]]
```

---

## Verificaciones Obligatorias en `data_generation`

```r
# 1. Verificar que respuesta errónea ≠ respuesta correcta
test_that("Error analizado produce respuesta errónea diferente de correcta", {
  expect_true(respuesta_erronea != valor_correcto)
})

# 2. Verificar que distractores son únicos
test_that("Distractores son únicos", {
  expect_equal(length(unique(distractores)), length(distractores))
})

# 3. Verificar coherencia de error conceptual
test_that("Error conceptual es reproducible", {
  resultado <- error_seleccionado$calcula(...)
  expect_equal(resultado, respuesta_erronea)
})

# 3b. Verificar que calcula() no retorna NA (guardia obligatoria)
test_that("calcula() no retorna NA para la operación seleccionada", {
  resultado <- error_seleccionado$calcula(datos_ord)
  expect_false(is.na(resultado),
    info = paste(error_seleccionado$codigo, "retorna NA — falta guardia is.na() en while loop"))
})

# 4. Verificar coherencia semántica: error seleccionado aplica a los datos
test_that("Error seleccionado cumple su precondición", {
  if (!is.null(error_sel$precondicion)) {
    params <- list(n = n, datos_ord = datos_ord)
    expect_true(error_sel$precondicion(params),
      info = paste(error_sel$codigo, "seleccionado pero precondición no se cumple"))
  }
})

# 5. Verificar precondiciones en múltiples semillas
test_that("Precondiciones respetadas en 100 semillas", {
  for (i in 1:100) {
    d <- generar_datos()
    if (!is.null(d$error_sel$precondicion)) {
      params <- list(n = d$n, datos_ord = d$datos_ord)
      expect_true(d$error_sel$precondicion(params),
        info = paste("Semilla", i, ":", d$error_sel$codigo, "con n =", d$n))
    }
  }
})
```

---

## Validación Semántica Automática (Nivel 4)

El script `validar_coherencia_matematica.R` valida automáticamente la coherencia semántica del pool de errores en **3 capas**:

### Capa A: Precondición declarada

Verifica que el error seleccionado cumple su `precondicion()` con los datos actuales.

- **Código de error**: `ERR_SEM_A`
- **Severidad**: Bloqueante
- **Qué detecta**: Error seleccionado cuya precondición no se cumple

### Capa B: Escaneo de keywords (DETECCIÓN AUTOMÁTICA)

Escanea `descripcion_corta` y `descripcion_larga` de **todos** los errores del pool buscando palabras clave que implican condiciones matemáticas. Si la condición no se cumple Y no hay `precondicion` que lo prevenga, reporta:

- **`ERR_SEM_B`** (bloqueante): El error **fue seleccionado** y es incoherente
- **`WARN_SEM_B`** (informativo): El error está en el pool sin protección (bug latente)

**Keywords escaneados automáticamente (21 reglas):**

| Keyword en descripción | Condición implicada | Verificación |
|------------------------|---------------------|--------------|
| "número par", "par de datos", "dos valores centrales" | n es par | `n %% 2 == 0` |
| "número impar", "un solo valor central" | n es impar | `n %% 2 == 1` |
| "moda única", "unimodal" | moda única | `sum(tb == max(tb)) == 1` |
| "bimodal", "dos modas" | bimodal | `sum(tb == max(tb)) == 2` |
| "multimodal", "múltiples modas" | multimodal | `sum(tb == max(tb)) >= 2` |
| "todos iguales", "sin variabilidad" | datos iguales | `length(unique(datos)) == 1` |
| "sin ordenar", "datos desordenados" | error de no ordenar | siempre aplicable |
| "cuartil", "Q1", "Q3" | cuartiles calculables | `n >= 4` |
| "rango", "recorrido" | datos no constantes | `length(unique(datos)) > 1` |
| "desviación estándar", "varianza" | al menos 2 datos | `n >= 2` |
| "valores negativos", "datos negativos" | hay negativos | `any(datos < 0)` |
| "contiene ceros", "valor cero" | hay ceros | `0 %in% datos` |
| "números enteros", "sin decimales" | todos enteros | `all(datos == floor(datos))` |
| "valores decimales", "con decimales" | hay decimales | `any(datos != floor(datos))` |
| "simétrica", "distribución simétrica" | asimetría baja | `abs(mean-median)/sd < 0.1` |
| "asimétrica", "sesgo", "sesgada" | asimetría alta | `abs(mean-median)/sd >= 0.1` |
| "atípicos", "outlier", "valor extremo" | hay outliers IQR | regla 1.5*IQR |
| "muestra grande", "muchos datos" | n grande | `n >= 30` |
| "muestra pequeña", "pocos datos" | n pequeño | `n < 30` |
| "frecuencia relativa", "proporción" | datos existentes | siempre si hay datos |
| "datos desordenados" (en error) | error de ordenamiento | siempre aplicable |

**Extensibilidad**: Agregar nuevas reglas en `REGLAS_SEMANTICAS_KEYWORDS` dentro de `validar_coherencia_matematica.R`. Cada regla tiene: `patron` (regex), `nombre`, `condicion` (función), `mensaje`.

### Capa C: Cross-validación calcula vs correcto

Verifica que `calcula()` del error seleccionado produce un valor diferente de la respuesta correcta.

- **Código de error**: `ERR_SEM_C`
- **Severidad**: Bloqueante
- **Qué detecta**: Error que produce el mismo valor que la respuesta correcta (distractor inútil)

### Flujo de ejecución

```
exams2html() / exams2pdf()
    ↓ (hook PostToolUse)
validar_coherencia_matematica.R
    ↓
Nivel 1: Sintáctico (chunks ejecutan)
Nivel 2: Numérico (sin NA/NaN/Inf)
Nivel 3: Estructural (metadatos, exsolution)
Nivel 4: Semántico ← NUEVO
    ├── Capa A: precondicion declarada
    ├── Capa B: keywords en descripciones
    └── Capa C: calcula vs correcto
```

---

## Sección Solution Obligatoria

La solución DEBE incluir TODAS estas subsecciones:

```markdown
### Análisis del Error (Parte 1)
**Error identificado:** [descripcion_larga]
**Código de error:** [codigo]
**Causa raíz:** [causa_raiz]

### Procedimiento Correcto (Parte 2)
**Paso 1:** [Descripción + fórmula LaTeX]
$$...$$

**Paso 2:** [Descripción + fórmula LaTeX]
$$...$$

[Continuar hasta el resultado]

### Propiedades del Concepto (Parte 3)
- Afirmación 1: [VERDADERA/FALSA] porque...
- Afirmación 2: [VERDADERA/FALSA] porque...

### Caso Específico (Parte 4)
[Enunciado] → **[Verdadero/Falso]** porque...

### Reflexión Metacognitiva
`r reflexion`

### Estrategia para Evitar el Error
1. [Paso preventivo 1]
2. [Paso preventivo 2]
3. [Verificación final]
```

---

## Integración con Otros Principios

### Con Retrieval Practice

```markdown
# NO dar fórmulas visibles
❌ "Usando la fórmula A = b × h, calcula..."
✓ "¿Por qué el estudiante que usó A = b + h obtuvo un resultado incorrecto?"
```

### Con Dual Coding

```markdown
# Incluir representación visual + verbal
- Tabla con datos
- Gráfico TikZ si aplica
- Descripción textual
- Fórmulas matemáticas
```

### Con Concrete Examples

```markdown
# Pool de contextos narrativos variados
contextos <- list(
  list(rol = "profesora", contexto = "calificaciones", unidad = "puntos"),
  list(rol = "entrenador", contexto = "puntos anotados", unidad = "puntos"),
  # Mínimo 6-8 contextos por ejercicio
)
```

---

## Antipatrones PROHIBIDOS

### 1. Ejercicio Puramente Procedimental (PROHIBIDO)

```markdown
❌ "Calcula el área de un rectángulo con base 8 cm y altura 5 cm."
```

**Por qué es malo**: No hay metacognición, solo cálculo mecánico.

### 2. Distractores Aleatorios (PROHIBIDO)

```r
❌ distractores <- respuesta + sample(-10:10, 3)
```

**Por qué es malo**: No representa errores conceptuales reales.

### 3. Solución Sin Análisis de Error (PROHIBIDO)

```markdown
❌ Solution
========
La respuesta correcta es 40.
```

**Por qué es malo**: No explica errores ni desarrolla metacognición.

### 4. Sin Pool de Errores Documentado (PROHIBIDO)

```r
❌ distractor1 <- respuesta - 5  # ¿Qué error representa?
```

**Por qué es malo**: No hay diagnóstico pedagógico.

---

## Checklist Pre-Generación

Antes de generar cualquier .Rmd:

- [ ] ¿Incluye pool de errores conceptuales con códigos?
- [ ] ¿Cada error tiene `descripcion_corta`, `descripcion_larga`, `causa_raiz`?
- [ ] ¿Hay función `calcula` para cada error?
- [ ] ¿Incluye pool de reflexiones metacognitivas?
- [ ] ¿La estructura es Progressive Disclosure (fácil → difícil)?
- [ ] ¿Solution incluye análisis de error + procedimiento + reflexión?
- [ ] ¿Hay verificaciones test_that para coherencia?

---

## Checklist Post-Generación

Después de generar el .Rmd:

- [ ] ¿Respuesta errónea ≠ respuesta correcta?
- [ ] ¿Distractores son únicos entre sí?
- [ ] ¿Metadatos incluyen DOK, Bloom, SOLO?
- [ ] ¿Nivel DOK ≥ 2 (preferible 3)?
- [ ] ¿Bloom incluye Analizar/Evaluar?
- [ ] ¿Coherencia Nivel ICFES ↔ DOK? (ver tabla abajo)
- [ ] ¿Solución tiene todas las subsecciones obligatorias?

---

## Coherencia Nivel ICFES ↔ DOK (OBLIGATORIA)

**El Nivel ICFES del archivo (`_nX_` en el nombre y `exextra[Nivel]`) DEBE ser coherente con el DOK asignado.** Una discrepancia indica clasificación incorrecta.

| DOK | Bloom típico | Nivel ICFES compatible | Nivel ICFES incompatible |
|-----|-------------|----------------------|------------------------|
| 1 (Recall) | Recordar | N1 | N2, N3, N4 |
| 2 (Skill/Concept) | Comprender, Aplicar | N1, N2 | N3, N4 |
| 3 (Strategic Thinking) | Analizar, Evaluar | **N3** | N1, N2 |
| 4 (Extended Thinking) | Crear, Sintetizar | N3, N4 | N1, N2 |

**Regla de validación**: Si `DOK >= 3` → `Nivel ICFES >= 3`. Si `Bloom = Evaluar` → `Nivel >= 3`.

**Antipatrón PROHIBIDO:**
```yaml
# ❌ INCORRECTO — DOK 3 con Nivel 2 es contradictorio
exextra[DOK]: 3
exextra[Bloom]: Evaluar
exextra[Nivel]: 2   # ← Nivel demasiado bajo para DOK 3

# ✅ CORRECTO — DOK y Nivel coherentes
exextra[DOK]: 3
exextra[Bloom]: Evaluar
exextra[Nivel]: 3   # ← Coherente con DOK 3
```

**Razón**: Un ejercicio clasificado como DOK 3 (pensamiento estratégico) requiere análisis y evaluación no rutinarios, lo cual corresponde a Nivel 3 ICFES. Asignar Nivel 2 minimiza la complejidad real del ejercicio y confunde la calibración del banco de preguntas.

---

## Metadatos Obligatorios Adicionales

```yaml
# Taxonomías cognitivas (OBLIGATORIAS)
exextra[DOK]: [2|3|4]              # Webb's Depth of Knowledge
exextra[Bloom]: [Analizar|Evaluar] # Taxonomía Bloom Revisada
exextra[SOLO]: [Relacional|Abstracto-Extendido]  # Estructura SOLO

# Tipo de metacognición
exextra[TipoMetacognicion]: [analisis_error|evaluacion_afirmacion|comparacion_procedimientos]
```

---

## Ejemplo Completo Mínimo

Ver archivo de referencia:
`A-Produccion/03-En-Produccion/.../promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd`

---

**Versión**: 1.0
**Fecha**: 2026-02-06
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: NINGUNA

**Fundamento científico**:
- Schraw & Dennison (1994) - Metacognitive awareness
- Dunlosky et al. (2013) - Learning techniques meta-analysis
- Anderson & Krathwohl (2001) - Bloom's Taxonomy Revised
- Webb (1997) - Depth of Knowledge
