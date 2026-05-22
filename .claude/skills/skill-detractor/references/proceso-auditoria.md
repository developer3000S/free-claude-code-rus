# Proceso de Auditoria — Detractor

## Paso 1: Identificar Target

```
Analizar: [ruta/nombre del target]
Tipo: [skill | codigo | proyecto | seccion | ejercicio.Rmd]
Dominio: [flutter | supabase | r-exams | otro]
```

## Paso 2: Recopilar Contexto

- Leer archivos relevantes (SKILL.md, .Rmd, scripts)
- Identificar decisiones clave (distractores, metadatos, estructura)
- Mapear dependencias (reglas que aplican, ejemplos funcionales de referencia)

## Paso 3: Consultar Fuentes

- Context7 para documentacion tecnica
- WebSearch para evidencia cientifica
- Archivos locales de referencia (`.claude/rules/`, `A-Produccion/Ejemplos-Funcionales-Rmd/`)

## Paso 4: Generar Objeciones

Para cada decision cuestionable:

1. Verificar que existe fuente Nivel 1-2
2. Cuantificar riesgo si es posible
3. Formular alternativa concreta
4. Asignar veredicto (MANTENER | MODIFICAR | REEMPLAZAR)

## Paso 5: Presentar Reporte

```markdown
# Auditoria Detractor: [Target]

**Fecha**: YYYY-MM-DD
**Alcance**: [descripcion del target]
**Objeciones**: N (X criticas, Y altas, Z medias)

## Resumen Ejecutivo

[Parrafo con hallazgos principales]

## Objeciones

[Lista ordenada por severidad — usar formato de objecion estandar]

## Veredicto Global

**Estado**: APROBAR | APROBAR CON CAMBIOS | RECHAZAR
**Justificacion**: [1-2 oraciones]

## Proximos Pasos

1. [Accion prioritaria]
2. [Accion secundaria]
```

## Formato de Objecion (Obligatorio)

```markdown
## Objecion: [Titulo descriptivo]

**Que se cuestiona**: [Decision/codigo/afirmacion especifica]

**Por que** (Fuente Nivel X):
> "Cita textual o parafrasis precisa" — [Enlace/Referencia]

**Riesgo concreto**: [Que puede salir mal, cuantificado si posible]

**Alternativa propuesta**:
[Solucion especifica e implementable]

**Veredicto**: MANTENER | MODIFICAR | REEMPLAZAR
```

## Dominios de Conocimiento Adicionales

Para proyectos no-ICFES, el detractor tiene expertise en:

- Flutter/Dart (documentacion oficial, effective dart)
- Supabase (docs, RFCs, patterns)
- Arquitectura (clean, DDD, SOLID)
- Testing (TDD, property-based)
- Seguridad (OWASP)
- Performance (benchmarks)
- Accesibilidad (WCAG)
