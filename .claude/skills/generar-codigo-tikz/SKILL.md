---
name: generar-codigo-tikz
description: >
  Genera codigo TikZ/pgfplots profesional para reproducir imagenes matematicas.
  Usa cuando necesites crear graficos dinamicos desde R para ejercicios ICFES.
  Parte del Flujo B (Graficador Experto) - fase 1 inicial.
  Activar con "generar tikz", "codigo tikz", "grafico LaTeX", "pgfplots".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere pdflatex, TikZ, pgfplots. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Bash(pdflatex:*)
  - Bash(ls:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas, la imagen original y los requisitos del grafico como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Generador de Codigo TikZ

## Decision Tree

```
Imagen original analizada?
    |
    +-> NO: Ejecutar /analizar-icfes primero
    |
    +-> SI: Identificar tipo de contenido
            |
            +-> Funciones matematicas -> axis + addplot
            +-> Figuras geometricas -> draw + coordinate
            +-> Graficos estadisticos -> ybar/pie
            +-> Vectores/angulos -> arrows + angles
                 |
                 +-> Generar codigo TikZ
                 |
                 +-> Compilar con pdflatex
                 |
                 +-> Comparar con original (>=95%)
                      |
                      +-> OK: Solicitar aprobacion usuario
                      +-> NO OK: Iterar codigo
```

## Proceso paso a paso

### PASO 1: Estructura base

```latex
\documentclass[border=2mm]{standalone}
% Paquetes necesarios
\begin{document}
\begin{tikzpicture}
% Contenido
\end{tikzpicture}
\end{document}
```

### PASO 2: Identificar patron

Ver [patrones TikZ](references/patrones-tikz.md) para:

- Funciones matematicas (lineas, curvas)
- Figuras geometricas (poligonos, circulos)
- Graficos estadisticos (barras, histogramas)
- Vectores y angulos

### PASO 3: Generar codigo

1. Determinar si se necesita `axis` (pgfplots) o coordenadas directas
2. Configurar rangos y escalas
3. Anadir curvas, figuras o datos
4. Aplicar colores y estilos

### PASO 4: Personalizar estilos

Ver [estilos TikZ](references/estilos-tikz.md) para:

- Colores (predefinidos, RGB, hex)
- Estilos de linea (thick, dashed, dotted)
- Flechas y marcadores
- Rellenos y patrones

### PASO 5: Validar y compilar

```bash
pdflatex outputs/output_tikz.tex
magick convert -density 150 outputs/output_tikz.pdf outputs/output_tikz.png
```

## Checklist de validacion

- [ ] Codigo compila sin errores
- [ ] Todos los elementos visibles
- [ ] Colores coinciden con original
- [ ] Proporciones correctas
- [ ] Texto legible
- [ ] Codigo comentado

## Mejores practicas

1. **Modularidad**: Usar `\coordinate` para puntos reutilizables
2. **Comentarios**: Documentar secciones del codigo
3. **Escalas**: Usar `scale` o dimensiones explicitas
4. **Nombres**: Usar nombres descriptivos para nodos
5. **Orden**: Dibujar de atras hacia adelante (fondo primero)
6. **Precision**: Usar calculos exactos cuando sea posible

## Salida

Codigo TikZ completo guardado en `outputs/output_tikz.tex`.

## Ejemplos

**Ejemplo 1**: Diagrama de caja con datos dinámicos
- Input: Imagen de boxplot ICFES + datos extraídos por analizar-imagen-grafica
- Resultado: Archivo `output_tikz_v1.tex` con código TikZ parametrizado por variables R

**Ejemplo 2**: Plano cartesiano con función
- Input: Gráfica de parábola con vértice y raíces marcados
- Resultado: Código pgfplots con `\addplot` dinámico usando coeficientes R

## Referencias

- [Patrones TikZ](references/patrones-tikz.md) - Codigo por tipo de contenido
- [Estilos TikZ](references/estilos-tikz.md) - Colores, lineas, plantillas
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
analizar-icfes -> Flujo B:
    1. generar-codigo-tikz <- ESTE SKILL
    2. generar-codigo-python
    3. generar-codigo-r
    4. seleccion usuario
```
