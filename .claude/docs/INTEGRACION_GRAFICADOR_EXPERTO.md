# 🎨 Integración Graficador-Experto en Workflow Principal

## ⛔ REGLAS CRITICAS v2.2

### Flujo B OBLIGATORIO si hay gráficos
Si el ejercicio tiene gráficos, el Graficador Experto es **OBLIGATORIO**. Ver `.claude/rules/flujo-b-obligatorio.md`

### Proceso SECUENCIAL (NO simultáneo)
```
1. TikZ → Iterar >=95% + 5 Coherencias + Aprobación Usuario
2. Python → Iterar >=95% + 5 Coherencias + Aprobación Usuario
3. R → Iterar >=95% + 5 Coherencias + Aprobación Usuario
4. Usuario selecciona versión final
```
Ver `.claude/rules/graficador-secuencial.md`

### 5 Coherencias a Verificar antes de aprobar
1. **Semántica** - Gramática correcta
2. **Visual-Texto** - Gráfico coincide con enunciado
3. **Matemática** - Fórmulas correctas
4. **Código** - Dinámico, compatible R-exams
5. **General** - Legible, estilo ICFES

---

## Resumen

El workflow principal ahora incluye todas las capacidades del Graficador-Experto para análisis de imágenes matemáticas y generación de código gráfico (TikZ, Python, R). Todos los componentes del Graficador-Experto están disponibles con el prefijo `grafico-` para evitar conflictos con el workflow principal.

---

## Comandos del Graficador-Experto Integrados

Todos los comandos del Graficador-Experto están disponibles con el prefijo `grafico-`:

### 1. `/grafico-analizar-imagen`
Analiza una imagen matemática ICFES y genera análisis estructurado en JSON. Guarda el análisis en `outputs/analisis_inicial.json` e inicializa el estado del workflow en `outputs/workflow_state.json`.

**Uso**: Comparte una imagen matemática y ejecuta `/grafico-analizar-imagen`

**Salida**: Análisis estructurado con clasificación de contenido, elementos visuales, estilos y evaluación de complejidad.

### 2. `/grafico-generar-tikz`
Genera código TikZ/LaTeX para reproducir la imagen analizada. Reutiliza el análisis inicial y actualiza el estado del workflow.

**Uso**: Después de `/grafico-analizar-imagen`, ejecuta `/grafico-generar-tikz`

**Salida**: Archivo `outputs/output_tikz.tex` con código TikZ completo y renderizado en `outputs/tikz_render.png`.

### 3. `/grafico-generar-python`
Genera código Python (matplotlib/numpy) para reproducir la imagen. Aplica lecciones aprendidas de TikZ y actualiza el estado.

**Uso**: Después de generar TikZ, ejecuta `/grafico-generar-python`

**Salida**: Archivo `outputs/output_python.py` con código Python completo y renderizado en `outputs/python_render.png`.

### 4. `/grafico-generar-r`
Genera código R (ggplot2) para reproducir la imagen. Aplica lecciones aprendidas de TikZ y Python.

**Uso**: Después de generar Python, ejecuta `/grafico-generar-r`

**Salida**: Archivo `outputs/output_r.R` con código R completo y renderizado en `outputs/r_render.png`.

### 5. `/grafico-comparar`
Compara imagen generada con original usando Claude Vision. Calcula métricas cuantitativas (0-100 puntos) y actualiza estado.

**Uso**: Después de generar código en cualquier lenguaje, ejecuta `/grafico-comparar tikz` (o `python` o `r`)

**Salida**: Métricas de similitud por categorías (colores, posiciones, valores, proporciones, estilos, elementos) y recomendación (validar/iterar/regenerar).

### 6. `/grafico-iterar`
Refina código basándose en comparación visual. Incrementa contador de iteración y actualiza estado.

**Uso**: Si la similitud es < 95%, ejecuta `/grafico-iterar tikz` (o el lenguaje correspondiente)

**Salida**: Código refinado con mejoras basadas en la comparación visual.

### 7. `/grafico-exportar`
Genera archivos finales y reporte consolidado con estadísticas del estado del workflow.

**Uso**: Cuando estés satisfecho con los resultados, ejecuta `/grafico-exportar`

**Salida**: Reporte completo en `outputs/reporte_matematico.md` con estadísticas detalladas del proceso.

### 8. `/grafico-estado`
Visualiza el estado actual del workflow: progreso por lenguaje, tiempos, próximos pasos sugeridos.

**Uso**: En cualquier momento del proceso, ejecuta `/grafico-estado`

**Salida**: Resumen del progreso actual, similitudes alcanzadas, iteraciones realizadas y próximos pasos recomendados.

### 9. `/grafico-auto-iterar`
Itera automáticamente un lenguaje hasta alcanzar umbral de similitud o máximo de iteraciones.

**Uso**: Para automatizar el refinamiento, ejecuta `/grafico-auto-iterar tikz 95 10` (lenguaje, umbral, máximo iteraciones)

**Salida**: Iteración automática hasta alcanzar 95% de similitud o máximo de 10 iteraciones.

---

## Workflow Integrado Completo

### Caso de Uso 1: Generar Ejercicio SCHOICE con Gráfico Complejo

1. **Analizar imagen del gráfico**:
   ```
   /grafico-analizar-imagen
   ```

2. **Generar código TikZ del gráfico**:
   ```
   /grafico-generar-tikz
   ```

3. **Comparar y validar similitud**:
   ```
   /grafico-comparar tikz
   ```

4. **Iterar hasta validar** (si es necesario):
   ```
   /grafico-iterar tikz
   ```
   O usar iteración automática:
   ```
   /grafico-auto-iterar tikz 95 10
   ```

5. **Generar ejercicio SCHOICE** usando el código TikZ validado:
   ```
   /analizar-icfes
   /generar-schoice
   ```

6. **Validar ejercicio completo**:
   ```
   /validar-renderizado
   /validar-coherencia
   /validar-diversidad archivo.Rmd
   ```

7. **Promover a producción**:
   ```
   /promover-ejercicio
   ```

### Caso de Uso 2: Corregir Gráfico Existente en Ejercicio

1. **Diagnosticar errores**:
   ```
   /diagnosticar-errores
   ```

2. **Analizar imagen del gráfico correcto**:
   ```
   /grafico-analizar-imagen
   ```

3. **Generar código corregido**:
   ```
   /grafico-generar-tikz --refinar
   ```

4. **Comparar y validar corrección**:
   ```
   /grafico-comparar tikz
   ```

5. **Si es necesario, iterar**:
   ```
   /grafico-iterar tikz
   ```

6. **Validar corrección en ejercicio**:
   ```
   /validar-renderizado
   ```

### Caso de Uso 3: Generar Múltiples Versiones de Gráfico (PROCESO SECUENCIAL)

⚠️ **PROHIBIDO**: Generar TikZ, Python y R simultáneamente

1. **Analizar imagen base**:
   ```
   /grafico-analizar-imagen
   ```

2. **PASO 1: TikZ (PRIMERO - OBLIGATORIO)**:
   ```
   /auto-refinar-grafico tikz 95
   ```
   - Iterar hasta >=95% similitud
   - Verificar 5 coherencias (semántica, visual-texto, matemática, código, general)
   - **Esperar aprobación del usuario antes de continuar**

3. **PASO 2: Python (DESPUÉS de TikZ aprobado)**:
   ```
   /auto-refinar-grafico python 95
   ```
   - Iterar hasta >=95% similitud
   - Verificar 5 coherencias
   - **Esperar aprobación del usuario antes de continuar**

4. **PASO 3: R (DESPUÉS de Python aprobado)**:
   ```
   /auto-refinar-grafico r 95
   ```
   - Iterar hasta >=95% similitud
   - Verificar 5 coherencias
   - **Esperar aprobación del usuario antes de continuar**

5. **PASO 4: Usuario selecciona versión final**:
   ```
   ¿Cuál versión deseas usar?
   - TikZ (dinámico desde R)
   - Python (reticulate)
   - R (nativo - RECOMENDADO)
   ```

6. **Exportar proyecto completo**:
   ```
   /grafico-exportar
   ```

---

## Archivos Generados por el Graficador-Experto

El Graficador-Experto genera archivos en `outputs/`:

### Archivos de Estado
- `workflow_state.json` - Estado persistente del workflow de graficación
- `analisis_inicial.json` - Análisis estructurado de la imagen
- `lecciones_aprendidas.json` - Lecciones capturadas durante iteraciones

### Archivos de Código
- `output_tikz.tex` - Código TikZ/LaTeX generado
- `output_python.py` - Código Python generado
- `output_r.R` - Código R generado

### Archivos de Renderizado
- `tikz_render.png` - Imagen renderizada desde TikZ
- `python_render.png` - Imagen renderizada desde Python
- `r_render.png` - Imagen renderizada desde R

### Archivos de Reporte
- `reporte_matematico.md` - Reporte incremental del proceso con estadísticas

---

## Skills del Graficador-Experto Disponibles

Todas las skills están disponibles con el prefijo `grafico-`:

### 1. `grafico-analizar-imagen-matematica`
Análisis visual detallado de imágenes matemáticas con extracción estructurada de información.

### 2. `grafico-generar-tikz`
Generación de código TikZ/LaTeX preciso con validación visual.

### 3. `grafico-generar-python`
Producción de código Python (matplotlib/numpy) profesional.

### 4. `grafico-generar-r`
Generación de código R (ggplot2) eficiente.

### 5. `grafico-comparar-visual`
Análisis de diferencias con Claude Vision y cálculo de métricas cuantitativas (0-100 puntos).

### 6. `grafico-refinar-codigo`
Mejora de código basándose en comparaciones visuales.

### 7. `grafico-gestionar-estado`
Manejo del estado persistente del workflow: tracking de progreso, iteraciones y similitudes.

### 8. `grafico-transferir-conocimiento`
Captura y aplicación de lecciones aprendidas entre lenguajes (TikZ → Python → R).

---

## Schemas JSON

Los schemas del Graficador-Experto están en `.claude/schemas/`:

### 1. `workflow_state.schema.json`
Define la estructura del estado persistente del workflow con tracking de progreso por lenguaje.

**Campos principales**:
- `lenguajes`: Estado por lenguaje (tikz, python, r)
- `similitudes`: Historial de similitudes por iteración
- `iteraciones`: Contador de iteraciones por lenguaje
- `tiempos`: Tiempos de ejecución por paso

### 2. `analisis_inicial.schema.json`
Estructura para el análisis visual estructurado y reutilizable de la imagen matemática.

**Campos principales**:
- `clasificacion`: Tipo de contenido matemático
- `elementos_visuales`: Componentes identificados
- `estilos`: Colores, tipografía, estilos de línea
- `complejidad`: Nivel de complejidad evaluado

### 3. `metricas_similitud.schema.json`
Sistema de puntuación cuantitativa de similitud visual (0-100 puntos) por categorías.

**Categorías evaluadas**:
- `colores`: Precisión de colores RGB
- `posiciones`: Ubicación de elementos
- `valores`: Valores numéricos y etiquetas
- `proporciones`: Escalas y relaciones
- `estilos`: Estilos de línea y tipografía
- `elementos`: Completitud de elementos

### 4. `lecciones_aprendidas.schema.json`
Estructura para documentar éxitos y problemas por lenguaje para transferencia de conocimiento.

**Campos principales**:
- `exitos`: Estrategias exitosas por lenguaje
- `problemas`: Problemas identificados y soluciones
- `transferencias`: Lecciones aplicadas entre lenguajes

---

## Integración con Workflow Principal

### Flujo A: Sin Gráficos Complejos

Cuando el ejercicio no requiere gráficos complejos, usa el workflow principal estándar:

1. `/analizar-icfes`
2. `/generar-schoice` o `/generar-cloze`
3. `/validar-renderizado`
4. `/validar-coherencia`
5. `/promover-ejercicio`

### Flujo B: Con Gráficos Complejos (OBLIGATORIO si hay gráficos)

⚠️ **Este flujo es OBLIGATORIO** cuando se detectan gráficos en el enunciado y/o las opciones de respuesta.

```
┌─────────────────────────────────────────────────────────┐
│ PASO 1: TikZ (dinámico desde R)                         │
│ /auto-refinar-grafico tikz 95                           │
│    ↓                                                    │
│ Iterar hasta >=95% similitud                            │
│    ↓                                                    │
│ Verificar 5 Coherencias                                 │
│    ↓                                                    │
│ ¿Usuario aprueba? → SI → Continuar                      │
│                   → NO → Volver a iterar                │
└─────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────┐
│ PASO 2: Python (reticulate)                             │
│ /auto-refinar-grafico python 95                         │
│ [Mismo proceso que TikZ]                                │
└─────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────┐
│ PASO 3: R (ggplot2 nativo)                              │
│ /auto-refinar-grafico r 95                              │
│ [Mismo proceso que TikZ]                                │
└─────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────┐
│ PASO 4: Usuario selecciona versión final                │
│ (TikZ, Python o R)                                      │
└─────────────────────────────────────────────────────────┘
    ↓
/generar-schoice o /generar-cloze
```

**Proceso completo**:

1. `/analizar-icfes` - Detectar si requiere Flujo B
2. `/grafico-analizar-imagen` - Analizar gráfico
3. **TikZ**: `/auto-refinar-grafico tikz 95` → 5 coherencias → aprobación usuario
4. **Python**: `/auto-refinar-grafico python 95` → 5 coherencias → aprobación usuario
5. **R**: `/auto-refinar-grafico r 95` → 5 coherencias → aprobación usuario
6. Usuario selecciona versión final
7. `/generar-schoice` - Generar ejercicio con código seleccionado
8. `/validar-renderizado` - Validar renderizado completo
9. `/validar-coherencia` - Validar coherencia matemática
10. `/promover-ejercicio` - Promover a producción

⚠️ **BLOQUEO**: No se puede ejecutar `/generar-schoice` o `/generar-cloze` si Flujo B está incompleto.

---

## Características del Sistema Integrado

### Sistema de Estado Persistente
- Tracking completo del progreso del workflow de graficación
- Historial de similitudes por iteración
- Recuperación ante interrupciones
- Visibilidad del progreso en tiempo real con `/grafico-estado`

### Métricas Cuantitativas
- Sistema objetivo de puntuación (0-100 puntos)
- Evaluación por categorías (colores, posiciones, valores, proporciones, estilos, elementos)
- Recomendaciones basadas en puntuación (validar/iterar/regenerar)

### Transferencia de Conocimiento
- Aprendizaje entre lenguajes (TikZ → Python → R)
- Aplicación automática de estrategias exitosas
- Evitar problemas ya identificados

### Compatibilidad Bidireccional
- El workflow principal puede usar las capacidades del Graficador-Experto
- El Graficador-Experto puede beneficiarse de las validaciones del workflow principal
- Ambos workflows mantienen su funcionalidad independiente

---

## Referencias

### Documentación Completa del Graficador-Experto
- **Explicación completa**: [01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md](01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md)
- **README original**: [GRAFICADOR_EXPERTO_README.md](GRAFICADOR_EXPERTO_README.md)
- **Diagrama de flujo**: `../Mermaid_Chart_Graficador_Experto.txt`

### Documentación del Workflow Principal
- **Workflow paso a paso**: [WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md)
- **Guía de usuario**: [GUIA_USUARIO.md](GUIA_USUARIO.md)
- **Troubleshooting**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## Notas Importantes

### Prefijos para Evitar Conflictos
Todos los componentes del Graficador-Experto usan el prefijo `grafico-` para evitar conflictos con el workflow principal.

### Preservación Exacta del Graficador-Experto
El contenido de los archivos del Graficador-Experto se copia **EXACTAMENTE** como está, sin modificaciones. Solo cambian los nombres de archivos/directorios.

### Sistema de Estado Persistente
El Graficador-Experto usa archivos JSON en `outputs/` para mantener estado persistente. Estos archivos son independientes del workflow principal.

### Permisos Bash Adicionales
El Graficador-Experto requiere permisos para:
- Compilación LaTeX (`pdflatex`)
- Conversión de imágenes (`magick`)
- Ejecución de scripts Python y R

Estos permisos están configurados en `settings.local.json`.

---

**Última actualización**: 2025-12-30
**Versión**: 2.2
**Estado**: Integración completa operacional

## Cambios v2.2
- Flujo B (Graficador Experto) ahora es OBLIGATORIO cuando hay gráficos
- Proceso SECUENCIAL: TikZ → Python → R (no simultáneo)
- 5 coherencias a verificar antes de aprobación
- Bloqueo de generación .Rmd si Flujo B incompleto

