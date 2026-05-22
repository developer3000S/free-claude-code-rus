# Routing de Modelos por Componente

## Principio

Asignar el modelo de menor costo que mantenga la calidad requerida para cada tarea.
Los model IDs actuales son:

| Modelo | ID | Costo relativo | Uso |
|--------|----|-----------------|-----|
| Opus 4.6 | `claude-opus-4-6` | 1.00x (base) | Razonamiento profundo, generacion creativa, adversarial |
| Sonnet 4.5 | `claude-sonnet-4-5-20250929` | ~0.20x | Codigo estructurado, correccion dirigida, comparacion |
| Haiku 4.5 | `claude-haiku-4-5-20251001` | ~0.04x | Validacion mecanica, estado, clasificacion taxonomica |

---

## Agentes (model: en frontmatter)

| Agente | Modelo | Justificacion |
|--------|--------|---------------|
| **PedagogoICFES** | `claude-opus-4-6` | 3 taxonomias cognitivas simultaneas + evidencia cientifica |
| **AgenteDetractor** | `claude-opus-4-6` | Revision adversarial en 8 dominios cruzando fuentes de verdad |
| **AgenteValidadorVisual** | `claude-sonnet-4-5-20250929` | Inspeccion visual estructurada con checklist |
| **AgenteDiagnosticador** | `claude-sonnet-4-5-20250929` | Clasificacion de errores contra catalogo conocido |
| **AgenteCorrectorCoherencia** | `claude-sonnet-4-5-20250929` | Verificacion de 5 coherencias contra reglas fijas |
| **ClasificadorICFES** | `claude-haiku-4-5-20251001` | Clasificacion en 6 dimensiones con taxonomia fija |

---

## Skills (model_recommendation en metadata)

### Opus 4.6 (razonamiento profundo)

| Skill | Justificacion |
|-------|---------------|
| **generar-schoice** | Diseno metacognitivo + Progressive Disclosure + pool errores + contextos narrativos + codigo R-exams complejo |
| **generar-cloze** | Multi-parte (4+) con tipos mixtos + todo lo anterior |
| **skill-retroalimentacion** | Diagnostico pedagogico de cada distractor con patron ICFES |
| **analizar-icfes** | Clasificacion 6D + decision Flujo A/B + diseno estructura metacognitiva |
| **validar-pedagogico** | 3 taxonomias cognitivas + evidencia cientifica |
| **skill-detractor** | Revision adversarial multi-dominio con fuentes verificables |

### Sonnet 4.5 (codigo estructurado)

| Skill | Justificacion |
|-------|---------------|
| **generar-codigo-tikz** | Generacion TikZ — API knowledge, patrones conocidos |
| **generar-codigo-python** | Generacion matplotlib — mecanico pero requiere API |
| **generar-codigo-r** | Generacion ggplot2 — patrones estandar |
| **comparar-similitud-visual** | Comparacion estructurada con scoring en 6 categorias |
| **refinar-codigo-grafico** | Iteracion basada en diferencias detectadas |
| **diagnosticar-errores** | Clasificacion contra catalogo de patrones conocidos |
| **corregir-graficos** | Correccion iterativa ERR_G1-G4 |
| **corregir-error-imagen** | Correccion especifica ERR_G1 (include_tikz) |
| **analizar-imagen-grafica** | Extraccion de informacion visual estructurada |

### Haiku 4.5 (validacion mecanica)

| Skill | Justificacion |
|-------|---------------|
| **validar-renderizado** | Ejecuta 4 comandos exams2* y reporta exito/fallo |
| **validar-diversidad** | Ejecuta testthat y reporta conteo numerico |
| **validar-icfes** | Verifica 6 campos contra lista fija |
| **validar-coherencia** | Checklist de 5 coherencias contra reglas |
| **gestionar-estado-graficador** | Lee/escribe JSON de estado |
| **transferir-conocimiento-grafico** | Documentacion de lecciones |
| **promover-ejercicio** | Mover archivos + verificar gates |

---

## Hooks (scripts Bash — no usan modelo)

Los hooks son scripts shell que ejecutan comandos R/magick directamente.
No consumen tokens de modelo.

| Hook | Ejecuta | Modelo |
|------|---------|--------|
| pre-write-rmd-gate.sh | bash + jq (gate ejercicio_state.json) | N/A |
| post-exams2-validation.sh | Rscript + magick | N/A |
| pre-commit-ortografia.sh | Rscript ortografia (git hook nativo) | N/A |

---

## Commands (invocacion manual — contexto principal)

Los commands se ejecutan en el contexto principal de la conversacion.
El modelo depende de como el usuario configura su sesion.

Cuando un command delega trabajo a un agente via Task tool,
el agente usa su propio modelo especificado en frontmatter.

---

## Como Aplicar en la Practica

### Cuando Claude (Opus) ejecuta el workflow principal:

1. **Tareas de generacion** (generar-schoice, generar-cloze): Se ejecutan en el contexto principal (Opus). Esto es correcto — requieren maxima calidad.

2. **Delegacion a agentes**: Cuando se necesita clasificar, diagnosticar o validar visualmente, usar `Task` con `subagent_type` apropiado. El agente usara su modelo asignado:
   ```
   Task(subagent_type="ClasificadorICFES") → Haiku 4.5
   Task(subagent_type="AgenteDiagnosticador") → Sonnet 4.5
   Task(subagent_type="AgenteDetractor") → Opus 4.6
   ```

3. **Validaciones mecanicas**: Delegar a agentes Haiku cuando sea posible en lugar de ejecutar en el contexto principal Opus.

### Ahorro estimado por workflow completo:

| Fase | Antes (todo Opus) | Despues (routing) | Ahorro |
|------|-------------------|-------------------|--------|
| Analisis ICFES | Opus | Opus | 0% |
| Clasificacion | Opus (heredado) | Haiku (agente) | ~96% |
| Generacion .Rmd | Opus | Opus | 0% |
| Retroalimentacion | Opus | Opus | 0% |
| Validacion render | Opus | Haiku (delegable) | ~96% |
| Validacion visual | Opus (heredado) | Sonnet (agente) | ~80% |
| Diagnostico | Opus (heredado) | Sonnet (agente) | ~80% |
| Correccion coherencia | Opus (heredado) | Sonnet (agente) | ~80% |
| Detractor | Opus (heredado) | Opus (agente) | 0% |
| Estado graficador | Opus | Haiku (delegable) | ~96% |

**Estimacion global**: 50-60% reduccion en costo de tokens.

---

**Version**: 1.0
**Fecha**: 2026-02-14
