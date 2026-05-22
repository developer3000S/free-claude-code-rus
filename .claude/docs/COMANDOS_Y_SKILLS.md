# Comandos y Skills del Sistema

## 📋 Índice

1. [Comandos Manuales (Slash Commands)](#comandos-manuales-slash-commands)
2. [Skills Automáticos](#skills-automáticos)
3. [Referencia Rápida](#referencia-rápida)

---

## Comandos Manuales (Slash Commands)

**Invocación**: El usuario debe ejecutarlos explícitamente con `/nombre-comando`

### Workflow Principal

#### `/analizar-icfes`
**Propósito**: Iniciar análisis de imagen ICFES para clasificación multidimensional

**Uso**:
```bash
/analizar-icfes
```

**Qué hace**:
1. Solicita imagen del ejercicio ICFES
2. Analiza según las 6 dimensiones ICFES:
   - Competencia (Interpretación/Formulación/Argumentación)
   - Componente (Aleatorio/Cambio/Datos/Espacial/Medida)
   - Afirmación
   - Evidencia
   - Nivel (1-4)
   - Tipo (SCHOICE/CLOZE)
3. Detecta si requiere gráficos (activa Flujo B si aplica)
4. Genera reporte de análisis completo

**Output**: Archivo JSON con clasificación multidimensional

---

#### `/orquestador-schoice` 🆕
**Propósito**: Pipeline end-to-end de generación SCHOICE (11 pasos, 3 pausas humanas)

**Uso**:
```bash
# JSON completo (recomendado)
/orquestador-schoice {"ruta_destino":"A-Produccion/01-En-PreDesarrollo/mi-ejercicio","nombre_ejercicio":"mediana_metacognitivo_argumentacion_n3_schoice_v1","entrada":"<ruta-imagen-o-texto>","modo":"ejecutar"}

# Modo dry-run (audita sin ejecutar)
/orquestador-schoice {"ruta_destino":"...","nombre_ejercicio":"...","entrada":"...","modo":"dry-run"}

# Forma corta (texto libre)
/orquestador-schoice mediana n3 desde imagen.png en 01-En-PreDesarrollo/mediana-v1
```

**Qué hace** (12 pasos secuenciales):
0. `workflow-state.sh init` — Inicializa estado del ejercicio
1. Clasificación ICFES 6D + 8D (sub-agente ClasificadorICFES, Haiku)
2. **WAIT_USER #1** — ¿Requiere gráficos? (Flujo B)
3. (si sí) Genera TikZ → Python → R hasta ≥98% similitud
4. **WAIT_USER #2** — Usuario elige lenguaje gráfico
5. Genera `.Rmd` SCHOICE metacognitivo (Opus inline)
6. Genera Solution con justificación + análisis diagnóstico (Opus inline)
7. Renderizado 4 formatos (HTML/PDF/DOCX/NOPS)
8. Arsenal post-render automático (FASES 2A-2H)
9. Detractor FASE 2C (sub-agente AgenteDetractor, Opus)
10. Validación visual 5 coherencias (sub-agente ValidadorVisual, Sonnet)
11. Diversidad 250+ versiones únicas
12. Validación ICFES + metadatos
13. **WAIT_USER #3** — Aprobación final

**Características**:
- Soporta reanudación desde último paso pendiente (si `ejercicio_state.json` existe)
- Política de auto-corrección (3 reintentos por fase, luego escala a Diagnosticador)
- 3 únicos puntos de interacción humana (Flujo B, lenguaje gráfico, aprobación)
- Tope: 60 turnos (reserva 55-60 para reporte final)
- Respeta estrictamente 19 reglas críticas

**Modelo**: Opus (orquestador) | **Agente**: `.claude/agents/orquestador-schoice.md` | **Comando**: `.claude/commands/orquestador-schoice.md`

---

#### `/orquestador-cloze` 🆕
**Propósito**: Pipeline end-to-end de generación CLOZE (11 pasos, 3 pausas humanas, 4+ partes Progressive Disclosure)

**Uso**:
```bash
# JSON completo (recomendado)
/orquestador-cloze {"ruta_destino":"A-Produccion/01-En-PreDesarrollo/mi-ejercicio","nombre_ejercicio":"promedios_metacognitivo_argumentacion_n3_cloze_v1","entrada":"<ruta-imagen-o-texto>","modo":"ejecutar"}

# Modo dry-run (audita sin ejecutar)
/orquestador-cloze {"ruta_destino":"...","nombre_ejercicio":"...","entrada":"...","modo":"dry-run"}

# Forma corta
/orquestador-cloze promedios n3 cloze desde enunciado en 01-En-PreDesarrollo/promedios-v1
```

**Qué hace** (12 pasos secuenciales):
0. `workflow-state.sh init` — Inicializa estado (tipo: cloze)
1. Clasificación ICFES + determinar estructura Progressive Disclosure (4+ partes)
2. **Validación previa CLOZE (V1-V4)**: mín. 4 partes, tipos de gap válidos, exclozetype consistente
3. **WAIT_USER #1** — ¿Requiere gráficos? (Flujo B)
4. (si sí) Genera TikZ → Python → R hasta ≥98% similitud
5. **WAIT_USER #2** — Usuario elige lenguaje gráfico
6. Genera `.Rmd` CLOZE metacognitivo con 4+ partes (Opus inline)
7. Genera Solution multi-parte con análisis por gap (Opus inline)
8. Renderizado 3 formatos (HTML/PDF/DOCX; NOPS: N/A si num/string gaps)
9. Arsenal post-render + validaciones CLOZE (exclozetype, ##ANSWERi##)
10. Detractor FASE 2C con énfasis CLOZE (sub-agente AgenteDetractor, Opus)
11. Validación visual 5 coherencias + gaps en posición (sub-agente ValidadorVisual, Sonnet)
12. Diversidad 250+ versiones únicas (sobre combinación de partes)
13. Validación ICFES + exclozetype + DOK≥3
14. **WAIT_USER #3** — Aprobación final

**Diferencias clave vs SCHOICE**:
| Aspecto | SCHOICE | CLOZE |
|---------|---------|-------|
| Partes | 1 gap | 4+ gaps (schoice\|num\|mchoice\|schoice) |
| Nivel mínimo | n2 | n3 |
| DOK mínimo | 2 | 3 |
| NOPS | OK | N/A si num/string gaps (esperado) |
| Diversidad | Por versión | Combinación de todas las partes |
| Turnos máx. | 60 | 65 (+5 por complejidad multi-parte) |

**Modelo**: Opus (orquestador) | **Agente**: `.claude/agents/orquestador-cloze.md` | **Comando**: `.claude/commands/orquestador-cloze.md`

---

#### `/revisar-schoice` 🆕
**Propósito**: Revisar ejercicio SCHOICE existente ejecutando pasos 4-11 del workflow

**Uso**:
```bash
/revisar-schoice [ruta-al-archivo.Rmd]
```

**Requisitos previos**:
- Archivo .Rmd SCHOICE ya generado (pasos 1-3 completados)

**Qué hace** (pasos 4-11 secuenciales):
4. `/skill-retroalimentacion` — Solution científica
5. Renderizado 4 formatos (HTML/PDF/DOCX/NOPS)
6. Arsenal post-render automático (FASES 2A-2H)
7. `/adversario` — Detractor FASE 2C
8. Documenta 5 coherencias visualmente
9. `/validar-diversidad` — 250+ versiones únicas
10. `/validar-icfes` — metadatos y estructura
11. Aprobación usuario

Detecta automáticamente en qué paso quedó el workflow y retoma desde ahí. Todos los pasos registran progreso via `workflow-state.sh complete`.

---

#### `/revisar-cloze` 🆕
**Propósito**: Revisar ejercicio CLOZE existente ejecutando pasos 4-11 del workflow

**Uso**:
```bash
/revisar-cloze [ruta-al-archivo.Rmd]
```

**Requisitos previos**:
- Archivo .Rmd CLOZE ya generado (pasos 1-3 completados)

**Qué hace**:
- **Validación previa CLOZE**: mín. 4 partes, ##ANSWERi## en orden, exclozetype consistente
- **Pasos 4-11**: idénticos a `/revisar-schoice` con validaciones CLOZE-específicas
- NOPS falla con gaps num/string = esperado, NO es error

Detecta automáticamente en qué paso quedó el workflow y retoma desde ahí.

---

#### `/generar-walkthrough` 🆕
**Propósito**: Generar walkthrough.md tutorial detallado a partir de un .Rmd existente

**Uso**:
```bash
/generar-walkthrough [ruta-al-archivo.Rmd]
```

**Qué hace**:
1. Analiza estructura del .Rmd (tipo, complejidad, patrones)
2. Si >200 líneas: lanza agentes en paralelo (Haiku + Sonnet)
3. Genera `walkthrough.md` con 7 secciones:
   - Mapa del ejercicio
   - Vista de pájaro (con analogías)
   - Bloque por bloque (código anotado)
   - Patrones clave
   - Receta paso a paso
   - Errores comunes
   - Glosario rápido
4. Escribe el archivo en el directorio del .Rmd

**Output**: Archivo `walkthrough.md` tutorial para novatos

**Modelo**: Sonnet (orquestador) + Haiku (extracción) + Sonnet (análisis)

---

#### `/generar-schoice`
**Propósito**: Generar ejercicio de selección única (Single Choice)

**Uso**:
```bash
/generar-schoice
```

**Requisitos previos**:
- Análisis ICFES completado
- Si tiene gráficos: Flujo B completado

**Qué hace** (workflow completo de 14 pasos, v4.0):
1. Selecciona patrón metacognitivo
2. Verifica análisis ICFES + Flujo B
3. Consulta ejemplos funcionales
4. Define pool de errores conceptuales
5. Crea carpeta + inicializa `workflow-state.sh`
6. Genera .Rmd metacognitivo
7. `/skill-retroalimentacion` — Solution científica
8. Renderizado 4 formatos (HTML/PDF/DOCX/NOPS)
9. Arsenal post-render automático (FASES 2A-2H)
10. `/adversario` — Detractor FASE 2C
11. Documenta 5 coherencias
12. `/validar-diversidad` — 250+ versiones únicas
13. `/validar-icfes` — metadatos y estructura
14. Aprobación usuario → `/promover-ejercicio`

Todos los pasos registran progreso via `workflow-state.sh complete`.

**Output**: Archivo `.Rmd` validado por 11 pasos del workflow

**Metadatos generados**:
```yaml
extype: schoice
exsolution: [binario, ej: 01000]
exshuffle: TRUE  # OBLIGATORIO (FALSE en SCHOICE con PNGs gráficos — ver graficos-como-opciones.md)
exname: nombre_ejercicio
exextra[Type]: SCHOICE
exextra[Competencia]: [clasificación]
exextra[Componente]: [clasificación]
# ... resto de metadatos ICFES
```

---

#### `/generar-cloze`
**Propósito**: Generar ejercicio compuesto (pregunta con múltiples partes)

**Uso**:
```bash
/generar-cloze
```

**Requisitos previos**:
- Análisis ICFES completado
- Si tiene gráficos: Flujo B completado

**Qué hace** (workflow completo de 16 pasos, v4.0):
1. Define estructura Progressive Disclosure (mín. 4 partes)
2. Verifica análisis ICFES + Flujo B
3. Consulta ejemplos funcionales
4-6. Define pools: errores, afirmaciones, V/F
7. Crea carpeta + inicializa `workflow-state.sh`
8. Genera .Rmd CLOZE metacognitivo
9. `/skill-retroalimentacion` — Solution científica
10. Renderizado 4 formatos (NOPS falla con num/string = esperado)
11. Arsenal post-render automático (FASES 2A-2H)
12. `/adversario` — Detractor FASE 2C
13. Documenta 5 coherencias
14. `/validar-diversidad` — 250+ versiones únicas
15. `/validar-icfes` — metadatos y estructura
16. Aprobación usuario → `/promover-ejercicio`

Todos los pasos registran progreso via `workflow-state.sh complete`.

**Output**: Archivo `.Rmd` validado por 11 pasos del workflow

**Metadatos generados**:
```yaml
extype: cloze
exclozetype: num|schoice|mchoice|string
```

---

#### `/validar-pedagogico` 🆕
**Propósito**: Análisis pedagógico avanzado basado en evidencias científicas y taxonomías cognitivas modernas

**Uso**:
```bash
/validar-pedagogico [ruta-al-ejercicio.Rmd]
```

**Requisitos previos**:
- Archivo .Rmd generado y renderizado
- (Opcional) Ciclo de Validación completado

**Qué hace**:
1. **Módulo 1**: Análisis cognitivo multinivel (Bloom, SOLO, Webb DOK)
2. **Módulo 2**: Validación ICFES (6 dimensiones obligatorias)
3. **Módulo 3**: Análisis avanzado de distractores (6 tipologías)
4. **Módulo 4**: Optimización pedagógica (7 principios científicos)
5. **Módulo 5**: Meta-evaluación (puntuación 0-100)

**Output**: Reporte completo con:
- Clasificación taxonómica triple
- Validación Marco Conceptual ICFES 2026
- Evaluación de distractores por tipología de error
- Aplicación de principios de aprendizaje
- Puntuación compuesta con desglose
- Recomendaciones específicas de mejora

**Modelo**: Claude Opus 4.6 (máxima capacidad cognitiva)

**Documentos consultados automáticamente**:
- `errores-conceptuales-matematicas.md`
- `principios-aprendizaje-evidencias.md`
- `taxonomias-cognitivas-integradas.md`
- `marco-conceptual-icfes-2026.md`
- `diseno-distractores-tipologia.md`

**Diferencia con `/analizar-icfes`**:
- `/analizar-icfes`: Clasificación inicial ANTES de crear .Rmd (input: imagen)
- `/validar-pedagogico`: Análisis pedagógico profundo DESPUÉS de crear .Rmd (input: archivo completo)

---

#### `/skill-retroalimentacion` 🆕
**Propósito**: Generar retroalimentación científica para la sección Solution siguiendo estándares ICFES 2026

**Uso**:
```bash
/skill-retroalimentacion [ruta-al-ejercicio.Rmd]
```

**Requisitos previos**:
- Archivo .Rmd con estructura SCHOICE o CLOZE
- Pool de errores conceptuales definido
- Metadatos ICFES completos

**Qué hace**:
1. Genera encabezado diagnóstico con competencia y evidencias
2. Describe específicamente qué capacidad evalúa el ejercicio
3. Justifica la respuesta correcta con pasos matemáticos detallados
4. Analiza CADA distractor con el patrón ICFES:
   > "Es posible que los estudiantes que eligen la opción X [error conceptual]..."
5. Incluye reflexión metacognitiva con estrategias preventivas

**Output**: Sección Solution completa con estructura científica

**Fuente oficial**: ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023 (pp. 22-51)

**Estructura de la retroalimentación**:
```markdown
### Competencia, Componente, Afirmación y Evidencia
[Encabezado diagnóstico automático]

### ¿Qué evalúa esta pregunta?
[Descripción específica de la capacidad]

### Justificación de la Respuesta Correcta
[Pasos matemáticos con fórmulas LaTeX]

### Opciones No Válidas
**Opción A:** Es posible que los estudiantes que eligen...
**Opción B:** Es posible que los estudiantes que eligen...
[Continúa para cada distractor]

### Reflexión Metacognitiva
[Estrategias para evitar errores comunes]
```

**Documentación completa**: `.claude/skills/skill-retroalimentacion/SKILL.md`

**Nota**: También se ejecuta automáticamente al generar ejercicios con `/generar-schoice` o `/generar-cloze`.

---

#### `/promover-ejercicio`
**Propósito**: Mover ejercicio validado de En-Desarrollo a 03-En-Produccion/[categoría ICFES]/

**Uso**:
```bash
/promover-ejercicio nombre_ejercicio.Rmd
```

**Requisitos previos**:
- Ejercicio en `A-Produccion/En-Desarrollo/`
- Ciclo de Validación completo (FASE 1+2+3 exitosas)
- Tests pasando 100%
- Usuario aprobó explícitamente

**Qué hace**:
1. Verifica estado de validación
2. Ejecuta tests finales
3. Mueve archivo a `A-Produccion/03-En-Produccion/[categoría ICFES]/`
4. Actualiza índice de ejercicios
5. Registra en historial

**Output**: Ejercicio en producción listo para usar

---

### Graficador Experto (Flujo B - SECUENCIAL)

**⚠️ IMPORTANTE**: Estos comandos deben ejecutarse SECUENCIALMENTE, no simultáneamente.

#### `/auto-refinar-grafico tikz`
**Propósito**: Generar y refinar versión TikZ del gráfico (PRIMERO)

**Uso**:
```bash
/auto-refinar-grafico tikz [umbral_similitud]
```

**Ejemplo**:
```bash
/auto-refinar-grafico tikz 95
```

**Qué hace**:
1. Genera código TikZ dinámico desde R
2. Compila a PDF y convierte a PNG
3. Compara con imagen original
4. Itera hasta alcanzar umbral de similitud (≥95%)
5. Verifica las 5 coherencias
6. Solicita aprobación del usuario
7. SOLO continúa si usuario aprueba

**Iteraciones**:
- v1, v2, v3... hasta alcanzar similitud
- Máximo 10 iteraciones por defecto

**Output**: `output_tikz_vN.tex`, `tikz_output_vN.png`

---

#### `/auto-refinar-grafico python`
**Propósito**: Generar y refinar versión Python del gráfico (SEGUNDO)

**Uso**:
```bash
/auto-refinar-grafico python [umbral_similitud]
```

**Requisito previo**: TikZ aprobado por usuario

**Qué hace**:
1. Usa misma lógica matemática que TikZ
2. Genera código Python/matplotlib
3. Compila con reticulate
4. Compara con imagen original
5. Itera hasta alcanzar umbral
6. Verifica las 5 coherencias
7. Solicita aprobación del usuario
8. SOLO continúa si usuario aprueba

**Output**: `output_python_vN.py`, `python_output_vN.png`

---

#### `/auto-refinar-grafico r`
**Propósito**: Generar y refinar versión R del gráfico (TERCERO)

**Uso**:
```bash
/auto-refinar-grafico r [umbral_similitud]
```

**Requisito previo**: Python aprobado por usuario

**Qué hace**:
1. Usa misma lógica matemática que versiones previas
2. Genera código R/ggplot2 nativo
3. Compila a PNG
4. Compara con imagen original
5. Itera hasta alcanzar umbral
6. Verifica las 5 coherencias
7. Solicita aprobación del usuario
8. Pregunta al usuario cuál versión usar en .Rmd

**Output**: `output_r_vN.R`, `r_output_vN.png`

---

#### `/estado-graficador`
**Propósito**: Consultar estado actual del workflow gráfico

**Uso**:
```bash
/estado-graficador
```

**Qué muestra**:
```json
{
  "fase_actual": "tikz_iteracion|python_iteracion|r_iteracion|seleccion_final",
  "tikz": {
    "estado": "pendiente|en_iteracion|verificando|aprobado",
    "version_actual": 3,
    "similitud_actual": 96,
    "coherencias_verificadas": true,
    "usuario_aprobo": true
  },
  "python": {
    "estado": "en_iteracion",
    "version_actual": 2,
    "similitud_actual": 94,
    "coherencias_verificadas": false,
    "usuario_aprobo": false
  },
  "r": {
    "estado": "bloqueado",
    "version_actual": 0
  }
}
```

**Sin argumentos**

---

#### `/exportar-graficos`
**Propósito**: Exportar resultados finales del Flujo B

**Uso**:
```bash
/exportar-graficos
```

**Requisito previo**: Flujo B completado (TikZ/Python/R aprobados)

**Qué hace**:
1. Copia versión seleccionada a directorio final
2. Genera reporte consolidado con:
   - Similitudes alcanzadas
   - Coherencias verificadas
   - Código fuente de cada versión
   - Comparaciones visuales
3. Archiva versiones intermedias

**Output**: Reporte PDF + archivos finales listos para .Rmd

---

## Skills Automáticos

**Invocación**: Claude los ejecuta automáticamente según contexto

### Validación (Ejecución Automática)

#### Validar Renderizado (FASE 1)
**Cuándo se ejecuta**: Después de generar/editar .Rmd

**Qué hace**:
```r
exams2html("archivo.Rmd", n = 1)
exams2pdf("archivo.Rmd", n = 1)
exams2pandoc("archivo.Rmd", n = 1, type = "docx")
exams2nops("archivo.Rmd", n = 1)
```

Captura errores/advertencias de cada formato

---

#### Validar Coherencia (FASE 2)
**Cuándo se ejecuta**: Después de renderizado exitoso (AUTOMÁTICO vía hook)

**FASE 2A - Validación Matemática** (automática):
```bash
Rscript .claude/scripts/validar_coherencia_matematica.R archivo.Rmd
```

**Verifica**:
- Chunks R sin errores
- Metadatos ICFES completos
- exshuffle = TRUE
- SCHOICE: exsolution binario, exactamente 1 correcta
- CLOZE: tipos/soluciones/tolerancias consistentes
- Variables sin NA/NaN/Inf
- Coherencia matemática entre variables

**FASE 2B - Preview Visual** (automática):
```bash
magick -density 150 archivo.pdf -quality 90 preview.png
```

Claude DEBE entonces:
1. `Read("preview.png")`
2. Verificar 5 coherencias VISUALMENTE
3. Documentar hallazgos
4. Solicitar aprobación del usuario

---

#### Diagnosticar Errores (FASE 3)
**Cuándo se ejecuta**: Cuando FASE 1 o 2 detectan problemas

**Qué hace**:
1. Analiza tipo de error
2. Consulta patrones conocidos (@.claude/docs/patrones-errores-conocidos.md)
3. Busca solución en ejemplos funcionales
4. Propone corrección específica
5. Aplica corrección
6. VUELVE A FASE 1 (re-renderiza)

---

### Corrección (Ejecución Automática en Errores)

#### Corregir Gráficos (SUBFASE 3A)
**Cuándo se ejecuta**: Error en renderizado de gráficos

**Qué hace**:
1. Identifica tipo de error:
   - TikZ no compila en HTML
   - Python falla con reticulate
   - R ggplot2 dimensiones incorrectas
2. Consulta ejemplos funcionales:
   ```
   /A-Produccion/Ejemplos-Funcionales-Rmd/
   ```
3. Aplica patrón de solución validado
4. Re-renderiza
5. Vuelve a FASE 2 (validación)

---

#### Corregir Errores Imagen TikZ
**Cuándo se ejecuta**: TikZ no renderiza correctamente

**Patrones comunes**:
- Falta `\usepackage{tikz}`
- Coordenadas fuera de rango
- Sintaxis TikZ incorrecta
- No usa `include_tikz()` correctamente

**Solución**:
```r
# Renderizado condicional
if (knitr::is_latex_output()) {
  include_tikz("grafico.tex", ...)
} else {
  knitr::include_graphics("grafico.png")
}
```

---

### Graficador (Ejecución SECUENCIAL)

#### Analizar Imagen Matemática
**Cuándo se ejecuta**: Al cargar imagen en `/analizar-icfes`

**Qué hace**:
1. Detecta si contiene gráficos matemáticos
2. Identifica tipo: barras/líneas/dispersión/geometría/etc.
3. Extrae valores numéricos visibles
4. Registra en análisis: `requiere_flujo_b: true/false`
5. Si TRUE → BLOQUEA generación .Rmd sin Flujo B

---

#### Generar Código [TikZ|Python|R]
**Cuándo se ejecuta**: Durante `/auto-refinar-grafico [lenguaje]`

**Proceso iterativo**:
```
1. Analizar imagen original
2. Generar código versión N
3. Compilar/renderizar
4. Comparar con original (similitud %)
5. Si < umbral → Ajustar → N+1 → repetir
6. Si ≥ umbral → Verificar coherencias
7. Solicitar aprobación usuario
8. Si rechazado → N+1 → repetir
9. Si aprobado → SIGUIENTE lenguaje
```

**Similitud**:
- Algoritmo: Comparación pixel-by-pixel con SSIM
- Umbral recomendado: ≥95%
- Máximo iteraciones: 10

---

## Referencia Rápida

### Flujo Completo Típico

```bash
# 1. Análisis inicial
/analizar-icfes
# → Detecta: Requiere gráficos

# 2. Flujo B (SECUENCIAL)
/auto-refinar-grafico tikz 95
# → Iterar hasta ≥95% + aprobar

/auto-refinar-grafico python 95
# → Iterar hasta ≥95% + aprobar

/auto-refinar-grafico r 95
# → Iterar hasta ≥95% + seleccionar versión

# 3. Generación de ejercicio
/generar-schoice
# O
/generar-cloze

# 4. Validación automática (skills)
# FASE 1: Renderizado 4 formatos
# FASE 2A: Validación matemática (hook automático)
# FASE 2B: Preview PNG (hook automático)
# FASE 2C-2F: Arsenal completo (hook automático)
# FASE 2G: Multi-semilla rápida (hook automático)
# FASE 2H: Stress Test Visual (hook automático)
# Claude: Verifica 5 coherencias + solicita aprobación

# 5. Promoción
/promover-ejercicio nombre_ejercicio.Rmd
```

---

### Tabla de Comandos por Contexto

| Necesito... | Comando |
|-------------|---------|
| Empezar ejercicio nuevo | `/analizar-icfes` |
| Ejercicio sin gráficos | `/generar-schoice` o `/generar-cloze` |
| Ejercicio con gráficos | Flujo B primero → luego generar |
| Gráfico TikZ | `/auto-refinar-grafico tikz 95` |
| Gráfico Python | `/auto-refinar-grafico python 95` |
| Gráfico R | `/auto-refinar-grafico r 95` |
| Ver estado gráficos | `/estado-graficador` |
| Exportar gráficos | `/exportar-graficos` |
| Promover a producción | `/promover-ejercicio archivo.Rmd` |

---

### Skills que NO Requieren Invocación Manual

Estos se ejecutan **automáticamente**:
- Validar renderizado (después de generar .Rmd)
- Validar coherencia (después de renderizar, vía hook)
- Diagnosticar errores (cuando hay fallos)
- Corregir gráficos (cuando detecta errores gráficos)
- Analizar imagen matemática (al cargar imagen)
- **Skill-retroalimentación** (al generar sección Solution)
- **Stress-test-visual** (FASE 2H: renderizado masivo + análisis anomalías + PNGs)

**NO ejecutar manualmente**. El sistema los invoca cuando corresponde.

---

### Skill-retroalimentación (OBLIGATORIO, AUTOMÁTICO, PERMANENTE) 🆕

**Cuándo se ejecuta**: Al generar la sección Solution de cualquier .Rmd

**Fuente oficial**: ICFES - Guía de Orientación Matemáticas 11° Cuadernillo 2-2023 (pp. 22-51)

**Qué genera automáticamente**:

1. **Encabezado diagnóstico**: Competencia, Componente, Afirmación, Evidencia, Nivel
2. **¿Qué evalúa?**: Descripción específica de la capacidad evaluada
3. **Justificación de respuesta correcta**: Pasos matemáticos con fórmulas LaTeX
4. **Opciones no válidas**: Para CADA distractor, análisis con patrón:
   > "Es posible que los estudiantes que eligen la opción X [error conceptual]..."
5. **Reflexión metacognitiva**: Estrategias para evitar errores comunes

**Ejemplo de salida**:
```markdown
### Opciones No Válidas

**Opción B:**
Es posible que los estudiantes que eligen la opción B confundan el
porcentaje con la cantidad absoluta, poniendo 30 en lugar de calcular
120 × 30/100 = 36. Este error se presenta cuando el estudiante no
comprende que el porcentaje es una proporción que debe aplicarse al
total. Para evitar este error, el estudiante debe recordar que:
$$\text{Cantidad} = \text{Total} \times \frac{\text{Porcentaje}}{100}$$
```

**Ubicación del skill**: `.claude/skills/skill-retroalimentacion/SKILL.md`

---

## Configuracion de Skills

**Ubicacion**: `.claude/skills/`

Cada skill sigue el patron **Progressive Disclosure** de Anthropic Agent Skills:

```
skill-name/
├── SKILL.md              # Archivo principal (~3-4KB)
│   ├── Frontmatter YAML  # name, description, allowed-tools
│   ├── Decision Tree     # Arbol de decision inicial
│   ├── Proceso paso a paso
│   └── Referencias a docs detallados
└── references/           # Documentacion extraida
    ├── patron-X.md
    └── ejemplos-Y.md
```

**Estructura del frontmatter**:

```yaml
---
name: nombre-skill
description: >
  Descripcion concisa del skill.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requisitos del skill.
metadata:
  author: alvaretto
  version: "2.1"
  language: es
  model_recommendation: sonnet    # opus | sonnet | haiku
allowed-tools:
  - Read
  - Write
  - Bash(comando:*)
---
```

**Skills disponibles** (24 skills con `model_recommendation` en frontmatter):

| Skill | Modelo | Proposito |
|-------|--------|-----------|
| analizar-icfes | **Opus** | Clasificación 6 dimensiones ICFES |
| generar-schoice | **Opus** | Ejercicios SCHOICE metacognitivos |
| generar-cloze | **Opus** | Ejercicios CLOZE metacognitivos |
| skill-detractor | **Opus** | Revisión adversarial 8 dominios |
| skill-retroalimentacion | **Opus** | Retroalimentación científica ICFES |
| validar-pedagogico | **Opus** | Análisis pedagógico profundo |
| analizar-imagen-grafica | Sonnet | Extracción de elementos visuales |
| comparar-similitud-visual | Sonnet | Puntuación 0-100 de similitud |
| corregir-error-imagen | Sonnet | ERR_G1: File not found |
| corregir-graficos | Sonnet | ERR_G1-G4: Errores gráficos |
| diagnosticar-errores | Sonnet | FASE 3: Clasificación de errores |
| generar-codigo-python | Sonnet | Matplotlib para gráficos |
| generar-codigo-r | Sonnet | ggplot2 para gráficos |
| generar-codigo-tikz | Sonnet | TikZ/pgfplots para gráficos |
| refinar-codigo-grafico | Sonnet | Iteración hasta ≥95% |
| stress-test-visual | Sonnet | Stress test multi-semilla + PNGs |
| generar-walkthrough | Sonnet | Tutorial walkthrough de .Rmd |
| gestionar-estado-graficador | Haiku | workflow_state.json |
| promover-ejercicio | Haiku | Mover a producción |
| transferir-conocimiento-grafico | Haiku | Lecciones entre lenguajes |
| validar-coherencia | Haiku | FASE 2: 5 coherencias |
| validar-diversidad | Haiku | 250+ versiones únicas |
| validar-icfes | Haiku | Estructura R-exams + ICFES |
| validar-renderizado | Haiku | FASE 1: 4 formatos |

**Routing obligatorio**: Skills no-Opus se delegan vía `Task(model=X)`. Ver @.claude/rules/modelo-routing-obligatorio.md

**NO modificar skills** sin ejecutar tests de regresión.

---

## 📚 Documentación Relacionada

- **Reglas críticas**: @.claude/docs/REGLAS_CRITICAS.md
- **Flujo B obligatorio**: @.claude/rules/flujo-b-obligatorio.md
- **Proceso secuencial**: @.claude/rules/graficador-secuencial.md
- **Ciclo validación**: @.claude/rules/ciclo-validacion.md
- **Workflow completo**: @.claude/docs/WORKFLOW_PASO_A_PASO.md
- **Routing de modelos**: @.claude/docs/MODELO_ROUTING.md 🆕

---

**Versión**: 1.5
**Fecha**: 2026-03-25
**Módulo de**: @.claude/CLAUDE.md (v3.6.0)

### Cambios v1.5 (2026-03-25)

- **24 skills** (era 23): +generar-walkthrough (Sonnet)
- **Nuevo comando**: `/generar-walkthrough` genera tutorial walkthrough.md desde .Rmd existente
- **Modelo**: Sonnet orquestador + Haiku extracción + Sonnet análisis (agentes en paralelo si >200 líneas)

### Cambios v1.4 (2026-02-14)

- **23 skills** (era 22): +stress-test-visual (Sonnet)
- **FASE 2H**: Stress Test Visual integrado en arsenal automático
- **Hook v6.0**: post-exams2-validation.sh incluye stress test
- **Skill automático**: Se ejecuta vía hook, renderiza 10 semillas con exams2pdf()

### Cambios v1.3 (2026-02-14)

- **22 skills** (era 18): +validar-diversidad, +validar-icfes, +promover-ejercicio, +skill-detractor
- **Tabla de skills** reorganizada por tier de modelo (Opus/Sonnet/Haiku)
- **`model_recommendation`** agregado al ejemplo de frontmatter YAML
- **Modelo** actualizado: Opus 4.5 → Opus 4.6
- **Referencia** a MODELO_ROUTING.md en documentación relacionada

### Cambios v1.2 (2026-02-07)

- Agregado comando manual `/skill-retroalimentacion` con documentación completa
- Incluye estructura de retroalimentación científica estilo ICFES 2026
- Referencias a fuente oficial (Guía de Orientación Matemáticas 11°)

### Cambios v1.1 (2026-02-06)

- Documentación de estructura Progressive Disclosure para skills
- Tabla completa de 17 skills refactorizados (v2.1)
- Frontmatter YAML estandarizado para todos los skills
