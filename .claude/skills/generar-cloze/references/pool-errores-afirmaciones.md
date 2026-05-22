# Pools de Errores y Afirmaciones — CLOZE

## PASO 3: Pool de errores conceptuales (Parte 1)

Minimo 4-6 errores documentados con codigos:

```r
errores_conceptuales <- list(
  list(
    codigo = "XXX-YYY-01",
    nombre = "Nombre descriptivo",
    descripcion_corta = "...",       # Para opciones Parte 1 (max 80 chars)
    descripcion_larga = "...",       # Para Solution (detallada)
    causa_raiz = "...",              # Diagnostico pedagogico
    precondicion = function(params) TRUE,  # Cuando aplica este error
    calcula = function(datos_ord, datos_presentados = NULL) {
      # Retorna el valor erroneo
      # PROHIBIDO: sample(), runif(), rnorm() — debe ser funcion pura
    }
  )
  # ... minimo 4-6 errores
)
```

Patron de seleccion generica (obligatorio):

```r
params <- list(n = n, datos_ord = datos_ord)
errores_aplicables_idx <- which(sapply(errores_conceptuales, function(err) {
  if (is.null(err$precondicion)) return(TRUE)
  err$precondicion(params)
}))
error_idx <- sample(errores_aplicables_idx, 1)
error_sel <- errores_conceptuales[[error_idx]]
```

Ver taxonomia de codigos en `.claude/skills/generar-schoice/references/pool-errores-conceptuales.md`.

## PASO 4: Pool de afirmaciones (Parte 3 — mchoice)

```r
pool_afirmaciones_verdaderas <- list(
  "Afirmacion verdadera 1 sobre el concepto matematico",
  "Afirmacion verdadera 2 — propiedad especifica",
  "Afirmacion verdadera 3 — caso particular",
  "Afirmacion verdadera 4 — relacion con otro concepto",
  "Afirmacion verdadera 5 — interpretacion correcta",
  "Afirmacion verdadera 6 — extension del concepto"
  # Minimo 6 afirmaciones verdaderas
)

pool_afirmaciones_falsas <- list(
  "Afirmacion falsa 1 — error conceptual comun (ej: confusion con otra medida)",
  "Afirmacion falsa 2 — generalizacion incorrecta",
  "Afirmacion falsa 3 — caso especial no aplicable al general",
  "Afirmacion falsa 4 — confunde propiedades de conceptos distintos",
  "Afirmacion falsa 5 — niega propiedad que si aplica",
  "Afirmacion falsa 6 — mal ejemplo de aplicacion"
  # Minimo 6 afirmaciones falsas
)
```

**Regla critica**: Las afirmaciones DEBEN estar basadas en errores conceptuales reales de estudiantes.
PROHIBIDO afirmaciones como "El resultado es 42" o "La respuesta es incorrecta" (sin base conceptual).

## PASO 5: Pool de enunciados V/F (Parte 4 — schoice)

```r
pool_vf <- list(
  list(
    enunciado = "Enunciado especifico con valores concretos del contexto actual",
    es_verdadero = TRUE
  ),
  list(
    enunciado = "Enunciado especifico con error conceptual sutil",
    es_verdadero = FALSE
  ),
  list(
    enunciado = "Caso de transferencia a contexto relacionado",
    es_verdadero = TRUE
  ),
  list(
    enunciado = "Afirmacion sobre caso borde del concepto",
    es_verdadero = FALSE
  )
  # Minimo 4 enunciados (mezcla de V y F)
)
```

Los enunciados V/F deben usar datos concretos del contexto generado dinamicamente,
no enunciados abstractos. Esto permite la variacion entre semillas.
