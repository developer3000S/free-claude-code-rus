# Manual de Usuario — Ecosistema `.claude/` ICFES R/exams

> Manual operativo del repositorio ICFES R/exams. Si vas a generar, revisar o promover un ejercicio, este es el archivo a leer primero.

**Versión del manual:** 1.0
**Fecha:** 2026-05-03
**Para Claude Code 2026 con Ruflo (claude-flow v3) instalado en convivencia (ADR-001)**

---

## TL;DR

- Para generar un `.Rmd` SCHOICE de cabo a rabo: `Task(subagent_type="orquestador-schoice", prompt='{...}')`.
- Para generar paso a paso: `/analizar-icfes` → `/generar-schoice` (o `/generar-cloze`).
- Para revisar un `.Rmd` ya hecho: `/revisar-schoice` o `/revisar-cloze`.
- Para auditar adversarialmente: `/adversario [archivo.Rmd]`.
- Para validar visualmente con stress test: `/stress-test-visual`.
- Si algo falla: consulta `INDICE_LECCIONES.md` antes de hipotetizar.

---

## 1. Mapa del ecosistema

### 1.1 Capas

```
┌─────────────────────────────────────────────────────┐
│  CAPA 1: ICFES (fuente de verdad)                   │
│  - .claude/CLAUDE.md      ← índice de 17 reglas     │
│  - .claude/rules/         ← 17 reglas en detalle    │
│  - .claude/agents/<X>.md  ← 8 agentes ICFES         │
│  - .claude/skills/<X>/    ← skills ICFES            │
│  - .claude/hooks/*.sh     ← gate + post-validation  │
│  - .claude/scripts/       ← workflow-state.sh, ... │
│  - tests/testthat/        ← 13 suites               │
└─────────────────────────────────────────────────────┘
                       ↑
                       │ (convivencia, ADR-001)
                       ↓
┌─────────────────────────────────────────────────────┐
│  CAPA 2: Ruflo (plataforma, descriptiva)            │
│  - CLAUDE.md raíz (Ruflo V3 abajo, ICFES arriba)    │
│  - .claude/helpers/hook-handler.cjs                  │
│  - .claude/agents/{60+ Ruflo}                       │
│  - .claude/skills/{... Ruflo}                       │
│  - .claude-flow/ (runtime data)                     │
└─────────────────────────────────────────────────────┘
                       ↑
                       │ (en conflicto: ICFES gana)
```

### 1.2 ¿Qué archivo me responde qué pregunta?

| Pregunta | Archivo |
|---|---|
| ¿Cómo es el flujo completo? | `WORKFLOW_PASO_A_PASO.md` |
| ¿Cuáles son las reglas? | `.claude/CLAUDE.md` (índice) → `.claude/rules/<X>.md` |
| ¿Hay un fix para este error? | `INDICE_LECCIONES.md` → `patrones-errores-conocidos.md` |
| ¿Por qué tomamos esta decisión? | `.claude/docs/ADR/<ADR-XXX>.md` |
| ¿Qué comandos existen? | `.claude/docs/COMANDOS_Y_SKILLS.md` |
| ¿Cómo configuro hooks? | `.claude/docs/HOOKS_Y_TESTING.md` |
| ¿Qué modelo uso? | `.claude/rules/modelo-routing-obligatorio.md` |
| ¿Cómo retomo un ejercicio interrumpido? | `bash .claude/scripts/workflow-state.sh status <dir>` |

---

## 2. Generar un ejercicio nuevo (3 modos)

### Modo A — Autónomo (recomendado)

Un solo comando, intervención humana mínima:

```python
Task(
  subagent_type="orquestador-schoice",
  prompt='{"ruta_destino": "A-Produccion/01-En-PreDesarrollo/<dir>",'
         ' "nombre_ejercicio": "<tema>_metacognitivo_<comp>_n<N>_schoice_v1",'
         ' "entrada": "<ruta imagen | texto enunciado>",'
         ' "modo": "ejecutar"}'
)
```

**3 pausas humanas obligatorias:**
1. ¿Requiere gráficos? (sí/no)
2. (si sí) ¿Qué lenguaje gráfico usar? (TikZ/Python/R)
3. ¿Apruebas el ejercicio final? (a/r/p)

Para auditar antes de ejecutar: cambia `"modo": "ejecutar"` por `"modo": "dry-run"`.

### Modo B — Paso a paso (control fino)

```bash
# 0. Init estado
.claude/scripts/workflow-state.sh init A-Produccion/01-En-PreDesarrollo/<dir> --tipo schoice

# 1. Análisis ICFES
/analizar-icfes [imagen | texto]

# 2. Decidir Flujo B
# (preguntar manualmente: ¿gráficos?)

# 2b. Si Flujo B = sí
/auto-refinar-grafico

# 3. Generar .Rmd
/generar-schoice
```

El skill `/generar-schoice` cubre los 11 pasos del workflow. Ver `COMANDOS_Y_SKILLS.md`.

### Modo C — Editar un `.Rmd` existente

Si ya tienes un `.Rmd` y quieres pasar pasos 4-11:

```bash
/revisar-schoice  # o /revisar-cloze
```

---

## 3. Validar y depurar

### 3.1 Renderizar 4 formatos

```r
library(exams)
exams2html("archivo.Rmd", n=1, dir="salida")
exams2pdf("archivo.Rmd", n=1, dir="salida")
exams2pandoc("archivo.Rmd", n=1, type="docx", dir="salida")
exams2nops("archivo.Rmd", n=1, dir="salida")
```

El hook `post-exams2-validation.sh` se dispara automáticamente y ejecuta FASES 2A-2H.

### 3.2 Tests testthat

```bash
# Todas las suites (modo completo, ~5-10 min)
Rscript tests/run_all_tests.R

# Modo quick (solo suites con cambios watch, ~40s)
R_TESTS_QUICK=1 Rscript tests/run_all_tests.R

# Una suite específica
Rscript -e 'testthat::test_file("tests/testthat/test_correctitud_respuesta.R")'
```

### 3.3 Auditoría adversarial

```bash
/adversario A-Produccion/01-En-PreDesarrollo/<dir>/<archivo>.Rmd
```

Revisa 8 dominios. Veredictos: APROBAR / APROBAR CON CAMBIOS / RECHAZAR.

### 3.4 Stress visual multi-semilla

```bash
/stress-test-visual A-Produccion/01-En-PreDesarrollo/<dir>/<archivo>.Rmd
```

Renderiza N semillas (default 10), detecta anomalías visuales (ANOM_DUP_OPT, ANOM_POS_FIJA, etc.).

### 3.5 Diagnóstico de errores

Si el render falla y no sabes por qué:

```bash
/diagnosticar-errores A-Produccion/01-En-PreDesarrollo/<dir>/<archivo>.Rmd
```

Consulta automáticamente `patrones-errores-conocidos.md` y propone fix.

---

## 4. Promover un ejercicio a producción

```bash
/promover-ejercicio A-Produccion/02-En-Desarrollo/<dir>
```

**Requisito:** evidencia de aplicación en aula con estudiantes reales (Nivel 3). El comando bloquea si no encuentra esta evidencia.

Mueve el ejercicio a `A-Produccion/03-En-Produccion/<categoria>/`.

---

## 5. Sub-agentes disponibles

| Sub-agente | Modelo | Cuándo invocar |
|---|---|---|
| `orquestador-schoice` | opus | Pipeline completo SCHOICE |
| `ClasificadorICFES` | haiku | Clasificar 6 dimensiones ICFES |
| `PedagogoICFES` | opus | Análisis pedagógico profundo |
| `AgenteDetractor` | opus | Auditoría adversarial 8 dominios |
| `AgenteValidadorVisual` | sonnet | Inspección visual coherencias |
| `AgenteCorrectorCoherencia` | sonnet | Aplicar fixes de coherencia |
| `AgenteDiagnosticador` | sonnet | Diagnóstico de errores complejos |
| `adversario` | sonnet | Análisis adversarial general |

Ejemplo de invocación:
```python
Task(subagent_type="ClasificadorICFES", prompt="Clasifica este ejercicio: ...")
```

Ver regla `modelo-routing-obligatorio.md` para la matriz completa.

---

## 6. Comandos / Skills disponibles

Ver `.claude/docs/COMANDOS_Y_SKILLS.md` para el catálogo completo. Resumen:

| Comando | Tipo | Modelo | Propósito |
|---|---|---|---|
| `/analizar-icfes` | skill | opus | Clasificación 6D + decisión Flujo B |
| `/generar-schoice` | skill | opus | Generar .Rmd SCHOICE metacognitivo (11 pasos) |
| `/generar-cloze` | skill | opus | Generar .Rmd CLOZE metacognitivo |
| `/revisar-schoice` | skill | sonnet | Revisar .Rmd existente (pasos 4-11) |
| `/revisar-cloze` | skill | sonnet | Revisar .Rmd CLOZE existente |
| `/skill-retroalimentacion` | skill | opus | Generar Solution científica |
| `/validar-pedagogico` | skill | opus | Análisis pedagógico (consultivo) |
| `/adversario` | command | sonnet | Auditoría adversarial |
| `/auto-refinar-grafico` | skill | sonnet | Workflow B: TikZ→Python→R hasta 98% |
| `/estado-graficador` | skill | haiku | Ver estado del workflow B |
| `/stress-test-visual` | skill | sonnet | Renderizar N semillas + análisis |
| `/diagnosticar-errores` | skill | sonnet | Diagnóstico con `patrones-errores-conocidos.md` |
| `/validar-renderizado` | skill | haiku | Ejecutar exams2* y reportar |
| `/validar-diversidad` | skill | haiku | Ejecutar testthat de diversidad |
| `/validar-icfes` | skill | haiku | Verificar 6 dimensiones ICFES |
| `/validar-coherencia` | skill | haiku | Checklist de 5 coherencias |
| `/promover-ejercicio` | skill | haiku | Mover a 03-En-Produccion (gates) |

---

## 7. Estructura del repositorio (operativa)

```
RepositorioMatematicasICFES_R_Exams/
├── A-Produccion/
│   ├── 01-En-PreDesarrollo/    ← Empieza aquí (gate: ejercicio_state.json)
│   ├── 02-En-Desarrollo/        ← Pasa cuando hay aprobación de Claude
│   ├── 03-En-Produccion/        ← Pasa cuando hay evidencia de aula (Nivel 3)
│   │   └── Ejemplos-Funcionales-Rmd/  ← INMUTABLE (fuente de verdad)
│   └── Ejemplos-Funcionales-Rmd/      ← INMUTABLE
├── tests/
│   └── testthat/                ← 13 suites
├── docus/
│   └── Base-de--Conocimiento-ICFES-Matematicas/
│       ├── Infografía Principal.md
│       └── Infografía-Principal.pdf
├── .claude/
│   ├── CLAUDE.md                ← ÍNDICE de 17 reglas
│   ├── rules/                   ← 17 reglas
│   ├── agents/                  ← 8 ICFES + 60+ Ruflo
│   ├── skills/                  ← 25+ ICFES + 35+ Ruflo
│   ├── commands/                ← Comandos personalizados
│   ├── hooks/                   ← pre-write-rmd-gate.sh, post-exams2-validation.sh, ...
│   ├── helpers/                 ← Ruflo (hook-handler.cjs, etc.)
│   ├── scripts/                 ← workflow-state.sh, ...
│   ├── docs/                    ← Manuales, índices, ADR, casos
│   │   ├── ADR/                 ← Architecture Decision Records
│   │   ├── templates/           ← retrospectiva-sesion.md
│   │   ├── casos-resueltos/     ← Histórico
│   │   ├── INDICE_LECCIONES.md  ← Empieza aquí cuando algo falla
│   │   ├── INDICE_DOCUMENTACION.md
│   │   ├── MANUAL_USUARIO.md    ← Este archivo
│   │   ├── patrones-errores-conocidos.md
│   │   └── ...
│   ├── settings.json            ← Hooks (3 Pre + 2 Post + Ruflo handlers)
│   └── settings.local.json      ← Permissions locales
├── CLAUDE.md                    ← ICFES priority + Ruflo descriptivo
└── CLAUDE.local.md              ← Local-only (gitignored)
```

---

## 8. Reglas inviolables (top 5 más comunes)

1. **NO modificar archivos en `03-En-Produccion/` ni `Ejemplos-Funcionales-Rmd/`** (regla #2 + reglas absolutas raíz).
2. **NO usar `git commit --no-verify`** (regla `testing-obligatorio.md`).
3. **NO ejecutar `npx ... init` sin backup previo** (regla #17).
4. **NO auto-decidir Flujo B ni selección de lenguaje gráfico** (reglas #2 + #3, `flujo-b-obligatorio.md`, `graficador-secuencial.md`).
5. **NO sobrescribir `.claude/CLAUDE.md`, `CLAUDE.md` raíz, `settings.json` sin verificar invariantes I-1 a I-7** (regla #17).

Lista completa: `.claude/CLAUDE.md`.

---

## 9. Solucionar problemas comunes

| Problema | Primer paso | Referencia |
|---|---|---|
| El render falla con "File not found" | Ver Error #1 | `patrones-errores-conocidos.md` |
| El gate bloquea sin razón aparente | `workflow-state.sh status <dir>` | regla #16 |
| El detractor reporta crítica | Aplicar fix → re-renderizar | regla #9 |
| El test de diversidad da 2/200 | Ver Error #8 (RNG) | `codigo-rmd.md` #10 |
| `claude mcp list` reporta `✗ Failed` | `claude mcp remove <nombre>` o investigar | Error #13 |
| Hooks ICFES no se disparan | Verificar I-3 con test | regla #17 |
| `CLAUDE.md` raíz cambió de identidad | Verificar I-1 | regla #17 |

---

## 10. Cómo agregar/cambiar algo

| Cambio | Procedimiento |
|---|---|
| Nueva regla | Crear `.claude/rules/<X>.md` + agregar al índice en `.claude/CLAUDE.md` + actualizar `INDICE_LECCIONES.md` |
| Nuevo error documentado | Agregar a `patrones-errores-conocidos.md` con número siguiente + actualizar `INDICE_LECCIONES.md` |
| Nuevo agente | Crear `.claude/agents/<nombre>.md` con frontmatter + reiniciar sesión |
| Nuevo skill | Crear `.claude/skills/<nombre>/SKILL.md` + actualizar `COMANDOS_Y_SKILLS.md` |
| Nueva ADR | `.claude/docs/ADR/<NNN>-<titulo>.md` + actualizar `INDICE_LECCIONES.md` §4 |
| Nuevo test | `tests/testthat/test_<nombre>.R` + agregar a `run_all_tests.R` |
| Nuevo caso resuelto | Copiar `templates/retrospectiva-sesion.md` a `casos-resueltos/<fecha>-<tema>.md` |

---

## 11. Glosario

| Término | Significado |
|---|---|
| **SCHOICE** | Single CHOICE — pregunta de opción múltiple, 1 correcta + N distractores |
| **CLOZE** | Pregunta compuesta de múltiples partes (schoice/num/mchoice) |
| **DOK** | Webb's Depth of Knowledge (1-4) |
| **Bloom** | Taxonomía Bloom Revisada (Recordar→Crear) |
| **SOLO** | Structure of Observed Learning Outcomes |
| **Flujo B** | Workflow del Graficador Experto (TikZ→Python→R hasta ≥98%) |
| **Progressive Disclosure** | Estructura metacognitiva: identifica → calcula → evalúa → transfiere |
| **Detractor** | Revisor adversarial obligatorio (regla #9) |
| **Ruflo** | claude-flow v3 — plataforma de coordinación instalada 2026-04-25 |
| **Hook ICFES** | Script `.sh` en `.claude/hooks/` que valida y bloquea |
| **Gate** | Hook PreToolUse que bloquea creación de `.Rmd` sin estado |
| **Workflow state** | `ejercicio_state.json` con los 11 pasos del workflow |

---

**Próxima revisión:** cuando se agregue una regla nueva, una decisión arquitectónica importante, o un cambio significativo en el flujo de trabajo.

**Mantenedor:** Álvaro Ángel Molina
