# Plantilla Completa de Sección Solution - Estilo ICFES

Esta plantilla replica exactamente el formato de retroalimentación utilizado en la Guía de Orientación ICFES Matemáticas 11° (páginas 22-51).

---

## Plantilla SCHOICE

```markdown
Solution
========

### Información de la Pregunta

| Aspecto | Descripción |
|---------|-------------|
| **Competencia** | `r competencia` |
| **Componente** | `r componente` |
| **Afirmación** | `r afirmacion` |
| **Evidencia** | `r evidencia` |
| **Nivel de dificultad** | `r paste0("N", nivel)` |

### ¿Qué evalúa esta pregunta?

Esta pregunta evalúa la capacidad del estudiante para `r descripcion_evaluacion`.

### Respuesta Correcta: `r letra_correcta`

**Justificación matemática:**

`r justificacion_correcta`

### Opciones No Válidas

`r opciones_no_validas`

### Reflexión Metacognitiva

`r sample(reflexiones_metacognitivas, 1)`

**Estrategias para evitar errores comunes:**
`r estrategias_preventivas`
```

---

## Plantilla CLOZE

```markdown
Solution
========

### Información de la Pregunta

| Aspecto | Descripción |
|---------|-------------|
| **Competencia** | `r competencia` |
| **Componente** | `r componente` |
| **Afirmación** | `r afirmacion` |
| **Evidencia** | `r evidencia` |
| **Nivel de dificultad** | `r paste0("N", nivel)` |

### ¿Qué evalúa esta pregunta?

Esta pregunta evalúa la capacidad del estudiante para `r descripcion_evaluacion`
utilizando un formato de respuesta compuesto que requiere múltiples habilidades.

### Parte 1: `r parte1_descripcion`

**Respuesta correcta:** `r parte1_respuesta`

**Justificación:** `r parte1_justificacion`

**Opciones no válidas (si aplica):**
`r parte1_opciones_invalidas`

### Parte 2: `r parte2_descripcion`

**Respuesta correcta:** `r parte2_respuesta`

**Justificación:** `r parte2_justificacion`

[Continuar para cada parte del CLOZE]

### Análisis Integrado de Errores

`r analisis_errores_integrado`

### Reflexión Metacognitiva

`r sample(reflexiones_metacognitivas, 1)`

**Estrategias para evitar errores comunes:**
`r estrategias_preventivas`
```

---

## Código R para Generar Retroalimentación

### Función para generar análisis de opciones no válidas

```r
generar_opciones_no_validas <- function(errores_conceptuales, respuesta_correcta_idx) {
  # Filtrar solo los errores que NO corresponden a la respuesta correcta
  errores_distractores <- errores_conceptuales[-respuesta_correcta_idx]
  letras <- LETTERS[setdiff(1:4, respuesta_correcta_idx)]

  texto <- ""
  for (i in seq_along(errores_distractores)) {
    error <- errores_distractores[[i]]
    texto <- paste0(texto, sprintf(
      "**Opción %s:**\nEs posible que los estudiantes que eligen la opción %s %s. Este error se presenta cuando %s. Para evitar este error, el estudiante debe %s.\n\n",
      letras[i],
      letras[i],
      error$descripcion_larga,
      error$causa_raiz,
      error$estrategia_correctiva
    ))
  }

  return(texto)
}
```

### Pool de errores conceptuales con formato completo

```r
# Ejemplo para estadística - medidas de tendencia central
errores_conceptuales_estadistica <- list(
  list(
    codigo = "EST-MTC-01",
    nombre = "Confusión media-valor",
    descripcion_corta = "Usa un valor de los datos como la media",
    descripcion_larga = "confundan el promedio aritmético con uno de los valores individuales del conjunto de datos, seleccionando un dato específico en lugar de calcular la suma dividida por la cantidad de elementos",
    causa_raiz = "el estudiante no distingue entre un valor del conjunto y la medida de tendencia central que resume todos los valores",
    estrategia_correctiva = "recordar que la media siempre se calcula sumando TODOS los valores y dividiendo por la cantidad total, y verificar que el resultado obtenido sea coherente con la magnitud de los datos",
    calcula = function(datos) datos[sample(length(datos), 1)]
  ),
  list(
    codigo = "EST-MTC-02",
    nombre = "Suma sin división",
    descripcion_corta = "Suma los datos sin dividir por n",
    descripcion_larga = "sumen todos los valores del conjunto de datos pero olviden dividir por la cantidad de elementos, obteniendo la suma total en lugar del promedio",
    causa_raiz = "el estudiante recuerda solo parcialmente la fórmula de la media aritmética, aplicando únicamente la suma",
    estrategia_correctiva = "recordar la fórmula completa: $\\bar{x} = \\frac{\\sum_{i=1}^{n} x_i}{n}$, verificando que el resultado sea un valor intermedio entre el mínimo y máximo del conjunto",
    calcula = function(datos) sum(datos)
  ),
  list(
    codigo = "EST-MTC-03",
    nombre = "Confusión media-mediana",
    descripcion_corta = "Calcula la mediana en lugar de la media",
    descripcion_larga = "calculen la mediana (valor central del conjunto ordenado) cuando se les pide la media aritmética, o viceversa, confundiendo las dos medidas de tendencia central más comunes",
    causa_raiz = "el estudiante no diferencia claramente entre las definiciones de media (promedio aritmético) y mediana (valor central)",
    estrategia_correctiva = "recordar que MEDIA = suma/cantidad y MEDIANA = valor del medio cuando los datos están ordenados, y verificar cuál medida se solicita en el problema",
    calcula = function(datos) median(datos)
  ),
  list(
    codigo = "EST-MTC-04",
    nombre = "División incorrecta por n-1",
    descripcion_corta = "Divide por n-1 en lugar de n",
    descripcion_larga = "dividan la suma de los datos por (n-1) en lugar de n, confundiendo la fórmula de la media poblacional con la corrección de Bessel usada para la varianza muestral",
    causa_raiz = "el estudiante mezcla conceptos de estadística descriptiva e inferencial, o ha memorizado incorrectamente la fórmula",
    estrategia_correctiva = "recordar que para la media SIEMPRE se divide por n (la cantidad total de datos), reservando n-1 solo para el cálculo de varianza muestral",
    calcula = function(datos) sum(datos) / (length(datos) - 1)
  )
)
```

### Función para generar justificación matemática paso a paso

```r
generar_justificacion_correcta <- function(datos, operacion = "media") {
  if (operacion == "media") {
    n <- length(datos)
    suma <- sum(datos)
    media <- mean(datos)

    texto <- paste0(
      "**Paso 1:** Identificar los datos del problema\n",
      "$$\\text{Datos: } ", paste(datos, collapse = ", "), "$$\n",
      "$$n = ", n, " \\text{ elementos}$$\n\n",

      "**Paso 2:** Calcular la suma de todos los valores\n",
      "$$\\sum_{i=1}^{", n, "} x_i = ", paste(datos, collapse = " + "), " = ", suma, "$$\n\n",

      "**Paso 3:** Aplicar la fórmula de la media aritmética\n",
      "$$\\bar{x} = \\frac{\\sum_{i=1}^{n} x_i}{n} = \\frac{", suma, "}{", n, "} = ", media, "$$\n\n",

      "**Por lo tanto**, la media aritmética del conjunto de datos es **", media, "**."
    )

    return(texto)
  }
  # Agregar más operaciones según necesidad
}
```

### Pool de reflexiones metacognitivas expandido

```r
reflexiones_metacognitivas <- c(
  "Identificar errores en el razonamiento de otros nos ayuda a evitar cometerlos nosotros mismos. La metacognición es fundamental para el aprendizaje matemático.",

  "Analizar por qué una respuesta es incorrecta fortalece la comprensión profunda del concepto. Este proceso de autoevaluación mejora significativamente el desempeño.",

  "Los errores más frecuentes en estadística están relacionados con la confusión entre diferentes medidas de tendencia central. Reconocerlos es el primer paso para superarlos.",

  "Cuando identificamos el tipo de error conceptual, podemos diseñar estrategias específicas para evitarlo en el futuro.",

  "La diferencia entre un error de cálculo y un error conceptual es importante: el primero es mecánico, el segundo requiere revisar la comprensión del concepto.",

  "Verificar la razonabilidad del resultado es una estrategia metacognitiva clave: ¿tiene sentido este valor en el contexto del problema?",

  "Antes de seleccionar una respuesta, es útil estimar mentalmente el rango esperado del resultado y verificar que la opción elegida sea coherente.",

  "Los expertos en matemáticas no solo calculan correctamente, sino que también verifican sus resultados usando múltiples estrategias."
)
```

### Función para generar estrategias preventivas

```r
generar_estrategias_preventivas <- function(errores_usados) {
  estrategias_base <- c(
    "Verificar que el resultado obtenido sea coherente con el contexto del problema.",
    "Releer el enunciado para confirmar qué operación o medida se solicita.",
    "Estimar mentalmente un rango razonable para la respuesta antes de calcular.",
    "Aplicar la fórmula paso a paso, verificando cada operación intermedia.",
    "Comprobar el resultado sustituyendo valores o usando un método alternativo."
  )

  # Agregar estrategias específicas basadas en los errores
  estrategias_especificas <- sapply(errores_usados, function(e) e$estrategia_correctiva)

  todas <- unique(c(estrategias_base[1:3], estrategias_especificas[1]))

  texto <- paste0(
    "1. ", todas[1], "\n",
    "2. ", todas[2], "\n",
    "3. ", todas[3], "\n",
    "4. ", todas[4]
  )

  return(texto)
}
```

---

## Ejemplos Adicionales por Componente

### Componente Numérico-Variacional (Álgebra)

```markdown
### Respuesta Correcta: B

**Justificación matemática:**

Para resolver la ecuación $3x + 7 = 22$, debemos despejar la variable $x$:

**Paso 1:** Restar 7 a ambos lados de la ecuación
$$3x + 7 - 7 = 22 - 7$$
$$3x = 15$$

**Paso 2:** Dividir ambos lados por 3
$$\frac{3x}{3} = \frac{15}{3}$$
$$x = 5$$

**Paso 3:** Verificación (sustituyendo en la ecuación original)
$$3(5) + 7 = 15 + 7 = 22 \checkmark$$

**Por lo tanto**, la respuesta correcta es **B** ($x = 5$).

### Opciones No Válidas

**Opción A ($x = 3$):**
Es posible que los estudiantes que eligen la opción A dividan 22 entre 7
aproximando a 3, ignorando el término $3x$. Este error se presenta cuando
el estudiante no comprende que debe despejar la variable aplicando
operaciones inversas en el orden correcto. Para evitar este error, el
estudiante debe recordar que primero se eliminan los términos constantes
y luego el coeficiente de la variable.

**Opción C ($x = 7$):**
Es posible que los estudiantes que eligen la opción C resten 7 de 22
correctamente obteniendo 15, pero luego no dividan por 3, tomando
erróneamente 7 como respuesta (confundiendo el término independiente
con la solución). Este error se presenta cuando el estudiante completa
solo parcialmente el proceso de despeje. Para evitar este error, el
estudiante debe verificar sustituyendo: $3(7) + 7 = 28 \neq 22$.

**Opción D ($x = 15$):**
Es posible que los estudiantes que eligen la opción D calculen
correctamente $22 - 7 = 15$ pero olviden dividir por el coeficiente 3,
confundiendo el valor de $3x$ con el valor de $x$. Este error se presenta
cuando el estudiante no distingue entre la expresión $3x$ y la variable
$x$. Para evitar este error, el estudiante debe verificar:
$3(15) + 7 = 52 \neq 22$.
```

### Componente Geométrico-Métrico

```markdown
### Respuesta Correcta: C

**Justificación matemática:**

Para calcular el área de un triángulo con base $b = 8$ cm y altura $h = 6$ cm:

**Paso 1:** Recordar la fórmula del área del triángulo
$$A = \frac{b \times h}{2}$$

**Paso 2:** Sustituir los valores
$$A = \frac{8 \times 6}{2}$$

**Paso 3:** Realizar las operaciones
$$A = \frac{48}{2} = 24 \text{ cm}^2$$

**Por lo tanto**, el área del triángulo es **24 cm²**, correspondiente a la opción **C**.

### Opciones No Válidas

**Opción A (48 cm²):**
Es posible que los estudiantes que eligen la opción A multipliquen
correctamente base por altura ($8 \times 6 = 48$) pero olviden dividir
por 2, aplicando la fórmula del rectángulo en lugar del triángulo.
Este error se presenta cuando el estudiante no recuerda que el triángulo
es "la mitad del rectángulo". Para evitar este error, el estudiante
debe visualizar que el triángulo cabe exactamente dos veces en el
rectángulo de misma base y altura.

**Opción B (14 cm²):**
Es posible que los estudiantes que eligen la opción B confundan área
con perímetro, sumando base más altura ($8 + 6 = 14$) en lugar de
multiplicar. Este error se presenta cuando el estudiante no distingue
entre perímetro (suma de lados) y área (superficie cubierta). Para
evitar este error, el estudiante debe recordar que área siempre
involucra multiplicación y produce unidades cuadradas.

**Opción D (7 cm²):**
Es posible que los estudiantes que eligen la opción D sumen base más
altura y dividan por 2: $(8 + 6)/2 = 7$, mezclando incorrectamente
las fórmulas de área y promedio. Este error se presenta cuando el
estudiante confunde operaciones geométricas con estadísticas. Para
evitar este error, el estudiante debe verificar las unidades: cm²
para área, no simplemente cm.
```

---

## Notas de Implementación

### Variables Requeridas en data_generation

```r
# Obligatorio para usar esta plantilla
competencia <- "Interpretación y representación"  # o Formulación/Argumentación
componente <- "Aleatorio"  # o Numérico-variacional/Geométrico-métrico
afirmacion <- "..."
evidencia <- "..."
nivel <- 2  # 1-4
descripcion_evaluacion <- "..."
letra_correcta <- "A"  # La letra de la opción correcta
justificacion_correcta <- generar_justificacion_correcta(datos)
opciones_no_validas <- generar_opciones_no_validas(errores_conceptuales, idx_correcto)
estrategias_preventivas <- generar_estrategias_preventivas(errores_usados)
```

---

**Versión**: 1.0
**Fecha**: 2026-02-07
**Fuente**: ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023
