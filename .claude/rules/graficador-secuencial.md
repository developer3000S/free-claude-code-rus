# Regla: Workflow Secuencial del Graficador Experto

## Principio Fundamental

**SIEMPRE se generan las TRES versiones gráficas (TikZ, Python, R) de forma SECUENCIAL con iteraciones AUTOMÁTICAS hasta alcanzar ≥98% de fidelidad. El USUARIO SIEMPRE decide cuál versión usar al final.**

Claude NO puede decidir qué lenguaje usar. Claude NO puede omitir ningún lenguaje. Las tres opciones SIEMPRE se presentan al usuario.

---

## Reglas Críticas (SIN EXCEPCIONES)

### 1. SIEMPRE generar los tres lenguajes

```
❌ PROHIBIDO: "Usaré ggplot2 porque es más simple"
❌ PROHIBIDO: "TikZ es mejor para este caso, omitiré Python"
❌ PROHIBIDO: Generar solo uno o dos lenguajes

✅ OBLIGATORIO: Generar TikZ → Python → R (los tres, siempre)
```

### 2. Umbral de fidelidad: 98%

```
❌ PROHIBIDO: Detener iteraciones con similitud < 98%
❌ PROHIBIDO: Aceptar "95% es suficiente"

✅ OBLIGATORIO: Iterar AUTOMÁTICAMENTE hasta ≥98% de similitud
✅ OBLIGATORIO: Máximo 10 iteraciones por lenguaje antes de escalar
```

### 3. Usuario SIEMPRE decide

```
❌ PROHIBIDO: Claude selecciona el lenguaje final
❌ PROHIBIDO: Asumir preferencia del usuario

✅ OBLIGATORIO: Presentar tabla comparativa de los 3 lenguajes
✅ OBLIGATORIO: Esperar selección explícita del usuario
```

---

## Orden Obligatorio

```
1. TikZ (dinámico desde R)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud
   ↓ Verificar 5 coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
2. Python (vía reticulate)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud
   ↓ Verificar 5 coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
3. R (nativo ggplot2)
   ↓ Iterar AUTOMÁTICAMENTE hasta ≥98% similitud
   ↓ Verificar 5 coherencias
   ↓ Mostrar resultado (NO pedir aprobación intermedia)
   ↓
4. PRESENTAR LAS 3 OPCIONES AL USUARIO
   ↓ Tabla comparativa con similitud, ventajas, código
   ↓ USUARIO SELECCIONA cuál usar
   ↓
5. Generar .Rmd con versión seleccionada por usuario
```

---

## Proceso Detallado por Lenguaje

### FASE 1: TikZ (Dinámico desde R)

**Paso 1.1: Generación inicial**

```
- Analizar imagen original
- Generar código TikZ integrado con R (NO estático)
- El código R debe generar coordenadas/datos dinámicamente
- TikZ se construye con paste0() interpolando variables R
```

**Paso 1.2: Iteración AUTOMÁTICA hasta 98%**

```r
# Pseudocódigo del proceso automático
similitud <- 0
iteracion <- 1
max_iteraciones <- 10

while(similitud < 98 && iteracion <= max_iteraciones) {
  # Renderizar versión actual
  renderizar_tikz(version = iteracion)

  # Comparar con original
  similitud <- comparar_imagenes(original, generada)

  # Si no alcanza 98%, refinar automáticamente
  if(similitud < 98) {
    ajustes <- identificar_diferencias(original, generada)
    aplicar_correcciones(ajustes)
    iteracion <- iteracion + 1
  }
}

# Registrar resultado
tikz_resultado <- list(
  similitud_final = similitud,
  iteraciones = iteracion,
  codigo = codigo_final
)
```

**Paso 1.3: Verificación de coherencias (automática)**

```markdown
### Coherencias TikZ v[N] - Similitud: [X]%

1. Semántica: [OK/Problema]
2. Visual-Texto: [OK/Problema]
3. Matemática: [OK/Problema]
4. Código: [OK/Problema]
5. General: [OK/Problema]
```

**NO pedir aprobación. Continuar automáticamente a Python.**

### FASE 2: Python (vía reticulate)

**Mismo proceso que TikZ:**

- Iteración automática hasta ≥98%
- Verificación de coherencias
- NO pedir aprobación intermedia
- Continuar automáticamente a R

### FASE 3: R (nativo ggplot2)

**Mismo proceso:**

- Iteración automática hasta ≥98%
- Verificación de coherencias
- NO pedir aprobación intermedia

### FASE 4: Presentación al Usuario (OBLIGATORIA)

```markdown
## Selección de Versión Gráfica

Las TRES versiones han sido generadas y validadas:

| Lenguaje | Similitud | Iteraciones | Ventajas | Desventajas |
|----------|-----------|-------------|----------|-------------|
| TikZ     | 98.5%     | 4           | Tipografía LaTeX, escalable vectorial | Requiere compilación LaTeX |
| Python   | 98.2%     | 3           | Flexible, matplotlib familiar | Dependencia reticulate |
| R        | 99.1%     | 2           | Nativo R-exams, sin dependencias | Menos control tipográfico |

### Previews Generados

[Mostrar imagen TikZ]
[Mostrar imagen Python]
[Mostrar imagen R]

### Código Generado (resumen)

**TikZ**: [líneas de código]
**Python**: [líneas de código]
**R**: [líneas de código]

---

**¿Cuál versión desea usar para el archivo .Rmd final?**

1. TikZ
2. Python
3. R
```

**ESPERAR respuesta del usuario antes de continuar.**

---

## Estados del Workflow

```json
{
  "fase_actual": "tikz_auto|python_auto|r_auto|seleccion_usuario|completado",
  "umbral_fidelidad": 98,
  "max_iteraciones": 10,
  "tikz": {
    "estado": "pendiente|iterando|completado",
    "version_actual": 0,
    "similitud_final": 0,
    "iteraciones_totales": 0,
    "coherencias_ok": false
  },
  "python": {
    "estado": "bloqueado|pendiente|iterando|completado",
    "version_actual": 0,
    "similitud_final": 0,
    "iteraciones_totales": 0,
    "coherencias_ok": false
  },
  "r": {
    "estado": "bloqueado|pendiente|iterando|completado",
    "version_actual": 0,
    "similitud_final": 0,
    "iteraciones_totales": 0,
    "coherencias_ok": false
  },
  "seleccion_usuario": null,
  "usuario_decidio": false
}
```

---

## Reglas de Transición

```
tikz.estado == "completado" → python.estado = "pendiente"
python.estado == "completado" → r.estado = "pendiente"
r.estado == "completado" → fase_actual = "seleccion_usuario"
usuario_decidio == true → fase_actual = "completado"
```

---

## Prohibiciones Absolutas

### PROHIBIDO: Decidir por el usuario

```
# ❌ INCORRECTO
"Recomiendo usar R porque tiene mejor similitud"
→ Generar .Rmd con R sin preguntar

# ✅ CORRECTO
"Las tres versiones están listas. ¿Cuál prefiere usar?"
→ Esperar selección explícita
```

### PROHIBIDO: Omitir lenguajes

```
# ❌ INCORRECTO
"Para este gráfico simple, solo generaré ggplot2"

# ✅ CORRECTO
Generar TikZ → Python → R (siempre los tres)
```

### PROHIBIDO: Detener antes de 98%

```
# ❌ INCORRECTO
if similitud >= 95:
    marcar_completado()

# ✅ CORRECTO
while similitud < 98 && iteraciones < 10:
    refinar_automaticamente()
```

### PROHIBIDO: Pedir aprobación intermedia

```
# ❌ INCORRECTO
"TikZ alcanzó 98%. ¿Aprueba para continuar con Python?"

# ✅ CORRECTO
Continuar automáticamente a Python sin preguntar
Solo preguntar al final: "¿Cuál versión usar?"
```

---

## Manejo de Errores

### Si un lenguaje no alcanza 98% en 10 iteraciones

```markdown
⚠️ ADVERTENCIA: TikZ alcanzó máximo 94.5% en 10 iteraciones

**Opciones:**
1. Continuar con Python/R (puede que logren mejor similitud)
2. Revisar imagen original (posible complejidad excesiva)
3. Ajustar manualmente el código TikZ

¿Desea continuar con los otros lenguajes?
```

### Si ningún lenguaje alcanza 98%

```markdown
⚠️ NINGÚN LENGUAJE ALCANZÓ 98%

| Lenguaje | Mejor similitud |
|----------|-----------------|
| TikZ     | 94.5%           |
| Python   | 96.2%           |
| R        | 95.8%           |

**Recomendación:** Revisar la complejidad de la imagen original.

¿Desea:
1. Usar la mejor versión disponible (Python 96.2%)
2. Continuar refinando manualmente
3. Simplificar el gráfico original
```

---

## Verificación de Coherencias (Las 5)

Para CADA lenguaje, verificar automáticamente:

### 1. Coherencia Semántica

- [ ] Etiquetas de ejes sin errores ortográficos
- [ ] Leyendas correctamente escritas
- [ ] Números con formato apropiado

### 2. Coherencia Visual-Texto

- [ ] Gráfico coincide con descripción del enunciado
- [ ] Valores visuales coinciden con valores mencionados
- [ ] Escalas apropiadas según el contexto

### 3. Coherencia Matemática

- [ ] Fórmulas/ecuaciones correctas
- [ ] Proporciones geométricas correctas
- [ ] Relaciones matemáticas preservadas

### 4. Coherencia de Código

- [ ] Código genera gráfico dinámicamente (no hardcoded)
- [ ] Variables R se interpolan correctamente
- [ ] Compatible con R-exams
- [ ] Diferentes semillas generan gráficos válidos

### 5. Coherencia General

- [ ] Gráfico legible (tamaño de fuente adecuado)
- [ ] Estilo visual apropiado para examen ICFES
- [ ] Calidad de imagen suficiente

---

## Integración con Skills

### /auto-refinar-grafico (actualizado)

```
/auto-refinar-grafico
  → Ejecuta TikZ automático hasta 98%
  → Ejecuta Python automático hasta 98%
  → Ejecuta R automático hasta 98%
  → Presenta las 3 opciones al usuario
  → Usuario selecciona
  → Genera .Rmd
```

### /estado-graficador

```
Muestra estado actual del workflow:
- Lenguaje actual
- Similitud alcanzada
- Iteraciones realizadas
- Lenguajes pendientes
```

---

## Ejemplo de Flujo Completo

```
Usuario: /auto-refinar-grafico

Claude: Iniciando Graficador Experto (umbral: 98%)

=== FASE 1: TikZ ===
Iteración 1: 78% → Ajustando escalas...
Iteración 2: 89% → Corrigiendo etiquetas...
Iteración 3: 95% → Refinando posiciones...
Iteración 4: 98.2% ✓

Coherencias TikZ: ✓ Semántica ✓ Visual ✓ Matemática ✓ Código ✓ General

=== FASE 2: Python ===
Iteración 1: 82% → Ajustando matplotlib...
Iteración 2: 94% → Corrigiendo colores...
Iteración 3: 98.5% ✓

Coherencias Python: ✓ Semántica ✓ Visual ✓ Matemática ✓ Código ✓ General

=== FASE 3: R ===
Iteración 1: 91% → Ajustando ggplot2...
Iteración 2: 99.1% ✓

Coherencias R: ✓ Semántica ✓ Visual ✓ Matemática ✓ Código ✓ General

=== SELECCIÓN FINAL ===

| Lenguaje | Similitud | Iteraciones |
|----------|-----------|-------------|
| TikZ     | 98.2%     | 4           |
| Python   | 98.5%     | 3           |
| R        | 99.1%     | 2           |

[Preview TikZ] [Preview Python] [Preview R]

¿Cuál versión desea usar para el .Rmd?

Usuario: R

Claude: Generando .Rmd con versión R (99.1% similitud)...
```

---

**Versión**: 2.0
**Fecha**: 2026-02-07
**Cambios v2.0**:

- Umbral aumentado de 95% a 98%
- Iteraciones AUTOMÁTICAS (sin aprobación intermedia)
- SIEMPRE generar los 3 lenguajes (sin excepciones)
- Usuario SIEMPRE decide la versión final
- Claude NO puede elegir el lenguaje
