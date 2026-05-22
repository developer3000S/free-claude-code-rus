# Ciclo de Validación y Corrección Automática

## OBLIGATORIO para todo archivo .Rmd

**⚠️ REGLA CRÍTICA: REPETIR CICLO DESPUÉS DE CADA CAMBIO**

Cada vez que se aplica CUALQUIER corrección o cambio al código:
1. **SIEMPRE** volver a renderizar
2. **SIEMPRE** mostrar preview visual al usuario
3. **SIEMPRE** verificar las 5 coherencias
4. **NUNCA** asumir que un cambio de código produjo el resultado esperado sin verificación visual

**Esto aplica a:**
- Cambios de posicionamiento (coordenadas, tamaños)
- Cambios de texto o etiquetas
- Cambios de formato o estilo
- Correcciones de cualquier tipo
- Ajustes solicitados por el usuario

---

## RESUMEN DEL CICLO COMPLETO

```
FASE 1: Renderizado (HTML/PDF/DOCX/NOPS)
    ↓
FASE 2A: Validación matemática [AUTOMÁTICA - hook]
    ↓
FASE 2B: Preview visual [AUTOMÁTICA - hook]
    ↓
FASE 2C: Revisión Detractor [OBLIGATORIA] ← NUEVO
    ↓
FASE 3: Decisión usuario (5 coherencias + aprobación)
```

---

## FASE 2A: VALIDACIÓN MATEMÁTICA AUTOMÁTICA (Hook PostToolUse)

**ACTIVACIÓN AUTOMÁTICA**: Después de cada `exams2*()` exitoso, el hook
`PostToolUse` en `settings.json` ejecuta automáticamente:

```
settings.json → PostToolUse(Bash) → post-exams2-validation.sh
  → validar_coherencia_matematica.R → APROBADO / ERRORES
```

**Qué valida automáticamente (SCHOICE y CLOZE):**
- Chunks R ejecutan sin errores en entorno aislado
- Metadatos completos (exname, extype, exsolution, ICFES 6 dimensiones)
- exshuffle = TRUE
- SCHOICE: exsolution binario, exactamente 1 correcta, longitud = opciones
- CLOZE: exclozetype/exsolution/extol consistentes, tipos válidos
- Variables numéricas sin NA/NaN/Inf
- Coherencia matemática entre variables (distancia = rapidez * tiempo, etc.)
- Sin funciones matemáticas sobre strings (ERR_C3)

**Si FASE 2A reporta ERRORES**: Claude DEBE corregir antes de continuar.
**Si FASE 2A reporta APROBADO**: Continuar con FASE 2B (inspección visual).

---

## FASE 2B: PREVIEW VISUAL AUTOMÁTICO (Hook PostToolUse)

**ACTIVACIÓN AUTOMÁTICA**: El mismo hook `post-exams2-validation.sh` que ejecuta
FASE 2A también genera automáticamente el preview visual:

```
post-exams2-validation.sh (después de FASE 2A APROBADO)
  → Busca PDF en output_pdf/, output/, dir=, cwd
  → magick -density 150 [pdf] -quality 90 preview_[nombre].png
  → Reporta rutas de PNGs generados
  → Emite instrucción OBLIGATORIA para Claude
```

**Qué hace automáticamente:**
- Localiza el PDF generado por exams2pdf()
- Convierte PDF → PNG con magick (150 DPI, calidad 90)
- Soporta múltiples páginas (genera preview_nombre-0.png, -1.png, etc.)
- Reporta las rutas completas de los PNGs generados

**Después de FASE 2B, Claude DEBE obligatoriamente:**
1. Ejecutar `Read()` sobre cada PNG reportado por el hook
2. Verificar las 5 coherencias VISUALMENTE
3. Documentar hallazgos con checklist
4. Solicitar aprobación del usuario

**Si no se encontró PDF**: El hook emite aviso para que Claude ejecute `exams2pdf()`.
Al ejecutar `exams2pdf()`, el hook se reactiva y genera el preview automáticamente.

---

## FASE 2C: REVISIÓN DETRACTOR (OBLIGATORIA)

**Regla detallada**: @.claude/rules/detractor-obligatorio.md

**ACTIVACIÓN**: Después de FASE 2B (preview visual), Claude DEBE ejecutar revisión detractor.

```
FASE 2B completada (preview visible)
    ↓
Claude ejecuta: /detractor auditoria [archivo.Rmd]
    ↓
Detractor revisa 4 dominios:
  - Código R-exams
  - Estructura pedagógica
  - Coherencia visual
  - Gramática/ortografía
    ↓
Genera reporte con objeciones (si hay)
    ↓
SI objeciones CRÍTICAS/ALTAS → Corregir → VOLVER A FASE 1
SI APROBAR → Continuar a FASE 3
```

### Qué Revisa el Detractor

| Dominio | Qué Valida | Fuentes de Verdad |
|---------|------------|-------------------|
| **Código** | exshuffle, exsolution, metadatos ICFES | R-exams docs, ejemplos locales |
| **Pedagógico** | Progressive Disclosure, metacognición, DOK/Bloom | ICFES 2026, Dunlosky, Schraw |
| **Visual** | Coherencia gráfico-texto, etiquetas, escalas | TikZ docs, estándares ICFES |
| **Gramática** | Tildes, redacción, terminología | RAE, diccionario local |

### Formato de Reporte FASE 2C

```markdown
## Revisión Detractor - [Nombre Ejercicio]

**Dominios revisados**: código | pedagógico | visual | gramática

### Objeciones Encontradas

[Lista de objeciones con formato estándar, o "Sin objeciones"]

### Veredicto

**Estado**: APROBAR | APROBAR CON CAMBIOS | RECHAZAR

### Próximos Pasos

[Acciones requeridas o "Continuar a FASE 3"]
```

### Bloqueos Automáticos

```
SI veredicto == RECHAZAR:
    BLOQUEAR avance a FASE 3
    MOSTRAR objeciones
    REQUERIR reescritura

SI veredicto == APROBAR CON CAMBIOS:
    MOSTRAR cambios requeridos
    APLICAR correcciones
    VOLVER A FASE 1 (re-renderizar)

SI veredicto == APROBAR:
    CONTINUAR a FASE 3
```

**⚠️ PROHIBIDO**: Omitir FASE 2C o ignorar objeciones críticas/altas.

---

Cada vez que se renderiza un archivo .Rmd, se ejecuta automáticamente:

### 🔄 FASE 1: RENDERIZADO INICIAL
```r
exams2html("archivo.Rmd", n = 1)
exams2pdf("archivo.Rmd", n = 1)
exams2pandoc("archivo.Rmd", n = 1, type = "docx")
exams2nops("archivo.Rmd", n = 1)
```
Capturar y registrar todos los errores/advertencias.

### 🔍 FASE 2: VALIDACIÓN AUTOMÁTICA + VISUAL ITERATIVA (OBLIGATORIA)

**⚠️ CRÍTICO: FASE 2A (matemática) y FASE 2B (preview PNG) son AUTOMÁTICAS vía hook.**
**Claude DEBE completar la inspección visual leyendo los PNGs generados.**

#### PASO 2.1: Preview generado automáticamente por el hook
```
El hook post-exams2-validation.sh ya convirtió PDF → PNG automáticamente.
Claude DEBE leer los PNGs reportados en la salida del hook:

Read("preview_[nombre]-0.png")  # Página 1
Read("preview_[nombre]-1.png")  # Página 2 (si existe)
...
```

#### PASO 2.2: Verificar las 5 coherencias VISUALMENTE

| # | Coherencia | Verificación VISUAL obligatoria |
|---|------------|--------------------------------|
| 1 | **Semántica** | ¿Texto legible? ¿Tildes correctas? ¿Gramática OK? |
| 2 | **Visual-Texto** | ¿Gráfico coincide con enunciado? ¿Valores sincronizados? |
| 3 | **Matemática** | ¿Fórmulas correctas? ¿Proporciones correctas? |
| 4 | **Código** | ¿Elementos dinámicos funcionan? ¿Datos cambian? |
| 5 | **General** | ¿Legible? ¿Estilo ICFES? ¿Opciones visibles? |

#### PASO 2.3: Documentar hallazgos

```markdown
## Revisión Visual Iteración [N]

### Coherencias verificadas:
- [ ] Semántica: [OK/Problema: descripción]
- [ ] Visual-Texto: [OK/Problema: descripción]
- [ ] Matemática: [OK/Problema: descripción]
- [ ] Código: [OK/Problema: descripción]
- [ ] General: [OK/Problema: descripción]

### Problemas detectados:
1. [Descripción del problema]
2. [Descripción del problema]

### Acción requerida:
- [ ] Ninguna - Pasar a FASE 3
- [ ] Corregir y volver a FASE 1
```

#### PASO 2.4: COMPARAR con imagen original (si aplica)

Si el ejercicio tiene gráfico basado en imagen ICFES original:
```bash
# Mostrar imagen original
Read("imagen_original.png")

# Mostrar imagen generada
Read("preview.png")

# OBLIGATORIO: Comparar visualmente y documentar diferencias
```

### ⚡ FASE 3: DECISIÓN Y ACCIÓN

**SI todas las coherencias OK** → Solicitar aprobación del usuario antes de continuar

**SI hay problemas detectados** → Ejecutar subfases OBLIGATORIAS:

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

#### 📊 SUBFASE 3C: Gestión de Resultados (Solo si éxito completo)

1. Documentar error y solución en `patrones-errores-conocidos.md`
2. Incluir código completo (antes/después)
3. Documentar ejemplo funcional utilizado
4. Referenciar archivo .Rmd verificado

## ⛔ CONDICIONES CRÍTICAS

- ❌ NO terminar con errores sin resolver
- ❌ NUNCA proceder con errores pendientes
- ❌ **NUNCA marcar como "completado" sin inspección visual REAL**
- ❌ **NUNCA asumir que "archivo existe" = "renderizado correcto"**
- ✓ Documentar SOLO después de confirmar solución
- ✓ Ejemplos funcionales = Fuente de verdad absoluta
- ✓ VOLVER A FASE 1 después de cada corrección
- ✓ **SIEMPRE mostrar preview.png al usuario antes de aprobar**
- ✓ **SIEMPRE documentar las 5 coherencias con checklist**

## 🔁 PROCESO ITERATIVO OBLIGATORIO

```
┌─────────────────────────────────────────────────────────┐
│  ITERACIÓN N                                            │
├─────────────────────────────────────────────────────────┤
│  1. FASE 1: Renderizar (HTML, PDF, DOCX, NOPS)         │
│  2. FASE 2A: [AUTOMÁTICO] Validación matemática (.R)   │
│     └── Si ERRORES → Corregir → VOLVER A ITERACIÓN N+1 │
│  3. FASE 2B: [AUTOMÁTICO] PDF → PNG (magick)           │
│  4. Claude: Read() cada PNG generado                    │
│  5. Claude: Verificar 5 coherencias VISUALMENTE         │
│  6. FASE 2C: [OBLIGATORIO] /detractor auditoria        │
│     └── Si CRÍTICAS/ALTAS → Corregir → VOLVER N+1      │
│  7. Claude: Documentar hallazgos con checklist          │
│  8. FASE 3: ¿Problemas detectados?                      │
│     │                                                   │
│     ├── SÍ → Corregir → VOLVER A ITERACIÓN N+1         │
│     │                                                   │
│     └── NO → Solicitar aprobación usuario               │
│              │                                          │
│              ├── Usuario aprueba → FIN ✅               │
│              │                                          │
│              └── Usuario rechaza → VOLVER A ITERACIÓN   │
└─────────────────────────────────────────────────────────┘
```

## ❌ ANTIPATRONES PROHIBIDOS

### 1. Validación "ciega" (PROHIBIDO)
```r
# ❌ INCORRECTO - Solo verificar que el archivo existe
exams2pdf("archivo.Rmd", n = 1)
# "El PDF se generó correctamente" ← INSUFICIENTE
```

### 2. Asumir éxito sin inspección (PROHIBIDO)
```markdown
# ❌ INCORRECTO
"Los 3 formatos se generaron correctamente. Ejercicio completado."
# ← NO se mostró ninguna imagen, NO se verificaron coherencias
```

### 3. Saltarse comparación visual (PROHIBIDO)
```markdown
# ❌ INCORRECTO - Ejercicio con gráfico
"El gráfico se generó." ← Sin comparar con original
```

### 4. Lenguaje minimizador en reportes de validación (PROHIBIDO)
```markdown
# ❌ INCORRECTO - Minimiza problemas con calificadores
"Problemas detectados: Ninguno significativo"
"Sin objeciones significativas"
"Diferencias: Ninguna significativa"

# ✅ CORRECTO - Reportar con precisión absoluta
"Problemas detectados: Ninguno"          # Si realmente hay CERO problemas
"Problemas detectados:"                  # Si hay problemas, listar CADA UNO
"  1. [descripción exacta del problema]"
"  2. [descripción exacta del problema]"

# ✅ CORRECTO - Si hubo problemas corregidos en iteraciones previas, listarlos
"Problemas encontrados y corregidos en esta sesión:"
"  1. [problema] → [fix aplicado]"
"  2. [problema] → [fix aplicado]"
"Estado actual: Todos los problemas resueltos"
```

**Razón**: El calificador "significativo" es subjetivo y permite que bugs reales pasen
desapercibidos. En la sesión 2026-02-27, "Ninguno significativo" ocultó 3 bugs que el
usuario tuvo que descubrir posteriormente:
- Corrupción de RNG por test de diversidad (2/50 versiones únicas)
- ##ANSWER1## mal ubicado en CLOZE (opciones después de Parte 2)
- Crash por NA en comparación while (calcula() retorna NA)

**Regla**: NUNCA usar "significativo", "relevante", "importante" como calificador para
minimizar hallazgos. Reportar TODOS los hallazgos, sin excepción.

## ✅ PATRÓN CORRECTO

```markdown
## Ciclo de Validación - Iteración 1

### FASE 1: Renderizado
- HTML: ✅ plain1.html (XXkb)
- PDF: ✅ plain1.pdf (XXkb)
- DOCX: ✅ pandoc1.docx (XXkb)

### FASE 2: Inspección Visual + Detractor

[Imagen preview.png mostrada aquí]

#### Coherencias verificadas:
- [x] Semántica: Texto legible, tildes correctas
- [x] Visual-Texto: Gráfico coincide con enunciado, valores correctos
- [x] Matemática: Fórmulas correctas, cálculos verificados
- [x] Código: Elementos dinámicos funcionando (contexto: parque natural, precios: $27,5/$20)
- [x] General: Legible, estilo ICFES, opciones visibles

#### Comparación con original (si aplica):
[Imagen original mostrada]
[Imagen generada mostrada]
Diferencias: Ninguna / [Lista EXHAUSTIVA de diferencias]

#### Revisión Detractor (FASE 2C):
- Dominios revisados: código | pedagógico | visual | gramática
- Objeciones: Ninguna
- Veredicto: APROBAR

### FASE 3: Decisión
✅ Todas las coherencias OK + Detractor APROBADO - Solicitar aprobación del usuario

**¿Aprueba este ejercicio?**
```

---

**Versión**: 5.0 (Antipatrón Lenguaje Minimizador + Validación CLOZE)
**Fecha**: 2026-02-27
**Cambio v5.0**: Antipatrón #4 (lenguaje minimizador PROHIBIDO), patrón correcto sin calificadores subjetivos
**Cambio v4.0**: FASE 2C (Detractor) es OBLIGATORIA - revisión adversarial en 4 dominios
**Cambio v3.0**: FASE 2A (matemática) y FASE 2B (preview visual) son AUTOMÁTICAS vía hook PostToolUse
**Cambio v2.0**: FASE 2 requiere inspección visual REAL con imagen mostrada
