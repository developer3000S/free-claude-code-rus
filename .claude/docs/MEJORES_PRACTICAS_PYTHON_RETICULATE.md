# Mejores Prácticas: Python/Reticulate en R/exams

**Última actualización:** 2025-12-20
**Estado:** Validado en producción

---

## Índice

1. [Configuración Inicial](#configuración-inicial)
2. [Generación de Gráficas](#generación-de-gráficas)
3. [Control de Dimensiones](#control-de-dimensiones)
4. [Integración R ↔ Python](#integración-r--python)
5. [Renderizado y Formatos](#renderizado-y-formatos)
6. [Patrones Validados](#patrones-validados)

---

## Configuración Inicial

### Setup del Chunk R

```r
# Chunk setup - OBLIGATORIO
library(exams)
library(reticulate)

# Configurar Python explícitamente
use_python("/usr/bin/python3", required = TRUE)

# Configurar motor de knitr para Python
knitr::knit_engines$set(python = function(options) {
  knitr::engine_output(options, options$code, '')
})

# Asegurar disponibilidad
use_python(Sys.which("python3"), required = TRUE)
```

### Configuración de Chunks

```r
knitr::opts_chunk$set(
  warning = FALSE,
  message = FALSE,
  fig.width = 4,      # Control de ancho
  fig.height = 4,     # Control de altura
  out.width = "40%",  # Tamaño en documento
  dpi = 150
)
```

**Referencias:**

- `Lab-Manjaro/36/volumen_cilindro_hueco_py_v1.Rmd:50-53`
- `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2_py.Rmd`

---

## Generación de Gráficas

### ✅ Método Recomendado: `py_run_string()`

**IMPORTANTE:** Usar `py_run_string()` en lugar de chunks `{python}` directos.

```r
# Chunk R para generar gráfica
codigo_python <- paste0("
import matplotlib
matplotlib.use('Agg')  # Backend sin interfaz gráfica
import matplotlib.pyplot as plt
import numpy as np

# Obtener parámetros desde R
radio_py = ", radio, "
altura_py = ", altura, "

# Crear figura
fig, ax = plt.subplots(figsize=(4, 4))

# ... código de gráfica ...

# Guardar
plt.tight_layout(pad=0.5)
plt.savefig('grafica.png', dpi=150, bbox_inches='tight', transparent=True)
plt.close()
")

# Ejecutar código Python
py_run_string(codigo_python)
```

**Ventajas:**

- ✅ Control total sobre rutas de archivos
- ✅ Interpolación directa de variables R
- ✅ Compatible con R/exams workflow
- ✅ Debugging más fácil

**Referencia:** `Lab-Manjaro/36/volumen_cilindro_hueco_py_v1.Rmd:191-367`

---

## Control de Dimensiones

### Estrategia Multi-Nivel

#### 1. **Configuración Global (knitr)**

```r
knitr::opts_chunk$set(
  fig.width = 4,
  fig.height = 4,
  out.width = "40%"
)
```

#### 2. **Tamaño de Figura (matplotlib)**

```python
fig, ax = plt.subplots(figsize=(4, 4))  # Pulgadas
```

#### 3. **Márgenes Dinámicos**

```python
# Calcular margen proporcional a las dimensiones
margen = max(radio_escalado, altura_escalada) * 0.6

# Aplicar límites dinámicos
ax.set_xlim(-radio_escalado - margen*0.5, radio_escalado + margen*0.8)
ax.set_ylim(-margen*0.4, altura_escalada + margen*0.6)
```

**Referencia:** `Lab-Manjaro/36/volumen_cilindro_hueco_py_v1.Rmd:354-356`

#### 4. **Padding Ajustado**

```python
plt.tight_layout(pad=0.5)  # Reducir espacio en blanco
```

#### 5. **Detección de Formato**

```r
# Ajustar tamaño según formato de salida
es_moodle <- (match_exams_call() %in% c("exams2moodle", "exams2qti12", ...))

if(es_moodle) {
  cat("![](grafica.png){width=30%}\n\n")  # Moodle
} else {
  cat("![](grafica.png){width=45%}\n\n")  # PDF/Word
}
```

**Referencia:** `A-Produccion/En-Desarrollo/volumen_cilindro_geometrico_metrico_interpretacion_python_n2_v1.Rmd:337-345`

---

## Integración R ↔ Python

### Variables: R → Python

**Método 1: Interpolación en String** (✅ Recomendado)

```r
codigo <- paste0("
radio_py = ", radio, "
altura_py = ", altura, "
nombre_py = '", nombre, "'
")
py_run_string(codigo)
```

**Método 2: Acceso directo con `r.`**

```python
# En chunk {python}
radio_py = r.radio
altura_py = r.altura
```

### Variables: Python → R

```r
# Después de ejecutar código Python
resultado <- py$variable_python
lista_resultados <- py$lista_python
```

**Referencia:** `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/Plantillas/Python/Contraseñas/Contrasennia_Cloze_All.Rmd:59`

---

## Renderizado y Formatos

### Inclusión de Imágenes

**✅ Método Correcto:**

```r
# Usar cat() con sintaxis markdown
cat("![](imagen.png){width=45%}\n\n")
```

**❌ Evitar:**

```r
# NO usar include_graphics() con imágenes Python
include_graphics("imagen.png")  # Falla en R/exams
```

**Referencia:** `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2_py.Rmd:550`

### Guardado de Imágenes

```python
# Parámetros optimizados para R/exams
plt.savefig('imagen.png',
            dpi=150,                  # Resolución balanceada
            bbox_inches='tight',       # Sin márgenes extra
            transparent=True,          # Fondo transparente
            facecolor='white')         # O color específico
```

**Formatos múltiples (si es necesario):**

```python
plt.savefig('imagen.png', dpi=150, bbox_inches='tight')
plt.savefig('imagen.pdf', dpi=150, bbox_inches='tight')
```

---

## Patrones Validados

### Patrón Completo: Cilindro 3D

```r
# 1. Configuración
library(reticulate)
use_python("/usr/bin/python3", required = TRUE)

# 2. Generación de datos
radio <- sample(2:6, 1)
altura <- sample(6:12, 1)

# 3. Código Python
codigo_cilindro <- paste0("
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Ellipse

# Parámetros desde R
radio_py = ", radio, "
altura_py = ", altura, "

# Figura compacta
fig, ax = plt.subplots(figsize=(4, 4))

# Escalado
escala_x = 1.0
escala_y = 1.5
r_escalado = radio_py * escala_x
y_tapa = altura_py * escala_y

# Elipses con perspectiva
profundidad = 0.25
elipse_base = Ellipse((0, 0), r_escalado*2, profundidad*2,
                       edgecolor='#654321', facecolor='none',
                       linewidth=2, linestyle='--')
ax.add_patch(elipse_base)

elipse_tapa = Ellipse((0, y_tapa), r_escalado*2, profundidad*2,
                       edgecolor='#654321', facecolor='#D2B48C',
                       linewidth=2, alpha=0.6)
ax.add_patch(elipse_tapa)

# Líneas laterales
ax.plot([-r_escalado, -r_escalado], [0, y_tapa],
        color='#654321', linewidth=2.5)
ax.plot([r_escalado, r_escalado], [0, y_tapa],
        color='#654321', linewidth=2.5)

# Etiquetas
ax.annotate('', xy=(r_escalado, y_tapa+0.5), xytext=(0, y_tapa+0.5),
            arrowprops=dict(arrowstyle='<->', color='red', lw=1.2))
ax.text(r_escalado/2, y_tapa+0.9, '", radio, " cm',
        ha='center', va='bottom', fontsize=9, color='red')

# Configuración de ejes
margen = max(r_escalado, y_tapa) * 0.6
ax.set_xlim(-r_escalado - margen*0.5, r_escalado + margen*0.8)
ax.set_ylim(-margen*0.4, y_tapa + margen*0.6)
ax.set_aspect('equal')
ax.axis('off')

# Guardar
plt.tight_layout(pad=0.5)
plt.savefig('cilindro.png', dpi=150, bbox_inches='tight', transparent=True)
plt.close()
")

# 4. Ejecutar
py_run_string(codigo_cilindro)

# 5. Mostrar en documento
cat("![](cilindro.png){width=45%}\n\n")
```

**Referencia:** `A-Produccion/En-Desarrollo/volumen_cilindro_geometrico_metrico_interpretacion_python_n2_v1.Rmd`

---

## Checklist Pre-Producción

Antes de mover un ejercicio con Python a producción:

- [ ] ✅ Usa `py_run_string()` en lugar de chunks `{python}` directos
- [ ] ✅ Configura `matplotlib.use('Agg')`
- [ ] ✅ Guarda con `transparent=True` y `bbox_inches='tight'`
- [ ] ✅ Usa `cat()` para incluir imágenes
- [ ] ✅ Implementa detección de formato (Moodle vs PDF)
- [ ] ✅ Configura tamaños en 3 niveles (knitr, matplotlib, markdown)
- [ ] ✅ Usa márgenes dinámicos proporcionales
- [ ] ✅ Cierra figuras con `plt.close()`
- [ ] ✅ Valida en múltiples formatos (HTML, PDF, Word)

---

## Errores Comunes y Soluciones

### Error: "Cannot find the file(s): imagen.png"

**Causa:** Usar `include_graphics()` en lugar de `cat()`

**Solución:**
```r
# En lugar de:
include_graphics("imagen.png")

# Usar:
cat("![](imagen.png){width=45%}\n\n")
```

### Error: Imagen muy grande o muy pequeña

**Causa:** Doble escalado o falta de control multi-nivel

**Solución:**
```r
# 1. Configurar en knitr
fig.width = 4, fig.height = 4, out.width = "40%"

# 2. Configurar en matplotlib
figsize=(4, 4)

# 3. Ajustar en markdown
{width=45%}
```

### Error: Gráfica cortada

**Causa:** No usar `bbox_inches='tight'`

**Solución:**
```python
plt.savefig('imagen.png', bbox_inches='tight')
```

---

## Referencias Completas

### Archivos Validados en Producción

1. **Cilindro Hueco:**
   - `Lab-Manjaro/36/volumen_cilindro_hueco_py_v1.Rmd`
   - Uso avanzado de matplotlib con perspectiva 3D

2. **Diagramas de Caja:**
   - `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2_py.Rmd`
   - Generación dinámica de múltiples gráficas

3. **Adopción de Mascotas:**
   - `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/Plantillas/Python/AdopcionMascotas/`
   - Gráficas de barras y circulares

4. **Generador de Contraseñas:**
   - `A-Produccion/En-Produccion/Ejemplos-Funcionales-Rmd/Plantillas/Python/Contraseñas/Contrasennia_Cloze_All.Rmd`
   - Integración R ↔ Python avanzada

---

## Cambios Recientes

### 2025-12-20

- ✅ Validado patrón de cilindro con dimensiones optimizadas
- ✅ Implementado sistema de detección de formato
- ✅ Documentadas mejores prácticas de márgenes dinámicos

---

**Versión:** 1.0.0
**Mantenedor:** Equipo R/exams ICFES
