# Tipos de Errores Graficos (ERR_G)

## ERR_G1: Graficas No Visualizadas

**Sintoma**: `File '*.png' not found` o imagen ausente en output

**Causa raiz**: `include_tikz()` en chunk de generacion crea archivos temporales inaccesibles

**Solucion**:

```r
# ANTES (incorrecto)
```{r generar, echo=FALSE, results="hide"}
include_tikz(tikz_code, name = "grafico", ...)
```

# DESPUES (correcto)
```{r mostrar, echo=FALSE, results='asis'}
if (knitr::is_latex_output()) {
  cat("\\begin{center}\n")
  cat(tikz_code)
  cat("\n\\end{center}\n")
} else {
  include_tikz(tikz_code, name = "grafico", ...)
}
```
```

## ERR_G2: Graficas Solapadas

**Sintoma**: Elementos graficos superpuestos, texto sobre figuras

**Causa raiz**: Posicionamiento incorrecto o margenes insuficientes

**Solucion TikZ**:

```latex
\vspace{1cm}  % Antes del grafico

\begin{tikzpicture}
  \node at (0,0) {...};
  \node at (3,0) {...};  % Separar horizontalmente
\end{tikzpicture}

\vspace{1cm}  % Despues del grafico
```

**En markdown R/exams**:

```r
cat("\n\n")  # Doble salto antes
cat(tikz_code)
cat("\n\n")  # Doble salto despues
```

## ERR_G3: Renderizado Incorrecto

**Sintoma**: Grafico visible pero distorsionado, colores incorrectos

**Diagnostico**:

1. Verificar sintaxis TikZ
2. Revisar librerias cargadas
3. Comprobar coordenadas y escalas

**Solucion TikZ**:

```latex
\usepackage{tikz}
\usepackage{pgfplots}
\usetikzlibrary{3d,babel}

\begin{tikzpicture}[scale=1.0]
  \draw (0,0) -- (3,0) -- (3,2) -- (0,2) -- cycle;
\end{tikzpicture}
```

**Solucion Python**:

```python
import matplotlib
matplotlib.use('Agg')

plt.savefig('grafico.png', dpi=150, bbox_inches='tight')
```

## ERR_G4: Tamano Inadecuado

**Sintoma**: Grafico demasiado grande/pequeno

**Solucion TikZ**:

```latex
\begin{tikzpicture}[scale=0.8]  % Reducir 20%

% O en include_tikz
include_tikz(tikz_code, width = "6cm")
```

**Solucion Python**:

```python
fig, ax = plt.subplots(figsize=(6, 4))  # 6x4 pulgadas
```

**En markdown**:

```markdown
![](grafico.png){width=40%}
```
