---
name: skill-consultar-ontologia
description: Consulta la ontología Fuseki para verificar prerequisitos antes de generar un ejercicio ICFES. Ejecutar ANTES de /generar-schoice o /generar-cloze cuando el ejercicio involucra un concepto matemático.
model_recommendation: sonnet
---

# Skill: Consultar Ontología — Prerequisitos de Concepto

## Cuándo usar este skill

**Antes de generar cualquier ejercicio** cuando el usuario menciona un concepto matemático específico (función logarítmica, probabilidad condicional, cuartiles, etc.).

## Pasos obligatorios

### 1. Verificar que Fuseki está activo

```bash
curl -s --max-time 3 http://localhost:3030/$/ping > /dev/null 2>&1 && echo "Fuseki OK" || echo "Fuseki DOWN"
```

Si Fuseki no está activo:
- Informar al usuario: "La ontología no está disponible. Inicie Fuseki con: `systemctl --user start fuseki.service`"
- Continuar sin verificación de prerequisitos

### 2. Consultar prerequisitos del concepto

```bash
cd /home/elpuente/R/proyecto-r-exams-icfes-matematicas-optimizado
Rscript -e "
source('core/consultar_cobertura.R')

# Consulta prerequisitos de un concepto específico
prereqs_query <- function(concepto_iri) {
  q <- sprintf('
PREFIX : <http://icfes.matematicas.edu.co/ontologia#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
SELECT ?prereq ?label
WHERE {
  ?prereq :esPrerequisitoDe :%s .
  OPTIONAL { ?prereq rdfs:label ?label }
}
ORDER BY ?label
', concepto_iri)
  sparql_query(q)
}

# Reemplazar CONCEPTO con el IRI local del concepto (ej: FuncionLogaritmica)
df <- prereqs_query('CONCEPTO')
if (!is.null(df) && nrow(df) > 0) {
  cat('Prerequisitos de CONCEPTO:\n')
  print(df)
} else {
  cat('Sin prerequisitos registrados para CONCEPTO\n')
}
"
```

### 3. Consultar cobertura existente del concepto

```bash
Rscript -e "
source('core/consultar_cobertura.R')

cobertura_concepto <- function(concepto_iri) {
  q <- sprintf('
PREFIX : <http://icfes.matematicas.edu.co/ontologia#>
SELECT (COUNT(?ej) AS ?n) WHERE {
  ?ej a :Ejercicio ; :cubreConcepto :%s .
}', concepto_iri)
  sparql_query(q)
}

df <- cobertura_concepto('CONCEPTO')
if (!is.null(df)) cat('Ejercicios existentes para CONCEPTO:', df\$n, '\n')
"
```

### 4. Reportar al usuario

Antes de generar el ejercicio, informar:

```
📚 Análisis ontológico de [CONCEPTO]:
- Prerequisitos: [lista o "ninguno registrado"]
- Ejercicios existentes: [N]
- Recomendación: [si N < 2, este concepto tiene baja cobertura]
```

Si el concepto tiene prerequisitos con CERO ejercicios, sugerir:
> "El concepto [X] es prerequisito de [CONCEPTO] pero no tiene ejercicios. Considera generar uno primero."

## Mapeo de conceptos a IRIs

| Concepto mencionado | IRI local |
|---------------------|-----------|
| función logarítmica / logaritmo | `FuncionLogaritmica` |
| función exponencial | `FuncionExponencial` |
| función cuadrática | `FuncionCuadratica` |
| función lineal | `FuncionLineal` |
| probabilidad condicional | `ProbabilidadCondicional` |
| teorema de Bayes | `TeoremaBayes` |
| cuartiles | `Cuartiles` |
| diagrama de caja / boxplot | `DiagramaCaja` |
| mediana | `Mediana` |
| media / promedio | `Media` |
| trigonometría | `Trigonometria` |
| teorema de Pitágoras | `TeoremaPitagoras` |
| distribución normal | `DistribucionNormal` |

## Integración con generación de ejercicios

Este skill debe ejecutarse:
1. ANTES de `/generar-schoice`
2. ANTES de `/generar-cloze`
3. Cuando el usuario dice "genera un ejercicio sobre [concepto]"

El resultado informa el nivel de dificultad recomendado (si hay muchos ejercicios fáciles, generar uno más difícil).
