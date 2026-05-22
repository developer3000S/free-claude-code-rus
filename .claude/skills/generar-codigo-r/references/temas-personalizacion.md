# Temas y Personalizacion ggplot2

## Temas Predefinidos

```r
theme_minimal()    # Minimalista
theme_classic()    # Clasico
theme_bw()         # Blanco y negro
theme_light()      # Claro
theme_dark()       # Oscuro
theme_void()       # Vacio (sin ejes)
```

## Personalizacion de Tema

```r
mi_tema <- theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title = element_text(size = 12, face = "bold"),
    axis.text = element_text(size = 10),
    legend.position = "bottom",
    legend.title = element_text(size = 11, face = "bold"),
    panel.grid.major = element_line(color = "gray90"),
    panel.grid.minor = element_blank(),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = "gray80")
  )
```

## Escalas de Color

### Paletas predefinidas

```r
scale_color_brewer(palette = "Set1")
scale_fill_viridis_d()
scale_color_gradient(low = "blue", high = "red")
```

### Colores manuales

```r
scale_color_manual(values = c("red", "blue", "green"))
scale_fill_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1"))
```

## Paquetes Esenciales

```r
library(ggplot2)    # Visualizacion principal
library(dplyr)      # Manipulacion de datos
library(tidyr)      # Reorganizacion de datos
library(scales)     # Escalas y formatos
library(grid)       # Elementos graficos de bajo nivel
library(gridExtra)  # Multiples graficos
library(ggforce)    # Extensiones geometricas (circulos, arcos)
```

## Configuracion Inicial

```r
theme_set(theme_minimal())
options(
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis"
)
```

## Guardar con Alta Resolucion

```r
ggsave("outputs/output_r.png", p, width = 10, height = 6, dpi = 300)
```
