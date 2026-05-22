# Anatomía de un Archivo .Rmd SCHOICE

## ⚠️ IMPORTANTE: Estructura Metacognitiva Obligatoria

**A partir de v3.0, TODOS los ejercicios deben ser metacognitivos.**

Para la anatomía completa de ejercicios metacognitivos (8 secciones), ver:
→ [anatomia-metacognitiva.md](anatomia-metacognitiva.md)

Este documento describe la estructura **básica mínima** de 7 secciones.
La estructura metacognitiva EXTIENDE esta base con componentes adicionales.

---

Un archivo SCHOICE válido tiene exactamente **7 secciones** en este orden:

```
1. ENCABEZADO YAML (output + header-includes)
2. CHUNK setup (librerías + configuración)
3. CHUNK data_generation (aleatorización + cálculos)
4. CHUNK version_diversity_test (validación 250+ versiones)
5. SECCIÓN Question (enunciado + Answerlist)
6. SECCIÓN Solution (explicación + Answerlist)
7. META-INFORMATION (metadatos R/exams + ICFES)
```

**Para ejercicios metacognitivos (OBLIGATORIO desde v3.0):**

```
1. ENCABEZADO YAML (+ taxonomías cognitivas)
2. CHUNK setup (+ testthat, digest)
3. CHUNK data_generation (+ pool de errores conceptuales)
4. CHUNK version_diversity_test
5. CHUNK validaciones_matematicas (NUEVO)
6. SECCIÓN Question (patrón metacognitivo)
7. SECCIÓN Solution (análisis de error + reflexión)
8. META-INFORMATION (+ DOK, Bloom, SOLO)
```

## Sección 1: Encabezado YAML

Configurar renderizado LaTeX/PDF con soporte TikZ y español.

```yaml
---
output:
  pdf_document:
    keep_tex: true
header-includes:
  - \usepackage{tikz}
  - \usepackage{pgfplots}
  - \pgfplotsset{compat=1.18}
  - \usepackage[spanish]{babel}
  - \decimalpoint
---
```

Campos obligatorios:

- `pdf_document` + `keep_tex: true` para debugging
- TikZ packages para gráficos vectoriales
- `babel[spanish]` + `\decimalpoint` para separadores correctos (1.234,56)

## Sección 2: Chunk setup

```r
```{r setup, include=FALSE}
library(exams)
library(tidyverse)
library(knitr)
# library(reticulate) # Solo si usa Python

knitr::opts_chunk$set(
  echo = FALSE,
  message = FALSE,
  warning = FALSE,
  fig.path = "figures/",
  fig.width = 8,
  fig.height = 5
)
```
```

## Sección 3: Chunk data_generation

```r
```{r data_generation, include=FALSE}
generar_datos <- function() {
  # 1. PARÁMETROS ALEATORIOS
  a <- sample(2:9, 1)
  b <- sample(10:20, 1)
  c <- sample(5:15, 1)

  # 2. CÁLCULO RESPUESTA CORRECTA
  respuesta_correcta <- (a * b) + c

  # 3. DISTRACTORES (mínimo 3)
  distractor1 <- a * b  # error: olvidar sumar c
  distractor2 <- (a + b) + c  # error: cambiar multiplicación por suma
  distractor3 <- a * (b + c)  # error: distributiva incorrecta

  # 4. LISTA DE OPCIONES
  opciones <- c(respuesta_correcta, distractor1, distractor2, distractor3)

  # 5. RETORNAR LISTA
  list(
    a = a,
    b = b,
    c = c,
    respuesta_correcta = respuesta_correcta,
    opciones = opciones,
    posicion_correcta = 1
  )
}

datos <- generar_datos()
a <- datos$a
b <- datos$b
c <- datos$c
respuesta <- datos$respuesta_correcta
opciones <- datos$opciones
```
```

Reglas críticas:

- SIEMPRE encapsular en función `generar_datos()`
- **Distractores basados en errores conceptuales documentados (pool de errores)**
- NO usar distractores aleatorios (`respuesta + sample(-10:10, 3)` PROHIBIDO)
- NO hacer shuffle manual (R/exams lo hace con `exshuffle: TRUE`; excepción: SCHOICE con PNGs gráficos usa `sample()` interno + `exshuffle: FALSE` — ver `graficos-como-opciones.md`)
- **Para ejercicios metacognitivos**: incluir pool de errores con código, descripción y función calcula()

## Sección 4: Chunk version_diversity_test

```r
```{r version_diversity_test, include=FALSE}
test_versiones <- function(n = 300) {
  versiones <- replicate(n, {
    datos <- generar_datos()
    paste(datos$a, datos$b, datos$c, datos$respuesta_correcta, sep = "_")
  }, simplify = TRUE)

  n_unicas <- length(unique(versiones))
  porcentaje <- round(100 * n_unicas / n, 1)

  cat("Versiones únicas:", n_unicas, "/", n, "(", porcentaje, "%)\n")

  if (n_unicas < 250) {
    warning("ALERTA: Menos de 250 versiones únicas.")
  }

  return(n_unicas)
}

# Ejecutar test (comentar después de validar)
# test_versiones(300)
```
```

Requisitos: Mínimo 250 versiones únicas de 300 intentos (83%).

## Sección 5: Question

```markdown
Question
========

[Contexto o introducción si aplica]

**Enunciado de la pregunta usando variables dinámicas**

Dado que $a = `r a`$ y $b = `r b`$, calcula el valor de $(a \times b) + `r c`$.

Answerlist
----------
* `r format(opciones[1], big.mark = ".", decimal.mark = ",", scientific = FALSE)`
* `r format(opciones[2], big.mark = ".", decimal.mark = ",", scientific = FALSE)`
* `r format(opciones[3], big.mark = ".", decimal.mark = ",", scientific = FALSE)`
* `r format(opciones[4], big.mark = ".", decimal.mark = ",", scientific = FALSE)`
```

Reglas:

- Encabezado `Question` con 8 signos `=`
- Variables inline con `` `r variable` ``
- Answerlist con 10 guiones `-`
- SIEMPRE usar `format()` con separadores españoles

## Sección 6: Solution

```markdown
Solution
========

**Paso 1: Identificar la operación**
Se debe calcular $(a \times b) + c$ con los valores dados.

**Paso 2: Sustituir valores**
$$(`r a` \times `r b`) + `r c`$$

**Paso 3: Resolver**
$$`r a * b + c`$$

Por lo tanto, la respuesta correcta es **`r format(respuesta, big.mark = ".", decimal.mark = ",")`**.

Answerlist
----------
* **Correcta**: Resultado de $(a \times b) + c$
* Falsa: Olvidó sumar $c$
* Falsa: Cambió multiplicación por suma
* Falsa: Aplicó distributiva incorrecta
```

## Sección 7: Meta-information

```markdown
Meta-information
================
exname: nombre_ejercicio
extype: schoice
exsolution: 1000
exshuffle: TRUE  # FALSE en SCHOICE con opciones gráficas PNG (ver graficos-como-opciones.md)
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Numérico-Variacional
exextra[Afirmacion]: Resuelve operaciones aritméticas básicas
exextra[Evidencia]: Aplica orden de operaciones correctamente
exextra[Nivel]: 1

# Taxonomías cognitivas (OBLIGATORIAS para ejercicios metacognitivos)
exextra[DOK]: 3
exextra[Bloom]: Analizar
exextra[SOLO]: Relacional
exextra[TipoMetacognicion]: analisis_error
```

Códigos exsolution:

- `1000` = primera opción correcta
- `0100` = segunda opción correcta
- `0010` = tercera opción correcta
- `0001` = cuarta opción correcta

---

## Referencia: Estructura Metacognitiva Completa

Para ejercicios metacognitivos (OBLIGATORIOS desde v3.0), consultar:

- [anatomia-metacognitiva.md](anatomia-metacognitiva.md) - Estructura de 8 secciones
- `.claude/rules/ejercicios-metacognitivos.md` - Regla completa
- Ejemplo canónico: `A-Produccion/03-En-Produccion/.../promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd`
