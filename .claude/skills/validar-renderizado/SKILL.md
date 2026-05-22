---
name: validar-renderizado
description: >
  Ejecuta FASE 1 del Ciclo de Validacion - Renderiza en 4 formatos (HTML, PDF, DOCX, NOPS).
  Usa automaticamente despues de generar/modificar archivo .Rmd, cuando hay errores de compilacion,
  o necesites validar que ejercicio renderiza correctamente en todos los formatos.
  Captura TODOS los errores y continua a FASE 2.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0), tinytex, paquete exams. Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: haiku
allowed-tools:
  - Read
  - Write
  - Bash(Rscript:*)
  - Bash(ls:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: haiku`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="haiku")` pasando las instrucciones completas y la ruta del archivo .Rmd como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Validador de Renderizado R/exams - FASE 1

## Decision Tree

```
Archivo .Rmd listo?
    |
    +-> NO: Usar /generar-schoice o /generar-cloze primero
    |
    +-> SI: Ejecutar validacion en 4 formatos
            |
            +-> HTML (debugging rapido)
            +-> PDF (formato principal)
            +-> DOCX (revision)
            +-> NOPS (escaneable)
                 |
                 +-> Todos OK? -> FASE 2 (validar-coherencia)
                 +-> Errores? -> FASE 3 (diagnosticar-errores)
```

## Contexto: Ciclo de Validacion

```
FASE 1: validar-renderizado <- ESTE SKILL
    |
FASE 2: validar-coherencia
    |
FASE 3: diagnosticar-errores
    |
promover-ejercicio
```

## Los 4 Formatos Obligatorios

| Formato | Funcion | Uso |
|---------|---------|-----|
| HTML | exams2html() | Debugging rapido |
| PDF | exams2pdf() | Formato principal |
| DOCX | exams2pandoc(type="docx") | Revision |
| NOPS | exams2nops() | Escaneable |

## Proceso paso a paso

### PASO 1: Ejecutar script de validacion

Run `scripts/validar-renderizado.R --help` first, then:

```bash
Rscript .claude/skills/generar-schoice/scripts/validar-renderizado.R archivo.Rmd
```

### PASO 2: Analizar resultados

El script reporta:

- [HTML] OK / ERROR: mensaje
- [PDF] OK / ERROR: mensaje
- [DOCX] OK / ERROR: mensaje
- [NOPS] OK / ERROR: mensaje

### PASO 3: Decidir siguiente accion

- **4/4 OK**: Continuar a FASE 2 (validar-coherencia)
- **3/4 OK + NOPS falla**: Si es CLOZE con num/string, esperado
- **Errores criticos**: Continuar a FASE 3 (diagnosticar-errores)

## Ejecucion manual en R

Si necesitas mas control:

```r
library(exams)

# HTML
exams2html("archivo.Rmd", n = 1, encoding = "UTF-8")

# PDF
exams2pdf("archivo.Rmd", n = 1, encoding = "UTF-8")

# DOCX
exams2pandoc("archivo.Rmd", n = 1, type = "docx", encoding = "UTF-8")

# NOPS
exams2nops("archivo.Rmd", n = 1, encoding = "UTF-8")
```

## Errores comunes en FASE 1

| Error | Formato afectado | Causa probable |
|-------|------------------|----------------|
| `LaTeX Error: File 'tikz.sty' not found` | PDF, NOPS | Falta header-includes |
| `File 'grafico.png' not found` | Todos | include_supplement() faltante |
| `invalid multibyte` | Todos | encoding incorrecto |
| `cloze not supported` | NOPS | CLOZE con num/string (esperado) |

Ver mas en: .claude/skills/diagnosticar-errores/references/categorias-errores.md

## Condiciones criticas

### Pre-validacion

- Archivo .Rmd existe y es accesible
- R y paquete exams instalados
- tinytex instalado (para PDF)

### Durante validacion

- Capturar TODOS los errores (no abortar en primero)
- Registrar warnings tambien
- Generar reporte detallado

### Post-validacion

- Si 4/4 OK: Continuar a FASE 2
- Si errores: Continuar a FASE 3 (NO terminar aqui)

## Referencias

- Script validacion: .claude/skills/generar-schoice/scripts/validar-renderizado.R
- Ciclo Validacion: .claude/rules/ciclo-validacion.md
- Errores conocidos: .claude/docs/patrones-errores-conocidos.md

## Integracion con otros skills

```
generar-schoice / generar-cloze
    |
validar-renderizado (FASE 1) <- ESTE SKILL
    |
validar-coherencia (FASE 2)
    |
diagnosticar-errores (FASE 3)
    |
promover-ejercicio
```
