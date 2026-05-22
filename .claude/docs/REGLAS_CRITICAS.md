# Reglas Críticas del Sistema (OBLIGATORIAS)

## ⛔ Resumen Ejecutivo

**Todas estas reglas son OBLIGATORIAS y NO tienen excepciones.**

### Las 14 Reglas Fundamentales

1. **Ejercicios metacognitivos** con Progressive Disclosure
2. **Flujo B obligatorio** cuando hay gráficos
3. **Proceso secuencial** TikZ→Python→R (98% fidelidad, usuario decide)
4. **Gráficos como opciones individuales** (PNGs separados)
5. **5 Coherencias** a verificar en cada validación
6. **Validación visual iterativa** con inspección REAL
7. **Ortografía española** con tildes correctas
8. **Testing automático** permanente con tolerancia cero
9. **Detractor obligatorio** en todas las fases de revisión
10. **Skill-retroalimentación** obligatorio para sección Solution
11. **Validación _neg_ opciones repetidas** (genérica con `digest()`)
12. **Contextos narrativos creativos** (no mecánicos)
13. **Validación correctitud respuesta** (Nivel 5: multi-semilla + cross-check)
14. **Routing de modelos obligatorio** (Opus/Sonnet/Haiku por complejidad) 🆕

---

## 1. Ejercicios Metacognitivos - OBLIGATORIO 🆕

**Regla detallada**: @.claude/rules/ejercicios-metacognitivos.md

### Principio Fundamental

**TODO ejercicio .Rmd (SCHOICE, CLOZE) DEBE ser metacognitivo con Progressive Disclosure.**

Los ejercicios puramente procedimentales ("calcula X") están **PROHIBIDOS**.

### Qué es un Ejercicio Metacognitivo

Un ejercicio metacognitivo va más allá del cálculo:
- Requiere **identificar errores** de otros
- Exige **justificar** por qué algo es correcto/incorrecto
- Incluye **reflexión** sobre el proceso de solución
- Aplica **verificación** de resultados

### Patrones Metacognitivos Obligatorios

| Patrón | Descripción | Bloom |
|--------|-------------|-------|
| **Análisis de Error Ajeno** | "Juan obtuvo X. ¿Cuál fue su error?" | Analizar |
| **Evaluación de Afirmación** | "María afirma Y. ¿Por qué es incorrecta?" | Evaluar |
| **Comparación de Procedimientos** | "¿Cuál estudiante aplicó correctamente Z?" | Analizar |

### Progressive Disclosure (CLOZE)

Todo ejercicio CLOZE DEBE tener **mínimo 4 partes**:

```
Parte 1 (schoice): IDENTIFICAR el error conceptual
    ↓ Bloom: Analizar | DOK: 3
Parte 2 (num): CALCULAR la respuesta correcta
    ↓ Bloom: Aplicar | DOK: 2
Parte 3 (mchoice): EVALUAR afirmaciones sobre el concepto
    ↓ Bloom: Evaluar | DOK: 3
Parte 4 (schoice V/F): TRANSFERIR a caso específico
    | Bloom: Analizar/Evaluar | DOK: 3
```

### Pool de Errores Conceptuales (OBLIGATORIO)

Todo ejercicio DEBE definir un pool de errores con:

```r
errores_conceptuales <- list(
  list(
    codigo = "XXX-YYY-01",          # Ej: EST-MTC-01
    nombre = "Nombre descriptivo",
    descripcion_corta = "...",       # Para opciones (max 80 chars)
    descripcion_larga = "...",       # Para solución
    causa_raiz = "...",              # Diagnóstico pedagógico
    calcula = function(...) { ... }  # Función que produce el distractor
  )
)
```

### Metadatos Cognitivos OBLIGATORIOS

```yaml
exextra[DOK]: [2|3|4]              # Webb's Depth of Knowledge
exextra[Bloom]: [Analizar|Evaluar]  # Taxonomía de Bloom
exextra[SOLO]: [Relacional|...]     # Taxonomía SOLO
exextra[TipoMetacognicion]: [analisis_error|evaluacion_afirmacion|...]
```

### Sección Solution OBLIGATORIA

```markdown
Solution
========

### Análisis del Error
**Error identificado:** [descripcion_larga]
**Código de error:** [codigo]
**Causa raíz:** [causa_raiz]

### Procedimiento Correcto
**Paso 1:** [descripción + fórmula LaTeX]
...

### Reflexión Metacognitiva
[reflexión aleatoria del pool]
```

### Antipatrones PROHIBIDOS

```markdown
❌ PROHIBIDO: Ejercicio puramente procedimental
"Calcula el área de un rectángulo con base 8 cm"

✓ CORRECTO: Ejercicio metacognitivo
"Un estudiante calculó 8 + 5 = 13 como área. ¿Cuál fue su error?"
```

```r
❌ PROHIBIDO: Distractores aleatorios
distractores <- respuesta + sample(-10:10, 3)

✓ CORRECTO: Distractores basados en errores conceptuales
distractores <- sapply(errores_conceptuales, function(e) e$calcula(...))
```

---

## 2. Flujo B (Graficador Experto) - OBLIGATORIO

**Regla detallada**: @.claude/rules/flujo-b-obligatorio.md

### Principio Fundamental

**SIEMPRE que se detecten gráficos en un ejercicio ICFES, el Flujo B es OBLIGATORIO.**

### Detección Automática

El sistema detecta gráficos en:
- Enunciados con imágenes matemáticas
- Opciones de respuesta con diagramas
- Referencias a "gráfica", "diagrama", "figura", "tabla"

### Bloqueo de Generación

```
SI ejercicio_tiene_graficos AND NOT flujo_b_completado:
    BLOQUEAR generación de .Rmd
    MOSTRAR mensaje de error
    REDIRIGIR a Flujo B
```

### Archivos Requeridos

```
outputs/[nombre_ejercicio]/
├── workflow_state.json          # Estado del flujo
├── output_tikz_vN.tex           # Versión TikZ final
├── output_python_vN.py          # Versión Python final
├── output_r_vN.R                # Versión R final
├── tikz_output_vN.png           # Preview TikZ
├── python_output_vN.png         # Preview Python
└── r_output_vN.png              # Preview R
```

**NO hay excepciones**. Si hay gráficos, hay Flujo B.

---

## 3. Proceso Secuencial del Graficador (v2.0) 🆕

**Regla detallada**: @.claude/rules/graficador-secuencial.md

### Cambios Importantes v2.0

- **Umbral de fidelidad**: 95% → **98%**
- **Iteraciones**: Manuales → **AUTOMÁTICAS**
- **Lenguajes**: SIEMPRE generar **TikZ + Python + R** (los tres)
- **Decisión final**: Claude NO puede elegir → **USUARIO SIEMPRE DECIDE**

### Orden OBLIGATORIO

```
1. TikZ (dinámico desde R)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud + coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
2. Python (vía reticulate)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud + coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
3. R (nativo ggplot2)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud + coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
4. PRESENTAR LAS 3 OPCIONES AL USUARIO
   ↓ Tabla comparativa con similitud, ventajas, código
   ↓ USUARIO SELECCIONA cuál usar
```

### PROHIBIDO: Omitir Lenguajes o Decidir por el Usuario

```r
# ❌ INCORRECTO - Omitir lenguajes
"Para este gráfico simple, solo generaré ggplot2"

# ❌ INCORRECTO - Decidir por el usuario
"Recomiendo usar R porque tiene mejor similitud" → [genera .Rmd sin preguntar]

# ✓ CORRECTO - Generar todos y preguntar
generar_tikz_automatico() → mostrar_resultado
→ generar_python_automatico() → mostrar_resultado
→ generar_r_automatico() → mostrar_resultado
→ "Las tres versiones están listas. ¿Cuál prefiere usar?"
```

### Estados del Workflow

```json
{
  "tikz": {
    "estado": "pendiente|en_iteracion|verificando|aprobado",
    "similitud_actual": 0,
    "usuario_aprobo": false
  },
  "python": {
    "estado": "bloqueado|pendiente|en_iteracion|verificando|aprobado"
  },
  "r": {
    "estado": "bloqueado|pendiente|en_iteracion|verificando|aprobado"
  }
}
```

---

## 4. Gráficos Como Opciones Individuales (OBLIGATORIO) 🆕

**Regla detallada**: @.claude/rules/graficos-como-opciones.md

### Principio Fundamental

**Cuando las opciones de respuesta de un ejercicio SCHOICE son gráficos, CADA gráfico DEBE ser una imagen PNG separada.**

Esta regla NO tiene excepciones. **NUNCA usar `grid.arrange()` para mostrar todos los gráficos juntos.**

### ⚠️ REGLA CRÍTICA: Sin Títulos con Letras

**Los gráficos de opciones NUNCA deben tener títulos con letras (A, B, C, D).**

```r
# ❌ PROHIBIDO - Título con letra fija
labs(title = "A")

# ✅ CORRECTO - Sin título
labs(title = NULL)
```

### Patrón Correcto: Mezcla interna + exshuffle:FALSE

```r
# 1. Mezclar opciones internamente con sample()
opciones_mezcladas <- sample(todas_opciones)
indice_correcto <- which(names(opciones_mezcladas) == "correcta")
solucion <- rep(0, 4)
solucion[indice_correcto] <- 1
letra_correcta <- c("a", "b", "c", "d")[indice_correcto]

# 2. Generar PNGs sin título
ggsave(paste0("diagrama_", tolower(letra), ".png"), plot = p, ...)

# 3. Meta-information: exshuffle: FALSE
# sample() ya aleatoriza; TRUE rompería la referencia a letra_correcta en Solution
```

```yaml
extype: schoice
exsolution: `r paste(as.integer(solucion), collapse="")`
exshuffle: FALSE  # sample() interno ya aleatoriza; TRUE rompe Solution
```

### Antipatrones PROHIBIDOS

```r
# ❌ PROHIBIDO: Títulos con letras
labs(title = "A")

# ❌ PROHIBIDO: grid.arrange() para mostrar opciones juntas
grid.arrange(plot_A, plot_B, plot_C, plot_D, ncol = 2)

# ❌ PROHIBIDO: exshuffle: TRUE cuando Solution referencia letra_correcta
# R-exams re-mezcla opciones pero NO modifica el texto de la Solution
exshuffle: TRUE  # ← rompe coherencia con "Opción X" en Solution
```

**Nota**: `exshuffle: TRUE` sigue siendo obligatorio para ejercicios con opciones de **texto** (ver regla #6 en `codigo-rmd.md`). La excepción aplica solo a SCHOICE con PNGs + Solution que referencia `letra_correcta`.

---

## 5. Las 5 Coherencias (Verificación Obligatoria)

**Todas deben verificarse ANTES de aprobar cualquier ejercicio.**

### 1. Coherencia Semántica (Gramática)
- Texto en español correcto
- **TILDES OBLIGATORIAS**: más, ángulo, función, gráfica, dispersión
- Sin errores ortográficos
- Terminología matemática apropiada
- Redacción clara estilo ICFES

### 2. Coherencia Visual-Texto
- Gráfico coincide EXACTAMENTE con enunciado
- Valores en gráfico = valores en texto
- Etiquetas consistentes con la pregunta
- Colores/estilos descritos coinciden con renderizado
- Sin contradicciones visuales

### 3. Coherencia Matemática
- Fórmulas correctas y bien formateadas
- Cálculos verificables paso a paso
- Proporciones y escalas correctas
- Respuesta correcta matemáticamente válida
- Distractores plausibles pero incorrectos
- Sin NaN, Inf, errores numéricos

### 4. Coherencia de Código
- Código dinámico (variables aleatorias, NO hardcoded)
- Compatible con R-exams en 4 formatos (HTML/PDF/DOCX/NOPS)
- Sin dependencias externas no declaradas
- Gráficos generados programáticamente
- Variables R interpoladas correctamente en TikZ/Python
- Diferentes semillas generan ejercicios válidos

### 5. Coherencia General
- Legible en todos los formatos
- Estilo visual consistente ICFES
- Dificultad apropiada al nivel (n1-n4)
- Tiempo de resolución razonable
- Opciones visibles y distinguibles
- Sin elementos confusos

### Checklist de Verificación

```markdown
## Verificación de Coherencias - [Nombre Ejercicio]

- [ ] 1. Semántica: ¿Gramática y ortografía correctas?
- [ ] 2. Visual-Texto: ¿Gráfico coincide con enunciado?
- [ ] 3. Matemática: ¿Fórmulas y cálculos correctos?
- [ ] 4. Código: ¿Dinámico y compatible R-exams?
- [ ] 5. General: ¿Legible y estilo ICFES apropiado?

### Problemas detectados:
[Lista de problemas si existen]

### Acción:
- [ ] Aprobar ejercicio
- [ ] Corregir y volver a validar
```

---

## 6. Validación Visual Iterativa (OBLIGATORIA)

**Regla detallada**: @.claude/rules/ciclo-validacion.md

### Principio Fundamental

**NUNCA marcar como "completado" sin inspección visual REAL.**

### Ciclo Obligatorio

```
1. Renderizar → exams2pdf/html/docx/nops
2. FASE 2A: Validación matemática [AUTOMÁTICA vía hook]
3. FASE 2B: Convertir PDF → PNG [AUTOMÁTICA vía hook]
4. Claude: Read() cada PNG generado
5. Claude: Verificar 5 coherencias VISUALMENTE
6. Claude: Documentar hallazgos con checklist
7. Claude: Solicitar aprobación del usuario
8. ¿Problemas? → Corregir → VOLVER A PASO 1
```

### ⚠️ REGLA CRÍTICA: REPETIR DESPUÉS DE CADA CAMBIO

**Cada vez que se aplica CUALQUIER corrección:**
- VOLVER A RENDERIZAR
- MOSTRAR NUEVO PREVIEW
- VERIFICAR RESULTADO VISUAL
- NUNCA asumir éxito sin verificación

### PROHIBIDO

❌ "El PDF se generó correctamente" sin mostrar imagen
❌ Asumir éxito solo porque no hubo errores de compilación
❌ Saltarse comparación visual con imagen original
❌ Aplicar cambios sin volver a mostrar el resultado

### Herramientas Automáticas

```bash
# FASE 2A (automática vía hook)
Rscript .claude/scripts/validar_coherencia_matematica.R archivo.Rmd

# FASE 2B (automática vía hook)
magick -density 150 archivo.pdf -quality 90 preview.png

# Claude DEBE entonces:
Read("preview.png")  # Mostrar al usuario
# Verificar 5 coherencias
# Documentar y solicitar aprobación
```

---

## 7. Ortografía Española (OBLIGATORIA)

**Regla detallada**: @.claude/rules/ortografia-espanol.md

### Principio Fundamental

**TODO texto en español DEBE incluir tildes correctas.**

### Palabras Frecuentes con Tilde

```
más  según  así  después  también  además  aquí  ahí

ángulo  gráfica  gráfico  función  número  cálculo  método
código  propósito  patrón  máximo  mínimo  análisis  éxito

dispersión  solución  ecuación  relación  variación
descripción  información  configuración  clasificación
```

### Excepciones (ASCII Obligatorio)

**Metadatos R-exams** NUNCA llevan tildes:
```yaml
exname: nombre_sin_tildes
exsection: Numerico-Variacional/Argumentacion
extype: schoice
exsolution: 1000
exextra[Competencia]: Interpretacion  # Sin tilde
exextra[Componente]: Aleatorio
```

**Variables R**: `angulos`, `solucion`, `grafica` (sin tildes para compatibilidad)

### Validación Automática

```bash
# Verificar (sin corregir)
Rscript .claude/scripts/corregir_ortografia_espanol.R archivo.Rmd

# Corregir automáticamente
Rscript .claude/scripts/corregir_ortografia_espanol.R archivo.Rmd --fix
```

### Hook Pre-Commit

El sistema detecta automáticamente errores de ortografía antes de cada commit.

**⚠️ PROHIBIDO**: `git commit --no-verify` para evadir validaciones

---

## 8. Testing Automático (PERMANENTE)

**Regla detallada**: @.claude/rules/testing-obligatorio.md
**Flujo automático**: @.claude/docs/FLUJO_AUTOMATICO_TESTING.md

### Principio Fundamental

**TODOS los cambios son validados automáticamente. Tolerancia cero a regresiones.**

### Sistema de 2 Hooks Activos + Git hooks nativos

> v3.8.0 (2026-04-10): los hooks `pre-edit-testing.sh`, `post-edit-testing.sh`
> y `pre-bash-testing.sh` **nunca** estuvieron cargados en `settings.json` y
> fueron eliminados del repo. Bloqueos de commit/push se manejan con git hooks
> nativos (`.git/hooks/pre-commit`, `.git/hooks/pre-push`). Detalles en
> `.claude/docs/HOOKS_Y_TESTING.md` y `.claude/rules/testing-obligatorio.md`.

#### 1. PreToolUse - Write/Edit
**Hook**: `.claude/hooks/pre-write-rmd-gate.sh`

- Gate mecánico para `.Rmd` en `01-En-PreDesarrollo/` y `02-En-Desarrollo/`.
- Verifica `ejercicio_state.json` + pasos `analisis_icfes` y `flujo_b` completados.
- exit 2 bloquea el tool call con instrucciones concretas en stderr.

#### 2. PostToolUse - Bash (exams2*)
**Hook**: `.claude/hooks/post-exams2-validation.sh`

- FASE 2A: Validación matemática automática (Niveles 1-4).
- FASE 2B: Preview PNG automático (magick).
- FASES 2C-2H: Arsenal, multi-semilla y stress test visual.
- Claude DEBE: Leer PNG + Verificar 5 coherencias + Solicitar aprobación.

#### Git hooks nativos (NO cargados por Claude)
- `.git/hooks/pre-commit`: valida ortografía en .Rmd modificados. Tests opcionales con `PRECOMMIT_TESTS=1`.
- `.git/hooks/pre-push`: ejecuta `Rscript tests/run_all_tests.R` (modo quick soportado con `R_TESTS_QUICK=1`).
- **⚠️ PROHIBIDO**: `git commit --no-verify`.

### Cobertura de Tests

| Suite | Tests | Cobertura |
|-------|-------|-----------|
| Validación matemática | 5 | 100% |
| Ortografía española | 5 | 100% |
| Renderizado 4 formatos | 6 | 100% |
| Aleatorización | 4 | 100% |
| Flujo B Graficador | 6 | 100% |
| Regresión | 7 | 100% |
| Distintividad Visual _neg_ | 3 | 100% |
| Media-Mediana-Moda | 3 | 100% |
| Validación Semántica (Nivel 4) | 35 | 100% |
| Correctitud Respuesta (Nivel 5) | 14 | 100% |
| **TOTAL** | **82+** | **100%** |

### Garantías del Sistema

✅ Ningún cambio rompedor llega a código
✅ 100% de cobertura se mantiene
✅ Commits solo con tests pasando
✅ Push solo con validación completa
✅ Validación automática de .Rmd
✅ Claude no puede romper el sistema
✅ CI/CD adicional en remoto

---

## 🚨 Mensajes de Error Comunes

### Error: Flujo B Incompleto

```
❌ BLOQUEO: Flujo B Obligatorio

Se han detectado gráficos pero el Flujo B no ha sido ejecutado.

ACCIÓN REQUERIDA:
1. Ejecutar /auto-refinar-grafico tikz 95
2. Obtener aprobación usuario para TikZ
3. Ejecutar /auto-refinar-grafico python 95
4. Obtener aprobación usuario para Python
5. Ejecutar /auto-refinar-grafico r 95
6. Obtener aprobación usuario para R
7. Solo entonces generar .Rmd
```

### Error: Tests Fallaron Pre-Commit

```
❌ COMMIT RECHAZADO - TESTS FALLARON

Acciones requeridas:
1. Revisar errores de tests
2. Corregir código
3. Volver a ejecutar: Rscript tests/run_all_tests.R
4. Solo entonces hacer commit

⚠️ PROHIBIDO usar: git commit --no-verify
```

### Error: Validación Visual Omitida

```
❌ VALIDACIÓN INCOMPLETA

No se detectó inspección visual del ejercicio.

ACCIÓN REQUERIDA:
1. Read("preview.png") para mostrar al usuario
2. Verificar las 5 coherencias VISUALMENTE
3. Documentar hallazgos con checklist
4. Solicitar aprobación explícita del usuario

No proceder sin aprobación.
```

### Error: Detractor Omitido

```
❌ FASE 2C OMITIDA

No se ejecutó revisión detractor después de validación visual.

ACCIÓN REQUERIDA:
1. Ejecutar: /detractor auditoria [archivo.Rmd]
2. Revisar objeciones en 4 dominios
3. Corregir objeciones CRÍTICAS/ALTAS si existen
4. Solo continuar a FASE 3 si veredicto es APROBAR

No proceder sin revisión detractor.
```

---

## 9. Detractor Obligatorio en Revisiones

**Regla detallada**: @.claude/rules/detractor-obligatorio.md

### Principio Fundamental

**El skill-detractor DEBE invocarse AUTOMÁTICAMENTE en toda fase de revisión.**

El detractor actúa como revisor adversarial que confronta decisiones con fuentes de verdad.

### Puntos de Activación

| Punto | Activación | Bloqueo |
|-------|------------|---------|
| **Post-generación** | Después de `/generar-*` | Si hay objeciones CRÍTICAS/ALTAS |
| **FASE 2C** | Después de preview visual | Si veredicto es RECHAZAR |
| **Pre-promoción** | Antes de `/promover-ejercicio` | Si hay objeciones pendientes |

### Dominios de Revisión (8 dominios)

1. **Código R-exams**: exshuffle, metadatos, estructura
2. **Pedagógico**: Progressive Disclosure, metacognición, DOK/Bloom
3. **Visual**: Coherencia gráfico-texto, etiquetas, escalas
4. **Gramática**: Tildes, redacción, terminología
5. **Coherencia matemática**: Fórmulas, cálculos, distractores plausibles
6. **ICFES metacognitivo**: Progressive Disclosure, pool errores, DOK ≥ 2
7. **Testing**: Cobertura tests, git hooks, CI/CD
8. **Coherencia semántica**: Descripción error ↔ datos generados (3 capas) 🆕

### Formato de Invocación

```bash
# Modo Auditoría (completo)
/detractor auditoria [archivo.Rmd]
/detractor auditoria [directorio/]

# Modo Inline (rápido)
/detractor [pregunta específica]
```

### Umbrales de Severidad

| Nivel | Criterio | Acción |
|-------|----------|--------|
| **Crítica** | Errores matemáticos, pérdida coherencia | BLOQUEAR, corregir inmediato |
| **Alta** | Distractores inválidos, metadatos faltantes | Priorizar corrección |
| **Media** | Mejoras pedagógicas | Agregar a backlog |
| **Baja** | Estilo, convenciones | Ignorar |

### Integración con Ciclo de Validación

```
FASE 1: Renderizado
    ↓
FASE 2A: Validación matemática [hook]
    ↓
FASE 2B: Preview visual [hook]
    ↓
FASE 2C: Detractor [OBLIGATORIO] ← NUEVO
    ↓
FASE 3: Decisión usuario
```

### Prohibiciones

- ❌ **NUNCA** omitir FASE 2C
- ❌ **NUNCA** ignorar objeciones CRÍTICAS/ALTAS
- ❌ **NUNCA** promocionar sin auditoría previa
- ❌ **NUNCA** objetar sin fuente verificable (Nivel 1-2)

### Garantías

✅ Toda decisión confrontada con fuentes de verdad
✅ Sesgo de confirmación eliminado
✅ Calidad pedagógica validada científicamente
✅ Código R-exams cumple estándares oficiales

---

## 10. Skill-Retroalimentación Obligatorio (PERMANENTE) 🆕

**Skill detallado**: @.claude/skills/skill-retroalimentacion/SKILL.md

### Principio Fundamental

**TODO ejercicio .Rmd DEBE generar su sección Solution usando el skill-retroalimentacion.**

Este skill se ejecuta AUTOMÁTICAMENTE al generar ejercicios, pero también puede invocarse manualmente.

### Fuente Oficial

**ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023 (pp. 22-51)**

Esta es la fuente de verdad NIVEL 1 para el formato de retroalimentación.

### Estructura Obligatoria de Solution

```markdown
Solution
========

### Competencia, Componente, Afirmación y Evidencia
[Generado automáticamente desde metadatos]

### ¿Qué evalúa esta pregunta?
[Descripción específica de la capacidad evaluada]

### Justificación de la Respuesta Correcta
[Pasos matemáticos detallados con fórmulas LaTeX]

$$
\text{Fórmula correcta}
$$

### Opciones No Válidas
**Opción A:** Es posible que los estudiantes que eligen la opción A
[error conceptual específico]...

**Opción B:** Es posible que los estudiantes que eligen la opción B
[error conceptual específico]...

[Continúa para CADA distractor]

### Reflexión Metacognitiva
[Estrategias para evitar errores comunes]
```

### Patrón ICFES Obligatorio

Para cada distractor, DEBE usarse el patrón:

> "Es posible que los estudiantes que eligen la opción X [verbo] [error conceptual específico]..."

**Ejemplos**:
- "Es posible que los estudiantes que eligen la opción B **confundan** el porcentaje con la cantidad absoluta..."
- "Es posible que los estudiantes que eligen la opción C **apliquen incorrectamente** la fórmula del área..."
- "Es posible que los estudiantes que eligen la opción D **no consideren** el orden de operaciones..."

### Invocación Manual

```bash
/skill-retroalimentacion [archivo.Rmd]
```

### Verificación Obligatoria

Antes de aprobar cualquier ejercicio, verificar que la sección Solution incluye:

- [ ] Encabezado diagnóstico (Competencia, Componente, Afirmación, Evidencia)
- [ ] Descripción de qué evalúa
- [ ] Justificación matemática completa con LaTeX
- [ ] Análisis de CADA distractor con patrón ICFES
- [ ] Reflexión metacognitiva

### PROHIBIDO

```markdown
# ❌ PROHIBIDO: Solution sin análisis de distractores
Solution
========
La respuesta correcta es 40.

# ❌ PROHIBIDO: Análisis sin patrón ICFES
**Opción B es incorrecta** porque usa la fórmula equivocada.

# ✅ CORRECTO: Análisis con patrón ICFES
**Opción B:** Es posible que los estudiantes que eligen la opción B
confundan la fórmula del área (b × h) con la del perímetro (2b + 2h)...
```

---

## 11. Validación _neg_ Opciones Repetidas (OBLIGATORIO) 🆕

**Regla detallada**: @.claude/rules/validacion-neg-opciones-repetidas.md

### Principio Fundamental

**Todo ejercicio con `_neg_` en el nombre DEBE incluir el test genérico de opciones repetidas. Todo ejercicio SIN `_neg_` DEBE verificar que todas las opciones son únicas.**

### Lógica Negativa vs Positiva

| Tipo | Patrón de opciones | Requisito |
|------|-------------------|-----------|
| **Positiva** (sin `_neg_`) | 1 correcta + (N-1) distractores únicos | TODAS las opciones diferentes |
| **Negativa** (con `_neg_`) | (N-1) correctas idénticas + 1 error | (N-1) idénticas + 1 diferente |

### Dos Variantes de Test

| Variante | Tipo de opciones | Equivalencia | Test |
|----------|-----------------|-------------|------|
| **A** (Datos/Gráficos) | Estructuras numéricas | Datos idénticos, diferenciados por color | `digest::digest()` → 2 hashes |
| **B** (Texto) | Afirmaciones/justificaciones | Significado idéntico, redacción diferente (sinónimos) | Etiquetas semánticas (`correcta1..N`, `error`) |

```r
# Variante A: digest() para datos/gráficos
hashes <- sapply(letras, function(l) digest::digest(opciones_data[[l]]))
# → (N-1) hashes iguales + 1 diferente

# Variante B: etiquetas semánticas para texto
expect_true("error" %in% names(opciones_mezcladas))
expect_equal(sum(grepl("^correcta", names(opciones_mezcladas))), n_opciones - 1)
# + verificar que los textos son todos diferentes (no copiar-pegar)
```

### Convenciones Obligatorias

- **Nomenclatura**: `_neg_` antes de `_v[N]` en el nombre del archivo
- **Gráficos**: `colores_opciones` con N colores únicos y neutrales
- **Texto**: (N-1) opciones correctas formuladas como sinónimos/paráfrasis
- **`sol`**: Marca la opción con ERROR (respuesta correcta a seleccionar)
- **Pregunta**: Incluye "***NO***" con énfasis visual
- **DOK**: ≥ 3 (la lógica negativa aumenta la demanda cognitiva)

### Detección Automática

Claude DEBE detectar `_neg_` en el nombre del archivo y aplicar la variante de validación correspondiente (A o B) automáticamente.

---

## 12. Contextos Narrativos Creativos (OBLIGATORIO)

**Regla detallada**: @.claude/rules/contextos-narrativos-creativos.md

### Principio

**PROHIBIDO el patrón mecánico "Un(a) [oficio], [nombre], registró [datos]".**

Pool de 6+ plantillas narrativas como funciones, 5+ tipos de estructura diferentes.

---

## 13. Validación Correctitud de Respuesta (Nivel 5) - OBLIGATORIO 🆕

**Regla detallada**: @.claude/rules/validacion-correctitud-respuesta.md

### Principio Fundamental

**El sistema DEBE verificar automáticamente que la respuesta marcada como correcta ES realmente la correcta matemáticamente, que los distractores son únicos y diferentes de la respuesta correcta, y que los valores están en rangos válidos.**

### Sub-niveles de Validación

| Sub-nivel | Qué valida | Código de error |
|-----------|-----------|----------------|
| **5A** | exsolution dinámico (`` `r expr` ``) evalúa correctamente | `ERR_ANS_A` |
| **5B** | Respuesta marcada coincide con valor_correcto calculado | `ERR_ANS_B` |
| **5C** | Opciones únicas en runtime (o patrón _neg_ correcto) | `ERR_ANS_C` |
| **5D** | Rangos matemáticos válidos (mediana, cuartiles, probabilidades) | `ERR_ANS_D` |
| **5E** | Ningún distractor idéntico a la respuesta correcta | `ERR_ANS_E` |

**Todos los errores son BLOQUEANTES.** No hay excepciones.

### Validación Multi-semilla

El script `validar_multisemilla.R` ejecuta el .Rmd N veces con diferentes semillas:

| Modo | Semillas | Uso |
|------|----------|-----|
| Rápido | 20 | Hook automático (FASE 2G) |
| Exhaustivo | 100 | Pre-promoción |

```bash
# Rápido (hook automático)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --n 20

# Exhaustivo (pre-promoción)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --modo exhaustivo
```

### Integración con Hook

```
FASE 2A: Coherencia matemática (Niveles 1-4)
FASE 2B: Preview visual (PDF → PNG)
FASES 2C-2F: Arsenal estático
FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5) ← NUEVO
```

La FASE 2G solo se ejecuta si las fases anteriores no tienen errores.

### Variables Detectadas Automáticamente

- **Vectores de solución**: `sol`, `solucion`, `solucion_vector`
- **Valor correcto**: `valor_correcto`, `mediana_calc`, `respuesta_correcta`, `media_correcta`, `mediana_correcta`, `moda_correcta`
- **Opciones**: `opciones_mezcladas`, `opciones_graficos`, `opciones_valores`, `opciones`
- **Datos**: `datos_ord`, `datos`
- **Cuartiles**: `cuartiles_correctos` (lista con `q1`, `mediana`, `q3`)
- **Probabilidades**: Variables con `prob` en el nombre → rango [0, 1]
- **Porcentajes**: Variables con `porcentaje`, `pct`, `percent` → rango [0, 100]

---

## 14. Routing de Modelos Obligatorio (Opus/Sonnet/Haiku) 🆕

**Regla detallada**: @.claude/rules/modelo-routing-obligatorio.md
**Referencia completa**: @.claude/docs/MODELO_ROUTING.md

### Principio Fundamental

**Cada skill y agente DEBE ejecutarse con el modelo apropiado según su complejidad cognitiva. Claude DEBE delegar vía `Task(model=X)` cuando un skill tiene `model_recommendation` diferente de Opus.**

### Clasificación por Tier

| Tier | Modelo | Cuándo usar | Ejemplos |
|------|--------|-------------|----------|
| **Opus 4.6** | `claude-opus-4-6` | Razonamiento profundo, generación .Rmd, revisión adversarial | generar-schoice, generar-cloze, skill-detractor, skill-retroalimentacion |
| **Sonnet 4.5** | `claude-sonnet-4-5-20250929` | Generación de código gráfico, diagnóstico, comparación visual | generar-codigo-tikz/python/r, diagnosticar-errores, comparar-similitud-visual |
| **Haiku 4.5** | `claude-haiku-4-5-20251001` | Validaciones mecánicas, estado, transferencia | validar-renderizado, validar-coherencia, estado-graficador, promover-ejercicio |

### Mecanismo de Delegación

```
Claude lee skill con model_recommendation: sonnet
    ↓
Claude DEBE ejecutar:
    Task(subagent_type="general-purpose", model="sonnet",
         prompt="[instrucciones del skill + contexto]")
    ↓
Sub-agente ejecuta con modelo Sonnet
    ↓
Resultado regresa a Claude (Opus)
```

### Ahorro Estimado

- **50-60%** reducción en tokens/costos
- **Sin degradación** de calidad (cada modelo opera en su zona óptima)
- **22 skills** con `model_recommendation` en frontmatter YAML
- **6 agentes** con modelo actualizado en frontmatter

### PROHIBIDO

```
❌ Ejecutar validaciones mecánicas (Haiku) directamente en Opus
❌ Ejecutar generación .Rmd o detractor en Sonnet/Haiku
❌ Ignorar model_recommendation del frontmatter
❌ Omitir delegación vía Task() para skills no-Opus
```

---

## 📋 Checklist de Cumplimiento

Antes de finalizar CUALQUIER ejercicio:

- [ ] **Ejercicio es metacognitivo** (patrón aplicado, no puramente procedimental)
- [ ] **Pool de errores conceptuales** definido (mínimo 4)
- [ ] **Metadatos cognitivos** presentes (DOK, Bloom, SOLO)
- [ ] **Solution incluye** análisis de error + reflexión metacognitiva
- [ ] Si tiene gráficos → Flujo B completado
- [ ] TikZ/Python/R aprobados secuencialmente (si aplica)
- [ ] 5 coherencias verificadas VISUALMENTE
- [ ] Preview PNG mostrado al usuario
- [ ] **FASE 2C Detractor ejecutada** (veredicto APROBAR) 🆕
- [ ] Ortografía validada (tildes correctas)
- [ ] Tests ejecutados y pasando (100%)
- [ ] Renderizado exitoso en 4 formatos
- [ ] 200+ versiones únicas generadas (250+ si no hay restricciones fuertes)
- [ ] Usuario aprobó explícitamente
- [ ] Documentación actualizada
- [ ] **Routing de modelos** respetado (skills delegados al modelo correcto) 🆕

**Si falta alguno → NO aprobar el ejercicio.**

---

**Versión**: 1.7
**Fecha**: 2026-02-14
**Módulo de**: @.claude/CLAUDE.md (v3.4.0)

### Cambios v1.7 (2026-02-14)

- **14 reglas fundamentales** (era 13, ahora 14): Routing de modelos obligatorio
- **Regla #14 nueva**: Routing Opus/Sonnet/Haiku por complejidad cognitiva
- **22 skills** con `model_recommendation` en frontmatter YAML
- **6 agentes** con modelo actualizado (Opus 4.6, Sonnet 4.5, Haiku 4.5)
- **Checklist** actualizado con verificación de routing

### Cambios v1.6 (2026-02-14)

- **13 reglas fundamentales** (era 12, ahora 13): Validación correctitud respuesta (Nivel 5)
- **Nivel 5 completo**: 5A (exsolution dinámico), 5B (cross-check), 5C (unicidad), 5D (rangos), 5E (distractor≠correcto)
- **Multi-semilla**: validar_multisemilla.R con 20/100 semillas
- **FASE 2G**: Integrada en hook post-exams2
- **10 suites de testing** (era 9): 82+ tests (era 68+)

### Cambios v1.5 (2026-02-13)

- **12 reglas fundamentales** (era 11, ahora 12): Validación semántica automática
- **8 dominios detractor** (era 7): agregado `coherencia_semantica`
- **9 suites de testing** (era 6): 68+ tests (era 33+)

### Cambios v1.4 (2026-02-08)

- **11 reglas fundamentales** (era 10, ahora 11)
- **Regla #11 nueva**: Validación `_neg_` opciones repetidas con `digest::digest()` genérico
- Regla aplica a: ejercicios con `_neg_` (verificar patrón N-1 idénticas + 1 diferente) y sin `_neg_` (verificar todas únicas)

### Cambios v1.3 (2026-02-07)

- **10 reglas fundamentales** (era 8, ahora 10)
- **Regla #3 actualizada**: Graficador Secuencial v2.0 (98% fidelidad, iteraciones automáticas, usuario decide)
- **Regla #4 nueva**: Gráficos como opciones individuales (PNGs separados, sin títulos con letras)
- **Regla #9 actualizada**: Detractor ahora tiene 7 dominios (era 4)
- **Regla #10 nueva**: Skill-retroalimentación obligatorio para sección Solution
- Referencias cruzadas actualizadas en toda la documentación

### Cambios v1.2 (2026-02-07)

- Añadida regla #8 Detractor Obligatorio en fases de revisión
- Integración de FASE 2C en ciclo de validación

### Cambios v1.1 (2026-02-06)

- Añadida regla #1 Ejercicios Metacognitivos con Progressive Disclosure
- Pool de errores conceptuales obligatorio
- Metadatos cognitivos (DOK, Bloom, SOLO)
