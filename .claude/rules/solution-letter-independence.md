# Regla #19 — Solution Letter-Independence (NUNCA referencias hardcoded a letra de opción)

## Principio Fundamental

**La sección `Solution` de un `.Rmd` NUNCA debe identificar la opción correcta por su letra/posición (A/B/C/D). DEBE identificarla por contenido (`descripcion_corta`), código del error (`GRAF-ARG-NN`, `EST-MTC-NN`) o etiqueta semántica ("argumento válido", "respuesta correcta").**

Esta regla NO tiene excepciones. Aplica a todo `.Rmd` SCHOICE o CLOZE que renderice una sección `Solution` con justificación, sea cual sea el valor de `exshuffle`.

---

## Origen: incidente 2026-05-12 (Comparacion-Lineas-Temporales-Schoice)

Estudiante real (KEVIN A. SILVA, p3c-mat) reportó confusión sobre un cuestionario Moodle:

- Seleccionó opción C, sistema marcó **Incorrecta**.
- La sección "Respuesta correcta" mostraba **"Opción C"** como respuesta correcta.
- El texto explicativo describía un argumento que no correspondía al texto literal de la opción C visible.

**Causa raíz:** el `.Rmd` tenía:

```rmd
### Respuesta correcta: Opción `r letra_correcta` {#respuesta-correcta-...}
```

con `letra_correcta <- c("A","B","C","D")[idx_correcto]` calculado tras el `sample()` interno y con `exshuffle: FALSE`. La asunción implícita era: "exshuffle:FALSE evita que la posición cambie".

**Esa asunción es falsa en Moodle.** Moodle tiene un setting independiente "Shuffle answers" en la configuración del cuestionario que **re-mezcla las opciones en tiempo de display**, sin tocar el marcado de cuál es correcta. La variable `letra_correcta` se evalúa en R una sola vez al generar el XML, queda escrita en el cuerpo de la Solution como "Opción C" (por ejemplo), y luego Moodle muestra esa misma opción en una posición distinta (digamos A). El estudiante ve incoherencia silenciosa.

Este es un caso **gemelo** de Error 17 (exshuffle:TRUE + letra), pero con `exshuffle:FALSE`. Error 17 forzó la regla #6 ampliada en `codigo-rmd.md`. Esta regla extiende esa defensa al caso simétrico.

---

## Patrones PROHIBIDOS

### ❌ P1: Header con letra inline

```rmd
### Respuesta correcta: Opción `r letra_correcta`
### Respuesta correcta: Opción `r letras[idx_correcto]`
### Respuesta correcta: Opción `r c("A","B","C","D")[which(solucion==1)]`
```

### ❌ P2: Cuerpo de prosa con letra interpolada

```rmd
La respuesta correcta es la **opción `r letra_correcta`** porque ...
Por lo tanto, la opción `r letra_correcta` es la única que ...
```

### ❌ P3: Análisis de distractores con letra hardcoded

```r
# En chunk R:
for (l in letras) {
  cat("**Opción ", l, " (", err$codigo, "):** ", ...)
}
```

### ❌ P4: Literal "Opción A/B/C/D" en Markdown

```markdown
Las opciones B y D son incorrectas porque ...
**Opción A:** este argumento ...
```

---

## Patrones ACEPTADOS

### ✓ A1: Header sin letra

```rmd
### Respuesta correcta {#respuesta-correcta-`r ex_uid`}

**Argumento válido:** "`r errores_conceptuales[[2]]$descripcion_corta`"
```

### ✓ A2: Identificación por contenido textual

```rmd
La respuesta correcta es la que afirma: "`r texto_opcion_correcta`".
```

### ✓ A3: Identificación por código del error

```r
for (l in letras) {
  opc <- opciones_mezcladas[[l]]
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

### ✓ A4: Etiqueta semántica genérica

```rmd
La opción que afirma X es la correcta porque ...
El argumento válido es el que ...
```

---

## Por qué esta regla NO es opcional

- Inmuniza al `.Rmd` contra cualquier reshuffle downstream (Moodle, OpenOLAT, Canvas, formato impreso randomizado).
- Funciona aunque el operador olvide desactivar "Shuffle answers" en Moodle.
- Funciona aunque R-exams cambie su contrato de `exshuffle` en versiones futuras.
- Funciona aunque el operador haga `exams2nops()` con re-ordenamiento aleatorio.
- Convierte un patrón frágil (acoplado a configuración externa) en uno robusto (auto-contenido).

`letra_correcta` puede seguir existiendo como variable R para conveniencia interna (logs, debug), pero NUNCA debe aparecer en código que emita texto al estudiante.

---

## Defensa Automática (4 capas)

### Capa 1 — Hook PreToolUse (gate pre-write)

`pre-write-rmd-gate.sh` escanea el cuerpo emitido durante Write/Edit y bloquea si detecta los patrones P1-P4 dentro de la sección `Solution`. Exit 2 con instrucciones de fix.

### Capa 2 — Hook PostToolUse FASE 2J

`post-exams2-validation.sh` ejecuta FASE 2J tras 2I:

```bash
# Extraer sección Solution
sed -n '/^Solution\s*$/,/^Meta-information\s*$/p' "$RMD" > /tmp/sol_block.txt

# P1, P2: r letra_correcta o letras[idx]
grep -nE '`r\s+(letra_correcta|letras\[)' /tmp/sol_block.txt && \
  echo "❌ ERR_SOL_LETRA_R: Solution referencia letra_correcta hardcoded" && exit 1

# P3: cat("**Opción ", l ...
grep -nE 'cat\(.*"\*\*Opción "' /tmp/sol_block.txt && \
  echo "❌ ERR_SOL_LETRA_CAT: Solution emite 'Opción ' con variable de letra" && exit 1

# P4: literal "Opción A/B/C/D" en Markdown
grep -nE '(^|[^`])(\*\*)?Opci[oó]n [A-D]\b' /tmp/sol_block.txt && \
  echo "❌ ERR_SOL_LETRA_LITERAL: Solution menciona 'Opción [A-D]' literal" && exit 1
```

Códigos de error: `ERR_SOL_LETRA_R`, `ERR_SOL_LETRA_CAT`, `ERR_SOL_LETRA_LITERAL` (todos bloqueantes).

### Capa 3 — Test de regresión estático

`tests/testthat/test_letter_independence.R` recorre todos los `.Rmd` en `01-En-PreDesarrollo/`, `02-En-Desarrollo/` y `03-En-Produccion/` (excepto `Ejemplos-Funcionales-Rmd/`), extrae la sección Solution y aplica los 3 detectores. Falla cualquier match.

### Capa 4 — Detractor (dominio `codigo_rexams`)

El detractor agrega un check explícito de letter-independence en su checklist. Reporta como objeción **CRÍTICA** cualquier match de P1-P4.

---

## Detección de patrones

| Patrón | Regex | Severidad | Capa que lo atrapa |
|---|---|---|---|
| P1: `` `r letra_correcta` `` | `` `r\s+letra_correcta\b`` | CRÍTICA | 1, 2, 3, 4 |
| P1b: `` `r letras[...]` `` | `` `r\s+letras\[`` | CRÍTICA | 1, 2, 3, 4 |
| P2: prosa con letra interpolada | igual a P1 dentro de párrafo | CRÍTICA | 2, 3 |
| P3: `cat("**Opción ", l, ...)` | `cat\(.*"\*\*Opción ".*l[,)]` | CRÍTICA | 2, 3 |
| P4: literal `Opción A/B/C/D` | `\bOpci[oó]n [A-D]\b` (no en backticks) | CRÍTICA | 2, 3, 4 |

---

## Excepciones

**NINGUNA.** Si un caso especial requiere referenciar la letra de opción en Solution, antes documentar en ADR explicando por qué la regla no aplica, obtener aprobación humana, y actualizar esta regla. No bypass tácitos.

Casos que NO son excepciones (deben cumplir igual):
- Solution muestra una tabla con valores y nombres de opciones → usar contenido, no letra
- Ejercicio educa sobre Moodle mismo → no aplica, Moodle no es contenido ICFES
- "El estudiante ya seleccionó una letra" → la feedback per-option del Answerlist (segundo Answerlist en Solution) sí puede usar `Correcto/Incorrecto` posicional porque R-exams mapea por contenido, no por letra rendered

---

## Variable `letra_correcta` — uso aceptado

`letra_correcta` puede seguir computándose para:

- Logs de debug en chunks R con `message()` o `cat()` a stderr (no a la salida del estudiante)
- Verificaciones en `stopifnot()` o tests internos del chunk
- Pasarse a tests externos vía `digest` o assertions

**NO PUEDE aparecer en:**
- Texto Markdown emitido al estudiante
- `cat()` con `results='asis'` que escribe a la Solution renderizada
- Comentarios renderizados a HTML/PDF

---

## Cómo migrar un .Rmd legado

1. Buscar `r letra_correcta`, `r letras[`, `letras[idx_correcto]` en el .Rmd.
2. Para cada match en la sección Solution:
   - Si está en un header (`### Respuesta correcta: Opción ...`) → quitar la letra del header.
   - Si está en prosa → reformular para identificar por contenido.
   - Si está en `cat("**Opción ", l, ...)` → reemplazar por `cat("**", err$codigo, " — ", err$nombre, "**\n\n*Argumento:* \"", err$descripcion_corta, "\"\n\n", ...)`.
3. Re-renderizar y validar 4 formatos.
4. Validar 20 semillas (FASE 2G).
5. Actualizar `ejercicio_state.json` si está en pipeline de desarrollo.

---

## Tests asociados

| Test | Verifica |
|---|---|
| `tests/testthat/test_letter_independence.R` | Sección Solution de cada .Rmd no contiene P1, P2, P3, P4 |
| Hook FASE 2J | Detección automática post-render |

---

## Relación con otras reglas

- **Regla #6 ampliada** (`codigo-rmd.md`): exigía `exshuffle:FALSE` cuando Solution usa `letra_correcta`. Esta regla #19 va más allá: prohíbe la combinación misma, independiente de `exshuffle`.
- **Error 17** (`patrones-errores-conocidos.md`): caso original con `exshuffle:TRUE`. Error 19 (nuevo): caso simétrico con `exshuffle:FALSE` + shuffle downstream.
- **Regla #16** (`workflow-state-enforcement.md`): el gate `pre-write-rmd-gate.sh` agrega los detectores P1-P4 a su lista de bloqueantes.

---

## Referencias

- Error 19 en `.claude/docs/patrones-errores-conocidos.md` (post-2026-05-12)
- Sesión 2026-05-12 con estudiante real KEVIN A. SILVA
- Issue gemelo: Error 17 (exshuffle:TRUE + letra)
- Commit del fix original: `86a4b211` (lineas-temporales-schoice)

---

**Versión:** 1.0
**Fecha:** 2026-05-12
**Estado:** ACTIVO Y OBLIGATORIO
**Excepciones:** NINGUNA
**Aplica a:** todo archivo `.Rmd` con sección `Solution` que justifique la respuesta correcta.
