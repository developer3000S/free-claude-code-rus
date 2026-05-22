---
name: transferir-conocimiento-grafico
description: >
  Captura lecciones aprendidas de cada lenguaje gráfico y las aplica en generaciones subsecuentes.
  Transfiere estrategias exitosas TikZ->Python->R para evitar repetir errores ya resueltos.
  Usa con "transferir conocimiento", "lecciones aprendidas", "aplicar estrategias gráficas".
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

> **ROUTING**: Este skill tiene `model_recommendation: haiku`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="haiku")` pasando las instrucciones completas como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Transferencia de Conocimiento entre Lenguajes

## Decision Tree

```
Lenguaje actual?
    |
    +-> TikZ: Documentar exitos/problemas
    |         (sin lecciones previas que aplicar)
    |
    +-> Python: Leer lecciones de TikZ
    |           |
    |           +-> Aplicar estrategias exitosas
    |           +-> Evitar problemas conocidos
    |           +-> Documentar propias lecciones
    |
    +-> R: Leer lecciones de TikZ Y Python
            |
            +-> Aplicar estrategias de ambos
            +-> Evitar problemas de ambos
            +-> Documentar propias lecciones
```

## Proceso paso a paso

### PASO 1: Capturar exitos

Despues de validar o cuando una estrategia funciona:

1. Identificar que funciono bien
2. Categorizar: colores, posicionamiento, estilos, funciones, anotaciones, otro
3. Documentar codigo de ejemplo
4. Registrar numero de iteracion

### PASO 2: Capturar problemas

Cuando se identifica un problema que requiere multiples iteraciones:

1. Identificar el problema
2. Categorizar el tipo
3. Documentar la solucion aplicada
4. Registrar iteraciones requeridas

### PASO 3: Aplicar lecciones previas

Al iniciar Python o R:

1. Leer `outputs/lecciones_aprendidas.json`
2. Identificar lecciones relevantes de lenguajes previos
3. Traducir estrategias exitosas al lenguaje actual
4. Documentar aplicacion

### PASO 4: Actualizar archivo

Despues de cada validacion significativa:

1. Leer archivo existente (o crear si no existe)
2. Anadir nuevo exito o problema
3. Actualizar `timestamp_ultima_actualizacion`
4. Guardar archivo

## Flujo de transferencia

```
TikZ (primero)
    |
    +-> Establece estrategias base
    +-> Documenta exitos/problemas
    |
    v
Python (segundo)
    |
    +-> Lee lecciones de TikZ
    +-> Aplica colores RGB, evita problemas de posicionamiento
    +-> Documenta propias lecciones
    |
    v
R (tercero)
    |
    +-> Lee lecciones de TikZ Y Python
    +-> Aplica lo mejor de ambos
    +-> Documenta propias lecciones
```

## Beneficios

- Reduccion de iteraciones (estrategias probadas desde inicio)
- Mejora de calidad (evitar problemas conocidos)
- Consistencia (mismos colores/estilos entre lenguajes)
- Eficiencia (menos tiempo por proyecto)
- Aprendizaje continuo (el sistema mejora con cada proyecto)

## Referencias

- [Estructura de lecciones](references/estructura-lecciones.md) - Formato JSON y categorias
- [Ejemplos de transferencia](references/ejemplos-transferencia.md) - Casos practicos
- Archivo: `outputs/lecciones_aprendidas.json`
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
generar-codigo-tikz -> transferir-conocimiento-grafico
                            |
                            +-> (captura exitos/problemas)
                            |
generar-codigo-python <- transferir-conocimiento-grafico
                            |
                            +-> (aplica lecciones TikZ)
                            |
generar-codigo-r <- transferir-conocimiento-grafico
                            |
                            +-> (aplica lecciones TikZ + Python)
```
