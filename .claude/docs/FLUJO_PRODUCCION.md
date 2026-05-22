# Flujo de Producción de Ejercicios

## 📁 Estructura REAL del Sistema

```
A-Produccion/
│
├── 01-En-PreDesarrollo/              # Experimentación inicial
│   └── Lab-Manjaro/                  # Laboratorio, bocetos, pruebas
│       ├── 50/
│       ├── 06-S2-2025-SEDQ/
│       └── [otros experimentos]/
│
├── 02-En-Desarrollo/                 # Ejercicios en validación
│   └── [nombre_ejercicio]/           # Cada ejercicio en su carpeta
│       ├── [ejercicio].Rmd           # Archivo principal
│       ├── output_pdf/               # Salidas de validación
│       ├── output_html/
│       ├── output_docx/
│       └── output_nops/
│
├── 03-En-Produccion/                 # Ejercicios validados
│   ├── 01-Numeros-Reales/
│   │   └── Pensamiento-Numerico/
│   ├── 02-Funciones/
│   │   └── Pensamiento-Variacional-Espacial/
│   ├── 03-Razones-Trigonometricas/
│   │   └── Pensamiento-Espacial-Metrico-Y-Variacional/
│   ├── 04-Funciones_Identidades-Trigonometricas/
│   │   └── Pensamiento-Espacial-Y-Variacional/
│   ├── 05-Geometría/
│   │   └── Pensamiento-Espacial/
│   ├── 06-Estadística-Y-Probabilidad/
│   │   └── Pensamiento-Aleatorio/
│   └── Ejemplos-Funcionales-Rmd/     # ← Biblioteca de referencia
│       ├── README.md                 # Guía técnica
│       ├── CATALOGO.md               # Índice searchable
│       ├── [Ejercicios .Rmd]         # Copias de los mejores
│       ├── Avances-Pedagogicos/      # Subdirectorios especiales
│       ├── oficial-schoice/
│       └── Plantillas/
│
└── perifericos/                      # Utilidades externas
```

---

## 🔄 Flujo Completo de Desarrollo

### FASE 1: Experimentación (01-En-PreDesarrollo/)

```
Usuario tiene idea de ejercicio
    ↓
Experimentos en Lab-Manjaro/
    ↓
Bocetos, pruebas iniciales
    ↓
NO hay validación formal aquí
```

**Características**:
- ✅ Espacio libre para experimentar
- ✅ Sin estructura obligatoria
- ✅ Múltiples versiones/intentos
- ❌ NO se valida formalmente
- ❌ NO se promociona directamente a producción

---

### FASE 2: Desarrollo y Validación (02-En-Desarrollo/)

```
Idea validada de PreDesarrollo o generada con skills
    ↓
/generar-schoice o /generar-cloze
    ↓
Crea directorio en 02-En-Desarrollo/[nombre]/
    │
    ├── [ejercicio].Rmd
    ├── output_pdf/
    ├── output_html/
    ├── output_docx/
    └── output_nops/
    ↓
CICLO DE VALIDACIÓN (OBLIGATORIO)
    ↓
FASE 1: Renderizado en 4 formatos
FASE 2A: Validación matemática automática [hook]
FASE 2B: Preview visual automático [hook]
FASE 2C: Revisión detractor OBLIGATORIA
FASE 3: Aprobación del usuario
    ↓
Ejercicio VALIDADO queda en 02-En-Desarrollo/
```

**Características**:
- ✅ Estructura obligatoria (carpeta por ejercicio)
- ✅ Validación completa (FASE 1→2A→2B→2C→3)
- ✅ Outputs organizados en subdirectorios
- ✅ Ejercicio listo para usar

**⚠️ IMPORTANTE**: Ejercicios en `02-En-Desarrollo/` YA ESTÁN VALIDADOS y son funcionales. Pueden usarse en producción sin mover a `03-En-Produccion/`.

---

### FASE 3A: Promoción a Producción (Opcional)

```
Ejercicio validado en 02-En-Desarrollo/
    ↓
/promover-ejercicio (opcional)
    ↓
Seleccionar tema:
  - 01-Numeros-Reales
  - 02-Funciones
  - 03-Razones-Trigonometricas
  - etc.
    ↓
Mover a: 03-En-Produccion/[Tema]/Pensamiento-XXX/
    ↓
Ejercicio organizado por tema
```

**Características**:
- ✅ Organización por tema
- ✅ Facilita búsqueda temática
- ❌ NO es obligatorio (ejercicio ya está validado en 02-En-Desarrollo/)

**¿Cuándo promocionar?**
- Cuando quieras organizar ejercicios por tema
- Cuando tengas múltiples ejercicios del mismo tema
- Para mantener orden en el repositorio

---

### FASE 3B: Agregar a Ejemplos Funcionales (Selectivo)

```
Ejercicio validado (desde 02-En-Desarrollo/ o 03-En-Produccion/)
    ↓
¿Representa patrón útil para futuros ejercicios?
    ↓ SI
Copiar .Rmd a Ejemplos-Funcionales-Rmd/
    ↓
Agregar entrada a CATALOGO.md
    ↓
Actualizar README.md si es necesario
    ↓
Commit con mensaje descriptivo
```

**Criterios de inclusión**:
- ✅ Implementa patrón técnico reutilizable
- ✅ Ejemplo de buenas prácticas
- ✅ Soluciona error común de forma ejemplar
- ✅ Ha sido usado exitosamente en producción

**NO incluir si**:
- ❌ Características muy específicas/únicas
- ❌ No aporta nuevos patrones al catálogo
- ❌ Es ejercicio experimental

---

## 📋 Resumen de Directorios

| Directorio | Propósito | ¿Validado? | ¿Funcional? | ¿Organizado? |
|------------|-----------|------------|-------------|--------------|
| **01-En-PreDesarrollo/** | Experimentación | ❌ No | ❌ No | ❌ No |
| **02-En-Desarrollo/** | Validación | ✅ Sí | ✅ Sí | ❌ No (por nombre) |
| **03-En-Produccion/[Tema]/** | Producción | ✅ Sí | ✅ Sí | ✅ Sí (por tema) |
| **03-En-Produccion/Ejemplos-Funcionales-Rmd/** | Referencia | ✅ Sí | ✅ Sí | ✅ Sí (por patrón) |

---

## 🎯 Casos de Uso

### Caso 1: Generar Nuevo Ejercicio

```bash
# 1. Generar ejercicio
/generar-schoice  # o /generar-cloze

# 2. El ejercicio se crea en:
A-Produccion/02-En-Desarrollo/[nombre_ejercicio]/[ejercicio].Rmd

# 3. Pasar por ciclo de validación (FASE 1-2-3)

# 4. Ejercicio listo para usar (ya está en 02-En-Desarrollo/)

# 5. (Opcional) Promocionar a tema específico
/promover-ejercicio → Seleccionar tema → Mueve a 03-En-Produccion/[Tema]/

# 6. (Selectivo) Si es ejemplo funcional útil
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/02-En-Desarrollo/[ejercicio]/[ejercicio].Rmd \
  EST-INT-05
```

---

### Caso 2: Consultar Ejemplo Funcional

```bash
# 1. Tengo error en ejercicio nuevo

# 2. Buscar en catálogo
cat A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/CATALOGO.md

# 3. Encontrar ejercicio similar
grep "Gráficos como opciones" CATALOGO.md

# 4. Abrir ejercicio de referencia
code A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/estadistica_diagramas_caja_*.Rmd

# 5. Aplicar mismo patrón al ejercicio con error
```

---

### Caso 3: Experimentar con Idea Nueva

```bash
# 1. Crear en PreDesarrollo
mkdir A-Produccion/01-En-PreDesarrollo/Lab-Manjaro/mi_experimento/

# 2. Experimentar libremente (sin validación formal)

# 3. Cuando la idea esté clara, generar ejercicio formal
/generar-schoice  # Se crea en 02-En-Desarrollo/

# 4. Validar formalmente (FASE 1-2-3)
```

---

## 📊 Estadísticas de Ubicaciones

### ¿Dónde están los ejercicios funcionales?

1. **02-En-Desarrollo/** → Ejercicios validados recientes
2. **03-En-Produccion/[Tema]/** → Ejercicios validados organizados por tema
3. **03-En-Produccion/Ejemplos-Funcionales-Rmd/** → Copias de los mejores (referencia)

### ¿Dónde buscar al corregir errores?

1. **Ejemplos-Funcionales-Rmd/CATALOGO.md** → Índice de patrones validados
2. **Ejemplos-Funcionales-Rmd/[ejercicio].Rmd** → Código de referencia
3. **.claude/docs/patrones-errores-conocidos.md** → Errores y soluciones

---

## ⚙️ Comandos Útiles

### Listar ejercicios en desarrollo

```bash
ls -la A-Produccion/02-En-Desarrollo/
```

### Listar ejercicios en producción por tema

```bash
ls -la A-Produccion/03-En-Produccion/06-Estadística-Y-Probabilidad/Pensamiento-Aleatorio/
```

### Buscar ejercicios validados

```bash
# En desarrollo
find A-Produccion/02-En-Desarrollo/ -name "*.Rmd"

# En producción
find A-Produccion/03-En-Produccion/ -name "*.Rmd" -not -path "*/Ejemplos-Funcionales-Rmd/*"

# En ejemplos funcionales
find A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/ -maxdepth 1 -name "*.Rmd"
```

### Copiar ejercicio a Ejemplos Funcionales

```bash
# Desde En-Desarrollo
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/02-En-Desarrollo/mi_ejercicio/mi_ejercicio.Rmd \
  EST-INT-05

# Desde En-Produccion (ya organizado)
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/03-En-Produccion/06-Estadística-Y-Probabilidad/Pensamiento-Aleatorio/mi_ejercicio.Rmd \
  EST-INT-05
```

---

## 🚨 Errores Comunes

### ❌ Error 1: "¿Dónde van los ejercicios validados?"

**Problema**: La documentación antigua mencionaba `Nuevos-Ejercicios/`

**Solución**: Los ejercicios validados se promueven a `03-En-Produccion/[categoría ICFES]/`

---

### ❌ Error 2: "¿Debo mover a 03-En-Produccion/?"

**Problema**: Confusión sobre si es obligatorio

**Solución**: NO es obligatorio. `02-En-Desarrollo/` ya contiene ejercicios validados funcionales. Mover a `03-En-Produccion/` es OPCIONAL para organizar por tema.

---

### ❌ Error 3: "¿Cuándo agregar a Ejemplos-Funcionales-Rmd/?"

**Problema**: Confusión sobre criterios de inclusión

**Solución**: SOLO si el ejercicio representa un **patrón útil** para futuros ejercicios. Es SELECTIVO, no para todos los ejercicios.

---

## 📖 Referencias

- **Estrategia completa**: `.claude/docs/ESTRATEGIA_EJEMPLOS_FUNCIONALES.md`
- **Guía técnica ejemplos**: `A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/README.md`
- **Catálogo de ejemplos**: `A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/CATALOGO.md`
- **Ciclo de validación**: `.claude/rules/ciclo-validacion.md`
- **Promoción de ejercicios**: `/promover-ejercicio` skill

---

**Versión**: 1.0
**Fecha**: 2026-02-07
**Propósito**: Aclarar estructura REAL del sistema y flujo de producción
