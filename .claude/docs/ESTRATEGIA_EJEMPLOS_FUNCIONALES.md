# Estrategia: Ejemplos Funcionales vs SOURCES/

## 🎯 Decisión de Arquitectura

### SOURCES/ - Para Componentes Compartidos

**Propósito**: Archivos compartidos mediante symlinks entre múltiples módulos del sistema.

**Contenido**:
```
SOURCES/
├── documentacion_compartida/      # Docs compartidos entre skills
│   └── anatomia-metacognitiva.md
│
├── scripts_validacion/            # Scripts compartidos
│   ├── validar_coherencia_matematica.R
│   ├── corregir_ortografia_espanol.R
│   └── arsenal_validacion_completa.R
│
└── plantillas/                    # Plantillas BASE reutilizables
    ├── schoice_metacognitivo_base.Rmd      (futuro)
    ├── cloze_metacognitivo_base.Rmd        (futuro)
    └── pools/                              (futuro)
        └── errores_conceptuales_*.R
```

**Mecanismo**: Symlinks bidireccionales
- Editas en cualquier ubicación → SOURCES/ se modifica
- SOURCES/ se modifica → Todos los symlinks reflejan cambios

---

### Ejemplos-Funcionales-Rmd/ - Para Ejercicios Validados

**Propósito**: Biblioteca de ejercicios .Rmd COMPLETOS y 100% validados.

**Contenido**:
```
A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/
├── README.md                     # Guía técnica
├── CATALOGO.md                   # Índice searchable
│
└── [Ejercicios validados].Rmd    # Symlinks a ejercicios en producción
    ├── estadistica_diagramas_caja_*.Rmd -> ../06-Estadística-Y-Probabilidad/...
    ├── Ejemplo_00_*.Rmd (copias legacy)
    └── [más ejercicios]
```

**Mecanismo**: Symlinks bidireccionales (como SOURCES/)
- Ejercicio en 03-En-Produccion/[Tema]/ → Crear symlink en Ejemplos-Funcionales-Rmd/
- Agregar entrada al CATALOGO.md
- Sincronización automática (editas en cualquier lado, se refleja en ambos)

---

## 🔄 Diferencias Clave

| Aspecto | SOURCES/ | Ejemplos-Funcionales-Rmd/ |
|---------|----------|---------------------------|
| **Propósito** | Componentes compartidos | Ejercicios de referencia |
| **Mecanismo** | Symlinks bidireccionales | Symlinks bidireccionales |
| **Contenido** | Plantillas/scripts/docs | Ejercicios completos validados |
| **Edición** | Desde cualquier symlink | Desde cualquier ubicación |
| **Sincronización** | Automática vía symlinks | Automática vía symlinks |
| **Reutilización** | Base para generar nuevos | Consulta para patrones |

---

## 📋 Workflow Completo

### Fase 1: Desarrollo de Nuevo Ejercicio

```
1. /generar-schoice o /generar-cloze
   ↓
2. Usa plantilla desde SOURCES/plantillas/ (vía symlink)
   ↓
3. Genera en A-Produccion/02-En-Desarrollo/[ejercicio]/
```

### Fase 2: Validación

```
4. Ciclo de validación (FASE 1→2A→2B→2C→3)
   ↓
5. Ejercicio validado queda en 02-En-Desarrollo/
```

### Fase 3: Promoción a Producción + Ejemplo Funcional

```
6. /promover-ejercicio (opcional)
   ↓
7. Mueve a A-Produccion/03-En-Produccion/[Tema]/Pensamiento-XXX/
   ↓
8. Ejercicio se usa en producción exitosamente
   ↓
9. ¿Representa patrón útil para futuros ejercicios?
   ↓ SI
10. Crear symlink en Ejemplos-Funcionales-Rmd/
    ↓
11. Agregar entrada a CATALOGO.md
    ↓
12. Commit con mensaje descriptivo
```

---

## 🛠️ Herramientas Disponibles

### Script Automatizado (Recomendado)

```bash
# Desde En-Desarrollo (recién validado)
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/02-En-Desarrollo/ejercicio/ejercicio.Rmd \
  EST-INT-04

# O desde En-Produccion (ya organizado por tema)
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/03-En-Produccion/06-Estadística-Y-Probabilidad/Pensamiento-Aleatorio/ejercicio.Rmd \
  EST-INT-04

# El script:
# 1. Copia el .Rmd
# 2. Extrae metadatos automáticamente
# 3. Pide información interactiva (título, características, patrones)
# 4. Agrega entrada a CATALOGO.md
# 5. Actualiza estadísticas
```

### Manual

```bash
# 1. Copiar archivo desde En-Desarrollo o En-Produccion
cp A-Produccion/02-En-Desarrollo/ejercicio/ejercicio.Rmd \
   A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/

# 2. Editar CATALOGO.md manualmente
# 3. Agregar entrada completa
# 4. Actualizar estadísticas
```

---

## 📝 Criterios de Inclusión en Ejemplos-Funcionales-Rmd/

### ✅ Incluir si:

- ✅ Pasó todas las fases del ciclo de validación (1→2A→2B→2C→3)
- ✅ Genera 200+ versiones únicas
- ✅ Ha sido usado en producción exitosamente
- ✅ Representa un **patrón útil** para futuros ejercicios
- ✅ Implementa técnicas que queremos reutilizar
- ✅ Es ejemplo de **buenas prácticas**

### ❌ NO incluir si:

- ❌ Es ejercicio experimental
- ❌ Tiene características muy específicas/únicas que no se reutilizarán
- ❌ No aporta nuevos patrones al catálogo
- ❌ No ha sido probado en producción

---

## 🔍 Casos de Uso

### Caso 1: Corrección de Errores (SUBFASE 3A)

```
Tengo un error en ejercicio.Rmd
    ↓
Consulto CATALOGO.md → Busco ejercicios similares
    ↓
Abro ejercicio de referencia validado
    ↓
Consulto sección relevante (data_generation, question, solution)
    ↓
Aplico mismo patrón al ejercicio con error
```

### Caso 2: Generar Nuevo Ejercicio

```
Quiero generar ejercicio con gráficos como opciones
    ↓
Consulto CATALOGO.md → Busco "Gráficos como opciones"
    ↓
Encuentro EST-REP-01
    ↓
Abro estadistica_diagramas_caja_*.Rmd
    ↓
Reviso implementación validada
    ↓
Uso como base para nuevo ejercicio
```

### Caso 3: Revisión Detractor

```
Detractor identifica desviación del estándar
    ↓
Consulta CATALOGO.md para ejercicios similares
    ↓
Compara implementación actual vs patrón validado
    ↓
Reporta objeción si hay inconsistencia
```

---

## 📊 Estado Actual

### SOURCES/

```
✅ documentacion_compartida/anatomia-metacognitiva.md
✅ scripts_validacion/ (3 scripts activos)
⏳ plantillas/ (vacío - pendiente)
```

### Ejemplos-Funcionales-Rmd/

```
✅ README.md (guía técnica completa)
✅ CATALOGO.md (índice searchable con 4 ejercicios)
✅ 4 ejercicios SCHOICE validados
⏳ 0 ejercicios CLOZE (pendiente)
```

---

## 🎯 Próximos Pasos Recomendados

### Corto Plazo (1-2 semanas)

1. **Agregar ejercicios CLOZE validados** a Ejemplos-Funcionales-Rmd/
2. **Crear plantillas base** en SOURCES/plantillas/
   - schoice_metacognitivo_base.Rmd
   - cloze_metacognitivo_base.Rmd
3. **Configurar symlinks** desde skills hacia plantillas

### Mediano Plazo (1 mes)

4. **Expandir catálogo** a 10+ ejercicios de referencia
   - Cubrir todas las áreas (estadística, álgebra, geometría, funciones)
   - Cubrir todos los niveles (1-4)
5. **Crear pools compartidos** en SOURCES/plantillas/pools/
   - errores_conceptuales_estadistica.R
   - errores_conceptuales_algebra.R
   - reflexiones_metacognitivas_generales.R

### Largo Plazo (3 meses)

6. **Automatizar validación** de patrones mediante detractor
7. **Integrar con CI/CD** para verificar que nuevos ejercicios siguen patrones validados
8. **Generar métricas** de reutilización de patrones

---

## 📖 Documentación Relacionada

- **SOURCES/README.md** - Arquitectura de symlinks
- **Ejemplos-Funcionales-Rmd/README.md** - Guía técnica de ejemplos
- **Ejemplos-Funcionales-Rmd/CATALOGO.md** - Índice searchable de ejercicios
- **.claude/scripts/agregar_ejemplo_funcional.sh** - Script automatizado
- **.claude/docs/patrones-errores-conocidos.md** - Errores y soluciones

---

## 🚀 Ejemplo de Uso Completo

### Escenario: Ejercicio Validado Listo para Producción

```bash
# Paso 1: Verificar que pasó todas las fases
# (FASE 1, 2A, 2B, 2C, 3 completadas)

# Paso 2: Usar script automatizado
# Opción A: Desde En-Desarrollo
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/02-En-Desarrollo/est_varianza/estadistica_varianza_interpretacion_n3_schoice_v1.Rmd \
  EST-INT-05

# Opción B: Desde En-Produccion (ya organizado por tema)
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/03-En-Produccion/06-Estadística-Y-Probabilidad/Pensamiento-Aleatorio/estadistica_varianza_interpretacion_n3_schoice_v1.Rmd \
  EST-INT-05

# Paso 3: Responder preguntas interactivas
# Título: Cálculo e Interpretación de Varianza
# Características:
#   - Pool de errores conceptuales
#   - Contextos narrativos variables
#   - Fórmulas LaTeX dinámicas
# Patrón útil para:
#   - Medidas de dispersión
#   - Interpretación estadística
#   - Cálculos con decimales

# Paso 4: Verificar entrada en CATALOGO.md
cat A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/CATALOGO.md | grep -A 20 "EST-INT-05"

# Paso 5: Commit
git add A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/
git commit -m "feat(ejemplos): Agregar EST-INT-05 - Cálculo e Interpretación de Varianza

- Archivo: estadistica_varianza_interpretacion_n3_schoice_v1.Rmd
- Características: Pool errores, contextos variables, LaTeX dinámico
- Patrón útil para: medidas de dispersión, interpretación estadística
"
```

---

## ✅ Resumen de Decisión

### SOURCES/ es para:
- ✅ Documentación compartida (anatomia-metacognitiva.md)
- ✅ Scripts de validación compartidos
- ✅ **Plantillas BASE** reutilizables (futuro)
- ✅ Pools de datos compartidos (futuro)
- ✅ Cualquier archivo que necesite sincronización automática vía symlinks

### Ejemplos-Funcionales-Rmd/ es para:
- ✅ Ejercicios .Rmd **COMPLETOS** validados
- ✅ Fuente de verdad para patrones de solución
- ✅ Consulta durante SUBFASE 3A
- ✅ Referencia para generar nuevos ejercicios
- ✅ Comparación durante revisión detractor

**NO hay overlap**: Son dos sistemas complementarios con propósitos distintos.

---

**Versión**: 1.0
**Fecha**: 2026-02-07
**Autor**: Sistema automatizado
**Decisión**: Usar Ejemplos-Funcionales-Rmd/ para ejercicios validados (copias directas), SOURCES/ para componentes compartidos (symlinks)
