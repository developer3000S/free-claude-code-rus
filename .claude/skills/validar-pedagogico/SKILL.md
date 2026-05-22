---
name: validar-pedagogico
description: >
  Analisis pedagogico avanzado basado en evidencias cientificas y taxonomias cognitivas modernas.
  Skill CONSULTIVO que requiere aprobacion del usuario. Evalua Progressive Disclosure, DOK, Bloom y SOLO.
  Usa con "validar pedagogico", "analisis pedagogico", "revisar taxonomias", "evaluar calidad educativa".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere ejercicio .Rmd validado. Modelo Opus 4.6 recomendado.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: opus
allowed-tools:
  - Read
  - Glob
  - Grep
  - Bash(ls:*)
---

# Validador Pedagogico ICFES

## Decision Tree

```
Ejercicio validado?
    |
    +-> NO: Completar Ciclo de Validacion primero
    |
    +-> SI: Sugerir analisis pedagogico
            |
            +-> Usuario aprueba? SI -> Invocar PedagogoICFES
            |                   NO -> Continuar sin analisis
            |
            +-> Generar reporte 0-100 pts
            |
            +-> Ofrecer aplicar recomendaciones
```

## Cuando activar (proactivo)

Claude sugiere este skill cuando:

1. Ejercicio .Rmd completado y validado
2. Ciclo de Validacion exitoso (FASE 1, 2, 3)
3. Todos los formatos renderizados correctamente
4. Usuario solicita analisis de calidad
5. Antes de `/promover-ejercicio`

## Cuando NO activar

- Ejercicio con errores de compilacion
- Faltan metadatos ICFES
- Ciclo de Validacion incompleto
- Consulta rapida (usar `/analizar-icfes`)

## Proceso paso a paso

### PASO 1: Verificar elegibilidad

- Archivo .Rmd existe y compila
- Metadatos ICFES completos (6 dimensiones)
- Sin errores en formatos (HTML, PDF, DOCX, NOPS)

### PASO 2: Solicitar aprobacion

```markdown
## Analisis Pedagogico Disponible

El ejercicio ha sido validado. Analisis incluye:

- Clasificacion con 3 taxonomias (Bloom, SOLO, Webb)
- Validacion Marco Conceptual ICFES 2026
- Evaluacion de distractores
- Optimizacion con principios cientificos
- Puntuacion compuesta 0-100

Duracion: 5-10 min | Modelo: Opus 4.6

Ejecutar analisis? (Si/No)
```

### PASO 3: Ejecutar analisis

Ver [modulos de analisis](references/modulos-analisis.md) para:

- Taxonomias cognitivas evaluadas
- Criterios de validacion ICFES
- Tipologia de distractores
- Principios de aprendizaje

### PASO 4: Presentar reporte

Estructura del reporte:

- Puntuacion final: X/100 (Letra)
- Fortalezas identificadas
- Areas de mejora
- Recomendaciones especificas

### PASO 5: Ofrecer aplicar recomendaciones

Si usuario acepta, modificar ejercicio segun sugerencias.

## Agente asociado

- **Nombre**: PedagogoICFES
- **Modelo**: Claude Opus 4.6
- **Herramientas**: read, glob, grep, bash
- **Base cientifica**: 30+ referencias peer-reviewed

## Documentos consultados

- `errores-conceptuales-matematicas.md`
- `principios-aprendizaje-evidencias.md`
- `taxonomias-cognitivas-integradas.md`
- `marco-conceptual-icfes-2026.md`
- `diseno-distractores-tipologia.md`

## Referencias

- [Modulos de analisis](references/modulos-analisis.md) - Componentes evaluados
- Agente: `.claude/agents/pedagogo-icfes.md`
- Base conocimiento: `.claude/knowledge/`

## Integracion con Workflow

```
/generar-schoice o /generar-cloze
    |
    v
FASE 1: Validacion automatica
    |
    v
FASE 2: Preview visual
    |
    v
Validacion exitosa
    |
    +-> [Sugerencia] /validar-pedagogico <- ESTE SKILL
    |
    +-> /promover-ejercicio
```
