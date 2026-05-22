# Ejemplos de Transferencia de Conocimiento

## Ejemplo 1: Colores RGB

### TikZ (exito original)

```json
{
  "descripcion": "Definir color azul con RGB(0,102,204) funciono perfectamente",
  "categoria": "colores",
  "codigo_ejemplo": "\\definecolor{myblue}{RGB}{0,102,204}",
  "iteracion": 1
}
```

### Python (aplicacion)

```json
{
  "leccion": "Color RGB(0,102,204) funciono perfectamente en TikZ",
  "aplicacion": "Usar mismo RGB en matplotlib: color='#0066CC'",
  "resultado": "exitoso"
}
```

**Codigo Python resultante**:

```python
color_funcion = '#0066CC'  # Mismo RGB que funciono en TikZ
ax.plot(x, y, color=color_funcion, linewidth=2)
```

### R (aplicacion)

```json
{
  "leccion": "Color RGB(0,102,204) funciono en TikZ y Python",
  "aplicacion": "Usar mismo RGB en ggplot2: color='#0066CC'",
  "resultado": "exitoso"
}
```

**Codigo R resultante**:

```r
color_funcion <- "#0066CC"  # Mismo RGB que funciono en TikZ y Python
geom_line(color = color_funcion, size = 1.2)
```

## Ejemplo 2: Posicionamiento Problematico

### TikZ (problema identificado)

```json
{
  "descripcion": "Posicionamiento de etiquetas requirio 3 iteraciones",
  "categoria": "posicionamiento",
  "solucion": "Usar coordenadas relativas con anchor y shift",
  "iteraciones_requeridas": 3
}
```

### Python (aplicacion preventiva)

```json
{
  "leccion": "Posicionamiento de etiquetas fue problematico en TikZ",
  "aplicacion": "Usar coordenadas exactas desde el inicio en matplotlib",
  "resultado": "exitoso"
}
```

**Codigo Python resultante**:

```python
# Aplicar atencion especial al posicionamiento (leccion de TikZ)
plt.annotate('Vertice', xy=(2, -1), xytext=(2.5, -1.5),
             arrowprops=dict(arrowstyle='->'), fontsize=10)
```

### R (aplicacion)

```json
{
  "leccion": "Posicionamiento fue problematico en TikZ, resuelto en Python con coordenadas exactas",
  "aplicacion": "Usar coordenadas exactas en R tambien",
  "resultado": "exitoso"
}
```

**Codigo R resultante**:

```r
# Aplicar coordenadas exactas (leccion de TikZ y Python)
annotate("text", x = 2.5, y = -1.5, label = "Vertice", size = 3)
```

## Ejemplo 3: Estilos de Linea

### TikZ (exito)

```json
{
  "descripcion": "Lineas gruesas (thick) mejoran visibilidad en graficos",
  "categoria": "estilos",
  "codigo_ejemplo": "\\draw[thick, blue] (0,0) -- (5,3);",
  "iteracion": 1
}
```

### Python (aplicacion)

```python
# Leccion TikZ: lineas gruesas mejoran visibilidad
ax.plot(x, y, linewidth=2)  # Equivalente a 'thick' en TikZ
```

### R (aplicacion)

```r
# Leccion TikZ/Python: lineas gruesas mejoran visibilidad
geom_line(size = 1.2)  # Equivalente a thick/linewidth=2
```
