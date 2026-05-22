# Patron de Renderizado Condicional para ERR_G1

## Contexto del Error

```
Package pdftex.def Error: File `imagen.png' not found: using draft setting.
Error: LaTeX failed to compile archivo.tex
```

## Causa Raiz

El uso de `include_tikz()` genera archivos PNG/PDF en directorios temporales
que no son accesibles durante la compilacion LaTeX final por `exams2pdf()`.

## Patron de Correccion

### ANTES (INCORRECTO)

```r
```{r generar_diagrama, echo=FALSE, results="hide"}
tikz_code <- generar_tikz_funcion(params)

include_tikz(tikz_code,
             name = "mi_diagrama",
             markup = "markdown",
             format = typ,
             packages = c("tikz", "xcolor"),
             width = "8cm")
```

**Uso en Question:**

```markdown
![](mi_diagrama.png){width=50%}
```

### DESPUES (CORRECTO)

```r
```{r generar_diagrama, echo=FALSE, results="hide"}
# Solo generar el codigo TikZ, NO renderizarlo aqui
tikz_code <- generar_tikz_funcion(params)
```

**Uso en Question:**

```r
```{r mostrar_diagrama, echo=FALSE, results='asis', fig.align='center'}
# Detectar formato de salida
es_latex <- knitr::is_latex_output()

if (es_latex) {
  # Para PDF: insertar codigo TikZ directamente
  cat("\\begin{center}\n")
  cat(tikz_code)
  cat("\n\\end{center}\n")
} else {
  # Para HTML: usar include_tikz
  include_tikz(tikz_code,
               name = "mi_diagrama",
               markup = "markdown",
               format = typ,
               packages = c("tikz", "xcolor"),
               width = "8cm")
  cat("\n\n")
}
```

## Casos de Uso

### Diagramas Geometricos

- Cilindros, conos, prismas, piramides
- Poligonos, triangulos, circunferencias
- Graficas de funciones

### Graficos Estadisticos

- Histogramas, diagramas de barras
- Graficos de dispersion
- Curvas de distribucion

### Diagramas de Probabilidad

- Arboles de probabilidad
- Diagramas de Venn
- Espacios muestrales

## Verificacion

Despues de aplicar la correccion:

1. Compilar a PDF con `exams2pdf()`
2. Compilar a HTML con `exams2html()`
3. Confirmar que ambos formatos funcionan
