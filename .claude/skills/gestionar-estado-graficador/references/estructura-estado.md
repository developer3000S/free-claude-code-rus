# Estructura del Estado del Workflow

## Archivo de Estado

```
outputs/workflow_state.json
```

## Estructura Completa

```json
{
  "version": "1.0",
  "timestamp_inicio": "2025-12-29T10:30:00Z",
  "timestamp_ultima_actualizacion": "2025-12-29T10:30:00Z",
  "imagen_original": "outputs/original.png",
  "fase_actual": "analisis",
  "analisis_completado": false,
  "tikz": {
    "estado": "pendiente",
    "iteracion_actual": 0,
    "similitud_actual": 0,
    "similitud_historico": [],
    "timestamp_inicio": null,
    "timestamp_validacion": null
  },
  "python": {
    "estado": "pendiente",
    "iteracion_actual": 0,
    "similitud_actual": 0,
    "similitud_historico": [],
    "timestamp_inicio": null,
    "timestamp_validacion": null
  },
  "r": {
    "estado": "pendiente",
    "iteracion_actual": 0,
    "similitud_actual": 0,
    "similitud_historico": [],
    "timestamp_inicio": null,
    "timestamp_validacion": null
  }
}
```

## Estados por Lenguaje

| Estado | Descripcion |
|--------|-------------|
| pendiente | No iniciado |
| en_iteracion | Generacion/refinamiento activo |
| validado | Aprobado (>=95% o manual) |

## Fases del Workflow

| fase_actual | Significado |
|-------------|-------------|
| analisis | Analisis inicial de imagen |
| tikz_iteracion | Generando/iterando TikZ |
| tikz_validado | TikZ aprobado |
| python_iteracion | Generando/iterando Python |
| python_validado | Python aprobado |
| r_iteracion | Generando/iterando R |
| r_validado | R aprobado |
| completado | Todos los lenguajes validados |

## Ejemplo con Progreso

```json
{
  "fase_actual": "python_iteracion",
  "analisis_completado": true,
  "tikz": {
    "estado": "validado",
    "iteracion_actual": 4,
    "similitud_actual": 96,
    "similitud_historico": [72, 85, 91, 96],
    "timestamp_validacion": "2025-12-29T11:15:00Z"
  },
  "python": {
    "estado": "en_iteracion",
    "iteracion_actual": 2,
    "similitud_actual": 88,
    "similitud_historico": [78, 88]
  },
  "r": {
    "estado": "pendiente",
    "iteracion_actual": 0,
    "similitud_actual": 0,
    "similitud_historico": []
  }
}
```
