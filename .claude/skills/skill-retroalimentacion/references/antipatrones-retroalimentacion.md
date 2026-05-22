# Antipatrones PROHIBIDOS — Retroalimentacion ICFES

## 1. Solution minima sin analisis

```markdown
❌ Solution
========
La respuesta correcta es A.
```

**Correccion:** La Solution DEBE incluir las 5 secciones obligatorias: encabezado diagnostico, ¿que evalua?, justificacion con LaTeX, analisis de CADA opcion incorrecta, reflexion metacognitiva.

---

## 2. Analisis superficial de distractores

```markdown
❌ **Opcion B:** Esta opcion es incorrecta.
```

**Correccion:** Usar el patron completo "Es posible que...":

```markdown
✓ **Opcion B:**
Es posible que los estudiantes que eligen la opcion B [DESCRIPCION ESPECIFICA DEL ERROR].
Este error se presenta cuando [CAUSA RAIZ]. Para evitar este error, el estudiante debe
[ESTRATEGIA CORRECTIVA especifica].
```

---

## 3. Sin justificacion matematica

```markdown
❌ La respuesta es A porque es la unica que cumple con las condiciones.
```

**Correccion:** Siempre incluir pasos numerados con formulas LaTeX:

```markdown
✓ ### Respuesta Correcta: A
✓
✓ **Justificacion matematica:**
✓
✓ **Paso 1:** [Descripcion del primer paso]
✓ $$[Formula LaTeX completa]$$
✓
✓ **Paso 2:** [Descripcion]
✓ $$[Formula LaTeX]$$
✓
✓ **Por lo tanto**, la respuesta correcta es **A** porque [conclusion especifica].
```

---

## 4. Sin analisis de errores individuales

```markdown
❌ Las demas opciones son incorrectas por errores de calculo.
```

**Correccion:** Analizar CADA opcion incorrecta por separado con su error conceptual especifico.
Si hay 4 opciones y 1 es correcta, DEBEN aparecer 3 bloques "**Opcion X:**" separados.

---

## Regla de oro

**El patron "Es posible que los estudiantes que eligen la opcion X..."** NO es opcional.
Es el formato oficial ICFES (Guia de Orientacion Matematicas 11° Cuadernillo 2-2023, pp. 22-51).
Cada analisis de opcion incorrecta DEBE incluir: error + causa raiz + estrategia correctiva.
