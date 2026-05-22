# 📋 Registro de Comandos Deprecados

Este documento mantiene un historial de comandos deprecados, sus razones de deprecación y las alternativas recomendadas.

---

## 🎯 Política de Deprecación

### Fases de Deprecación

1. **Fase 1 - Marcado (Actual)**: Comando marcado como deprecado, mantiene funcionalidad
2. **Fase 2 - Advertencia (1 mes)**: Agregar warnings al ejecutar comando deprecado
3. **Fase 3 - Eliminación (3 meses)**: Eliminar comando del sistema completamente

### Criterios para Deprecación

Un comando se depreca cuando:

- ✅ Existe redundancia funcional con otro comando
- ✅ El comando alternativo es superior en funcionalidad
- ✅ No hay uso documentado en el workflow oficial
- ✅ La migración no rompe compatibilidad con el sistema existente

---

## 📚 Comandos Deprecados

### `/analizar-ejercicio` → `/analizar-icfes`

**Fecha de deprecación:** 2025-12-20  
**Fase actual:** Fase 1 (Marcado)  
**Fecha estimada de eliminación:** 2025-03-20  
**Razón:** Análisis incompleto (3/6 dimensiones ICFES)  
**Alternativa:** `/analizar-icfes`

#### Diferencias Clave

| Aspecto | `/analizar-ejercicio` | `/analizar-icfes` |
|---------|----------------------|-------------------|
| **Dimensiones analizadas** | 3 (parcial) | 6 (completo) |
| **Nivel de Dificultad** | ✅ | ✅ |
| **Competencia** | ✅ | ✅ |
| **Componente** | ⚠️ (combinado con Pensamiento) | ✅ (separado) |
| **Pensamiento** | ⚠️ (combinado con Componente) | ✅ (separado) |
| **Contenido Curricular** | ❌ | ✅ |
| **Eje Axial Disciplinar** | ❌ | ✅ |
| **Alineación con Mermaid Chart** | Parcial | Total |
| **Referencias en documentación** | 0 | 5 |

#### Problemas Identificados

1. **Análisis Incompleto**: Solo cubre 3 de las 6 dimensiones obligatorias del Mermaid Chart
2. **Dimensiones Combinadas**: Mezcla "Componente" (C3) y "Pensamiento" (C4) en una sola dimensión
3. **Metadatos Incompletos**: Los archivos .Rmd generados carecen de información de dimensiones C5 y C6
4. **Sin Uso Documentado**: No hay referencias en el workflow oficial (`.claude/docs/TROUBLESHOOTING.md`)
5. **Incompatibilidad con Agente**: El agente `ClasificadorICFES` está diseñado para 6 dimensiones

#### Migración

**Antes:**
```bash
/analizar-ejercicio imagen.png
```

**Salida anterior (incompleta):**
```

1. Nivel de Dificultad (1-4)
2. Competencia (Interpretación, Formulación, Argumentación)
3. Componente y Pensamiento (Numérico, Espacial, Aleatorio, etc.)
```

**Después:**
```bash
/analizar-icfes imagen.png
```

**Salida nueva (completa):**
```

1. Nivel de Dificultad: (1-4)
2. Competencia: (Interpretación, Formulación, Argumentación)
3. Componente: (Numérico, Geométrico, Aleatorio)
4. Pensamiento: (Numérico, Espacial, Métrico, Variacional, Aleatorio)
5. Contenido: (Álgebra, Geometría, Estadística)
6. Eje: (Matemático, Aplicado)
```

#### Impacto de la Migración

- ✅ **Sin cambios en workflow existente**: El workflow oficial ya usa `/analizar-icfes`
- ✅ **Sin impacto en usuarios**: El comando `/analizar-ejercicio` no tiene uso documentado
- ✅ **Mejora de calidad**: Análisis completo genera metadatos ICFES completos
- ✅ **Mayor consistencia**: Alineación total con Mermaid Chart y agente ClasificadorICFES

#### Referencias

- **Comando deprecado**: `.claude/deprecated/analizar-ejercicio.md`
- **Comando recomendado**: `.claude/skills/analizar-icfes/skill.md`
- **Agente relacionado**: `.claude/agents/clasificador-icfes.md`
- **Workflow oficial**: `.claude/docs/TROUBLESHOOTING.md`
- **Mermaid Chart**: `.claude/Mermaid_Chart.txt`

---

## 📊 Estadísticas de Deprecación

| Métrica | Valor |
|---------|-------|
| **Total de comandos deprecados** | 1 |
| **Comandos en Fase 1** | 1 |
| **Comandos en Fase 2** | 0 |
| **Comandos eliminados (Fase 3)** | 0 |
| **Tasa de migración exitosa** | 100% |

---

## 🔍 Historial de Cambios

| Fecha | Comando | Acción | Fase |
|-------|---------|--------|------|
| 2025-12-20 | `/analizar-ejercicio` | Deprecado | Fase 1 |

---

**Última actualización:** 2025-12-28
**Versión:** 1.1

