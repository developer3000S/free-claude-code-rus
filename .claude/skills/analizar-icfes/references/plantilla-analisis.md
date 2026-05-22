# Plantilla de Analisis ICFES

## Comprension Inicial

```markdown
## Comprension Inicial

- **Enunciado**: [resumen breve]
- **Datos**: [lista de datos numericos]
- **Pregunta**: [que se pide calcular/demostrar]
- **Graficos**: [SI/NO - descripcion si aplica]
```

## Clasificacion por Dimensiones

```markdown
## Analisis ICFES Completo

### 1. Nivel de Dificultad

- **Nivel**: [1|2|3|4]
- **Justificacion**: [por que este nivel]
- **Puntos estimados**: [0-100]

### 2. Competencia

- **Competencia**: [Interpretacion|Formulacion|Argumentacion]
- **Justificacion**: [que hace principalmente]

### 3. Componente

- **Componente**: [Numerico-Variacional|Geometrico-Metrico|Aleatorio]
- **Justificacion**: [area matematica principal]

### 4. Tipo de Pensamiento

- **Pensamiento(s)**: [lista de tipos aplicables]
- **Predominante**: [el principal]

### 5. Contenido Curricular

- **Area**: [Algebra|Geometria|Estadistica]
- **Tipo**: [Generico|No Generico]
- **Tema especifico**: [ej: "Ecuaciones cuadraticas"]

### 6. Eje Axial

- **Eje**: [Puramente Matematico|Aplicado/Contextualizado]
- **Contexto**: [descripcion si es aplicado]
```

## Decision de Flujo (OBLIGATORIO)

```markdown
## Decision de Flujo (OBLIGATORIO)

### Deteccion de Graficos

- **Graficos en enunciado**: [SI/NO - descripcion]
- **Graficos en opciones**: [SI/NO - descripcion]
- **Elementos visuales matematicos**: [lista]

### Decision Final

**Flujo seleccionado**: [A: Estandar | B: Con Graficador]

**Justificacion**: [razon detallada]

**Registro**:
```json
{
  "requiere_flujo_b": true/false,
  "graficos_detectados": ["lista de graficos"],
  "decision_justificada": "razon"
}
```

### Siguiente Paso OBLIGATORIO

- **Flujo A** → Ir a /generar-schoice o /generar-cloze
- **Flujo B** → Ejecutar Graficador Experto SECUENCIALMENTE
```

## Metadatos R/exams

```yaml
exname: [Nombre descriptivo del ejercicio]
extype: [schoice|cloze]
exsolution: [Respuesta correcta]
exshuffle: TRUE  # FALSE en SCHOICE con opciones gráficas PNG (ver graficos-como-opciones.md)
extol: 0.01

# Metadatos ICFES (derivados del analisis)
exextra[Type]: [SCHOICE|CLOZE]
exextra[Competencia]: [resultado Dimension 2]
exextra[Componente]: [resultado Dimension 3]
exextra[Afirmacion]: [descripcion basada en Dimension 5]
exextra[Evidencia]: [descripcion basada en Dimension 2]
exextra[Nivel]: [resultado Dimension 1]
```
