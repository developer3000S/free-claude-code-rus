# Sistema de Generación Automatizada de Ejercicios ICFES R/exams

## 🎯 Índice Principal

Este archivo funciona como **índice central** del sistema. Para información detallada, consulte los módulos especializados:

### 📋 Información General
- **Propósito**: Automatizar creación y validación de ejercicios ICFES tipo SCHOICE/CLOZE
- **Tecnologías**: R/exams, TikZ, Python/matplotlib, R/ggplot2
- **Formatos soportados**: HTML, PDF, DOCX, NOPS
- **Versiones por ejercicio**: 250+ únicas aleatorias

### ⛔ Reglas Críticas (OBLIGATORIAS)
@.claude/docs/REGLAS_CRITICAS.md

**Resumen de reglas fundamentales:**
1. **Ejercicios metacognitivos** con Progressive Disclosure → @.claude/rules/ejercicios-metacognitivos.md
2. **Flujo B obligatorio** cuando hay gráficos → @.claude/rules/flujo-b-obligatorio.md
3. **Proceso secuencial** TikZ→Python→R (98% fidelidad, usuario decide) → @.claude/rules/graficador-secuencial.md
4. **Gráficos como opciones individuales** (PNGs separados) → @.claude/rules/graficos-como-opciones.md
5. **5 Coherencias** a verificar siempre (Semántica, Visual-Texto, Matemática, Código, General)
6. **Validación visual iterativa** OBLIGATORIA → @.claude/rules/ciclo-validacion.md
7. **Ortografía española** con tildes → @.claude/rules/ortografia-espanol.md
8. **Testing automático** permanente → @.claude/rules/testing-obligatorio.md
9. **Detractor obligatorio** en fases de revisión → @.claude/rules/detractor-obligatorio.md
10. **Validación _neg_ opciones repetidas** → @.claude/rules/validacion-neg-opciones-repetidas.md
11. **Contextos narrativos creativos** (no mecánicos) → @.claude/rules/contextos-narrativos-creativos.md
12. **Validación semántica automática** (Nivel 4: descripción ↔ datos) → @.claude/rules/ejercicios-metacognitivos.md (sección Validación Semántica)
13. **Validación correctitud respuesta** (Nivel 5: multi-semilla + cross-check) → @.claude/rules/validacion-correctitud-respuesta.md
14. **Routing de modelos obligatorio** (Opus/Sonnet/Haiku por complejidad) → @.claude/rules/modelo-routing-obligatorio.md
15. **Stress Test Visual** (FASE 2H: renderizado masivo + análisis anomalías) → @.claude/skills/stress-test-visual/SKILL.md
16. **Workflow State Enforcement** (gate mecánico PreToolUse + estado persistente) → @.claude/rules/workflow-state-enforcement.md
17. **Infraestructura `.claude/` protegida** (backups + verificación de invariantes I-1 a I-7 antes/después de plataformas externas) → @.claude/rules/infraestructura-protegida.md
18. **Markdown-imágenes-PDF (anti `\pandocbounded`)** → @.claude/rules/markdown-imagenes-pdf.md
    Toda imagen `.png/.jpg/.svg/.pdf` emitida vía Markdown (directa o `cat()`) en `.Rmd` DEBE incluir atributo `{width=...}`. Pandoc 3.x sin width genera `\pandocbounded` no definido en LaTeX → rompe `exams2pdf()`. Coupled con regla #6 ampliada (`exshuffle: FALSE` para Solution con letra explícita). Errores 16-17 documentados.
19. **Solution letter-independence** (NUNCA `r letra_correcta` ni "Opción [A-D]" en Solution) → @.claude/rules/solution-letter-independence.md
    Defensa permanente contra Error 19. La sección Solution debe identificar opciones por contenido/código de error, NUNCA por letra/posición, porque Moodle (y otros LMS) pueden re-shufflear las opciones de forma independiente al `exshuffle` de R-exams, rompiendo coherencia letra ↔ contenido para el estudiante. Capas: hook FASE 2J + test_letter_independence.R + detractor.

### 🛠️ Comandos y Skills
@.claude/docs/COMANDOS_Y_SKILLS.md

**Comandos principales:**
- `/analizar-icfes`, `/generar-schoice`, `/generar-cloze`
- `/orquestador-schoice`, `/orquestador-cloze` - Pipeline end-to-end (11 pasos, 3 pausas humanas) 🆕
- `/revisar-schoice`, `/revisar-cloze` - Revisión completa pasos 4-11 del workflow
- `/skill-retroalimentacion` - Generación científica de sección Solution
- `/validar-pedagogico` - Análisis pedagógico avanzado basado en evidencias
- `/detractor auditoria [target]` - Revisión adversarial en 8 dominios
- `/auto-refinar-grafico [tikz|python|r]`
- `/estado-graficador`, `/exportar-graficos`, `/promover-ejercicio`

### 🔧 Sistema de Hooks y Testing
@.claude/docs/HOOKS_Y_TESTING.md

**Sistema automático permanente:**
- 2 hooks activos (PreToolUse: gate .Rmd + recordatorio tildes; PostToolUse: arsenal post-render)
- Gate mecánico: `pre-write-rmd-gate.sh` bloquea .Rmd sin `ejercicio_state.json`
- 100% cobertura de tests (12 suites, 130+ tests)
- CI/CD con GitHub Actions
- Tolerancia cero a regresiones

### 📁 Estructura del Repositorio
@.claude/docs/ESTRUCTURA_REPOSITORIO.md

**Directorios principales:**
```
A-Produccion/
├── 01-En-PreDesarrollo/         # Experimentación
├── 02-En-Desarrollo/            # En proceso
├── 03-En-Produccion/            # Validados (por categoría ICFES)
└── Ejemplos-Funcionales-Rmd/    # FUENTE DE VERDAD

.claude/
├── rules/                       # Reglas obligatorias
├── docs/                        # Documentación modular
├── hooks/                       # Hooks de validación
├── scripts/                     # Scripts de validación
├── skills/                      # Agent Skills
└── commands/                    # Slash Commands
```

### 📚 Documentación Técnica Detallada

#### Workflows y Validación
- @.claude/docs/WORKFLOW_PASO_A_PASO.md
- @.claude/docs/TRES_NIVELES_VALIDACION.md
- @.claude/docs/FLUJO_AUTOMATICO_TESTING.md
- @.claude/docs/TROUBLESHOOTING.md

#### Testing y Calidad
- @.claude/docs/ECOSISTEMA_TESTING.md
- @.claude/rules/testing-obligatorio.md
- @.claude/rules/documentacion-verificada.md

#### Código y Desarrollo
- @.claude/rules/codigo-rmd.md
- @.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md
- @.claude/docs/MEJORES_PRACTICAS_PYTHON_RETICULATE.md
- @.claude/docs/patrones-errores-conocidos.md

#### Casos Resueltos
- @.claude/docs/casos-resueltos/

### 🔗 Referencias Rápidas

| Necesito... | Ver documento |
|-------------|---------------|
| Iniciar desarrollo de ejercicio | @.claude/docs/WORKFLOW_PASO_A_PASO.md |
| Resolver error conocido | @.claude/docs/patrones-errores-conocidos.md |
| Entender hooks de testing | @.claude/docs/HOOKS_Y_TESTING.md |
| Configurar gráficos | @.claude/docs/REGLAS_CRITICAS.md + Flujo B |
| Gráficos como opciones SCHOICE | @.claude/rules/graficos-como-opciones.md |
| Workflow Graficador (98% + 3 lenguajes) | @.claude/rules/graficador-secuencial.md |
| Generar retroalimentación científica | @.claude/skills/skill-retroalimentacion/SKILL.md |
| Ver comandos disponibles | @.claude/docs/COMANDOS_Y_SKILLS.md |
| Validar ortografía | @.claude/rules/ortografia-espanol.md |
| Ejecutar tests | `tests/run_all_tests.R` |
| Revisar decisiones/código | @.claude/rules/detractor-obligatorio.md |
| Routing de modelos (Opus/Sonnet/Haiku) | @.claude/rules/modelo-routing-obligatorio.md |
| Stress test visual multi-semilla | @.claude/skills/stress-test-visual/SKILL.md |
| Revisar ejercicio SCHOICE existente | @.claude/skills/revisar-schoice/SKILL.md |
| Revisar ejercicio CLOZE existente | @.claude/skills/revisar-cloze/SKILL.md |
| Pipeline end-to-end SCHOICE (11 pasos) | @.claude/agents/orquestador-schoice.md + `/orquestador-schoice` |
| Pipeline end-to-end CLOZE (11 pasos) | @.claude/agents/orquestador-cloze.md + `/orquestador-cloze` |

### ⚙️ Configuración del Sistema

- **Settings Claude**: @.claude/settings.json
- **CI/CD**: @.github/workflows/ci-testing.yml
- **Tests**: `tests/testthat/` (12 suites)
- **Hooks**: `.claude/hooks/` (2 scripts activos cargados por settings.json)

---

## 📌 Metainformación

**Versión**: 3.14.0 (Checker ortográfico Python v2.0 + Error 22 + hook pre-commit 2-capas)
**Fecha**: 2026-05-18
**Basado en**: Documentación oficial Claude Code (nov 2025)

### Cambios v3.13.0 (2026-05-14)
- **NUEVA SECCIÓN**: Formato Equilibrado en `graficos-como-opciones.md` (v5.0) — al menos 2 opciones deben compartir el formato de la correcta
  - Previene que el estudiante adivine por formato sin verificar datos (ej: 3 tortas + 1 barra cuando la correcta siempre es torta)
  - Catálogo de distractores por formato: GRAF-TOR-01, GRAF-TOR-02, GRAF-TOR-03, GRAF-BAR-01
  - Verificación obligatoria en `data_generation`: `stopifnot(n_formato_correcto >= 2)`
- **ERROR 18**: Format-based guessing vulnerability — documentado en `patrones-errores-conocidos.md`
  - Detectado en v1 de `distribucion-contagiados`: la torta siempre era correcta y la barra siempre incorrecta
  - Fix: v2 con 2 barras + 2 tortas, correcta = barras
- **ERROR 20 (GRAF-BAR-01)**: Nuevo patrón de distractor — barras con categorías correctas pero alturas permutadas
  - Pasa verificación de categorías, solo falla en verificación de valores por categoría
  - Permite equilibrio 2+2 sin sacrificar calidad de distractores
- **EJERCICIO**: `distribucion_contagiados_metacognitivo_interpretacion_n3_schoice_v2.Rmd` — correcta = barras, 2+2 equilibrio
- **MEMORIA**: 2 nuevas memorias de feedback persistente (format-diversity, GRAF-BAR-01)
- **DOCS**: `INDICE_LECCIONES.md` actualizado con errores 18/20 + v3.13.0

### Cambios v3.12.0 (2026-05-14)
- **NUEVO ORQUESTADOR CLOZE**: `/orquestador-cloze` — pipeline end-to-end de 11 pasos para ejercicios CLOZE, gemelo de `/orquestador-schoice`.
  - Agente: `.claude/agents/orquestador-cloze.md` (Opus, 65 turnos, 400+ líneas)
  - Comando: `.claude/commands/orquestador-cloze.md` (wrapper que valida y delega)
  - Soporta: 4+ partes Progressive Disclosure, exclozetype multi-gap, validaciones V1-V4 específicas CLOZE
  - Mismos 3 WAIT_USER que SCHOICE (Flujo B, lenguaje gráfico, aprobación)
  - NOPS tratado como N/A esperado cuando hay gaps num/string (no como error)
  - 5 incidentes documentados específicos CLOZE (##ANSWERi## fuera de orden, pandocbounded, letter-independence en sub-partes, colapso pools mchoice, NOPS falso error)
- **INFRAESTRUCTURA**: I-5 (invariante de agentes) sube de 8 a 9 agentes con la adición de orquestador-cloze
- **DOCS**: `COMANDOS_Y_SKILLS.md` actualizado con documentación completa de ambos orquestadores + tabla comparativa SCHOICE vs CLOZE
- **REFERENCIAS CRUZADAS**: `CLAUDE.md` índice actualizado con los 2 orquestadores

### Cambios v3.14.0 (2026-05-18)
- **NUEVO SCRIPT PYTHON**: `corregir_ortografia_espanol.py` — checker ortográfico con ~500+ palabras (3.5× más cobertura que el R legacy) y detección de strings multilínea
- **ERROR 22**: Ortografía masiva en strings R no detectada por el checker legacy — documentado en `patrones-errores-conocidos.md`
- **HOOK PRE-COMMIT**: `pre-commit-ortografia.sh` actualizado a 2 capas (Python + R fallback)
- **DICCIONARIO**: ~500+ palabras (era ~140). Cobertura de falsos negativos: ~95% → ~0%
- **MEMORIA**: 1 nuevo archivo de feedback persistente (`feedback_ortografia_checker_python.md`)
- **INDICE_LECCIONES.md**: actualizado con Error 22 + v3.14.0

### Cambios v3.11.0 (2026-05-12)
- **NUEVA REGLA #19**: `solution-letter-independence.md` — prohíbe `r letra_correcta` y literal "Opción [A-D]" en la sección Solution. Defensa contra re-shuffle externo (Moodle "Shuffle answers").
- **HOOK FASE 2J**: `post-exams2-validation.sh` agrega detector de patrones P1-P4 en Solution. Errores `ERR_SOL_LETRA_R`, `ERR_SOL_LETRA_CAT`, `ERR_SOL_LETRA_LITERAL` (todos bloqueantes).
- **NUEVO TEST**: `tests/testthat/test_letter_independence.R` (4 tests). Lista legacy con 8 .Rmd conocidos (action item de fix pendiente).
- **SCRIPT ORTOGRAFÍA**: `corregir_ortografia_espanol.R` arregla 3 falsos positivos sistemáticos: variables R entre strings concatenados (esta_en_string roto), anchors Markdown `{#...}`, rutas/nombres de archivo en comentarios.
- **ORQUESTADOR-SCHOICE**: pre-flight checks 8-10 (regla #19, test, hook FASE 2J), Incidente C en lecciones absorbidas, paso 4 de validación realista.
- **TESTS**: 13 suites enganchadas al runner (era 12).
- **ERROR 19 EN CATÁLOGO**: documentado en `patrones-errores-conocidos.md`.
- **EJERCICIO PILOTO**: `Comparacion-Lineas-Temporales-Schoice` renombrado desde `Comparacion-Lineas-Fertilizantes-Rusia-China` + 5 fixes (commit `86a4b211`).
- **REGLA #6 EXCEPCIÓN #2 OBSOLETA**: la excepción "exshuffle:FALSE permitido si Solution referencia letra" queda obsoleta porque la regla #19 prohíbe esa referencia.

### Cambios v3.10.0 (2026-05-03)
- **NUEVA REGLA #18**: `markdown-imagenes-pdf.md` — anti `\pandocbounded undefined`. Toda imagen Markdown en `.Rmd` debe llevar `{width=...}`.
- **REGLA #6 AMPLIADA** (codigo-rmd.md): `exshuffle: FALSE` también obligatorio cuando Solution referencia `r letra_correcta` o "Opción [A-D]" hardcoded.
- **NUEVO TEST DE REGRESIÓN**: `tests/testthat/test_pandocbounded_y_solution_coherence.R` (10 tests) — análisis estático de Markdown sin width + combinación exshuffle:TRUE+letra explícita.
- **HOOK FASE 2I**: `post-exams2-validation.sh` agrega detección automática de `\pandocbounded` en `.tex` recientes y patrones Markdown sin width en el `.Rmd`.
- **AGENTE orquestador-schoice**: pre-flight checks ampliados (#6, #7) + sección "Lecciones absorbidas de sesiones previas" con incidentes A-B + validación realista obligatoria.
- **SKILL generar-schoice**: patrones obligatorios documentados con ejemplos correcto/prohibido.
- **MEMORIA GLOBAL**: 3 nuevos archivos de feedback persistente (`feedback_pandocbounded.md`, `feedback_exshuffle_solution_coherence.md`, `feedback_validation_realista.md`).
- **ERRORES 16-17 EN CATÁLOGO**: documentados en `patrones-errores-conocidos.md` (líneas 1782-2024).
- **INDICE_LECCIONES.md**: actualizado con sección 2.5 (pipeline render PDF + coherencia Solution).
- **TESTS**: 12 suites enganchadas a runner (era 11).

### Cambios v3.8.0 (2026-04-10)
- **INFRAESTRUCTURA: resuelto drift hooks/tests/CI/docs** — una sola fuente de verdad por componente.
- **Runner ejecuta 12 suites** (antes 10): `test_cloze_n3.R` y `test_stress_test_visual.R` enganchadas al runner y al modo quick.
- **CI simplificado**: `.github/workflows/ci-testing.yml` reemplazado por un único job `tests-full` que invoca `Rscript tests/run_all_tests.R`. Upgrades a `actions/checkout@v4` y `actions/upload-artifact@v4`.
- **Hooks muertos eliminados**: `pre-edit-testing.sh`, `post-edit-testing.sh` y 3 docs stub. `settings.json` carga únicamente los 2 hooks activos (`pre-write-rmd-gate.sh`, `post-exams2-validation.sh`).
- **Fix aritmético en `post-exams2-validation.sh`**: el conteo del arsenal ya no se duplica cuando el script reporta `Total ERRORES: N` y además falla con exit≠0.
- **Fix ruta en `test_stress_test_visual.R`**: source basado en `git rev-parse --show-toplevel` — la suite ya corre desde cualquier cwd.

### Cambios v3.7.0 (2026-03-23)
- **SKILLS DE REVISIÓN**: `/revisar-schoice` y `/revisar-cloze` ejecutan pasos 4-11 del workflow
  - Skill SCHOICE: `.claude/skills/revisar-schoice/SKILL.md` (model_recommendation: sonnet)
  - Skill CLOZE: `.claude/skills/revisar-cloze/SKILL.md` (model_recommendation: sonnet)
  - Detectan automáticamente paso pendiente y retoman workflow interrumpido
  - Validaciones específicas por tipo (exsolution binario, ##ANSWERi##, exclozetype)
- **SKILLS GENERACIÓN v4.0**: `/generar-schoice` y `/generar-cloze` ahora cubren 11 pasos completos
  - 5 pasos antes ausentes: retroalimentación, detractor, coherencias, diversidad, validar-icfes
  - `workflow-state.sh init` + `complete` integrado en cada paso
  - Diagrama de integración actualizado con flujo completo
- **25 SKILLS** (era 23): +revisar-schoice, +revisar-cloze
- **DOCS**: `COMANDOS_Y_SKILLS.md` actualizado con los nuevos skills

### Cambios v3.6.0 (2026-02-14)
- **STRESS TEST VISUAL MULTI-SEMILLA**: Renderiza N veces con exams2pdf(), analiza anomalías, genera PNGs
  - Script R: `SOURCES/scripts_validacion/stress_test_visual.R` (~450 líneas)
  - Skill: `.claude/skills/stress-test-visual/SKILL.md` (model_recommendation: sonnet)
  - Tests: `tests/testthat/test_stress_test_visual.R` (28 tests)
  - Anomalías detectadas: ANOM_COMPILE, ANOM_DUP_OPT, ANOM_DIST_EQ_CORR, ANOM_POS_FIJA, ANOM_BAJA_VAR, ANOM_NA_INF, ANOM_CTX_REPET, ANOM_NEG_PATRON
- **FASE 2H nueva**: Integrada en hook `post-exams2-validation.sh` v6.0
  - Se ejecuta automáticamente después de FASE 2G si no hay errores previos
  - 10 semillas por defecto, renderizado real con exams2pdf()
  - Claude inspecciona PNGs de semillas sospechosas
- **11 SUITES DE TESTING** (era 10): 110+ tests (era 82+)
- **23 SKILLS** (era 22): +stress-test-visual (Sonnet)
- **Regla #15 nueva**: Stress Test Visual automático y permanente

### Cambios v3.5.0 (2026-02-14)
- **CAPA D: DETERMINISMO DE calcula()**: Nueva capa de validación semántica
  - Análisis estático: `deparse()` escanea `sample(`, `runif(`, `rnorm(`, etc.
  - Test empírico: ejecuta `calcula()` 2 veces con mismos args, compara resultados
  - `ERR_SEM_D`: error seleccionado no determinista (bloqueante)
  - `WARN_SEM_D`: error en pool no determinista (bug latente, informativo)
- **FIX EST-MTC-03**: `calcula()` usaba `sample(datos_ord)` — reemplazado por `datos_presentados`
  - `set.seed()` del multi-semilla enmascaraba el no-determinismo
  - Firma estándar ahora: `function(datos_ord, datos_presentados = NULL)`
- **REGLA**: `calcula()` DEBE ser función pura — PROHIBIDO `sample/runif/rnorm` dentro
- **6 tests nuevos** en `test_validacion_semantica.R` para Capa D
- **Docs actualizados**: `ejercicios-metacognitivos.md`, `validacion-correctitud-respuesta.md`

### Cambios v3.4.0 (2026-02-14)
- **ROUTING DE MODELOS OBLIGATORIO**: Cada skill/agente usa el modelo apropiado por complejidad
  - Opus 4.6: 6 skills (generación .Rmd, detractor, retroalimentación, análisis pedagógico) + 2 agentes
  - Sonnet 4.5: 9 skills (generación gráficos, comparación visual, diagnóstico) + 3 agentes
  - Haiku 4.5: 7 skills (validaciones, estado, transferencia, promoción) + 1 agente
- **6 AGENTES actualizados**: Modelos obsoletos (claude-3-5-sonnet, opus-4-5) → modelos actuales
- **22 SKILLS con `model_recommendation`**: Metadata en frontmatter YAML
- **16 SKILLS con bloque ROUTING**: Delegación obligatoria via `Task(model=X)`
- **Regla #14 nueva**: `.claude/rules/modelo-routing-obligatorio.md`
- **Doc de referencia**: `.claude/docs/MODELO_ROUTING.md` (tabla completa)
- **Ahorro estimado**: 50-60% en tokens/costos sin degradar calidad

### Cambios v3.3.0 (2026-02-14)
- **VALIDACIÓN CORRECTITUD NIVEL 5**: Cross-check respuesta marcada vs valor correcto
  - 5A: Evaluación de exsolution dinámico (`` `r expr` ``)
  - 5B: Cross-check respuesta marcada vs valor_correcto calculado
  - 5C: Unicidad de opciones en runtime (digest::digest)
  - 5D: Validación de rangos matemáticos (mediana, cuartiles, probabilidades)
  - 5E: Distractor ≠ respuesta correcta
- **VALIDACIÓN MULTI-SEMILLA**: Script `validar_multisemilla.R` (20 semillas rápido, 100 exhaustivo)
- **FASE 2G nueva**: Multi-semilla rápida integrada en hook post-exams2
- **10 SUITES DE TESTING** (era 9): 82+ tests (era 68+)
  - Nueva suite: `test_correctitud_respuesta.R` (14 tests)
- **Errores nuevos**: ERR_ANS_A/B/C/D/E (todos bloqueantes)
- **Regla #13 nueva**: Validación correctitud respuesta automática y permanente

### Cambios v3.2.3 (2026-02-13)
- **VALIDACIÓN SEMÁNTICA NIVEL 4**: Sistema de 3 capas integrado globalmente
  - Capa A: Precondiciones declaradas (`precondicion` en cada error del pool)
  - Capa B: Scanner automático de 21 keywords semánticas
  - Capa C: Cross-validación `calcula()` ≠ valor correcto
- **8 DOMINIOS DETRACTOR** (era 7): agregado `coherencia_semantica`
- **9 SUITES DE TESTING** (era 6): 68+ tests (era 33+)
  - Nueva suite: `test_validacion_semantica.R` (35 tests)
  - Nueva suite: `test_media_mediana_moda.R` (3 tests)
  - Nueva suite: `test_neg_visual_distinctness.R` (3 tests)
- **Errores semánticos**: ERR_SEM_A/B/C y WARN_SEM_B documentados
- **Bug fix**: tryCatch scoping en R (asignaciones no propagaban al scope externo)
- **Regla #12 nueva**: Validación semántica automática (descripción ↔ datos)

### Cambios v3.2.2 (2026-02-07)
- **GRÁFICOS COMO OPCIONES INDIVIDUALES**: Nueva regla `.claude/rules/graficos-como-opciones.md`
  - Cada opción gráfica DEBE ser PNG separado (diagrama_a.png, etc.)
  - PROHIBIDO usar `grid.arrange()` para mostrar opciones juntas
  - Answerlist DEBE referenciar imágenes individuales
- **GRAFICADOR SECUENCIAL v2.0**: Actualizado `.claude/rules/graficador-secuencial.md`
  - Umbral de fidelidad: 95% → **98%**
  - Iteraciones: Manuales → **AUTOMÁTICAS**
  - Lenguajes: SIEMPRE generar **TikZ + Python + R** (los tres)
  - Decisión final: Claude NO puede elegir → **USUARIO SIEMPRE DECIDE**
- **3 NUEVOS PATRONES DE ERROR** documentados en `patrones-errores-conocidos.md`:
  - Error 4: Gráficos en grid (no individuales)
  - Error 5: EST-BOX-01 escala incompatible
  - Error 6: sample() sin rango suficiente

### Cambios v3.2.1 (2026-02-07)
- **7 DOMINIOS DE REVISIÓN**: código, pedagógico, visual, gramática, matemático, metacognitivo, testing
- **Nuevos dominios**:
  - `coherencia_matematica`: Fórmulas, cálculos, proporciones, distractores plausibles
  - `icfes_metacognitivo`: Progressive Disclosure, pool errores, metadatos DOK/Bloom/SOLO
  - `testing`: Cobertura tests, git hooks nativos, CI/CD
- **Integración mejorada** con testing-obligatorio.md y ejercicios-metacognitivos.md

### Cambios v3.2 (2026-02-07)
- **DETRACTOR OBLIGATORIO**: Skill-detractor se ejecuta automáticamente en fases de revisión
- **Nueva regla**: `.claude/rules/detractor-obligatorio.md`
- **FASE 2C añadida**: Revisión adversarial después de validación visual
- **Ciclo de validación v4.0**: FASE 1 → 2A → 2B → 2C (detractor) → FASE 3
- **Puntos de activación**: Post-generación, FASE 2C, pre-promoción
- **Config por defecto**: `.claude/detractor-config.yaml`

### Cambios v3.1 (2026-02-06)
- **EJERCICIOS METACOGNITIVOS OBLIGATORIOS**: Todo .Rmd debe aplicar Progressive Disclosure
- **Nueva regla**: `.claude/rules/ejercicios-metacognitivos.md`
- **Skills actualizados**: generar-schoice v3.0, generar-cloze v3.0
- **Nueva referencia**: `anatomia-metacognitiva.md` para estructura de 8 secciones
- **Pool de errores conceptuales**: Ahora obligatorio con códigos y funciones `calcula()`
- **Metadatos cognitivos**: DOK, Bloom, SOLO ahora obligatorios
- **Antipatrones documentados**: Ejercicios puramente procedimentales PROHIBIDOS

### Cambios v3.0 (2026-02-04)
- **MODULARIZACIÓN COMPLETA**: CLAUDE.md ahora es índice central
- **Nuevos módulos**:
  - `REGLAS_CRITICAS.md` - Consolidación de reglas obligatorias
  - `COMANDOS_Y_SKILLS.md` - Referencia completa de comandos
  - `HOOKS_Y_TESTING.md` - Sistema automático de validación
  - `ESTRUCTURA_REPOSITORIO.md` - Organización del proyecto
- **Mejora de navegación**: Enlaces directos a cada módulo
- **Tabla de referencias rápidas**: Acceso inmediato por necesidad

### Cambios v2.7 (2026-02-03)
- Sistema de Testing Automático PERMANENTE
- 4 hooks activos configurados
- Garantía: IMPOSIBLE romper el sistema
- PROHIBIDO: `git commit --no-verify`

### Cambios v2.6 (2026-02-03)
- Ecosistema de Testing Agresivo implementado
- COBERTURA 100% ALCANZADA: 9 suites, 68+ tests unitarios
- CI/CD automático con GitHub Actions

### Historial Completo
Ver @.claude/docs/CHANGELOG.md para historial detallado de cambios v2.2-v2.5

---

**Principio Fundamental**: Este sistema garantiza calidad mediante validación automática permanente. NO hay forma de evadir las protecciones de testing. Toda modificación es validada antes y después de su aplicación.
