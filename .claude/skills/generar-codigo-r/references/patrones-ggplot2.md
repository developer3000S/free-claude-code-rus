# Patrones ggplot2 por Tipo de Contenido

## 1. Funciones Matematicas

### Funcion basica

```r
x <- seq(-5, 5, length.out = 1000)
datos <- data.frame(x = x, y = x^2 - 4*x + 3)

p <- ggplot(datos, aes(x, y)) +
  geom_line(color = "blue", size = 1.2) +
  geom_hline(yintercept = 0, color = "black", size = 0.5) +
  geom_vline(xintercept = 0, color = "black", size = 0.5) +
  labs(title = expression(f(x) == x^2 - 4*x + 3), x = "x", y = "y") +
  theme_minimal()
```

### Multiples funciones

```r
datos <- data.frame(x = x, cuadratica = x^2, lineal = 2*x + 1) %>%
  pivot_longer(cols = -x, names_to = "funcion", values_to = "y")

p <- ggplot(datos, aes(x, y, color = funcion)) +
  geom_line(size = 1.2) +
  scale_color_manual(values = c("cuadratica" = "red", "lineal" = "blue"))
```

### Funciones trigonometricas

```r
x <- seq(0, 2*pi, length.out = 500)
datos <- data.frame(x = x, sin = sin(x), cos = cos(x))

p <- ggplot(datos, aes(x)) +
  geom_line(aes(y = sin, color = "Seno"), size = 1.2) +
  geom_line(aes(y = cos, color = "Coseno"), size = 1.2) +
  scale_x_continuous(
    breaks = c(0, pi/2, pi, 3*pi/2, 2*pi),
    labels = c("0", expression(frac(pi,2)), expression(pi),
               expression(frac(3*pi,2)), expression(2*pi))
  )
```

## 2. Figuras Geometricas

### Triangulo

```r
triangulo <- data.frame(x = c(0, 4, 2, 0), y = c(0, 0, 3, 0))
etiquetas <- data.frame(x = c(0, 4, 2), y = c(0, 0, 3), label = c("A", "B", "C"))

p <- ggplot(triangulo, aes(x, y)) +
  geom_path(size = 1.5, color = "black") +
  geom_point(data = etiquetas, size = 3, color = "red") +
  geom_text(data = etiquetas, aes(label = label),
            nudge_x = c(-0.2, 0.2, 0), nudge_y = c(-0.2, -0.2, 0.2)) +
  coord_equal() +
  theme_void()
```

### Circulo (requiere ggforce)

```r
library(ggforce)
p <- ggplot() +
  geom_circle(aes(x0 = 0, y0 = 0, r = 2),
              fill = "blue", alpha = 0.3, color = "blue", size = 1.5) +
  geom_segment(aes(x = 0, y = 0, xend = 2, yend = 0), size = 1) +
  coord_equal()
```

### Poligono regular

```r
n <- 5  # pentagono
angulos <- seq(0, 2*pi, length.out = n + 1)
poligono <- data.frame(x = cos(angulos), y = sin(angulos))

p <- ggplot(poligono, aes(x, y)) +
  geom_polygon(fill = "blue", alpha = 0.3, color = "blue", size = 1.5) +
  coord_equal()
```

## 3. Graficos Estadisticos

### Barras

```r
datos <- data.frame(categoria = c("A", "B", "C"), valor = c(12, 18, 7))

p <- ggplot(datos, aes(x = categoria, y = valor)) +
  geom_col(fill = "#4CAF50", color = "black", width = 0.6) +
  geom_text(aes(label = valor), vjust = -0.5)
```

### Histograma

```r
p <- ggplot(datos, aes(x = valor)) +
  geom_histogram(bins = 20, fill = "skyblue", color = "black", alpha = 0.7)
```

### Dispersion con regresion

```r
p <- ggplot(datos, aes(x, y)) +
  geom_point(color = "blue", size = 3, alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", linetype = "dashed", se = FALSE)
```

### Circular (pie)

```r
p <- ggplot(datos, aes(x = "", y = valor, fill = categoria)) +
  geom_col(width = 1, color = "white") +
  coord_polar(theta = "y") +
  theme_void()
```

### Boxplot

```r
p <- ggplot(datos, aes(x = grupo, y = valor, fill = grupo)) +
  geom_boxplot(alpha = 0.7, outlier.color = "red")
```

## 4. Vectores

```r
vectores <- data.frame(
  x = c(0, 0), y = c(0, 0),
  xend = c(3, -2), yend = c(2, 3),
  label = c("u", "v")
)

p <- ggplot(vectores) +
  geom_segment(aes(x = x, y = y, xend = xend, yend = yend, color = label),
               arrow = arrow(length = unit(0.3, "cm"), type = "closed"),
               size = 1.5) +
  coord_equal()
```
