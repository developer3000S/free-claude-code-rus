# Decision de Flujo: A vs B

## Regla Critica

**FLUJO B (Graficador Experto) es OBLIGATORIO si hay graficos.**

Ver: .claude/rules/flujo-b-obligatorio.md

## Criterios de Activacion

### ACTIVAR Flujo B SI cualquiera aplica:

- Hay graficos matematicos en la imagen (barras, lineas, dispersion, etc.)
- Hay diagramas geometricos (triangulos, circulos, figuras)
- Hay plano cartesiano con funciones o puntos
- Hay tablas con datos que requieren visualizacion
- Las opciones de respuesta incluyen graficos
- El enunciado menciona "segun la grafica", "observa el diagrama", etc.

### NO activar (Flujo A) SOLO SI:

- Solo texto puro sin NINGUN elemento visual
- Imagenes puramente decorativas (no matematicas)

**SI HAY DUDA: USAR FLUJO B**

## Proceso Flujo B (Secuencial)

Ver: .claude/rules/graficador-secuencial.md

```
1. TikZ (dinamico desde R)
   ↓ iterar hasta >=95% + coherencias + aprobacion usuario
2. Python (via reticulate)
   ↓ iterar hasta >=95% + coherencias + aprobacion usuario
3. R (ggplot2 nativo)
   ↓ iterar hasta >=95% + coherencias + aprobacion usuario
4. Usuario selecciona version final
   ↓
5. SOLO ENTONCES → /generar-schoice o /generar-cloze
```

## Bloqueo de Generacion

Si se detectan graficos y se intenta generar .Rmd sin completar Flujo B, el sistema BLOQUEARA la generacion.

El archivo workflow_state.json debe contener:

```json
{
  "flujo_b_completado": true,
  "tikz": { "estado": "validado", "usuario_aprobo": true },
  "python": { "estado": "validado", "usuario_aprobo": true },
  "r": { "estado": "validado", "usuario_aprobo": true },
  "version_seleccionada": "tikz|python|r"
}
```
