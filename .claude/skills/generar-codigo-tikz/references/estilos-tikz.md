# Estilos y Personalizacion TikZ

## Colores

```latex
% Colores predefinidos
\draw[red] ...;
\draw[blue!70] ...;        % 70% azul
\draw[red!50!blue] ...;    % Mezcla 50-50

% Colores personalizados
\definecolor{myblue}{RGB}{0,102,204}
\definecolor{mygreen}{HTML}{4CAF50}
```

## Lineas

```latex
\draw[thin] ...;          % Delgada
\draw[thick] ...;         % Gruesa
\draw[very thick] ...;    % Muy gruesa
\draw[dashed] ...;        % Discontinua
\draw[dotted] ...;        % Punteada
\draw[dash dot] ...;      % Raya-punto
```

## Flechas

```latex
\draw[->] ...;                    % Flecha simple
\draw[<->] ...;                   % Doble flecha
\draw[-{Stealth[length=3mm]}] ...; % Flecha personalizada
```

## Rellenos

```latex
\fill[blue] ...;              % Relleno solido
\fill[blue, opacity=0.3] ...; % Relleno transparente
\pattern[pattern=dots] ...;   % Patron de puntos
```

## Plantilla: Funcion Matematica

```latex
\documentclass[border=2mm]{standalone}
\usepackage{tikz}
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}

\begin{document}
\begin{tikzpicture}
    \begin{axis}[
        width=10cm,
        height=8cm,
        xlabel={$x$},
        ylabel={$y$},
        domain=-5:5,
        samples=100,
        axis lines=middle,
        grid=major,
        legend pos=north west
    ]

    % Funcion principal
    \addplot[blue, thick] {x^2 - 4*x + 3};
    \addlegend{$f(x)=x^2-4x+3$}

    % Puntos especiales
    \addplot[only marks, mark=*, red] coordinates {(1,0) (3,0) (2,-1)};

    % Anotaciones
    \node[above] at (axis cs:1,0) {$(1,0)$};
    \node[below] at (axis cs:2,-1) {Vertice $(2,-1)$};

    \end{axis}
\end{tikzpicture}
\end{document}
```

## Plantilla: Geometria Plana

```latex
\documentclass[border=2mm]{standalone}
\usepackage{tikz}
\usetikzlibrary{angles, quotes, calc}

\begin{document}
\begin{tikzpicture}[scale=1.5]

    % Definir puntos
    \coordinate (A) at (0,0);
    \coordinate (B) at (4,0);
    \coordinate (C) at (2,3);

    % Dibujar triangulo
    \draw[thick] (A) -- (B) -- (C) -- cycle;

    % Etiquetas de vertices
    \node[below left] at (A) {$A$};
    \node[below right] at (B) {$B$};
    \node[above] at (C) {$C$};

    % Medidas de lados
    \draw[|<->|, >=stealth] ($(A)+(0,-0.3)$) -- ($(B)+(0,-0.3)$)
        node[midway, below] {$4$ cm};

    % Angulos
    \pic[draw, angle radius=0.5cm, "$\alpha$"] {angle=B--A--C};

\end{tikzpicture}
\end{document}
```

## Plantilla: Estadistica

```latex
\documentclass[border=2mm]{standalone}
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}

\begin{document}
\begin{tikzpicture}
    \begin{axis}[
        ybar,
        width=12cm,
        height=8cm,
        bar width=15pt,
        symbolic x coords={Lun,Mar,Mie,Jue,Vie},
        xtick=data,
        nodes near coords,
        ylabel={Ventas},
        xlabel={Dia de la semana},
        title={Ventas Semanales},
        ymin=0,
        ymax=30,
        grid=major
    ]

    \addplot[fill=blue!60] coordinates {
        (Lun,20) (Mar,25) (Mie,18) (Jue,28) (Vie,22)
    };

    \end{axis}
\end{tikzpicture}
\end{document}
```

## Optimizacion de Codigo

```latex
% MAL: Repetitivo
\draw (0,0) -- (1,0);
\draw (1,0) -- (1,1);
\draw (1,1) -- (0,1);
\draw (0,1) -- (0,0);

% BIEN: Conciso
\draw (0,0) rectangle (1,1);

% MAL: Sin reutilizacion
\fill[blue] (2,3) circle (0.1);
\node[above] at (2,3) {$P$};

% BIEN: Con coordenada nombrada
\coordinate (P) at (2,3);
\fill[blue] (P) circle (0.1);
\node[above] at (P) {$P$};
```

## Errores Comunes

| Error | Solucion |
|-------|----------|
| Dimension demasiado grande | Reducir `samples` o ajustar `domain` |
| Punto indefinido | Verificar coordenadas bien definidas |
| Paquete no encontrado | Incluir paquete en preambulo |
| Compilacion lenta | Reducir `samples`, simplificar calculos |
