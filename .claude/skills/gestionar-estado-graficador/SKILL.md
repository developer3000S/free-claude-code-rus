---
name: gestionar-estado-graficador
description: >
  Gestiona el estado persistente del workflow Graficador Experto via workflow_state.json.
  Permite tracking de progreso, recuperación ante interrupciones y trazabilidad del proceso TikZ/Python/R.
  Usa con "estado graficador", "progreso gráficos", "recuperar workflow", "guardar estado".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere workflow Graficador Experto activo. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: haiku
allowed-tools:
  - Read
  - Write
  - Bash(ls:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: haiku`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="haiku")` pasando las instrucciones completas y la ruta del workflow_state.json como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Gestion de Estado del Workflow

## Decision Tree

```
Operacion solicitada?
    |
    +-> Inicializar: Crear workflow_state.json vacio
    |
    +-> Iniciar lenguaje: Cambiar estado a "en_iteracion"
    |
    +-> Registrar iteracion: Incrementar contador
    |
    +-> Registrar similitud: Actualizar valor y historico
    |
    +-> Validar lenguaje: Cambiar estado a "validado"
    |
    +-> Consultar estado: Mostrar resumen de progreso
```

## Proceso paso a paso

### PASO 1: Inicializar estado

Al iniciar un nuevo workflow:

1. Crear `outputs/workflow_state.json`
2. Establecer `timestamp_inicio`
3. Establecer `fase_actual` como "analisis"
4. Inicializar lenguajes con estado "pendiente"

### PASO 2: Gestionar transiciones

Al cambiar de fase:

1. Leer estado actual
2. Validar que transicion sea permitida
3. Actualizar `fase_actual` y estado del lenguaje
4. Guardar cambios

### PASO 3: Registrar progreso

Durante iteraciones:

1. Incrementar `iteracion_actual`
2. Registrar similitud en `similitud_historico`
3. Actualizar `timestamp_ultima_actualizacion`

### PASO 4: Consultar estado

Para mostrar progreso:

1. Leer `workflow_state.json`
2. Calcular tiempo transcurrido
3. Determinar indicadores por lenguaje
4. Sugerir proximos pasos

## Estados y transiciones

```
analisis -> tikz_iteracion -> tikz_validado
                                    |
                                    v
         python_iteracion <- python_validado
                                    |
                                    v
              r_iteracion <- r_validado -> completado
```

## Indicadores de estado

| Indicador | Estado | Significado |
|-----------|--------|-------------|
| VALIDADO | validado | Aprobado (>=95% o manual) |
| EN ITERACION | en_iteracion | Activo |
| PENDIENTE | pendiente | No iniciado |

## Reglas de validacion

- TikZ: Puede iniciarse despues de analisis
- Python: Requiere TikZ validado o al menos iniciado
- R: Requiere Python validado o al menos iniciado
- Validacion: Solo si similitud >= 95 o aprobacion manual

## Recuperacion ante errores

Si el workflow se interrumpe:

1. Leer estado persistente
2. Identificar ultima fase completada
3. Sugerir continuar desde donde quedo
4. Validar que archivos necesarios existan

## Referencias

- [Estructura del estado](references/estructura-estado.md) - Formato JSON completo
- [Operaciones de estado](references/operaciones-estado.md) - Acciones disponibles
- Archivo: `outputs/workflow_state.json`
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
analizar-icfes
    |
    +-> gestionar-estado-graficador <- ESTE SKILL
            |
            +-> (inicializa estado)
            |
generar-codigo-* -> gestionar-estado-graficador
            |
            +-> (registra iteraciones, similitudes)
            |
comparar-similitud-visual -> gestionar-estado-graficador
            |
            +-> (registra similitud)
            |
/estado -> gestionar-estado-graficador
            |
            +-> (consulta y muestra progreso)
```
