---
name: generar-codigo-r
description: >
  Genera codigo R profesional usando ggplot2 para reproducir imagenes matematicas.
  Usa cuando necesites crear graficos nativos R para ejercicios ICFES.
  Parte del Flujo B (Graficador Experto) - fase 3 despues de TikZ y Python.
  Activar con "generar ggplot", "codigo r grafico", "grafico ggplot2", "plot nativo R".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0), ggplot2, tidyverse. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Bash(Rscript:*)
  - Bash(ls:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas, la imagen original y los requisitos del grafico como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Generador de Codigo R (ggplot2)

## Decision Tree

```
Imagen original analizada?
    |
    +-> NO: Ejecutar /analizar-icfes primero
    |
    +-> SI: Identificar tipo de contenido
            |
            +-> Funciones matematicas
            +-> Figuras geometricas
            +-> Graficos estadisticos
            +-> Vectores/geometria avanzada
                 |
                 +-> Generar codigo ggplot2
                 |
                 +-> Renderizar PNG
                 |
                 +-> Comparar con original (>=95%)
                      |
                      +-> OK: Solicitar aprobacion usuario
                      +-> NO OK: Iterar codigo
```

## Proceso paso a paso

### PASO 1: Configuracion inicial

```r
library(ggplot2)
library(dplyr)
theme_set(theme_minimal())
```

### PASO 2: Identificar patron

Ver [patrones ggplot2](references/patrones-ggplot2.md) para:

- Funciones matematicas (lineas, curvas)
- Figuras geometricas (poligonos, circulos)
- Graficos estadisticos (barras, histogramas, dispersion)
- Vectores y geometria avanzada

### PASO 3: Generar codigo

Estructura basica:

```r
p <- ggplot(datos, aes(x, y)) +
  geom_*() +           # Geometria
  scale_*() +          # Escalas
  labs() +             # Etiquetas
  theme_minimal()      # Tema

ggsave("outputs/output_r.png", p, width = 10, height = 6, dpi = 300)
```

### PASO 4: Personalizar tema

Ver [temas y personalizacion](references/temas-personalizacion.md) para:

- Temas predefinidos
- Personalizacion de elementos
- Escalas de color
- Configuracion de guardado

### PASO 5: Validar y guardar

```r
ggsave("outputs/output_r.png", p, width = 10, height = 6, dpi = 300)
print(p)
```

## Checklist de validacion

- [ ] Codigo ejecuta sin errores
- [ ] Genera imagen en outputs/
- [ ] Todos los elementos visibles
- [ ] Colores correctos
- [ ] Proporciones adecuadas
- [ ] Texto legible
- [ ] Codigo documentado

## Mejores practicas

1. **Usar tuberias (%>%)**: Codigo mas legible
2. **Data frames tidy**: Estructura larga para ggplot2
3. **Nombres descriptivos**: Variables claras
4. **Comentarios**: Documentar secciones
5. **Alta resolucion**: dpi = 300
6. **Modularidad**: Separar datos y visualizacion

## Salida

Codigo R completo guardado en `outputs/output_r.R`.

## Ejemplos

**Ejemplo 1**: Diagrama de caja (boxplot) con opciones individuales PNG
- Input: Datos de estaturas + imagen ICFES con cuatro boxplots comparativos
- Resultado: `output_r_v1.R` con `geom_boxplot()` usando `ggsave()` para cada opción (diagrama_a.png, etc.)

**Ejemplo 2**: Gráfico de barras con distribución de frecuencias
- Input: Tabla de frecuencias extraída + gráfica de barras ICFES de referencia
- Resultado: Código ggplot2 con `geom_bar(stat="identity")` parametrizado por vectores R dinámicos

## Referencias

- [Patrones ggplot2](references/patrones-ggplot2.md) - Codigo por tipo de contenido
- [Temas y personalizacion](references/temas-personalizacion.md) - Estilos y colores
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
analizar-icfes -> Flujo B:
    1. generar-codigo-tikz
    2. generar-codigo-python
    3. generar-codigo-r <- ESTE SKILL
    4. seleccion usuario
```
