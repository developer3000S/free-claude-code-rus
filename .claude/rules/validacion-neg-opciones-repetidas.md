# Regla: Validación de Opciones Repetidas en Ejercicios _neg_

## Principio Fundamental

**Todo ejercicio con `_neg_` en el nombre DEBE incluir el bloque de validación genérico de opciones repetidas. Todo ejercicio SIN `_neg_` DEBE verificar que todas las opciones son únicas.**

---

## Contexto: Lógica Positiva vs Negativa

### Lógica positiva (ejercicios sin `_neg_`)

El estudiante busca la **opción correcta** entre distractores incorrectos.

```
Opciones: 1 correcta + (N-1) distractores únicos
Requisito: TODAS las opciones deben ser diferentes entre sí
```

### Lógica negativa (ejercicios con `_neg_`)

El estudiante busca la **opción incorrecta** entre opciones correctas.

```
Opciones: (N-1) correctas (equivalentes en contenido) + 1 error
Requisito: (N-1) opciones equivalentes + 1 diferente
```

**Dos modalidades de equivalencia:**

| Modalidad | Opciones correctas | Diferenciación | Test automático |
|-----------|-------------------|----------------|-----------------|
| **Gráficos** | Datos idénticos (mismos valores) | Color de relleno diferente | `digest()` sobre estructura de datos |
| **Texto** | Significado idéntico, redacción diferente (sinónimos/paráfrasis) | La propia redacción distinta | Etiquetas semánticas en lista nombrada |

**Valor pedagógico**: La lógica negativa aumenta la demanda cognitiva (DOK 2 a 3). Evaluar cada opción contra los datos requiere análisis sistemático, no solo reconocimiento.

---

## Tests OBLIGATORIOS para Ejercicios `_neg_`

Hay **dos variantes** de test según el tipo de opciones:

### Variante A: Opciones con datos/gráficos (datos idénticos)

Cuando las opciones son estructuras de datos (gráficos, tablas, listas numéricas), los datos de las (N-1) opciones correctas son **literalmente idénticos**. Se usa `digest()` para verificar.

```r
# --- Validación _neg_ para opciones con datos/gráficos ---
# Regla: .claude/rules/validacion-neg-opciones-repetidas.md
test_that("Patrón _neg_ datos: exactamente (N-1) opciones idénticas + 1 diferente", {
  letras <- c("A", "B", "C", "D")
  n_opciones <- length(letras)
  # digest() hashea cualquier estructura R de forma recursiva
  hashes <- sapply(letras, function(l) digest::digest(opciones_data[[l]]))
  freq <- table(hashes)
  expect_equal(length(freq), 2,
    info = paste("Se esperaban 2 hashes distintos, hay", length(freq)))
  expect_true((n_opciones - 1) %in% as.integer(freq),
    info = paste("Ningún hash tiene frecuencia", n_opciones - 1))
  expect_true(1 %in% as.integer(freq),
    info = "Ningún hash tiene frecuencia 1 (no hay opción única)")
  hash_unico <- names(freq)[freq == 1]
  idx_error <- which(sol == 1)
  expect_equal(length(idx_error), 1,
    info = "sol debe tener exactamente una opción marcada como correcta")
  hash_marcado <- hashes[idx_error]
  expect_equal(as.character(hash_marcado), hash_unico,
    info = "La opción marcada en sol no coincide con la opción única")
})

test_that("Patrón _neg_ datos: opciones repetidas se diferencian visualmente", {
  expect_equal(length(colores_opciones), length(sol),
    info = "Debe haber un color por cada opción")
  expect_equal(length(unique(colores_opciones)), length(sol),
    info = "Todos los colores deben ser distintos entre sí")
})
```

**Aplica a**: boxplots, barras, funciones, tablas, diagramas — cualquier opción basada en datos numéricos/estructurados.

| Tipo de ejercicio | Variable de opciones | Contenido |
|-------------------|---------------------|-----------|
| Boxplots | `opciones_graficos` | `list(min, q1, mediana, q3, max)` |
| Barras | `opciones_graficos` | `list(categorias, valores)` |
| Funciones | `opciones_graficos` | `list(coeficientes, dominio)` |
| Tablas | `opciones_datos` | `data.frame(...)` |

Adaptar `opciones_data[[l]]` al nombre de la variable usada en cada ejercicio.

### Variante B: Opciones con texto (sinónimos/paráfrasis)

Cuando las opciones son texto, las (N-1) opciones correctas expresan el **mismo significado con redacción diferente** (sinónimos, paráfrasis). `digest()` NO funciona aquí porque el texto literal es distinto.

La validación se basa en **etiquetas semánticas**: la lista nombrada de opciones usa `"correcta1"`, `"correcta2"`, `"correcta3"`, `"error"`.

```r
# --- Validación _neg_ para opciones de texto (sinónimas) ---
# Regla: .claude/rules/validacion-neg-opciones-repetidas.md
test_that("Patrón _neg_ texto: estructura semántica correcta", {
  # La lista ANTES de mezclar debe tener las etiquetas correctas
  n_opciones <- length(sol)
  n_correctas <- n_opciones - 1

  # Verificar que sol marca exactamente 1 opción (el error)
  expect_equal(sum(sol), 1,
    info = "sol debe marcar exactamente 1 opción como correcta (el error)")
  idx_error <- which(sol == 1)
  expect_equal(length(idx_error), 1,
    info = "Debe haber exactamente 1 posición marcada en sol")

  # Verificar que opciones_mezcladas conserva etiquetas semánticas
  nombres <- names(opciones_mezcladas)
  expect_true("error" %in% nombres,
    info = "opciones_mezcladas debe contener una opción etiquetada 'error'")
  n_correctas_encontradas <- sum(grepl("^correcta", nombres))
  expect_equal(n_correctas_encontradas, n_correctas,
    info = paste("Se esperaban", n_correctas, "opciones 'correcta*', hay", n_correctas_encontradas))

  # Verificar que la posición del error en sol coincide con la etiqueta
  expect_equal(nombres[idx_error], "error",
    info = "La posición marcada en sol debe corresponder a la etiqueta 'error'")
})

test_that("Patrón _neg_ texto: todas las opciones son textualmente distintas", {
  letras <- c("A", "B", "C", "D")
  textos <- sapply(letras, function(l) opciones_texto[[l]])
  # Aunque son sinónimas, el TEXTO debe ser diferente (no copiar-pegar)
  expect_equal(length(unique(textos)), length(letras),
    info = "Opciones sinónimas deben tener redacción diferente entre sí")
})
```

**Aplica a**: ejercicios donde las opciones son afirmaciones, justificaciones o descripciones textuales.

### Diseño de opciones sinónimas (guía para el autor)

Las (N-1) opciones correctas deben:

1. **Expresar el mismo significado** pero con palabras/estructura diferente
2. **No ser distinguibles** como "la original" vs "las copias" — cada una debe ser igualmente natural
3. **Variar**: vocabulario, orden de la oración, nivel de detalle, uso de sinónimos

```r
# Ejemplo: "La mediana divide el conjunto de datos en dos mitades iguales"
opciones_texto_correctas <- c(
  "La mediana separa los datos en dos grupos con igual cantidad de elementos",
  "El valor de la mediana deja la misma cantidad de datos a cada lado",
  "Al ordenar los datos, la mediana es el valor que queda en la posición central"
)

# Opción con error conceptual
opcion_error <- "La mediana es el valor que más se repite en el conjunto de datos"
# (Confunde mediana con moda — error EST-MTC-02)
```

### ¿Cuándo usar cada variante?

```
SI las opciones son gráficos/datos numéricos/tablas:
    → Variante A (digest + colores)

SI las opciones son texto/afirmaciones/justificaciones:
    → Variante B (etiquetas semánticas + texto distinto)

SI las opciones mezclan gráfico + texto (ej: gráfico con leyenda):
    → Variante A para los datos del gráfico
    → Verificar manualmente que el texto acompañante es coherente
```

---

## Test OBLIGATORIO para Ejercicios sin `_neg_`

En ejercicios de lógica positiva, todas las opciones DEBEN ser diferentes:

```r
test_that("Todas las opciones son únicas (lógica positiva)", {
  letras <- c("A", "B", "C", "D")
  hashes <- sapply(letras, function(l) digest::digest(opciones_data[[l]]))
  expect_equal(length(unique(hashes)), length(letras),
    info = "Hay opciones duplicadas - cada opción debe ser única")
})
```

---

## Convenciones para Ejercicios `_neg_`

### 1. Nomenclatura

El nombre del archivo DEBE contener `_neg_` antes de la versión:

```
[tema]_[subtema]_metacognitivo_[competencia]_n[nivel]_[tipo]_neg_v[N].Rmd
```

Ejemplo:
```
diagrama_caja_estaturas_metacognitivo_interpretacion_n2_schoice_neg_v1.Rmd
```

### 2. Diferenciación de opciones equivalentes

Las (N-1) opciones correctas son equivalentes en contenido. La estrategia de diferenciación depende del tipo:

#### Gráficos: `colores_opciones`

Todo ejercicio `_neg_` con gráficos DEBE definir un vector de colores neutrales:

```r
# Colores neutrales - NO indican correcto/incorrecto
colores_opciones <- c("white", "#E8E8E8", "#D6EAF8", "#FADBD8")
```

Los colores deben ser:
- **Neutrales**: No usar rojo/verde que sugieran correcto/incorrecto
- **Todos diferentes**: Para que el estudiante distinga visualmente las opciones
- **Asignados por posición** (A/B/C/D), no por correcto/incorrecto

#### Texto: redacción sinónima

Todo ejercicio `_neg_` con texto DEBE formular las (N-1) opciones correctas como **sinónimos o paráfrasis**:

```r
# Cada opción correcta dice LO MISMO con DIFERENTES PALABRAS
opciones_pre_mezcla <- list(
  correcta1 = "La mediana divide los datos ordenados en dos mitades iguales",
  correcta2 = "Al ordenar los datos, la mediana queda en la posición central",
  correcta3 = "La mediana separa el 50% inferior del 50% superior de los datos",
  error = "La mediana es el valor que aparece con mayor frecuencia"
)
```

Requisitos para opciones sinónimas:
- **Mismo significado**: Cada opción correcta es conceptualmente equivalente
- **Redacción distinta**: Varía vocabulario, estructura, nivel de detalle
- **Naturalidad**: Ninguna debe parecer "la original" o "la copia"
- **Indistinguibles sin conocimiento**: Solo quien sabe el concepto puede detectar el error

### 3. Variable `sol` en lógica negativa

En `_neg_`, `sol[i] == 1` marca la opción con **error** (la respuesta correcta a seleccionar):

```r
# Lógica negativa: sol marca la opción INCORRECTA (que el estudiante debe encontrar)
sol <- rep(0, 4)
indice_error <- which(names(opciones_mezcladas) == "error")
sol[indice_error] <- 1  # El error ES la respuesta correcta a marcar
```

### 4. Texto de la pregunta

Debe incluir "**NO**" con énfasis visual (negrita+cursiva):

```markdown
# Para gráficos:
¿Cuál de los siguientes diagramas ***NO*** representa correctamente [...]?

# Para texto:
¿Cuál de las siguientes afirmaciones ***NO*** es correcta sobre [...]?
```

### 5. Solution en lógica negativa

La sección Solution debe:
- Explicar por qué la opción marcada es INCORRECTA (identificar el error conceptual)
- Explicar por qué las demás opciones SÍ son correctas (aunque digan lo mismo con distintas palabras)
- Para gráficos: incluir tabla comparativa (valores correctos vs erróneos)
- Para texto: explicar la equivalencia semántica entre las opciones correctas

### 6. Metadatos cognitivos

La lógica negativa aumenta la demanda cognitiva:

```yaml
exextra[DOK]: 3                    # Strategic Thinking (mayor que positiva)
exextra[Bloom]: Evaluar            # Requiere evaluación sistemática
# Para gráficos:
exextra[TipoMetacognicion]: identificacion_error_grafico
# Para texto:
exextra[TipoMetacognicion]: identificacion_error_conceptual
```

---

## Detección Automática

Claude DEBE detectar automáticamente si un archivo es `_neg_`:

```r
es_negativo <- grepl("_neg_", nombre_archivo)
```

Y aplicar la validación correspondiente:

```
SI _neg_ en nombre:
    SI opciones son datos/gráficos:
        → Variante A: digest() para (N-1) idénticas + 1 diferente
        → Verificar: colores_opciones con N colores únicos
    SI opciones son texto:
        → Variante B: etiquetas semánticas (correcta1..N, error)
        → Verificar: textos todos diferentes (no copiar-pegar)
    EN AMBOS CASOS:
        → Verificar: sol marca exactamente 1 opción (el error)

SI NO _neg_ en nombre:
    Verificar: TODAS las opciones son únicas (digest para datos, texto literal para texto)
```

---

## Integración con Ciclo de Validación

### FASE 2A (Validación matemática automática)

El hook `post-exams2-validation.sh` y el script `validar_coherencia_matematica.R` DEBEN incluir la detección `_neg_` y aplicar el test correspondiente.

### FASE 2C (Detractor)

El dominio `codigo_rexams` del detractor DEBE verificar:
- Si archivo es `_neg_`: test de opciones repetidas presente y pasando
- Si archivo NO es `_neg_`: test de opciones únicas presente y pasando

---

## Antipatrones PROHIBIDOS

### 1. Ejercicio `_neg_` sin test de opciones

```r
# PROHIBIDO: archivo _neg_ sin validación de patrón
# El test (Variante A o B) DEBE estar presente en data_generation
```

### 2. Gráficos: opciones idénticas sin diferenciación visual

```r
# PROHIBIDO: mismos colores para opciones idénticas
colores_opciones <- c("white", "white", "white", "white")
```

### 3. Gráficos: hash específico por campos (no genérico)

```r
# PROHIBIDO: hashing que asume campos específicos
paste(g$min, g$q1, g$mediana, g$q3, g$max, sep = "-")

# CORRECTO: hashing genérico que funciona con cualquier estructura
digest::digest(opciones_data[[l]])
```

### 4. Texto: opciones correctas con texto idéntico (copiar-pegar)

```r
# PROHIBIDO: las opciones correctas son el mismo texto literal
opciones <- list(
  correcta1 = "La mediana divide los datos en dos mitades",
  correcta2 = "La mediana divide los datos en dos mitades",  # ← copiar-pegar
  correcta3 = "La mediana divide los datos en dos mitades",  # ← copiar-pegar
  error = "La mediana es el valor más frecuente"
)

# CORRECTO: cada opción correcta es una paráfrasis diferente
opciones <- list(
  correcta1 = "La mediana divide los datos en dos mitades",
  correcta2 = "Al ordenar los datos, la mediana queda en la posición central",
  correcta3 = "La mediana separa el 50% inferior del 50% superior",
  error = "La mediana es el valor más frecuente"
)
```

### 5. Texto: opciones sin etiquetas semánticas

```r
# PROHIBIDO: usar nombres genéricos que no indican rol semántico
opciones <- list(opcion1 = "...", opcion2 = "...", opcion3 = "...", opcion4 = "...")

# CORRECTO: nombres indican claramente el rol de cada opción
opciones <- list(correcta1 = "...", correcta2 = "...", correcta3 = "...", error = "...")
```

---

**Versión**: 2.0
**Fecha**: 2026-02-08
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: NINGUNA
**Aplica a**: Todo archivo .Rmd con `_neg_` en el nombre

### Cambios v2.0 (2026-02-08)
- **Dos variantes de test**: Variante A (datos/gráficos con `digest()`) y Variante B (texto sinónimo con etiquetas semánticas)
- **Opciones textuales sinónimas**: Las (N-1) correctas expresan lo mismo con diferente redacción
- **Guía de diseño**: Requisitos para opciones sinónimas (naturalidad, indistinguibilidad, variedad)
- **Nuevos antipatrones**: Texto copiar-pegar (#4), sin etiquetas semánticas (#5)

### Cambios v1.0 (2026-02-08)
- Versión inicial con test genérico `digest::digest()` para datos/gráficos
