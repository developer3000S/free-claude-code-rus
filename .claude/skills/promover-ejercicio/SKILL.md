---
name: promover-ejercicio
description: Mueve un ejercicio a 03-En-Produccion/ SOLO después de validación en aula con estudiantes reales (Nivel 3). Es el ÚLTIMO paso del workflow.
metadata:
  model_recommendation: haiku
---

> **ROUTING**: Este skill tiene `model_recommendation: haiku`. Claude DEBE delegarlo via `Task(subagent_type="general-purpose", model="haiku")` pasando las instrucciones completas y la ruta del directorio del ejercicio como contexto. Ver regla `.claude/rules/modelo-routing-obligatorio.md`.

# Promover Ejercicio a Produccion

## ⚡ CONTEXTO: ÚLTIMO PASO del Workflow

Este skill es el **paso final** del flujo de trabajo completo. Se ejecuta **SOLO** despues de que el ejercicio ha sido probado con estudiantes reales en el aula (Nivel 3: Terreno).

```
🔄 Niveles 1+2: Validacion automatica (RStudio + Scripts) ✅
    │
    ▼
📋 Ejercicio queda en 02-En-Desarrollo/ como "Listo para Aula"
    │
    ▼
🎓 Nivel 3: Validacion en Terreno (estudiantes reales) ✅
    │
    ▼
🚀 /promover-ejercicio ← ESTE SKILL (ÚLTIMO PASO)
```

Mueve un archivo .Rmd desde su ubicacion actual a `/A-Produccion/03-En-Produccion/[categoria ICFES]/`
**SOLO** despues de confirmar validacion con estudiantes.

## Parametros de entrada

- **$ARGUMENTS**: Nombre del archivo .Rmd a promover

## ⛔ PRERREQUISITOS OBLIGATORIOS (TODOS)

### Nivel 1+2: Validacion Automatica (ya completada)

1. ✅ FASE 1: Renderizado exitoso en 4 formatos (HTML, PDF, DOCX, NOPS)
2. ✅ FASE 2: Coherencias verificadas (matematica, visual-texto, codigo, semantica, general)
3. ✅ FASE 3: Sin errores pendientes
4. ✅ Diversidad: 200+ versiones unicas de 300 intentos
5. ✅ Detractor: Auditoria aprobada

### Nivel 3: Validacion en Terreno (OBLIGATORIO NUEVO)

6. ✅ **Aplicado en aula** con estudiantes reales
7. ✅ **Tasa de acierto razonable** (entre 25% y 95%)
8. ✅ **Sin ambiguedades** reportadas por estudiantes
9. ✅ **Tiempo de resolucion** apropiado (5-10 min)
10. ✅ **Feedback** recopilado y documentado

**⛔ SIN EVIDENCIA DE NIVEL 3, LA PROMOCION ESTA BLOQUEADA.**

## Proceso de promocion

### Paso 1: Confirmar evidencia de Nivel 3

Claude DEBE preguntar al usuario:

```markdown
## Verificacion de Nivel 3 (Terreno)

Antes de promover, confirme:

1. ¿Este ejercicio fue aplicado en aula con estudiantes? [Si/No]
2. ¿Cual fue la tasa de acierto aproximada? [___%]
3. ¿Hubo preguntas frecuentes o ambiguedades? [Si/No - Descripcion]
4. ¿El tiempo de resolucion fue razonable? [Si/No]
5. ¿Algun feedback relevante de estudiantes? [Texto libre]
```

**Si alguna respuesta indica problemas → BLOQUEAR promocion → Corregir primero.**

### Paso 2: Verificar ubicacion actual
```bash
ls -la [ruta_actual]/[nombre].Rmd
```

### Paso 3: Mover archivo a categoria ICFES correspondiente
```bash
mv [ruta_actual]/[nombre].Rmd A-Produccion/03-En-Produccion/[categoria-ICFES]/[nombre].Rmd
```

### Paso 4: Confirmar movimiento
```bash
ls -la A-Produccion/03-En-Produccion/[categoria-ICFES]/[nombre].Rmd
```

### Paso 5: Registrar evidencia de validacion en terreno
Agregar entrada con:

- Nombre del ejercicio
- Fecha de promocion
- Fecha de aplicacion en aula
- Tasa de acierto observada
- Feedback resumido
- Competencia y nivel
- Tipo de ejercicio

## Ejemplo de uso

```
/promover-ejercicio probabilidad_aleatorio_interpretacion_n2_v1.Rmd
```

## ⛔ CONDICIONES CRITICAS (NO NEGOCIABLES)

1. ❌ **NUNCA promover** sin validacion en aula (Nivel 3)
2. ❌ **NUNCA promover** con errores pendientes de Nivel 1+2
3. ❌ **NUNCA promover** sin evidencia de feedback estudiantil
4. ✓ **SIEMPRE** preguntar por evidencia de Nivel 3 antes de mover
5. ✓ **SIEMPRE** registrar datos de la validacion en terreno
6. ✓ El ejercicio debe haber pasado los 3 Niveles de Validacion

## Regla de Oro
**`03-En-Produccion/` solo contiene ejercicios probados con estudiantes reales.** Ningun ejercicio llega ahi solo por pasar validacion automatica.

## Referencias

- `.claude/docs/TRES_NIVELES_VALIDACION.md`
- `/A-Produccion/Ejemplos-Funcionales-Rmd/` (fuente de verdad)
- `.claude/rules/ciclo-validacion.md`

