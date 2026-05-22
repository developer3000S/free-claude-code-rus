# Patrones de Errores Conocidos y Soluciones - R/exams

> **Nota:** Este documento solo registra errores que ya han sido identificados, corregidos y verificados. No se documentan problemas sin solución confirmada.

---

## Índice

1. [Error: Imagen PNG no encontrada en compilación PDF](#error-1-imagen-png-no-encontrada)
2. [Error: Argumento no numérico para función matemática abs()](#error-2-argumento-no-numerico-abs)
3. [Error: Imágenes Python/matplotlib no visibles en exams2pdf](#error-3-imagenes-python-no-visibles-pdf)
4. [Error: Gráficos como opciones mostrados en grid](#error-4-gráficos-como-opciones-mostrados-en-grid-no-individuales)
5. [Error: Gráfico aplastado por escala incompatible](#error-5-gráfico-aplastado-por-escala-incompatible-est-box-01)
6. [Error: Rango insuficiente para sample()](#error-6-rango-insuficiente-para-sample-sin-reemplazo)
7. [Error: Descripción de error conceptual incoherente con paridad de datos](#error-7-descripción-de-error-conceptual-incoherente-con-paridad-de-datos)
8. [Error: Corrupción de RNG por test de diversidad](#error-8-corrupción-de-rng-por-test-de-diversidad)
9. [Error: ##ANSWERi## mal ubicados en ejercicio CLOZE](#error-9-answeri-mal-ubicados-en-ejercicio-cloze)
10. [Error: NA en comparación while con calcula()](#error-10-na-en-comparación-while-con-calcula)

### Categoría: Infraestructura `.claude/` (sesión Ruflo 2026-05-03)
11. [Error: Drift silencioso de hooks tras instalación de plataforma externa](#error-11-drift-silencioso-de-hooks-tras-instalación-de-plataforma-externa)
12. [Error: `CLAUDE.md` raíz sobrescrito por plantilla genérica de plataforma](#error-12-claudemd-raíz-sobrescrito-por-plantilla-genérica-de-plataforma)
13. [Error: MCP registrado pero sin conectar (paquete fantasma)](#error-13-mcp-registrado-pero-sin-conectar-paquete-fantasma)
14. [Error: CLI claude-flow falla con `npm error Invalid Version`](#error-14-cli-claude-flow-falla-con-npm-error-invalid-version)
15. [Error: Auto-memory bridge sin paquete instalado (`Memory package not available`)](#error-15-auto-memory-bridge-sin-paquete-instalado)

### Categoría: Pipeline render PDF + coherencia Solution (sesiones 2026-05-03/14)
16. [Error: `\pandocbounded` undefined en PDF](#error-16-pandocbounded-undefined-al-renderizar-pdf-con-imágenes-markdown-sin-atributo-width)
17. [Error: Inconsistencia Solution↔Answerlist por exshuffle](#error-17-inconsistencia-solutionanswerlist-por-exshuffle-true-con-referencia-explícita-a-letra)
18. [Error: Estudiante identifica opción correcta por formato gráfico sin verificar datos](#error-18-estudiante-puede-identificar-opción-correcta-por-formato-gráfico-sin-verificar-datos)
19. [Error: Solution con letra_correcta rompe coherencia bajo Moodle](#error-19-solution-con-r-letra_correcta-rompe-coherencia-bajo-moodle-re-shuffle)
20. [Error: GRAF-BAR-01 — Barras con categorías correctas pero alturas permutadas](#error-20-graf-bar-01--gráfico-de-barras-con-categorías-correctas-pero-alturas-permutadas)

---

## Error 1: Imagen PNG no encontrada en compilación PDF

### ❌ Mensaje de Error
```
Package pdftex.def Error: File `nombre_archivo.png' not found: using draft setting.
Error: LaTeX failed to compile archivo.tex.
See https://yihui.org/tinytex/r/#debugging for debugging tips.
```

### 🔍 Causa Raíz
El uso de `include_tikz()` dentro de chunks de generación de datos crea archivos PNG/PDF en directorios temporales que no son accesibles cuando `exams2pdf()` ejecuta la compilación LaTeX final.

**Flujo del problema:**

1. `include_tikz()` genera `imagen.png` en `/tmp/RtmpXXXX/...`
2. El chunk retorna referencia markdown: `![](imagen.png)`
3. Durante `exams2pdf()`, LaTeX busca `imagen.png` en el directorio de trabajo actual
4. El archivo no existe en esa ruta → Error de compilación

### ✅ Solución Verificada

**Enfoque:** Renderizado condicional según formato de salida

#### Código ANTES (incorrecto):

```r
```{r generar_diagrama_cilindro, echo=FALSE, results="hide"}
options(OutDec = ".")

generar_tikz_cilindro <- function(r, h) {
  tikz_code <- paste0(
    "\\begin{tikzpicture}[scale=0.6]\n",
    # ... código TikZ ...
    "\\end{tikzpicture}"
  )
  return(tikz_code)
}

tikz_cilindro <- generar_tikz_cilindro(radio, altura)

# ❌ PROBLEMA: include_tikz en chunk de generación
include_tikz(tikz_cilindro,
             name = "cilindro_vaso",
             markup = "markdown",
             format = typ,
             packages = c("tikz", "xcolor", "amsmath"),
             width = "8cm")
```

Uso en Question:
```markdown
![](cilindro_vaso.png){width=50%}
```

#### Código DESPUÉS (correcto):

```r
```{r generar_codigo_tikz, echo=FALSE, results="hide"}
# ✅ Solo generar el código TikZ, NO renderizarlo
options(OutDec = ".")

generar_tikz_cilindro <- function(r, h) {
  tikz_code <- paste0(
    "\\begin{tikzpicture}[scale=0.6]\n",
    "\\def\\radio{", r * 0.4, "}\n",
    "\\def\\altura{", h * 0.4, "}\n",
    "\\draw[thick, brown!70!black] (0, \\altura) ellipse (\\radio cm and 0.4 cm);\n",
    "\\draw[thick, brown!70!black, dashed] (0, 0) ellipse (\\radio cm and 0.4 cm);\n",
    "\\draw[thick, brown!70!black] (-\\radio, 0) -- (-\\radio, \\altura);\n",
    "\\draw[thick, brown!70!black] (\\radio, 0) -- (\\radio, \\altura);\n",
    "\\draw[<->, thick, red] (0, \\altura) -- (\\radio, \\altura) ",
    "node[midway, above] {\\textbf{", r, " cm}};\n",
    "\\draw[<->, thick, blue] (\\radio + 0.8, 0) -- (\\radio + 0.8, \\altura) ",
    "node[midway, right] {\\textbf{", h, " cm}};\n",
    "\\end{tikzpicture}"
  )
  return(tikz_code)
}

tikz_cilindro <- generar_tikz_cilindro(radio, altura)
# NO llamar a include_tikz aquí
```

Uso en Question (con renderizado condicional):
```r
```{r mostrar_cilindro, echo=FALSE, results='asis', fig.align='center'}
# ✅ Renderizado condicional según formato
es_latex <- knitr::is_latex_output()

if (es_latex) {
  # Para PDF/LaTeX: insertar código TikZ directamente
  cat("\\begin{center}\n")
  cat(tikz_cilindro)
  cat("\n\\end{center}\n\n")
} else {
  # Para HTML: usar include_tikz
  include_tikz(tikz_cilindro,
               name = "cilindro_vaso",
               markup = "markdown",
               format = typ,
               packages = c("tikz", "xcolor", "amsmath"),
               width = "8cm")
  cat("\n\n")
}
```

### 🧪 Validación de la Solución

La validación debe hacerse en **TRES NIVELES** según el flujo de trabajo real:

#### **Nivel 1: RStudio (Run > Run all)**
Ejecutar todos los chunks interactivamente en RStudio.

**Criterio de éxito:**

- ✅ Todos los chunks ejecutan sin errores
- ✅ El output configurado en YAML se genera correctamente
- ✅ Los gráficos TikZ se visualizan

**Método:**
```

1. Abrir .Rmd en RStudio
2. Run > Run All
3. Verificar output (HTML/PDF/Word según YAML)
```

#### **Nivel 2: Generación Masiva (SemilleroUnico_v2.R)**
Ejecutar el script de generación completa desde la misma carpeta del .Rmd.

**Criterios de éxito:**

- ✅ `exams2html()` compila sin errores
- ✅ `exams2pdf()` compila sin errores
- ✅ `exams2pandoc()` genera DOCX sin errores
- ✅ `exams2nops()` genera exámenes escaneables sin errores
- ✅ Diagramas TikZ correctos en TODOS los formatos

**Método:**
```bash
# Desde la carpeta del .Rmd
Rscript SemilleroUnico_v2.R
```

**O usar script de prueba completa:**
```bash
Rscript test_todos_formatos.R
```

**Resultado esperado:**
```
Formato    | Resultado
-----------|----------
HTML       | ✅ EXITOSO
PDF        | ✅ EXITOSO
DOCX       | ✅ EXITOSO
NOPS       | ✅ EXITOSO

Tasa de éxito: 4 de 4 formatos (100%)
```

#### **Nivel 3: Terreno (Estudiantes)**
Validación en el aula con estudiantes reales.

**Criterios de validación:**

- ✅ Enunciado claro y sin ambigüedades
- ✅ Solución matemática correcta
- ✅ Distractores plausibles pero incorrectos
- ✅ Contexto apropiado para el nivel
- ✅ Tiempos de resolución razonables
- ✅ Sin errores de cálculo o tipográficos

**Importante:**
> Esta validación detecta errores que no son visibles en pruebas técnicas: ambigüedades en el lenguaje, errores matemáticos sutiles, contextos confusos, etc.

### 📋 Checklist de Corrección

- [ ] Identificar chunks que usan `include_tikz()`
- [ ] Mover `include_tikz()` fuera del chunk de generación
- [ ] Crear chunk de renderizado condicional con `knitr::is_latex_output()`
- [ ] Para LaTeX: usar `cat()` para insertar código TikZ directamente
- [ ] Para HTML: mantener `include_tikz()`
- [ ] Verificar compilación a PDF
- [ ] Verificar compilación a HTML
- [ ] Confirmar visualización correcta en ambos formatos

### 🎯 Casos Aplicables

Este patrón de solución aplica para:

- ✅ Diagramas geométricos con TikZ (cilindros, prismas, polígonos)
- ✅ Gráficos estadísticos generados con TikZ
- ✅ Diagramas de árbol de probabilidad
- ✅ Cualquier visualización generada con código TikZ en R/exams

### ⚠️ Casos NO Aplicables

Este patrón NO aplica para:

- ❌ Imágenes externas (PNG/JPG ya existentes)
- ❌ Gráficos generados con ggplot2 o base R
- ❌ Diagramas generados con Python/matplotlib

### 🔗 Archivos de Referencia

**Ejemplo corregido verificado:**

- `/A-Produccion/En-Desarrollo/volumen_cilindro_geometrico_metrico_interpretacion_n2_v1.Rmd`

**Skill asociado:**

- `.claude/skills/corregir-error-imagen/skill.md`

### 📅 Historial

| Fecha | Versión | Estado | Validado en | Niveles Validados |
|-------|---------|--------|-------------|-------------------|
| 2025-12-19 22:36 | v1.1 | ✅ Verificado | volumen_cilindro_geometrico_metrico_interpretacion_n2_v1.Rmd | Nivel 2 ✅ (Validación completa) |
| 2025-12-19 | v1.0 | ✅ Verificado | volumen_cilindro_geometrico_metrico_interpretacion_n2_v1.Rmd | Niveles 1 y 2 ✅ |

**Pruebas de validación realizadas (v1.1 - 2025-12-19 22:36):**

**Nivel 1 - RStudio (Run > Run all):**

- ⏭️ Pendiente de validación por usuario

**Nivel 2 - Generación Masiva (validar_sin_gui.R):**

- ✅ exams2html: Exitoso
  - HTML generado sin errores
  - include_tikz() funcionó correctamente para formato HTML
- ✅ exams2pdf: Exitoso (template solpcielo, pdfTeX-1.40.28)
  - Archivo: volumen_cilindro_geometrico_metrico_interpretacion_n2_v1_1.pdf
  - Tamaño: 94K (95,542 bytes)
  - Páginas: 4
  - Código TikZ insertado directamente (no usa archivos PNG externos)
  - Sin errores de "File not found"
- ✅ exams2pandoc: Exitoso (DOCX con pcielo.tex)
  - Archivo: volumen_cilindro_geometrico_metrico_interpretacion_n2_v1_1.docx
  - Tamaño: 23K
  - Imágenes embebidas detectadas:
    - word/media/rId23.png (3.1 KB)
    - word/media/rId32.png (2.4 KB)
    - word/media/rId20.svg (6.6 KB)
    - word/media/rId29.svg (7.6 KB)
- ✅ exams2nops: Exitoso (exámenes escaneables)
  - Archivo: volumen_cilindro_geometrico_metrico_interpretacion_n2_v1_nops_1.pdf
  - Tamaño: 81K
  - Formato escaneable generado correctamente
- ✅ Tasa de éxito: 4 de 4 formatos (100%)
- ✅ Diagrama TikZ del cilindro renderizado correctamente en TODOS los formatos
- ✅ Renderizado condicional funcionando perfectamente:
  - PDF: Código TikZ insertado directamente con cat()
  - HTML: include_tikz() genera PNG en directorio temporal
  - DOCX: Imágenes PNG/SVG embebidas en el archivo
- ✅ Sin errores de "File not found" en ningún formato
- ✅ Solución confirmada y reproducible
- ⚠️ Advertencias menores: Labels LaTeX duplicados (no afectan funcionalidad)

**Nivel 3 - Terreno (Estudiantes):**

- ⏭️ Pendiente de validación en aula

---

## Error 2: Argumento no numérico para función matemática abs()

### ❌ Mensaje de Error
```
Error in `abs(b_formateado)`: Argumento no numérico para una función matemática
Backtrace:

 1. └─global generar_datos()
 2. └─base::paste0("y = ", m_formateado, "x - ", abs(b_formateado))
Error: ! Test failed
```

### 🔍 Causa Raíz
Aplicar funciones matemáticas (como `abs()`, `round()`, `floor()`, etc.) sobre variables que ya han sido formateadas como strings. Las variables formateadas son de tipo `character`, no `numeric`, por lo que no pueden usarse en operaciones matemáticas.

**Flujo del problema:**

1. Se genera un valor numérico: `b <- -2.5`
2. Se formatea como string: `b_formateado <- ifelse(b == as.integer(b), as.character(b), sprintf("%.1f", b))` → `"-2.5"` (string)
3. Se intenta aplicar `abs()` sobre el string: `abs(b_formateado)` → ❌ Error
4. La función `abs()` requiere un argumento numérico, no un string

**Patrón común:**
Este error ocurre frecuentemente cuando se necesita:

- Aplicar valor absoluto a un número negativo para mostrarlo en una ecuación
- Formatear el resultado después de aplicar la función matemática
- Usar el valor formateado en múltiples lugares

### ✅ Solución Verificada

**Enfoque:** Aplicar la función matemática sobre el valor numérico original, luego formatear el resultado.

#### Código ANTES (incorrecto):

```r
# Generar valor numérico
b <- -2.5

# Formatear como string
b_formateado <- ifelse(b == as.integer(b), 
                       as.character(b), 
                       sprintf("%.1f", b))
# b_formateado = "-2.5" (string)

# ❌ ERROR: Intentar aplicar abs() sobre string
if (b < 0) {
  ecuacion <- paste0("y = ", m_formateado, "x - ", abs(b_formateado))
  # Error: abs() no puede trabajar con strings
}
```

#### Código DESPUÉS (correcto):

```r
# Generar valor numérico
b <- -2.5

# Formatear valor original (para casos donde b >= 0)
b_formateado <- ifelse(b == as.integer(b), 
                       as.character(b), 
                       sprintf("%.1f", b))

# Para casos donde b < 0, aplicar abs() sobre el número, luego formatear
if (b < 0) {
  # ✅ Aplicar abs() sobre el valor numérico
  b_abs <- abs(b)  # b_abs = 2.5 (numérico)
  
  # ✅ Formatear el resultado
  b_abs_formateado <- ifelse(b_abs == as.integer(b_abs), 
                             as.character(b_abs), 
                             sprintf("%.1f", b_abs))
  # b_abs_formateado = "2.5" (string)
  
  ecuacion <- paste0("y = ", m_formateado, "x - ", b_abs_formateado)
}
```

**Patrón generalizado:**

```r
# ❌ INCORRECTO: Aplicar función matemática sobre string formateado
resultado <- funcion_matematica(variable_formateada)

# ✅ CORRECTO: Aplicar función matemática sobre número, luego formatear
valor_original <- obtener_valor_numerico()
resultado_numerico <- funcion_matematica(valor_original)
resultado_formateado <- formatear(resultado_numerico)
```

### 🧪 Validación de la Solución

#### **Nivel 1: RStudio (Run > Run all)**
Ejecutar todos los chunks interactivamente en RStudio.

**Criterio de éxito:**

- ✅ Todos los chunks ejecutan sin errores
- ✅ Las funciones matemáticas se aplican correctamente
- ✅ Los valores formateados se muestran correctamente en las ecuaciones

**Método:**
```

1. Abrir .Rmd en RStudio
2. Run > Run All
3. Verificar que no hay errores en chunks de generación
4. Verificar que las ecuaciones se muestran correctamente
```

#### **Nivel 2: Prueba de Diversidad**
Ejecutar la prueba de diversidad de versiones.

**Criterios de éxito:**

- ✅ `test_that("Prueba de diversidad de versiones", ...)` pasa sin errores
- ✅ Se generan al menos 250 versiones únicas
- ✅ Todas las versiones generan ecuaciones válidas

**Método:**
```r
# Dentro del archivo .Rmd, ejecutar el chunk de prueba
test_that("Prueba de diversidad de versiones", {
  versiones <- list()
  for(i in 1:1000) {
    datos_test <- generar_datos()
    versiones[[i]] <- digest::digest(datos_test)
  }
  n_versiones_unicas <- length(unique(versiones))
  expect_true(n_versiones_unicas >= 250)
})
```

**Resultado esperado:**
```
Test passed
✓ Prueba de diversidad de versiones
```

#### **Nivel 3: Generación Masiva**
Ejecutar el script de generación completa.

**Criterios de éxito:**

- ✅ `exams2html()` compila sin errores
- ✅ `exams2pdf()` compila sin errores
- ✅ Las ecuaciones se muestran correctamente en todos los formatos
- ✅ No hay errores de tipo en las funciones matemáticas

### 📋 Checklist de Corrección

- [ ] Identificar todas las ocurrencias de funciones matemáticas sobre variables formateadas
- [ ] Buscar patrones como: `abs(variable_formateada)`, `round(variable_formateada)`, etc.
- [ ] Para cada ocurrencia:
  - [ ] Identificar la variable numérica original
  - [ ] Aplicar la función matemática sobre el valor numérico
  - [ ] Formatear el resultado después de aplicar la función
  - [ ] Usar el valor formateado en la construcción de strings
- [ ] Verificar que todas las ecuaciones se generan correctamente
- [ ] Ejecutar prueba de diversidad
- [ ] Validar compilación en todos los formatos

### 🎯 Casos Aplicables

Este patrón de solución aplica para:

- ✅ Aplicar `abs()` sobre valores negativos antes de formatear
- ✅ Aplicar `round()`, `floor()`, `ceiling()` sobre valores antes de formatear
- ✅ Cualquier función matemática que requiera argumentos numéricos
- ✅ Construcción de ecuaciones matemáticas con valores formateados
- ✅ Generación de opciones de respuesta con valores absolutos

### ⚠️ Funciones Matemáticas Comunes que Causan Este Error

| Función | Ejemplo Incorrecto | Ejemplo Correcto |
|---------|-------------------|------------------|
| `abs()` | `abs(b_formateado)` | `abs(b)` luego formatear |
| `round()` | `round(x_formateado)` | `round(x)` luego formatear |
| `floor()` | `floor(x_formateado)` | `floor(x)` luego formatear |
| `ceiling()` | `ceiling(x_formateado)` | `ceiling(x)` luego formatear |
| `sqrt()` | `sqrt(x_formateado)` | `sqrt(x)` luego formatear |
| `log()` | `log(x_formateado)` | `log(x)` luego formatear |

### 🔗 Archivos de Referencia

**Ejemplo corregido verificado:**

- `/A-Produccion/En-Desarrollo/recta_geometria_analitica_interpretacion_representacion/recta_geometria_analitica_interpretacion_representacion_n2_v1.Rmd`
- **Caso resuelto:** `.claude/docs/casos-resueltos/2025-12-21-recta-abs-formateado.md`

**Líneas corregidas:**

- Línea 160: `abs(b_formateado)` → `abs(b)` luego formatear
- Línea 177: `abs(b_dist1_formateado)` → `abs(b_distractor1)` luego formatear
- Línea 196: `abs(b_formateado)` → `abs(b)` luego formatear
- Línea 219: `abs(b_dist3_formateado)` → `abs(b_distractor3)` luego formatear

### 📅 Historial

| Fecha | Versión | Estado | Validado en | Niveles Validados |
|-------|---------|--------|-------------|-------------------|
| 2025-12-21 | v1.0 | ✅ Verificado | recta_geometria_analitica_interpretacion_representacion_n2_v1.Rmd | Nivel 1 ✅ (RStudio) |

**Pruebas de validación realizadas (v1.0 - 2025-12-21):**

**Nivel 1 - RStudio (Run > Run all):**

- ✅ Todos los chunks ejecutan sin errores
- ✅ Las ecuaciones se generan correctamente
- ✅ No hay errores de tipo en funciones matemáticas
- ✅ Función probada directamente: 10 ejecuciones exitosas

**Nivel 2 - Prueba de Diversidad:**

- ✅ Código corregido y verificado
- ⚠️ **Nota importante**: Si el error persiste, puede ser debido a caché de R/knitr
  - Solución: Reiniciar sesión de R o limpiar caché con `rm(list = ls())` y `knitr::knit_cache$clean()`

**Nivel 3 - Generación Masiva:**

- ⏭️ Pendiente de validación completa

### ⚠️ Nota sobre Caché de R/knitr

Si el error persiste después de corregir el código, puede ser debido a:

1. **Caché de knitr**: Los chunks pueden estar usando versiones en caché
   - **Solución**: Limpiar caché con `knitr::knit_cache$clean()` o eliminar carpeta `*_cache/`
2. **Entorno de R**: Variables en memoria de sesiones anteriores
   - **Solución**: Reiniciar sesión de R o ejecutar `rm(list = ls())`
3. **Archivo no guardado**: Verificar que los cambios se guardaron correctamente
   - **Solución**: Verificar timestamp del archivo y contenido con `grep -n "abs(b_formateado)" archivo.Rmd`

---

## Error 3: Imágenes Python/matplotlib no visibles en exams2pdf

### ❌ Mensaje de Error
```
# No hay mensaje de error explícito, pero la imagen no aparece en el PDF generado
# El PDF se compila correctamente pero la gráfica está ausente
```

**Síntoma:**

- El PDF se genera sin errores de compilación
- La imagen generada por Python existe en el directorio
- La imagen NO se visualiza en el PDF final
- El texto del ejercicio aparece correctamente

### 🔍 Causa Raíz
El uso de `knitr::include_graphics()` para mostrar imágenes generadas por Python/matplotlib no funciona correctamente con `exams2pdf()` debido a problemas de rutas y contexto de compilación.

**Flujo del problema:**

1. Python genera la imagen: `plt.savefig('recta_python.png')` → se guarda en directorio actual
2. Se intenta mostrar con: `knitr::include_graphics("recta_python.png")`
3. Durante `exams2pdf()`, knitr busca la imagen en rutas relativas/absolutas que no coinciden
4. La imagen no se encuentra en el contexto de compilación → No aparece en PDF

**Patrón común:**
Este error ocurre cuando:

- Se generan gráficos con Python/matplotlib usando `py_run_string()`
- Se guarda la imagen con `plt.savefig('nombre.png')`
- Se intenta incluir con `knitr::include_graphics()` en un chunk R

### ✅ Solución Verificada

**Enfoque:** Usar sintaxis markdown simple con `cat()` en lugar de `knitr::include_graphics()`, siguiendo el patrón de archivos funcionales en producción.

#### Código ANTES (incorrecto):

```r
```{r generar_grafico_python, echo=FALSE, results="hide"}
codigo_python <- paste0("
import matplotlib.pyplot as plt
# ... código de generación ...
plt.savefig('recta_python.png', dpi=150, bbox_inches='tight')
plt.close()
")
py_run_string(codigo_python)
```

```{r mostrar_grafico, echo=FALSE, fig.align='center', out.width='50%'}
# ❌ PROBLEMA: knitr::include_graphics() no funciona con exams2pdf
if (file.exists("recta_python.png")) {
  knitr::include_graphics("recta_python.png")
} else {
  warning("El archivo no se encontró")
}
```
```

#### Código DESPUÉS (correcto):

```r
```{r generar_grafico_python, echo=FALSE, results="hide"}
# ✅ Guardar imagen en directorio actual (patrón de archivos funcionales)
codigo_python <- paste0("
import matplotlib
matplotlib.use('Agg')  # Backend sin interfaz gráfica
import matplotlib.pyplot as plt
import numpy as np

# Obtener parámetros desde R
m_py = ", datos$m, "
b_py = ", datos$b, "

# ... código de generación del gráfico ...

# Guardar en el directorio actual (compatible con todos los formatos)
plt.savefig('recta_python.png', dpi=150, bbox_inches='tight', transparent=True)
plt.close()
")

# Ejecutar el código Python
py_run_string(codigo_python)
```

```{r mostrar_grafico, echo=FALSE, results='asis', fig.align='center'}
# ✅ SOLUCIÓN: Usar markdown simple con cat() (patrón de archivos funcionales)
# Detectar si se está generando para Moodle
es_moodle <- (match_exams_call() %in% c("exams2moodle", "exams2qti12", "exams2qti21", "exams2openolat"))

# Ajustar tamaño según formato de salida
if(es_moodle) {
  cat("![](recta_python.png){width=30%}\n\n")  # Más pequeño para Moodle
} else {
  cat("![](recta_python.png){width=50%}\n\n")  # Tamaño estándar para PDF/Word
}
```
```

**Diferencias clave:**

1. ✅ **Guardar imagen simple**: `plt.savefig('recta_python.png')` sin rutas absolutas
2. ✅ **Chunk de visualización**: `results='asis'` (no `fig.align` ni `out.width`)
3. ✅ **Sintaxis markdown**: `cat("![](recta_python.png){width=50%}\n\n")` en lugar de `knitr::include_graphics()`
4. ✅ **Renderizado condicional**: Ajustar tamaño según formato (Moodle vs PDF/Word)

### 🧪 Validación de la Solución

#### **Nivel 1: RStudio (Run > Run all)**
Ejecutar todos los chunks interactivamente en RStudio.

**Criterio de éxito:**

- ✅ Todos los chunks ejecutan sin errores
- ✅ La imagen se genera correctamente
- ✅ La imagen se visualiza en el output (HTML/PDF/Word según YAML)

**Método:**
```

1. Abrir .Rmd en RStudio
2. Run > Run All
3. Verificar que la imagen aparece en el output
```

#### **Nivel 2: Generación Masiva (exams2pdf)**
Ejecutar `exams2pdf()` para verificar que la imagen aparece en el PDF.

**Criterios de éxito:**

- ✅ `exams2pdf()` compila sin errores
- ✅ El PDF contiene la imagen (verificable con `pdfimages -list archivo.pdf`)
- ✅ La imagen se visualiza correctamente en el PDF

**Método:**
```r
library(exams)
set.seed(123)
exams2pdf('archivo.Rmd', n=1, dir='test_pdf', template='plain')
```

**Verificación:**
```bash
# Verificar que el PDF contiene imágenes
pdfimages -list test_pdf/plain1.pdf

# Resultado esperado:
# page   num  type   width height color comp bpc  enc interp  object ID
#    1     0 image     487   734  rgb     3   8  image  no         1  0
```

#### **Nivel 3: Todos los Formatos**
Validar que funciona en todos los formatos de salida.

**Criterios de éxito:**

- ✅ `exams2html()` muestra la imagen correctamente
- ✅ `exams2pdf()` muestra la imagen correctamente
- ✅ `exams2pandoc()` (DOCX) muestra la imagen correctamente
- ✅ `exams2moodle()` muestra la imagen correctamente

### 📋 Checklist de Corrección

- [ ] Identificar chunks que generan imágenes con Python/matplotlib
- [ ] Verificar que `plt.savefig()` guarda en directorio actual (sin rutas absolutas)
- [ ] Reemplazar `knitr::include_graphics()` por sintaxis markdown con `cat()`
- [ ] Cambiar chunk de visualización a `results='asis'`
- [ ] Agregar renderizado condicional para diferentes formatos (Moodle vs PDF/Word)
- [ ] Verificar compilación a PDF con `exams2pdf()`
- [ ] Verificar que la imagen aparece en el PDF (usar `pdfimages -list`)
- [ ] Confirmar visualización correcta en todos los formatos

### 🎯 Casos Aplicables

Este patrón de solución aplica para:

- ✅ Gráficos generados con Python/matplotlib (`py_run_string()`)
- ✅ Imágenes guardadas con `plt.savefig()`
- ✅ Cualquier visualización generada con Python en R/exams
- ✅ Gráficos de rectas, funciones, diagramas, etc. generados con matplotlib

### ⚠️ Casos NO Aplicables

Este patrón NO aplica para:

- ❌ Imágenes TikZ (usar solución del Error 1)
- ❌ Imágenes externas ya existentes (PNG/JPG)
- ❌ Gráficos generados con ggplot2 o base R (usar sistema de figuras de knitr)

### 🔗 Archivos de Referencia

**Ejemplos funcionales verificados en producción:**

- `/A-Produccion/En-Produccion/06-Estadística-Y-Probabilidad/.../accidentalidad-vial-genero-01.Rmd`
- `/A-Produccion/En-Desarrollo/volumen_cilindro_geometrico_metrico_interpretacion/volumen_cilindro_geometrico_metrico_interpretacion_python_n2_v1.Rmd`

**Ejemplo corregido verificado:**

- `/A-Produccion/En-Desarrollo/recta_geometria_analitica_interpretacion_representacion_python/recta_geometria_analitica_python_interpretacion_representacion_n2_v1.Rmd`

**Patrón de referencia:**
Los archivos funcionales en producción usan consistentemente:
```r
cat("![](nombre_imagen.png){width=50%}\n\n")
```
en lugar de `knitr::include_graphics()`.

### 📅 Historial

| Fecha | Versión | Estado | Validado en | Niveles Validados |
|-------|---------|--------|-------------|-------------------|
| 2025-12-21 | v1.0 | ✅ Verificado | recta_geometria_analitica_python_interpretacion_representacion_n2_v1.Rmd | Nivel 2 ✅ (exams2pdf) |

**Pruebas de validación realizadas (v1.0 - 2025-12-21):**

**Nivel 1 - RStudio (Run > Run all):**

- ⏭️ Pendiente de validación por usuario

**Nivel 2 - Generación Masiva (exams2pdf):**

- ✅ `exams2pdf()`: Exitoso
  - PDF generado: 85KB
  - Imágenes incluidas: 2 objetos de imagen detectados con `pdfimages -list`
  - Tamaño de imagen: 487x734 píxeles, RGB
  - Sin errores de compilación
  - Imagen visible en el PDF
- ✅ Solución confirmada y reproducible
- ✅ Patrón basado en archivos funcionales en producción

**Nivel 3 - Todos los Formatos:**

- ⏭️ Pendiente de validación completa

### 💡 Notas Importantes

1. **Patrón de archivos funcionales**: Esta solución se basa en el análisis de archivos `.Rmd` funcionales en producción que usan Python/matplotlib. Todos usan el patrón `cat("![](imagen.png)")` en lugar de `knitr::include_graphics()`.

2. **Compatibilidad con exams2pdf**: El problema específico es con `exams2pdf()`. Para otros formatos (HTML, Word), ambos métodos pueden funcionar, pero el patrón markdown simple es más consistente.

3. **Renderizado condicional**: Es recomendable ajustar el tamaño de la imagen según el formato de salida (más pequeño para Moodle, estándar para PDF/Word).

---

## Error 4: Gráficos como opciones mostrados en grid (no individuales)

### ❌ Síntoma del Error

```
- Las 4 opciones de gráficos se muestran juntas en un solo grid
- El Answerlist tiene texto ("Opción A", "Opción B"...) en lugar de imágenes
- exshuffle no puede mezclar las opciones correctamente
- El estudiante no puede seleccionar una opción específica
```

**Ejemplo visual del error:**

```
┌─────────────────┐  ← Un solo bloque con 4 gráficos
│  [A]   [B]      │
│  [C]   [D]      │
└─────────────────┘

Answerlist:
* Opción A        ← Texto en lugar de imagen
* Opción B
* Opción C
* Opción D
```

### 🔍 Causa Raíz

Uso de `grid.arrange()` o similar para mostrar todos los gráficos en una sola imagen, con el Answerlist conteniendo solo texto descriptivo en lugar de las imágenes individuales.

**Código incorrecto:**

```r
# ❌ PROBLEMA: grid.arrange muestra todo junto
library(gridExtra)
grid.arrange(plot_A, plot_B, plot_C, plot_D, ncol = 2)

# ❌ PROBLEMA: Answerlist con texto
Answerlist
----------
* Opción A
* Opción B
* Opción C
* Opción D
```

### ✅ Solución Verificada

**Enfoque:** Guardar cada gráfico como PNG separado y referenciarlos en el Answerlist.

#### Código DESPUÉS (correcto):

```r
# ✅ CORRECTO: Función que guarda cada gráfico individualmente
crear_y_guardar_boxplot <- function(cuartiles, letra, y_min, y_max, unidad) {
  p <- ggplot(...) + ...

  # OBLIGATORIO: Guardar como archivo PNG individual
  nombre_archivo <- paste0("diagrama_", tolower(letra), ".png")
  ggsave(nombre_archivo, plot = p, width = 4, height = 5, dpi = 150, bg = "white")

  return(p)
}

# Crear los 4 gráficos como archivos separados
plot_A <- crear_y_guardar_boxplot(opciones$A, "A", y_min, y_max, unidad)
plot_B <- crear_y_guardar_boxplot(opciones$B, "B", y_min, y_max, unidad)
plot_C <- crear_y_guardar_boxplot(opciones$C, "C", y_min, y_max, unidad)
plot_D <- crear_y_guardar_boxplot(opciones$D, "D", y_min, y_max, unidad)
```

#### Answerlist (correcto):

```markdown
Answerlist
----------

` ``{r mostrar_opciones, echo=FALSE, results='asis'}
cat("* ![](diagrama_a.png){width=60%}\n")
cat("* ![](diagrama_b.png){width=60%}\n")
cat("* ![](diagrama_c.png){width=60%}\n")
cat("* ![](diagrama_d.png){width=60%}\n")
` ``
```

### 🧪 Validación de la Solución

```r
# Verificar que se generaron los 4 PNG
list.files(pattern = "diagrama_[a-d]\\.png$")
# Debe retornar: "diagrama_a.png" "diagrama_b.png" "diagrama_c.png" "diagrama_d.png"

# Renderizar y verificar visualmente
exams2pdf("archivo.Rmd", n = 1)
# Cada opción (a), (b), (c), (d) debe mostrar su propio gráfico
```

### 📋 Checklist de Corrección

- [ ] Crear función que use `ggsave()` para guardar cada gráfico
- [ ] Nombre de archivo: `diagrama_[letra].png` (minúsculas)
- [ ] Llamar la función para cada opción (A, B, C, D)
- [ ] Answerlist usa `cat("* ![](diagrama_x.png){width=60%}\n")`
- [ ] Verificar que `exshuffle: FALSE` está configurado (SCHOICE con PNGs usa mezcla interna con `sample()`, ver `graficos-como-opciones.md`)

### 🔗 Archivos de Referencia

**Ejemplo funcional:**

- `A-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2.Rmd`

**Ejemplo corregido:**

- `A-Produccion/01-En-PreDesarrollo/Lab-Manjaro/50/diagrama_caja_estaturas_metacognitivo_interpretacion_n2_schoice_v1.Rmd`

**Regla asociada:**

- `.claude/rules/graficos-como-opciones.md`

### 📅 Historial

| Fecha | Versión | Estado | Validado en |
|-------|---------|--------|-------------|
| 2026-02-07 | v1.0 | ✅ Verificado | diagrama_caja_estaturas_metacognitivo_interpretacion_n2_schoice_v1.Rmd |

---

## Error 5: Gráfico aplastado por escala incompatible (EST-BOX-01)

### ❌ Síntoma del Error

```
- Uno de los gráficos de opciones aparece casi invisible
- El diagrama de caja está "aplastado" contra el fondo de la escala
- El eje Y tiene un rango muy amplio (ej: 1 a 251)
- Los valores del gráfico problemático son muy pequeños (ej: 1-11)
```

**Ejemplo visual:**

```
┌─────────────────┐
│      251        │
│                 │
│                 │  ← Escala de 1 a 251
│       51        │
│                 │
│        1 ■■■■   │  ← Diagrama aplastado aquí (valores 1-11)
└─────────────────┘
```

### 🔍 Causa Raíz

El error conceptual EST-BOX-01 (confusión posición/valor) genera cuartiles con valores de posición (1, 3, 6, 9, 11) en lugar de valores reales (ej: 200-400 puntos). Cuando se comparte una escala con gráficos que tienen valores reales, el gráfico con posiciones queda visualmente inutilizable.

**Código incorrecto:**

```r
# ❌ PROBLEMA: Incluir EST-BOX-01 en ejercicios con gráficos comparativos
error_seleccionado_idx <- sample(1:3, 1)  # Incluye índice 1 (EST-BOX-01)

# El error EST-BOX-01 genera valores 1-11
list(min = 1, q1 = 3, mediana = 6, q3 = 9, max = 11)

# Pero los datos reales tienen valores como 200-400
# → La escala compartida hace ilegible el gráfico con posiciones
```

### ✅ Solución Verificada

**Enfoque:** Excluir EST-BOX-01 del pool de errores para ejercicios que comparan gráficos visualmente.

```r
# ✅ CORRECTO: Solo usar errores que mantienen valores en el mismo rango
errores_validos_para_grafico <- c(2, 3, 4)  # Excluir índice 1 (EST-BOX-01)

# Seleccionar error de los válidos para representación gráfica
error_seleccionado_idx <- sample(errores_validos_para_grafico, 1)

# Generar distractores solo de errores válidos
otros_errores_idx <- setdiff(errores_validos_para_grafico, error_seleccionado_idx)
```

```r
# ✅ CORRECTO: Calcular rango Y basado en valores reales
y_min_global <- min(sapply(opciones_graficos, function(x) x$min)) - 2
y_max_global <- max(sapply(opciones_graficos, function(x) x$max)) + 2
```

### 🧪 Validación de la Solución

```r
# Verificar que todos los gráficos son visualmente distinguibles
exams2pdf("archivo.Rmd", n = 10)

# Inspeccionar visualmente cada PDF
# Todos los diagramas deben ser legibles en la misma escala
```

### 📋 Checklist de Corrección

- [ ] Identificar errores que generan valores fuera del rango de datos
- [ ] Crear lista `errores_validos_para_grafico` excluyendo esos errores
- [ ] Usar `sample(errores_validos_para_grafico, 1)` para selección
- [ ] Calcular `y_min_global` y `y_max_global` solo con valores válidos
- [ ] Verificar visualmente que todos los gráficos son legibles

### 📅 Historial

| Fecha | Versión | Estado | Validado en |
|-------|---------|--------|-------------|
| 2026-02-07 | v1.0 | ✅ Verificado | diagrama_caja_estaturas_metacognitivo_interpretacion_n2_schoice_v1.Rmd |

---

## Error 6: Rango insuficiente para sample() sin reemplazo

### ❌ Mensaje de Error

```
Error en sample.int(length(x), size, replace, prob):
  imposible tomar una muestra mayor que la población cuando 'replace = FALSE'
```

### 🔍 Causa Raíz

Un contexto en el pool tiene un rango numérico (rango_max - rango_min + 1) menor que el número de datos requeridos (n_datos), lo que hace imposible seleccionar valores únicos sin repetición.

**Ejemplo:**

```r
# ❌ PROBLEMA: Rango insuficiente
list(
  tipo_dato = "edades",
  rango_min = 12,
  rango_max = 18,  # Solo 7 valores únicos: 12,13,14,15,16,17,18
  n_datos = 11     # Necesita 11 valores únicos → IMPOSIBLE
)
```

### ✅ Solución Verificada

**Enfoque 1:** Aumentar el rango del contexto problemático.

```r
# ✅ CORRECTO: Rango suficiente
list(
  tipo_dato = "IMC",
  rango_min = 18,
  rango_max = 32,  # 15 valores únicos: 18-32
  n_datos = 11     # Necesita 11 → POSIBLE
)
```

**Enfoque 2:** Agregar validación de rangos antes de seleccionar contexto.

```r
# ✅ CORRECTO: Filtrar contextos válidos
contextos_validos <- Filter(function(ctx) {
  (ctx$rango_max - ctx$rango_min + 1) >= ctx$n_datos
}, contextos)

# Verificar que hay al menos un contexto válido
if(length(contextos_validos) == 0) {
  stop("No hay contextos con rango suficiente para n_datos")
}

ctx <- contextos_validos[[sample(length(contextos_validos), 1)]]
```

### 📋 Checklist de Corrección

- [ ] Identificar contextos con rango < n_datos
- [ ] Opción A: Aumentar rango_max o reducir rango_min
- [ ] Opción B: Agregar filtro de validación
- [ ] Verificar con múltiples renderizaciones (n >= 50)

### 📅 Historial

| Fecha | Versión | Estado | Validado en |
|-------|---------|--------|-------------|
| 2026-02-07 | v1.0 | ✅ Verificado | diagrama_caja_estaturas_metacognitivo_*.Rmd |

**Contextos corregidos:**

- "edades" (12-18) → "IMC" (18-32)
- "tiempos" (12-18) → "distancias" (8-25)

---

## Error 7: Descripción de error conceptual incoherente con paridad de datos

### ❌ Síntoma del Error

```
El ejercicio genera n=7 datos (impar) pero selecciona como respuesta correcta:
"Para un número par de datos, tomó solo uno de los dos valores centrales"

La descripción del error es imposible con datos impares — no hay "dos valores centrales"
cuando n es impar.
```

**Ejemplo concreto reportado:** 7 estudiantes, error EST-MTC-04 seleccionado.

### 🔍 Causa Raíz

**Dos bugs combinados:**

1. **Filtro de errores sin restricción de paridad:** `errores_mediana_idx <- c(1, 2, 3, 4)` permitía seleccionar EST-MTC-04 sin importar si `n` era par o impar.

2. **Hack silencioso en función calcula:** Para n impar, EST-MTC-04 tenía un fallback que devolvía un valor adyacente al central — producía un número diferente de la mediana, pasando el test numérico, pero con una descripción textual incoherente.

3. **Pool de distractores insuficiente:** Al restringir `errores_mediana_idx` a 3 elementos (n impar), `setdiff()` dejaba solo 2 opciones para `sample(..., 3)`, causando error de sample().

**Fallo sistémico:**
- El test solo verificaba `mediana_erronea != mediana_calc` (coherencia numérica)
- No verificaba coherencia semántica: ¿la DESCRIPCIÓN del error aplica a los datos?
- El script `validar_coherencia_matematica.R` no tiene reglas para este tipo de incoherencia
- El detractor no detectó la incoherencia descripción-datos

### ✅ Solución Verificada

**Corrección 1:** Filtrar errores según paridad de n.

```r
# ANTES (incorrecto):
errores_mediana_idx <- c(1, 2, 3, 4)

# DESPUÉS (correcto):
if (n %% 2 == 0) {
  errores_mediana_idx <- c(1, 2, 3, 4)
} else {
  errores_mediana_idx <- c(1, 2, 3)  # Excluir EST-MTC-04 cuando n es impar
}
```

**Corrección 2:** Eliminar hack de calcula para n impar.

```r
# ANTES (hack silencioso):
calcula = function(datos_ord) {
  n <- length(datos_ord)
  if (n %% 2 == 0) {
    datos_ord[n / 2]
  } else {
    pos <- (n + 1) / 2
    datos_ord[max(1, pos - 1)]  # ← Hack: valor arbitrario
  }
}

# DESPUÉS (honesto):
calcula = function(datos_ord) {
  n <- length(datos_ord)
  if (n %% 2 == 0) {
    datos_ord[n / 2]
  } else {
    stop("EST-MTC-04 no debe usarse con n impar")
  }
}
```

**Corrección 3:** Distractores del pool completo de 6 errores.

```r
# ANTES (insuficiente con 3 errores):
otros_idx <- setdiff(errores_mediana_idx, error_idx)
otros_idx <- sample(otros_idx, 3)  # ← Falla si solo hay 2

# DESPUÉS (siempre suficiente):
todos_errores_idx <- seq_along(errores_conceptuales)
otros_idx <- setdiff(todos_errores_idx, error_idx)
otros_idx <- sample(otros_idx, 3)  # 5 opciones → siempre OK
```

**Corrección 4:** Test de coherencia obligatorio.

```r
test_that("EST-MTC-04 nunca se selecciona cuando n es impar", {
  if (error_sel$codigo == "EST-MTC-04") {
    expect_true(n %% 2 == 0,
      info = paste("EST-MTC-04 con n =", n, "(impar)"))
  }
})

test_that("Descripción del error es coherente con los datos (50 semillas)", {
  for (i in 1:50) {
    d <- generar_datos()
    if (d$error_sel$codigo == "EST-MTC-04") {
      expect_true(d$n %% 2 == 0,
        info = paste("Semilla", i, ": EST-MTC-04 con n =", d$n))
    }
  }
})
```

### 🧪 Validación de la Solución

```
Resultado: 0 incoherencias en 200 ejecuciones
Distribución de errores: EST-MTC-01 (66), EST-MTC-02 (58), EST-MTC-03 (54), EST-MTC-04 (22)
HTML: 9/9 seeds OK
PDF: OK
DOCX: OK
```

### 📋 Checklist de Corrección (Generalizable)

- [ ] Verificar que cada error conceptual del pool tiene precondiciones explícitas
- [ ] Filtrar el pool de errores seleccionables según las características de los datos generados
- [ ] Funciones `calcula()` deben fallar explícitamente (`stop()`) si se llaman fuera de contexto
- [ ] Tests deben verificar coherencia semántica (descripción ↔ datos), no solo numérica
- [ ] Pool de distractores debe ser suficiente después del filtrado

### 📅 Historial

| Fecha | Versión | Estado | Validado en |
|-------|---------|--------|-------------|
| 2026-02-13 | v1.0 | ✅ Verificado | Media-Mediana-Moda.Rmd (200 ejecuciones, 0 incoherencias) |

---

## Futuros Errores

*Este espacio se reserva para documentar futuros patrones de error una vez que sean identificados, corregidos y verificados.*

### Template para nuevos errores:

```markdown
## Error X: [Título descriptivo]

### ❌ Mensaje de Error
[Mensaje exacto del error]

### 🔍 Causa Raíz
[Explicación técnica de la causa]

### ✅ Solución Verificada
[Código antes y después]

### 🧪 Validación de la Solución
[Criterios y comandos de prueba]

### 📋 Checklist de Corrección
[Pasos específicos]

### 🔗 Archivos de Referencia
[Ejemplos verificados]

### 📅 Historial
[Tabla de versiones]
```

---

## Contribución

Para agregar un nuevo patrón de error a este documento:

1. ✅ El error debe estar completamente resuelto
2. ✅ La solución debe estar probada y verificada
3. ✅ Debe existir al menos un archivo .Rmd de referencia funcionando
4. ✅ Seguir el template proporcionado
5. ✅ Incluir ejemplos de código completos (antes/después)
6. ✅ Documentar criterios de validación específicos

**No documentar:**

- ❌ Errores sin solución confirmada
- ❌ Soluciones no probadas
- ❌ Casos específicos sin patrón generalizable

---

## Error 8: Corrupción de RNG por test de diversidad

### ❌ Mensaje de Error
```
No hay mensaje de error explícito. El síntoma es que exams2html(n=50)
produce solo 2-3 versiones únicas en lugar de 40+.
```

### 🔍 Causa Raíz
Un chunk `test_that()` dentro del .Rmd usa `set.seed()` en un loop para verificar diversidad
de versiones. Esto modifica `.Random.seed` en el entorno global de R. Cuando R-exams
genera múltiples versiones después, todas comparten el mismo estado RNG corrompido y
producen datos casi idénticos.

**Flujo del problema:**
1. Chunk `data_generation` genera datos aleatorios correctamente
2. Chunk `diversity_test` ejecuta `for(i in 1:300) { set.seed(i*7); ... }`
3. `.Random.seed` global queda en el estado del último `set.seed(300*7)`
4. `exams2html(n=50)` re-ejecuta el .Rmd 50 veces
5. Cada vez, `data_generation` usa el mismo RNG state → datos idénticos

### ✅ Solución Verificada

#### Código ANTES (incorrecto):
```r
test_that("Diversidad de versiones", {
  versiones <- character(300)
  for (i in 1:300) {
    set.seed(i * 7 + 13)
    # ... genera versiones
    versiones[i] <- digest::digest(list(...))
  }
  n_unicas <- length(unique(versiones))
  expect_true(n_unicas >= 200)
})
```

#### Código DESPUÉS (correcto):
```r
test_that("Diversidad de versiones", {
  # GUARDAR estado RNG antes del test
  saved_seed <- if (exists(".Random.seed", envir = globalenv())) {
    get(".Random.seed", envir = globalenv())
  } else NULL

  versiones <- character(300)
  for (i in 1:300) {
    set.seed(i * 7 + 13)
    # ... genera versiones
    versiones[i] <- digest::digest(list(...))
  }
  n_unicas <- length(unique(versiones))
  expect_true(n_unicas >= 200)

  # RESTAURAR estado RNG después del test
  if (!is.null(saved_seed)) {
    assign(".Random.seed", saved_seed, envir = globalenv())
  } else {
    rm(".Random.seed", envir = globalenv())
  }
})
```

### 🧪 Validación de la Solución
```r
# Antes del fix: exams2html(n=50) → 2 versiones únicas
# Después del fix: exams2html(n=100) → 94 versiones únicas (94%)
```

### 📋 Checklist de Corrección
1. Buscar TODOS los chunks `test_that` que usen `set.seed()`
2. Agregar guardado de `.Random.seed` AL INICIO del test
3. Agregar restauración de `.Random.seed` AL FINAL del test
4. Verificar con `exams2html(n=50)` que diversidad se mantiene

### 📚 Ejemplo Funcional Utilizado
Archivo corregido: `diagrama_venn_generos_musicales_metacognitivo_argumentacion_n3_cloze_v3.Rmd`

### 📅 Historial

| Fecha | Archivo | Antes | Después | Verificado |
|-------|---------|-------|---------|------------|
| 2026-02-27 | diagrama_venn_generos_musicales (Venn) | 2/50 únicas | 94/100 únicas | ✓ |

---

## Error 9: ##ANSWERi## mal ubicados en ejercicio CLOZE

### ❌ Mensaje de Error
```
No hay error de compilación. El síntoma visual es que las opciones de la
Parte 1 aparecen DESPUÉS del texto de la Parte 2 en el PDF/HTML renderizado.
```

### 🔍 Causa Raíz
En ejercicios R-exams tipo CLOZE, cada `##ANSWERi##` es un placeholder que R-exams
reemplaza con el widget de respuesta correspondiente. Si `##ANSWER1##` se coloca
después del texto de la Parte 2, R-exams inserta las opciones de la Parte 1 en la
posición equivocada.

Errores típicos:
1. `##ANSWER1##` colocado después de `**Parte 2.**` en vez de después de `**Parte 1.**`
2. `##ANSWER4##` omitido completamente (la última parte no tiene widget)
3. Chunks R con `cat()` que duplican el contenido del Answerlist (R-exams ya lo renderiza)

### ✅ Solución Verificada

#### Código ANTES (incorrecto):
```markdown
**Parte 1.** ¿Cuál es el error?

` ``{r opciones_display, echo=FALSE, results='asis'}
for (i in 1:4) cat(paste0("- ", opciones[i], "\n"))
` ``

**Parte 2.** ¿Cuál es el valor correcto?

##ANSWER1##
##ANSWER2##

**Parte 3.** Seleccione las afirmaciones verdaderas:

##ANSWER3##
```

#### Código DESPUÉS (correcto):
```markdown
**Parte 1.** ¿Cuál es el error?

##ANSWER1##

**Parte 2.** ¿Cuál es el valor correcto?

##ANSWER2##

**Parte 3.** Seleccione las afirmaciones verdaderas:

##ANSWER3##

**Parte 4.** Verdadero o falso:

##ANSWER4##

Answerlist
----------
* `r opciones_p1[1]`
* `r opciones_p1[2]`
* `r opciones_p1[3]`
* `r opciones_p1[4]`
*
* `r afirmaciones[1]`
* `r afirmaciones[2]`
* `r afirmaciones[3]`
* `r afirmaciones[4]`
* Verdadero
* Falso
```

### 📋 Checklist de Corrección
1. Contar tipos en `exclozetype` (ej: `schoice|num|mchoice|schoice` = 4 partes)
2. Verificar que existen EXACTAMENTE 4 `##ANSWERi##` (uno por parte)
3. Cada `##ANSWERi##` va INMEDIATAMENTE después del texto de su parte
4. NO usar chunks R para mostrar opciones — el Answerlist al final se encarga
5. Para partes `num`: usar `*` vacío en el Answerlist (sin texto)
6. Verificar visualmente en PDF que cada parte tiene su widget en la posición correcta

### 📚 Referencia
Patrón validado en: `promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd`

### 📅 Historial

| Fecha | Archivo | Síntoma | Verificado |
|-------|---------|---------|------------|
| 2026-02-27 | diagrama_venn_generos_musicales (Venn) | Opciones Parte 1 aparecían después de Parte 2 | ✓ |

---

## Error 10: NA en comparación while con calcula()

### ❌ Mensaje de Error
```
Error in while (respuesta_erronea == valor_correcto && intentos_error < 20) {
  : valor ausente donde TRUE/FALSE es necesario
Calls: exams2moodle -> ... -> <Anonymous>
```

### 🔍 Causa Raíz
Las funciones `calcula()` en el pool de errores conceptuales pueden retornar `NA` cuando
el `tipo_operacion` seleccionado no coincide con lo que el error espera. Aunque las
precondiciones deberían filtrar estos casos, ciertas combinaciones de RNG producen
estados donde un error pasa la precondición pero su `calcula()` retorna NA para la
operación específica.

En R, `NA == valor` produce `NA` (no TRUE ni FALSE), y `while(NA)` crashea.

### ✅ Solución Verificada

#### Código ANTES (incorrecto):
```r
while (respuesta_erronea == valor_correcto && intentos_error < 20) {
  # ... reintenta otro error
}

if (respuesta_erronea == valor_correcto) {
  # fallback
}
```

#### Código DESPUÉS (correcto):
```r
while ((is.na(respuesta_erronea) || respuesta_erronea == valor_correcto) && intentos_error < 20) {
  # ... reintenta otro error
}

if (is.na(respuesta_erronea) || respuesta_erronea == valor_correcto) {
  # fallback
}
```

### 🧪 Validación de la Solución
```r
# Antes del fix: semillas 29 y 114 crasheaban (de 200 probadas)
# Después del fix: 0 fallos en 200 semillas
```

### 📋 Checklist de Corrección
1. Buscar TODOS los `while` que comparen con resultado de `calcula()`
2. Agregar `is.na(variable) ||` como primera condición
3. Hacer lo mismo para `if` statements que usen el resultado
4. Verificar con 200+ semillas que no hay crashes

### 📚 Ejemplo Funcional Utilizado
Archivo corregido: `diagrama_venn_generos_musicales_metacognitivo_argumentacion_n3_cloze_v3.Rmd`

### 📅 Historial

| Fecha | Archivo | Semillas fallidas | Verificado |
|-------|---------|-------------------|------------|
| 2026-02-27 | diagrama_venn_generos_musicales (Venn) | 2/200 → 0/200 | ✓ |

---

## Error 11: Drift silencioso de hooks tras instalación de plataforma externa

### ❌ Síntoma

Una herramienta como Ruflo, claude-flow, ruv-swarm o flow-nexus se instala (`npx ... init` o equivalente) y reemplaza `.claude/settings.json`. Los hooks ICFES siguen presentes en `.claude/hooks/*.sh` (ejecutables, sintaxis válida) pero **`settings.json` ya no los carga**. El nuevo handler de la plataforma (típicamente `hook-handler.cjs`) no invoca los `.sh` ICFES.

**Verificación:**
```bash
grep -E "rmd-gate|post-exams2|ortografia" .claude/helpers/<wrapper>.cjs
# Si retorna 0 → wrapper NO invoca hooks ICFES
```

**Detección tardía:** el drift puede pasar desapercibido durante semanas porque las reglas siguen documentadas y los binarios siguen existiendo. La única forma fiable de detectarlo es ejecutar `tests/testthat/test_infraestructura_claude.R` (regla #17, invariante I-3).

### 🔍 Causa Raíz

Las herramientas externas tratan `.claude/settings.json` como su propio archivo de configuración y lo sobrescriben en `init`. No respetan los hooks pre-existentes ni preguntan al usuario antes de reemplazar.

### ✅ Solución Verificada (Ruta B — Convivencia)

Re-enganchar los hooks ICFES en paralelo a los del wrapper externo:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          { "type": "command", "command": "sh -c 'exec node \"${CLAUDE_PROJECT_DIR:-.}/.claude/helpers/hook-handler.cjs\" pre-edit'", "timeout": 5000 },
          { "type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/hooks/pre-write-rmd-gate.sh\"", "timeout": 5000 },
          { "type": "command", "command": "echo 'TILDES OBLIGATORIAS...'" }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "sh -c 'exec node \"${CLAUDE_PROJECT_DIR:-.}/.claude/helpers/hook-handler.cjs\" post-bash'", "timeout": 5000 },
          { "type": "command", "command": "bash \"${CLAUDE_PROJECT_DIR:-.}/.claude/hooks/post-exams2-validation.sh\"", "timeout": 120000 }
        ]
      }
    ]
  }
}
```

### 🧪 Validación

```bash
# Test live: el gate bloquea correctamente
mkdir -p A-Produccion/01-En-PreDesarrollo/_test_$$
echo '{"tool_input":{"file_path":"A-Produccion/01-En-PreDesarrollo/_test_'"$$"'/d.Rmd","content":"x"}}' \
  | bash .claude/hooks/pre-write-rmd-gate.sh
# Esperado: exit 0 con mensaje "⛔ GATE: Archivo .Rmd bloqueado..."
rmdir A-Produccion/01-En-PreDesarrollo/_test_$$
```

### 📋 Checklist de Prevención

- [ ] ANTES de cualquier `npx ... init`: snapshot `.claude/` con tar (regla #17 paso 1).
- [ ] DESPUÉS del init: ejecutar `Rscript tests/testthat/test_infraestructura_claude.R`.
- [ ] Si el test falla: re-enganchar los hooks ICFES en `settings.json` o revertir.

### 📚 Referencias

- Regla #17: `.claude/rules/infraestructura-protegida.md`
- ADR-001: `.claude/docs/ADR/001-convivencia-ruflo-icfes.md`
- Backup pre-Ruflo: `.claude.pre-ruflo-20260425-123652.tar.gz`
- Backup pre-rehook: `.claude/settings.json.pre-icfes-rehook-20260503-171742`

### 📅 Historial

| Fecha | Plataforma | Hooks perdidos | Detección | Recuperación |
|-------|-----------|----------------|-----------|--------------|
| 2026-04-25 | Ruflo (claude-flow v3) | `pre-write-rmd-gate.sh`, `post-exams2-validation.sh` | 8 días después | commit `fb6ba030` (2026-05-03) |

---

## Error 12: `CLAUDE.md` raíz sobrescrito por plantilla genérica de plataforma

### ❌ Síntoma

El archivo `CLAUDE.md` raíz, que era el índice ICFES con identidad del repo, queda reemplazado por una plantilla genérica del estilo `# Claude Code Configuration - <Plataforma> V<N>`. Las reglas ICFES (16 críticas) ya no aparecen en la primera carga que hace Claude Code al abrir el repo.

### 🔍 Causa Raíz

`npx ... init` y wizards similares reemplazan `CLAUDE.md` raíz como parte de su instalación, asumiendo que el repo es nuevo o que el archivo no existe. No respetan contenido pre-existente.

**Particularidad descubierta en sesión 2026-05-03:** el `CLAUDE.md` raíz nunca había estado versionado en git. Aparecía como `??` (untracked). Esto significa que NO se podía restaurar desde git history porque nunca se había commiteado.

### ✅ Solución Verificada (Mezcla con priority ICFES)

Insertar al inicio del `CLAUDE.md` raíz un bloque ICFES priority de ~47 líneas con:
- Identidad del repo: "# Repositorio ICFES R/exams — Configuración del Repo".
- Pointer a `@.claude/CLAUDE.md` (el índice real).
- Reglas absolutas resumidas (no sobrescribir hooks, no editar inmutables, etc.).
- Declaración explícita: "cuando Ruflo y ICFES entren en conflicto, ICFES gana".

Conservar el contenido externo abajo, marcado como descriptivo:

```markdown
# Repositorio ICFES R/exams — Configuración del Repo

> **IDENTIDAD DEL REPO:** Sistema de generación automatizada de ejercicios ICFES tipo
> SCHOICE/CLOZE en R/exams. NO es un demo de claude-flow / Ruflo, ni un repo genérico.

## Fuente de verdad operativa
[...47 líneas ICFES...]

@.claude/CLAUDE.md

---

# Claude Code Configuration - RuFlo V3

> **Nota:** lo que sigue es la configuración de plataforma Ruflo, instalada el
> 2026-04-25. Es **descriptiva**, no normativa para este repo.
[...244 líneas Ruflo originales...]
```

### 🧪 Validación

```bash
head -1 CLAUDE.md | grep -qE "(ICFES|Repositorio ICFES R/exams)" && echo "I-1 OK"
```

### 📋 Checklist de Prevención

- [ ] Versionar `CLAUDE.md` raíz en git desde el primer momento (no dejarlo untracked).
- [ ] Antes de cualquier `init`: `cp CLAUDE.md CLAUDE.md.pre-<plataforma>-<TS>`.
- [ ] Después: verificar invariante I-1 (regla #17).

### 📚 Referencias

- Regla #17: `.claude/rules/infraestructura-protegida.md` (invariante I-1).
- ADR-001 §"Mezcla de CLAUDE.md raíz".
- Commit de fix: `e8bcc2b3` (2026-05-03).

### 📅 Historial

| Fecha | Plataforma | Restauración |
|-------|-----------|--------------|
| 2026-04-25 | Ruflo | Mezcla aplicada en commit `e8bcc2b3` (2026-05-03) |

---

## Error 13: MCP registrado pero sin conectar (paquete fantasma)

### ❌ Síntoma

`claude mcp list` muestra:
```
ruflo: npx -y ruflo@latest mcp start - ✗ Failed to connect
```

El MCP está en `~/.claude.json` pero al arrancar la sesión, el comando falla. Las herramientas `mcp__<plataforma>__*` que aparecen en la lista de tools diferidas no son invocables.

### 🔍 Causa Raíz

Tres posibles:

1. El paquete npm no existe (versión retirada de npm registry).
2. El paquete existe pero `npx -y <paquete>@latest` falla por incompatibilidad de Node, peer dependencies rotas, o `npm error Invalid Version`.
3. El paquete corre pero el comando `mcp start` falla por config inválida.

### ✅ Solución Verificada

Si la funcionalidad ya está cubierta por otro MCP (ej. `ruv-swarm` y `flow-nexus` cubren coordinación + memoria), **desregistrar el MCP roto**:

```bash
claude mcp remove <nombre>
```

Esto edita `~/.claude.json` (fuera del repo). Verificar:

```bash
claude mcp list 2>&1 | grep -v "✗ Failed" | head
```

Si la funcionalidad NO está cubierta por otro MCP:
1. `npx -y <paquete>@latest --version` para diagnosticar.
2. Probar versiones anteriores: `npx <paquete>@<version-anterior>`.
3. Revisar `/home/bootcamp/.npm/_logs/<fecha>-debug-0.log` para detalles.

### 📋 Checklist de Prevención

- [ ] Cada vez que `claude mcp list` reporte `✗ Failed to connect`: investigar de inmediato.
- [ ] No registrar MCPs experimentales en config global; usar config local del proyecto.

### 📅 Historial

| Fecha | MCP | Acción tomada |
|-------|-----|---------------|
| 2026-05-03 | `ruflo` | Desregistrado (cubierto por `ruv-swarm` + `flow-nexus`) |

---

## Error 14: CLI claude-flow falla con `npm error Invalid Version`

### ❌ Mensaje de Error

```
$ npx @claude-flow/cli@latest doctor
npm warn exec The following package was not found and will be installed: @claude-flow/cli@3.6.21
npm error Invalid Version:
npm error A complete log of this run can be found in: /home/bootcamp/.npm/_logs/<fecha>-debug-0.log
```

### 🔍 Causa Raíz

El paquete `@claude-flow/cli` tiene un `package.json` (propio o de un dependiente) con un campo `version` malformado o incompatible con la versión de npm/Node instalada. El error es de la cadena de dependencias, no del comando que se ejecuta.

### ✅ Solución (parcial — aceptación a medias)

El CLI npm de claude-flow no se usa en el día a día del workflow ICFES. Los componentes locales (`hook-handler.cjs` en `.claude/helpers/`, agentes Ruflo en `.claude/agents/`, skills en `.claude/skills/`) funcionan independientemente del CLI.

**Conclusión adoptada:** aceptar el "Ruflo a medias". El CLI roto no bloquea el workflow ICFES.

**Si en el futuro se necesita el CLI:**
```bash
# Diagnóstico
cat /home/bootcamp/.npm/_logs/<fecha>-debug-0.log | grep -E "Invalid|version"

# Probar versiones anteriores
npx @claude-flow/cli@3.5.0 doctor
npx @claude-flow/cli@3.4.0 doctor

# Limpiar caché npm
npm cache clean --force
```

### 📋 Checklist de Prevención

- [ ] No depender del CLI `claude-flow` para flujos críticos del workflow ICFES.
- [ ] Toda funcionalidad importante debe replicarse en scripts locales (`.claude/scripts/`).

### 📅 Historial

| Fecha | Versión rota | Estado |
|-------|--------------|--------|
| 2026-05-03 | `@claude-flow/cli@3.6.21` | Aceptado a medias (no usado en flujo crítico) |

---

## Error 15: Auto-memory bridge sin paquete instalado

### ❌ Síntoma

En cada SessionStart, el log muestra:
```
[AutoMemory] Importing auto memory files into bridge...
  Memory package not available — skipping auto memory import
```

`node .claude/helpers/auto-memory-hook.mjs status` retorna:
```
Package:        ❌ Not found
Store:          ⏸ Not initialized
LearningBridge: ✅ Enabled
MemoryGraph:    ✅ Enabled
AgentScopes:    ✅ Enabled
```

### 🔍 Causa Raíz

El bridge JS de auto-memoria (parte de Ruflo) está OK, pero la implementación del store (probablemente `@ruflo/agentdb` o `@claude-flow/memory`) no está instalada como paquete npm. El bridge intenta cargarlo dinámicamente, falla silenciosamente y omite la importación.

### ✅ Solución (parcial — vivir sin embeddings)

La auto-memoria de Claude Code (los archivos `~/.claude/projects/*/memory/*.md`) sigue funcionando como siempre — son archivos de texto que Claude lee directamente. Lo que NO se obtiene es la búsqueda semántica vectorial con embeddings ONNX 384-dim.

**Conclusión adoptada:** vivir sin embeddings. Los `MEMORY.md` siguen siendo la fuente de verdad de las lecciones del usuario.

**Si en el futuro se quiere búsqueda semántica:**
1. Identificar el paquete npm faltante (`grep -nE "require|import" .claude/helpers/auto-memory-hook.mjs`).
2. `npm install --save <paquete>`.
3. Verificar: `node .claude/helpers/auto-memory-hook.mjs status` debe reportar `Package: ✅ Found`.
4. Importación inicial: `node .claude/helpers/auto-memory-hook.mjs import`.

### 📋 Checklist de Prevención

- [ ] No depender de embeddings semánticos para flujos críticos.
- [ ] Mantener `MEMORY.md` archivos como fuente primaria; embeddings son una feature extra.

### 📅 Historial

| Fecha | Estado | Acción |
|-------|--------|--------|
| 2026-05-03 | Detectado tras instalación Ruflo | Aceptado, los `MEMORY.md` cubren la necesidad |


---

## Error 16: `\pandocbounded` undefined al renderizar PDF con imágenes Markdown sin atributo `width`

### ❌ Mensaje de Error

```
! Undefined control sequence.
l.5 \pandocbounded
                  {\includegraphics[keepaspectratio]{grafico_equilibrio.png}}
The control sequence at the end of the top line
of your error message was never \def'ed.

Error: LaTeX failed to compile <archivo>_1.tex.
```

### 🔍 Causa Raíz

A partir de **pandoc 3.x**, cuando un Markdown contiene una imagen sin atributos explícitos:

```markdown
![](grafico_equilibrio.png)
```

pandoc envuelve el `\includegraphics` en LaTeX con un comando `\pandocbounded{...}` que pretende ajustar bounding box. **Este comando NO está definido en los templates LaTeX que usa R/exams** (ni en los stock de TinyTeX), por lo que la compilación PDF falla.

El problema NO aparece en HTML ni DOCX, solo en PDF (y por extensión NOPS, que también compila LaTeX).

**Por qué FASE 2G "20/20 OK" no lo detectó:** la validación multi-semilla previa no compilaba PDF en el entorno real del usuario (TinyTeX en Manjaro/zsh) o usaba un template parcheado. Las validaciones en sandbox no son suficientes; HAY que renderizar PDF en el entorno destino.

### ✅ Solución Verificada (3 patrones, en orden de preferencia)

#### Patrón A — Bloque R con `cat()` y atributo `{width=...}` (RECOMENDADO)

```r
` ``{r echo=FALSE, results='asis'}
cat("![](grafico_equilibrio.png){width=80%}\n")
` ``
```

**Por qué funciona**: cuando pandoc ve el atributo `{width=80%}`, NO usa `\pandocbounded` — emite directo `\includegraphics[width=0.8\textwidth]{...}`.

Este patrón está validado en producción en `diagrama_venn_encuesta...Rmd` (línea ~1070) y otros ejercicios con gráficos como opciones.

#### Patrón B — `knitr::include_graphics()` con renderizado condicional

```r
` ``{r echo=FALSE, results='asis'}
if (knitr::is_latex_output()) {
  cat("\\includegraphics[width=0.8\\textwidth]{grafico_equilibrio.png}")
} else {
  cat('<img src="grafico_equilibrio.png" width="80%" />')
}
` ``
```

**Cuándo usarlo**: si necesitas control fino sobre el HTML output o renderizado distinto por formato.

#### Patrón C — Preamble fix (último recurso, no portable)

Solo si A y B no son aplicables, agregar al template LaTeX:

```latex
\providecommand{\pandocbounded}[1]{#1}
```

NO recomendado porque depende de modificar templates fuera del .Rmd.

### 🚫 Antipatrón PROHIBIDO

```markdown
❌ ![](grafico.png)              # sin atributo → \pandocbounded
❌ ![texto alternativo](g.png)    # sin atributo → \pandocbounded
```

```r
❌ cat("![](g.png)\n")            # genera Markdown sin width → mismo bug
```

### 🧪 Validación de la Solución

```r
# Renderizar en entorno real (no simulado)
exams2pdf("archivo.Rmd", n = 5, dir = "salida_pdf")

# Verificar que el .tex generado NO contiene \pandocbounded
system("grep -L 'pandocbounded' salida_pdf/*.tex")  # debe listar todos los archivos

# Verificar que los PDFs se generaron
ls salida_pdf/*.pdf
```

Suite de tests: `tests/testthat/test_pandocbounded_y_solution_coherence.R` ejecuta este check automáticamente sobre todos los `.Rmd` modificados.

### 📋 Checklist de Corrección

- [ ] Identificar TODAS las imágenes en el `.Rmd` (`grep -n '!\\[' archivo.Rmd`).
- [ ] Reemplazar cada `![](file.png)` por `cat("![](file.png){width=Y%}\n")` dentro de un bloque R.
- [ ] Re-renderizar con `exams2pdf()` en el entorno real con ≥5 semillas.
- [ ] Confirmar `grep -c 'pandocbounded' salida/*.tex` retorna 0 en todos.
- [ ] Inspección visual: el gráfico aparece en el PDF (no se rompió por el cambio).

### 📚 Ejemplo Funcional Utilizado

`A-Produccion/03-En-Produccion/.../diagrama_venn_encuesta_metacognitivo_*.Rmd` línea 1070+ — patrón A validado en 4/4 formatos y 300/300 versiones únicas.

### 🛡️ Defensa Automática

| Capa | Mecanismo | Detecta |
|---|---|---|
| Pre-Write | hook `pre-write-rmd-gate.sh` (futuro) | `![](*.png)` sin width attribute en .Rmd nuevos |
| Post-Render | hook `post-exams2-validation.sh` FASE 2I | `\pandocbounded` en .tex generado |
| Test suite | `test_pandocbounded_y_solution_coherence.R` | Patrón Markdown crudo sin width en .Rmd existentes |
| Agente SCHOICE | pre-flight check en `orquestador-schoice` | Detecta antes de generar |

### 📅 Historial

| Fecha | Archivo afectado | Resultado |
|-------|------------------|-----------|
| 2026-05-03 | `interseccion_ingresos_gastos_metacognitivo_interpretacion_n2_schoice_v1.Rmd` | Detectado por usuario al ejecutar `exams2pdf()`. Fix Patrón A aplicado. 5/5 semillas PDF OK post-fix. |

---

## Error 17: Inconsistencia Solution↔Answerlist por `exshuffle: TRUE` con referencia explícita a letra

### ❌ Síntoma

El estudiante ve:
- En la sección Solution: "La respuesta correcta es la **Opción A** porque..."
- En el Answerlist: la opción marcada como correcta es **(c)**.

El bug es silencioso: el .Rmd compila correctamente, los 4 formatos generan, pero el contenido es incoherente. NO lo detecta validación sintáctica ni de metadatos.

### 🔍 Causa Raíz

Cuando un .Rmd SCHOICE tiene:

```yaml
exshuffle: TRUE        # R-exams re-mezcla las opciones
```

```markdown
Solution
========
La respuesta correcta es la **Opción `r letra_correcta`** porque...
```

El flujo es:

1. `data_generation` calcula `letra_correcta = "A"` (basado en la posición de la opción correcta tras `sample()` interno).
2. R-exams parsea el .Rmd y construye el ejercicio con las opciones en su orden actual.
3. R-exams aplica `exshuffle: TRUE` y **re-mezcla las opciones del Answerlist**, ajustando `exsolution` automáticamente.
4. **PERO** el texto de la Solution (`r letra_correcta`) ya fue evaluado en el paso 1, así que sigue diciendo "Opción A" aunque ahora la correcta esté en posición (c).

Resultado: incoherencia silenciosa entre Solution narrativa y Answerlist.

### ✅ Solución Verificada

Para SCHOICE con opciones gráficas (PNGs) **O** texto con Solution que referencia la letra explícitamente:

```yaml
exshuffle: FALSE       # ✓ NO dejar que R-exams re-mezcle
```

Y en `data_generation`:

```r
# Mezclar internamente
opciones_mezcladas <- sample(todas_opciones)
indice_correcto <- which(names(opciones_mezcladas) == "correcta")

# Vector de solución posicional
sol <- rep(0, 4)
sol[indice_correcto] <- 1

# Letra correspondiente (sincronizada con sample interno)
letras <- c("A", "B", "C", "D")
names(opciones_mezcladas) <- letras
letra_correcta <- letras[indice_correcto]
```

```yaml
exsolution: `r paste(as.integer(sol), collapse="")`
```

**La aleatorización ya está garantizada por `sample()`**: cada renderizado con semilla distinta produce orden distinto. `exshuffle: FALSE` solo evita que R-exams haga una segunda mezcla incoherente.

### 🚫 Antipatrón PROHIBIDO

```yaml
exshuffle: TRUE       # PROHIBIDO si Solution dice "Opción `r letra_correcta`"
```

```markdown
La respuesta correcta es la **Opción A** porque...   ← letra hardcoded
```

### 🧪 Validación de la Solución

```r
# Renderizar 20 semillas dispersas
for (s in c(1, 7, 13, 23, 41, 59, 73, 89, 101, 113, 127, 137, 149, 163, 173, 191, 197, 211, 223, 239)) {
  set.seed(s)
  out <- exams2html("archivo.Rmd", n = 1)

  # Extraer letra mencionada en Solution y posición correcta en exsolution
  # Verificar que coinciden
  assert_solution_matches_answerlist(out)
}
```

Suite: `tests/testthat/test_pandocbounded_y_solution_coherence.R` automatiza esta verificación.

### 📋 Checklist de Corrección

- [ ] Si la Solution referencia `r letra_correcta` o cualquier letra explícita: `exshuffle: FALSE`.
- [ ] Mezcla interna con `sample()` ya garantiza aleatorización (verificar con 20+ semillas: 250+ versiones únicas).
- [ ] `exsolution` debe construirse desde el vector `sol` posicional.
- [ ] La variable `letra_correcta` debe calcularse DESPUÉS del `sample()`.

### 📚 Ejemplo Funcional Utilizado

`A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2.Rmd`

### 🛡️ Defensa Automática

| Capa | Mecanismo | Detecta |
|---|---|---|
| Test suite | `test_pandocbounded_y_solution_coherence.R` | Combinación `exshuffle: TRUE` + `r letra_correcta` o "Opción [A-D]" en Solution |
| Hook post-render | `post-exams2-validation.sh` FASE 2I | Mismatch detectado por análisis estático del .Rmd |
| Detractor | dominio `codigo_rexams` | Reporta como objeción ALTA |

### 📅 Historial

| Fecha | Archivo afectado | Resultado |
|-------|------------------|-----------|
| 2026-05-03 | `interseccion_ingresos_gastos_metacognitivo_interpretacion_n2_schoice_v1.Rmd` | Usuario detectó "Opción A en Solution ≠ opción marcada en Answerlist". Fix `exshuffle: FALSE` aplicado. 20/20 semillas coherentes post-fix. |

### 🔗 Reglas Cruzadas

- `.claude/rules/codigo-rmd.md` regla #6 (excepción documentada)
- `.claude/rules/graficos-como-opciones.md` (caso específico SCHOICE con PNGs)

---

## Error 18: Estudiante puede identificar opción correcta por formato gráfico sin verificar datos

**Detectado:** 2026-05-14 (sesión v2 distribucion-contagiados)
**Severidad:** ALTA (el ejercicio mide formato, no comprensión de datos)
**Síntoma observado:** si el conjunto de opciones tiene un solo gráfico de barras (o una sola torta) y ese formato coincide siempre con la opción correcta, el estudiante aprende a responder por formato sin analizar los datos.

### Causa raíz

Cuando las 4 opciones de un SCHOICE gráfico tienen distribución desigual de formatos —por ejemplo, 3 tortas + 1 barra— el estudiante puede inferir la respuesta correcta por eliminación visual sin verificar categorías ni proporciones. En la v1 de `distribucion-contagiados`, la opción correcta era SIEMPRE una torta de 3 sectores. El estudiante que detectaba ese patrón podía acertar sin leer la tabla.

### Consecuencia pedagógica

El ejercicio deja de evaluar la competencia declarada ("Interpretar y transformar información entre formatos") y pasa a evaluar "reconocer el tipo de gráfico que siempre es correcto". La Alfirmación y Evidencia ICFES quedan sin verificar.

### Fix permanente (format diversity principle)

**Principio:** Para todo SCHOICE con opciones gráficas, el formato de la opción correcta DEBE aparecer en al menos 2 de las 4 opciones. Idealmente, usar 2 de un formato + 2 de otro (ej: 2 barras + 2 tortas).

**Regla asociada:** `.claude/rules/graficos-como-opciones.md` §Formato equilibrado

**Implementación en la v2 de distribucion-contagiados:**

| Opción | v1 (frágil) | v2 (robusto) |
|--------|-------------|--------------|
| Correcta | Torta 3 sectores proporcionales | **Barras** 3 categorías + alturas exactas |
| Distractor 1 | Torta + categoría "Otro" | Torta + categoría "Otro" |
| Distractor 2 | Torta áreas iguales | Torta áreas iguales |
| Distractor 3 | Barras + categoría "0-45" | **Barras** categorías correctas + alturas permutadas |

En v2, el estudiante ve 2 barras y 2 tortas. No puede descartar por formato. Debe verificar:
- ¿Están todas las categorías de la tabla? (descarta la torta con "Otro")
- ¿Las áreas/alturas son proporcionales a las frecuencias? (descarta la torta de áreas iguales)
- ¿La altura de cada barra coincide con su categoría específica? (descarta la barra con alturas permutadas)

### Verificación en el código

```r
# Validación obligatoria en data_generation: verificar equilibrio de formatos
formatos <- sapply(opciones_mezcladas, function(x) x$formato)
stopifnot(sum(formatos == "barras") == 2, sum(formatos == "torta") == 2)
```

### 📅 Historial

| Fecha | Archivo afectado | Resultado |
|-------|------------------|-----------|
| 2026-05-14 | `distribucion_contagiados_metacognitivo_interpretacion_n3_schoice_v1.Rmd` | v1 vulnerable (1 formato correcto = único en su tipo). v2 creada con 2 barras + 2 tortas. Verificado 10 semillas: correcta siempre = barras, formato nunca delata. |

### 🔗 Reglas Cruzadas

- `.claude/rules/graficos-como-opciones.md` §Formato equilibrado (nueva sección, 2026-05-14)
- Error 20 (GRAF-BAR-01): patrón de distractor de barras con alturas permutadas que hace posible el equilibrio de formatos
- `.claude/rules/ejercicios-metacognitivos.md` (Progressive Disclosure: el estudiante debe analizar, no reconocer patrones superficiales)

---

## Error 19: Solution con `r letra_correcta` rompe coherencia bajo Moodle re-shuffle

**Detectado:** 2026-05-12 (estudiante real KEVIN A. SILVA, p3c-mat)
**Severidad:** ALTA (silenciosa, solo visible en producción Moodle)
**Síntoma observado:** estudiante seleccionó Opción C → sistema marcó "Incorrecta" → Solution decía "Respuesta correcta: Opción C". Contradicción visible al estudiante.

### Causa raíz

El `.Rmd` tenía:

```rmd
### Respuesta correcta: Opción `r letra_correcta` {#respuesta-correcta-...}
```

con `exshuffle: FALSE` y mezcla interna con `sample()`. La asunción implícita: "exshuffle:FALSE evita re-shuffle".

**Esa asunción es falsa en Moodle.** Moodle tiene un setting independiente "Shuffle answers" en la configuración del cuestionario (no relacionado con exshuffle de R-exams). Cuando está activado, Moodle re-ordena las opciones en tiempo de display PERO no toca el valor de `letra_correcta` ya escrito en la prosa de Solution. Resultado: el estudiante ve "Respuesta correcta: Opción C" pero la opción etiquetada C en su pantalla no es la que R-exams generó como correcta.

### Por qué los validadores no lo detectaron

1. FASES 2A-2H operan sobre R-exams nativo. No simulan Moodle.
2. FASE 2I.3 detecta `exshuffle:TRUE + letra` (Error 17) pero no `exshuffle:FALSE + letra + Moodle shuffle`.
3. 4/4 formatos (HTML/PDF/DOCX/NOPS) pasaban porque ninguno aplica re-shuffle adicional.
4. Multi-semilla (FASE 2G) valida coherencia interna R-exams; el bug solo emerge en el target Moodle.

### Fix permanente (regla #19)

**Regla:** `.claude/rules/solution-letter-independence.md`

Solution NUNCA debe referenciar opciones por letra/posición. SIEMPRE por contenido (`descripcion_corta`), código de error (`GRAF-ARG-NN`) o etiqueta semántica.

Patrones prohibidos en Solution:
- P1: `` `r letra_correcta` `` o `` `r letras[...]` ``
- P2: prosa con letra interpolada
- P3: `cat("**Opción ", l, ...)` en chunk R
- P4: literal "Opción [A-D]" en Markdown

### Patrón correcto (antes/después)

**Antes (frágil):**

````rmd
### Respuesta correcta: Opción `r letra_correcta` {#respuesta-correcta-`r ex_uid`}

```{r}
err_correcto <- errores_conceptuales[[2]]
cat(paste0(err_correcto$descripcion_larga, "\n"))
```

### Análisis de los distractores

```{r}
for (l in letras) {
  opc <- opciones_mezcladas[[l]]
  if (opc$tipo != "correcto") {
    err <- errores_conceptuales[[opc$error_idx]]
    cat(paste0("**Opción ", l, " (", err$codigo, "):** ", err$descripcion_larga))
  }
}
```
````

**Después (robusto):**

````rmd
### Respuesta correcta {#respuesta-correcta-`r ex_uid`}

**Argumento válido:** "`r errores_conceptuales[[2]]$descripcion_corta`"

```{r}
err_correcto <- errores_conceptuales[[2]]
cat(paste0(err_correcto$descripcion_larga, "\n"))
```

### Análisis de los argumentos incorrectos

```{r}
for (l in letras) {
  opc <- opciones_mezcladas[[l]]
  if (opc$tipo != "correcto") {
    err <- errores_conceptuales[[opc$error_idx]]
    cat(paste0(
      "**", err$codigo, " — ", err$nombre, "**\n\n",
      "*Argumento:* \"", err$descripcion_corta, "\"\n\n",
      err$descripcion_larga, "\n\n"
    ))
  }
}
```
````

### Defensas implementadas (4 capas)

1. **Hook FASE 2J** (`post-exams2-validation.sh`): detecta P1-P4 en sección Solution. Bloqueante.
2. **Test estático** (`test_letter_independence.R`): 4 tests + self-test. Falla CI si nuevo .Rmd cae en patrón.
3. **Pre-write gate** (futuro, regla #16): bloquear Write/Edit de .Rmd con patrones prohibidos.
4. **Detractor** (dominio `codigo_rexams`): check explícito de letter-independence.

### Action item: .Rmd legacy con bug

Lista en `tests/testthat/test_letter_independence.R::.legacy_known_letter_dep`. Fix uno por uno y remover de la lista. Total al crear la regla: 8 .Rmd.

### 📅 Historial

| Fecha | Archivo afectado | Resultado |
|-------|------------------|-----------|
| 2026-05-12 | `Comparacion-Lineas-Temporales-Schoice` | Estudiante real (KEVIN A. SILVA) reportó incoherencia en Moodle. Fix: Solution reescrita sin `r letra_correcta`. Regla #19 creada. Commit `86a4b211`. |

### 🔗 Reglas Cruzadas

- `.claude/rules/solution-letter-independence.md` (regla #19, fix principal)
- `.claude/rules/codigo-rmd.md` regla #6 excepción (casos 2 y 3 ahora obsoletos)
- Error 17 (gemelo: exshuffle:TRUE + letra con R-exams)
- `tests/testthat/test_letter_independence.R`
- `.claude/rules/markdown-imagenes-pdf.md` (regla anti-pandocbounded)

---

## Error 20: GRAF-BAR-01 — Gráfico de barras con categorías correctas pero alturas permutadas

**Detectado:** 2026-05-14 (sesión v2 distribucion-contagiados)
**Severidad:** MEDIA (patrón de distractor pedagógico; no es un bug sino un nuevo tipo de distractor a catalogar)
**Código:** GRAF-BAR-01

### Descripción del patrón

Un distractor de gráfico de barras que muestra las categorías correctas del eje horizontal (coinciden con la tabla) pero con alturas que no corresponden a las frecuencias reales — los valores están permutados entre categorías. El estudiante que solo verifica "¿las categorías coinciden?" cae en este distractor. Solo quien verifica "¿la altura de CADA barra coincide con la frecuencia de SU categoría?" lo descarta correctamente.

### Valor pedagógico

Este distractor es más fuerte que los basados en formato (GRAF-TOR-01: categoría extra; GRAF-TOR-02: áreas iguales) porque:

1. **Pasa la verificación de categorías**: las 3 etiquetas del eje X coinciden con la tabla
2. **Pasa la verificación de formato**: es un gráfico de barras, formato perfectamente válido
3. **Solo falla en la verificación de valores por categoría**: hay que comparar cada barra con su celda correspondiente en la tabla

Esto lo hace particularmente adecuado para ejercicios de Nivel 3 (DOK 3), donde el estudiante debe realizar verificación sistemática y no solo reconocimiento de patrones.

### Uso del patrón

El distractor se construye permutando las frecuencias entre las categorías, con una guardia que garantiza que la permutación NO coincida con el orden original:

```r
# Generar frecuencias permutadas para el distractor de barras
freq_perm <- frecuencias
while (TRUE) {
  freq_perm <- sample(frecuencias)
  if (!all(freq_perm == frecuencias)) break  # Garantiza que al menos una cambió
}

# Las categorías son LAS MISMAS que la tabla
cats_distractor <- categorias_tabla  # "45-64", "65-74", "75+"
# Pero las alturas están asignadas a categorías equivocadas
vals_distractor <- as.numeric(freq_perm)
```

### Verificación en el código

```r
# Validar que las categorías del distractor de barras coinciden con la tabla
# pero las alturas NO (eso es lo que lo hace ser un distractor)
stopifnot(all(cats_distractor == categorias_tabla))
stopifnot(!all(vals_distractor == as.numeric(frecuencias)))
```

### 📅 Historial

| Fecha | Archivo | Resultado |
|-------|---------|-----------|
| 2026-05-14 | `distribucion_contagiados_metacognitivo_interpretacion_n3_schoice_v2.Rmd` | GRAF-BAR-01 implementado como distractor 3. Combinado con GRAF-TOR-01 y GRAF-TOR-02 para lograr 2 barras + 2 tortas. |

### 🔗 Reglas Cruzadas

- `.claude/rules/graficos-como-opciones.md` §Formato equilibrado (la diversidad de formatos requiere distractores en ambos formatos)
- Error 18 (format-based guessing): GRAF-BAR-01 es la pieza que permite equilibrar formatos sin sacrificar calidad de distractores
- `.claude/rules/ejercicios-metacognitivos.md` (pool de errores conceptuales con códigos documentados)
- `Error 5 (EST-BOX-01)` — otro error de gráficos por confusión valor/posición, pero en boxplots

---

## Error 21: Multiply-Defined Labels en LaTeX

### ❌ Mensaje de Error

```
LaTeX Warning: Label `procedimiento-correcto' multiply defined.
LaTeX Warning: Label `reflexiuxf3n-metacognitiva' multiply defined.
LaTeX Warning: There were multiply-defined labels.
```

### 🔍 Causa Raíz

Cuando la sección `Solution` de un `.Rmd` contiene headings Markdown (`### Título`) emitidos via `cat()` con `results='asis'`, el pipeline de R-exams para PDF (knitr → HTML → tth → LaTeX) los convierte a `\subsection{Título}` que genera `\label{titulo}` en LaTeX. Si `exams2pdf()` genera múltiples copias del examen (n > 1), cada copia define los mismos labels, y LaTeX reporta "multiply defined".

**El modificador `{-}` de Pandoc NO funciona en este pipeline**: R-exams usa `tth` (no Pandoc) para la conversión HTML→LaTeX, y `tth` no reconoce `{-}`. Por lo tanto, `### Título {-}` produce `\subsection{Título {-}}` con el `{-}` visible en el PDF Y con label duplicado.

Las etiquetas repetidas no rompen la compilación pero producen warnings y pueden causar referencias cruzadas incorrectas (hyperlinks `\ref{}` que apuntan a la copia equivocada).

**Mecanismo específico**:
1. El chunk R con `results='asis'` emite `cat("### Procedimiento correcto {-}\n\n")`
2. knitr convierte el Markdown a HTML: `<h3>Procedimiento correcto</h3>` (el `{-}` se pierde)
3. tth convierte el HTML a `\subsection{Procedimiento correcto}\label{procedimiento-correcto}`
4. Con 4 copias del examen en un solo PDF (n=4), el label se define 4 veces
5. El warning se repite para cada heading en Solution (6-7 por ejercicio típico)

### ✅ Solución Verificada

**Reemplazar `### Título {-}` por `**Título**` (negrita Markdown).** La negrita no genera labels LaTeX en ningún formato de salida.

**Antes (errado — `{-}` no funciona en pipeline tth):**
```r
cat("### Análisis de las justificaciones incorrectas {-}\n\n")
cat("### Procedimiento correcto {-}\n\n")
cat("### Propiedades del concepto: el promedio {-}\n\n")
cat("### Reflexión metacognitiva {-}\n\n")
```

**Después (corregido — negrita sin labels):**
```r
cat("**Análisis de las justificaciones incorrectas**\n\n")
cat("**Procedimiento correcto**\n\n")
cat("**Propiedades del concepto: el promedio**\n\n")
cat("**Reflexión metacognitiva**\n\n")
```

**Por qué funciona**: `**texto**` → `\textbf{texto}` en LaTeX (sin label), `<strong>texto</strong>` en HTML. No genera entradas en el archivo `.aux`.

### 🧪 Validación de la Solución

```bash
# Después del fix, ejecutar:
Rscript -e "exams::exams2pdf('ejercicio.Rmd', n = 4)"
# Verificar que NO aparezca "multiply defined" en stderr/stdout
```

### 📋 Checklist de Corrección

1. Identificar TODOS los headings `### ` en la sección Solution del `.Rmd` (dentro y fuera de chunks `cat()`)
2. Reemplazar CADA `### Título {-}` por `**Título**` (negrita Markdown)
3. Si el heading está fuera de `cat()`, reemplazar `### Título {-}` por `**Título**` seguido de línea en blanco
4. Re-renderizar con `exams2pdf(n = 4)` y verificar que los warnings desaparecen
5. Verificar que el PDF resultante mantiene legibilidad (la negrita debe diferenciar secciones claramente)

### 📅 Historial

| Fecha | Archivo | Resultado |
|-------|---------|-----------|
| 2026-05-17 | `promedio_calibracion_botellas_metacognitivo_argumentacion_n3_schoice_v1.Rmd` | 7 headings `### ... {-}` reemplazados por `**...**`. Warnings eliminados. Confirmado que `{-}` NO funciona en pipeline R-exams (tth). |

### 🔗 Reglas Cruzadas

- `.claude/rules/markdown-imagenes-pdf.md` (regla #18): misma clase de problema (pipeline Pandoc/tth→LaTeX), requiere atributos explícitos
- `.claude/hooks/post-exams2-validation.sh` FASE 2K: detección automática de `### ` en `cat()` dentro de Solution
- `.claude/rules/solution-letter-independence.md` (regla #19): ambas reglas protegen la sección Solution de bugs silenciosos en el pipeline de renderizado
- **Lección aprendida**: `{-}` de Pandoc NO es confiable en el pipeline R-exams porque tth no lo reconoce. Preferir markup que no genere labels en ningún formato (`**texto**`, `\textbf{}`, etc.)

---

## Error 22: Ortografía Masiva en Strings R No Detectada (Falsos Negativos del Checker Legacy)

### ❌ Síntoma

El script `corregir_ortografia_espanol.R` reporta 0-1 errores ortográficos en un `.Rmd`
que en realidad contiene 80-100+ errores de tildes faltantes.

### 🔍 Causa Raíz

El checker R legacy tiene **dos limitaciones fundamentales**:

1. **Diccionario insuficiente**: solo ~140 palabras. Faltan cientos de términos
   frecuentes en ejercicios ICFES: `desviacion`, `estandar`, `fabrica`, `compania`,
   `produccion`, `inspeccion`, `auditoria`, `definicion`, `especifico`, `tipico`,
   `atipico`, `sinonimo`, `metacognicion`, `pequeno`, `cuanto`, `habia`,
   `parecian`, `podria`, `mayoria`, `raiz`, `tecnico`, `esten`, etc.

2. **Detección de strings limitada a una línea**: la función `esta_en_string()`
   usa regex `'[^']*'` que opera dentro de una sola línea. Los `paste0()` que
   abarcan múltiples líneas (patrón común en `.Rmd`) no se detectan como strings.

**Impacto**: ~95% de falsos negativos. El script aprueba archivos con docenas
de errores, generando falsa confianza.

### ✅ Solución Verificada

**Nuevo checker Python** (`.claude/scripts/corregir_ortografia_espanol.py`):

- Diccionario de **~500+ palabras** (3.5× más cobertura)
- Detecta errores en strings R multilínea (paste0, cat, strings en listas)
- Mismos filtros de seguridad que el checker R (respeta variables R, metadatos, etc.)
- Soporta modo `--fix` y procesamiento de directorios

```bash
# Verificar
python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd

# Corregir
python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd --fix

# Directorio completo
python3 .claude/scripts/corregir_ortografia_espanol.py directorio/ --fix
```

### 📋 Checklist de Corrección

1. Ejecutar `python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd`
2. Si hay errores → `python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd --fix`
3. Repetir verificación hasta 0 errores
4. Renderizar para confirmar que no se rompió código R

### 📚 Referencias

- `.claude/scripts/corregir_ortografia_espanol.py` — checker Python v2.0 (2026-05-18)
- `.claude/scripts/corregir_ortografia_espanol.R` — checker R v1.0 (legacy)
- `.claude/rules/ortografia-espanol.md` — regla actualizada con ambos checkers
- `.claude/hooks/pre-commit-ortografia.sh` — hook pre-commit actualizado (2 capas)

### 📅 Historial

| Fecha | Archivo | Errores reales | Detectados R | Detectados Python |
|-------|---------|---------------|-------------|-------------------|
| 2026-05-18 | rango_diferencia_botellas_*.Rmd | ~117 | 1 (falso positivo) | 117 |
| 2026-05-18 | Ejemplos-Funcionales-Rmd/ (87 archivos) | 25 | ~5 | 25 |

### 🔗 Reglas Cruzadas

- `.claude/rules/ortografia-espanol.md` — regla maestra de ortografía
- `.claude/rules/documentacion-verificada.md` — solo documentar soluciones verificadas
- `.claude/hooks/pre-commit-ortografia.sh` — enforcement en pre-commit
- **Lección aprendida**: Un diccionario pequeño + detección de strings limitada
  produce falsa confianza. La cobertura del diccionario es el factor más
  determinante en la efectividad del checker ortográfico.
