---
name: generar-codigo-python
description: >
  Genera codigo Python profesional usando matplotlib/numpy para reproducir imagenes matematicas.
  Usa cuando necesites crear graficos via reticulate para ejercicios ICFES.
  Parte del Flujo B (Graficador Experto) - fase 2 despues de TikZ.
  Activar con "generar python", "codigo matplotlib", "grafico python", "reticulate plot".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere Python 3.8+, matplotlib, numpy. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Bash(python:*)
  - Bash(ls:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas, la imagen original y los requisitos del grafico como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Generador de Codigo Python (matplotlib/numpy)

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
                 +-> Generar codigo matplotlib
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

```python
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import rcParams

rcParams['savefig.dpi'] = 300
rcParams['figure.figsize'] = (8, 6)
```

### PASO 2: Identificar patron

Ver [patrones matplotlib](references/patrones-matplotlib.md) para:

- Funciones matematicas (lineas, curvas)
- Figuras geometricas (poligonos, circulos)
- Graficos estadisticos (barras, histogramas)
- Vectores y angulos

### PASO 3: Generar codigo

Estructura basica:

```python
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y, 'b-', linewidth=2)  # Geometria
ax.set_xlabel('x')                 # Etiquetas
ax.set_ylabel('y')
ax.grid(True, alpha=0.3)           # Cuadricula
plt.savefig('outputs/output_python.png', dpi=300, bbox_inches='tight')
```

### PASO 4: Personalizar estilos

Ver [estilos matplotlib](references/estilos-matplotlib.md) para:

- Colores (nombres, hex, RGB)
- Estilos de linea
- Marcadores
- Texto matematico (LaTeX)

### PASO 5: Validar y guardar

```python
plt.savefig('outputs/output_python.png', dpi=300, bbox_inches='tight')
plt.show()
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

1. **Usar numpy**: Vectorizacion, evitar bucles
2. **Alta resolucion**: dpi=300
3. **bbox_inches='tight'**: Evitar recortes
4. **Nombres descriptivos**: Variables claras
5. **Comentarios**: Documentar secciones
6. **Cerrar figuras**: plt.close() despues de guardar

## Salida

Codigo Python completo guardado en `outputs/output_python.py`.

## Ejemplos

**Ejemplo 1**: Histograma de frecuencias con datos generados en R
- Input: Vector numérico desde R (via reticulate) + imagen ICFES de referencia
- Resultado: `output_python_v1.py` con `ax.bar()` parametrizado por variables transferidas con `r.variable`

**Ejemplo 2**: Diagrama de dispersión con línea de tendencia
- Input: Gráfica de dispersión con recta de regresión visible
- Resultado: Código matplotlib con `ax.scatter()` y `ax.plot()` usando pendiente e intercepto dinámicos

## Referencias

- [Patrones matplotlib](references/patrones-matplotlib.md) - Codigo por tipo de contenido
- [Estilos matplotlib](references/estilos-matplotlib.md) - Colores, lineas, LaTeX
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
analizar-icfes -> Flujo B:
    1. generar-codigo-tikz
    2. generar-codigo-python <- ESTE SKILL
    3. generar-codigo-r
    4. seleccion usuario
```
