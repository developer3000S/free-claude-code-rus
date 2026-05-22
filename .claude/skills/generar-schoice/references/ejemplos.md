# Ejemplos Completos de Generación SCHOICE

## Ejemplo 1: Ejercicio Nivel 1 - Aritmética Básica

**Problema:**
> Calcula el área de un rectángulo de base 5 cm y altura 8 cm.

**Clasificación ICFES:**

- Nivel: 1 (aplicación directa)
- Competencia: Formulación y Ejecución
- Componente: Geométrico-Métrico

**Código data_generation:**

```r
generar_datos <- function() {
  base <- sample(3:12, 1)
  altura <- sample(5:15, 1)

  area <- base * altura

  # Distractores
  d1 <- base + altura  # error: suma en vez de multiplicación
  d2 <- 2 * (base + altura)  # error: confunde con perímetro
  d3 <- (base * altura) / 2  # error: confunde con triángulo

  opciones <- c(area, d1, d2, d3)

  list(
    base = base,
    altura = altura,
    area = area,
    opciones = opciones,
    posicion_correcta = 1
  )
}
```

**Nombre archivo:**

```
area_rectangulo_geometrico_metrico_formulacion_ejecucion_n1_v1.Rmd
```

## Ejemplo 2: Ejercicio Nivel 3 - Estadística con Gráfico

**Problema:**
> [Gráfico de barras con ventas mensuales]
> ¿En qué mes hubo el mayor incremento porcentual respecto al mes anterior?

**Clasificación ICFES:**

- Nivel: 3 (múltiples pasos: leer gráfico, calcular variaciones, comparar)
- Competencia: Interpretación y Representación
- Componente: Aleatorio

**Código data_generation con gráfico:**

```r
generar_datos <- function() {
  meses <- c("Ene", "Feb", "Mar", "Abr", "May", "Jun")
  ventas <- sample(100:500, 6, replace = TRUE)

  variaciones <- c(0, diff(ventas) / head(ventas, -1) * 100)

  mes_max <- meses[which.max(variaciones)]

  df <- data.frame(Mes = factor(meses, levels = meses), Ventas = ventas)
  p <- ggplot(df, aes(x = Mes, y = Ventas)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    theme_minimal() +
    labs(title = "Ventas Mensuales", y = "Ventas (unidades)")

  ggsave("ventas.png", plot = p, width = 8, height = 5, dpi = 150)
  include_supplement("ventas.png")

  opciones <- c(mes_max, sample(setdiff(meses, mes_max), 3))

  list(
    meses = meses,
    ventas = ventas,
    mes_max = mes_max,
    opciones = opciones
  )
}
```

**Question section:**

```markdown
Question
========

Observa el siguiente gráfico de ventas mensuales:

![](ventas.png)

¿En qué mes se registró el **mayor incremento porcentual** respecto al mes anterior?

Answerlist
----------
* `r opciones[1]`
* `r opciones[2]`
* `r opciones[3]`
* `r opciones[4]`
```

**Nombre archivo:**

```
incremento_ventas_aleatorio_interpretacion_representacion_n3_v1.Rmd
```

## Directorio de ejemplos validados

Los ejemplos funcionales completos están en:

```
/A-Produccion/Ejemplos-Funcionales-Rmd/
```

SIEMPRE consultar estos archivos antes de generar código nuevo.
