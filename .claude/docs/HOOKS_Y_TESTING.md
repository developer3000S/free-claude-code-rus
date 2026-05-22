# Sistema de Hooks y Testing Automático

## 🎯 Resumen Ejecutivo

**Sistema de validación automática PERMANENTE** con tolerancia cero a regresiones.

- **2 hooks activos** cargados por `settings.json` (PreToolUse: gate .Rmd + recordatorio tildes; PostToolUse: arsenal post-render)
- **100% cobertura** de tests (12 suites, 130+ tests unitarios)
- **CI/CD automático** con GitHub Actions (un job llama a `run_all_tests.R`)
- **Bloqueo proactivo** de `.Rmd` sin `ejercicio_state.json` vía gate mecánico
- **Validación matemática + arsenal + preview visual** automática después de renderizar

> Nota (v3.8.0, 2026-04-10): los hooks `pre-edit-testing.sh` y `post-edit-testing.sh`
> fueron eliminados. Nunca estuvieron cargados en `settings.json`. Los git hooks
> nativos (`.git/hooks/pre-commit`, `.git/hooks/pre-push`) siguen siendo los
> responsables de bloquear commits/push con tests fallando — ver
> `.claude/rules/testing-obligatorio.md`.

---

## 📋 Índice

1. [Los 2 Hooks Configurados](#los-2-hooks-configurados)
2. [Sistema de Testing (100% Cobertura)](#sistema-de-testing-100-cobertura)
3. [Flujo Automático Completo](#flujo-automático-completo)
4. [Garantías del Sistema](#garantías-del-sistema)
5. [CI/CD y Monitoreo](#cicd-y-monitoreo)

---

## Los 2 Hooks Configurados

**Configuración**: @.claude/settings.json

> Los únicos hooks que Claude Code carga desde `settings.json` son los dos
> descritos abajo. Commits/push se protegen con git hooks nativos en
> `.git/hooks/pre-commit` y `.git/hooks/pre-push` (ver
> `.claude/rules/testing-obligatorio.md`).

### 1. PreToolUse - Write/Edit: Gate de .Rmd + recordatorio de tildes

**Hook principal**: `.claude/hooks/pre-write-rmd-gate.sh`
**Recordatorio**: mensaje `echo` con lista de palabras que llevan tilde.

#### Cuándo se Ejecuta
Antes de que Claude ejecute `Write` o `Edit`.

#### Qué Hace
1. Si el archivo objetivo es un `.Rmd` en `01-En-PreDesarrollo/` o `02-En-Desarrollo/`,
   verifica que exista `ejercicio_state.json` en el directorio del ejercicio y
   que los pasos obligatorios (`analisis_icfes`, `flujo_b`) estén completos.
2. Si alguna verificación falla → **exit 2** (bloquea el tool call) con
   instrucciones concretas en stderr.
3. Si el archivo está fuera del workflow o en `Ejemplos-Funcionales/` → permite.
4. Fail open: si el JSON es inválido, permite (nunca bloquear por error del sistema).

Detalles completos en `.claude/rules/workflow-state-enforcement.md`.

---

### 2. PostToolUse - Bash (exams2*)

**Hook**: `.claude/hooks/post-exams2-validation.sh`
**Timeout**: 120 segundos
**Status**: "Validando matemática + preview visual..."

#### Cuándo se Ejecuta
Después de cualquier comando `Bash` exitoso

#### Detecta
Comandos `exams2pdf()`, `exams2html()`, `exams2pandoc()`, `exams2nops()`

#### Acciones (si detecta exams2*)

##### FASE 2A - Validación Matemática Automática

```bash
Rscript .claude/scripts/validar_coherencia_matematica.R [archivo.Rmd]
```

**Valida**:
- Chunks R sin errores (NA/NaN/Inf)
- Metadatos ICFES completos
- `exshuffle = TRUE` (excepción: acepta FALSE en SCHOICE con opciones gráficas PNG)
- SCHOICE: `exsolution` binario, exactamente 1 correcta
- CLOZE: tipos/soluciones/tolerancias consistentes
- Coherencia matemática entre variables

**Reporta**: APROBADO / ERRORES

##### FASE 2B - Preview Visual Automático

```bash
# 1. Busca PDF generado
find output_pdf/ output/ -name "*.pdf" -type f

# 2. Convierte a PNG
magick -density 150 [pdf] -quality 90 preview_[nombre].png

# 3. Soporta múltiples páginas
preview_nombre-0.png
preview_nombre-1.png
...
```

**Reporta**:
- Rutas de PNGs generados
- **Emite instrucción OBLIGATORIA para Claude**:
  ```
  Claude DEBE:
  1. Ejecutar Read() sobre cada PNG reportado
  2. Verificar las 5 coherencias VISUALMENTE
  3. Documentar hallazgos con checklist
  4. Solicitar aprobación del usuario
  ```

---

## Sistema de Testing (100% Cobertura)

**Documentación completa**: @.claude/docs/ECOSISTEMA_TESTING.md
**Regla obligatoria**: @.claude/rules/testing-obligatorio.md

### Las 12 Suites de Tests

| Suite | Archivo | Tests | Cubre |
|-------|---------|-------|-------|
| **Validación Matemática** | `test_validacion_matematica.R` | 5 | Script validación, metadatos ICFES, coherencia |
| **Ortografía Española** | `test_ortografia_espanol.R` | 5 | Tildes, metadatos ASCII, variables |
| **Renderizado 4 Formatos** | `test_renderizado_4_formatos.R` | 6 | HTML, PDF, DOCX, NOPS |
| **Aleatorización** | `test_aleatorization_diversity.R` | 4 | exshuffle, 250+ versiones, rangos |
| **Flujo B Graficador** | `test_flujo_b_graficador.R` | 6 | workflow_state.json, aprobaciones, similitud |
| **Regresión** | `test_regression_suite.R` | 7 | Ejemplos funcionales, scripts, hooks |
| **Distintividad Visual _neg_** | `test_neg_visual_distinctness.R` | 3 | Colores únicos, digest opciones, lógica negativa |
| **Media-Mediana-Moda** | `test_media_mediana_moda.R` | 3 | Precondiciones, filtro genérico, 100 semillas |
| **Validación Semántica (Nivel 4)** | `test_validacion_semantica.R` | 35 | 3 capas, 21 keywords, regresión EST-MTC-04 |
| **Correctitud Respuesta (Nivel 5)** | `test_correctitud_respuesta.R` | 14 | 5A-5E, cross-check, unicidad, rangos |
| **CLOZE N3 (Trigonometría)** | `test_cloze_n3.R` | 6 | Estructura CLOZE nivel 3 |
| **Stress Test Visual Multi-Semilla** | `test_stress_test_visual.R` | 15 | Extracción, anomalías, renderizado masivo |
| **TOTAL** | 12 archivos | **130+** | **100%** |

> El runner (`run_all_tests.R`) marca como pesadas las suites con campo
> `watch` y las salta en modo `R_TESTS_QUICK=1` cuando ningún archivo
> cambiado coincide con los patrones de la suite. Esto aplica hoy a:
> Renderizado, Aleatorización, Regresión, Media-Mediana-Moda, CLOZE N3 y
> Stress Test Visual.

### Ejecutor Principal

**Archivo**: `tests/run_all_tests.R` (chmod +x)

**Uso**:
```bash
Rscript tests/run_all_tests.R
```

**Output**:
```
========================================
  SUITE DE TESTING COMPLETA
========================================

Ejecutando suite: Validación Matemática
✓ test_validacion_matematica.R [5 tests, ~3.2s]

Ejecutando suite: Ortografía Española
✓ test_ortografia_espanol.R [5 tests, ~2.1s]

...

========================================
  RESUMEN FINAL
========================================

Suites ejecutadas: 10
✓ Exitosas: 10
✗ Fallidas: 0

Tests totales: 82+
✓ Pasados: 82+
✗ Fallidos: 0

⏱  Tiempo total: ~28.4s

========================================
✅ TODOS LOS TESTS PASARON
========================================
```

**Exit codes**:
- `0` → Todos los tests pasaron
- `1` → Algún test falló

---

## Flujo Automático Completo

**Documentación detallada**: @.claude/docs/FLUJO_AUTOMATICO_TESTING.md

### Diagrama de Flujo

```
┌─────────────────────────────────────────────────────────┐
│               SISTEMA AUTOMÁTICO DE TESTING              │
│                   (SIEMPRE ACTIVO)                       │
└─────────────────────────────────────────────────────────┘

EVENTO 1: Claude intenta Write/Edit sobre un .Rmd
└─→ PreToolUse Hook → pre-write-rmd-gate.sh
    ├─→ ¿.Rmd en 01-PreDesarrollo/ o 02-Desarrollo/?
    │   ├─→ SÍ: Verificar ejercicio_state.json + pasos 1-2
    │   │   ├─→ OK: Permitir ✅
    │   │   └─→ FALTA: exit 2 → BLOQUEAR ❌
    │   └─→ NO: Permitir (fuera del workflow)

EVENTO 2: Usuario/Claude intenta git commit
└─→ .git/hooks/pre-commit (git hook nativo, NO Claude hook)
    ├─→ Valida ortografía .Rmd modificados
    └─→ (Opcional) Ejecuta tests con PRECOMMIT_TESTS=1

EVENTO 3: Usuario/Claude intenta git push
└─→ .git/hooks/pre-push (git hook nativo)
    └─→ Ejecuta Rscript tests/run_all_tests.R (modo quick disponible)

EVENTO 4: Después de exams2*()
└─→ PostToolUse Hook (Bash) → post-exams2-validation.sh
    ├─→ FASE 2A: Validar matemática (script R, Niveles 1-4)
    ├─→ FASE 2B: Generar preview PNG (magick)
    │   └─→ Claude DEBE leer PNG + verificar + aprobar
    ├─→ FASES 2C-2F: Arsenal completo de validación
    ├─→ FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5)
    └─→ FASE 2H: Stress test visual multi-semilla
        └─→ Solo si FASES anteriores sin errores
```

---

### Escenarios Detallados

#### Escenario 1: Claude crea un ejercicio .Rmd nuevo

```
1. Usuario: "Crea ejercicio de mediana"

2. Claude ejecuta pasos 1-2 (/analizar-icfes + preguntar flujo_b) y
   marca ambos en ejercicio_state.json con workflow-state.sh complete.

3. Claude: Write("mi-ejercicio.Rmd")

4. PreToolUse Hook:
   → pre-write-rmd-gate.sh
   → Verifica ejercicio_state.json + pasos 1-2 completos
   → Permite ✅

5. Claude: Bash("Rscript -e 'exams2pdf(\"mi-ejercicio.Rmd\")'")

6. PostToolUse Hook:
   → post-exams2-validation.sh
   → FASES 2A-2H automáticas (ver sección siguiente)
```

#### Escenario 2: Usuario Hace Commit

```
1. Usuario: git commit -m "feat: nueva funcionalidad"

2. .git/hooks/pre-commit (git hook nativo):
   → Valida ortografía en .Rmd modificados
   → Opcional: tests con PRECOMMIT_TESTS=1

3. Resultado:
   - PASA: commit ejecutado
   - FALLA: commit rechazado, corregir errores
```

#### Escenario 3: Claude Genera .Rmd y lo Renderiza

```
1. Claude: Write("ejercicio.Rmd")  → gate permite si pasos previos OK

2. Claude: Bash("Rscript -e 'exams2pdf(\"ejercicio.Rmd\")'")

3. PostToolUse Hook (Bash):
   → post-exams2-validation.sh
   → Detecta: exams2pdf

   FASE 2A:
   → Ejecuta validar_coherencia_matematica.R
   → Valida metadatos, chunks, coherencia
   → Reporta: APROBADO / ERRORES

   FASE 2B:
   → Busca PDF: output_pdf/plain1.pdf
   → Convierte: magick → preview.png
   → Reporta: "PNG generado en [ruta]"
   → Emite: "Claude DEBE leer PNG y verificar 5 coherencias"

   FASES 2C-2H:
   → Arsenal, multi-semilla, stress test visual

4. Claude ejecuta automáticamente:
   → Read("preview.png")
   → Muestra imagen al usuario
   → Verifica 5 coherencias
   → Solicita aprobación
```

---

## Garantías del Sistema

Con este sistema permanentemente activo:

✅ **1. Ningún cambio rompedor llega a código**
- Tests se ejecutan ANTES y DESPUÉS de editar

✅ **2. 100% de cobertura se mantiene**
- Tests de regresión validan que nada se rompa

✅ **3. Commits solo con tests pasando**
- Imposible hacer commit con tests fallidos

✅ **4. Push solo con validación completa**
- Suite completa se ejecuta antes de push

✅ **5. Validación automática de .Rmd**
- FASE 2A (matemática) + FASE 2B (preview) automáticas

✅ **6. Claude no puede romper el sistema**
- Hooks bloquean cambios peligrosos

✅ **7. CI/CD adicional en remoto**
- GitHub Actions ejecuta tests en cada push/PR

---

## CI/CD y Monitoreo

### GitHub Actions

**Archivo**: `.github/workflows/ci-testing.yml`

**Triggers**:
- Push a `main` o `develop`
- Pull Requests
- Daily cron: 02:00 UTC

**Jobs** (7 paralelos):
1. Validación matemática
2. Ortografía española
3. Renderizado 4 formatos
4. Aleatorización
5. Flujo B graficador
6. Regresión
7. Suite completa

**Configuración**:
```yaml
strategy:
  fail-fast: true  # Abortar si algún job falla
  matrix:
    suite:
      - validacion_matematica
      - ortografia_espanol
      - renderizado_4_formatos
      - aleatorization_diversity
      - flujo_b_graficador
      - regression_suite
      - completa
```

**Política**: Tolerancia cero → Pipeline falla si cualquier job falla

---

### Métricas y Reportes

Cada hook reporta su estado en tiempo real:

```
🔍 Verificando tests antes de editar...
→ Ejecutando tests de validación matemática...
✅ Tests pasaron - Procediendo con edición

🔍 Validando cambios en: .claude/scripts/validar_coherencia_matematica.R
→ Script de validación matemática modificado
→ Ejecutando tests de validación matemática...
✅ Todos los tests pasaron después del cambio

🔒 BLOQUEO PRE-COMMIT ACTIVADO
Ejecutando suite completa de tests...

========================================
  SUITE DE TESTING COMPLETA
========================================

Suites ejecutadas: 6
✓ Exitosas: 6
✗ Fallidas: 0

✅ TESTS PASARON - COMMIT PERMITIDO
```

---

### Variables de Entorno Disponibles

Los hooks tienen acceso a:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `$CLAUDE_PROJECT_DIR` | Directorio raíz del proyecto | `/home/bootcamp/.../RepositorioMatematicasICFES_R_Exams` |
| `$ARGS_FILE` | Archivo JSON con argumentos del tool | Contiene `file_path` para Edit/Write |
| `$BASH_COMMAND` | Comando bash siendo ejecutado | `git commit -m "mensaje"` |
| `$FILE_PATH` | Ruta del archivo (extraída de $ARGS_FILE) | `.claude/scripts/validar_coherencia_matematica.R` |

---

## Verificación del Sistema

Para verificar que el sistema está activo:

```bash
# 1. Verificar que hooks existen y tienen permisos
ls -la .claude/hooks/*.sh

# 2. Verificar configuración en settings.json
cat .claude/settings.json | grep -A 20 "hooks"

# 3. Probar manualmente suite completa
Rscript tests/run_all_tests.R

# 4. Intentar commit de prueba (debería bloquear si hay tests fallidos)
git commit -m "test" --allow-empty
```

---

## 🚨 Mensajes de Error y Acciones

### Error en PreToolUse (Edit)

```
❌ ==============================================
❌ EDICIÓN BLOQUEADA - TESTS FALLARON
❌ ==============================================

Archivo: .claude/scripts/validar_coherencia_matematica.R

ACCIÓN REQUERIDA:
1. Los tests actuales están fallando
2. Corregir problemas antes de editar
3. NO proceder con edición hasta que tests pasen
```

**Claude debe**:
- NO intentar editar el archivo
- Informar al usuario del problema
- Esperar instrucciones

---

### Error en PostToolUse (Edit)

```
❌ ==============================================
❌ TESTS FALLARON DESPUÉS DEL CAMBIO
❌ ==============================================

Archivo: .claude/scripts/validar_coherencia_matematica.R

⚠️ ACCIÓN REQUERIDA:
1. El cambio introdujo un error
2. Revisar el código modificado
3. Corregir el problema
4. Los tests deben pasar antes de commit
```

**Claude debe**:
- Analizar el error reportado
- Identificar qué rompió
- Proponer corrección
- Aplicar corrección
- Verificar que tests pasen

---

### Error en PreBash (Commit)

```
❌ ==============================================
❌ COMMIT RECHAZADO - TESTS FALLARON
❌ ==============================================

Acciones requeridas:
1. Revisar errores de tests arriba ↑
2. Corregir el código que causó la falla
3. Volver a ejecutar: Rscript tests/run_all_tests.R
4. Solo entonces hacer commit

⚠️ PROHIBIDO usar: git commit --no-verify
```

**Claude debe**:
- NO intentar commit con --no-verify
- Informar al usuario qué tests fallaron
- Ayudar a corregir el código
- Esperar a que tests pasen

---

## 🛡️ Mantenimiento del Sistema

### Actualizar Hooks

1. Editar `pre-write-rmd-gate.sh` o `post-exams2-validation.sh`
2. Los tests de regresión y la suite completa validan los cambios en CI
3. Commit y push con git hooks nativos validando

### Agregar Nuevos Tests

1. Crear `tests/testthat/test_nuevo_componente.R`
2. Registrarlo en `tests/run_all_tests.R` (añadir entrada en `suites`)
3. Al próximo push, CI lo ejecuta automáticamente (el CI llama al runner)

### Deshabilitar Temporalmente (PROHIBIDO)

❌ **NO hay forma de deshabilitar el sistema**
❌ **NO usar `--no-verify`**
❌ **NO comentar hooks en settings.json**

✅ **SIEMPRE corregir el código para que pase los tests**

---

## 📚 Documentación Relacionada

- **Regla obligatoria**: @.claude/rules/testing-obligatorio.md
- **Flujo automático detallado**: @.claude/docs/FLUJO_AUTOMATICO_TESTING.md
- **Ecosistema completo**: @.claude/docs/ECOSISTEMA_TESTING.md
- **Ciclo validación**: @.claude/rules/ciclo-validacion.md
- **Configuración**: @.claude/settings.json

---

**Versión**: 1.2
**Fecha**: 2026-02-14
**Estado**: ACTIVO Y PERMANENTE
**Módulo de**: @.claude/CLAUDE.md (v3.4.0)

### Cambios v1.2 (2026-02-14)
- **10 suites** (antes 9): +Correctitud de Respuesta (Nivel 5)
- **82+ tests** (antes 68+): +14 tests Nivel 5A-5E
- **FASE 2G** agregada: Multi-semilla rápida (20 semillas) en hook post-exams2
- Validación Correctitud Nivel 5: cross-check respuesta, unicidad opciones, rangos matemáticos

### Cambios v1.1 (2026-02-13)
- **9 suites** (antes 6): +Distintividad Visual _neg_, +Media-Mediana-Moda, +Validación Semántica
- **68+ tests** (antes 33+)
- Validación Semántica Nivel 4: 3 capas + 21 keyword rules
