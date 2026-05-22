---
name: stress-test-visual
description: >
  Stress test visual multi-semilla para ejercicios .Rmd. Renderiza N veces con exams2pdf(),
  convierte a PNG, analiza anomalías estadísticas y ejecuta inspección visual de semillas sospechosas.
  Usa con "stress test", "probar con múltiples semillas", "verificar renderizado masivo", "anomalías visuales".
metadata:
  author: alvaretto
  version: "1.0"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Bash(Rscript:*)
  - Bash(ls:*)
  - Bash(cat:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas y la ruta del archivo .Rmd como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Stress Test Visual Multi-Semilla

## Propósito

Renderizar un ejercicio .Rmd N veces con diferentes semillas, analizar los resultados como lo haría un profesor revisando un examen, y reportar anomalías que otros niveles de validación no detectan.

## Cuándo se ejecuta

1. **Hook automático (FASE 2H)**: Después de cada renderizado exitoso, si las fases 2A-2G pasan
2. **Manual**: El usuario invoca `/stress-test-visual archivo.Rmd [--n 30]`

## Flujo de ejecución

### Paso 1: Ejecutar script R

```bash
Rscript SOURCES/scripts_validacion/stress_test_visual.R archivo.Rmd --n 10 --output-dir ./stress_test_output
```

El script R genera automáticamente:
- `stress_test_output/reporte.json` — Análisis completo
- `stress_test_output/resumen.txt` — Resumen legible
- `stress_test_output/semillas_sospechosas.txt` — Semillas con anomalías
- `stress_test_output/datos_por_semilla.csv` — Datos extraídos
- `stress_test_output/pngs/seed_XXXXX*.png` — PNGs de cada renderización

### Paso 2: Leer reporte R

```
Read("stress_test_output/reporte.json")
```

Identificar:
- `veredicto`: PASA / ADVERTENCIA / FALLA
- `anomalias`: Lista de anomalías con tipo, severidad, semilla
- `pngs_sospechosas`: PNGs que DEBEN inspeccionarse visualmente
- `pngs_muestra_normales`: 3 PNGs de semillas normales para verificación base

### Paso 3: Inspección visual (OBLIGATORIA si hay anomalías)

Si el veredicto es ADVERTENCIA o FALLA:

1. **Leer TODOS los PNGs de semillas sospechosas**:
   ```
   Read("stress_test_output/pngs/seed_XXXXX-0.png")
   ```

2. **Para cada PNG, verificar**:
   - **Texto**: ¿Legible? ¿Cortado? ¿Superpuesto?
   - **Opciones**: ¿Se ven todas? ¿Alguna vacía o rota?
   - **Gráficos**: ¿Renderizados correctamente? ¿Ejes visibles?
   - **Fórmulas**: ¿LaTeX renderizado o código crudo?
   - **Layout**: ¿Formato correcto? ¿Márgenes apropiados?
   - **Coherencia**: ¿El texto coincide con el gráfico/tabla?
   - **Sentido**: ¿Un estudiante podría resolver esto?

3. **Leer 3 PNGs de semillas normales** (verificación base):
   - Confirmar que las semillas "normales" realmente se ven bien

### Paso 4: Consolidar y reportar

Generar reporte consolidado para el usuario:

```markdown
## Stress Test Visual — [Nombre Ejercicio]

### Veredicto: [PASA / ADVERTENCIA / FALLA]

**Semillas**: [N] probadas, [X] exitosas, [Y] sospechosas, [Z] fallidas

### Anomalías detectadas por R
| # | Tipo | Severidad | Semilla | Detalle |
|---|------|-----------|---------|---------|
| 1 | ... | ... | ... | ... |

### Hallazgos de inspección visual
[Descripción de lo que se observó en los PNGs sospechosos]
[Imágenes referenciadas si es necesario]

### Semillas normales verificadas
[Confirmación de que N semillas normales se ven correctas]

### Acción requerida
- [ ] [Correcciones necesarias]
- [ ] Re-ejecutar stress test después de correcciones
```

## Tipos de anomalía

| ID | Anomalía | Severidad | Lo que significa |
|----|----------|-----------|-----------------|
| `ANOM_COMPILE` | Fallo de compilación | Crítica | El .Rmd no compila con ciertas semillas |
| `ANOM_DUP_OPT` | Opciones duplicadas | Crítica | Dos opciones son idénticas en una semilla |
| `ANOM_DIST_EQ_CORR` | Distractor = correcto | Crítica | Un distractor es igual a la respuesta |
| `ANOM_NEG_PATRON` | Patrón _neg_ inválido | Crítica | Ejercicio _neg_ sin (N-1)+1 esperado |
| `ANOM_POS_FIJA` | Posición correcta fija | Alta | La correcta siempre en la misma posición |
| `ANOM_RANGO` | Valor fuera de rango | Alta | Opción con valor absurdo |
| `ANOM_NA_INF` | NA/NaN/Inf | Crítica | Valores inválidos en opciones |
| `ANOM_BAJA_VAR` | Baja variabilidad | Media | Valores casi iguales entre semillas |
| `ANOM_CTX_REPET` | Contexto repetido | Media | El enunciado no varía |

## Integración con ciclo de validación

```
FASE 2A: Coherencia matemática [hook]
FASE 2B: Preview visual [hook]
FASE 2C-2F: Arsenal estático
FASE 2G: Multi-semilla (solo entorno R)
FASE 2H: Stress Test Visual (renderizado real + PNGs) ← ESTE SKILL
```
