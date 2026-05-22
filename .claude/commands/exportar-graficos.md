---
description: Genera archivos finales y reporte consolidado del proceso completo.
---

# Exportar Gráficos

Exporta todos los resultados del workflow.

## Proceso

1. **Leer Estado del Workflow**:
   - Cargar `outputs/workflow_state.json`
   - Verificar progreso de cada lenguaje
   - Calcular estadísticas: iteraciones totales, similitudes finales, tiempos transcurridos

2. **Verifica** que los tres códigos estén validados (o al menos generados)

3. **Guarda archivos finales**:
   - `outputs/output_tikz.tex` - Código TikZ final
   - `outputs/output_python.py` - Código Python final
   - `outputs/output_r.R` - Código R final
   - `outputs/original.png` - Imagen original
   - `outputs/tikz_render.png` - Renderizado TikZ
   - `outputs/python_render.png` - Renderizado Python
   - `outputs/r_render.png` - Renderizado R
   - `outputs/workflow_state.json` - Estado final del workflow
   - `outputs/analisis_inicial.json` - Análisis estructurado inicial

4. **Genera reporte consolidado** (`outputs/reporte_matematico.md`) con información del estado:

```markdown
# Reporte de Conversión Matemática ICFES

## Resumen Ejecutivo

- **Fecha inicio**: [timestamp_inicio del workflow_state.json]
- **Fecha finalización**: [timestamp_ultima_actualizacion]
- **Duración total**: [calcular diferencia]
- **Tipo de contenido**: [tipo del analisis_inicial.json]
- **Iteraciones totales**: TikZ: [tikz.iteracion_actual], Python: [python.iteracion_actual], R: [r.iteracion_actual]
- **Similitudes finales**: TikZ: [tikz.similitud_actual]%, Python: [python.similitud_actual]%, R: [r.similitud_actual]%
- **Estado final**: ✅ Completado

## Análisis Inicial

[Resumen del análisis de la imagen original]

## Implementaciones

### TikZ (LaTeX)

**Iteraciones**: [tikz.iteracion_actual]
**Similitud visual final**: [tikz.similitud_actual]%
**Historial de similitud**: [tikz.similitud_historico como gráfico de progreso]
**Tiempo de desarrollo**: [calcular desde tikz.timestamp_inicio hasta tikz.timestamp_validacion]
**Ventajas**:

- Salida vectorial de máxima calidad
- Precisión matemática perfecta
- Ideal para publicaciones académicas

**Desventajas**:

- Requiere compilación LaTeX
- Curva de aprendizaje pronunciada

**Código final**: Ver `output_tikz.tex`

![TikZ Output](tikz_render.png)

### Python (matplotlib/numpy)

**Iteraciones**: [python.iteracion_actual]
**Similitud visual final**: [python.similitud_actual]%
**Historial de similitud**: [python.similitud_historico como gráfico de progreso]
**Tiempo de desarrollo**: [calcular desde python.timestamp_inicio hasta python.timestamp_validacion]
**Ventajas**:

- Ecosistema científico completo
- Fácil integración con cálculos
- Gran flexibilidad

**Desventajas**:

- Calidad de salida inferior a TikZ
- Configuración de estilos puede ser compleja

**Código final**: Ver `output_python.py`

![Python Output](python_render.png)

### R (ggplot2)

**Iteraciones**: [r.iteracion_actual]
**Similitud visual final**: [r.similitud_actual]%
**Historial de similitud**: [r.similitud_historico como gráfico de progreso]
**Tiempo de desarrollo**: [calcular desde r.timestamp_inicio hasta r.timestamp_validacion]
**Ventajas**:

- Gramática de gráficos intuitiva
- Excelente para visualización estadística
- Código conciso y legible

**Desventajas**:

- Menos flexible para gráficos complejos
- Rendimiento con datasets grandes

**Código final**: Ver `output_r.R`

![R Output](r_render.png)

## Comparación Visual

| Aspecto | TikZ | Python | R |
|---------|------|--------|---|
| Precisión | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Colores | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Escalas | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| Anotaciones | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

## Recomendaciones

- **Para publicaciones académicas**: Usar versión TikZ
- **Para análisis interactivo**: Usar versión Python
- **Para reportes estadísticos**: Usar versión R

## Notas Técnicas

[Decisiones de implementación, desafíos encontrados, soluciones aplicadas]

## Gráficos de Progreso

### Evolución de Similitud por Lenguaje

```
TikZ:    [75] → [82] → [89] → [96] ✅
Python:  [78] → [88] → [94] ✅
R:       [80] → [92] ✅
```

### Estadísticas de Iteración

- **Promedio de iteraciones por lenguaje**: [calcular promedio]
- **Mejora promedio por iteración**: [calcular mejora promedio]
- **Tiempo promedio por iteración**: [calcular tiempo promedio]

## Historial de Iteraciones

[Resumen de cambios en cada iteración - ya documentado incrementalmente en el reporte]
```

5. **⚠️ PREGUNTA OBLIGATORIA: Selección de versión para R-exams**

**ANTES de generar el archivo .Rmd, SIEMPRE preguntar al usuario:**

```
Se han generado tres versiones del gráfico:

| Versión | Similitud | Ventajas |
|---------|-----------|----------|
| TikZ    | [X]%      | Vectorial, precisión máxima, ideal para PDF |
| Python  | [Y]%      | Integrable con reticulate, flexible |
| R       | [Z]%      | Nativo R-exams, más fácil de mantener |

¿Cuál versión deseas usar para el archivo .Rmd de R-exams?

1. TikZ (standalone, incluido como imagen)
2. Python (via reticulate)
3. R/ggplot2 (nativo, RECOMENDADO)
```

**CRÍTICO:**
- NO generar el .Rmd automáticamente
- ESPERAR la respuesta del usuario
- Usar la versión seleccionada para `/generar-schoice` o `/generar-cloze`

6. **Crear CARPETA con nomenclatura oficial**

Después de que el usuario seleccione la versión:

```bash
# 1. Construir nombre según nomenclatura:
NOMBRE="[ejercicio]_[componente]_[competencia]_n[nivel]_v[version]"

# 2. Crear carpeta:
mkdir -p outputs/$NOMBRE

# 3. Mover todos los archivos a la carpeta:
mv outputs/output_tikz.tex outputs/$NOMBRE/
mv outputs/output_python.py outputs/$NOMBRE/
mv outputs/output_r.R outputs/$NOMBRE/
mv outputs/tikz_final.png outputs/$NOMBRE/
mv outputs/python_final.png outputs/$NOMBRE/
mv outputs/r_final.png outputs/$NOMBRE/
mv outputs/analisis_inicial.json outputs/$NOMBRE/
mv outputs/workflow_state.json outputs/$NOMBRE/
mv outputs/reporte_matematico.md outputs/$NOMBRE/
cp outputs/original.png outputs/$NOMBRE/  # Si existe
```

**Estructura final:**
```
outputs/[nombre_ejercicio]/
├── [nombre_ejercicio].Rmd
├── output_tikz.tex
├── output_python.py
├── output_r.R
├── tikz_final.png
├── python_final.png
├── r_final.png
├── analisis_inicial.json
├── workflow_state.json
└── reporte_matematico.md
```

7. **Confirma exportación completa**

## Opciones

- `--solo-codigo`: Solo genera archivos de código, sin reporte
- `--solo-reporte`: Solo genera reporte, sin archivos individuales
- `--formato html|md`: Formato del reporte (default: md)

## Referencias

- `skills/gestionar-estado-graficador/skill.md` - Skill de gestión de estado del workflow
- `.claude/schemas/workflow_state.schema.json` - Esquema del estado del workflow
- `.claude/schemas/analisis_inicial.schema.json` - Esquema del análisis estructurado

