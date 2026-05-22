---
name: refinar-codigo-grafico
description: >
  Refina codigo grafico generado basandose en reportes de comparacion visual.
  Aplica correcciones especificas mientras mantiene calidad. Itera hasta alcanzar similitud >=95%.
  Usa con "refinar grafico", "mejorar similitud", "iterar codigo visual", "ajustar grafico generado".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere TikZ, Python matplotlib, o R ggplot2. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(pdflatex:*)
  - Bash(python:*)
  - Bash(Rscript:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas y las rutas de archivos como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Refinamiento Iterativo de Codigo Grafico

## Decision Tree

```
Reporte de comparacion disponible?
    |
    +-> NO: Ejecutar /comparar-similitud-visual primero
    |
    +-> SI: Analizar correcciones
            |
            +-> Clasificar por prioridad (Alta, Media, Baja)
            |
            +-> Aplicar cambios al codigo
            |    +-> Colores
            |    +-> Posiciones
            |    +-> Valores numericos
            |    +-> Estilos
            |    +-> Elementos faltantes/extra
            |
            +-> Re-renderizar
            |
            +-> Similitud >= 95%?
                 |
                 +-> SI: Solicitar aprobacion usuario
                 +-> NO: Repetir ciclo
```

## Principios basicos

1. **Preservacion**: No romper lo que funciona
2. **Focalizacion**: Corregir solo lo identificado
3. **Incremental**: Cambios graduales
4. **Validacion**: Verificar cada cambio
5. **Documentacion**: Registrar modificaciones

## Proceso paso a paso

### PASO 1: Analisis del reporte

- Leer reporte de comparacion completo
- Identificar correcciones por prioridad
- Verificar factibilidad

### PASO 2: Aplicar correcciones

Ver [patrones de correccion](references/patrones-correccion.md) para:

- Correcciones de colores (RGB, hex)
- Correcciones de posiciones (coordenadas)
- Correcciones de rangos (ejes)
- Correcciones de estilos (lineas)
- Anadir/eliminar elementos

### PASO 3: Validar y re-renderizar

```bash
# TikZ
pdflatex output_tikz.tex

# Python
python output_python.py

# R
Rscript output_r.R
```

### PASO 4: Comparar nuevamente

Ver [proceso de iteracion](references/proceso-iteracion.md) para:

- Criterios de detencion
- Limites practicos
- Patrones de refinamiento exitoso

## Criterios de detencion

| Condicion | Accion |
|-----------|--------|
| Similitud >= 95% | Solicitar aprobacion |
| Similitud 90-94% | Evaluar si continuar |
| Similitud < 90% | Continuar iterando |
| 10 iteraciones sin progreso | Reevaluar enfoque |

## Mejores practicas

1. No cambiar todo a la vez
2. Validar frecuentemente
3. Mantener backup de versiones
4. Comentar cambios significativos
5. Priorizar matematica sobre estetica

## Referencias

- [Patrones de correccion](references/patrones-correccion.md) - Codigo por tipo de correccion
- [Proceso de iteracion](references/proceso-iteracion.md) - Flujo sistematico
- Regla: .claude/rules/graficador-secuencial.md

## Integracion con otros skills

```
comparar-similitud-visual -> refinar-codigo-grafico <- ESTE SKILL
    |
    +-> (ciclo hasta >=95%)
    |
    +-> generar-schoice/cloze
```
