# Nomenclatura Oficial para Archivos .Rmd

## REGLA OBLIGATORIA

**Todo archivo .Rmd DEBE seguir este formato de nomenclatura:**

```
[ejercicio]_[componente]_[competencia]_n[nivel]_v[version].Rmd
```

## Componentes del Nombre

### 1. [ejercicio] - Nombre Descriptivo
- Usar snake_case (guiones bajos)
- Describir el contenido matemático del ejercicio
- Sin tildes ni caracteres especiales
- Máximo 40 caracteres

**Ejemplos válidos:**
- `series_temporales_poblacion`
- `diagrama_venn_generos_musicales`
- `mediana_datos_farmaceuticos`
- `funcion_lineal_auto_viajero`
- `probabilidad_bolas_colores`

**Ejemplos inválidos:**
- `poblacion_paises` (muy genérico)
- `ejercicio1` (no descriptivo)
- `SeriesTemporales` (camelCase prohibido)
- `series-temporales` (guiones prohibidos)

### 2. [componente] - Componente ICFES
Usar exactamente uno de estos valores:

| Valor | Descripción |
|-------|-------------|
| `geometrico_metrico` | Geometría, medición, espacial |
| `numerico_variacional` | Números, álgebra, funciones |
| `aleatorio` | Estadística, probabilidad |

### 3. [competencia] - Competencia ICFES
Usar exactamente uno de estos valores:

| Valor | Descripción |
|-------|-------------|
| `interpretacion_representacion` | Leer, interpretar gráficos/tablas |
| `formulacion_ejecucion` | Plantear y resolver problemas |
| `argumentacion` | Justificar, validar procedimientos |

### 4. n[nivel] - Nivel de Dificultad
Usar `n1`, `n2`, `n3` o `n4`:

| Nivel | Descripción |
|-------|-------------|
| `n1` | Básico - Reconocimiento directo |
| `n2` | Intermedio - Aplicación simple |
| `n3` | Avanzado - Múltiples pasos |
| `n4` | Superior - Análisis complejo |

### 5. v[version] - Versión del Ejercicio
- Empezar siempre con `v1`
- Incrementar al crear variantes: `v2`, `v3`, etc.
- Las variantes son ejercicios diferentes, no versiones dinámicas

## Ejemplos Completos

```
# Ejercicio de series temporales, estadística, interpretación, nivel 2, versión 1
series_temporales_poblacion_aleatorio_interpretacion_representacion_n2_v1.Rmd

# Ejercicio de diagrama de Venn, estadística, formulación, nivel 3, versión 1
diagrama_venn_generos_musicales_aleatorio_formulacion_ejecucion_n3_v1.Rmd

# Ejercicio de función lineal, variacional, interpretación, nivel 2, versión 1
funcion_lineal_auto_viajero_numerico_variacional_interpretacion_representacion_n2_v1.Rmd

# Ejercicio de mediana, estadística, argumentación, nivel 2, versión 2
mediana_datos_farmaceuticos_aleatorio_argumentacion_n2_v2.Rmd
```

## Correspondencia con exname

El campo `exname` en Meta-information DEBE coincidir exactamente con el nombre del archivo (sin extensión):

```yaml
Meta-information
================
exname: series_temporales_poblacion_aleatorio_interpretacion_representacion_n2_v1
extype: schoice
...
```

## Correspondencia con Metadatos ICFES

Los metadatos ICFES en el archivo DEBEN coincidir con el nombre:

```yaml
# icfes:
#   competencia: interpretacion_representacion  # ← Debe coincidir con [competencia]
#   nivel_dificultad: 2                         # ← Debe coincidir con n[nivel]
#   componente: aleatorio                       # ← Debe coincidir con [componente]
```

## Validación Automática

Antes de guardar cualquier archivo .Rmd, verificar:

1. ✅ El nombre sigue el formato `[ejercicio]_[componente]_[competencia]_n[nivel]_v[version].Rmd`
2. ✅ [componente] es uno de: `geometrico_metrico`, `numerico_variacional`, `aleatorio`
3. ✅ [competencia] es una de: `interpretacion_representacion`, `formulacion_ejecucion`, `argumentacion`
4. ✅ [nivel] es uno de: `n1`, `n2`, `n3`, `n4`
5. ✅ [version] empieza con `v` seguido de número: `v1`, `v2`, etc.
6. ✅ `exname` coincide exactamente con el nombre del archivo
7. ✅ Metadatos ICFES coinciden con los componentes del nombre

## Estructura de Carpetas OBLIGATORIA

### Carpeta del Ejercicio

**Todo ejercicio .Rmd DEBE estar en su propia carpeta con el mismo nombre:**

```
outputs/[nombre_ejercicio]/
├── [nombre_ejercicio].Rmd          # Archivo principal
├── original.png                     # Imagen original (si aplica)
├── output_tikz.tex                  # Código TikZ
├── output_python.py                 # Código Python
├── output_r.R                       # Código R
├── tikz_final.png                   # Renderizado TikZ
├── python_final.png                 # Renderizado Python
├── r_final.png                      # Renderizado R
├── analisis_inicial.json            # Análisis estructurado
└── workflow_state.json              # Estado del workflow
```

### Ejemplo Completo

```
outputs/series_temporales_poblacion_aleatorio_interpretacion_representacion_n2_v1/
├── series_temporales_poblacion_aleatorio_interpretacion_representacion_n2_v1.Rmd
├── original.png
├── output_tikz.tex
├── output_python.py
├── output_r.R
├── tikz_final.png
├── python_final.png
├── r_final.png
├── analisis_inicial.json
└── workflow_state.json
```

### Ubicación según Estado

| Estado | Carpeta Base |
|--------|--------------|
| En desarrollo | `/A-Produccion/En-Desarrollo/[nombre_ejercicio]/` |
| Validados (producción) | `/A-Produccion/03-En-Produccion/[categoría]/[nombre_ejercicio]/` |
| En producción | `/A-Produccion/En-Produccion/[categoria]/[nombre_ejercicio]/` |

## Errores Comunes a Evitar

❌ `poblacion_paises.Rmd` - Falta componente, competencia, nivel, versión
❌ `ejercicio_estadistica_v1.Rmd` - Falta competencia y nivel
❌ `Series_Temporales_Aleatorio_n2_v1.Rmd` - Usar minúsculas, falta competencia
❌ `series-temporales_aleatorio_n2_v1.Rmd` - Usar guiones bajos, no guiones

## Referencias

- `.claude/commands/generar-schoice.md`
- `.claude/commands/generar-cloze.md`
- `.claude/skills/generar-schoice/skill.md`
- `.claude/skills/generar-cloze/skill.md`
