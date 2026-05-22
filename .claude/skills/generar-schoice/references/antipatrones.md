# Antipatrones PROHIBIDOS — SCHOICE Metacognitivo

## 1. Ejercicio puramente procedimental

```markdown
❌ "Calcula el area de un rectangulo con base 8 cm."
```

**Correccion:** Convertir a analisis de error:

```markdown
✓ "Un estudiante calculo 8 + 5 = 13 como area. ¿Cual fue su error conceptual?"
```

**Por que:** Los ejercicios procedimentales no desarrollan metacognicion (Schraw & Dennison, 1994).
El patron obligatorio es: *evaluar el razonamiento de otro*, no calcular directamente.

---

## 2. Distractores aleatorios

```r
❌ distractores <- respuesta + sample(-10:10, 3)
```

**Correccion:** Usar pool de errores conceptuales:

```r
✓ error_sel <- errores_conceptuales[[sample(errores_aplicables_idx, 1)]]
✓ respuesta_erronea <- error_sel$calcula(datos_ord)
```

**Por que:** Los distractores aleatorios no representan errores reales de estudiantes
y no permiten diagnostico pedagogico. Cada distractor debe tener codigo, causa_raiz
y funcion calcula() asociada.

---

## 3. Solucion sin analisis de error

```markdown
❌ Solution
========
La respuesta correcta es 40.
```

**Correccion:** Incluir analisis completo con las 6 subsecciones obligatorias:

```markdown
✓ ### Analisis del Error
✓ **Error identificado:** [descripcion_larga del error seleccionado]
✓ **Codigo de error:** [codigo, ej: EST-MTC-01]
✓ **Causa raiz:** [causa_raiz del error]
✓
✓ ### Procedimiento Correcto
✓ **Paso 1:** [descripcion + formula LaTeX]
✓ $$...$$
✓
✓ ### Propiedades del Concepto
✓ [afirmaciones sobre el concepto matematico]
✓
✓ ### Caso Especifico
✓ [transferencia a caso concreto]
✓
✓ ### Reflexion Metacognitiva
✓ `r sample(reflexiones_metacognitivas, 1)`
✓
✓ ### Estrategia para Evitar el Error
✓ 1. [paso preventivo]
✓ 2. [verificacion final]
```

**Por que:** La Solution debe desarrollar consciencia metacognitiva, no solo
confirmar la respuesta. Ver `.claude/rules/ejercicios-metacognitivos.md` —
seccion "Solucion Solution Obligatoria".

---

## 4. Conclusion fija + justificacion con roles invertibles (lecciones 2026-05-12)

```r
❌ list(
   codigo = "GRAF-ARG-03",
   descripcion_corta = paste0(
     "No, porque existen años donde ", pais_perdedor,
     " supera a ", pais_ganador
   )
 )
```

**Problema:** cuando `afirmacion_es_verdadera = FALSE`, `pais_perdedor` toma el rol
de `pais_a` → el texto dice "Pa supera a Pb" (justificacion apoya conclusion "Si")
pero la opcion empieza con "No" → **incoherencia interna silenciosa**.

```r
✓ list(
   codigo = "GRAF-ARG-03",
   descripcion_corta = if (afirmacion_es_verdadera) {
     paste0("No, porque existen años donde ", pais_b, " supera a ", pais_a)
   } else {
     paste0("Si, porque existen años donde ", pais_a, " supera a ", pais_b)
   }
 )
```

**Regla:** si la justificacion usa variables que invierten rol segun un flag,
la conclusion ("Si"/"No") tambien debe ser condicional al MISMO flag.

---

## 5. Premisas que la generacion garantiza que NO ocurren

```r
❌ gap_min <- 0.3   # garantiza series_a[i] != series_b[i] siempre
   descripcion_corta = "No, porque hay un punto donde ambos países usan cantidades iguales..."
```

**Problema:** el estudiante mira el grafico, ve que las series NUNCA son iguales,
descarta el distractor automaticamente. El distractor pierde valor diagnostico.

```r
✓ descripcion_corta = "No, porque hay puntos donde los dos países usan cantidades muy similares..."
```

**Regla:** la `descripcion_corta` no debe afirmar como premisa observable
algo que las restricciones de generacion garantizan que NO ocurre.

---

## 6. Gotcha `sample(x, n)` cuando length(x) == 1

```r
❌ sel_si <- sample(distractores_si, n_si)
```

**Problema:** R interpreta `sample(c(3L), 1)` NO como "elige el elemento 3",
sino como `sample(1:3, 1)` (trata el escalar como rango). Cuando los pools
dinamicos colapsan a un solo elemento, la seleccion retorna un indice invalido
→ falla `stopifnot(opciones unicas)` o produce duplicados silenciosos.

```r
✓ sel_si <- distractores_si[sample.int(length(distractores_si), n_si)]
```

**Regla:** SIEMPRE usar `x[sample.int(length(x), n)]` para muestrear vectores
cuyo tamaño pueda ser 1 en algun caso (pools dinamicos por flags).
