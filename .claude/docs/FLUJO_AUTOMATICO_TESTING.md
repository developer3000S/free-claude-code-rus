# Flujo Automático de Testing Permanente

> ⚠️ **DEPRECADO (2026-04-10, v3.8.0)**: Este documento describe un flujo basado
> en los hooks `pre-edit-testing.sh` / `post-edit-testing.sh` que **nunca estuvieron
> cargados** en `.claude/settings.json` y cuyos scripts fueron eliminados del
> repositorio. Se preserva solo como referencia histórica del diseño original.
>
> **Flujo real actual**:
> - Gate mecánico de `.Rmd`: `.claude/hooks/pre-write-rmd-gate.sh` (PreToolUse).
> - Validación post-renderizado: `.claude/hooks/post-exams2-validation.sh` (PostToolUse).
> - Bloqueo de commit/push: git hooks nativos en `.git/hooks/pre-commit` y
>   `.git/hooks/pre-push` (ver `.claude/rules/testing-obligatorio.md`).
> - Runner único: `Rscript tests/run_all_tests.R` (12 suites, modo quick
>   disponible con `R_TESTS_QUICK=1`).
>
> Para documentación vigente ver `HOOKS_Y_TESTING.md`.

## 🎯 Objetivo

Este documento describe cómo el sistema de testing se ejecuta **automáticamente y permanentemente** sin intervención manual, garantizando que NUNCA se rompa el código.

---

## 🔄 Diagrama de Flujo Completo

```
┌─────────────────────────────────────────────────────────────┐
│               SISTEMA AUTOMÁTICO DE TESTING                 │
│                   (SIEMPRE ACTIVO)                          │
└─────────────────────────────────────────────────────────────┘

EVENTO 1: Claude intenta Edit/Write
├─→ PreToolUse Hook → pre-edit-testing.sh
│   ├─→ ¿Es componente crítico? (.claude/*, tests/*)
│   │   ├─→ SÍ: Ejecutar tests relevantes
│   │   │   ├─→ PASAN: Permitir edición
│   │   │   └─→ FALLAN: BLOQUEAR edición ❌
│   │   └─→ NO: Permitir edición
│   │
├─→ Claude ejecuta Edit/Write
│   │
└─→ PostToolUse Hook → post-edit-testing.sh
    ├─→ Ejecutar tests según tipo de archivo
    ├─→ PASAN: ✅ Cambio validado
    └─→ FALLAN: ❌ Mostrar error + Instrucciones

EVENTO 2: Usuario/Claude intenta git commit
├─→ PreToolUse Hook (Bash) → pre-bash-testing.sh
│   ├─→ Ejecutar: Rscript tests/run_all_tests.R
│   ├─→ PASAN: Permitir commit ✅
│   └─→ FALLAN: RECHAZAR commit ❌

EVENTO 3: Usuario/Claude intenta git push
├─→ PreToolUse Hook (Bash) → pre-bash-testing.sh
│   ├─→ Verificar no hay cambios sin commit
│   ├─→ Ejecutar suite completa
│   ├─→ Verificar CI/CD configurado
│   ├─→ PASAN: Permitir push ✅
│   └─→ FALLAN: RECHAZAR push ❌

EVENTO 4: Después de exams2*()
└─→ PostToolUse Hook (Bash) → post-exams2-validation.sh
    ├─→ FASE 2A: Validar matemática (script R, Niveles 1-4)
    ├─→ FASE 2B: Generar preview PNG (magick)
    └─→ FASE 2G: Multi-semilla rápida (20 semillas, Nivel 5)
```

---

## 📋 Hooks Configurados (settings.json)

### 1. PreToolUse - Write|Edit

**Hook:** `pre-edit-testing.sh`

**Cuándo se ejecuta:**
- Antes de que Claude ejecute `Edit` o `Write`

**Qué hace:**
1. Detecta si el archivo es componente crítico:
   - `.claude/scripts/*`
   - `.claude/hooks/*`
   - `.claude/rules/*`
   - `tests/*`

2. Si ES crítico:
   - Ejecuta tests relevantes según el archivo
   - Si PASAN → Permite edición
   - Si FALLAN → **BLOQUEA** edición con mensaje de error

3. Si NO es crítico:
   - Permite edición sin tests

**Archivos específicos:**
- `validar_coherencia_matematica.R` → `test_validacion_matematica.R`
- `corregir_ortografia_espanol.R` → `test_ortografia_espanol.R`
- `test_*.R` → Suite completa
- Otros en `.claude/*` → `test_regression_suite.R`

### 2. PostToolUse - Write|Edit

**Hook:** `post-edit-testing.sh`

**Cuándo se ejecuta:**
- Inmediatamente después de que Claude ejecuta `Edit` o `Write`

**Qué hace:**
1. Detecta tipo de archivo modificado:
   - `validar_coherencia_matematica.R` → Ejecuta tests de validación
   - `corregir_ortografia_espanol.R` → Ejecuta tests de ortografía
   - `*.Rmd` → Ejecuta tests de renderizado
   - `test_*.R` → Ejecuta suite completa
   - Configuración Claude → Ejecuta tests de regresión

2. Ejecuta tests correspondientes

3. Si FALLAN:
   - Muestra error detallado
   - Indica que se debe corregir
   - **NO revierte** cambio (responsabilidad de Claude/usuario corregir)

4. Si PASAN:
   - Confirma que todo está bien
   - Permite continuar

### 3. PreToolUse - Bash

**Hook:** `pre-bash-testing.sh`

**Cuándo se ejecuta:**
- Antes de que Claude ejecute comando `Bash`

**Qué detecta y bloquea:**

#### A. git commit

```bash
git commit -m "mensaje"
```

**Acciones:**
1. Ejecuta: `Rscript tests/run_all_tests.R`
2. Si FALLA → **RECHAZA** commit con mensaje:
   ```
   ❌ COMMIT RECHAZADO - TESTS FALLARON
   Acciones requeridas:
   1. Revisar errores de tests
   2. Corregir código
   3. Volver a ejecutar tests
   4. Solo entonces hacer commit
   ```
3. Si PASA → Permite commit

#### B. git push

```bash
git push origin main
```

**Acciones:**
1. Verifica que no hay cambios sin commit
2. Ejecuta suite completa: `Rscript tests/run_all_tests.R`
3. Verifica que `.github/workflows/ci-testing.yml` existe
4. Si TODO PASA → Permite push
5. Si ALGO FALLA → **RECHAZA** push

### 4. PostToolUse - Bash

**Hook:** `post-exams2-validation.sh`

**Cuándo se ejecuta:**
- Después de cualquier comando `Bash` exitoso

**Qué detecta:**
- Comandos `exams2pdf()`, `exams2html()`, etc.

**Acciones (si detecta exams2*):**
1. **FASE 2A - Validación Matemática:**
   - Ejecuta `validar_coherencia_matematica.R`
   - Valida chunks R, metadatos, coherencia matemática
   - Reporta APROBADO/ERRORES

2. **FASE 2B - Preview Visual:**
   - Busca PDF generado
   - Convierte a PNG: `magick -density 150 pdf → png`
   - Reporta rutas de PNGs generados
   - **Emite instrucción OBLIGATORIA** para que Claude:
     - Lea los PNGs con `Read()`
     - Verifique las 5 coherencias
     - Documente hallazgos
     - Solicite aprobación del usuario

---

## 🚦 Comportamiento por Escenario

### Escenario 1: Claude Edita Script de Validación

```
1. Usuario: "Actualiza validar_coherencia_matematica.R"

2. Claude detecta → Edit("validar_coherencia_matematica.R")

3. PreToolUse Hook ejecuta:
   → pre-edit-testing.sh "validar_coherencia_matematica.R"
   → Detecta: archivo crítico
   → Ejecuta: test_validacion_matematica.R
   → Estado actual: PASANDO

4. Claude procede con Edit

5. PostToolUse Hook ejecuta:
   → post-edit-testing.sh "validar_coherencia_matematica.R"
   → Ejecuta: test_validacion_matematica.R con el NUEVO código

6. Resultado:
   - Si PASA: ✅ "Tests pasaron después del cambio"
   - Si FALLA: ❌ "Tests fallaron - Corregir código"
```

### Escenario 2: Usuario Hace Commit

```
1. Usuario: git commit -m "feat: nueva funcionalidad"

2. PreToolUse Hook (Bash) ejecuta:
   → pre-bash-testing.sh "git commit -m '...'"
   → Detecta: comando git commit
   → Ejecuta: Rscript tests/run_all_tests.R
   → Suite completa: 10 suites, 82+ tests

3. Resultado:
   - Si TODO PASA:
     ✅ "TESTS PASARON - COMMIT PERMITIDO"
     → Commit se ejecuta

   - Si ALGO FALLA:
     ❌ "COMMIT RECHAZADO - TESTS FALLARON"
     → Commit NO se ejecuta
     → Mostrar errores
     → Instrucciones de corrección
```

### Escenario 3: Claude Genera .Rmd y lo Renderiza

```
1. Claude: Write("ejercicio.Rmd")

2. PostToolUse Hook (Write):
   → post-edit-testing.sh "ejercicio.Rmd"
   → Ejecuta: test_renderizado_4_formatos.R
   → Valida estructura básica

3. Claude: Bash("Rscript -e 'exams2pdf(\"ejercicio.Rmd\")'")

4. PostToolUse Hook (Bash):
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

5. Claude ejecuta automáticamente:
   → Read("preview.png")
   → Muestra imagen al usuario
   → Verifica 5 coherencias
   → Solicita aprobación
```

---

## ⚙️ Variables de Entorno Disponibles

Los hooks tienen acceso a:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `$CLAUDE_PROJECT_DIR` | Directorio raíz del proyecto | `/home/bootcamp/.../RepositorioMatematicasICFES_R_Exams` |
| `$ARGS_FILE` | Archivo JSON con argumentos del tool | Contiene `file_path` para Edit/Write |
| `$BASH_COMMAND` | Comando bash siendo ejecutado | `git commit -m "mensaje"` |
| `$FILE_PATH` | Ruta del archivo (extraída de $ARGS_FILE) | `.claude/scripts/validar_coherencia_matematica.R` |

---

## 📊 Métricas y Monitoreo

### Reportes Automáticos

Cada hook reporta su estado:

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

Suites ejecutadas: 10
✓ Exitosas: 10
✗ Fallidas: 0

✅ TESTS PASARON - COMMIT PERMITIDO
```

### Logs de Testing

Todos los hooks generan logs en tiempo real visibles para:
- Claude (en el contexto de ejecución)
- Usuario (en la terminal)

---

## 🛡️ Garantías del Sistema

Con este sistema **permanentemente activo**, se garantiza:

1. ✅ **Ningún cambio rompedor llega a código**
   - Tests se ejecutan ANTES y DESPUÉS de editar

2. ✅ **100% de cobertura se mantiene**
   - Tests de regresión validan que nada se rompa

3. ✅ **Commits solo con tests pasando**
   - Imposible hacer commit con tests fallidos

4. ✅ **Push solo con validación completa**
   - Suite completa se ejecuta antes de push

5. ✅ **Validación automática de .Rmd**
   - FASE 2A (matemática) + FASE 2B (preview) automáticas

6. ✅ **Claude no puede romper el sistema**
   - Hooks bloquean cambios peligrosos

7. ✅ **CI/CD adicional en remoto**
   - GitHub Actions ejecuta tests en cada push/PR

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

**Claude debe:**
- NO intentar editar el archivo
- Informar al usuario del problema
- Esperar instrucciones

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

**Claude debe:**
- Analizar el error reportado
- Identificar qué rompió
- Proponer corrección
- Aplicar corrección
- Verificar que tests pasen

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

**Claude debe:**
- NO intentar commit con --no-verify
- Informar al usuario qué tests fallaron
- Ayudar a corregir el código
- Esperar a que tests pasen

---

## 📚 Archivos del Sistema Automático

```
.claude/
├── rules/
│   └── testing-obligatorio.md           # Esta regla (documentación completa)
├── hooks/
│   ├── pre-edit-testing.sh              # Validación pre-edición
│   ├── post-edit-testing.sh             # Validación post-edición
│   ├── pre-bash-testing.sh              # Bloqueo commit/push
│   └── post-exams2-validation.sh        # Validación matemática + preview
├── settings.json                         # Configuración de hooks
└── docs/
    ├── ECOSISTEMA_TESTING.md            # Documentación completa
    └── FLUJO_AUTOMATICO_TESTING.md      # Este archivo

tests/
├── run_all_tests.R                      # Script ejecutor principal
└── testthat/
    ├── test_validacion_matematica.R
    ├── test_ortografia_espanol.R
    ├── test_renderizado_4_formatos.R
    ├── test_aleatorization_diversity.R
    ├── test_flujo_b_graficador.R
    ├── test_regression_suite.R
    ├── test_neg_visual_distinctness.R
    ├── test_media_mediana_moda.R
    ├── test_validacion_semantica.R
    └── test_correctitud_respuesta.R

.github/workflows/
└── ci-testing.yml                        # CI/CD remoto
```

---

## 🔧 Mantenimiento del Sistema

### Actualizar Hooks

1. Editar archivo de hook (ej. `pre-edit-testing.sh`)
2. Los tests de regresión validan automáticamente que el hook funciona
3. Commit y push con sistema automático validando

### Agregar Nuevos Tests

1. Crear `test_nuevo_componente.R`
2. Sistema detecta que es archivo crítico (test_*.R)
3. Pre-edit ejecuta suite completa
4. Post-edit valida que el nuevo test funciona
5. Commit solo se permite si todo pasa

### Deshabilitar Temporalmente (PROHIBIDO)

❌ **NO hay forma de deshabilitar el sistema**
❌ **NO usar `--no-verify`**
❌ **NO comentar hooks en settings.json**

✅ **SIEMPRE corregir el código para que pase los tests**

---

## ✅ Verificación del Sistema

Para verificar que el sistema está activo:

```bash
# 1. Verificar que hooks existen y tienen permisos
ls -la .claude/hooks/*.sh

# 2. Verificar configuración en settings.json
cat .claude/settings.json | grep -A 20 "hooks"

# 3. Probar manualmente
Rscript tests/run_all_tests.R

# 4. Intentar commit de prueba (debería bloquear si hay tests fallidos)
git commit -m "test" --allow-empty
```

---

**Versión:** 1.2
**Fecha:** 2026-02-14
**Estado:** ACTIVO Y PERMANENTE
**Modificable:** Solo con tests pasando

### Cambios v1.2 (2026-02-14)
- Actualizado a 10 suites, 82+ tests (era 9 suites, 68+)
- Agregado test_correctitud_respuesta.R al árbol
- FASE 2G (multi-semilla Nivel 5) agregada al diagrama EVENTO 4

### Cambios v1.1 (2026-02-13)
- Actualizado a 9 suites, 68+ tests (era 6 suites, 33+)
- Agregados 3 archivos de test al árbol: neg_visual, media_mediana_moda, validacion_semantica
