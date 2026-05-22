---
name: generar-schoice
description: >
  Genera ejercicio R-exams tipo SCHOICE (seleccion unica) METACOGNITIVO.
  TODO ejercicio debe aplicar Progressive Disclosure y analisis de errores conceptuales.
  Usa cuando el analisis ICFES indica schoice, necesites ejercicio de opciones multiples,
  o quieras crear pregunta con 1 respuesta correcta y 3+ distractores.
  SIEMPRE consulta ejemplos funcionales ANTES de generar codigo.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0), tinytex, paquetes exams y tidyverse. Linux/macOS.
metadata:
  author: alvaretto
  version: "4.0"
  language: es
  model_recommendation: opus
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash(ls:*)
  - Bash(mkdir:*)
  - Bash(Rscript:*)
---

# Generador de Ejercicios SCHOICE Metacognitivos

## REGLA CRÍTICA

**⚠️ TODO ejercicio SCHOICE DEBE ser metacognitivo con Progressive Disclosure.**

Ver regla completa: `.claude/rules/ejercicios-metacognitivos.md`

## Decision Tree

```
User task -> Tiene analisis ICFES?
    |-- No -> Ejecutar /analizar-icfes primero
    +-- Si -> Tiene graficos?
        |-- Si -> Preguntar version grafica (TikZ/Python/R)
        |        +-- Consultar ejemplos funcionales similares con grafico
        +-- No -> Consultar ejemplos funcionales similares sin grafico
                 +-- Seleccionar PATRON METACOGNITIVO
                    |-- Patron 1: Analisis de Error Ajeno
                    |-- Patron 2: Evaluacion de Afirmacion
                    +-- Patron 3: Comparacion de Procedimientos
                 +-- Generar .Rmd con nomenclatura oficial
                    +-- Validar: Rscript scripts/validar-renderizado.R
```

## Proceso paso a paso

### PASO 0: Seleccionar patron metacognitivo (OBLIGATORIO)

| Patron | Cuando usar | Bloom | DOK |
|--------|-------------|-------|-----|
| **Analisis de Error Ajeno** | Ejercicios de calculo donde hay errores comunes | Analizar/Evaluar | 3 |
| **Evaluacion de Afirmacion** | Ejercicios conceptuales sobre propiedades | Evaluar | 3 |
| **Comparacion de Procedimientos** | Ejercicios con multiples metodos de solucion | Analizar | 3 |

### PASO 0.5: Seleccion de version grafica (si aplica)

Preguntar al usuario: 1. TikZ / 2. Python (reticulate) / 3. R/ggplot2 (RECOMENDADO). NO continuar sin respuesta.

### PASO 1: Verificar analisis ICFES

Confirmar que existe clasificacion previa: Nivel, Competencia, Componente, Tipo = schoice.

### PASO 2: Consultar ejemplos funcionales METACOGNITIVOS (Búsqueda Inteligente)

NUNCA generar código sin consultar ejemplos primero. Buscar en **orden de prioridad**:

**Prioridad 1 — Ejercicios recientes completados** (más actualizados, reflejan patrones vigentes):
```bash
# Buscar .Rmd SCHOICE metacognitivos más recientes en producción y desarrollo
ls -t A-Produccion/03-En-Produccion/**/*metacognitivo*schoice*.Rmd 2>/dev/null | head -3
ls -t A-Produccion/02-En-Desarrollo/**/*metacognitivo*schoice*.Rmd 2>/dev/null | head -3
```

Solo considerar archivos que tengan `ejercicio_state.json` con `aprobacion_usuario.completado = true` o que estén en `03-En-Produccion/`.

**Prioridad 2 — Ejemplos Funcionales canónicos** (fuente de verdad inmutable):
```bash
ls A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
ls A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
```

**Protocolo**: Leer al menos 1 ejemplo de Prioridad 1 (si existe) + 1 de Prioridad 2. Copiar patrones del más reciente, validar contra el canónico.

### PASO 3: Definir pool de errores conceptuales (OBLIGATORIO)

Minimo 4-6 errores con codigos, descripcion_corta, descripcion_larga, causa_raiz y funcion `calcula()`.

Ver [pool-errores-conceptuales.md](references/pool-errores-conceptuales.md) para estructura completa, patron de seleccion generica y taxonomia de codigos.

### PASO 4: Generar nombre con nomenclatura

Formato: `[ejercicio]_metacognitivo_[competencia]_n[nivel]_schoice_v[version].Rmd`

`metacognitivo` es OBLIGATORIO en el nombre. Nivel minimo: n2. Ver: `.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md`

### PASO 5: Crear carpeta e inicializar estado

```bash
mkdir -p A-Produccion/02-En-Desarrollo/[nombre_ejercicio]
.claude/scripts/workflow-state.sh init A-Produccion/02-En-Desarrollo/[nombre_ejercicio] --tipo schoice --nombre "[nombre_ejercicio]"
.claude/scripts/workflow-state.sh complete A-Produccion/02-En-Desarrollo/[nombre_ejercicio] analisis_icfes
.claude/scripts/workflow-state.sh complete A-Produccion/02-En-Desarrollo/[nombre_ejercicio] flujo_b --requerido [true|false]
```

### PASO 6: Generar codigo .Rmd METACOGNITIVO

Ver [anatomia metacognitiva del .Rmd](references/anatomia-metacognitiva.md) para las 8 secciones obligatorias.

Estructura requerida: YAML (con taxonomias cognitivas) → setup → data_generation (pool errores) → version_diversity_test → validaciones_matematicas → Question (patron metacognitivo) → Solution (analisis error + reflexion) → META-INFORMATION (DOK, Bloom, SOLO).

```bash
.claude/scripts/workflow-state.sh complete <dir> generacion_rmd --archivo "[nombre].Rmd"
```

### PASO 7: Retroalimentación científica (workflow paso 4)

Ejecutar `/skill-retroalimentacion` para generar la sección Solution con justificación matemática y análisis diagnóstico de cada opción.

```bash
.claude/scripts/workflow-state.sh complete <dir> retroalimentacion
```

### PASO 8: Renderizado 4 formatos (workflow paso 5)

```bash
Rscript -e 'library(exams); exams2html("[archivo].Rmd", n=1, dir="salida")'
Rscript -e 'library(exams); exams2pdf("[archivo].Rmd", n=1, dir="salida")'
Rscript -e 'library(exams); exams2pandoc("[archivo].Rmd", n=1, type="docx", dir="salida")'
Rscript -e 'library(exams); exams2nops("[archivo].Rmd", n=1, dir="salida")'
```

```bash
.claude/scripts/workflow-state.sh complete <dir> renderizado_4_formatos
```

### PASO 9: Arsenal post-render (workflow paso 6, AUTOMÁTICO)

El hook `post-exams2-validation.sh` ejecuta automáticamente FASES 2A-2H (validación matemática, preview visual, multi-semilla). No requiere acción manual.

```bash
.claude/scripts/workflow-state.sh complete <dir> arsenal_post_render
```

### PASO 10: Detractor FASE 2C (workflow paso 7, OBLIGATORIO)

Ejecutar `/adversario [archivo.Rmd]`. Revisa 8 dominios: código, pedagógico, visual, gramática, matemático, metacognitivo, testing, semántico.

- Si veredicto = RECHAZAR → corregir → volver a PASO 8
- Si veredicto = APROBAR CON CAMBIOS → aplicar → volver a PASO 8
- Si veredicto = APROBAR → continuar

```bash
.claude/scripts/workflow-state.sh complete <dir> detractor_fase2c --veredicto "[APROBAR|RECHAZAR]"
```

### PASO 11: Documentar 5 coherencias (workflow paso 8)

Verificar y documentar con checklist:
- [ ] Semántica: gramática, tildes, redacción ICFES
- [ ] Visual-Texto: gráfico coincide con enunciado
- [ ] Matemática: fórmulas, cálculos, distractores plausibles
- [ ] Código: elementos dinámicos, compatibilidad 4 formatos
- [ ] General: legibilidad, estilo ICFES, opciones visibles

```bash
.claude/scripts/workflow-state.sh complete <dir> coherencias_5
```

### PASO 12: Validar diversidad (workflow paso 9)

Ejecutar `/validar-diversidad`. Requiere 250+ versiones únicas de 300 intentos.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_diversidad --versiones_unicas [N]
```

### PASO 13: Validar ICFES (workflow paso 10)

Ejecutar `/validar-icfes`. Verifica estructura R-exams, metadatos ICFES (6 dimensiones), exsolution y exshuffle.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_icfes
```

### PASO 14: Aprobación del usuario (workflow paso 11)

Solicitar aprobación explícita del usuario. SOLO después de aprobación:

```bash
.claude/scripts/workflow-state.sh complete <dir> aprobacion_usuario
/promover-ejercicio [nombre_ejercicio]
```

## Antipatrones PROHIBIDOS

Ver [antipatrones.md](references/antipatrones.md) para ejemplos con codigo incorrecto/correcto.

Resumen: (1) NO ejercicios puramente procedimentales, (2) NO distractores aleatorios, (3) NO Solution sin analisis de error, (4) NO `![](file.png)` sin atributo `{width=...}`, (5) NO `exshuffle: TRUE` cuando Solution referencia letra explícita.

## Patrones obligatorios para Imágenes y exshuffle (lecciones 2026-05-03)

### Imágenes en bloque R (regla #18 markdown-imagenes-pdf.md)

**OBLIGATORIO**: incluir atributo `{width=...}` en TODA imagen Markdown.

```r
# ✓ CORRECTO
` ``{r mostrar_grafico, echo=FALSE, results='asis'}
cat("![](grafico.png){width=80%}\n")
` ``

# ❌ PROHIBIDO (causa \pandocbounded undefined en PDF)
cat("![](grafico.png)\n")
```

### exshuffle con Solution que referencia letra (regla codigo-rmd.md #6)

```yaml
# ✓ CORRECTO si Solution dice "Opción `r letra_correcta`"
exshuffle: FALSE
# (la mezcla interna con sample() ya aleatoriza el orden)

# ❌ PROHIBIDO con Solution referenciando letra → inconsistencia silenciosa
exshuffle: TRUE
```

**Patrón completo** en `data_generation`:

```r
opciones_mezcladas <- sample(todas_opciones)
indice_correcto <- which(names(opciones_mezcladas) == "correcta")
sol <- rep(0, 4); sol[indice_correcto] <- 1
letras <- c("A", "B", "C", "D")
names(opciones_mezcladas) <- letras
letra_correcta <- letras[indice_correcto]   # DESPUÉS del sample
```

```yaml
exsolution: `r paste(as.integer(sol), collapse="")`
exshuffle: FALSE
```

## Letter-independence en Solution (regla #19, OBLIGATORIO)

La sección Solution del .Rmd **NUNCA** debe identificar opciones por su letra/posición. SIEMPRE por contenido o código de error.

### Patrones prohibidos (bloquean compilación vía FASE 2J)

```rmd
### Respuesta correcta: Opción `r letra_correcta`
La opción `r letra_correcta` es la correcta porque...
**Opción A** es la correcta.
```

```r
# Chunk R que emite "Opción <letra>":
for (l in letras) {
  cat("**Opción ", l, " (", err$codigo, "):** ", err$descripcion_larga)
}
```

### Patrones correctos (auto-contenidos)

```rmd
### Respuesta correcta

**Argumento válido:** "`r errores_conceptuales[[2]]$descripcion_corta`"
```

```r
# Chunk R que identifica por código + nombre + contenido:
for (l in letras) {
  opc <- opciones_mezcladas[[l]]
  if (opc$tipo != "correcto") {
    err <- errores_conceptuales[[opc$error_idx]]
    cat(paste0(
      "**", err$codigo, " — ", err$nombre, "**\n\n",
      "*Argumento:* \"", err$descripcion_corta, "\"\n\n",
      err$descripcion_larga, "\n\n"
    ))
  }
}
```

### Razón

Moodle (y otros LMS) tiene un setting "Shuffle answers" INDEPENDIENTE del `exshuffle` de R-exams. Cuando está activado, Moodle re-ordena opciones al desplegar, pero NO toca el texto de Solution. Resultado: si Solution dice "Opción A" pero Moodle movió esa opción a la posición C, el estudiante ve incoherencia. Solo se detecta cuando un estudiante real cae en el ejercicio (cobertura tardía).

`letra_correcta` puede seguir existiendo como variable R interna (logs con `message()` a stderr, asserts en `stopifnot()`) pero NUNCA debe llegar al texto del estudiante.

Ver `.claude/rules/solution-letter-independence.md` (regla #19, sin excepciones).

## Distractores con conclusión binaria Sí/No (lecciones 2026-05-12)

Aplica a ejercicios de **argumentación** y **evaluación de afirmaciones** donde cada distractor empieza con "Sí, porque..." o "No, porque...".

### Patrón A — Coherencia conclusión-justificación condicional

Cuando la justificación (`descripcion_corta`) usa variables que invierten su rol según el estado del ejercicio (`pais_perdedor`/`pais_ganador`, `error_seleccionado`, etc.), la **conclusión "Sí/No" también debe ser condicional** al flag que invierte esos roles. De lo contrario, en la mitad de las semillas la justificación apoya una conclusión y el texto declara la opuesta → incoherencia interna silenciosa.

```r
# ❌ ANTIPATRÓN: conclusión fija + justificación con roles invertibles
list(
  codigo = "GRAF-ARG-03",
  descripcion_corta = paste0(
    "No, porque existen años donde ", pais_perdedor,
    " supera a ", pais_ganador
  )
  # Cuando afirmacion=FALSE, pais_perdedor=Pa → texto dice "Pa supera a Pb"
  # → justificación apoya "Sí" pero la conclusión dice "No". Incoherente.
)

# ✓ CORRECTO: ambos (conclusión + justificación) condicionales al MISMO flag
list(
  codigo = "GRAF-ARG-03",
  descripcion_corta = if (afirmacion_es_verdadera) {
    paste0("No, porque existen años donde ", pais_b,
           " supera a ", pais_a)
  } else {
    paste0("Sí, porque existen años donde ", pais_a,
           " supera a ", pais_b)
  }
)
```

### Patrón B — Premisas consistentes con restricciones de generación

Si la generación garantiza una propiedad de los datos (e.g., `gap_min=0.3` impone series **nunca iguales**), ningún distractor puede afirmar como premisa observable la negación de esa propiedad.

```r
# ❌ ANTIPATRÓN: premisa imposible
gap_min <- 0.3   # garantiza series_a[i] != series_b[i] siempre
descripcion_corta <- "No, porque hay un punto donde ambos países usan cantidades iguales..."
# El estudiante mira el gráfico, ve que NO hay iguales, descarta automáticamente.
# El distractor pierde valor diagnóstico.

# ✓ CORRECTO: redacción coherente con la restricción
descripcion_corta <- "No, porque hay puntos donde los dos países usan cantidades muy similares..."
```

### Patrón C — Gotcha `sample()` con length(x)==1

`sample(c(3L), 1)` **NO retorna 3**: trata el escalar como `1:3` y muestrea uniformemente. Es el gotcha #1 de selección de pools en R cuando el pool puede colapsar a un solo elemento (caso límite con flags condicionales).

```r
# ❌ ANTIPATRÓN: rompe cuando length(distractores_si)==1
sel_si <- sample(distractores_si, n_si)

# ✓ CORRECTO: patrón seguro vía indexación
sel_si <- distractores_si[sample.int(length(distractores_si), n_si)]
```

### Patrón D — Pools dinámicos con sanity checks

Cuando los distractores tienen conclusiones que dependen de flags, los pools "Sí"/"No" no son listas fijas — se calculan en runtime y pueden colapsar. Construirlos con función explícita y validar con `stopifnot`:

```r
concl_distractor <- function(idx) {
  if (idx == 1L) return("No")
  if (idx == 3L) return(if (afirmacion_es_verdadera) "No" else "Sí")
  # ... casos restantes
}
todos <- c(1L, 3L, 4L, 5L, 6L)
concl_por_idx <- sapply(todos, concl_distractor)
distractores_si <- todos[concl_por_idx == "Sí"]
distractores_no <- todos[concl_por_idx == "No"]

# Sanity checks ANTES de muestrear
stopifnot(
  n_si + n_no == 3L,
  n_si <= length(distractores_si),
  n_no <= length(distractores_no)
)
```

### Patrón E — Tradeoff balance Sí/No vs premisas verdaderas

Si forzar premisas siempre verdaderas (Patrón B aplicado a todos los distractores) colapsa el pool de un lado a `length == 0` para alguna combinación de flags → las 4 opciones renderizadas tendrán la misma conclusión, dando al estudiante una metaregla delatora ("única opción Sí = correcta").

**Resolución aceptada**: priorizar balance Sí/No. Distractor con premisa contrafáctica es válido si su `descripcion_larga` lo reconoce explícitamente ("Además la premisa es falsa: en realidad..."). Es patrón didáctico de "verificar premisas antes de aceptar el argumento".

## Referencias

- [Anatomia Metacognitiva .Rmd](references/anatomia-metacognitiva.md) - Las 8 secciones obligatorias
- [Anatomia .Rmd basica](references/anatomia-rmd.md) - Estructura general
- [Pool de Errores Conceptuales](references/pool-errores-conceptuales.md) - Estructura, seleccion, taxonomia
- [Antipatrones](references/antipatrones.md) - Patrones prohibidos con correcciones
- [Checklist Metacognitivo](references/checklist-metacognitivo.md) - Pre/durante/post generacion
- [Errores comunes](references/errores-comunes.md) - Patrones incorrecto/correcto
- [Ejemplos completos](references/ejemplos.md) - Nivel 1 aritmetica + Nivel 3 estadistica
- Regla Metacognitiva: `.claude/rules/ejercicios-metacognitivos.md`
- Regla #18 Markdown-imágenes-PDF (anti `\pandocbounded`): `.claude/rules/markdown-imagenes-pdf.md`
- Errores conocidos 16-17 (sesión 2026-05-03): `.claude/docs/patrones-errores-conocidos.md`
- Ejemplos Funcionales (canónicos): `A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/`
- Ejemplos Recientes (Prioridad 1): `A-Produccion/03-En-Produccion/**/*metacognitivo*.Rmd` y `A-Produccion/02-En-Desarrollo/**/*metacognitivo*.Rmd`
- Nomenclatura: `.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md`
- Ciclo Validacion: `.claude/rules/ciclo-validacion.md`
- Metadatos: `.claude/rules/codigo-rmd.md`

## Integracion con otros skills (workflow completo de 11 pasos)

```
1. analizar-icfes ──→ 2. flujo_b ──→ 3. generar-schoice
                                              ↓
4. skill-retroalimentacion ←─────────────────┘
      ↓
5. renderizado 4 formatos (exams2html/pdf/docx/nops)
      ↓
6. arsenal post-render (hook automático FASES 2A-2H)
      ↓
7. adversario (detractor FASE 2C) ──→ si RECHAZAR → volver a 5
      ↓
8. documentar 5 coherencias
      ↓
9. validar-diversidad (250+ versiones únicas)
      ↓
10. validar-icfes (metadatos + estructura)
      ↓
11. aprobación usuario → promover-ejercicio
```

Todos los pasos registran progreso via `workflow-state.sh complete`.
