# Patrones de Correccion por Lenguaje

## 1. Correcciones de Colores

### TikZ

```latex
% ANTES
\draw[blue] (0,0) -- (1,1);

% DESPUES
\definecolor{customblue}{RGB}{0,102,204}
\draw[customblue] (0,0) -- (1,1);
```

### Python

```python
# ANTES
ax.plot(x, y, 'b-')

# DESPUES
ax.plot(x, y, color='#0066CC', linewidth=2)
```

### R

```r
# ANTES
geom_line(color = "blue")

# DESPUES
geom_line(color = "#0066CC", size = 1.2)
```

## 2. Correcciones de Posiciones

### TikZ

```latex
% ANTES
\coordinate (C) at (2,2.8);

% DESPUES
\coordinate (C) at (2,3);  % Coordenada exacta
```

### Python

```python
# ANTES
vertices = [(0, 0), (4, 0), (2, 2.8)]

# DESPUES
vertices = [(0, 0), (4, 0), (2, 3)]  # Corregida
```

### R

```r
# ANTES
y = c(0, 0, 2.8)

# DESPUES
y = c(0, 0, 3)  # Coordenada exacta
```

## 3. Correcciones de Rangos

### TikZ

```latex
% ANTES
\begin{axis}[ymin=-2, ymax=6]

% DESPUES
\begin{axis}[ymin=-3, ymax=7]  % Rango corregido
```

### Python

```python
# ANTES
ax.set_ylim(-2, 6)

# DESPUES
ax.set_ylim(-3, 7)  # Rango corregido
```

### R

```r
# ANTES
coord_cartesian(ylim = c(-2, 6))

# DESPUES
coord_cartesian(ylim = c(-3, 7))
```

## 4. Correcciones de Estilos de Linea

### TikZ

```latex
% ANTES
\draw[thick] (0,0) -- (1,1);

% DESPUES
\draw[thick, dashed] (0,0) -- (1,1);
```

### Python

```python
# ANTES
ax.plot(x, y, linewidth=2)

# DESPUES
ax.plot(x, y, linewidth=2, linestyle='--')
```

### R

```r
# ANTES
geom_line(size = 1.2)

# DESPUES
geom_line(size = 1.2, linetype = "dashed")
```

## 5. Anadir Elementos Faltantes

### Leyenda TikZ

```latex
\legend{$f(x)=x^2$, $g(x)=2x+1$}
```

### Leyenda Python

```python
ax.legend(['$f(x)=x^2$', '$g(x)=2x+1$'], loc='upper right')
```

### Leyenda R

```r
labs(color = "Funcion")
```

## 6. Eliminar Elementos Extra

### Cuadricula TikZ

```latex
% ANTES
grid=both,

% DESPUES
grid=major,  % Solo principal
```

### Cuadricula Python

```python
# ANTES
ax.grid(True, which='both')

# DESPUES
ax.grid(True, which='major')
```

### Cuadricula R

```r
theme(
  panel.grid.major = element_line(),
  panel.grid.minor = element_blank()  # Eliminar menor
)
```
