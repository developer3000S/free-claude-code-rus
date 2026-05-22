# Errores Comunes a Evitar en SCHOICE

## Error 1: Inclusión Incorrecta de Gráficos

Incorrecto:

```r
```{r grafico}
p <- ggplot(...) + ...
print(p)
```
```

Problema: R/exams NO captura gráficos con `print()` en chunks.

Correcto:

```r
```{r data_generation, include=FALSE}
p <- ggplot(...) + ...
ggsave("grafico.png", plot = p, width = 8, height = 5, dpi = 150)
include_supplement("grafico.png")
```
```

```markdown
Question
========
![](grafico.png)
```

Regla: Siempre `ggsave()` + `include_supplement()` + referencia Markdown.

## Error 2: Distractores Aleatorios sin Sentido

Incorrecto:

```r
distractor1 <- respuesta_correcta + sample(-10:10, 1)
distractor2 <- respuesta_correcta * sample(1:3, 1)
```

Problema: No representan errores conceptuales.

Correcto:

```r
# Distractores basados en errores comunes
distractor1 <- a * b  # olvida sumar c
distractor2 <- (a + b) + c  # cambia operación
distractor3 <- a * (b + c)  # distributiva incorrecta
```

Regla: Cada distractor = 1 error conceptual específico documentado.

## Error 3: Formato de Números sin Separadores

Incorrecto:

```markdown
* `r opciones[1]`
```

Problema: Muestra números con punto decimal inglés (1234.56).

Correcto:

```markdown
* `r format(opciones[1], big.mark = ".", decimal.mark = ",", scientific = FALSE)`
```

Resultado: 1.234,56 (formato español correcto).

## Error 4: Nomenclatura Incorrecta

Incorrecto:

```
ejercicio1.Rmd
problema_geometria.Rmd
test_nivel2_v1.Rmd
```

Correcto:

```
area_rectangulo_geometrico_metrico_formulacion_ejecucion_n1_v1.Rmd
```

Formato: `[ejercicio]_[componente]_[competencia]_n[nivel]_v[version].Rmd`

Ver: .claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md

## Error 5: No Validar Diversidad de Versiones

Incorrecto:

```r
a <- sample(1:3, 1)  # solo 3 valores
b <- sample(1:2, 1)  # solo 2 valores
# Total: 3 × 2 = 6 versiones (INSUFICIENTE)
```

Correcto:

```r
a <- sample(2:20, 1)  # 19 valores
b <- sample(5:30, 1)  # 26 valores
c <- sample(1:15, 1)  # 15 valores
# Total: 19 × 26 × 15 = 7,410 versiones posibles

test_versiones(300)  # Debe dar 250+ únicas
```

## Error 6: No Consultar Ejemplos Funcionales

Incorrecto: Generar código desde cero sin consultar ejemplos.

Correcto:

```bash
ls /A-Produccion/Ejemplos-Funcionales-Rmd/
grep -l "Geométrico" /A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
# Leer ejemplo similar completo
# Copiar estructura y adaptar
```

Regla de Oro: Ejemplos funcionales = Fuente de verdad ABSOLUTA.
