# Pool de Errores Conceptuales — SCHOICE

## Estructura obligatoria de cada error

```r
errores_conceptuales <- list(
  list(
    codigo = "XXX-YYY-01",          # Ej: ALG-OPE-01
    nombre = "Nombre descriptivo",
    descripcion_corta = "...",       # Para opciones (max 80 chars)
    descripcion_larga = "...",       # Para solucion (detallada)
    causa_raiz = "...",              # Diagnostico pedagogico
    precondicion = function(params) TRUE,  # Cuando aplica este error
    calcula = function(datos_ord, datos_presentados = NULL) {
      # Retorna el valor erroneo que produciria este error
      # PROHIBIDO: sample(), runif(), rnorm() — calcula() debe ser funcion pura
    }
  ),
  # Minimo 4-6 errores por ejercicio
)
```

## Seleccion generica por precondiciones (patron obligatorio)

```r
params <- list(n = n, datos_ord = datos_ord)
errores_aplicables_idx <- which(sapply(errores_conceptuales, function(err) {
  if (is.null(err$precondicion)) return(TRUE)
  err$precondicion(params)
}))
error_idx <- sample(errores_aplicables_idx, 1)
error_sel <- errores_conceptuales[[error_idx]]
```

## Taxonomia de codigos

| Prefijo | Area | Ejemplo |
|---------|------|---------|
| ALG | Algebra | ALG-OPE-01 (Inversion de operacion) |
| ARI | Aritmetica | ARI-FRA-01 (Suma fracciones incorrecta) |
| EST | Estadistica | EST-MTC-01 (Confusion medidas centrales) |
| GEO | Geometria | GEO-ARE-01 (Confusion area-perimetro) |
| FUN | Funciones | FUN-PEN-01 (Confusion pendiente-intercepto) |

## Reglas criticas para calcula()

- `calcula()` DEBE ser funcion pura (determinista)
- Firma estandar: `function(datos_ord, datos_presentados = NULL)`
- PROHIBIDO dentro de `calcula()`: `sample()`, `runif()`, `rnorm()`, `rbinom()` u otras `r*()`
- Si el error depende del orden de presentacion, usar `datos_presentados` (no `sample(datos_ord)`)
- La Capa D de validacion semantica detecta no-determinismo automaticamente (`ERR_SEM_D`)

Ver regla completa: `.claude/rules/ejercicios-metacognitivos.md` — seccion "Pool de Errores Conceptuales"

## Pools dinamicos para distractores con conclusion binaria (Si/No)

Para ejercicios de **argumentacion** o **evaluacion de afirmaciones** donde cada
opcion empieza con "Si, porque..." o "No, porque...", los pools de seleccion NO
son listas fijas: dependen de flags del ejercicio (e.g., `afirmacion_es_verdadera`,
`pa_es_subiendo`).

### Patron generico

```r
# Funcion que retorna la conclusion final ("Si"/"No") de cada distractor
# en funcion de los flags activos en esta semilla.
concl_distractor <- function(idx) {
  if (idx == 1L) return("No")                                       # fijo
  if (idx == 3L) return(if (afirmacion_es_verdadera) "No" else "Sí")  # condicional
  if (idx == 4L) return("Sí")                                       # fijo
  # ... casos restantes
  stop("idx invalido")
}

todos <- c(1L, 3L, 4L, 5L, 6L)
concl_por_idx <- sapply(todos, concl_distractor)
distractores_si <- todos[concl_por_idx == "Sí"]
distractores_no <- todos[concl_por_idx == "No"]

# Calcular cuantos "Si" y cuantos "No" pedir, acotado por pool disponible
if (afirmacion_es_verdadera) {
  max_si <- min(2L, length(distractores_si))
  n_si <- if (max_si == 0L) 0L else sample(0:max_si, 1)
} else {
  max_si <- min(2L, length(distractores_si))
  min_si <- if (length(distractores_si) >= 1L) 1L else 0L
  n_si <- if (min_si > max_si) max_si else sample(min_si:max_si, 1)
}
n_no <- 3L - n_si

# Sanity checks OBLIGATORIOS antes de muestrear (regla #14)
stopifnot(
  n_si + n_no == 3L,
  n_si <= length(distractores_si),
  n_no <= length(distractores_no)
)

# Muestreo seguro contra el gotcha de sample() con length(x)==1
sel_si <- if (n_si > 0) distractores_si[sample.int(length(distractores_si), n_si)] else integer()
sel_no <- if (n_no > 0) distractores_no[sample.int(length(distractores_no), n_no)] else integer()
distractores_seleccionados <- c(sel_si, sel_no)
```

### Verificar balance posible en TODAS las combinaciones de flags

Antes de aceptar el diseno, simular los 2^k casos posibles (k = numero de flags
binarios que afectan conclusion) y verificar que `distractores_si` y `distractores_no`
nunca quedan ambos vacios. Si un caso colapsa un pool a 0 → considerar:

1. **Hacer condicional un distractor adicional** para reequilibrar el pool deficiente.
2. **Aceptar premisas contrafacticas** en distractores que las reconozcan en
   `descripcion_larga` ("Ademas la premisa es falsa: en realidad..."). Es el
   **Patron E** documentado en `generar-schoice/SKILL.md` — tradeoff valido
   cuando preservar balance Si/No es prioritario.
