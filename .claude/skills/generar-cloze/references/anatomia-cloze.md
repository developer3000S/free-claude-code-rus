# Anatomia de un Archivo .Rmd CLOZE

Un archivo CLOZE valido tiene exactamente **7 secciones** (igual que SCHOICE).

## Diferencias Clave vs SCHOICE

| Aspecto | SCHOICE | CLOZE |
|---------|---------|-------|
| Respuestas | 1 sola | Multiples (2-6 gaps) |
| Tipos | Solo schoice | Mixtos (schoice\|num\|string) |
| exsolution | `1000` | `1000\|42.5\|texto` |
| extol | `0.01` | `0\|1\|0` (una por gap) |
| exclozetype | N/A | `schoice\|num\|string` |

## Tipos de Gap Soportados

| Tipo | Codigo | Descripcion | Ejemplo |
|------|--------|-------------|---------|
| schoice | `##ANSWER1##` | Seleccion unica | A, B, C, D |
| mchoice | `##ANSWER2##` | Seleccion multiple | Checkbox |
| num | `##ANSWER3##` | Respuesta numerica | 42.5 |
| string | `##ANSWER4##` | Texto libre | "exponencial" |

## Seccion 5: Question con GAPS

```markdown
Question
========

Dado un problema con multiples pasos:

a) Selecciona la formula correcta: ##ANSWER1##
b) Calcula el resultado: ##ANSWER2##
c) Escribe el tipo de funcion: ##ANSWER3##

Answerlist
----------
* Formula A (distractor)
* Formula B (correcta)
* Formula C (distractor)
* Formula D (distractor)
```

Reglas de GAPS:

- Numeracion secuencial: ##ANSWER1##, ##ANSWER2##, ##ANSWER3##
- Cada gap debe tener su Answerlist (si es schoice/mchoice)
- Gaps numericos (num) no requieren Answerlist

## Seccion 7: Meta-information CLOZE

```yaml
Meta-information
================
exname: problema_compuesto
extype: cloze
exclozetype: schoice|num|string
exsolution: 0100|42.5|exponencial
extol: 0|1|0
exshuffle: TRUE  # Nota: FALSE solo aplica a SCHOICE con PNGs gráficos (ver graficos-como-opciones.md)

exextra[Type]: CLOZE
exextra[Competencia]: Formulacion y Ejecucion
exextra[Componente]: Numerico-Variacional
exextra[Afirmacion]: Resuelve problemas multietapa
exextra[Evidencia]: Aplica formulas y calcula correctamente
exextra[Nivel]: 3
```

Formato exsolution para CLOZE:

- Separador: `|`
- schoice/mchoice: binario (0100 = 2da opcion)
- num: valor numerico (42.5)
- string: texto exacto (exponencial)

Formato extol para CLOZE:

- Una tolerancia por gap, separadas por `|`
- Para schoice/string: 0
- Para num: tolerancia aceptable (ej: 1 para +-1)

## Chunk data_generation para CLOZE

```r
generar_datos <- function() {
  # Parametros aleatorios
  base <- sample(2:10, 1)
  exponente <- sample(2:5, 1)

  # Gap 1: Formula correcta (schoice)
  formula_correcta <- 2  # Indice de la correcta
  opciones_formula <- c(
    paste0("a^", exponente, " + b"),    # distractor
    paste0("a^", exponente),             # correcta
    paste0("a * ", exponente),           # distractor
    paste0(exponente, "^a")              # distractor
  )

  # Gap 2: Resultado numerico
  resultado <- base^exponente

  # Gap 3: Tipo de funcion (string)
  tipo_funcion <- "exponencial"

  # Construir exsolution dinamico
  exsolution_gap1 <- c(0, 1, 0, 0)  # 2da correcta
  exsolution <- paste(
    paste(exsolution_gap1, collapse = ""),
    resultado,
    tipo_funcion,
    sep = "|"
  )

  list(
    base = base,
    exponente = exponente,
    opciones_formula = opciones_formula,
    formula_correcta = formula_correcta,
    resultado = resultado,
    tipo_funcion = tipo_funcion,
    exsolution = exsolution
  )
}
```

## Limitacion NOPS

IMPORTANTE: exams2nops() NO soporta ejercicios CLOZE con gaps tipo `num` o `string`.

Solo soporta CLOZE con gaps tipo schoice/mchoice exclusivamente.

Resultado esperado en validacion:

- HTML: OK
- PDF: OK
- DOCX: OK
- NOPS: FALLO (esperado si hay gaps num/string)
