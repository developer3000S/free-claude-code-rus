---
name: corregir-graficos
description: >
  Ejecuta SUBFASE 3A para errores graficos. Aplica correcciones especificas para ERR_G1-G4
  basandose en ejemplos funcionales. Requiere revalidacion despues de cada correccion.
  Usa cuando hay errores de graficos en renderizado, "corregir grafico", "fix error visual", "ERR_G1".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R-exams, TikZ o Python/matplotlib. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash(ls:*)
  - Bash(grep:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas, el archivo .Rmd y el tipo de error gráfico (ERR_G1-G4) como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# SUBFASE 3A - Correccion de Errores Graficos

## Decision Tree

```
Error grafico detectado?
    |
    +-> ERR_G1 (File not found) -> Renderizado condicional
    |
    +-> ERR_G2 (Solapamiento) -> Ajustar posiciones/margenes
    |
    +-> ERR_G3 (Distorsion) -> Verificar sintaxis/paquetes
    |
    +-> ERR_G4 (Tamano) -> Ajustar escala/dimensiones
         |
         +-> Consultar ejemplos funcionales
         |
         +-> Aplicar correccion
         |
         +-> SUBFASE 3B: Revalidar (volver a FASE 1)
              |
              +-> Corregido? SI -> SUBFASE 3C: Documentar
              +-> Corregido? NO -> Repetir ciclo
```

## Proceso paso a paso

### PASO 0: Consultar ejemplos funcionales (OBLIGATORIO)

```bash
ls /A-Produccion/Ejemplos-Funcionales-Rmd/

grep -l "include_tikz" /A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd

grep -l "is_latex_output" /A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
```

### PASO 1: Identificar tipo de error

Revisar mensaje de error para clasificar:

- ERR_G1: `File '*.png' not found`
- ERR_G2: Elementos superpuestos visualmente
- ERR_G3: Colores/formas incorrectas
- ERR_G4: Tamano desproporcionado

### PASO 2: Localizar chunk problematico

Buscar en el archivo .Rmd:

- Chunks con `include_tikz()`
- Chunks con `include_graphics()`
- Codigo TikZ directo

### PASO 3: Aplicar correccion

Ver [tipos de errores graficos](references/tipos-errores-graficos.md) para:

- Patron de correccion por tipo de error
- Codigo antes/despues
- Soluciones para TikZ, Python, R

### PASO 4: SUBFASE 3B - Revalidar

```
OBLIGATORIO: Volver automaticamente a FASE 1
-> Ejecutar validar-renderizado
-> Ejecutar validar-coherencia
-> Verificar que error esta resuelto
-> REPETIR si persisten errores
```

### PASO 5: SUBFASE 3C - Documentar (solo si exito)

1. Documentar en `patrones-errores-conocidos.md`
2. Incluir ejemplo funcional utilizado
3. Registrar codigo antes/despues

## Condiciones criticas

- NO terminar con errores graficos sin resolver
- SIEMPRE consultar ejemplos funcionales ANTES de corregir
- SIEMPRE ejecutar SUBFASE 3B despues de correcciones
- Ejemplos funcionales = Fuente de verdad ABSOLUTA

## Referencias

- [Tipos de errores graficos](references/tipos-errores-graficos.md) - ERR_G1-G4
- Fuente de verdad: `/A-Produccion/Ejemplos-Funcionales-Rmd/`
- Documentacion: `.claude/docs/patrones-errores-conocidos.md`
- Skill relacionado: corregir-error-imagen (ERR_G1 especifico)

## Integracion con Ciclo de Validacion

```
diagnosticar-errores
    |
    +-> Detecta ERR_G (grafico)
    |
    v
corregir-graficos <- ESTE SKILL
    |
    +-> SUBFASE 3A: Aplica correccion
    |
    v
validar-renderizado (FASE 1)
    |
    +-> SUBFASE 3B: Revalida
    |
    +-> Si corregido -> SUBFASE 3C: Documenta
    +-> Si falla -> Repetir correccion
```
