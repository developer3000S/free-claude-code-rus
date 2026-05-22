# Categorias de Errores R/exams (4 Tipos)

## Categoria 1: ERRORES DE GRAFICOS (ERR_G)

| Codigo | Error | Sintomas | Solucion |
|--------|-------|----------|----------|
| **ERR_G1** | Graficas no visualizadas | Espacio en blanco donde debe ir grafico | include_tikz() condicional |
| **ERR_G2** | Graficas solapadas | Graficos se superponen | Ajustar posicionamiento |
| **ERR_G3** | Renderizado incorrecto | Grafico visible pero distorsionado | Revisar codigo TikZ/Python/R |
| **ERR_G4** | Tamano inadecuado | Grafico muy grande/pequeno | Ajustar scale/width/height |
| **ERR_G5** | Leyenda faltante/incorrecta | Sin leyenda o valores mal | Agregar/corregir legend() |
| **ERR_G6** | Ejes sin labels | Ejes sin nombre de variable | Agregar xlab(), ylab() |

Skill de correccion: `corregir-graficos`

## Categoria 2: ERRORES DE TEXTO (ERR_T)

| Codigo | Error | Sintomas | Solucion |
|--------|-------|----------|----------|
| **ERR_T1** | LaTeX no compila | PDF falla con `LaTeX Error` | Revisar sintaxis LaTeX |
| **ERR_T2** | Encoding incorrecto | Caracteres raros | encoding = "UTF-8" |
| **ERR_T3** | Metadatos faltantes | Warning missing exname | Completar Meta-information |
| **ERR_T4** | Ecuaciones mal formateadas | Ecuacion no renderiza | Revisar delimitadores |
| **ERR_T5** | Caracteres especiales | Error LaTeX por %, _, # | Escapar: \%, \_, \# |

Skill de correccion: Manual (Edit tool)

## Categoria 3: ERRORES DE ESTRUCTURA (ERR_S)

| Codigo | Error | Sintomas | Solucion |
|--------|-------|----------|----------|
| **ERR_S1** | Opciones incorrectas | <4 opciones o duplicados | Regenerar opciones |
| **ERR_S2** | Solucion no coincide | exsolution incorrecto | Recalcular respuesta |
| **ERR_S3** | Answerlist faltante | Sin lista de respuestas | Agregar Answerlist |
| **ERR_S4** | CLOZE gaps incorrectos | ##ANSWER1## mal numerados | Renumerar secuencial |
| **ERR_S5** | extol/exclozetype desincronizado | Numero elementos != gaps | Igualar longitudes |

Skill de correccion: Manual (Edit tool)

## Categoria 4: ERRORES DE COHERENCIA (ERR_C)

| Codigo | Error | Sintomas | Solucion |
|--------|-------|----------|----------|
| **ERR_C1** | Coherencia matematica | Calculo incorrecto | Revisar logica |
| **ERR_C2** | Coherencia imagen-texto | Descripcion != grafico | Alinear texto/visual |
| **ERR_C3** | Coherencia de codigo | Variables desincronizadas | Sincronizar parametros |
| **ERR_C4** | Coherencia opciones | Distractores ilogicos | Diversificar distractores |
| **ERR_C5** | Coherencia metadatos | Metadatos != contenido | Alinear clasificacion |

Skill de correccion: Manual (revision completa)

## Patrones de Deteccion por Mensaje

| Patron en mensaje | Codigo |
|-------------------|--------|
| `File.*png.*not found` | ERR_G1 |
| `LaTeX Error` o `! Undefined` | ERR_T1 |
| `invalid multibyte` | ERR_T2 |
| `object.*not found` | ERR_C3 |
| `exercise type 'cloze'.*not supported` | ERR_S5 |
| `non-numeric argument` | ERR_C3 |
| `exsolution` | ERR_S2 |
