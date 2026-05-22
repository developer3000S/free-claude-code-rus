---
name: comparar-similitud-visual
description: >
  Compara imagenes generadas con originales usando vision por computadora.
  Calcula similitud cuantitativa (0-100 puntos) en 6 categorias y genera reportes con correcciones priorizadas.
  Usa con "comparar imagenes", "similitud visual", "que tan parecido quedo", "evaluar grafico generado".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere capacidades de vision de Claude. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Bash(ls:*)
  - Bash(magick:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas y las rutas de ambas imagenes (original y generada) como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Comparacion Visual Inteligente

## Decision Tree

```
Imagen generada lista?
    |
    +-> NO: Renderizar primero (exams2pdf, pdflatex, etc.)
    |
    +-> SI: Cargar ambas imagenes (original + generada)
            |
            +-> Analisis global (tipo: funcion, geometria, estadistica)
            |
            +-> Analisis por 6 categorias
            |    +-> Colores (20 pts)
            |    +-> Posiciones (20 pts)
            |    +-> Valores (20 pts)
            |    +-> Proporciones (15 pts)
            |    +-> Estilos (15 pts)
            |    +-> Elementos (10 pts)
            |
            +-> Calcular puntuacion total
                 |
                 +-> >= 95: Validar
                 +-> 85-94: Considerar validar/iterar
                 +-> 70-84: Iterar
                 +-> < 70: Iterar o regenerar
```

## Proceso paso a paso

### PASO 1: Cargar imagenes

```bash
# Verificar que existen ambas imagenes
ls imagen_original.png imagen_generada.png
```

### PASO 2: Analisis global

Identificar tipo de contenido:

- Funcion matematica
- Geometria
- Estadistica (barras, dispersion, etc.)

### PASO 3: Analisis por categoria

Ver [categorias de analisis](references/categorias-analisis.md) para:

- Que detectar en cada categoria
- Como evaluar diferencias
- Que correcciones sugerir

### PASO 4: Calcular puntuacion

Ver [sistema de puntuacion](references/sistema-puntuacion.md) para:

- Criterios de evaluacion por categoria
- Calculo de distancia RGB, diferencias porcentuales
- Formato JSON de metricas

### PASO 5: Generar reporte

Ver [formato de reporte](references/formato-reporte.md) para:

- Plantilla estandar de comparacion
- Seccion de priorizacion de correcciones
- Historial de similitud

### PASO 6: Decidir accion

| Puntuacion | Recomendacion |
|------------|---------------|
| 95-100 | Validar - Listo para produccion |
| 85-94 | Considerar validar o iterar |
| 70-84 | Iterar - Necesita refinamiento |
| < 70 | Iterar o regenerar |

## Mejores Practicas

1. **Ser especifico**: No "color mal", sino "#0055BB deberia ser #0066CC"
2. **Priorizar**: Separar errores criticos de mejoras menores
3. **Ser constructivo**: Proporcionar siempre correccion concreta
4. **Contextualizar**: Explicar impacto de cada diferencia
5. **Ser sistematico**: Seguir proceso completo

## Activacion

Esta skill se activa:

- Despues de cada generacion de codigo grafico
- Con el comando `/comparar`
- Cuando el usuario solicita validacion visual

## Salida

1. Reporte estructurado en markdown
2. Metricas cuantitativas (JSON)
3. Actualizacion de workflow_state.json
4. Correcciones priorizadas por impacto

## Referencias

- [Sistema de puntuacion](references/sistema-puntuacion.md) - 6 categorias, 0-100 pts
- [Categorias de analisis](references/categorias-analisis.md) - Que detectar y corregir
- [Formato de reporte](references/formato-reporte.md) - Plantilla estandar
- Esquema JSON: .claude/schemas/metricas_similitud.schema.json
- Regla: .claude/rules/ciclo-validacion.md

## Integracion con otros skills

```
auto-refinar-grafico -> comparar-similitud-visual -> validar-renderizado
                             |
                             +-> workflow_state.json (actualiza similitud)
```
