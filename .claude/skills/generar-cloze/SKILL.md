---
name: generar-cloze
description: >
  Genera ejercicio R-exams tipo CLOZE (pregunta compuesta) METACOGNITIVO.
  TODO ejercicio CLOZE DEBE aplicar Progressive Disclosure con minimo 4 partes.
  Usa cuando el analisis ICFES indica tipo cloze, necesites pregunta con multiples partes,
  o quieras combinar opciones multiples + respuestas numericas en un solo ejercicio.
  SIEMPRE consulta ejemplos funcionales ANTES de generar codigo.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere R (>= 4.0), tinytex, paquetes exams y tidyverse. Linux/macOS.
metadata:
  author: alvaretto
  version: "4.0"
  language: es
  model_recommendation: opus
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash(ls:*)
  - Bash(mkdir:*)
  - Bash(Rscript:*)
---

# Generador de Ejercicios CLOZE Metacognitivos

## REGLA CRÍTICA

**⚠️ TODO ejercicio CLOZE DEBE ser metacognitivo con Progressive Disclosure de minimo 4 partes.**

Ver regla completa: `.claude/rules/ejercicios-metacognitivos.md`

## Decision Tree

```
User task -> Tiene analisis ICFES?
    |-- No -> Ejecutar /analizar-icfes primero
    +-- Si -> Tipo = cloze confirmado?
        |-- No -> Usar /generar-schoice
        +-- Si -> Definir estructura Progressive Disclosure
            |-- Parte 1: schoice (Identificar error)
            |-- Parte 2: num (Calcular correcto)
            |-- Parte 3: mchoice (Evaluar afirmaciones)
            +-- Parte 4: schoice V/F (Transferir)
            +-- Consultar ejemplos funcionales similares
                 +-- Generar .Rmd con nomenclatura oficial
                    +-- Validar: Rscript scripts/validar-renderizado.R
```

## Cuando usar CLOZE vs SCHOICE

**Usa CLOZE cuando:** problema requiere multiples niveles cognitivos en secuencia, necesitas Progressive Disclosure completo, hay varios pasos a responder por separado, nivel 3 o 4, competencia = Argumentacion.

**Usa SCHOICE cuando:** solo hay 1 aspecto a evaluar, nivel 1 o 2 (pero siempre metacognitivo).

## Proceso paso a paso

### PASO 0: Definir estructura Progressive Disclosure (OBLIGATORIO)

Ver [estructura-progressive-disclosure.md](references/estructura-progressive-disclosure.md) para la secuencia de 4 partes, tabla de tipos de gap y plantilla obligatoria del Question.

### PASO 1: Verificar analisis ICFES

Confirmar: Nivel, Competencia, Componente, Tipo = cloze.

### PASO 2: Consultar ejemplos funcionales METACOGNITIVOS (Búsqueda Inteligente)

NUNCA generar código sin consultar ejemplos primero. Buscar en **orden de prioridad**:

**Prioridad 1 — Ejercicios CLOZE recientes completados**:
```bash
# Buscar .Rmd CLOZE metacognitivos más recientes en producción y desarrollo
ls -t A-Produccion/03-En-Produccion/**/*metacognitivo*cloze*.Rmd 2>/dev/null | head -3
ls -t A-Produccion/02-En-Desarrollo/**/*metacognitivo*cloze*.Rmd 2>/dev/null | head -3
```

Solo considerar archivos que tengan `ejercicio_state.json` con `aprobacion_usuario.completado = true` o que estén en `03-En-Produccion/`.

**Prioridad 2 — Ejemplos canónicos**:
```bash
cat A-Produccion/03-En-Produccion/.../promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd
ls A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/*cloze*.Rmd
```

**Protocolo**: Leer al menos 1 ejemplo de Prioridad 1 (si existe) + 1 de Prioridad 2. Copiar patrones del más reciente, validar contra el canónico.

### PASO 3: Definir pool de errores conceptuales (OBLIGATORIO)

Minimo 4-6 errores con codigos, descripciones, causa_raiz y funciones `calcula()` deterministicas.

Ver [pool-errores-afirmaciones.md](references/pool-errores-afirmaciones.md) para estructura completa del pool de errores (Parte 1).

### PASO 4: Definir pool de afirmaciones (OBLIGATORIO para Parte 3)

Minimo 6 afirmaciones verdaderas + 6 falsas basadas en errores conceptuales reales.

Ver [pool-errores-afirmaciones.md](references/pool-errores-afirmaciones.md) para estructura del pool de afirmaciones.

### PASO 5: Definir pool de enunciados V/F (OBLIGATORIO para Parte 4)

Minimo 4 enunciados usando datos concretos del contexto generado.

Ver [pool-errores-afirmaciones.md](references/pool-errores-afirmaciones.md) para estructura del pool V/F.

### PASO 6: Generar nombre con nomenclatura

Formato: `[ejercicio]_metacognitivo_[competencia]_n[nivel]_cloze_v[version].Rmd`

`metacognitivo` y `cloze` son OBLIGATORIOS en el nombre. Nivel minimo: n3. Ver: `.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md`

### PASO 7: Crear carpeta e inicializar estado

```bash
mkdir -p A-Produccion/02-En-Desarrollo/[nombre_ejercicio]
.claude/scripts/workflow-state.sh init A-Produccion/02-En-Desarrollo/[nombre_ejercicio] --tipo cloze --nombre "[nombre_ejercicio]"
.claude/scripts/workflow-state.sh complete A-Produccion/02-En-Desarrollo/[nombre_ejercicio] analisis_icfes
.claude/scripts/workflow-state.sh complete A-Produccion/02-En-Desarrollo/[nombre_ejercicio] flujo_b --requerido [true|false]
```

### PASO 8: Generar codigo .Rmd CLOZE METACOGNITIVO

Ver [anatomia CLOZE](references/anatomia-cloze.md) para estructura de GAPS y [anatomia metacognitiva](references/anatomia-metacognitiva.md) para secciones obligatorias.

Estructura Solution obligatoria: Analisis del Error → Procedimiento Correcto → Propiedades del Concepto → Caso Especifico → Reflexion Metacognitiva.

```bash
.claude/scripts/workflow-state.sh complete <dir> generacion_rmd --archivo "[nombre].Rmd"
```

### PASO 9: Retroalimentación científica (workflow paso 4)

Ejecutar `/skill-retroalimentacion` para generar la sección Solution con justificación matemática y análisis diagnóstico de cada opción.

```bash
.claude/scripts/workflow-state.sh complete <dir> retroalimentacion
```

### PASO 10: Renderizado 4 formatos (workflow paso 5)

```bash
Rscript -e 'library(exams); exams2html("[archivo].Rmd", n=1, dir="salida")'
Rscript -e 'library(exams); exams2pdf("[archivo].Rmd", n=1, dir="salida")'
Rscript -e 'library(exams); exams2pandoc("[archivo].Rmd", n=1, type="docx", dir="salida")'
Rscript -e 'library(exams); exams2nops("[archivo].Rmd", n=1, dir="salida")'
```

NOPS fallará si hay gaps tipo num/string — esto es ESPERADO, no es error.

```bash
.claude/scripts/workflow-state.sh complete <dir> renderizado_4_formatos
```

### PASO 11: Arsenal post-render (workflow paso 6, AUTOMÁTICO)

El hook `post-exams2-validation.sh` ejecuta automáticamente FASES 2A-2H (validación matemática, preview visual, multi-semilla). No requiere acción manual.

```bash
.claude/scripts/workflow-state.sh complete <dir> arsenal_post_render
```

### PASO 12: Detractor FASE 2C (workflow paso 7, OBLIGATORIO)

Ejecutar `/adversario [archivo.Rmd]`. Revisa 8 dominios: código, pedagógico, visual, gramática, matemático, metacognitivo, testing, semántico.

- Si veredicto = RECHAZAR → corregir → volver a PASO 10
- Si veredicto = APROBAR CON CAMBIOS → aplicar → volver a PASO 10
- Si veredicto = APROBAR → continuar

```bash
.claude/scripts/workflow-state.sh complete <dir> detractor_fase2c --veredicto "[APROBAR|RECHAZAR]"
```

### PASO 13: Documentar 5 coherencias (workflow paso 8)

Verificar y documentar con checklist:
- [ ] Semántica: gramática, tildes, redacción ICFES
- [ ] Visual-Texto: gráfico coincide con enunciado
- [ ] Matemática: fórmulas, cálculos, distractores plausibles
- [ ] Código: elementos dinámicos, compatibilidad 4 formatos
- [ ] General: legibilidad, estilo ICFES, opciones visibles

```bash
.claude/scripts/workflow-state.sh complete <dir> coherencias_5
```

### PASO 14: Validar diversidad (workflow paso 9)

Ejecutar `/validar-diversidad`. Requiere 250+ versiones únicas de 300 intentos.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_diversidad --versiones_unicas [N]
```

### PASO 15: Validar ICFES (workflow paso 10)

Ejecutar `/validar-icfes`. Verifica estructura R-exams, metadatos ICFES (6 dimensiones), exsolution y exshuffle.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_icfes
```

### PASO 16: Aprobación del usuario (workflow paso 11)

Solicitar aprobación explícita del usuario. SOLO después de aprobación:

```bash
.claude/scripts/workflow-state.sh complete <dir> aprobacion_usuario
/promover-ejercicio [nombre_ejercicio]
```

## Antipatrones PROHIBIDOS

Ver [antipatrones-cloze.md](references/antipatrones-cloze.md) para los 4 antipatrones con codigo incorrecto/correcto.

Resumen: (1) NO menos de 4 partes, (2) NO partes sin progresion cognitiva, (3) NO afirmaciones sin base conceptual, (4) NO ##ANSWERi## mal ubicado.

## Letter-independence en Solution (regla #19, OBLIGATORIO)

La sección Solution del .Rmd CLOZE **NUNCA** debe identificar opciones por su letra/posición. SIEMPRE por contenido o código de error. Aplica a cada sub-parte schoice del CLOZE.

### Patrones prohibidos (bloquean compilación vía FASE 2J)

```rmd
### Respuesta correcta Parte 1: Opción `r letra_correcta_p1`
La opción `r letra_correcta_p3` de la Parte 3 es correcta porque...
**Opción A** corresponde al error conceptual identificado.
```

```r
# Chunk R que emite "Opción <letra>" en cualquier parte del CLOZE:
for (l in letras_p1) {
  cat("**Opción ", l, " (", err$codigo, "):** ", err$descripcion_larga)
}
```

### Patrones correctos (auto-contenidos)

```rmd
### Respuesta correcta — Parte 1

**Error identificado:** "`r errores_conceptuales[[error_idx_p1]]$descripcion_corta`"
```

```r
# Chunk R que identifica por código + nombre + contenido (sin letra):
for (l in letras_p1) {
  opc <- opciones_mezcladas_p1[[l]]
  if (opc$tipo != "correcto") {
    err <- errores_conceptuales[[opc$error_idx]]
    cat(paste0(
      "**", err$codigo, " — ", err$nombre, "**\n\n",
      "*Argumento:* \"", err$descripcion_corta, "\"\n\n",
      err$descripcion_larga, "\n\n"
    ))
  }
}
```

### Razón

Moodle (y otros LMS) tiene un setting "Shuffle answers" INDEPENDIENTE del `exshuffle` de R-exams. Cuando está activado, Moodle re-ordena las opciones de cada sub-parte schoice del CLOZE, pero NO toca el texto de Solution. Si Solution dice "Opción A de la Parte 1" pero Moodle movió esa opción a la posición C, el estudiante ve incoherencia.

Las variables `letra_correcta_p1`, `letra_correcta_p3`, etc. pueden existir como variables R internas para asserts y logs (`message()` a stderr) pero NUNCA deben llegar al texto visible del estudiante.

Ver `.claude/rules/solution-letter-independence.md` (regla #19, sin excepciones).

## Referencias

- [Estructura Progressive Disclosure](references/estructura-progressive-disclosure.md) - Secuencia de 4 partes, tipos de gap, plantilla Question, metadatos
- [Pool de Errores y Afirmaciones](references/pool-errores-afirmaciones.md) - PASOs 3, 4 y 5 con codigo R completo
- [Antipatrones CLOZE](references/antipatrones-cloze.md) - 4 antipatrones con correcciones
- [Checklist CLOZE](references/checklist-cloze.md) - Checklist + condiciones criticas + metadatos obligatorios
- [Anatomia CLOZE](references/anatomia-cloze.md) - Estructura GAPS y metadatos
- [Anatomia Metacognitiva](references/anatomia-metacognitiva.md) - Las 8 secciones obligatorias
- Regla Metacognitiva: `.claude/rules/ejercicios-metacognitivos.md`
- generar-schoice: `.claude/skills/generar-schoice/SKILL.md` (estructura base)
- Ejemplo Canónico: `A-Produccion/03-En-Produccion/.../promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd`
- Ejemplos Recientes (Prioridad 1): `A-Produccion/03-En-Produccion/**/*metacognitivo*cloze*.Rmd` y `A-Produccion/02-En-Desarrollo/**/*metacognitivo*cloze*.Rmd`
- Nomenclatura: `.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md`
- Ciclo Validacion: `.claude/rules/ciclo-validacion.md`

## Integracion con otros skills (workflow completo de 11 pasos)

```
1. analizar-icfes ──→ 2. flujo_b ──→ 3. generar-cloze
                                              ↓
4. skill-retroalimentacion ←─────────────────┘
      ↓
5. renderizado 4 formatos (exams2html/pdf/docx/nops)
      ↓
6. arsenal post-render (hook automático FASES 2A-2H)
      ↓
7. adversario (detractor FASE 2C) ──→ si RECHAZAR → volver a 5
      ↓
8. documentar 5 coherencias
      ↓
9. validar-diversidad (250+ versiones únicas)
      ↓
10. validar-icfes (metadatos + estructura)
      ↓
11. aprobación usuario → promover-ejercicio
```

Todos los pasos registran progreso via `workflow-state.sh complete`.
Progressive Disclosure de 4 partes MÍNIMO es OBLIGATORIO.
