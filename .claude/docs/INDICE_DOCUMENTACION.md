# 📚 Índice de Documentación - Sistema Claude Code ICFES R-Exams

**Guía de navegación de toda la documentación del sistema**

---

## 🚀 PARA EMPEZAR

### Si es tu primera vez:

1. **[WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md)** ⭐ RECOMENDADO
   - Guía completa desde subir imagen hasta ejercicio en producción
   - 8 pasos detallados con ejemplos
   - Tiempos estimados y troubleshooting
   - **Tiempo de lectura:** 30-40 minutos

2. **[GUIA_RAPIDA_VISUAL.md](GUIA_RAPIDA_VISUAL.md)** ⚡ REFERENCIA RÁPIDA
   - Diagramas visuales del workflow
   - Checklist y comandos clave
   - **Tiempo de lectura:** 5-10 minutos

3. **[GUIA_USUARIO.md](GUIA_USUARIO.md)** 📖 REFERENCIA COMPLETA
   - Todos los comandos disponibles
   - Documentación de cada comando
   - Recursos adicionales
   - **Tiempo de lectura:** 20-30 minutos

---

## 📋 DOCUMENTACIÓN POR CATEGORÍA

### 🎯 Workflows y Procedimientos

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md)** | Workflow completo detallado | Primera vez o como referencia completa |
| **[GUIA_RAPIDA_VISUAL.md](GUIA_RAPIDA_VISUAL.md)** | Referencia visual rápida | Recordatorio rápido del proceso |
| **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** | Solución de problemas | Cuando encuentres errores |

### 📚 Guías de Usuario

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[GUIA_USUARIO.md](GUIA_USUARIO.md)** | Guía completa de comandos | Referencia de comandos y recursos |
| **[README.md](README.md)** | Estructura del sistema | Entender organización del proyecto |

### 🔧 Procedimientos Técnicos

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[TRES_NIVELES_VALIDACION.md](TRES_NIVELES_VALIDACION.md)** | Metodología de validación | Validar calidad de ejercicios |
| **[patrones-errores-conocidos.md](patrones-errores-conocidos.md)** | Base de errores conocidos | Buscar soluciones a errores |

### 🎨 Graficador-Experto (Integrado)

El Graficador-Experto está completamente integrado en el workflow principal. Se activa automáticamente cuando se detectan gráficos matemáticos en la imagen ICFES.

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md](01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md)** | Incluye sección "Detección Automática de Gráficos" | Entender flujo integrado completo |
| **[01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md](01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md)** | Funcionamiento detallado del Graficador-Experto | Entender sistema completo de replicación visual |
| **[GRAFICADOR_EXPERTO_README.md](GRAFICADOR_EXPERTO_README.md)** | README original del Graficador-Experto | Referencia rápida de comandos y skills |

**Comandos disponibles**: `/analizar-imagen-grafica`, `/generar-codigo-tikz`, `/generar-codigo-python`, `/generar-codigo-r`, `/comparar-similitud-visual`, `/refinar-codigo-grafico`, `/exportar-graficos`, `/estado-graficador`, `/auto-refinar-grafico`

**Nota**: Los comandos anteriores con prefijo `grafico-*` han sido renombrados a nombres más descriptivos. El sistema detecta automáticamente gráficos y activa este flujo cuando es necesario.

### 🗂️ Gestión del Sistema

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[COMANDOS_DEPRECADOS.md](COMANDOS_DEPRECADOS.md)** | Registro de comandos deprecados | Verificar comandos obsoletos |
| **[CHANGELOG.md](CHANGELOG.md)** | Historial de cambios | Ver evolución del sistema |
| **[COMMANDS_VS_SKILLS.md](COMMANDS_VS_SKILLS.md)** | Filosofía commands vs skills | Entender arquitectura del sistema |
| **[ACTUALIZACION_DOCUMENTACION.md](ACTUALIZACION_DOCUMENTACION.md)** | Guía de actualización | Actualizar documentación |
| **[01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md](01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md)** | Explicación completa del sistema | Entender estructura completa |
| **[01-OPTIMIZACION_DIRECTORIO_CLAUDE.md](01-OPTIMIZACION_DIRECTORIO_CLAUDE.md)** | Optimización reciente (2025-12-28) | Ver cambios de optimización |

### 🔄 Fase 5 - Eliminación de Comandos

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[FASE5_RESUMEN_EJECUTIVO.md](FASE5_RESUMEN_EJECUTIVO.md)** | Resumen de Fase 5 | Visión general de la fase |
| **[FASE5_PROCEDIMIENTO_ELIMINACION.md](FASE5_PROCEDIMIENTO_ELIMINACION.md)** | Procedimiento completo | Ejecutar eliminación (2025-03-20) |
| **[FASE5_CHECKLIST_PRE_ELIMINACION.md](FASE5_CHECKLIST_PRE_ELIMINACION.md)** | Checklist de verificación | Antes de ejecutar eliminación |

### 📝 Casos Resueltos

| Documento | Descripción | Cuándo Usar |
|-----------|-------------|-------------|
| **[casos-resueltos/](casos-resueltos/)** | Historial de casos específicos | Aprender de casos reales |

---

## 🎯 DOCUMENTACIÓN POR OBJETIVO

### Quiero generar mi primer ejercicio

1. **Leer**: [WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md)
2. **Consultar**: [GUIA_RAPIDA_VISUAL.md](GUIA_RAPIDA_VISUAL.md) (mientras trabajas)
3. **Si hay problemas**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

### Quiero entender los comandos disponibles

1. **Leer**: [GUIA_USUARIO.md](GUIA_USUARIO.md)
2. **Consultar**: Archivos en `.claude/commands/`

### Tengo un error de compilación

1. **Buscar**: [patrones-errores-conocidos.md](patrones-errores-conocidos.md)
2. **Consultar**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. **Revisar**: [casos-resueltos/](casos-resueltos/)

### Quiero validar la calidad de mi ejercicio

1. **Leer**: [TRES_NIVELES_VALIDACION.md](TRES_NIVELES_VALIDACION.md)
2. **Ejecutar**: `/validar-diversidad`
3. **Verificar**: Checklist en [WORKFLOW_PASO_A_PASO.md](WORKFLOW_PASO_A_PASO.md#paso-4-revisar-el-archivo-rmd)

### Quiero saber qué ha cambiado en el sistema

1. **Leer**: [CHANGELOG.md](CHANGELOG.md)
2. **Verificar**: [COMANDOS_DEPRECADOS.md](COMANDOS_DEPRECADOS.md)

### Quiero generar gráficos complejos para ejercicios

1. **Leer**: Sección "Detección Automática de Gráficos" en [01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md](01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md)
2. **El sistema detecta automáticamente** gráficos en la imagen ICFES
3. **Si hay gráficos**: Se ejecuta automáticamente `/analizar-imagen-grafica`
4. **Generar código**: `/generar-codigo-tikz` o `/generar-codigo-python` o `/generar-codigo-r`
5. **Validar similitud**: `/comparar-similitud-visual` y `/auto-refinar-grafico` si es necesario
6. **Integración automática**: El código validado se integra automáticamente en la generación del ejercicio `.Rmd`

---

## 📁 ESTRUCTURA DE ARCHIVOS

```
.claude/
├── docs/                                    # 📚 Documentación principal
│   ├── INDICE_DOCUMENTACION.md             # Este archivo
│   ├── WORKFLOW_PASO_A_PASO.md             # ⭐ Guía paso a paso
│   ├── GUIA_RAPIDA_VISUAL.md               # ⚡ Referencia visual
│   ├── GUIA_USUARIO.md                     # 📖 Guía de usuario
│   ├── README.md                           # Estructura del sistema
│   ├── TRES_NIVELES_VALIDACION.md          # Metodología de validación
│   ├── TROUBLESHOOTING.md                  # 🆘 Solución de problemas
│   ├── CHANGELOG.md                        # 📝 Historial de cambios
│   ├── COMANDOS_DEPRECADOS.md              # Comandos obsoletos
│   ├── COMMANDS_VS_SKILLS.md               # Filosofía commands vs skills
│   ├── ACTUALIZACION_DOCUMENTACION.md      # Guía de actualización
│   ├── patrones-errores-conocidos.md       # Base de errores
│   ├── FASE5_RESUMEN_EJECUTIVO.md          # Resumen Fase 5
│   ├── FASE5_PROCEDIMIENTO_ELIMINACION.md  # Procedimiento Fase 5
│   ├── FASE5_CHECKLIST_PRE_ELIMINACION.md  # Checklist Fase 5
│   ├── RESUMEN_DOCUMENTACION_WORKFLOW.md   # Resumen del workflow
│   ├── 01-EXPLICACION_COMPLETA_DIRECTORIO_CLAUDE.md  # Explicación completa
│   ├── 01-OPTIMIZACION_DIRECTORIO_CLAUDE.md          # Optimización reciente
│   ├── 01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md  # 🎨 Graficador-Experto completo (referencia)
│   ├── GRAFICADOR_EXPERTO_README.md                  # 🎨 README Graficador-Experto (referencia)
│   ├── casos-resueltos/                    # Casos específicos
│   │   ├── 2025-12-19-cilindro-tikz.md
│   │   ├── 2025-12-21-recta-abs-formateado.md
│   │   └── 2025-01-XX-recta-abs-formateado.md
│   └── html-backups/                       # Backups HTML de documentación
│       └── html-20251228/                  # Backup 2025-12-28
├── skills/                                  # 🎯 Skills de Claude Code
│   ├── analizar-icfes/                     # Análisis ICFES 6 dimensiones
│   ├── generar-schoice/                    # Generar SCHOICE
│   ├── generar-cloze/                      # Generar CLOZE
│   ├── corregir-error-imagen/              # Corrección de errores
│   ├── corregir-graficos/                  # Corrección de gráficos
│   ├── diagnosticar-errores/               # Diagnóstico de errores
│   ├── promover-ejercicio/                 # Promoción a producción
│   ├── validar-coherencia/                 # Validación de coherencia
│   ├── validar-diversidad/                 # Validación de 250+ versiones únicas
│   ├── validar-icfes/                      # Validación de metadatos
│   └── validar-renderizado/                # Validación de renderizado
│   ├── analizar-imagen-grafica/           # 🎨 Análisis visual matemático
│   ├── generar-codigo-tikz/              # 🎨 Generación TikZ/LaTeX
│   ├── generar-codigo-python/            # 🎨 Generación Python/Matplotlib
│   ├── generar-codigo-r/                 # 🎨 Generación R/ggplot2
│   ├── comparar-similitud-visual/         # 🎨 Comparación visual inteligente
│   ├── refinar-codigo-grafico/           # 🎨 Refinamiento iterativo
│   ├── gestionar-estado-graficador/      # 🎨 Gestión de estado persistente
│   └── transferir-conocimiento-grafico/   # 🎨 Transferencia entre lenguajes
├── schemas/                                 # 📋 Schemas JSON (Graficador-Experto)
│   ├── workflow_state.schema.json          # Estado persistente del workflow
│   ├── analisis_inicial.schema.json        # Análisis estructurado reutilizable
│   ├── metricas_similitud.schema.json      # Sistema de puntuación 0-100
│   └── lecciones_aprendidas.schema.json    # Transferencia de conocimiento
├── agents/                                  # 🤖 Agentes especializados
│   └── clasificador-icfes.md               # Clasificador ICFES
│   └── deprecated/                         # ⚠️ Agentes deprecados
│       └── graficador-tikz.md              # (Deprecado - Reemplazado por Graficador-Experto integrado)
├── scripts/                                 # 🔧 Scripts de automatización
│   ├── README.md                           # Documentación de scripts
│   ├── fase5_eliminar_comando_deprecado.sh # Script de eliminación
│   ├── fase5_tests_post_eliminacion.sh     # Tests post-eliminación
│   └── fase5_rollback.sh                   # Rollback
├── tests/                                   # 🧪 Tests de validación
│   └── test_comandos_workflow.md           # Tests de workflow
├── deprecated/                              # ⚠️ Archivos deprecados
│   └── analizar-ejercicio.md               # (Deprecado - Usar analizar-icfes)
├── backups/                                 # 💾 Backups de archivos
│   ├── .gitkeep
│   └── README.md
├── logs/                                    # 📋 Logs de ejecución
│   ├── .gitkeep
│   └── README.md
├── settings.json                            # ⚙️ Configuración global
├── settings.local.json                      # ⚙️ Permisos locales
├── Mermaid_Chart.txt                        # 📊 Diagrama de arquitectura
└── Mermaid_Chart_Graficador_Experto.txt    # 📊 Diagrama Graficador-Experto
```

---

## 🔍 BÚSQUEDA RÁPIDA

### Por Tema

| Tema | Documentos Relevantes |
|------|----------------------|
| **Workflow completo** | WORKFLOW_PASO_A_PASO.md, GUIA_RAPIDA_VISUAL.md |
| **Comandos** | GUIA_USUARIO.md, commands/*.md |
| **Graficador-Experto** | INTEGRACION_GRAFICADOR_EXPERTO.md, 01-EXPLICACION_COMPLETA_GRAFICADOR_EXPERTO.md |
| **Errores** | TROUBLESHOOTING.md, patrones-errores-conocidos.md |
| **Validación** | TRES_NIVELES_VALIDACION.md |
| **Fase 5** | FASE5_*.md |
| **Cambios** | CHANGELOG.md, COMANDOS_DEPRECADOS.md |

### Por Nivel de Experiencia

| Nivel | Documentos Recomendados |
|-------|------------------------|
| **Principiante** | WORKFLOW_PASO_A_PASO.md → GUIA_RAPIDA_VISUAL.md → GUIA_USUARIO.md |
| **Intermedio** | GUIA_USUARIO.md → TRES_NIVELES_VALIDACION.md → patrones-errores-conocidos.md |
| **Avanzado** | CHANGELOG.md → casos-resueltos/ → scripts/README.md |

---

## 📊 ESTADÍSTICAS DE DOCUMENTACIÓN

| Métrica | Valor |
|---------|-------|
| **Total de documentos** | 25+ |
| **Guías de usuario** | 5 |
| **Procedimientos técnicos** | 6 |
| **Graficador-Experto** | 3 documentos |
| **Skills documentados** | 19 (11 principales + 8 grafico-*) |
| **Agentes documentados** | 2 |
| **Scripts documentados** | 4 |
| **Casos resueltos** | 3 |
| **Líneas totales de documentación** | ~8,000+ |

---

## 🎯 RUTAS DE APRENDIZAJE

### Ruta 1: Usuario Nuevo (Tiempo: 2-3 horas)

```

1. Leer WORKFLOW_PASO_A_PASO.md (40 min)
   ↓

2. Practicar con primera imagen (60 min)
   ↓

3. Consultar GUIA_RAPIDA_VISUAL.md (10 min)
   ↓

4. Generar segundo ejercicio (40 min)
   ↓

5. Leer GUIA_USUARIO.md (30 min)
```

### Ruta 2: Resolución de Problemas (Tiempo: 30-60 min)

```

1. Identificar error
   ↓

2. Buscar en patrones-errores-conocidos.md (10 min)
   ↓

3. Si no está → TROUBLESHOOTING.md (15 min)
   ↓

4. Si no está → casos-resueltos/ (15 min)
   ↓

5. Si no está → Solicitar ayuda a Claude Code
```

### Ruta 3: Optimización (Tiempo: 1-2 horas)

```

1. Leer TRES_NIVELES_VALIDACION.md (20 min)
   ↓

2. Revisar ejemplos funcionales (30 min)
   ↓

3. Estudiar casos-resueltos/ (30 min)
   ↓

4. Experimentar con optimizaciones (40 min)
```

---

## 📞 SOPORTE

### Si no encuentras lo que buscas:

1. **Buscar en este índice** por tema o objetivo
2. **Consultar TROUBLESHOOTING.md** para problemas comunes
3. **Revisar CHANGELOG.md** para cambios recientes
4. **Solicitar ayuda a Claude Code** con contexto específico

---

## 🔄 ACTUALIZACIONES

Este índice se actualiza con cada nueva documentación agregada al sistema.

**Última actualización:** 2025-12-29  
**Versión:** 1.2  
**Documentos indexados:** 25+

---

**Nota:** Todos los enlaces son relativos a la ubicación de este archivo (`.claude/docs/`).
