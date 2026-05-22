---
name: diagnosticar-errores
description: >
  Ejecuta FASE 3 del Ciclo de Validacion - Diagnostica errores, clasifica por categoria,
  activa SUBFASE 3A (correccion ejemplos), SUBFASE 3B (revalidacion FASE 1).
  Usa automaticamente cuando FASE 1 o FASE 2 detectan errores, o cuando compilacion falla.
  Loop hasta resolver TODOS los errores.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0), paquete exams. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash(Rscript:*)
  - Bash(grep:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: sonnet`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="sonnet")` pasando las instrucciones completas, el archivo .Rmd problemático y los mensajes de error como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Diagnosticador de Errores R/exams - FASE 3

## Decision Tree

```
Error reportado
    |
    +-> Contiene "File.*png.*not found"?
    |    +-> SI: ERR_G1 (Graficas no visualizadas)
    |
    +-> Contiene "LaTeX Error" o "! Undefined"?
    |    +-> SI: ERR_T1 (LaTeX no compila)
    |
    +-> Contiene "object.*not found"?
    |    +-> SI: ERR_C3 (Variable R no definida)
    |
    +-> Contiene "non-numeric argument"?
    |    +-> SI: ERR_C3 (Operacion con string)
    |
    +-> Contiene "cloze.*not supported"?
    |    +-> SI: ERR_S5 (CLOZE incompatible NOPS - esperado)
    |
    +-> NO coincide: Analizar archivo .Rmd
         +-> Falta exname? -> ERR_T3
         +-> Answerlist < 4? -> ERR_S1
         +-> Gaps no secuenciales? -> ERR_S4
```

## Contexto: Ciclo de Validacion

```
FASE 1: validar-renderizado
    |
FASE 2: validar-coherencia
    |
FASE 3: diagnosticar-errores <- ESTE SKILL
    |
    +-> Sin errores -> promover-ejercicio
    |
    +-> Con errores:
            +-> SUBFASE 3A: Correccion basada en ejemplos
            +-> SUBFASE 3B: Revalidacion (volver FASE 1)
            +-> SUBFASE 3C: Documentar solucion (si exito)
```

## Proceso paso a paso

### PASO 1: Recibir errores

Input de FASE 1 y/o FASE 2:

- Lista de errores por formato (HTML, PDF, DOCX, NOPS)
- Incoherencias detectadas
- Mensajes de error completos

### PASO 2: Clasificar errores

Run `scripts/diagnosticar-error.R --help` first, then:

```bash
Rscript .claude/skills/diagnosticar-errores/scripts/diagnosticar-error.R archivo.Rmd "mensaje_error"
```

Ver [categorias de errores](references/categorias-errores.md) para lista completa.

### PASO 3: Priorizar

Orden de prioridad:

1. CRITICA (bloquea todo)
2. ALTA (bloquea formatos principales)
3. MEDIA (afecta calidad)
4. BAJA (opcional/esperado)

### PASO 4: SUBFASE 3A - Correccion basada en ejemplos

OBLIGATORIO consultar ejemplos funcionales ANTES de corregir:

```bash
ls /A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
grep -l "[patron_similar]" /A-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
```

Copiar patron exacto del ejemplo funcional. NO improvisar.

Ver [patrones comunes](references/patrones-comunes.md) para soluciones verificadas.

### PASO 5: SUBFASE 3B - Revalidacion OBLIGATORIA

SIEMPRE volver a FASE 1 despues de aplicar correcciones:

```bash
Rscript .claude/skills/generar-schoice/scripts/validar-renderizado.R ejercicio.Rmd
```

Si errores persisten -> volver a SUBFASE 3A con solucion alternativa.

### PASO 6: SUBFASE 3C - Documentar (solo si exito)

Solo despues de revalidacion 100% exitosa.
Agregar a .claude/docs/patrones-errores-conocidos.md

## Condiciones criticas

### Pre-diagnostico

- Recibir lista completa de errores de FASE 1/FASE 2
- Tener archivo .Rmd accesible
- Acceso a /A-Produccion/Ejemplos-Funcionales-Rmd/

### Durante diagnostico

- Clasificar TODOS los errores
- Priorizar por nivel critico
- SIEMPRE consultar ejemplos funcionales ANTES de corregir
- Aplicar soluciones basadas en ejemplos, NO improvisar

### Post-correccion

- SIEMPRE ejecutar SUBFASE 3B (revalidacion)
- NUNCA marcar "completado" si quedan errores
- Si errores persisten -> volver a SUBFASE 3A
- Solo si exito 100% -> SUBFASE 3C (documentar)

Regla Absoluta: LOOP hasta exito total.

## Referencias

- [Categorias de errores](references/categorias-errores.md) - ERR_G, ERR_T, ERR_S, ERR_C
- [Patrones comunes](references/patrones-comunes.md) - Soluciones verificadas
- Ciclo Validacion: .claude/rules/ciclo-validacion.md
- Patrones Errores: .claude/docs/patrones-errores-conocidos.md
- Ejemplos Funcionales: /A-Produccion/Ejemplos-Funcionales-Rmd/

## Integracion con otros skills

```
validar-renderizado (FASE 1)
    |
validar-coherencia (FASE 2)
    |
diagnosticar-errores (FASE 3) <- ESTE SKILL
    |
    +-> corregir-graficos (si ERR_G*)
    +-> manual-edit (otros errores)
    +-> promover-ejercicio (si exito)
```
