# Regla: Routing Obligatorio de Modelos por Complejidad

## Principio Fundamental

**Claude DEBE verificar el campo `model_recommendation` de cada skill ANTES de ejecutarlo. Si el skill recomienda `sonnet` o `haiku`, Claude DEBE delegarlo a un sub-agente via Task tool con el modelo correspondiente, en vez de ejecutarlo inline en el contexto Opus.**

Esta regla NO tiene excepciones. Ejecutar tareas mecánicas en Opus desperdicia tokens sin beneficio de calidad.

---

## Mecanismo de Routing

### Paso 1: Verificar model_recommendation

Cuando se invoca un skill (via `/nombre-skill` o automáticamente), Claude DEBE:

1. Leer el campo `model_recommendation` del SKILL.md
2. Si es `opus` → Ejecutar inline (contexto actual)
3. Si es `sonnet` → Delegar via `Task(model="sonnet")`
4. Si es `haiku` → Delegar via `Task(model="haiku")`
5. Si no tiene campo → Ejecutar inline (retrocompatibilidad)

### Paso 2: Delegar via Task

Para skills `sonnet` o `haiku`, Claude DEBE:

```
Task(
  subagent_type = "general-purpose",
  model = "[sonnet|haiku]",
  prompt = "[Instrucciones completas del skill + contexto necesario]",
  description = "[nombre-skill]: [descripcion corta]"
)
```

**Contexto que debe incluir en el prompt del Task:**
- Ruta del archivo .Rmd a procesar (si aplica)
- Estado actual del workflow (si aplica)
- Resultados de fases anteriores (si aplica)
- Instrucciones específicas del skill

### Paso 3: Recibir resultado y continuar

Claude recibe el resultado del sub-agente y:
- Lo integra en el flujo principal
- Lo muestra al usuario si es relevante
- Continúa con la siguiente fase del workflow

---

## Tabla de Routing

### Opus 4.6 — Ejecutar inline (contexto principal)

| Skill | Razón |
|-------|-------|
| generar-schoice | Diseño metacognitivo complejo |
| generar-cloze | Multi-parte con tipos mixtos |
| skill-retroalimentacion | Diagnóstico pedagógico de distractores |
| analizar-icfes | Clasificación 6D + diseño estructura |
| validar-pedagogico | 3 taxonomías cognitivas + evidencia |
| skill-detractor | Revisión adversarial multi-dominio |

### Sonnet 4.5 — Delegar via Task(model="sonnet")

| Skill | Razón |
|-------|-------|
| generar-codigo-tikz | Generación de código estructurado |
| generar-codigo-python | API matplotlib conocida |
| generar-codigo-r | Patrones ggplot2 estándar |
| comparar-similitud-visual | Scoring en 6 categorías |
| refinar-codigo-grafico | Corrección iterativa dirigida |
| diagnosticar-errores | Pattern matching contra catálogo |
| corregir-graficos | Corrección ERR_G1-G4 |
| corregir-error-imagen | Corrección ERR_G1 específica |
| analizar-imagen-grafica | Extracción visual estructurada |

### Haiku 4.5 — Delegar via Task(model="haiku")

| Skill | Razón |
|-------|-------|
| validar-renderizado | Ejecutar exams2* y reportar |
| validar-diversidad | Ejecutar testthat y contar |
| validar-icfes | Verificar 6 campos fijos |
| validar-coherencia | Checklist de 5 coherencias |
| gestionar-estado-graficador | Leer/escribir JSON |
| transferir-conocimiento-grafico | Documentación simple |
| promover-ejercicio | Mover archivos + gates |

---

## Agentes: Ya Tienen Routing Nativo

Los agentes invocados via `Task(subagent_type=...)` ya usan su modelo del frontmatter:

| Agente | Modelo | Invocación |
|--------|--------|-----------|
| PedagogoICFES | opus | `Task(subagent_type="PedagogoICFES")` |
| AgenteDetractor | opus | `Task(subagent_type="AgenteDetractor")` |
| AgenteValidadorVisual | sonnet | `Task(subagent_type="AgenteValidadorVisual")` |
| AgenteDiagnosticador | sonnet | `Task(subagent_type="AgenteDiagnosticador")` |
| AgenteCorrectorCoherencia | sonnet | `Task(subagent_type="AgenteCorrectorCoherencia")` |
| ClasificadorICFES | haiku | `Task(subagent_type="ClasificadorICFES")` |

**No necesitan routing adicional** — el Task tool respeta su campo `model:`.

---

## Excepciones al Routing

### 1. Skill requiere contexto visual del padre

Si un skill necesita acceso a imágenes que ya están en el contexto principal (ej: preview PNG ya leído), mantener inline.

### 2. Skill es parte de una cadena rápida

Si ejecutar el Task añade más latencia que el ahorro en tokens (ej: skill de 5 líneas), Claude puede ejecutar inline y documentar la excepción.

### 3. Usuario solicita ejecución inline explícitamente

Si el usuario dice "ejecuta esto aquí" o "no delegues", respetar la instrucción.

---

## Patrón de Delegación (Plantilla)

```python
# Skill con model_recommendation: haiku
Task(
  subagent_type = "general-purpose",
  model = "haiku",
  description = "validar-renderizado: FASE 1",
  prompt = """
  Ejecuta la validación de renderizado para el archivo:
  {ruta_archivo}

  Instrucciones:
  1. Ejecutar exams2html("{archivo}", n = 1)
  2. Ejecutar exams2pdf("{archivo}", n = 1)
  3. Ejecutar exams2pandoc("{archivo}", n = 1, type = "docx")
  4. Ejecutar exams2nops("{archivo}", n = 1)
  5. Reportar éxito/fallo de cada formato
  6. Listar errores/warnings encontrados

  Directorio de trabajo: {directorio}
  """
)
```

---

## Verificación de Cumplimiento

Claude DEBE incluir en su razonamiento interno:

```
[Routing] Skill: validar-renderizado → model_recommendation: haiku → Delegar via Task(model="haiku")
```

o:

```
[Routing] Skill: generar-schoice → model_recommendation: opus → Ejecutar inline
```

---

## Antipatrones PROHIBIDOS

### 1. Ejecutar skill Haiku en Opus

```
❌ PROHIBIDO: /validar-diversidad ejecutado inline en Opus
   (Desperdicia ~96% del costo sin beneficio)

✓ CORRECTO: Task(model="haiku", prompt="Ejecutar validación diversidad...")
```

### 2. Delegar skill Opus a Haiku

```
❌ PROHIBIDO: Task(model="haiku", prompt="Genera ejercicio SCHOICE metacognitivo...")
   (Haiku no tiene capacidad para diseño metacognitivo complejo)

✓ CORRECTO: Ejecutar /generar-schoice inline en Opus
```

### 3. Ignorar model_recommendation

```
❌ PROHIBIDO: No verificar model_recommendation antes de ejecutar
✓ CORRECTO: Siempre verificar y aplicar routing
```

---

**Versión**: 1.0
**Fecha**: 2026-02-14
**Estado**: ACTIVO Y OBLIGATORIO
**Excepciones**: Ver sección "Excepciones al Routing"
