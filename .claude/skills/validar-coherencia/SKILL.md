---
name: validar-coherencia
description: >
  Ejecuta FASE 2 del Ciclo de Validacion - Validacion Visual y Funcional.
  Verifica 4 tipos de coherencia: matematica, imagen-texto, codigo, metadatos.
  Usa cuando renderizado pasa FASE 1 o necesites verificar sincronizacion.
  Detecta ERR_C1-C5 (coherencia) antes de diagnostico en FASE 3.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0). Linux/macOS.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: haiku
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(Rscript:*)
  - Bash(grep:*)
---

> **ROUTING**: Este skill tiene `model_recommendation: haiku`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="haiku")` pasando las instrucciones completas y la ruta del archivo .Rmd como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Validacion de Coherencia Visual y Funcional (FASE 2)

## Decision Tree

```
Archivo .Rmd paso FASE 1?
    |
    +-> NO: Ejecutar validar-renderizado primero
    |
    +-> SI: Validar 4 tipos de coherencia
            |
            +-> Coherencia Matematica (ERR_C1)
            |    +-> Formulas correctas?
            |    +-> exsolution coincide con calculo?
            |
            +-> Coherencia Imagen-Texto (ERR_C2)
            |    +-> Variables sincronizadas R <-> TikZ?
            |    +-> Valores en texto = valores en grafico?
            |
            +-> Coherencia Codigo (ERR_C3)
            |    +-> Funciones sobre numeros (no strings)?
            |    +-> Variables definidas antes de usar?
            |
            +-> Coherencia Metadatos (ERR_C4)
                 +-> 6 dimensiones ICFES presentes?
                 +-> exsolution formato correcto?
```

## Contexto: Ciclo de Validacion

```
FASE 1: validar-renderizado (HTML, PDF, DOCX, NOPS)
    |
FASE 2: validar-coherencia <- ESTE SKILL
    |
FASE 3: diagnosticar-errores (si hay errores)
    |
promover-ejercicio (si todo OK)
```

## Proceso paso a paso

### PASO 1: Verificar que FASE 1 paso

El archivo debe renderizar en 4 formatos sin errores criticos.

### PASO 2: Ejecutar validacion de coherencia

Run `scripts/validar-coherencia.R --help` first, then:

```bash
Rscript .claude/skills/validar-coherencia/scripts/validar-coherencia.R archivo.Rmd
```

### PASO 3: Analizar resultados

El script verifica automaticamente:

- Metadatos obligatorios (exname, extype, exsolution, exshuffle)
- Metadatos ICFES (6 dimensiones)
- exsolution vs Answerlist (longitud coincide)
- Funciones matematicas sobre strings
- Variables TikZ hardcodeadas

### PASO 4: Decidir siguiente accion

- **Si todo OK**: Aprobar para produccion
- **Si hay errores**: Continuar a FASE 3 (diagnosticar-errores)

## Los 4 Tipos de Coherencia

Ver [tipos de coherencia](references/tipos-coherencia.md) para:

- Checklists detallados por tipo
- Ejemplos de errores comunes
- Patrones de deteccion

### Resumen rapido

| Tipo | Codigo | Que verifica |
|------|--------|--------------|
| Matematica | ERR_C1 | Formulas, calculos, exsolution |
| Imagen-Texto | ERR_C2 | Sincronizacion R <-> TikZ/grafico |
| Codigo | ERR_C3 | Funciones sobre numeros, orden variables |
| Metadatos | ERR_C4 | ICFES 6 dimensiones, exsolution formato |

## Errores comunes detectados

### Variables TikZ hardcodeadas (ERR_C2)

Incorrecto:

```latex
\def\radio{3}   % Hardcodeado
```

Correcto:

```r
tikz_code <- paste0("\\def\\radio{", radio_cilindro, "}")
```

### Funcion sobre string (ERR_C3)

Incorrecto:

```r
b_formateado <- sprintf("%.1f", b)
resultado <- abs(b_formateado)  # Error: abs sobre string
```

Correcto:

```r
b_abs <- abs(b)  # abs sobre numero
b_formateado <- sprintf("%.1f", b_abs)
```

### exsolution desincronizado (ERR_C4)

Incorrecto:

```yaml
exsolution: 1  # Debe ser binario
```

Correcto:

```yaml
exsolution: 10000  # 5 opciones, 1ra correcta
```

## Condiciones criticas

### Pre-validacion

- Archivo paso FASE 1 (renderiza en 4 formatos)
- Acceso al archivo .Rmd

### Durante validacion

- Verificar los 4 tipos de coherencia
- Documentar todos los errores encontrados

### Post-validacion

- Si hay errores: Continuar a FASE 3
- Si todo OK: Aprobar para produccion

## Referencias

- [Tipos de coherencia](references/tipos-coherencia.md) - Checklists detallados
- Ciclo Validacion: .claude/rules/ciclo-validacion.md
- Codigo .Rmd: .claude/rules/codigo-rmd.md
- Metadatos ICFES: .claude/skills/analizar-icfes/SKILL.md

## Integracion con otros skills

```
validar-renderizado (FASE 1)
    |
validar-coherencia (FASE 2) <- ESTE SKILL
    |
diagnosticar-errores (FASE 3)
    |
promover-ejercicio
```
