# Patrones TikZ por Tipo de Contenido

## Paquetes Esenciales

```latex
\usepackage{tikz}           % Dibujo basico
\usepackage{pgfplots}       % Graficos y plots
\usepackage{amsmath}        % Matematicas
\usepackage{amssymb}        % Simbolos matematicos
\pgfplotsset{compat=1.18}   % Version de pgfplots
```

## Librerias Utiles

```latex
\usetikzlibrary{arrows.meta}      % Flechas
\usetikzlibrary{calc}             % Calculos
\usetikzlibrary{patterns}         % Patrones de relleno
\usetikzlibrary{decorations}      % Decoraciones
\usetikzlibrary{angles}           % Angulos
\usetikzlibrary{quotes}           % Etiquetas
\usetikzlibrary{shapes.geometric} % Formas
```

## 1. Funciones Matematicas

### Funciones basicas

```latex
\begin{axis}[
    xlabel=$x$,
    ylabel=$y$,
    domain=-5:5,
    samples=100,
    axis lines=middle,
    grid=major
]
\addplot[blue, thick] {x^2};
\addplot[red, dashed] {2*x + 1};
\end{axis}
```

### Funciones trigonometricas

```latex
\addplot[domain=0:2*pi, samples=200] {sin(deg(x))};
\addplot[domain=0:2*pi, samples=200] {cos(deg(x))};
```

### Funciones por partes

```latex
\addplot[blue, thick] coordinates {
    (-5, 0) (-2, 0)
};
\addplot[blue, thick] coordinates {
    (-2, 1) (2, 1)
};
```

## 2. Figuras Geometricas

### Triangulo

```latex
\draw[thick] (0,0) -- (4,0) -- (2,3) -- cycle;
\node[below left] at (0,0) {$A$};
\node[below right] at (4,0) {$B$};
\node[above] at (2,3) {$C$};
```

### Circulo

```latex
\draw[thick] (0,0) circle (2cm);
\fill[blue, opacity=0.3] (0,0) circle (2cm);
```

### Poligonos regulares

```latex
\draw[thick] (0:2) \foreach \x in {72,144,...,288} {
    -- (\x:2)
} -- cycle;
```

### Angulos

```latex
\draw (0,0) -- (3,0) -- (2,2) -- cycle;
\pic[draw, angle radius=0.5cm, "$\theta$"] {angle=B--A--C};
```

## 3. Estadistica

### Grafico de barras

```latex
\begin{axis}[
    ybar,
    symbolic x coords={A,B,C,D,E},
    xtick=data,
    nodes near coords,
    ylabel={Frecuencia}
]
\addplot coordinates {(A,12) (B,18) (C,7) (D,22) (E,15)};
\end{axis}
```

### Histograma

```latex
\begin{axis}[
    ybar interval,
    xlabel={Rango},
    ylabel={Frecuencia}
]
\addplot coordinates {
    (0,5) (10,12) (20,8) (30,15) (40,10) (50,0)
};
\end{axis}
```

### Grafico circular

```latex
\pie[radius=2, text=legend]{
    30/Categoria A,
    25/Categoria B,
    20/Categoria C,
    25/Categoria D
}
```
