# Regla: Detractor Obligatorio en Fases de Revisión

## Principio Fundamental

**El skill-detractor DEBE invocarse AUTOMÁTICAMENTE en toda fase de revisión (visual, código, gramática, etc.). NO hay excepciones.**

El detractor actúa como revisor adversarial que confronta decisiones con fuentes de verdad, documentación oficial y evidencia científica.

---

## Puntos de Activación Obligatoria

### 1. FASE 2C: Revisión Detractor (Nuevo)

**Se ejecuta DESPUÉS de FASE 2A (matemática) y FASE 2B (visual)**

```
FASE 2A: Validación matemática [AUTOMÁTICA]
    ↓
FASE 2B: Preview visual [AUTOMÁTICA]
    ↓
FASE 2C: Revisión Detractor [OBLIGATORIA]
    ↓
FASE 3: Decisión y aprobación usuario
```

### 2. Durante Generación de Ejercicios

```
/generar-schoice o /generar-cloze
    ↓
[Ejercicio generado]
    ↓
OBLIGATORIO: /detractor auditoria [archivo.Rmd]
    ↓
[Corregir objeciones si existen]
    ↓
Ciclo de validación (FASE 1-2-3)
```

### 3. Pre-Promoción de Ejercicios

```
/promover-ejercicio
    ↓
OBLIGATORIO: /detractor auditoria [directorio_ejercicio/]
    ↓
Veredicto: APROBAR → Continuar promoción
Veredicto: MODIFICAR/RECHAZAR → Bloquear promoción
```

---

## Dominios de Revisión del Detractor

### 1. Revisión de Código (.Rmd)

**Qué revisa:**
- Coherencia de código R-exams
- Uso correcto de exshuffle, exsolution, extype
- Distractores basados en errores conceptuales (no aleatorios)
- Metadatos ICFES completos (6 dimensiones)
- Metadatos cognitivos (DOK, Bloom, SOLO)
- Pool de errores con funciones calcula()

**Fuentes de verdad:**
- Documentación R-exams (Nivel 1)
- Ejemplos funcionales locales (Nivel 1)
- Vignettes CRAN (Nivel 1)

### 2. Revisión Pedagógica

**Qué revisa:**
- Aplicación de Progressive Disclosure
- Estructura metacognitiva correcta
- Reflexiones pedagógicas apropiadas
- Nivel de dificultad coherente con metadatos
- Distractores diagnosticables

**Fuentes de verdad:**
- Marco Conceptual ICFES 2026 (Nivel 1)
- Dunlosky et al. (2013) Learning techniques (Nivel 1)
- Schraw & Dennison (1994) Metacognition (Nivel 1)
- Anderson & Krathwohl (2001) Bloom revisado (Nivel 1)

### 3. Revisión Visual/Gráfica

**Qué revisa:**
- Coherencia visual-texto (gráfico vs enunciado)
- Etiquetas legibles y correctas
- Escalas y proporciones apropiadas
- Compatibilidad con 4 formatos de salida

**Fuentes de verdad:**
- Estándares visuales ICFES (Nivel 1)
- Documentación TikZ/pgfplots (Nivel 1)
- Buenas prácticas de visualización (Nivel 2)

### 4. Revisión Gramatical/Ortográfica

**Qué revisa:**
- Tildes en palabras frecuentes
- Gramática española correcta
- Redacción estilo ICFES
- Terminología matemática apropiada

**Fuentes de verdad:**
- RAE (Nivel 1)
- Diccionario local `.claude/rules/ortografia-espanol.md` (Nivel 1)

### 5. Coherencia Matemática

**Qué revisa:**
- Fórmulas y ecuaciones correctas
- Cálculos verificables paso a paso
- Proporciones y escalas correctas
- Respuesta correcta matemáticamente válida
- Distractores plausibles pero incorrectos (no absurdos)
- Consistencia entre datos del enunciado y opciones
- Variables sin NA/NaN/Inf

**Fuentes de verdad:**
- Definiciones matemáticas estándar (Nivel 1)
- Wolfram Alpha / verificación simbólica (Nivel 1)
- `.claude/scripts/validar_coherencia_matematica.R` (Nivel 1)

### 6. Coherencia ICFES Metacognitiva

**Qué revisa:**
- Aplicación de Progressive Disclosure (4+ partes en CLOZE)
- Pool de errores conceptuales con códigos y funciones `calcula()`
- Metadatos cognitivos completos (DOK ≥ 2, Bloom, SOLO)
- Sección Solution con 6 subsecciones obligatorias:
  - Análisis del error
  - Procedimiento correcto
  - Propiedades del concepto
  - Caso específico
  - Reflexión metacognitiva
  - Estrategia para evitar el error
- Antipatrón detectado: ejercicio puramente procedimental
- Distractores basados en errores conceptuales reales (no aleatorios)

**Fuentes de verdad:**
- `.claude/rules/ejercicios-metacognitivos.md` (Nivel 1)
- Marco Conceptual ICFES 2026 (Nivel 1)
- Dunlosky et al. (2013) - Learning techniques (Nivel 1)
- Schraw & Dennison (1994) - Metacognitive awareness (Nivel 1)
- Anderson & Krathwohl (2001) - Bloom revisado (Nivel 1)

### 7. Testing y Regresión

**Qué revisa:**
- Tests unitarios existen para componentes críticos
- Cobertura de tests ≥ 100% para scripts de validación
- Tests de diversidad (200+ versiones únicas)
- Sin regresiones en funcionalidad existente
- Git hooks nativos configurados (pre-commit, pre-push)
- CI/CD activo y pasando

**Fuentes de verdad:**
- `tests/testthat/` (Nivel 1)
- `.claude/rules/testing-obligatorio.md` (Nivel 1)
- `.git/hooks/pre-commit`, `.git/hooks/pre-push` (Nivel 1)
- `.github/workflows/ci-testing.yml` (Nivel 1)

### 8. Coherencia Semántica (Nivel 4)

**Qué revisa:**
- Campo `precondicion` declarado en cada error del pool conceptual (Capa A)
- Descripciones de errores coherentes con datos generados — keyword scanner automático (Capa B)
- `calcula()` produce valor diferente al correcto — cross-validación (Capa C)
- 21 reglas de keywords cubren: paridad, modalidad, cuartiles, outliers, simetría, tipo de datos, tamaño de muestra
- Errores `ERR_SEM_A/B/C` (bloqueantes) y `WARN_SEM_B` (bugs latentes)
- Patrón de selección genérico basado en `precondicion` (no filtros hardcoded)

**Fuentes de verdad:**
- `.claude/scripts/validar_coherencia_matematica.R` — `REGLAS_SEMANTICAS_KEYWORDS` (Nivel 1)
- `.claude/rules/ejercicios-metacognitivos.md` — sección "Validación Semántica Automática" (Nivel 1)
- `.claude/rules/codigo-rmd.md` — regla #8 (Nivel 1)
- `tests/testthat/test_validacion_semantica.R` (Nivel 1)

---

## Formato de Revisión Detractor

### Reporte Estructurado (FASE 2C)

```markdown
## Revisión Detractor - [Nombre Ejercicio]

**Fecha**: YYYY-MM-DD
**Dominios revisados**: [código | pedagógico | visual | gramática | matemático | metacognitivo | testing | semántico]

### Objeciones Encontradas

#### [Si hay objeciones]

**Objeción 1: [Título]**
- **Qué se cuestiona**: [código/decisión específica]
- **Por qué** (Fuente Nivel X): "[Cita]" — [Referencia]
- **Riesgo concreto**: [descripción cuantificada si posible]
- **Alternativa propuesta**: [solución específica]
- **Veredicto**: MANTENER | MODIFICAR | REEMPLAZAR

#### [Si no hay objeciones]

✅ **Sin objeciones**

Dominios analizados:
- Código R-exams: Conforme
- Estructura pedagógica: Conforme
- Coherencia visual: Conforme
- Gramática/ortografía: Conforme
- Coherencia matemática: Conforme
- ICFES metacognitivo: Conforme
- Testing/regresión: Conforme

### Veredicto Global

**Estado**: APROBAR | APROBAR CON CAMBIOS | RECHAZAR

### Próximos Pasos

1. [Acción si hay cambios requeridos]
2. [O continuar a FASE 3 si aprobado]
```

---

## Umbrales de Activación

```yaml
defaults:
  severidad_minima: media      # Solo reportar media, alta, crítica
  fuente_minima: 2             # Nivel 1-2 requerido
  max_objeciones: 10           # Priorizar las más importantes
  ignorar_estilistico: true    # No objetar preferencias de estilo
```

### Severidades y Acciones

| Nivel | Criterio | Acción |
|-------|----------|--------|
| Crítica | Errores matemáticos, pérdida de coherencia | BLOQUEAR, corregir inmediatamente |
| Alta | Distractores inválidos, metadatos faltantes | Priorizar corrección |
| Media | Optimizaciones pedagógicas, mejoras menores | Agregar a backlog |
| Baja | Estilo, convenciones menores | Ignorar (delegar a linter) |

---

## Bloqueos Automáticos

### 1. Bloqueo Pre-Promoción

```
SI /detractor reporta objeciones CRÍTICAS o ALTAS:
    BLOQUEAR /promover-ejercicio
    MOSTRAR objeciones
    REQUERIR corrección antes de continuar
```

### 2. Bloqueo Post-Generación

```
SI /detractor reporta veredicto RECHAZAR:
    MARCAR ejercicio como "requiere revisión"
    NO avanzar a ciclo de validación
    REQUERIR reescritura
```

---

## Integración con Otros Skills

### Con /validar-pedagogico

```
/validar-pedagogico genera reporte
    ↓
/detractor valida las decisiones del reporte
    ↓
Confronta recomendaciones con evidencia científica
```

### Con /generar-schoice y /generar-cloze

```
[Ejercicio generado]
    ↓
/detractor auditoria automática (OBLIGATORIO)
    ↓
Reporta objeciones sobre:
- Estructura metacognitiva
- Pool de errores
- Metadatos cognitivos
- Formato Solution
```

### Con Ciclo de Validación

```
FASE 1: Renderizado
FASE 2A: Validación matemática [hook]
FASE 2B: Preview visual [hook]
FASE 2C: Revisión Detractor [OBLIGATORIO] ← NUEVO
FASE 3: Decisión usuario
```

---

## Invocación Manual vs Automática

### Automática (OBLIGATORIA)

Se invoca automáticamente en:

1. **Post-generación** de cualquier .Rmd
2. **FASE 2C** del ciclo de validación
3. **Pre-promoción** de ejercicios
4. **Post-validación pedagógica**

### Manual (Opcional)

El usuario puede invocar directamente:

```
/detractor auditoria [target]
/detractor [pregunta específica]
```

---

## Antipatrones PROHIBIDOS

### 1. Omitir FASE 2C

```
❌ PROHIBIDO
FASE 2A → FASE 2B → FASE 3 (saltando detractor)

✓ CORRECTO
FASE 2A → FASE 2B → FASE 2C (detractor) → FASE 3
```

### 2. Ignorar Objeciones Críticas/Altas

```
❌ PROHIBIDO
Detractor reporta objeción ALTA → Continuar sin corregir

✓ CORRECTO
Detractor reporta objeción ALTA → Corregir → Re-auditar
```

### 3. Promoción sin Auditoría

```
❌ PROHIBIDO
/promover-ejercicio sin /detractor previo

✓ CORRECTO
/detractor auditoria [ejercicio] → APROBAR → /promover-ejercicio
```

---

## Configuración Proyecto

Archivo `.claude/detractor-config.yaml`:

```yaml
# Activación automática
activacion:
  post_generacion: true       # Después de /generar-*
  fase_2c: true               # En ciclo de validación
  pre_promocion: true         # Antes de /promover-ejercicio
  post_validacion_pedagogico: true

# Umbrales
umbrales:
  severidad_minima: media
  fuente_minima: 2
  max_objeciones: 10

# Dominios obligatorios a revisar (8 dominios)
dominios_obligatorios:
  - codigo_rexams
  - pedagogico
  - visual
  - gramatica
  - coherencia_matematica
  - icfes_metacognitivo
  - testing

# Fuentes de verdad locales
fuentes_locales:
  - .claude/rules/
  - .claude/docs/
  - A-Produccion/Ejemplos-Funcionales-Rmd/

# Bloqueos
bloqueos:
  critica: true               # Bloquear si hay objeciones críticas
  alta: true                  # Bloquear si hay objeciones altas
  media: false                # No bloquear, solo reportar
```

---

## Flujo Completo con Detractor

```
┌─────────────────────────────────────────────────────────┐
│  WORKFLOW COMPLETO CON DETRACTOR OBLIGATORIO            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. /generar-schoice o /generar-cloze                  │
│     ↓                                                   │
│  2. [Ejercicio.Rmd generado]                           │
│     ↓                                                   │
│  3. /detractor auditoria [Ejercicio.Rmd] ← OBLIGATORIO │
│     │                                                   │
│     ├── Objeciones CRÍTICAS/ALTAS → Corregir → (3)     │
│     │                                                   │
│     └── APROBAR → Continuar                            │
│     ↓                                                   │
│  4. FASE 1: Renderizado (HTML/PDF/DOCX/NOPS)           │
│     ↓                                                   │
│  5. FASE 2A: Validación matemática [hook automático]   │
│     ↓                                                   │
│  6. FASE 2B: Preview visual [hook automático]          │
│     ↓                                                   │
│  7. FASE 2C: Revisión Detractor ← OBLIGATORIO          │
│     │                                                   │
│     ├── Objeciones → Corregir → VOLVER A (4)           │
│     │                                                   │
│     └── APROBAR → Continuar                            │
│     ↓                                                   │
│  8. FASE 3: Documentar 5 coherencias + Pedir aprobacion│
│     ↓                                                   │
│  9. Usuario aprueba → Ejercicio "LISTO PARA AULA"      │
│     → Permanece en 02-En-Desarrollo/                   │
│     ↓                                                   │
│  10. NIVEL 3: Aplicar en aula con estudiantes           │
│     ↓                                                   │
│  11. /promover-ejercicio (requiere evidencia Nivel 3)   │
│      → Mover a 03-En-Produccion/ ✅                    │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Garantías del Sistema

Con el detractor obligatorio:

1. ✅ **Toda decisión es confrontada** con fuentes de verdad
2. ✅ **Errores conceptuales** son detectados antes de promoción
3. ✅ **Sesgo de confirmación** es eliminado
4. ✅ **Calidad pedagógica** es validada científicamente
5. ✅ **Código R-exams** cumple estándares oficiales
6. ✅ **Coherencias** son verificadas por segunda opinión

---

**Versión**: 1.1
**Fecha**: 2026-02-07
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: NINGUNA
**Skill asociado**: `.claude/skills/skill-detractor/SKILL.md`
**Agente asociado**: `.claude/agents/agente-detractor.md`

### Cambios v1.1 (2026-02-07)
- **3 nuevos dominios agregados**: coherencia matemática, ICFES metacognitivo, testing
- **8 dominios totales** de revisión adversarial obligatoria
- **Fuentes de verdad** documentadas para cada nuevo dominio
- **Integración** con testing-obligatorio.md y ejercicios-metacognitivos.md
