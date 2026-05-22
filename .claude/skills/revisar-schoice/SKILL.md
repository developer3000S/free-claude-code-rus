---
name: revisar-schoice
description: >
  Revisa un ejercicio SCHOICE .Rmd existente ejecutando los pasos 4-11 del workflow completo.
  Orquesta: retroalimentación, renderizado, arsenal, detractor, coherencias, diversidad,
  validar-icfes y aprobación. Usa cuando tengas un .Rmd ya generado que necesite validación
  completa, o cuando quieras retomar un workflow interrumpido.
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

# Revisor de Ejercicios SCHOICE

## Propósito

Ejecuta los pasos 4-11 del workflow sobre un archivo `.Rmd` SCHOICE existente. Detecta automáticamente en qué paso quedó el workflow y retoma desde ahí.

## Invocación

```
/revisar-schoice [ruta-al-archivo.Rmd]
```

Si no se proporciona ruta, buscar archivos `.Rmd` en el directorio actual con `extype: schoice`.

## Decision Tree

```
Input: ruta .Rmd
    ↓
¿Existe ejercicio_state.json en el directorio?
    |-- No → Crear con workflow-state.sh init --tipo schoice
    |         Marcar pasos 1-3 como completados (el .Rmd ya existe)
    +-- Sí → Leer estado actual
    ↓
¿Qué paso sigue? (workflow-state.sh next <dir>)
    ↓
Ejecutar pasos pendientes en orden (4→11)
    ↓
Si un paso falla → corregir → volver al paso que corresponda
    ↓
Si todos pasan → reportar estado final
```

## Proceso: Pasos 4-11

### PASO 4: Retroalimentación científica

**Verificar**: ¿La sección Solution tiene las 6 subsecciones obligatorias?
- Análisis del error
- Procedimiento correcto
- Propiedades del concepto
- Caso específico
- Reflexión metacognitiva
- Estrategia para evitar el error

**Si falta o es insuficiente**: Ejecutar `/skill-retroalimentacion` sobre el archivo.

```bash
.claude/scripts/workflow-state.sh complete <dir> retroalimentacion
```

### PASO 5: Renderizado 4 formatos

Ejecutar los 4 renderizados obligatorios:

```r
library(exams)
exams2html("[archivo].Rmd", n = 1, dir = "salida")
exams2pdf("[archivo].Rmd", n = 1, dir = "salida")
exams2pandoc("[archivo].Rmd", n = 1, type = "docx", dir = "salida")
exams2nops("[archivo].Rmd", n = 1, dir = "salida")
```

**Si alguno falla**: Diagnosticar error, corregir, volver a renderizar.

```bash
.claude/scripts/workflow-state.sh complete <dir> renderizado_4_formatos
```

### PASO 6: Arsenal post-render (AUTOMÁTICO)

El hook `post-exams2-validation.sh` se ejecuta automáticamente después de cada `exams2*()`. Incluye:
- FASE 2A: Validación matemática
- FASE 2B: Preview visual (PDF → PNG)
- FASES 2C-2F: Arsenal estático
- FASE 2G: Multi-semilla rápida (20 semillas)
- FASE 2H: Stress test visual

**Acción**: Leer la salida del hook. Si reporta errores → corregir → volver a PASO 5.

```bash
.claude/scripts/workflow-state.sh complete <dir> arsenal_post_render
```

### PASO 7: Detractor FASE 2C (OBLIGATORIO)

Ejecutar `/adversario [archivo.Rmd]`.

El adversario revisa 8 dominios:
1. Código R-exams
2. Pedagógico (Progressive Disclosure, metacognición)
3. Visual (coherencia gráfico-texto)
4. Gramática/ortografía
5. Coherencia matemática
6. ICFES metacognitivo (DOK, Bloom, SOLO)
7. Testing
8. Coherencia semántica

**Decisión basada en veredicto**:
- RECHAZAR → corregir objeciones CRÍTICAS/ALTAS → volver a PASO 5
- APROBAR CON CAMBIOS → aplicar cambios → volver a PASO 5
- APROBAR → continuar

```bash
.claude/scripts/workflow-state.sh complete <dir> detractor_fase2c --veredicto "[veredicto]"
```

### PASO 8: Documentar 5 coherencias

Leer los PNGs de preview generados en PASO 6 y verificar VISUALMENTE:

- [ ] **Semántica**: gramática correcta, tildes, redacción estilo ICFES
- [ ] **Visual-Texto**: gráfico coincide con enunciado, valores sincronizados
- [ ] **Matemática**: fórmulas correctas, cálculos verificables, distractores plausibles
- [ ] **Código**: elementos dinámicos funcionan, datos cambian entre semillas
- [ ] **General**: legible en todos los formatos, estilo ICFES, opciones visibles

**Documentar hallazgos con checklist**. Si hay problemas → corregir → volver a PASO 5.

```bash
.claude/scripts/workflow-state.sh complete <dir> coherencias_5
```

### PASO 9: Validar diversidad

Ejecutar `/validar-diversidad`. Requiere 250+ versiones únicas de 300 intentos.

**Si no alcanza el umbral**: Revisar aleatorización en data_generation, ampliar rangos de parámetros.

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_diversidad --versiones_unicas [N]
```

### PASO 10: Validar ICFES

Ejecutar `/validar-icfes`. Verifica:
- extype: schoice
- exsolution: binario con exactamente 1 correcta
- exshuffle: TRUE (o FALSE si opciones gráficas con letra_correcta)
- 6 dimensiones ICFES completas (Competencia, Componente, Afirmación, Evidencia, Nivel, Contexto)
- Metadatos cognitivos (DOK, Bloom, SOLO)

```bash
.claude/scripts/workflow-state.sh complete <dir> validar_icfes
```

### PASO 11: Aprobación del usuario

Presentar resumen completo al usuario:

```markdown
## Resumen de revisión — [nombre ejercicio]

| Paso | Estado | Detalle |
|------|--------|---------|
| 4. Retroalimentación | ✅ | Solution con 6 subsecciones |
| 5. Renderizado | ✅ | HTML/PDF/DOCX/NOPS |
| 6. Arsenal | ✅ | FASES 2A-2H sin errores |
| 7. Detractor | ✅ | Veredicto: APROBAR |
| 8. Coherencias | ✅ | 5/5 verificadas |
| 9. Diversidad | ✅ | N versiones únicas |
| 10. ICFES | ✅ | Metadatos completos |

**¿Aprueba este ejercicio?**
```

Esperar respuesta explícita del usuario.

```bash
.claude/scripts/workflow-state.sh complete <dir> aprobacion_usuario
```

## Validaciones específicas SCHOICE

Además del workflow general, verificar:

1. **exsolution binario**: Exactamente un `1` en el string (ej: `01000`)
2. **Opciones únicas**: `digest::digest()` sobre cada opción → todos diferentes
3. **exshuffle**: TRUE para texto, FALSE para opciones gráficas PNG con Solution que referencia `letra_correcta`
4. **Si archivo es `_neg_`**: Patrón (N-1) idénticas + 1 diferente (ver `validacion-neg-opciones-repetidas.md`)
5. **Pool de errores**: Mínimo 4-6 con códigos, `calcula()` determinista, `precondicion` declarada

### Para ejercicios con distractores Sí/No (argumentación / evaluación de afirmaciones)

Ver patrones en `.claude/skills/generar-schoice/SKILL.md` § "Distractores con conclusión binaria".

6. **Patrón A — Coherencia conclusión-justificación condicional**: Para cada
   error en el pool cuya `descripcion_corta` empiece con "Sí, " o "No, ",
   verificar que **si la justificación usa variables con roles invertibles**
   (`pais_perdedor`/`pais_ganador`, `serie_baja`/`serie_alta`, etc.), la
   conclusión también es condicional al mismo flag que invierte esos roles.

   **Antipatrón a detectar (regex)**:
   ```bash
   grep -nE 'descripcion_corta\s*=\s*paste0\(\s*"(Sí|No),' archivo.Rmd
   # Para cada match: verificar si el texto que sigue contiene variables tipo
   # pais_perdedor/ganador SIN un if() condicional alrededor.
   ```

   Si la conclusión es fija pero la justificación es condicional → **bug
   sistémico**: la mitad de las semillas producirán incoherencia interna
   conclusión-justificación. Reportar como objeción CRÍTICA.

7. **Patrón B — Premisas consistentes con restricciones de generación**:
   Cruzar las premisas de cada `descripcion_corta` con las restricciones
   declaradas en `data_generation`:

   - Si `gap_min > 0` → ninguna `descripcion_corta` debe afirmar "valores iguales".
   - Si `stopifnot(serie_a[i] != serie_b[i])` → ninguna premisa debe asumir
     igualdad puntual observable.
   - Si la generación garantiza monotonía → ninguna premisa debe asumir
     comportamiento no monótono observable.

   Reportar como objeción ALTA cuando la premisa es objetivamente imposible
   de cumplir en cualquier semilla.

8. **Patrón C — Gotcha `sample()` con length(x)==1**: Buscar todas las
   apariciones de `sample(<var>, <n>)` donde `<var>` pueda ser un vector
   construido dinámicamente (pool filtrado, pool por flags).

   ```bash
   grep -nE 'sample\(distractores_(si|no|aplicables|filtrados)' archivo.Rmd
   ```

   Si encuentra coincidencias y NO usa el patrón `x[sample.int(length(x), n)]`,
   reportar como objeción ALTA con el riesgo: cuando el pool colapsa a 1
   elemento por la lógica de flags, `sample(c(3L), 1)` retorna un número
   aleatorio en 1:3 en lugar del elemento 3 → opciones inválidas o duplicadas
   silenciosamente.

9. **Patrón D — Pools dinámicos sin `stopifnot`**: Si el código construye
   `distractores_si`/`distractores_no` dinámicamente a partir de flags,
   verificar que existe un bloque `stopifnot` justo antes del muestreo que
   valide:
   - `n_si + n_no == cantidad_esperada` (típicamente 3)
   - `n_si <= length(distractores_si)`
   - `n_no <= length(distractores_no)`

   Sin estas guardias, una semilla rara puede pedir más distractores de los
   disponibles → error oscuro en `sample()` o duplicación silenciosa.
   Reportar como objeción MEDIA.

## Consulta de ejemplos para correcciones (Búsqueda Inteligente)

Cuando un paso detecta un problema que requiere corrección, ANTES de corregir:

**Prioridad 1 — Ejercicios SCHOICE recientes aprobados** (patrones vigentes):
```bash
ls -t A-Produccion/03-En-Produccion/**/*metacognitivo*schoice*.Rmd 2>/dev/null | head -3
ls -t A-Produccion/02-En-Desarrollo/**/*metacognitivo*schoice*.Rmd 2>/dev/null | head -3
```

Solo considerar archivos con `ejercicio_state.json` donde `aprobacion_usuario.completado = true` o en `03-En-Produccion/`.

**Prioridad 2 — Ejemplos Funcionales canónicos**:
```bash
ls A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
```

**Protocolo**: Buscar el patrón de solución en el ejemplo más reciente similar. Si no existe, usar el canónico. NUNCA corregir sin consultar al menos 1 ejemplo.

## Retomar workflow interrumpido

Si el workflow fue interrumpido (ej: sesión anterior), el skill detecta automáticamente:

```bash
# Ver estado actual
.claude/scripts/workflow-state.sh status <dir>

# Ver próximo paso
.claude/scripts/workflow-state.sh next <dir>
```

Y retoma desde el paso pendiente sin repetir pasos ya completados.

## Flujo de corrección

```
Paso N detecta problema
    ↓
Corregir el archivo .Rmd
    ↓
¿El cambio afecta renderizado?
    |-- Sí → Volver a PASO 5 (re-renderizar)
    +-- No → Volver a PASO N (re-verificar solo ese paso)
```

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
/revisar-schoice [archivo.Rmd]
    ↓
Pasos 4-11 del workflow secuencial
    ↓
Cada paso registra progreso via workflow-state.sh
    ↓
Si todo pasa → ejercicio listo para aula
    ↓
Después de validación en aula → /promover-ejercicio
```
