# Los 4 Tipos de Coherencia

## Tipo 1: Coherencia Matematica (ERR_C1)

Verificar que calculos, formulas, y respuesta correcta sean matematicamente validos.

**Que verificar:**

- Formula aplicada correcta para el problema
- Parametros en orden correcto
- Unidades consistentes
- Cada paso matematico correcto
- Orden de operaciones correcto
- Resultado final coincide con exsolution
- Distractores plausibles (errores comunes)
- No hay respuestas duplicadas

**Checklist:**

```
[ ] Formula correcta para el problema
[ ] Valores en rangos validos
[ ] Operaciones intermedias correctas
[ ] Respuesta correcta coincide con calculo
[ ] Distractores matematicamente plausibles
[ ] Sin errores de redondeo significativos
[ ] exsolution coincide con respuesta identificada
```

## Tipo 2: Coherencia Imagen-Texto (ERR_C2)

Verificar sincronizacion entre descripcion textual y graficos generados.

**Que verificar:**

- Dimensiones en texto = dimensiones en grafico
- Coordenadas en texto = coordenadas en TikZ/matplotlib
- Variables R usadas tanto en texto como en grafico
- Colores descritos = colores mostrados
- Formas descritas = formas mostradas
- Etiquetas legibles y en posicion correcta
- Ejes con escalas apropiadas

**Checklist:**

```
[ ] Valores en texto coinciden con grafico
[ ] Colores descritos son los mostrados
[ ] Figuras descritas coinciden con renderizado
[ ] Posicion/rotacion es la descrita
[ ] Etiquetas legibles y correctas
[ ] Escala apropiada para valores mostrados
[ ] Variables R usadas en ambos (texto y grafico)
```

## Tipo 3: Coherencia de Codigo (ERR_C3)

Verificar sincronizacion entre chunks R, Python, y TikZ.

**Que verificar:**

- Variables R a Python pasadas con `r.variable`
- Variables R a TikZ con `paste0()` para insertar valores
- No usar variables formateadas en calculos
- Variables definidas antes de usarse
- No hay referencias circulares
- Chunks en orden logico
- Funciones matematicas sobre numeros (no strings)
- Formateo DESPUES de calculos

**Checklist:**

```
[ ] R->Python: Variables con r.variable
[ ] R->TikZ: Variables con paste0()
[ ] Variables definidas antes de usar
[ ] Funciones operan sobre numeros, no strings
[ ] sprintf() DESPUES de calculos
[ ] set.seed() genera datos validos
[ ] Variables disponibles en contexto correcto
```

## Tipo 4: Coherencia de Metadatos (ERR_C4)

Verificar que metadatos ICFES esten completos y consistentes.

**Metadatos obligatorios R-exams:**

- exname: Nombre descriptivo
- extype: schoice o cloze
- exsolution: Respuesta correcta
- exshuffle: TRUE (excepción: FALSE en SCHOICE con opciones gráficas PNG — ver `graficos-como-opciones.md`)
- extol: 0.01

**Metadatos ICFES (6 dimensiones):**

- exextra[Type]: SCHOICE o CLOZE
- exextra[Competencia]: Interpretacion|Formulacion|Argumentacion
- exextra[Componente]: Numerico-Variacional|Geometrico-Metrico|Aleatorio
- exextra[Afirmacion]: Descripcion especifica
- exextra[Evidencia]: Descripcion especifica
- exextra[Nivel]: 1|2|3|4

**Formato exsolution:**

- SCHOICE: String binario (ej: "10000" = 5 opciones, 1ra correcta)
- CLOZE: Formato por tipo

**Checklist:**

```
[ ] exname presente y descriptivo
[ ] extype "schoice" o "cloze"
[ ] exsolution formato correcto segun extype
[ ] exshuffle: TRUE (FALSE si SCHOICE con PNGs gráficos)
[ ] extol: 0.01 o apropiado
[ ] exextra[Type]: SCHOICE o CLOZE
[ ] exextra[Competencia]: Valor valido ICFES
[ ] exextra[Componente]: Valor valido ICFES
[ ] exextra[Afirmacion]: Presente
[ ] exextra[Evidencia]: Presente
[ ] exextra[Nivel]: 1, 2, 3, o 4
[ ] Answerlist items = longitud exsolution
```
