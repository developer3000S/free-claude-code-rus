---
output:
  pdf_document:
    latex_engine: xelatex
  html_document: default
---
# Eficiencia, Eficacia y Efectividad en la Generación de Ejercicios R/exams

> Basado en la infografía de Virginio Gallardo (@Virginiog)

---

## Resumen Visual

| Concepto | Pregunta Clave | Enfoque | Medición |
|----------|----------------|---------|----------|
| **Eficiencia** | ¿CÓMO lo hago? | Proceso | Rendimiento interno |
| **Eficacia** | ¿QUÉ logro? | Resultado | Impacto externo |
| **Efectividad** | ¿Lo hago BIEN y logro el objetivo? | Proceso + Resultado | Ambos |

---

## 1. EFICIENCIA (Cómo se hace)

### Definición

Se centra en **CÓMO** se hace el trabajo. Busca **reducir recursos, tiempo o esfuerzo** para hacer lo mismo.

### Características

- Enfoque en el **proceso**
- Mide el **rendimiento interno** del sistema
- Optimiza **recursos** (tiempo, código, iteraciones)

### Ejemplos en tu trabajo .Rmd

| Situación | Eficiente | Ineficiente |
|-----------|-----------|-------------|
| **Generar gráfico TikZ** | 3 iteraciones para alcanzar ≥95% similitud | 15 iteraciones para el mismo resultado |
| **Validar ejercicio** | Usar `SemilleroUnico_v2.R` que valida 4 formatos en 1 comando | Ejecutar manualmente `exams2html`, `exams2pdf`, `exams2docx`, `exams2nops` por separado |
| **Corregir error LaTeX** | Consultar `patrones-errores-conocidos.md` y aplicar solución verificada | Intentar soluciones por prueba y error durante horas |
| **Código dinámico** | Reutilizar plantilla existente de `Ejemplos-Funcionales-Rmd/` | Escribir desde cero sin consultar ejemplos |

### Fórmula mental

```
EFICIENCIA = Resultado / Recursos utilizados
```

**Ejemplo concreto:**

- Generar 1 ejercicio SCHOICE validado en **2 horas** = EFICIENTE
- Generar 1 ejercicio SCHOICE validado en **8 horas** = INEFICIENTE
- (Mismo resultado, diferentes recursos de tiempo)

---

## 2. EFICACIA (Qué se logra)

### Definición

Se centra en **QUÉ** se logra. Busca **alcanzar los objetivos propuestos**, sin importar los recursos usados.

### Características

- Enfoque en las **metas o resultados**
- Mide el **impacto o éxito externo** del trabajo
- Pregunta: ¿Se cumplió el objetivo?

### Ejemplos en tu trabajo .Rmd

| Objetivo | Eficaz | Ineficaz |
|----------|--------|----------|
| **Ejercicio renderiza en 4 formatos** | HTML ✓, PDF ✓, DOCX ✓, NOPS ✓ | HTML ✓, PDF ✗ (falla), DOCX ✓, NOPS ✗ |
| **Cumplir 6 dimensiones ICFES** | Todas las dimensiones correctamente clasificadas | Faltan metadatos de Competencia o Componente |
| **Generar 250+ versiones únicas** | 287/300 versiones únicas (95.6%) | 150/300 versiones únicas (50%) |
| **Gráfico coincide con enunciado** | Las 5 coherencias verificadas ✓ | Gráfico muestra datos diferentes al texto |

### Fórmula mental

```
EFICACIA = Objetivos logrados / Objetivos propuestos
```

**Ejemplo concreto:**

- Ejercicio con todas las coherencias validadas = EFICAZ
- Ejercicio que compila pero tiene errores matemáticos = INEFICAZ
- (No importa cuánto tiempo tomó, importa si cumple el objetivo)

---

## 3. EFECTIVIDAD (Eficiencia + Eficacia)

### Definición

Es la **combinación** de eficiencia y eficacia. Lograr los objetivos **utilizando los recursos óptimos**.

### Características

- Hacer las cosas **correctas** (eficacia)
- Hacerlas **de la manera correcta** (eficiencia)
- Maximiza **valor total** del trabajo

### Ejemplos en tu trabajo .Rmd

| Escenario | Clasificación |
|-----------|---------------|
| Ejercicio validado en 4 formatos + 5 coherencias + 2 horas de trabajo | **EFECTIVO** (eficaz + eficiente) |
| Ejercicio validado en 4 formatos + 5 coherencias + 12 horas de trabajo | Eficaz pero **INEFICIENTE** |
| Ejercicio generado en 30 minutos pero falla en PDF | Eficiente pero **INEFICAZ** |
| Ejercicio que tomó 8 horas y aún tiene errores | **NI EFICAZ NI EFICIENTE** |

### Fórmula mental

```
EFECTIVIDAD = EFICACIA × EFICIENCIA
```

---

## Aplicación Práctica: Workflow R/exams

### Flujo EFECTIVO (recomendado)

```
1. EFICACIA PRIMERO: Definir objetivo claro
   └── ¿Qué tipo de ejercicio? (SCHOICE/CLOZE)
   └── ¿Qué dimensiones ICFES?
   └── ¿Requiere gráficos? (Flujo B obligatorio)

2. EFICIENCIA EN PROCESO: Usar recursos optimizados
   └── Consultar Ejemplos-Funcionales-Rmd/ ANTES de escribir
   └── Usar plantillas existentes
   └── Aplicar patrones conocidos de errores
   └── Proceso SECUENCIAL del Graficador (TikZ→Python→R)

3. VALIDAR EFECTIVIDAD: Verificar ambas dimensiones
   └── ¿Cumple los 4 formatos? (eficacia)
   └── ¿Cumple las 5 coherencias? (eficacia)
   └── ¿Cuántas iteraciones tomó? (eficiencia)
   └── ¿Cuánto tiempo total? (eficiencia)
```

### Métricas de Efectividad para tu Trabajo

| Métrica | Objetivo Efectivo |
|---------|-------------------|
| Iteraciones TikZ | ≤5 para alcanzar ≥95% |
| Tiempo por ejercicio SCHOICE | ≤3 horas |
| Tiempo por ejercicio CLOZE | ≤4 horas |
| Tasa de éxito primer renderizado | ≥70% |
| Consultas a ejemplos funcionales | 100% antes de corregir |

---

## Resumen Final

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   EFICIENCIA = Hacer las cosas BIEN (proceso)          │
│   "Generar el ejercicio con menos iteraciones"         │
│                                                         │
│   EFICACIA = Hacer las cosas CORRECTAS (resultado)     │
│   "El ejercicio cumple TODAS las validaciones"         │
│                                                         │
│   EFECTIVIDAD = EFICIENCIA + EFICACIA                  │
│   "Ejercicio validado en tiempo óptimo"                │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Analogía Simple

| Concepto | Analogía con Flecha y Diana |
|----------|----------------------------|
| **Eficiente** | Disparar rápido con pocas flechas |
| **Eficaz** | Dar en el centro de la diana |
| **Efectivo** | Dar en el centro con pocas flechas y rápido |

---

**Fecha de creación:** 2026-01-01\
**Basado en:** Infografía de Virginio Gallardo (@Virginiog)\
**Aplicado a:** Generación de ejercicios R/exams para ICFES
