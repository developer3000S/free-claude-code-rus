# Hooks de Automatización - Claude Code

Este directorio contiene la documentación de hooks que se activan automáticamente
durante el workflow de generación de ejercicios R/exams.

## ¿Qué son los Hooks?

Los hooks son puntos de activación automática que ejecutan validaciones o acciones
específicas cuando ocurren ciertos eventos en el workflow.

## Hooks Implementados

### 1. PostToolUse(exams2*)

**Evento**: Después de ejecutar cualquier función exams2* (exams2html, exams2pdf, etc.)

**Acción automática**:

1. Capturar resultado de la compilación
2. Si hay error → Activar `diagnosticar-errores`
3. Si éxito → Sugerir inspección visual
4. Registrar resultado en log

**Implementación conceptual**:
```
Cuando: Usuario ejecuta exams2html/exams2pdf/exams2pandoc/exams2nops
Entonces:

  - Capturar output y errores
  - Si error detectado:
      Activar skill: diagnosticar-errores
      Clasificar error
      Sugerir corrección

  - Si éxito:
      Confirmar al usuario
      Sugerir: "Verificar visualmente el output generado"
```

### 2. PreToolUse(str-replace-editor) para .Rmd

**Evento**: Antes de editar un archivo .Rmd con str-replace-editor

**Acción automática**:

1. Verificar coherencia del código a insertar
2. Detectar patrones problemáticos conocidos
3. Advertir si hay errores potenciales

**Patrones a detectar**:

- `abs(.*formateado)` → Advertir sobre Error #2
- `include_tikz` en chunk de generación → Advertir sobre Error #1
- Variables hardcodeadas en TikZ → Sugerir sincronización

**Implementación conceptual**:
```
Cuando: Usuario va a editar archivo .Rmd
Antes de editar:

  - Analizar código nuevo a insertar
  - Buscar patrones problemáticos
  - Si patrón detectado:
      Advertir: "Posible error: [descripción]"
      Sugerir: "Ver .claude/docs/patrones-errores-conocidos.md"

  - Si todo OK:
      Proceder con edición
```

### 3. PostError(LaTeX|TikZ|Python)

**Evento**: Cuando se detecta un error de compilación LaTeX, TikZ o Python

**Acción automática**:

1. Capturar mensaje de error
2. Clasificar según patrones conocidos
3. Activar diagnóstico automático
4. Sugerir corrección específica

**Patrones manejados**:
| Patrón | Categoría | Acción |
|--------|-----------|--------|
| `File '*.png' not found` | ERR_G1 | Sugerir renderizado condicional |
| `LaTeX failed to compile` | ERR_T1 | Verificar sintaxis |
| `non-numeric argument` | ERR_C3 | Revisar funciones sobre strings |
| `undefined control sequence` | ERR_T1 | Verificar paquetes LaTeX |

**Implementación conceptual**:
```
Cuando: Error de LaTeX/TikZ/Python detectado
Entonces:

  - Capturar mensaje completo
  - Buscar patrón en base de conocimiento
  - Si patrón conocido:
      Mostrar diagnóstico
      Mostrar solución verificada
      Ofrecer aplicar corrección automática

  - Si patrón desconocido:
      Solicitar análisis manual
      Sugerir documentar si se resuelve
```

## Integración con Workflow

```
┌─────────────────────────────────────────┐
│            WORKFLOW R/EXAMS             │
├─────────────────────────────────────────┤
│                                         │
│  Edición .Rmd                           │
│      ↓                                  │
│  [Hook: PreToolUse] ← Validar antes     │
│      ↓                                  │
│  Renderizado exams2*                    │
│      ↓                                  │
│  [Hook: PostToolUse] ← Capturar result  │
│      ↓                                  │
│  ¿Error?                                │
│    Sí → [Hook: PostError] ← Diagnosticar│
│    No → Continuar                       │
│                                         │
└─────────────────────────────────────────┘
```

## Notas de Implementación

Los hooks en Claude Code son conceptuales - se implementan como patrones de
comportamiento que el agente sigue automáticamente cuando detecta los eventos
correspondientes.

Para activar este comportamiento:

1. El agente debe monitorear outputs de comandos R
2. Detectar patrones de error conocidos
3. Activar skills/commands según el diagrama de flujo

## Referencias

- `.claude/Mermaid_Chart.txt` - Diagrama de flujo completo
- `.claude/docs/patrones-errores-conocidos.md` - Base de errores
- `.claude/skills/` - Skills de corrección
- `.claude/agents/` - Agentes especializados

