---
name: skill-retroalimentacion
description: >
  Genera retroalimentación científica estilo ICFES para la sección Solution de ejercicios R-exams.
  OBLIGATORIO y AUTOMÁTICO para TODO ejercicio .Rmd. Incluye justificación matemática de respuesta
  correcta y análisis diagnóstico de CADA opción incorrecta.
  Usa con "generar retroalimentación", "mejorar solution", "analizar opciones incorrectas", "feedback ICFES".
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Integración obligatoria con generar-schoice y generar-cloze
metadata:
  author: alvaretto
  version: "1.0"
  language: es
  model_recommendation: opus
  fuente_oficial: "ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023"
activation:
  type: automatic
  triggers:
    - generar-schoice
    - generar-cloze
    - edit .Rmd Solution section
allowed-tools:
  - Read
  - Write
  - Edit
---

# Skill: Retroalimentación Científica Estilo ICFES

## Principio Fundamental

**TODO ejercicio .Rmd DEBE incluir una sección Solution con retroalimentación científica completa siguiendo el estándar oficial ICFES.**

Esta regla es **OBLIGATORIA**, **AUTOMÁTICA** y **PERMANENTE**. No hay excepciones.

Basado en: Guía de Orientación ICFES Matemáticas 11° (páginas 22-51).

---

## Estructura Obligatoria (5 secciones)

| Sección | Descripción |
|---------|-------------|
| **1. Encabezado diagnóstico** | Tabla con Competencia, Componente, Afirmación, Evidencia, Tarea, Nivel |
| **2. ¿Qué evalúa?** | 2-3 oraciones sobre la habilidad matemática evaluada |
| **3. Respuesta correcta** | Pasos numerados con fórmulas LaTeX + conclusión |
| **4. Opciones no válidas** | Una por cada opción incorrecta con patrón "Es posible que..." |
| **5. Reflexión metacognitiva** | Del pool de reflexiones + estrategias para evitar errores |

Ver [patron-retroalimentacion.md](references/patron-retroalimentacion.md) para el código completo de cada sección y ejemplo de estadística funcionando.

---

## Patron "Es posible que..." (Sección 4)

Cada opción incorrecta DEBE seguir este patron:

```
Es posible que los estudiantes que eligen la opción [X] [ERROR CONCEPTUAL].
Este error se presenta cuando [CAUSA RAÍZ].
Para evitar este error, el estudiante debe [ESTRATEGIA CORRECTIVA].
```

Ver tablas de patrones por componente (Numérico-Variacional, Geométrico-Métrico, Aleatorio) en [patron-retroalimentacion.md](references/patron-retroalimentacion.md).

---

## Pool de Reflexiones Metacognitivas

Definir en `data_generation` e invocar con `sample()` en Solution:

```r
reflexiones_metacognitivas <- c(
  "Identificar errores en el razonamiento de otros nos ayuda a evitar cometerlos nosotros mismos...",
  "Analizar por qué una respuesta es incorrecta fortalece la comprensión profunda del concepto...",
  # Mínimo 4 reflexiones, incluyendo al menos 1 específica al tema
)
```

Ver [pool-reflexiones.md](references/pool-reflexiones.md) para el pool base y guía para ampliarlo.

---

## Checklists

### Pre-generación
- [ ] Pool de errores conceptuales definido con códigos
- [ ] Cada error tiene descripción del patrón "Es posible que..."
- [ ] Justificación matemática incluye fórmulas LaTeX paso a paso
- [ ] Metadatos ICFES conocidos (competencia, componente, afirmación)

### Post-generación
- [ ] Encabezado diagnóstico completo (6 campos)
- [ ] Sección "¿Qué evalúa?" con 2-3 oraciones
- [ ] Justificación con pasos numerados y LaTeX
- [ ] CADA opción incorrecta tiene análisis con error + causa raíz + estrategia
- [ ] Reflexión metacognitiva con estrategias incluida

---

## Antipatrones PROHIBIDOS

Ver [antipatrones-retroalimentacion.md](references/antipatrones-retroalimentacion.md) para los 4 antipatrones con correcciones.

Resumen: (1) NO Solution mínima, (2) NO análisis superficial de distractores, (3) NO sin justificación matemática, (4) NO analizar todas las incorrectas con una sola frase genérica.

---

## Referencias

- [Patrón Completo de Retroalimentación](references/patron-retroalimentacion.md) - Código completo de 5 secciones + ejemplo estadística
- [Pool de Reflexiones Metacognitivas](references/pool-reflexiones.md) - Pool base y guía de ampliación
- [Antipatrones](references/antipatrones-retroalimentacion.md) - 4 antipatrones con correcciones
- [Plantilla Solution](references/plantilla-solution.md) - Plantilla reutilizable
- Fuente oficial: ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023 (pp. 22-51)
- Regla metacognitiva: `.claude/rules/ejercicios-metacognitivos.md`
- Ciclo validación: `.claude/rules/ciclo-validacion.md`

---

## Integración con Otros Skills

```
generar-schoice → [Genera Question + Answerlist]
                       ↓
              skill-retroalimentacion [AUTOMÁTICO]
                       ↓
              [Genera Solution completa]
                       ↓
              [Validación ciclo-validacion.md]
```

---

**Versión**: 1.0
**Fecha**: 2026-02-07
**Estado**: ACTIVO, OBLIGATORIO, AUTOMÁTICO, PERMANENTE
**Excepciones**: NINGUNA
