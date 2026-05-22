# 📚 Commands vs Skills en Claude Code

**Guía para entender la diferencia entre Slash Commands y Agent Skills**

---

## 🎯 CONCEPTOS CLAVE

Claude Code ofrece **DOS formas complementarias** de extender su funcionalidad:

1. **Slash Commands** (`.claude/commands/`)
2. **Agent Skills** (`.claude/skills/`)

**IMPORTANTE:** Ambos **DEBEN COEXISTIR** - no son alternativas, son complementos.

---

## 📁 Slash Commands (`.claude/commands/`)

### ¿Qué son?

Comandos que el **usuario invoca explícitamente** escribiendo `/nombre-comando`.

### Características

- ✅ **Invocación manual**: Usuario escribe `/comando`
- ✅ **Archivo simple**: Un archivo `.md` por comando
- ✅ **Prompts rápidos**: Ideales para tareas repetitivas
- ✅ **Control total**: Usuario decide cuándo ejecutar

### Estructura

```
.claude/commands/
├── analizar-icfes.md
├── generar-schoice.md
├── generar-cloze.md
├── promover-ejercicio.md
└── corregir-error-imagen.md
```

### Ejemplo de uso

```bash
# Usuario escribe:
/analizar-icfes imagen.png

# Claude ejecuta el comando con la imagen
```

### ¿Cuándo usar Slash Commands?

✅ Prompts que usas frecuentemente  
✅ Cuando quieres control explícito de ejecución  
✅ Tareas simples que caben en un archivo  
✅ Templates o plantillas predefinidas  

---

## 🤖 Agent Skills (`.claude/skills/`)

### ¿Qué son?

Capacidades que **Claude invoca automáticamente** según el contexto de la conversación.

### Características

- ✅ **Invocación automática**: Claude decide cuándo usar
- ✅ **Estructura organizada**: Directorio con múltiples archivos
- ✅ **Workflows complejos**: Para procesos de múltiples pasos
- ✅ **Contextual**: Basado en la descripción del skill

### Estructura

```
.claude/skills/
├── analizar-icfes/
│   └── skill.md
├── generar-schoice/
│   └── skill.md
├── corregir-error-imagen/
│   └── skill.md
├── validar-diversidad/
│   └── skill.md
└── validar-icfes/
    └── skill.md
```

### Ejemplo de uso

```bash
# Usuario escribe:
Analiza esta imagen de ejercicio ICFES

# Claude automáticamente detecta y usa el skill "analizar-icfes"
# basándose en la descripción del skill
```

### ¿Cuándo usar Agent Skills?

✅ Workflows automáticos y contextuales  
✅ Procesos complejos de múltiples pasos  
✅ Cuando necesitas scripts o archivos auxiliares  
✅ Para que Claude "descubra" capacidades automáticamente  

---

## 🔄 ¿Por qué ambos coexisten en este proyecto?

### Dual-Mode Design

Cada funcionalidad del workflow ICFES existe en **AMBOS formatos**:

| Funcionalidad | Slash Command | Agent Skill | Razón |
|---------------|---------------|-------------|-------|
| Analizar ICFES | `/analizar-icfes` | `analizar-icfes/` | Manual O automático |
| Generar SCHOICE | `/generar-schoice` | `generar-schoice/` | Manual O automático |
| Generar CLOZE | `/generar-cloze` | `generar-cloze/` | Manual O automático |
| Promover | `/promover-ejercicio` | `promover-ejercicio/` | Manual O automático |
| Corregir imagen | `/corregir-error-imagen` | `corregir-error-imagen/` | Manual O automático |

### Beneficios del diseño dual

1. **Flexibilidad máxima**
   - Usuario puede invocar manualmente con `/comando`
   - O dejar que Claude lo detecte automáticamente

2. **Mejor experiencia**
   - Usuarios nuevos: Claude les ayuda automáticamente (skills)
   - Usuarios expertos: Control total con `/comandos`

3. **Documentación clara**
   - Commands para referencia rápida
   - Skills para workflows completos

---

## 📊 Comparación Visual

### Modo Manual (Slash Command)

```
Usuario: /analizar-icfes
         ↓
Claude: Ejecuta el comando inmediatamente
```

### Modo Automático (Agent Skill)

```
Usuario: "Analiza este ejercicio ICFES"
         ↓
Claude: Detecta contexto → Busca skill relevante → Ejecuta
```

---

## 🎓 Mejores Prácticas

### Para Usuarios

1. **Primera vez con el workflow**: Deja que Claude use los skills automáticamente
2. **Usuario experimentado**: Usa `/comandos` para control preciso
3. **Exploración**: Pregunta a Claude qué puede hacer (skills) o usa `/help`

### Para Mantenedores

1. **Mantener sincronizados**: Actualizar ambos (commands + skills) cuando cambies algo
2. **Descripción clara**: Skills necesitan buena descripción para detección automática
3. **Documentar ambos**: Mencionar en docs que hay dos formas de invocar

---

## ✅ Estado Actual del Proyecto

### Slash Commands (`.claude/commands/`)

- ✅ `analizar-icfes.md`
- ✅ `generar-schoice.md`
- ✅ `generar-cloze.md`
- ✅ `promover-ejercicio.md`
- ✅ `corregir-error-imagen.md`

### Agent Skills (`.claude/skills/`)

- ✅ `analizar-icfes/skill.md`
- ✅ `generar-schoice/skill.md`
- ✅ `generar-cloze/skill.md`
- ✅ `promover-ejercicio/skill.md`
- ✅ `corregir-error-imagen/skill.md`
- ✅ `validar-diversidad/skill.md`
- ✅ `validar-icfes/skill.md`

**Total:** 5 comandos + 7 skills = **Dual-mode completo**

---

## 🚀 Recomendación Final

**MANTENER AMBOS** (Commands + Skills) porque:

1. ✅ Es la estructura **recomendada** por Claude Code
2. ✅ Ofrece máxima **flexibilidad** a usuarios
3. ✅ No hay **overhead** - solo archivos markdown
4. ✅ Mejor **experiencia de usuario** para todos los niveles

**Referencia oficial:**

- Commands: https://code.claude.com/docs/en/slash-commands.md
- Skills: https://code.claude.com/docs/en/skills.md

---

**Última actualización:** 2025-12-20  
**Estado:** ✅ Estructura dual implementada correctamente

