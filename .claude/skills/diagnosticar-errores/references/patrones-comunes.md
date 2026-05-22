# Patrones de Errores Comunes

## Patron 1: TikZ No Renderiza en HTML

**Sintomas:**

- PDF OK, HTML muestra espacio en blanco

**Diagnostico:** ERR_G1

**Solucion verificada:**

```r
if (knitr::is_latex_output()) {
  include_tikz("grafico.tex")
} else {
  knitr::include_graphics("grafico.png")
}
```

**Ejemplo funcional:** `/A-Produccion/Ejemplos-Funcionales-Rmd/grafico_lineas_poblacion.Rmd`

## Patron 2: Caracteres Especiales Rompen LaTeX

**Sintomas:**

- PDF falla con `! LaTeX Error: Missing \begin{document}`
- HTML OK

**Diagnostico:** ERR_T5

**Solucion verificada:**
Escapar caracteres: `_` -> `\_`, `%` -> `\%`, `#` -> `\#`, `&` -> `\&`

## Patron 3: CLOZE Falla en NOPS

**Sintomas:**

- HTML/PDF/DOCX OK (3/4)
- NOPS falla: `exercise type 'cloze' with 'num' not supported`

**Diagnostico:** ERR_S5

**Solucion:**
Aceptar que NOPS fallara. Es comportamiento esperado para CLOZE con gaps num/string.

**Accion:** Ninguna. Marcar error como BAJA prioridad y continuar.

## Patron 4: Operacion con Variable Formateada

**Sintomas:**

- Error: `non-numeric argument to binary operator`

**Diagnostico:** ERR_C3

**Causa:**

```r
# Incorrecto:
poblacion <- formatear_entero(poblacion_inicial)  # "150.000" (string)
incremento <- poblacion * 1.05  # Error: string * number
```

**Solucion:**

```r
# Correcto:
poblacion <- poblacion_inicial  # 150000 (numeric)
poblacion_formateada <- formatear_entero(poblacion)  # Solo para mostrar
incremento <- poblacion * 1.05  # OK: numeric * number
```

## Patron 5: Paquete LaTeX Faltante

**Sintomas:**

- Error: `! LaTeX Error: File 'tikz.sty' not found`

**Diagnostico:** ERR_T1

**Solucion:**

```yaml
header-includes:
  - \usepackage{tikz}
  - \usepackage{pgfplots}
  - \pgfplotsset{compat=1.18}
  - \usepackage[spanish]{babel}
  - \decimalpoint
```

## Patron 6: Variable No Definida

**Sintomas:**

- Error: `object 'variable' not found`

**Diagnostico:** ERR_C3

**Causa:** Variable calculada pero no retornada en lista de generar_datos()

**Solucion:**

```r
# Antes:
generar_datos <- function() {
  resultado <- a * b
  list(a = a, b = b)  # resultado NO retornado
}

# Despues:
generar_datos <- function() {
  resultado <- a * b
  list(a = a, b = b, resultado = resultado)  # resultado retornado
}
```
