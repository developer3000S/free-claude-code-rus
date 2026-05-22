# Pool de Reflexiones Metacognitivas

## Uso en el .Rmd

```r
reflexiones_metacognitivas <- c(
  "Identificar errores en el razonamiento de otros nos ayuda a evitar cometerlos nosotros mismos. La metacognicion es fundamental para el aprendizaje matematico.",
  "Analizar por que una respuesta es incorrecta fortalece la comprension profunda del concepto. Este proceso de autoevaluacion mejora significativamente el desempeno.",
  "Los errores mas frecuentes en este tipo de problemas estan relacionados con [area especifica]. Reconocerlos es el primer paso para superarlos.",
  "Cuando identificamos el tipo de error conceptual, podemos disenar estrategias especificas para evitarlo en el futuro.",
  "La diferencia entre un error de calculo y un error conceptual es importante: el primero es mecanico, el segundo requiere revisar la comprension del concepto."
)
```

Invocar en la Solution:

```r
# En el chunk data_generation:
reflexion <- sample(reflexiones_metacognitivas, 1)

# En la seccion Solution (markdown):
`r reflexion`
```

## Guia para ampliar el pool

Cada ejercicio puede (y DEBE) agregar reflexiones especificas al tema:

```r
# Agregar reflexiones especificas al pool base
reflexiones_metacognitivas <- c(
  reflexiones_metacognitivas,
  paste0("Al trabajar con ", tema_especifico, ", un error comun es confundir ",
         concepto_a, " con ", concepto_b, ". Verificar siempre la definicion."),
  paste0("La estrategia de verificacion para ", tema_especifico, " consiste en ",
         estrategia_verificacion, ".")
)
```

## Reglas para el pool

- Minimo 4 reflexiones por ejercicio (para asegurar variedad entre semillas)
- Al menos 1 reflexion especifica al concepto matematico del ejercicio
- Al menos 1 reflexion sobre estrategia de verificacion
- NUNCA reflexiones vacias o genericas sin relevancia al tema
- Las reflexiones deben sonar naturales en voz alta (no generadas por maquina)
