# Reglas para Código R/Markdown

## Pre-Edit/Write: Regla de Oro

Antes de editar cualquier archivo .Rmd, verifica OBLIGATORIAMENTE:

- ✓ Entendiste completamente el error a corregir
- ✓ Verificaste solución en ejemplos funcionales (`/A-Produccion/Ejemplos-Funcionales-Rmd/`)
- ✓ NO harás cambios innecesarios o experimentales
- ✓ Validarás en los 4 formatos después del cambio

## Advertencias Críticas

### ❌ NUNCA hacer:

1. **NO usar `include_tikz()` sin renderizado condicional**
   ```r
   # MAL - falla en HTML
   include_tikz("grafico.tex")

   # BIEN - renderizado condicional
   if (knitr::is_latex_output()) {
     include_tikz("grafico.tex")
   } else {
     knitr::include_graphics("grafico.png")
   }
   ```

2. **NO mezclar código Python/R sin validar en ambos**
   - Siempre probar con reticulate activo e inactivo
   - Validar que variables se transfieren correctamente

3. **NO crear ejercicios con < 200 versiones únicas**
   - Validar con `exams2html("archivo.Rmd", n = 200)`
   - Verificar diversidad de parámetros aleatorios
   - Razón del umbral: ejercicios con restricciones algebraicas fuertes
     (cubos perfectos, primos, etc.) no pueden generar más sin degradar
     la diagnosticidad de los distractores

4. **NO omitir validación en los 4 formatos**
   - HTML, PDF, DOCX, NOPS son OBLIGATORIOS

5. **NO modificar ejemplos funcionales**
   - Los archivos en `/A-Produccion/Ejemplos-Funcionales-Rmd/` son INMUTABLES
   - Solo copiar patrones, nunca editar directamente

6. **NO usar `exshuffle: FALSE`** (regla general)
   ```yaml
   # ❌ MAL - permite patrones predecibles
   exshuffle: FALSE

   # ✓ BIEN - mezcla aleatoria obligatoria
   exshuffle: TRUE
   ```
   **Razón**: ICFES requiere distractores avanzados. `exshuffle: TRUE` garantiza:
   - Opciones de respuesta mezcladas aleatoriamente
   - Estudiante no puede identificar patrones visuales/textuales
   - Obliga al estudiante a analizar cada opción individualmente
   - Genera versiones únicas en cada renderizado

   **⚠️ EXCEPCIÓN (ampliada 2026-05-03)**: `exshuffle: FALSE` + mezcla interna con `sample()`
   es OBLIGATORIO en CUALQUIERA de estos casos:

   1. SCHOICE con opciones gráficas individuales (PNGs).
   2. SCHOICE cuya Solution referencia `r letra_correcta` o cualquier letra explícita
      (ej: "La respuesta correcta es la **Opción A**").
   3. Cualquier ejercicio donde la sección Solution muestre el contenido específico de
      la opción correcta basándose en su letra/posición pre-mezcla.

   **Por qué**: R-exams con `exshuffle: TRUE` re-mezcla las opciones del Answerlist y
   ajusta `exsolution`, pero **NO modifica el texto de la Solution**. Si el .Rmd dice
   "Opción A" pero R-exams movió esa opción a (c), el estudiante ve una inconsistencia
   silenciosa que NO detecta validación sintáctica.

   El `sample()` interno en `data_generation` ya garantiza aleatorización en cada
   renderizado (semillas distintas → órdenes distintos). `exshuffle: FALSE` solo evita
   la doble mezcla incoherente.

   Ver Error 17 en `.claude/docs/patrones-errores-conocidos.md`,
   `.claude/rules/graficos-como-opciones.md` y la regla #18
   `.claude/rules/markdown-imagenes-pdf.md` (vinculada).

   **⚠️ ACTUALIZACIÓN 2026-05-12 (regla #19):** los casos 2 y 3 de esta excepción quedan OBSOLETOS porque la regla #19 (`solution-letter-independence.md`) prohíbe terminantemente las referencias `r letra_correcta` y literal "Opción [A-D]" en la sección Solution. Por lo tanto, el único caso vivo de la excepción para `exshuffle: FALSE` es el caso 1 (SCHOICE con opciones gráficas individuales en PNGs). Para SCHOICE de texto, usar `exshuffle: TRUE` o `exshuffle: FALSE + sample() interno` indistintamente — ya no depende de Solution porque Solution es letter-independent.

## ⚠️ 5 Coherencias OBLIGATORIAS

Antes de aprobar cualquier ejercicio, verificar las 5 coherencias:

### 1. Coherencia Semántica
- Gramática correcta en español
- Sin errores ortográficos en etiquetas y texto
- Redacción clara y precisa estilo ICFES
- Terminología matemática apropiada

### 2. Coherencia Visual-Texto
- Gráfico coincide exactamente con el enunciado
- Valores en el gráfico = valores en el texto
- Etiquetas del gráfico consistentes con la pregunta
- Colores/estilos descritos coinciden con lo renderizado

### 3. Coherencia Matemática
- Fórmulas correctas y bien formateadas
- Cálculos verificables paso a paso
- Proporciones y escalas correctas en gráficos
- Respuesta correcta es matemáticamente válida
- Distractores son plausibles pero incorrectos

### 4. Coherencia de Código
- Código dinámico (usa variables aleatorias)
- Compatible con R-exams en 4 formatos
- Sin dependencias externas no declaradas
- Gráficos generados programáticamente (no estáticos)
- Variables R interpoladas correctamente en TikZ/Python

### 5. Coherencia General
- Legible en todos los formatos (HTML, PDF, DOCX, NOPS)
- Estilo visual consistente con estándares ICFES
- Dificultad apropiada al nivel declarado (n1-n4)
- Tiempo de resolución razonable para el contexto
- **Nivel ICFES coherente con DOK**: si DOK ≥ 3 → Nivel ≥ 3 (ver `ejercicios-metacognitivos.md`)

7. **NO omitir validación de opciones repetidas en ejercicios `_neg_`**
   ```r
   # Si el archivo tiene _neg_ en el nombre:
   # - OBLIGATORIO: test con digest::digest() que verifica (N-1) idénticas + 1 diferente
   # - OBLIGATORIO: colores_opciones con N colores únicos
   # Ver: .claude/rules/validacion-neg-opciones-repetidas.md
   ```

8. **NO seleccionar errores conceptuales sin verificar precondiciones**

   Cada error en `errores_conceptuales` DEBE declarar `precondicion`:
   - `function(params) TRUE` si siempre aplica (mayoría de errores)
   - `function(params) params$n %% 2 == 0` si solo aplica con n par
   - `calcula()` DEBE fallar con `stop()` si se llama fuera de contexto

   **Defensa en profundidad**: Aun sin `precondicion` declarada, el **keyword scanner
   automático** (Capa B) escanea `descripcion_corta/larga` buscando condiciones
   implícitas ("número par", "bimodal", "muestra grande"...) y reporta `ERR_SEM_B`
   si la condición no se cumple con los datos actuales.

   Ver: `.claude/rules/ejercicios-metacognitivos.md` (sección Pool de Errores + Validación Semántica)

   ```r
   # ❌ MAL - filtrado hardcoded por caso específico
   if (n %% 2 == 0) errores_idx <- c(1,2,3,4) else errores_idx <- c(1,2,3)

   # ✓ BIEN - filtrado genérico por precondiciones declaradas
   params <- list(n = n, datos_ord = datos_ord)
   errores_aplicables_idx <- which(sapply(errores_conceptuales, function(err) {
     if (is.null(err$precondicion)) return(TRUE)
     err$precondicion(params)
   }))
   error_idx <- sample(errores_aplicables_idx, 1)
   ```

9. **NO comparar resultado de `calcula()` sin guardia NA**
   ```r
   # ❌ MAL - calcula() puede retornar NA si tipo_operacion no coincide
   while (respuesta_erronea == valor_correcto && intentos < 20) {

   # ✓ BIEN - guardia NA antes de comparación
   while ((is.na(respuesta_erronea) || respuesta_erronea == valor_correcto) && intentos < 20) {
   ```
   **Razón**: `calcula()` retorna NA cuando `tipo_operacion` no coincide con el error
   seleccionado. `NA == valor` produce `NA`, no TRUE/FALSE, y R crashea en `while`/`if`.
   Detectado en ejercicio Venn (semillas 29 y 114 de 200 crasheaban).

10. **NO usar `set.seed()` en chunks de test sin guardar/restaurar `.Random.seed`**
    ```r
    # ❌ MAL - corrompe el estado RNG para renderizados posteriores
    test_that("diversidad", {
      for (i in 1:300) {
        set.seed(i * 7)
        # ... genera versiones
      }
    })
    # Después de esto, exams2html(n=50) produce solo 2 versiones únicas

    # ✓ BIEN - preserva el estado RNG
    test_that("diversidad", {
      saved_seed <- if (exists(".Random.seed", envir = globalenv())) {
        get(".Random.seed", envir = globalenv())
      } else NULL

      for (i in 1:300) {
        set.seed(i * 7)
        # ... genera versiones
      }

      # Restaurar RNG
      if (!is.null(saved_seed)) {
        assign(".Random.seed", saved_seed, envir = globalenv())
      } else {
        rm(".Random.seed", envir = globalenv())
      }
    })
    ```
    **Razón**: `set.seed()` dentro de un test modifica `.Random.seed` global.
    Si el chunk de test se ejecuta antes que R-exams genere versiones, todas
    las versiones comparten el mismo estado RNG y producen resultados idénticos.
    Detectado en ejercicio Venn: 2/50 versiones únicas → 94/100 después del fix.

13. **NO usar `![](file.png)` Markdown sin atributo `{width=...}`** (regla #18)

    Pandoc 3.x envuelve `\includegraphics` en `\pandocbounded{...}` cuando la imagen
    no tiene atributo de tamaño, comando que NO está definido en templates LaTeX de
    R-exams → falla `exams2pdf()` con `Undefined control sequence`.

    ```markdown
    ❌ MAL — falla en PDF
    ![](grafico.png)
    ![texto](g.png)
    ```

    ```r
    ❌ MAL — mismo bug vía cat()
    cat("![](grafico.png)\n")

    ✓ BIEN — atributo width explícito
    cat("![](grafico.png){width=80%}\n")
    ```

    Ver `.claude/rules/markdown-imagenes-pdf.md` y Error 16 en
    `.claude/docs/patrones-errores-conocidos.md`.

14. **NO colocar `##ANSWERi##` de CLOZE fuera de orden ni omitir placeholders**
    ```markdown
    ❌ MAL - ##ANSWER1## después de Parte 2
    **Parte 1.** ¿Cuál es el error?
    **Parte 2.** ¿Cuál es el valor correcto?
    ##ANSWER1##
    ##ANSWER2##

    ✓ BIEN - cada ##ANSWERi## inmediatamente después de su parte
    **Parte 1.** ¿Cuál es el error?
    ##ANSWER1##
    **Parte 2.** ¿Cuál es el valor correcto?
    ##ANSWER2##
    **Parte 3.** Seleccione las afirmaciones verdaderas:
    ##ANSWER3##
    **Parte 4.** Verdadero o falso:
    ##ANSWER4##
    ```
    **Regla para CLOZE**: El número de `##ANSWERi##` DEBE coincidir con el número
    de tipos en `exclozetype`. Cada placeholder va inmediatamente después de la
    pregunta de su parte correspondiente. NO usar chunks R con `cat()` para
    duplicar el Answerlist — R-exams ya renderiza las opciones via el Answerlist
    del final.

## ✓ SIEMPRE hacer:

- Validar gráficos dinámicos en PDF Y HTML
- Consultar ejemplos funcionales antes de cualquier corrección
- Ejecutar ciclo completo de validación (FASE 1→2→3)
- Documentar solo después de confirmar solución 100%
- Usar metadatos ICFES completos (6 dimensiones)
- Si archivo es `_neg_`: incluir test genérico de opciones repetidas (regla #11)
- Todo error conceptual con aplicabilidad condicional DEBE declarar `precondicion` (regla #8)
- Comparaciones con resultado de `calcula()` DEBEN tener guardia `is.na()` (regla #9)
- Chunks de test con `set.seed()` DEBEN guardar/restaurar `.Random.seed` (regla #10)
- En CLOZE: `##ANSWERi##` por cada parte, en orden, inmediatamente después de su pregunta (regla #14)
- Toda imagen en bloque R `cat()` o Markdown directo DEBE incluir atributo `{width=...}` (regla #13 / regla maestra #18)

## Metadatos ICFES Requeridos

Todo ejercicio DEBE incluir:
```yaml
exname: [Nombre descriptivo]
extype: [schoice|cloze]
exsolution: [Respuesta correcta]
exshuffle: TRUE          # ⚠️ OBLIGATORIO - NUNCA usar FALSE
extol: 0.01

# Metadatos ICFES (6 dimensiones OBLIGATORIAS)
exextra[Type]: [SCHOICE|CLOZE]
exextra[Competencia]: [Interpretación|Formulación|Argumentación]
exextra[Componente]: [Aleatorio|Cambio|Datos|Espacial|Medida]
exextra[Afirmacion]: [Descripción específica]
exextra[Evidencia]: [Descripción específica]
exextra[Nivel]: [1|2|3|4]
```

## Ejemplos Funcionales = Fuente de Verdad (Búsqueda Inteligente)

Ante cualquier error, consultar en **orden de prioridad**:

**Prioridad 1 — Ejercicios recientes completados** (reflejan patrones vigentes):
```bash
ls -t A-Produccion/03-En-Produccion/**/*metacognitivo*.Rmd 2>/dev/null | head -3
ls -t A-Produccion/02-En-Desarrollo/**/*metacognitivo*.Rmd 2>/dev/null | head -3
```
Solo considerar .Rmd con `aprobacion_usuario.completado = true` o en `03-En-Produccion/`.

**Prioridad 2 — Ejemplos canónicos inmutables** (fuente de verdad base):
```bash
ls A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/*.Rmd
```

Los ejemplos canónicos son la fuente de verdad inmutable. Los ejemplos recientes complementan con patrones actualizados.
