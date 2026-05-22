# Ejemplo: Auditoria de Skill

## Comando Ejecutado

```
/detractor auditoria .claude/skills/generar-schoice/
```

---

# Auditoria Detractor: generar-schoice

**Fecha**: 2026-02-06
**Alcance**: Skill completo (SKILL.md + references/)
**Objeciones**: 4 (0 criticas, 1 alta, 2 medias, 1 nota)

## Resumen Ejecutivo

El skill `generar-schoice` tiene una base solida para generacion de ejercicios SCHOICE metacognitivos. Sin embargo, presenta una objecion de severidad alta relacionada con la validacion de distractores y dos oportunidades de mejora en la documentacion de errores conceptuales.

---

## Objeciones

### Objecion 1: Pool de errores sin validacion de unicidad

**Que se cuestiona**:

En la generacion de distractores, no hay validacion explicita de que los valores generados sean unicos entre si y diferentes de la respuesta correcta.

```r
# Codigo actual (inferido del skill)
distractores <- sapply(errores_conceptuales[1:3], function(e) e$calcula(datos))
```

**Por que** (Fuente Nivel 1):

> "Each distractor should be plausible but clearly incorrect,
> and no two options should have the same value"
> — [R-exams: Single Choice Items](https://www.r-exams.org/tutorials/schoice/)

**Riesgo concreto**:

- Si dos errores conceptuales producen el mismo valor numerico, el ejercicio tiene opciones duplicadas
- Si un error produce el valor correcto, la pregunta tiene dos respuestas correctas
- Ambos casos invalidan el item psicometricamente

**Alternativa propuesta**:

```r
# En data_generation chunk
generar_distractores_unicos <- function(errores, datos, respuesta_correcta, max_intentos = 100) {
  distractores <- c()
  usados <- c(respuesta_correcta)

  for (error in errores) {
    valor <- error$calcula(datos)
    intentos <- 0

    while (valor %in% usados && intentos < max_intentos) {
      # Ajustar datos ligeramente y recalcular
      datos_ajustados <- ajustar_datos(datos)
      valor <- error$calcula(datos_ajustados)
      intentos <- intentos + 1
    }

    if (!valor %in% usados) {
      distractores <- c(distractores, valor)
      usados <- c(usados, valor)
    }
  }

  stopifnot(length(unique(distractores)) == length(distractores))
  stopifnot(!respuesta_correcta %in% distractores)

  return(distractores)
}
```

**Veredicto**: MODIFICAR

Agregar seccion en SKILL.md sobre validacion de unicidad de distractores con codigo de ejemplo.

---

### Objecion 2: Codigos de error sin taxonomia estandarizada

**Que se cuestiona**:

El skill menciona codigos como `EST-MTC-01` pero no define una taxonomia completa ni referencia a documento estandar.

**Por que** (Fuente Nivel 2):

> "Error taxonomies should be grounded in research on student misconceptions,
> not ad-hoc categorizations"
> — Confrey (1990), Journal for Research in Mathematics Education

**Riesgo concreto**:

- Codigos inconsistentes entre ejercicios
- Dificil agregar nuevos errores sin duplicar
- No hay trazabilidad a literatura pedagogica

**Alternativa propuesta**:

Crear documento `references/taxonomia-errores.md` con:

1. Estructura jerarquica de codigos
2. Referencia a literatura por cada categoria
3. Ejemplos de errores documentados por tema

```markdown
# Taxonomia de Errores Conceptuales

## Estructura de Codigos

[AREA]-[SUBTEMA]-[NUMERO]

### Areas
- ALG: Algebra
- ARI: Aritmetica
- EST: Estadistica
- GEO: Geometria
- FUN: Funciones

### Ejemplo Documentado

**Codigo**: EST-MTC-01
**Nombre**: Confusion promedio-mediana
**Referencia**: Batanero et al. (1994)
**Manifestacion**: Usar mediana cuando se pide promedio
```

**Veredicto**: MODIFICAR

Crear taxonomia estandarizada de errores con referencias academicas.

---

### Objecion 3: Sin mencion de Item Response Theory (IRT)

**Que se cuestiona**:

El skill no menciona como los items generados se comportan en modelos IRT, que es estandar en evaluaciones como ICFES.

**Por que** (Fuente Nivel 2):

> "Items designed for large-scale assessment should consider
> discrimination and difficulty parameters from the design phase"
> — Haladyna (2004), Developing and Validating Multiple-Choice Test Items

**Riesgo concreto**:

- Items pueden tener dificultad real diferente a la declarada
- Sin calibracion IRT, no se puede garantizar que N3 sea mas dificil que N2
- ICFES usa modelos Rasch/2PL; items deben ser compatibles

**Alternativa propuesta**:

Agregar seccion en SKILL.md:

```markdown
## Consideraciones IRT

Los ejercicios generados deben ser compatibles con modelos IRT:

- **Dificultad**: El nivel declarado (N1-N4) debe correlacionar con
  dificultad empirica b ∈ [-3, 3]
- **Discriminacion**: Distractores plausibles aumentan discriminacion a ≥ 1.0
- **Adivinar**: Con 4 opciones, c ≈ 0.25; distractores atractivos lo reducen

Para validacion post-hoc, usar:
- Pilotaje con N ≥ 200 estudiantes
- Analisis con paquete `mirt` o `TAM` en R
```

**Veredicto**: MODIFICAR

Agregar seccion de consideraciones IRT para alinear con estandares psicometricos.

---

### Nota Menor: Formato de reflexiones metacognitivas

**Observacion**:

Las reflexiones metacognitivas estan en lista simple. Podrian categorizarse por tipo de metacognicion (monitoreo, evaluacion, regulacion).

**Severidad**: Baja - No requiere accion inmediata.

---

## Veredicto Global

**Estado**: APROBAR CON CAMBIOS

**Justificacion**: El skill tiene fundamentos pedagogicos solidos y estructura clara. Las objeciones son mejoras incrementales, no problemas fundamentales. Una vez implementadas las modificaciones, el skill estara alineado con estandares psicometricos profesionales.

## Proximos Pasos

1. **Prioridad Alta**: Agregar validacion de unicidad de distractores (Objecion 1)
2. **Prioridad Media**: Crear taxonomia estandarizada de errores (Objecion 2)
3. **Prioridad Media**: Documentar consideraciones IRT (Objecion 3)

---

## Configuracion Utilizada

| Parametro | Valor |
|-----------|-------|
| Severidad minima | Media |
| Fuente minima | Nivel 2 |
| Ignorar estilistico | Si |

Objeciones que pasaron filtro: 3
Notas menores: 1
Objeciones ignoradas por umbral: 2
