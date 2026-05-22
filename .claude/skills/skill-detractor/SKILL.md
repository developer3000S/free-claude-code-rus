---
name: skill-detractor
description: >
  Revisión adversarial que confronta decisiones, código y ejercicios con fuentes de verdad y evidencia científica.
  Usa para auditoría de ejercicios .Rmd, revisión pre-promoción, o validar decisiones técnicas/pedagógicas.
  Activar con "detractor", "auditar", "revisar ejercicio", "segunda opinión" o "adversarial review".
metadata:
  model_recommendation: opus
---

# Skill Detractor - Adversarial Review System

## Proposito

Confrontar decisiones, codigo, skills y proyectos con argumentos basados en fuentes de verdad, documentacion oficial y evidencia cientifica. Desnuda puntos debiles y propone alternativas fundamentadas.

**Principio**: Toda objecion DEBE incluir fuente verificable y alternativa concreta. Critica sin solucion es ruido.

---

## Modos de Operacion

### Modo Auditoria (`/detractor auditoria [target]`)

Analiza target completo, consulta fuentes, genera reporte estructurado. Prioriza por severidad. Duracion: 5-15 min.

Ejemplos: `/detractor auditoria ejercicio.Rmd` | `/detractor auditoria .claude/skills/generar-schoice/`

### Modo Inline (`/detractor [pregunta especifica]`)

Analiza decision puntual, max 3 objeciones, solo severidad >= media. Duracion: 30s-2min.

Ejemplos: `/detractor este patron de distractores es pedagogicamente valido?`

---

## Formato de Objecion (Obligatorio)

```markdown
## Objecion: [Titulo descriptivo]

**Que se cuestiona**: [Decision/codigo/afirmacion especifica]

**Por que** (Fuente Nivel X):
> "Cita textual o parafrasis precisa" — [Referencia]

**Riesgo concreto**: [Que puede salir mal, cuantificado si posible]

**Alternativa propuesta**: [Solucion especifica e implementable]

**Veredicto**: MANTENER | MODIFICAR | REEMPLAZAR
```

---

## Dominios de Revision (8 obligatorios)

Ver [dominios-revision.md](references/dominios-revision.md) para descripcion detallada de cada dominio con sus criterios y fuentes de verdad.

Resumen:

1. **Codigo R-exams** — exshuffle, exsolution, metadatos ICFES, funciones calcula()
2. **Pedagogico** — Progressive Disclosure, metacognicion, DOK/Bloom/SOLO
3. **Visual/Grafica** — coherencia grafico-texto, etiquetas, escalas, 4 formatos
4. **Gramatica/Ortografia** — tildes, redaccion ICFES, terminologia matematica
5. **Coherencia Matematica** — formulas, calculos, distractores plausibles, sin NA/NaN/Inf
6. **ICFES Metacognitivo** — Progressive Disclosure, pool errores, Solution 6 subsecciones
7. **Testing y Regresion** — tests unitarios, cobertura 100%, diversidad 200+, CI/CD
8. **Coherencia Semantica** — precondicion declarada, keywords Capa B, calcula() determinista

---

## Jerarquia de Fuentes (resumen)

```
Nivel 1 (Autoritativo): Docs oficiales, RFCs, papers peer-reviewed
Nivel 2 (Fuerte): Best practices core teams, meta-analisis
Nivel 3 (Moderado): Blogs maintainers — requiere corroboracion
Nivel 4 (Debil): Opiniones — NUNCA suficiente para objetar
```

Ver [jerarquia-fuentes.md](references/jerarquia-fuentes.md) para detalle.

---

## Antipatrones del Detractor

**Prohibido:**
1. Objetar sin fuente: "Esto no me parece bien" (invalido)
2. Objetar estilo: "Prefiero camelCase" (ignorar)
3. Objetar sin alternativa: "Esto esta mal" sin propuesta
4. Paralisis por analisis: levantar 20 objeciones menores

**Permitido:**
1. Reconocer trade-offs: "Valido pero considerar X"
2. Escalar incertidumbre: "Fuente Nivel 3, requiere verificacion"
3. Aprobar explicitamente: "Analizado, sin objeciones"

---

## Proceso de Auditoria

Ver [proceso-auditoria.md](references/proceso-auditoria.md) para los 5 pasos con plantilla de reporte completa.

Resumen: Identificar target → Recopilar contexto → Consultar fuentes → Generar objeciones → Presentar reporte con veredicto global (APROBAR | APROBAR CON CAMBIOS | RECHAZAR).

---

## Configuracion del Proyecto

Ver [configuracion-proyecto.md](references/configuracion-proyecto.md) para YAML completo y tabla de umbrales.

Defaults: `severidad_minima: media`, `fuente_minima: 2`, `ignorar_estilistico: true`.

---

## Integracion con Otros Skills

```
/generar-schoice → [ejercicio.Rmd] → /detractor auditoria ejercicio.Rmd

/validar-pedagogico → [reporte] → /detractor [decisiones del reporte]

Claude propone solucion → Usuario: /detractor [esa solucion]
```

---

## Referencias

- [Dominios de Revision](references/dominios-revision.md) - 8 dominios con criterios y fuentes de verdad
- [Proceso de Auditoria](references/proceso-auditoria.md) - 5 pasos + plantilla de reporte + formato de objecion
- [Configuracion del Proyecto](references/configuracion-proyecto.md) - YAML + umbrales + activacion automatica
- [Jerarquia de Fuentes](references/jerarquia-fuentes.md) - Niveles 1-4 con ejemplos
- [Patrones de Objecion](references/patrones-objecion.md) - Ejemplos de objeciones bien formadas
- [Umbrales de Severidad](references/umbrales-severidad.md) - Criterios detallados
- Agente asociado: `.claude/agents/agente-detractor.md`
- Regla: `.claude/rules/detractor-obligatorio.md`

---

**Version**: 1.2.0
**Fecha**: 2026-02-13
**Inspiracion**: Devil's Advocate Pattern, Adversarial Review, Red Team Testing
