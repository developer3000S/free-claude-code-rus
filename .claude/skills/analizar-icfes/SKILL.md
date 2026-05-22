---
name: analizar-icfes
description: >
  Analiza ejercicios matematicos tipo ICFES segun 6 dimensiones oficiales
  (dificultad, competencia, componente, pensamiento, contenido, eje).
  Usa cuando tengas imagen de problema ICFES, pregunta matematica para clasificar,
  o necesites decidir si requiere graficos complejos. Detecta automaticamente
  si el ejercicio necesita Graficador Experto para replicacion visual.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere capacidades de vision de Claude. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: opus
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(ls:*)
---

# Analisis ICFES de Ejercicios Matematicos

## Decision Tree

```
Imagen/texto de ejercicio?
    |
    +-> PASO 1: Comprension inicial
    |    +-> Extraer enunciado, datos, pregunta
    |    +-> Detectar graficos/elementos visuales
    |
    +-> PASO 2: Clasificar 6 dimensiones
    |    +-> Nivel (1-4)
    |    +-> Competencia (Interpretacion|Formulacion|Argumentacion)
    |    +-> Componente (Numerico|Geometrico|Aleatorio)
    |    +-> Pensamiento (Numerico|Espacial|Metrico|Variacional|Aleatorio)
    |    +-> Contenido (Generico|No Generico)
    |    +-> Eje (Puro|Aplicado)
    |
    +-> PASO 3: Decision de flujo (OBLIGATORIO)
    |    |
    |    +-> Hay graficos? -> FLUJO B (Graficador Experto)
    |    +-> Solo texto? -> FLUJO A (Estandar)
    |
    +-> PASO 4: Generar metadatos R/exams
         +-> exname, extype, exsolution
         +-> exextra[Competencia|Componente|Nivel|...]
```

## Proceso paso a paso

### PASO 1: Comprension inicial

Si es imagen: Leer enunciado, identificar datos, detectar graficos.
Si es texto: Extraer variables, relaciones, pregunta.

Ver [plantilla de analisis](references/plantilla-analisis.md) para formato.

### PASO 2: Clasificar 6 dimensiones

Ver [dimensiones ICFES](references/dimensiones-icfes.md) para:

- Criterios de clasificacion por dimension
- Tablas de referencia
- Combinaciones comunes

### PASO 3: Decision de flujo (OBLIGATORIO)

Ver [decision de flujo](references/decision-flujo.md) para:

- Criterios de activacion Flujo B
- Proceso secuencial TikZ→Python→R
- Bloqueos de generacion

**REGLA CRITICA**: Si hay graficos → Flujo B OBLIGATORIO.

### PASO 4: Generar metadatos R/exams

```yaml
exname: [Nombre descriptivo]
extype: [schoice|cloze]
exsolution: [Respuesta]
exshuffle: TRUE  # FALSE en SCHOICE con opciones gráficas PNG (ver graficos-como-opciones.md)
extol: 0.01

exextra[Type]: [SCHOICE|CLOZE]
exextra[Competencia]: [resultado Dimension 2]
exextra[Componente]: [resultado Dimension 3]
exextra[Afirmacion]: [descripcion]
exextra[Evidencia]: [descripcion]
exextra[Nivel]: [1|2|3|4]
```

## Errores comunes

| Error | Correccion |
|-------|-----------|
| Confundir Competencia con Componente | Competencia = accion (Interpretar, Formular, Argumentar) |
| Nivel muy bajo/alto | Contar pasos: 1-2 → Nivel 1-2, 3+ → Nivel 3-4 |
| No detectar necesidad de Graficador | Grafico con valores numericos? → SI usar Graficador |

## Output esperado

```markdown
# Analisis ICFES Completo: [Nombre]

## 1. Clasificacion por Dimensiones
[Tabla con las 6 dimensiones]

## 2. Metadatos R/exams Generados
[Bloque YAML]

## 3. Decision de Flujo
[A o B, con justificacion]

## 4. Siguiente Accion
[Comando a ejecutar]
```

## Referencias

- [Dimensiones ICFES](references/dimensiones-icfes.md) - 6 dimensiones detalladas
- [Plantilla de analisis](references/plantilla-analisis.md) - Formato estandar
- [Decision de flujo](references/decision-flujo.md) - Flujo A vs B
- Regla: .claude/rules/flujo-b-obligatorio.md
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
analizar-icfes <- ESTE SKILL (entry point)
    |
    +-> Flujo A (sin graficos) -> generar-schoice/cloze
    |
    +-> Flujo B (con graficos) -> TikZ -> Python -> R -> generar-schoice/cloze
```
