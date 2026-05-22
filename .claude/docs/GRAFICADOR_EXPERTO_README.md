# Configuracion de Claude Code - Graficador Experto ICFES

Este directorio contiene toda la configuracion de Claude Code para el proyecto Graficador Experto.

## ⛔ REGLAS CRITICAS v2.2

### Flujo B OBLIGATORIO si hay graficos
Si el ejercicio tiene graficos, el Graficador Experto es **OBLIGATORIO**. Ver `.claude/rules/flujo-b-obligatorio.md`

### Proceso SECUENCIAL (NO simultaneo)
```
1. TikZ → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
2. Python → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
3. R → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
4. Usuario selecciona version final
```
Ver `.claude/rules/graficador-secuencial.md`

### 5 Coherencias a Verificar antes de aprobar
1. **Semantica** - Gramatica correcta
2. **Visual-Texto** - Grafico coincide con enunciado
3. **Matematica** - Formulas correctas
4. **Codigo** - Dinamico, compatible R-exams
5. **General** - Legible, estilo ICFES

## Estructura

```
.claude/
├── commands/           # Comandos slash personalizados
│   ├── analizar-imagen.md
│   ├── generar-tikz.md
│   ├── generar-python.md
│   ├── generar-r.md
│   ├── comparar.md
│   ├── iterar.md
│   ├── exportar.md
│   ├── estado.md          # [NUEVO] Visualización de progreso
│   └── auto-iterar.md     # [NUEVO] Iteración automática
├── skills/            # Skills especializadas
│   ├── analizar-imagen-matematica/
│   ├── generar-tikz/
│   ├── generar-python/
│   ├── generar-r/
│   ├── comparar-visual/
│   ├── refinar-codigo/
│   ├── gestionar-estado/      # [NUEVO] Gestión de estado persistente
│   └── transferir-conocimiento/ # [NUEVO] Transferencia de conocimiento
├── schemas/           # [NUEVO] Esquemas JSON
│   ├── workflow_state.schema.json
│   ├── analisis_inicial.schema.json
│   ├── metricas_similitud.schema.json
│   └── lecciones_aprendidas.schema.json
├── agents/            # Agentes (futuro)
├── hooks/             # Hooks automáticos (futuro)
└── README.md          # Este archivo
```

## Comandos Disponibles (9)

### 1. `/analizar-imagen`
Inicia el workflow completo con análisis visual de imagen ICFES. Guarda análisis estructurado e inicializa estado del workflow.

### 2. `/generar-tikz`
Genera código TikZ/LaTeX con validación visual. Actualiza estado del workflow y reutiliza análisis inicial.

### 3. `/generar-python`
Genera código Python (matplotlib/numpy). Aplica lecciones aprendidas de TikZ y actualiza estado.

### 4. `/generar-r`
Genera código R (ggplot2). Aplica lecciones aprendidas de TikZ y Python.

### 5. `/comparar`
Compara imagen generada con original usando Claude Vision. Calcula métricas cuantitativas (0-100 puntos) y actualiza estado.

### 6. `/iterar`
Refina código basándose en comparación visual. Incrementa contador de iteración y actualiza estado.

### 7. `/exportar`
Genera archivos finales y reporte consolidado con estadísticas del estado del workflow.

### 8. `/estado` [NUEVO]
Visualiza el estado actual del workflow: progreso por lenguaje, tiempos, próximos pasos sugeridos.

### 9. `/auto-iterar` [NUEVO]
Itera automáticamente un lenguaje hasta alcanzar umbral de similitud o máximo de iteraciones.

## Skills Especializadas (8)

### 1. Análisis Visual Matemático
Identificación y extracción de información de imágenes matemáticas.

### 2. Generación TikZ
Creación de código LaTeX/TikZ preciso.

### 3. Generación Python
Producción de código matplotlib/numpy profesional.

### 4. Generación R
Generación de código ggplot2 eficiente.

### 5. Comparación Visual Inteligente
Análisis de diferencias con Claude Vision y cálculo de métricas cuantitativas (0-100 puntos).

### 6. Refinamiento Iterativo
Mejora de código basándose en comparaciones.

### 7. Gestión de Estado [NUEVO]
Manejo del estado persistente del workflow: tracking de progreso, iteraciones y similitudes.

### 8. Transferencia de Conocimiento [NUEVO]
Captura y aplicación de lecciones aprendidas entre lenguajes (TikZ → Python → R).

## Schemas JSON (4) [NUEVO]

### 1. `workflow_state.schema.json`
Define la estructura del estado persistente del workflow con tracking de progreso por lenguaje.

### 2. `analisis_inicial.schema.json`
Estructura para el análisis visual estructurado y reutilizable de la imagen matemática.

### 3. `metricas_similitud.schema.json`
Sistema de puntuación cuantitativa de similitud visual (0-100 puntos) por categorías.

### 4. `lecciones_aprendidas.schema.json`
Estructura para documentar éxitos y problemas por lenguaje para transferencia de conocimiento.

## Uso

### Workflow Básico

1. Comparte una imagen matemática ICFES
2. Ejecuta `/analizar-imagen` para iniciar el workflow (guarda análisis estructurado e inicializa estado)
3. Valida cada lenguaje o usa `/iterar` para refinar
4. Usa `/estado` en cualquier momento para ver progreso
5. Exporta con `/exportar` cuando estés satisfecho

### Workflow Avanzado

1. Comparte imagen y ejecuta `/analizar-imagen`
2. Usa `/auto-iterar tikz 95 10` para iteración automática hasta 95% de similitud
3. Continúa con Python y R de forma similar
4. Consulta `/estado` para ver progreso en tiempo real
5. Exporta con `/exportar` para reporte completo con estadísticas

## Workflow Visual (SECUENCIAL OBLIGATORIO)

```
/analizar-imagen
    ↓
┌─────────────────────────────────────────────────────────┐
│ PASO 1: TikZ (dinamico desde R)                         │
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
│ PASO 4: Usuario selecciona version final                │
│ (TikZ, Python o R)                                      │
└─────────────────────────────────────────────────────────┘
    ↓
/generar-schoice o /generar-cloze
```

⚠️ **PROHIBIDO**: Generar TikZ, Python y R simultaneamente

## Archivos Generados en `outputs/`

- `workflow_state.json` - Estado persistente del workflow (generado automáticamente)
- `analisis_inicial.json` - Análisis estructurado de la imagen (generado por `/analizar-imagen`)
- `lecciones_aprendidas.json` - Lecciones capturadas durante el proceso (generado automáticamente)
- `reporte_matematico.md` - Reporte incremental actualizado en cada paso
- `output_tikz.tex`, `output_python.py`, `output_r.R` - Códigos generados
- `tikz_render.png`, `python_render.png`, `r_render.png` - Imágenes renderizadas

## Características Nuevas

### Sistema de Estado Persistente
- Tracking completo del progreso del workflow
- Historial de similitudes por iteración
- Recuperación ante interrupciones
- Visibilidad del progreso en tiempo real

### Métricas Cuantitativas
- Sistema objetivo de puntuación (0-100 puntos)
- Evaluación por categorías (colores, posiciones, valores, proporciones, estilos, elementos)
- Recomendaciones basadas en puntuación (validar/iterar/regenerar)

### Transferencia de Conocimiento
- Aprendizaje entre lenguajes (TikZ → Python → R)
- Aplicación automática de estrategias exitosas
- Evitar problemas ya identificados

## Notas

- Los comandos usan formato Markdown con frontmatter YAML
- Las skills están organizadas en subdirectorios con `skill.md`
- Los schemas JSON definen estructuras de datos persistentes
- Los hooks de compilación/ejecución están documentados pero pendientes de implementación
- Para más detalles, consulta `../README.md` en la raíz del proyecto

