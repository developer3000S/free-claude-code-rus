# Regla: Gráficos Como Opciones Individuales (OBLIGATORIO)

## Principio Fundamental

**Cuando las opciones de respuesta de un ejercicio SCHOICE son gráficos, CADA gráfico DEBE ser una imagen PNG separada referenciada individualmente en el Answerlist.**

Esta regla NO tiene excepciones. Nunca usar `grid.arrange()` o similar para mostrar todos los gráficos juntos.

---

## ⚠️ REGLA CRÍTICA: Sin Títulos con Letras en Gráficos

**Los gráficos de opciones NUNCA deben tener títulos con letras (A, B, C, D).**

Los gráficos NO deben tener letras fijas porque el orden se determina por la mezcla interna con `sample()`.

### ❌ PROHIBIDO: Títulos con letras

```r
# ❌ INCORRECTO - El título "A" no se reordena cuando R-exams mezcla
labs(title = "A")
labs(title = paste0("Opción ", letra))
```

### ✅ CORRECTO: Sin título o título genérico

```r
# ✅ CORRECTO - R-exams asigna (a), (b), (c), (d) automáticamente
labs(title = NULL)
```

---

## Patrón Correcto (Basado en Ejemplo Funcional)

### 1. Mezclar opciones internamente + exshuffle:FALSE

```r
# Crear lista de todas las opciones
todas_opciones <- list(
  correcta = stats_correctas,
  distractor1 = distractor1,
  distractor2 = distractor2,
  distractor3 = distractor3
)

# Mezclar internamente
opciones_mezcladas <- sample(todas_opciones)

# Identificar la posición de la respuesta correcta
indice_correcto <- which(names(opciones_mezcladas) == "correcta")

# Crear el vector de solución para r-exams
solucion <- rep(0, 4)
solucion[indice_correcto] <- 1

# Crear mapeo entre letras y estadísticas
letras <- c("A", "B", "C", "D")
mapeo_letras_stats <- setNames(names(opciones_mezcladas), letras)

# Identificar qué letra corresponde a la respuesta correcta
letra_correcta <- names(mapeo_letras_stats)[which(mapeo_letras_stats == "correcta")]

# Asignar nombres de letras a las opciones
names(opciones_mezcladas) <- letras
```

### 2. Generar gráficos con nombres de letra (sin título)

```r
# Función para crear y GUARDAR gráfico sin título
crear_y_guardar_grafico <- function(datos, letra, ...) {
  p <- ggplot(datos, aes(...)) +
    geom_...() +
    # ✅ SIN TÍTULO - R-exams asigna las letras automáticamente
    labs(title = NULL, x = NULL, y = NULL) +
    theme_minimal()

  # Guardar con nombre de letra (diagrama_a.png, etc.)
  nombre_archivo <- paste0("diagrama_", tolower(letra), ".png")
  ggsave(nombre_archivo, plot = p, width = 4, height = 5, dpi = 150, bg = "white")

  return(p)
}

# Generar los 4 gráficos
plot_A <- crear_y_guardar_grafico(opciones_mezcladas$A, "A", ...)
plot_B <- crear_y_guardar_grafico(opciones_mezcladas$B, "B", ...)
plot_C <- crear_y_guardar_grafico(opciones_mezcladas$C, "C", ...)
plot_D <- crear_y_guardar_grafico(opciones_mezcladas$D, "D", ...)
```

### 3. Answerlist con imágenes de letras

```markdown
Answerlist
----------

` ``{r mostrar_opciones, echo=FALSE, results='asis'}
cat("* ![](diagrama_a.png){width=60%}\n")
cat("* ![](diagrama_b.png){width=60%}\n")
cat("* ![](diagrama_c.png){width=60%}\n")
cat("* ![](diagrama_d.png){width=60%}\n")
` ``
```

### 4. Solution con diagrama correcto dinámico

```markdown
### Respuesta Correcta: `r letra_correcta`

**Justificación matemática:**
[...]

**Por lo tanto**, la respuesta correcta es la **opción `r letra_correcta`**...

` ``{r mostrar_diagrama_correcto, echo=FALSE, results='asis'}
letra_correcta_lower <- tolower(letra_correcta)
nombre_archivo <- paste0("diagrama_", letra_correcta_lower, ".png")
cat("![](", nombre_archivo, "){width=70%}", sep = "")
` ``
```

### 5. Meta-information correcta

```yaml
extype: schoice
exsolution: `r paste(as.integer(solucion), collapse="")`
exshuffle: FALSE        # La mezcla interna con sample() ya aleatoriza
```

---

## ¿Por Qué Mezcla Interna + exshuffle:FALSE?

### El problema con exshuffle:TRUE en opciones gráficas

Cuando `exshuffle: TRUE`, R-exams:
1. Lee las opciones (diagrama_a.png, diagrama_b.png, etc.)
2. Re-mezcla su ORDEN (diagrama_b podría aparecer como opción (a))
3. Ajusta `exsolution` automáticamente
4. **PERO NO modifica el texto de la Solution**

Esto causa que la Solution diga "La respuesta correcta es la **Opción A**" pero R-exams haya movido esa opción a la posición (c). **Inconsistencia fatal.**

### La solución: sample() interno + exshuffle:FALSE

La mezcla interna con `sample()` en `data_generation`:
1. Aleatoriza el orden de opciones **en cada renderizado** (diferentes semillas = diferente orden)
2. Permite conocer `letra_correcta` para mostrarla en la Solution
3. Genera archivos con nombres consistentes (diagrama_a.png, etc.)
4. `exshuffle: FALSE` evita que R-exams re-mezcle y rompa la referencia en Solution

**Resultado**: Cada renderizado produce un orden diferente (por `sample()`), Y la Solution siempre indica la letra correcta.

### Regla general vs excepción

| Caso | exshuffle | Razón |
|------|-----------|-------|
| Opciones de texto | `TRUE` | R-exams puede reordenar sin problema |
| **Opciones gráficas PNG + Solution con `letra_correcta`** | **`FALSE`** | `sample()` ya aleatoriza; TRUE rompería la referencia en Solution |

**Ver también**: `.claude/rules/codigo-rmd.md` regla #6 para la regla general

---

## Antipatrones PROHIBIDOS

### ❌ 1. Títulos con letras en gráficos

```r
# ❌ PROHIBIDO - Las letras quedan fijas visualmente
labs(title = "A")
labs(title = letra)
```

### ❌ 2. grid.arrange() para mostrar opciones juntas

```r
# ❌ PROHIBIDO - Todos los gráficos en una sola imagen
library(gridExtra)
grid.arrange(plot_A, plot_B, plot_C, plot_D, ncol = 2)
```

### ❌ 3. exshuffle: TRUE con opciones gráficas + Solution con letra

```yaml
# ❌ PROHIBIDO en SCHOICE con opciones gráficas PNG + Solution que referencia letra_correcta
# R-exams re-mezcla las opciones pero NO modifica el texto de la Solution → inconsistencia
exshuffle: TRUE

# ✅ CORRECTO para este caso - sample() interno ya aleatoriza
exshuffle: FALSE
```

---

## Errores Visuales a Evitar

### Error EST-BOX-01 (Confusión posición/valor)

**PROHIBIDO en ejercicios con gráficos comparativos.**

Este error genera valores 1-11 (posiciones) en lugar de valores reales (ej: 150-190 cm).

```r
# ❌ PROHIBIDO en ejercicios gráficos
errores_conceptuales[[1]]  # EST-BOX-01

# ✅ CORRECTO - Solo usar errores que mantienen el rango de valores
errores_validos_para_grafico <- c(2, 3, 4)  # Excluir índice 1
```

### Escala del Eje Y

Calcular el rango basándose en TODOS los valores de las opciones:

```r
# ✅ CORRECTO - Rango que incluye todos los valores
y_min_global <- min(sapply(opciones_graficos, function(x) x$min)) - 2
y_max_global <- max(sapply(opciones_graficos, function(x) x$max)) + 2
```

---

## Checklist Pre-Generación

- [ ] ¿Los gráficos NO tienen título con letras (`labs(title = NULL)`)?
- [ ] ¿Hay mezcla interna con `sample()` + tracking de `letra_correcta`?
- [ ] ¿Los archivos usan nombres con letras (`diagrama_a.png`, etc.)?
- [ ] ¿`exshuffle: FALSE` está en Meta-information? (sample() interno ya aleatoriza)
- [ ] ¿Se excluyeron errores fuera de rango (EST-BOX-01)?
- [ ] ¿El eje Y tiene un rango que incluye todos los valores?

---

## Checklist Post-Generación

- [ ] ¿Las opciones aparecen en orden (a), (b), (c), (d)?
- [ ] ¿Los gráficos NO tienen títulos con letras visibles?
- [ ] ¿Cada opción muestra un gráfico diferente?
- [ ] ¿La Solution indica correctamente la opción correcta?
- [ ] ¿Al renderizar múltiples veces, las opciones se mezclan?

---

## Ejemplo Funcional de Referencia

Ver archivos validados:
```
A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/
  estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2.Rmd
```

---

## Integración con Detractor

El dominio `visual` del detractor DEBE verificar:

1. Gráficos guardados como PNGs individuales
2. **Gráficos SIN títulos con letras**
3. Answerlist referencia imágenes con letras
4. Escala compartida apropiada para todas las opciones
5. No hay errores que generen valores fuera de rango
6. `exshuffle: FALSE` + mezcla interna con `sample()` (para opciones gráficas con Solution que referencia letra)
7. **Formato equilibrado**: al menos 2 opciones comparten el formato de la opción correcta (ver §Formato Equilibrado)

---

## Formato Equilibrado en Opciones Gráficas (OBLIGATORIO)

### Principio Fundamental

**Cuando las opciones de un SCHOICE son gráficos, el formato de la opción correcta (barras, torta, etc.) DEBE aparecer en al menos 2 de las 4 opciones. Idealmente, usar 2 opciones de un formato + 2 de otro.**

Esta regla previene que el estudiante identifique la respuesta correcta por el formato del gráfico sin verificar los datos. Si hay 3 tortas y 1 barra, y la barra siempre es incorrecta (o siempre es correcta), el estudiante aprende el patrón y deja de analizar.

### Evidencia del problema

En la v1 de `distribucion-contagiados` (2026-05-14), la opción correcta era SIEMPRE una torta de 3 sectores. Las 4 opciones eran: 3 tortas + 1 barra. Un estudiante que detectara "la barra nunca es correcta" podía descartar una opción sin leer la tabla.

En la v2, se reorganizó a 2 barras + 2 tortas. El estudiante ya no puede descartar por formato.

### Patrón Correcto (2+2)

```
✅ CORRECTO — formato equilibrado
   Opción correcta: Barras con categorías y alturas exactas
   Distractor 1:   Torta con categoría extra
   Distractor 2:   Torta con áreas iguales
   Distractor 3:   Barras con categorías correctas + alturas permutadas (GRAF-BAR-01)

   → 2 barras + 2 tortas. Estudiante debe verificar datos, no formato.
```

### Patrones PROHIBIDOS

```
❌ 3 tortas + 1 barra (o viceversa) — el formato único delata la respuesta
❌ 4 del mismo formato — no evalúa interpretación entre formatos
❌ La opción correcta es la ÚNICA de su formato — patrón detectable
```

### Verificación obligatoria en data_generation

```r
# Validar equilibrio de formatos (al menos 2 del formato correcto)
formato_correcto <- opciones_mezcladas[[letra_correcta]]$formato
n_formato_correcto <- sum(sapply(opciones_mezcladas, function(x) x$formato == formato_correcto))
stopifnot(n_formato_correcto >= 2,
          "La opción correcta es la única de su formato — el estudiante puede detectar el patrón")
```

### Catálogo de distractores por formato

Para lograr el equilibrio 2+2 sin sacrificar calidad, se requieren distractores en AMBOS formatos:

| Formato | Distractor | Código | Qué viola |
|---------|-----------|--------|-----------|
| Torta | Categoría extra ("Otro") | GRAF-TOR-01 | Correspondencia de categorías |
| Torta | Áreas iguales | GRAF-TOR-02 | Proporcionalidad |
| Barras | Categoría inventada | GRAF-TOR-03 | Correspondencia de categorías |
| Barras | Alturas permutadas | GRAF-BAR-01 | Fidelidad de valores por categoría |

Ver Error 20 en `patrones-errores-conocidos.md` para el patrón GRAF-BAR-01.

---

## Resumen de la Regla

| Aspecto | ❌ PROHIBIDO | ✅ CORRECTO |
|---------|-------------|-------------|
| Título del gráfico | `labs(title = "A")` | `labs(title = NULL)` |
| Nombre de archivo | N/A | `diagrama_a.png` |
| Mezcla de opciones | Sin mezcla | Interna con `sample()` |
| Solution | Sin indicar opción | Indica `letra_correcta` |
| exshuffle | TRUE (rompe referencia en Solution) | FALSE (sample() ya aleatoriza) |
| Formato equilibrado | 1 solo del formato correcto | Al menos 2 comparten el formato correcto |

---

**Versión**: 5.0
**Fecha**: 2026-05-14
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: Ver regla general en `codigo-rmd.md` para otros tipos de ejercicios

### Cambios v5.0 (2026-05-14)
- **NUEVA SECCIÓN**: Formato Equilibrado en Opciones Gráficas (OBLIGATORIO)
- **Principio**: al menos 2 de las 4 opciones deben compartir el formato de la opción correcta
- **Catálogo de distractores por formato**: GRAF-TOR-01, GRAF-TOR-02, GRAF-TOR-03, GRAF-BAR-01
- **Verificación en código**: `stopifnot` de equilibrio de formatos en `data_generation`
- **Origen**: sesión v2 `distribucion-contagiados` — detectado patrón "la torta siempre es correcta"
- **Referencias cruzadas**: Error 18 y Error 20 en `patrones-errores-conocidos.md`
- **Detractor**: checklist ampliado a 7 puntos (agregado punto 7: formato equilibrado)

### Cambios v4.0 (2026-02-08)
- **CORRECCIÓN CRÍTICA**: `exshuffle: FALSE` es OBLIGATORIO para SCHOICE con opciones gráficas PNG
- **Razón**: `exshuffle: TRUE` causa que R-exams re-mezcle opciones pero NO modifique el texto de la Solution, rompiendo la referencia a `letra_correcta`
- **Patrón validado**: `sample()` interno + `exshuffle: FALSE` (aleatorización garantizada por sample)
- **Referencias cruzadas**: `codigo-rmd.md` regla #6 actualizada con esta excepción
- **Evidencia**: Sesiones `7e7d763f` y `93b0708f` validaron este patrón

### Cambios v3.0 (2026-02-07)
- **Patrón basado en ejemplo funcional**: Mezcla interna + tracking de `letra_correcta`
- **Nombres con letras**: `diagrama_a.png` (no numéricos)
- **Solution dinámico**: Muestra opción correcta con variable
