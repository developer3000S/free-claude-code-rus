# Antipatrones PROHIBIDOS — CLOZE Metacognitivo

## 1. CLOZE con menos de 4 partes

```markdown
❌ Parte 1: Calcule X
   Parte 2: Calcule Y
```

**Correccion:** Siempre 4 partes con Progressive Disclosure completo:

```markdown
✓ Parte 1: Identificar el error conceptual (Analizar)
✓ Parte 2: Calcular el valor correcto (Aplicar)
✓ Parte 3: Evaluar afirmaciones sobre el concepto (Evaluar)
✓ Parte 4: Transferir a caso especifico — V/F (Analizar/Evaluar)
```

**Por que:** Progressive Disclosure requiere escalada cognitiva. Dos calculos
del mismo nivel no cumplen el requisito de Bloom ascendente.

---

## 2. Partes sin progresion cognitiva

```markdown
❌ Parte 1: Calcule area
   Parte 2: Calcule perimetro
   Parte 3: Calcule volumen
   Parte 4: Calcule diagonal
```

**Correccion:** Cada parte sube nivel cognitivo:

```markdown
✓ Parte 1: Identificar error en calculo de area (Analizar — DOK 3)
✓ Parte 2: Calcular area correcta (Aplicar — DOK 2)
✓ Parte 3: Evaluar propiedades del area y perimetro (Evaluar — DOK 3)
✓ Parte 4: Aplicar a caso especifico V/F (Transferir — DOK 3)
```

---

## 3. Afirmaciones sin base conceptual

```markdown
❌ pool_afirmaciones_falsas <- list(
     "El resultado es 42",
     "La respuesta es incorrecta"
   )
```

**Correccion:** Afirmaciones basadas en errores conceptuales reales:

```markdown
✓ pool_afirmaciones_falsas <- list(
     "El promedio siempre es uno de los valores del conjunto de datos",
     "Si se duplica cada dato, el promedio se mantiene igual",
     "La mediana y el promedio siempre coinciden en distribuciones simetricas"
   )
```

**Por que:** Las afirmaciones del pool deben reflejar concepciones erroneas
comunes de los estudiantes. Afirmaciones vacias no tienen valor diagnostico.

---

## 4. ##ANSWERi## mal ubicado

```markdown
❌ Parte 1. ¿Cual es el error?
   Parte 2. ¿Cual es el valor correcto?
   ##ANSWER1##
   ##ANSWER2##
```

**Correccion:** Cada placeholder va inmediatamente despues de SU pregunta:

```markdown
✓ Parte 1. ¿Cual es el error?
   ##ANSWER1##
   Parte 2. ¿Cual es el valor correcto?
   ##ANSWER2##
```

**Por que:** R-exams renderiza las opciones de respuesta en la posicion
del placeholder. Si estan al final, las opciones de Parte 1 aparecen
despues de leer Parte 2, rompiendo el flujo del ejercicio.
Ver regla #12 en `.claude/rules/codigo-rmd.md`.
