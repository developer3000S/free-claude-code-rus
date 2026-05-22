# Documentación Técnica - Sistema de Automatizaciones

Esta carpeta contiene la documentación técnica del sistema de automatizaciones para la generación y corrección de ejercicios R/exams.

---

## 🚀 INICIO RÁPIDO

**¿Buscas algo específico?**

👉 **[INDICE_DOCUMENTACION.md](INDICE_DOCUMENTACION.md)** - Índice completo de toda la documentación

**¿Primera vez usando el sistema?**

1. **[WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md)** - Guía completa paso a paso
2. **[GUIA_RAPIDA_VISUAL.md](GUIA_RAPIDA_VISUAL.md)** - Referencia visual rápida
3. **[GUIA_USUARIO.md](GUIA_USUARIO.md)** - Referencia de comandos

---

## Estructura

```
.claude/
├── docs/                           # 📚 Documentación técnica
│   ├── README.md                   # Este archivo
│   ├── INDICE_DOCUMENTACION.md     # Índice completo de documentación
│   ├── WORKFLOW_PASO_A_PASO.md     # Guía completa del workflow
│   ├── GUIA_RAPIDA_VISUAL.md       # Referencia visual rápida
│   ├── GUIA_USUARIO.md             # Guía completa de usuario
│   ├── TRES_NIVELES_VALIDACION.md  # Metodología de validación
│   ├── TROUBLESHOOTING.md          # Solución de problemas
│   ├── CHANGELOG.md                # Historial de cambios
│   ├── COMMANDS_VS_SKILLS.md       # Filosofía commands vs skills
│   ├── ACTUALIZACION_DOCUMENTACION.md # Actualización de documentación
│   ├── COMANDOS_DEPRECADOS.md      # Registro de comandos deprecados
│   ├── FASE5_CHECKLIST_PRE_ELIMINACION.md  # Checklist Fase 5
│   ├── FASE5_PROCEDIMIENTO_ELIMINACION.md  # Procedimiento Fase 5
│   ├── FASE5_RESUMEN_EJECUTIVO.md  # Resumen ejecutivo Fase 5
│   ├── RESUMEN_DOCUMENTACION_WORKFLOW.md   # Resumen del workflow
│   ├── 01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md  # Explicación completa
│   ├── 01-OPTIMIZACION_DIRECTORIO_CLAUDE.md          # Optimización 2025-12-28
│   ├── patrones-errores-conocidos.md   # Base de conocimiento de errores
│   ├── casos-resueltos/            # Historial de casos específicos
│   │   ├── 2025-12-19-cilindro-tikz.md
│   │   ├── 2025-12-21-recta-abs-formateado.md
│   │   └── 2025-01-XX-recta-abs-formateado.md
│   └── html-backups/               # Backups HTML de documentación
│       └── html-20251228/          # Backup 2025-12-28
├── agents/                         # 🤖 Agentes especializados
│   ├── clasificador-icfes.md       # Análisis de ejercicios ICFES
│   └── graficador-tikz.md          # Replicación visual TikZ
├── skills/                         # 🎯 Skills de Claude Code (Workflow)
│   ├── analizar-icfes/             # Análisis ICFES según 6 dimensiones
│   ├── generar-schoice/            # Generador de ejercicios SCHOICE
│   ├── generar-cloze/              # Generador de ejercicios CLOZE
│   ├── promover-ejercicio/         # Promoción a producción
│   ├── corregir-error-imagen/      # Corrector de errores TikZ
│   ├── corregir-graficos/          # Corrector de gráficos
│   ├── diagnosticar-errores/       # Diagnóstico de errores
│   ├── validar-coherencia/         # Validación de coherencia
│   ├── validar-diversidad/         # Validador de 250+ versiones únicas
│   ├── validar-icfes/              # Validador de metadatos ICFES
│   └── validar-renderizado/        # Validación de renderizado
├── deprecated/                     # ⚠️ Archivos deprecados
│   └── analizar-ejercicio.md       # (Deprecado - Usar analizar-icfes)
├── scripts/                        # 🔧 Scripts de automatización
│   ├── README.md                   # Documentación de scripts
│   ├── fase5_eliminar_comando_deprecado.sh  # Script de eliminación
│   ├── fase5_tests_post_eliminacion.sh      # Tests post-eliminación
│   └── fase5_rollback.sh           # Plan de rollback
├── tests/                          # 🧪 Tests de validación
│   └── test_comandos_workflow.md   # Tests de workflow
├── backups/                        # 💾 Backups de archivos
│   ├── .gitkeep
│   └── README.md
├── logs/                           # 📋 Logs de ejecución
│   ├── .gitkeep
│   └── README.md
├── settings.json                   # ⚙️ Hooks y configuración global
├── settings.local.json             # ⚙️ Permisos para skills
└── Mermaid_Chart.txt               # 📊 Diagrama de arquitectura
```

**Notas importantes:**

- ✅ Optimización 2025-12-28: Documentación consolidada en `docs/`
- ✅ 11 skills activos del workflow en `skills/`
- ✅ Backups HTML preservados con fecha en `html-backups/`
- ⚠️ `analizar-ejercicio.md` deprecado - Ver `COMANDOS_DEPRECADOS.md` para detalles

## Filosofia del Sistema

### ⛔ REGLAS CRITICAS v2.5 (OBLIGATORIAS)

#### Flujo B OBLIGATORIO si hay graficos
**Archivo**: `.claude/rules/flujo-b-obligatorio.md`

Si se detectan graficos en el ejercicio (enunciado u opciones), el Flujo B (Graficador Experto) es **OBLIGATORIO**. NO hay excepciones.

#### Proceso SECUENCIAL del Graficador
**Archivo**: `.claude/rules/graficador-secuencial.md`

Las versiones se generan UNA A LA VEZ, no simultaneamente:
```
1. TikZ → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
2. Python → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
3. R → Iterar >=95% + 5 Coherencias + Aprobacion Usuario
4. Usuario selecciona version final
```

#### 5 Coherencias a Verificar
Antes de aprobar cada version:
1. **Coherencia Semantica** - Gramatica correcta, **TILDES OBLIGATORIAS**
2. **Coherencia Visual-Texto** - Grafico coincide con enunciado
3. **Coherencia Matematica** - Formulas y proporciones correctas
4. **Coherencia de Codigo** - Dinamico, compatible con R-exams
5. **Coherencia General** - Legible, estilo ICFES

#### Validación Visual Iterativa (OBLIGATORIO)
**Archivo**: `.claude/rules/ciclo-validacion.md`

**Principio**: NUNCA marcar como "completado" sin inspección visual REAL.
- Convertir PDF → PNG con `magick`
- MOSTRAR imagen al usuario con `Read` tool
- Verificar las 5 coherencias VISUALMENTE
- Documentar hallazgos con checklist
- Solicitar aprobación del usuario antes de finalizar

**⚠️ REGLA CRÍTICA v2.5: REPETIR CICLO DESPUÉS DE CADA CAMBIO**
- Cada vez que se aplica CUALQUIER corrección → VOLVER A RENDERIZAR
- Cada vez que se modifica código → MOSTRAR NUEVO PREVIEW
- NUNCA asumir que un cambio produjo el resultado esperado sin verificación

### ⚡ Ciclo de Validacion y Correccion Automatica (OBLIGATORIO)

**Cada vez que se renderiza un archivo .Rmd, se ejecuta automaticamente:**

```
🔄 FASE 1: RENDERIZADO INICIAL
    └── Ejecutar exams2html, exams2pdf, exams2docx, exams2nops
    └── Capturar errores/advertencias

🔍 FASE 2: VALIDACION VISUAL Y FUNCIONAL
    └── Coherencia Matematica, Imagen-Texto, Codigo, 4 formatos

⚡ FASE 3: DECISION Y ACCION
    ├── ❌ SIN ERRORES → Continuar workflow
    └── ✓ CON ERRORES:
        ├── 📚 SUBFASE 3A: Consultar /A-Produccion/Ejemplos-Funcionales-Rmd/
        ├── 🔄 SUBFASE 3B: VOLVER A FASE 1 (ciclo obligatorio)
        └── 📊 SUBFASE 3C: Documentar en patrones-errores-conocidos.md
```

**Condiciones Criticas:**

- ❌ NO terminar con errores sin resolver
- ❌ NO generar .Rmd con graficos sin completar Flujo B
- ✓ Ejemplos funcionales = Fuente de verdad absoluta
- ✓ Documentar SOLO despues de confirmar solucion

### Principio de Documentación Verificada

**Solo se documenta lo que está 100% verificado y funcionando.**

Este principio fundamental asegura que:

- ✅ Todas las soluciones documentadas han sido probadas
- ✅ Cada patrón incluye código de ejemplo funcional
- ✅ Los resultados son reproducibles
- ✅ La documentación es confiable como referencia

### ¿Qué NO documentamos?

- ❌ Errores sin solución confirmada
- ❌ Soluciones parciales o incompletas
- ❌ "Posibles soluciones" o aproximaciones
- ❌ Teorías o hipótesis sin validación

### ¿Qué SÍ documentamos?

- ✅ Errores identificados con solución verificada
- ✅ Código antes/después completamente funcional
- ✅ Pruebas de validación exitosas (PDF + HTML)
- ✅ Referencias a archivos .Rmd en producción
- ✅ Historial con resultados específicos
- ✅ Patrón utilizado de ejemplos funcionales (SUBFASE 3C)

## Documentos Principales

### 1. TRES_NIVELES_VALIDACION.md

**Propósito:** Guía completa del sistema de validación en tres niveles.

**Los tres niveles:**

1. **Nivel 1 - RStudio:** Run > Run all (validación interactiva)
2. **Nivel 2 - Generación Masiva:** SemilleroUnico_v2.R (todos los formatos)
3. **Nivel 3 - Terreno:** Validación con estudiantes en el aula

**Contenido:**

- Descripción detallada de cada nivel
- Criterios de éxito específicos
- Qué detecta y qué no detecta cada nivel
- Flujo completo de validación
- Checklist de validación completa

### 2. patrones-errores-conocidos.md

**Propósito:** Base de conocimiento de errores comunes y sus soluciones verificadas.

**Estructura de cada patrón:**
```markdown
## Error N: [Título]

### ❌ Mensaje de Error
[Error exacto]

### 🔍 Causa Raíz
[Explicación técnica]

### ✅ Solución Verificada
[Código antes/después con ejemplos completos]

### 🧪 Validación de la Solución
[Criterios y comandos de prueba]

### 📋 Checklist de Corrección
[Pasos específicos]

### 📅 Historial
[Tabla con resultados de validación]
```

**Proceso de agregado:**

1. Identificar el error recurrente
2. Desarrollar y probar la solución
3. Validar en archivo .Rmd real (PDF + HTML)
4. Documentar con código completo
5. Agregar resultados de validación

## Skills de Automatización

Los skills son procedimientos automatizados que Claude puede ejecutar para tareas específicas.

### Skill: corregir-error-imagen

**Función:** Corrige errores de compilación LaTeX causados por `include_tikz()`.

**Cuándo usar:**
```bash
/corregir-error-imagen
```

**Qué hace:**

1. Identifica chunks con `include_tikz()`
2. Aplica patrón de renderizado condicional
3. Prueba compilación PDF y HTML
4. Valida resultados

**Documentación completa:** `.claude/skills/corregir-error-imagen/skill.md`

### Skill: validar-diversidad

**Función:** Valida que un ejercicio genere 250+ versiones únicas (de 300 intentos).

**Cuándo usar:**
```bash
/validar-diversidad
```

**Documentación completa:** `.claude/skills/validar-diversidad/skill.md`

### Skill: validar-icfes

**Función:** Verifica que los metadatos ICFES estén completos y correctos.

**Documentación completa:** `.claude/skills/validar-icfes/skill.md`

## Flujo de Trabajo: Ciclo de Validación y Corrección Automática

### 🔄 FASE 1: Renderizado Inicial (OBLIGATORIO)
```r
# Ejecutar renderizado completo
exams2html("archivo.Rmd", n = 1)
exams2pdf("archivo.Rmd", n = 1)
exams2pandoc("archivo.Rmd", n = 1, type = "docx")
exams2nops("archivo.Rmd", n = 1)
# Capturar y registrar errores/advertencias
```

### 🔍 FASE 2: Validación Visual y Funcional

1. **Coherencia Matemática**: Fórmulas, cálculos, respuesta correcta
2. **Coherencia Imagen-Texto**: Descripción vs gráfico, valores sincronizados
3. **Coherencia de Código**: R ↔ Python ↔ TikZ sincronizado
4. **Renderizado 4 formatos**: HTML, PDF, DOCX, NOPS correctos

### ⚡ FASE 3: Decisión y Acción

**SI NO hay errores** → Continuar workflow normal

**SI hay errores** → Ejecutar subfases:

#### 📚 SUBFASE 3A: Corrección Basada en Ejemplos
```bash
# SIEMPRE consultar ejemplos funcionales ANTES de corregir
ls /A-Produccion/Ejemplos-Funcionales-Rmd/
# Identificar patrones de solución en archivos similares
# Aplicar correcciones basadas en ejemplos validados
```

#### 🔄 SUBFASE 3B: Ciclo de Revalidación (OBLIGATORIO)
```
⚠️ VOLVER AUTOMÁTICAMENTE A FASE 1
→ Repetir renderizado completo
→ NO TERMINAR hasta resolver TODOS los errores
```

#### 📊 SUBFASE 3C: Gestión de Resultados (Solo si éxito)

1. Documentar error y solución en `patrones-errores-conocidos.md`
2. Incluir código completo (antes/después)
3. Documentar ejemplo funcional utilizado
4. Referenciar archivo .Rmd verificado

### ⛔ CONDICIONES CRÍTICAS

- ❌ NO terminar con errores sin resolver
- ❌ NUNCA proceder con errores pendientes
- ✓ Documentar SOLO después de confirmar solución
- ✓ Ejemplos funcionales = Fuente de verdad absoluta

## Criterios de Calidad

### Para Documentación de Errores

**Mínimo requerido:**

- [ ] Error reproducible con mensaje exacto
- [ ] Causa raíz identificada y explicada
- [ ] Solución con código completo (antes/después)
- [ ] Validación exitosa en PDF
- [ ] Validación exitosa en HTML
- [ ] Archivo .Rmd de referencia funcionando
- [ ] Tabla de historial con resultados

### Para Skills de Automatización

**Mínimo requerido:**

- [ ] Descripción clara de la función
- [ ] Algoritmo paso a paso documentado
- [ ] Casos de uso específicos
- [ ] Link a patrón de error documentado
- [ ] Instrucciones de ejecución
- [ ] Criterios de validación

## Mantenimiento

### Actualización de Patrones Existentes

Si un patrón documentado necesita actualización:

1. ✅ Probar nueva solución completamente
2. ✅ Validar en múltiples archivos .Rmd
3. ✅ Actualizar sección de código
4. ✅ Agregar nueva entrada en historial
5. ✅ Incrementar versión (v1.0 → v1.1)

### Obsolescencia de Patrones

Si un patrón ya no es relevante:

1. No eliminar (preservar historial)
2. Agregar nota al inicio: `⚠️ OBSOLETO - Ver [nuevo_patron]`
3. Explicar por qué quedó obsoleto
4. Referenciar nuevo enfoque recomendado

## Convenciones

### Símbolos Utilizados

- ✅ Verificado / Exitoso
- ❌ No válido / Error
- ⚠️ Advertencia / Precaución
- 🔍 Análisis / Investigación
- 🧪 Prueba / Validación
- 📋 Checklist / Lista de tareas
- 📅 Historial / Versiones
- 🔗 Referencia / Link
- 🎯 Aplicable / Caso de uso
- 🎉 Éxito completo

### Formato de Código

**Bloques de código siempre incluyen:**
```r
# Comentario explicativo
codigo_funcional <- function() {
  # Implementación completa
  return(resultado)
}
```

**Nunca usar:**
```r
# ... resto del código ...
# [código omitido]
# etc.
```

## Contribución

Para agregar nueva documentación:

1. Seguir el template exacto del tipo de documento
2. Validar completamente antes de documentar
3. Incluir resultados específicos de pruebas
4. Referenciar archivos reales del repositorio
5. Actualizar este README si es necesario

## Contacto y Soporte

Para preguntas sobre la documentación:

- Ver primero `patrones-errores-conocidos.md`
- Revisar skills existentes en `.claude/skills/`
- Consultar archivos .Rmd de referencia en `/A-Produccion/`

---

**Ultima actualizacion:** 2026-01-01
**Version del sistema:** 2.5.1 (Sincronización Documentación)
**Estado:** ✅ Operacional

### Cambios v2.5.1
- Sincronización de documentación entre CLAUDE.md, Mermaid_Chart.txt y docs/README.md
- Fecha actualizada a 2026-01-01

### Cambios v2.5
- **NUEVO**: Regla crítica: REPETIR CICLO DESPUÉS DE CADA CAMBIO
- Cada corrección/ajuste → Volver a renderizar → Mostrar preview → Verificar coherencias
- PROHIBIDO aplicar cambios sin volver a mostrar resultado visual al usuario
- Validación Visual Iterativa OBLIGATORIA con inspección REAL

### Cambios v2.4
- Script ortografía mejorado: Excluye automáticamente metadatos R-exams
- Campos ASCII obligatorios en metadatos
- PROHIBIDO: `git commit --no-verify`

### Cambios v2.3
- Validación Visual Iterativa OBLIGATORIA después de renderizado
- Mostrar preview.png al usuario antes de aprobar
- Documentar 5 coherencias con checklist explícito

### Cambios v2.2
- Flujo B (Graficador Experto) ahora es OBLIGATORIO cuando hay graficos
- Proceso SECUENCIAL: TikZ → Python → R (no simultaneo)
- 5 coherencias a verificar antes de aprobacion de cada version
- Bloqueo de generacion .Rmd si Flujo B incompleto
