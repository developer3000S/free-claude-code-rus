---
name: revisar-cloze
description: >
  Revisa un ejercicio CLOZE .Rmd existente ejecutando los pasos 4-11 del workflow completo.
  Orquesta: retroalimentación, renderizado, arsenal, detractor, coherencias, diversidad,
  validar-icfes y aprobación. Incluye validaciones específicas CLOZE (##ANSWERi##, exclozetype,
  Progressive Disclosure mín. 4 partes). Usa cuando tengas un .Rmd CLOZE que necesite
  validación completa, o cuando quieras retomar un workflow interrumpido.
license: Proyecto Educativo - IE Pedacito de Cielo
metadata:
  author: alvaretto
  version: "1.0"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash(ls:*)
  - Bash(Rscript:*)
  - Bash(.claude/scripts/workflow-state.sh:*)
  - Agent
  - Skill
---

# Revisor de Ejercicios CLOZE

## Propósito

Ejecuta los pasos 4-11 del workflow sobre un archivo `.Rmd` CLOZE existente. Detecta automáticamente en qué paso quedó el workflow y retoma desde ahí.

## Invocación

```
/revisar-cloze [ruta-al-archivo.Rmd]
```

Si no se proporciona ruta, buscar archivos `.Rmd` en el directorio actual con `extype: cloze`.

## Decision Tree

```
Input: ruta .Rmd
    ↓
¿Existe ejercicio_state.json en el directorio?
    |-- No → Crear con workflow-state.sh init --tipo cloze
    |         Marcar pasos 1-3 como completados (el .Rmd ya existe)
    +-- Sí → Leer estado actual
    ↓
Validación previa CLOZE (antes de pasos 4-11):
    - ¿Tiene mínimo 4 partes (Progressive Disclosure)?
    - ¿##ANSWERi## en orden correcto?
    - ¿exclozetype consistente con las partes?
    ↓
¿Qué paso sigue? (workflow-state.sh next <dir>)
    ↓
Ejecutar pasos pendientes en orden (4→11)
```

## Validación previa específica CLOZE (ANTES del paso 4)

Ejecutar estas verificaciones ANTES de iniciar el workflow general:

### V1: Progressive Disclosure (mínimo 4 partes)

```bash
# Contar ##ANSWERi## en el archivo
grep -c "##ANSWER" [archivo].Rmd
```

Si hay menos de 4 → **BLOQUEAR** revisión. El ejercicio necesita rediseño, no revisión.

### V2: Orden de ##ANSWERi##

Verificar que cada `##ANSWERi##` aparece inmediatamente después de su pregunta correspondiente, NO agrupados al final.

```markdown
✅ CORRECTO:
**Parte 1.** ¿Pregunta?
##ANSWER1##
**Parte 2.** ¿Pregunta?
##ANSWER2##

❌ INCORRECTO:
**Parte 1.** ¿Pregunta?
**Parte 2.** ¿Pregunta?
##ANSWER1##
##ANSWER2##
```

### V3: Consistencia exclozetype

```r
# Número de tipos en exclozetype debe coincidir con número de ##ANSWERi##
n_tipos <- length(strsplit(exclozetype, "|", fixed = TRUE)[[1]])
n_answers <- # contar ##ANSWERi## en el archivo
stopifnot(n_tipos == n_answers)
```

### V4: Tipos válidos por parte

| Parte | Propósito cognitivo | Tipos válidos |
|-------|-------------------|---------------|
| 1 | Identificar (error/concepto) | schoice |
| 2 | Calcular (valor correcto) | num |
| 3 | Evaluar (afirmaciones) | mchoice |
| 4 | Transferir (V/F, caso) | schoice |

Si las partes no siguen la progresión cognitiva → advertir (no bloquear).

## Proceso: Pasos 4-11

### PASO 4: Retroalimentación científica

**Verificar**: ¿La sección Solution tiene las 6 subsecciones obligatorias?
- Análisis del error (Parte 1)
- Procedimiento correcto (Parte 2)
- Propiedades del concepto (Parte 3)
- Caso específico (Parte 4)
- Reflexión metacognitiva
- Estrategia para evitar el error

**Si falta o es insuficiente**: Ejecutar `/skill-retroalimentacion` sobre el archivo.

```bash
.claude/scripts/workflow-state.sh complete <dir> retroalimentacion
```

### PASO 5: Renderizado 4 formatos

```r
library(exams)
exams2html("[archivo].Rmd", n = 1, dir = "salida")
exams2pdf("[archivo].Rmd", n = 1, dir = "salida")
exams2pandoc("[archivo].Rmd", n = 1, type = "docx", dir = "salida")
exams2nops("[archivo].Rmd", n = 1, dir = "salida")
```

**NOPS fallará si hay gaps tipo num/string** — esto es ESPERADO para CLOZE, NO es error.

**Si HTML o PDF fallan**: Diagnosticar error, corregir, volver a renderizar.

```bash
.claude/scripts/workflow-state.sh complete <dir> renderizado_4_formatos
```

### PASO 6: Arsenal post-render (AUTOMÁTICO)

El hook `post-exams2-validation.sh` se ejecuta automáticamente. Para CLOZE verifica adicionalmente:
- exclozetype/exsolution/extol consistentes
- Tipos válidos en cada parte

**Acción**: Leer la salida del hook. Si reporta errores → corregir → volver a PASO 5.

```bash
.claude/scripts/workflow-state.sh complete <dir> arsenal_post_render
```

### PASO 7: Detractor FASE 2C (OBLIGATORIO)

Ejecutar `/adversario [archivo.Rmd]`.

El adversario revisa 8 dominios con énfasis adicional en CLOZE:
- **Código**: exclozetype, ##ANSWERi##, extol por parte
- **Pedagógico**: Progressive Disclosure, progresión cognitiva entre partes
- **Matemático**: Coherencia entre partes (Parte 2 calcula lo que Parte 1 identifica)

**Decisión basada en veredicto**:
- RECHAZAR → corregir → volver a PASO 5
- APROBAR CON CAMBIOS → aplicar → volver a PASO 5
- APROBAR → continuar

```bash
.claude/scripts/workflow-state.sh complete <dir> detractor_fase2c --veredicto "[veredicto]"
```

### PASO 8: Documentar 5 coherencias

Leer los PNGs de preview y verificar VISUALMENTE:

- [ ] **Semántica**: gramática, tildes, cada parte tiene pregunta clara
- [ ] **Visual-Texto**: gráfico coincide con enunciado, valores sincronizados
- [ ] **Matemática**: fórmulas correctas, respuesta Parte 2 = cálculo correcto del concepto
- [ ] **Código**: las 4+ partes se renderizan, cada ##ANSWERi## muestra su input
- [ ] **General**: legible, estilo ICFES, progresión visible entre partes

**Verificación adicional CLOZE**: Confirmar visualmente que cada parte muestra su campo de respuesta en la posición correcta.

```bash
.claude/scripts/workflow-state.sh complete <dir> coherencias_5
```

### PASO 9: Validar diversidad

Ejecutar `/validar-diversidad`. Requiere 250+ versiones únicas de 300 intentos.

**Atención CLOZE**: La diversidad se mide sobre la COMBINACIÓN de todas las partes, no sobre cada parte individual.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_diversidad --versiones_unicas [N]
```

### PASO 10: Validar ICFES

Ejecutar `/validar-icfes`. Verifica para CLOZE:
- extype: cloze
- exclozetype: tipos separados por `|` (ej: `schoice|num|mchoice|schoice`)
- exsolution: formato consistente con exclozetype
- extol: tolerancia por parte numérica
- 6 dimensiones ICFES completas
- Metadatos cognitivos (DOK ≥ 3 para CLOZE, Bloom, SOLO)

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_icfes
```

### PASO 11: Aprobación del usuario

Presentar resumen completo:

```markdown
## Resumen de revisión CLOZE — [nombre ejercicio]

### Validación previa CLOZE
- Partes: N (mínimo 4) ✅
- ##ANSWERi##: en orden ✅
- exclozetype: consistente ✅

### Workflow pasos 4-11
| Paso | Estado | Detalle |
|------|--------|---------|
| 4. Retroalimentación | ✅ | Solution con 6 subsecciones |
| 5. Renderizado | ✅ | HTML/PDF/DOCX (NOPS: N/A) |
| 6. Arsenal | ✅ | FASES 2A-2H sin errores |
| 7. Detractor | ✅ | Veredicto: APROBAR |
| 8. Coherencias | ✅ | 5/5 verificadas |
| 9. Diversidad | ✅ | N versiones únicas |
| 10. ICFES | ✅ | Metadatos completos |

**¿Aprueba este ejercicio?**
```

```bash
.claude/scripts/workflow-state.sh complete <dir> aprobacion_usuario
```

## Retomar workflow interrumpido

```bash
# Ver estado actual
.claude/scripts/workflow-state.sh status <dir>

# Ver próximo paso
.claude/scripts/workflow-state.sh next <dir>
```

Retoma desde el paso pendiente sin repetir pasos completados.

## Flujo de corrección

```
Paso N detecta problema
    ↓
Corregir el archivo .Rmd
    ↓
¿El cambio afecta renderizado?
    |-- Sí → Volver a PASO 5 (re-renderizar)
    +-- No → Volver a PASO N (re-verificar)
```

**Regla especial CLOZE**: Si se corrige un ##ANSWERi## o se modifica exclozetype → SIEMPRE volver a PASO 5 (renderizado completo).

## Consulta de ejemplos para correcciones (Búsqueda Inteligente)

Cuando un paso detecta un problema que requiere corrección, ANTES de corregir:

**Prioridad 1 — Ejercicios CLOZE recientes aprobados** (patrones vigentes):
```bash
ls -t A-Produccion/03-En-Produccion/**/*metacognitivo*cloze*.Rmd 2>/dev/null | head -3
ls -t A-Produccion/02-En-Desarrollo/**/*metacognitivo*cloze*.Rmd 2>/dev/null | head -3
```

Solo considerar archivos con `ejercicio_state.json` donde `aprobacion_usuario.completado = true` o en `03-En-Produccion/`.

**Prioridad 2 — Ejemplo canónico CLOZE**:
```bash
cat A-Produccion/03-En-Produccion/.../promedios_borrados_metacognitivo_argumentacion_n3_cloze_v1.Rmd
```

**Protocolo**: Buscar el patrón de solución en el ejemplo más reciente similar. Si no existe, usar el canónico. NUNCA corregir sin consultar al menos 1 ejemplo.

## Routing de modelos

| Sub-tarea | Modelo | Razón |
|-----------|--------|-------|
| Retroalimentación | opus | Diseño pedagógico complejo |
| Renderizado | haiku | Ejecutar comandos R |
| Detractor | sonnet | Revisión adversarial |
| Coherencias | sonnet (visual) | Lectura de imágenes |
| Diversidad | haiku | Ejecutar testthat |
| Validar ICFES | haiku | Verificar campos fijos |

## Integración

```
/revisar-cloze [archivo.Rmd]
    ↓
Validación previa CLOZE (V1-V4)
    ↓
Pasos 4-11 del workflow secuencial
    ↓
Cada paso registra progreso via workflow-state.sh
    ↓
Si todo pasa → ejercicio listo para aula
    ↓
Después de validación en aula → /promover-ejercicio
```
