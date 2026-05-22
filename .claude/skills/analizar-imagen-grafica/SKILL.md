---
name: analizar-imagen-grafica
description: >
  Analiza imágenes matemáticas de problemas ICFES y extrae información estructurada.
  Identifica tipos de gráficos, valores numéricos, símbolos y estilos visuales como base para generación de código.
  Usa con "analizar imagen", "extraer datos del gráfico", "qué hay en esta imagen", "describir figura ICFES".
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
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas y la imagen a analizar como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Analisis Visual Matematico

## Decision Tree

```
Imagen recibida?
    |
    +-> NO: Solicitar imagen al usuario
    |
    +-> SI: Clasificar contenido
            |
            +-> Geometria -> Extraer figuras, medidas, angulos
            +-> Estadistica -> Extraer datos, categorias, valores
            +-> Calculo -> Extraer funciones, puntos clave
            +-> Trigonometria -> Extraer angulos, funciones
            +-> Algebra -> Extraer ecuaciones, regiones
                 |
                 +-> Generar reporte estructurado
                 |
                 +-> Determinar requisitos tecnicos
```

## Proceso paso a paso

### PASO 1: Observacion inicial

1. Identificar tipo de imagen matematica
2. Determinar proposito educativo
3. Evaluar complejidad general

### PASO 2: Analisis sistematico

1. Examinar ejes y sistema de coordenadas
2. Identificar todas las curvas y figuras
3. Extraer valores numericos visibles
4. Reconocer anotaciones y texto
5. Catalogar colores y estilos

### PASO 3: Extraccion de datos

Ver [clasificacion de contenido](references/clasificacion-contenido.md) para:

- Tipos de contenido matematico
- Elementos a extraer por categoria
- Simbolos y notacion comunes

### PASO 4: Evaluacion tecnica

Determinar requisitos para cada lenguaje:

- TikZ: paquetes, comandos especiales
- Python: librerias, funciones especificas
- R: paquetes, geoms necesarios

### PASO 5: Generar reporte

Ver [plantilla de reporte](references/plantilla-reporte.md) para:

- Formato estructurado de salida
- Secciones obligatorias
- Niveles de complejidad

## Notacion matematica comun

| Simbolo | LaTeX | Uso |
|---------|-------|-----|
| sqrt | `\sqrt{x}` | Raiz cuadrada |
| frac | `\frac{a}{b}` | Fraccion |
| alpha | `\alpha` | Variable griega |
| int | `\int` | Integral |
| sum | `\sum` | Sumatoria |

## Mejores practicas

1. **Precision**: Extraer valores numericos exactos
2. **Completitud**: No omitir elementos visibles
3. **Contexto**: Considerar proposito educativo
4. **Verificacion**: Validar coherencia de datos
5. **Documentacion**: Anotar ambiguedades

## Referencias

- [Clasificacion de contenido](references/clasificacion-contenido.md) - Tipos y elementos
- [Plantilla de reporte](references/plantilla-reporte.md) - Formato de salida
- Regla: .claude/rules/flujo-b-obligatorio.md

## Integracion con otros skills

```
Usuario comparte imagen
    |
    +-> analizar-imagen-grafica <- ESTE SKILL
            |
            +-> (genera reporte estructurado)
            |
            v
    generar-codigo-tikz/python/r
            |
            +-> (usa reporte como entrada)
```
