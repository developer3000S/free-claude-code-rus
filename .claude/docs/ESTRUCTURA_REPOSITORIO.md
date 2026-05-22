# Estructura del Repositorio

## 📁 Organización General

```
RepositorioMatematicasICFES_R_Exams/
│
├── A-Produccion/                      # PRODUCCIÓN
│   ├── 01-En-PreDesarrollo/          # Experimentación inicial
│   ├── 02-En-Desarrollo/             # Ejercicios en creación/validación
│   ├── 03-En-Produccion/             # Ejercicios validados por categoría ICFES
│   └── Ejemplos-Funcionales-Rmd/     # FUENTE DE VERDAD (INMUTABLES)
│
├── .claude/                           # SISTEMA CLAUDE CODE
│   ├── CLAUDE.md                     # Índice principal
│   ├── settings.json                 # Configuración de hooks
│   ├── rules/                        # Reglas obligatorias modulares
│   ├── docs/                         # Documentación modular
│   ├── hooks/                        # Hooks de validación automática
│   ├── scripts/                      # Scripts de validación
│   ├── skills/                       # Agent Skills (invocación automática)
│   └── commands/                     # Slash Commands (invocación manual)
│
├── tests/                             # ECOSISTEMA DE TESTING
│   ├── run_all_tests.R               # Ejecutor principal (chmod +x)
│   └── testthat/                     # Suites de tests (12 suites, 110+ tests)
│
├── outputs/                           # Archivos temporales de renderizado
│   ├── output_pdf/                   # PDFs generados
│   ├── output_html/                  # HTMLs generados
│   ├── output_docx/                  # DOCXs generados
│   └── [ejercicio]/                  # Workspace por ejercicio
│       ├── workflow_state.json       # Estado del Flujo B
│       ├── output_tikz_vN.tex        # Versiones TikZ
│       ├── output_python_vN.py       # Versiones Python
│       ├── output_r_vN.R             # Versiones R
│       └── *_output_vN.png           # Previews generados
│
├── .github/workflows/                 # CI/CD
│   └── ci-testing.yml                # GitHub Actions (7 jobs paralelos)
│
├── renv/                              # Gestión de dependencias R
├── README.md                          # Documentación principal
└── [otros archivos de configuración]
```

---

## 📂 Directorios Principales

### 1. A-Produccion/

**Propósito**: Almacenar ejercicios en diferentes estados de madurez

#### Subdirectorios:

##### `02-En-Desarrollo/`
**Estado**: En creacion, validacion, o **Listo para Aula**
**Contenido**: Archivos `.Rmd` siendo trabajados o esperando validacion en terreno
- Pueden tener errores pendientes (en creacion)
- Validacion automatica en progreso
- Flujo B en curso (si tienen graficos)
- **Ejercicios que pasaron Niveles 1+2 permanecen aqui** hasta ser probados con estudiantes

**Organización recomendada**:
```
En-Desarrollo/
├── [Pensamiento]/
│   ├── [Competencia]/
│   │   └── [Ejercicio]/
│   │       ├── ejercicio.Rmd
│   │       ├── preview.png
│   │       └── output_*/
└── README.md
```

**Ejemplo**:
```
En-Desarrollo/
└── Pensamiento-Variacional-Espacial/
    └── Variacion-Lineal/
        └── Auto-Viajero-09/
            ├── Variación-Lineal-Auto-Viajero-cloze.Rmd
            ├── preview_cloze_OpcA-0.png
            └── salida/
```

---

##### `Ejemplos-Funcionales-Rmd/`
**Estado**: **INMUTABLES - FUENTE DE VERDAD**

**⚠️ CRÍTICO**: Estos archivos **NUNCA** se modifican directamente.

**Propósito**:
- Patrones de solución validados y probados
- Referencia para resolver errores (SUBFASE 3A)
- Ejemplos de código correcto

**Uso**:
```bash
# CORRECTO: Copiar patrón
cp A-Produccion/Ejemplos-Funcionales-Rmd/patron.Rmd En-Desarrollo/nuevo.Rmd

# INCORRECTO: Editar directamente
# ❌ NO HACER: Edit(A-Produccion/Ejemplos-Funcionales-Rmd/patron.Rmd)
```

**Contenido típico**:
```
Ejemplos-Funcionales-Rmd/
├── schoice-basico-numerico.Rmd
├── schoice-con-tikz-dinamico.Rmd
├── cloze-multiple-num-schoice.Rmd
├── grafico-python-reticulate.Rmd
└── grafico-r-ggplot2.Rmd
```

---

##### `03-En-Produccion/`
**Estado**: Ejercicios validados con estudiantes reales (Nivel 3: Terreno) organizados por categoria ICFES 2026
**⛔ SOLO ejercicios que han pasado los 3 niveles de validacion, incluyendo testing en aula.**

**Organización** (6 categorías + Ejemplos):
```
03-En-Produccion/
├── 01-Numeros-Reales/                              # Algebra y Calculo [4 .Rmd]
│   └── Pensamiento-Numerico/ (6 subtemas)
├── 02-Funciones/                                    # Algebra y Calculo [17 .Rmd]
│   └── Pensamiento-Variacional-Espacial/ (12 subtemas)
├── 03-Razones-Trigonometricas/                      # Geometria no genérico [0 .Rmd]
│   └── Pensamiento-Espacial-Metrico-Y-Variacional/ (13 subtemas)
├── 04-Funciones_Identidades-Trigonometricas/        # Geometria no genérico [0 .Rmd]
│   └── Pensamiento-Espacial-Y-Variacional/ (11 subtemas)
├── 05-Geometría/                                    # Geometria [3 .Rmd]
│   └── Pensamiento-Espacial/ (18 subtemas)
├── 06-Estadística-Y-Probabilidad/                   # Estadistica [54 .Rmd]
│   └── Pensamiento-Aleatorio/ (9 subtemas)
└── Ejemplos-Funcionales-Rmd/                        # FUENTE DE VERDAD
```

**Total**: 78 archivos .Rmd en produccion | 69 subtemas | Todos con `.gitkeep`

**Documentación completa del árbol**: `Auxiliares/Estructura-Repositorio/Estructura_Repositorio.md`

---

### 2. .claude/

**Propósito**: Sistema completo de Claude Code (reglas, documentación, automatización)

#### Subdirectorios:

##### `rules/`
**Contenido**: Reglas obligatorias modulares

```
rules/
├── flujo-b-obligatorio.md           # Flujo B cuando hay gráficos
├── graficador-secuencial.md         # Proceso TikZ→Python→R
├── ciclo-validacion.md              # Validación visual iterativa
├── codigo-rmd.md                    # Reglas para archivos .Rmd
├── ortografia-espanol.md            # Tildes y ortografía
├── documentacion-verificada.md      # Principio de documentación
├── testing-obligatorio.md           # Sistema de testing automático
├── detractor-obligatorio.md         # Detractor en fases de revisión
├── ejercicios-metacognitivos.md     # Progressive Disclosure obligatorio
├── graficos-como-opciones.md        # PNGs individuales para SCHOICE
├── validacion-neg-opciones-repetidas.md  # Lógica negativa _neg_
├── contextos-narrativos-creativos.md     # Plantillas narrativas variadas
├── validacion-correctitud-respuesta.md   # Nivel 5: multi-semilla
└── modelo-routing-obligatorio.md    # Routing Opus/Sonnet/Haiku 🆕
```

**Todas son OBLIGATORIAS y NO tienen excepciones.**

---

##### `docs/`
**Contenido**: Documentación modular y técnica

```
docs/
├── REGLAS_CRITICAS.md               # Consolidación de reglas (NEW v3.0)
├── COMANDOS_Y_SKILLS.md             # Referencia comandos (NEW v3.0)
├── HOOKS_Y_TESTING.md               # Sistema automático (NEW v3.0)
├── ESTRUCTURA_REPOSITORIO.md        # Este archivo (NEW v3.0)
├── MODELO_ROUTING.md                # Routing de modelos por complejidad 🆕
├── CHANGELOG.md                     # Historial de cambios (NEW v3.0)
├── WORKFLOW_PASO_A_PASO.md          # Guía detallada del flujo
├── TRES_NIVELES_VALIDACION.md       # Fases de validación
├── FLUJO_AUTOMATICO_TESTING.md      # Flujo hooks y tests
├── ECOSISTEMA_TESTING.md            # Cobertura 100% y suites
├── TROUBLESHOOTING.md               # Solución de problemas
├── NOMENCLATURA_ARCHIVOS_RMD.md     # Convenciones de nombres
├── MEJORES_PRACTICAS_PYTHON_RETICULATE.md
├── patrones-errores-conocidos.md    # Errores y soluciones verificadas
└── casos-resueltos/                 # Casos específicos resueltos
```

---

##### `hooks/`
**Contenido**: 2 hooks activos cargados por `settings.json` (chmod +x)

```
hooks/
├── pre-write-rmd-gate.sh            # Gate .Rmd: exige ejercicio_state.json (PreToolUse)
├── post-exams2-validation.sh        # FASE 2A-2H tras exams2* (PostToolUse)
└── pre-commit-ortografia.sh         # Usado por .git/hooks/pre-commit (no por Claude)
```

**Configurados en**: @.claude/settings.json

**Ver documentación**: @.claude/docs/HOOKS_Y_TESTING.md

---

##### `scripts/`
**Contenido**: Scripts de validación y corrección

```
scripts/
├── validar_coherencia_matematica.R  # FASE 2A automática (Niveles 1-5)
├── validar_multisemilla.R           # Stress-test multi-semilla (Nivel 5)
├── corregir_ortografia_espanol.R    # Validación de tildes
└── [otros scripts de utilidad]
```

**Tests asociados**: `tests/testthat/test_validacion_matematica.R`, etc.

---

##### `skills/`
**Contenido**: Agent Skills (invocacion automatica por Claude)

Estructura Progressive Disclosure (Anthropic Agent Skills v2.1):

```
skills/
├── analizar-icfes/              # Opus — clasificación 6 dimensiones
│   ├── SKILL.md                 # Archivo principal (~3-4KB)
│   └── references/              # Documentación extraída
├── analizar-imagen-grafica/     # Sonnet — extracción visual
├── comparar-similitud-visual/   # Sonnet — puntuación similitud
├── corregir-error-imagen/       # Sonnet — ERR_G1 file not found
├── corregir-graficos/           # Sonnet — ERR_G1-G4
├── diagnosticar-errores/        # Sonnet — FASE 3 clasificación
├── generar-cloze/               # Opus — ejercicios CLOZE metacognitivos
├── generar-codigo-python/       # Sonnet — matplotlib
├── generar-codigo-r/            # Sonnet — ggplot2
├── generar-codigo-tikz/         # Sonnet — TikZ/pgfplots
├── generar-schoice/             # Opus — ejercicios SCHOICE metacognitivos
├── gestionar-estado-graficador/ # Haiku — workflow_state.json
├── promover-ejercicio/          # Haiku — mover a producción
├── refinar-codigo-grafico/      # Sonnet — iteración hasta ≥95%
├── skill-detractor/             # Opus — revisión adversarial 8 dominios
├── skill-retroalimentacion/     # Opus — retroalimentación científica ICFES
├── transferir-conocimiento-grafico/ # Haiku — lecciones entre lenguajes
├── validar-coherencia/          # Haiku — FASE 2: 5 coherencias
├── validar-diversidad/          # Haiku — 250+ versiones únicas
├── validar-icfes/               # Haiku — estructura R-exams + ICFES
├── validar-pedagogico/          # Opus — análisis pedagógico profundo
└── validar-renderizado/         # Haiku — FASE 1: 4 formatos
```

**Total**: 23 skills (v2.1) con `model_recommendation` en frontmatter 🆕

**NO invocar manualmente**. Claude los usa segun contexto.

---

##### `commands/`
**Contenido**: Slash Commands (invocación manual por usuario)

```
commands/
├── analizar-icfes/
│   ├── command.json
│   ├── command.prompt
│   └── examples/
├── generar-schoice/
├── generar-cloze/
├── auto-refinar-grafico/
├── estado-graficador/
├── exportar-graficos/
└── promover-ejercicio/
```

**Invocación**: Usuario ejecuta `/nombre-comando`

---

### 3. tests/

**Propósito**: Ecosistema de testing con 100% de cobertura

#### Estructura:

```
tests/
├── run_all_tests.R                  # Ejecutor principal (chmod +x)
├── testthat.R                       # Runner de testthat
└── testthat/
    ├── test_validacion_matematica.R      # 5 tests
    ├── test_ortografia_espanol.R         # 5 tests
    ├── test_renderizado_4_formatos.R     # 6 tests
    ├── test_aleatorization_diversity.R   # 4 tests
    ├── test_flujo_b_graficador.R         # 6 tests
    ├── test_regression_suite.R           # 7 tests
    ├── test_neg_visual_distinctness.R    # 3 tests
    ├── test_media_mediana_moda.R         # 3 tests
    ├── test_validacion_semantica.R       # 35 tests
    ├── test_correctitud_respuesta.R      # 14 tests
    ├── test_cloze_n3.R                   # tests CLOZE nivel 3
    └── test_stress_test_visual.R         # 28 tests
```

**Total**: 12 suites, 110+ tests unitarios

**Ejecución**:
```bash
Rscript tests/run_all_tests.R
```

**Documentación**: @.claude/docs/ECOSISTEMA_TESTING.md

---

### 4. outputs/

**Propósito**: Archivos temporales de renderizado y workspaces

#### Estructura:

```
outputs/
├── output_pdf/                      # PDFs generados por exams2pdf()
│   └── plain1.pdf
├── output_html/                     # HTMLs generados por exams2html()
│   └── plain1.html
├── output_docx/                     # DOCXs generados por exams2pandoc()
│   └── pandoc1.docx
└── [nombre_ejercicio]/              # Workspace por ejercicio
    ├── workflow_state.json          # Estado del Flujo B
    ├── output_tikz_v1.tex
    ├── output_tikz_v2.tex
    ├── output_python_v1.py
    ├── output_python_v2.py
    ├── output_r_v1.R
    ├── tikz_output_v1.png
    ├── tikz_output_v2.png
    ├── python_output_v1.png
    ├── r_output_v1.png
    └── preview_nombre-0.png         # Generado por hook FASE 2B
```

**Limpieza**: Archivos temporales pueden eliminarse después de validación

---

### 5. .github/workflows/

**Propósito**: CI/CD con GitHub Actions

#### Archivo:

```
.github/workflows/
└── ci-testing.yml                   # 7 jobs paralelos
```

**Triggers**:
- Push a `main` o `develop`
- Pull Requests
- Daily cron: 02:00 UTC

**Jobs**:
1. Validación matemática
2. Ortografía española
3. Renderizado 4 formatos
4. Aleatorización
5. Flujo B graficador
6. Regresión
7. Suite completa

**Política**: Tolerancia cero → falla si cualquier job falla

---

## 🔍 Navegación por Necesidad

| Necesito... | Directorio/Archivo |
|-------------|--------------------|
| Ejercicio validado en producción | `A-Produccion/03-En-Produccion/[categoría]/` |
| Ejercicio en desarrollo | `A-Produccion/02-En-Desarrollo/` |
| Patrón de solución validado | `A-Produccion/Ejemplos-Funcionales-Rmd/` |
| Regla obligatoria | `.claude/rules/` |
| Documentación técnica | `.claude/docs/` |
| Comando manual | `.claude/commands/` |
| Hook de validación | `.claude/hooks/` |
| Script de validación | `.claude/scripts/` |
| Test unitario | `tests/testthat/` |
| Ejecutar todos los tests | `tests/run_all_tests.R` |
| Preview de ejercicio | `outputs/preview_*.png` |
| Workspace de gráficos | `outputs/[ejercicio]/` |
| CI/CD | `.github/workflows/ci-testing.yml` |

---

## 📝 Convenciones de Nombres

### Archivos .Rmd

**Formato**: `[Tema]-[Subtema]-[Tipo].Rmd`

**Ejemplos**:
```
Geometria-Triangulo-Area-schoice.Rmd
Algebra-Ecuacion-Lineal-cloze.Rmd
Variacion-Proporcionalidad-Directa-schoice.Rmd
```

**Documentación completa**: @.claude/docs/NOMENCLATURA_ARCHIVOS_RMD.md

---

### Directorios de Ejercicios

**Formato**: `[Pensamiento]/[Competencia]/[Tema]/`

**Ejemplo**:
```
A-Produccion/03-En-Produccion/02-Funciones/
  Pensamiento-Variacional-Espacial/
    11-Variacion-Lineal-Y-Exponencial_Razon-De-Cambio/
      Variación-Lineal-Auto-Viajero-09/
```

---

### Archivos de Estado

**workflow_state.json**:
```json
{
  "flujo_b_completado": true,
  "tikz": {
    "estado": "aprobado",
    "similitud_final": 95,
    "usuario_aprobo": true,
    "version_final": 3
  },
  "python": {
    "estado": "aprobado",
    "similitud_final": 96,
    "usuario_aprobo": true,
    "version_final": 2
  },
  "r": {
    "estado": "aprobado",
    "similitud_final": 95,
    "usuario_aprobo": true,
    "version_final": 1
  },
  "version_seleccionada": "tikz"
}
```

---

## 🔒 Archivos y Directorios INMUTABLES

**NO modificar directamente**:

1. `A-Produccion/Ejemplos-Funcionales-Rmd/` - Solo copiar patrones
2. `.claude/rules/` - Solo con aprobación y tests pasando
3. `.claude/hooks/` - Solo con validación de regresión
4. `tests/testthat/` - Solo con cobertura 100% mantenida
5. `.github/workflows/ci-testing.yml` - Solo con validación CI/CD

**Modificación requiere**:
- Tests pasando 100%
- Revisión de regresión
- Commit con suite completa exitosa

---

## 📊 Estadísticas del Repositorio

```
Total de archivos críticos:
├── Reglas obligatorias:      14 archivos
├── Documentación:            14+ archivos
├── Hooks:                     4 scripts
├── Scripts de validación:     3+ scripts
├── Suites de tests:          12 suites
├── Tests unitarios:          110+ tests
├── Comandos manuales:         7 comandos
├── Skills automáticos:       23 skills (con model_recommendation)
├── Agentes especializados:    6 agentes (con modelo asignado)
└── Ejemplos funcionales:     10+ ejemplos

Cobertura de tests:          100%
Estado del sistema:          ACTIVO Y PERMANENTE
```

---

## 🔄 Flujo de Trabajo Tipico

```
1. Crear ejercicio
   → A-Produccion/02-En-Desarrollo/[categoria]/[ejercicio]/

2. Desarrollar
   → .Rmd + graficos (si aplica, Flujo B)

3. Validar automaticamente (Niveles 1+2)
   → Hooks ejecutan FASE 2A + 2B
   → Claude verifica 5 coherencias
   → Tests automaticos + Detractor

4. Ejercicio "LISTO PARA AULA"
   → Permanece en 02-En-Desarrollo/
   → Commit + Push con tests pasando

5. Validar en Terreno (Nivel 3)
   → Aplicar con estudiantes reales
   → Recopilar evidencia y feedback

6. Promover a Produccion (ULTIMO PASO)
   → /promover-ejercicio (requiere evidencia Nivel 3)
   → Mover a A-Produccion/03-En-Produccion/[categoria]/
```

---

## 📚 Documentación Relacionada

- **Índice principal**: @.claude/CLAUDE.md
- **Reglas críticas**: @.claude/docs/REGLAS_CRITICAS.md
- **Comandos y skills**: @.claude/docs/COMANDOS_Y_SKILLS.md
- **Hooks y testing**: @.claude/docs/HOOKS_Y_TESTING.md
- **Workflow paso a paso**: @.claude/docs/WORKFLOW_PASO_A_PASO.md
- **Ecosistema testing**: @.claude/docs/ECOSISTEMA_TESTING.md

---

**Versión**: 1.5
**Fecha**: 2026-02-27
**Módulo de**: @.claude/CLAUDE.md (v3.6.0)

### Historial de Cambios

- **v1.5** (2026-02-27): Actualizar conteos produccion (78 .Rmd), 12 suites/110+ tests, 23 skills, promover diagrama_venn a 08-Probabilidad
- **v1.4** (2026-02-14): Actualizar rules/ (14 archivos), docs/ (+MODELO_ROUTING.md), skills/ (22 con modelo), stats actualizados
- **v1.3** (2026-02-14): Actualizar a 10 suites, 82+ tests. Agregar test_correctitud_respuesta.R y validar_multisemilla.R
- **v1.2** (2026-02-06): Actualizar skills a estructura Progressive Disclosure (17 skills v2.1)
- **v1.1** (2026-02-04): Actualizar 03-En-Produccion con estructura real verificada (6 categorias, 69 subtemas, ~122 .Rmd)
