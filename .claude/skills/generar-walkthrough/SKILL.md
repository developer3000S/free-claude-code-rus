---
name: generar-walkthrough
description: >
  Genera un walkthrough.md tutorial detallado a partir de un archivo .Rmd existente.
  El walkthrough explica bloque por bloque cómo funciona el ejercicio, con analogías
  del mundo real, para que un novato pueda entender y replicar ejercicios del mismo tipo.
  Usa cuando necesites documentar un .Rmd como tutorial, crear material de capacitación,
  o generar guías de referencia para nuevos colaboradores.
license: Proyecto Educativo - IE Pedacito de Cielo
compatibility: Requiere acceso de lectura al .Rmd y a las reglas del proyecto.
metadata:
  author: alvaretto
  version: "1.1"
  language: es
  model_recommendation: sonnet
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(ls:*)
  - Bash(wc:*)
  - Bash(head:*)
  - Agent
---

# Generador de Walkthrough para .Rmd

## Propósito

Toma un archivo `.Rmd` del repositorio ICFES R-exams y genera un `walkthrough.md` tutorial
completo en el mismo directorio. El walkthrough sirve como guía de aprendizaje para que un
novato entienda la estructura, lógica y patrones del ejercicio, y pueda crear uno similar.

## Invocación

```
/generar-walkthrough [ruta-al-archivo.Rmd]
```

Si no se proporciona ruta, preguntar al usuario qué archivo desea documentar.

## Decision Tree

```
Input: ruta .Rmd
    ↓
¿El archivo existe y es .Rmd?
    |-- No → Error: "Archivo no encontrado o no es .Rmd"
    +-- Sí → Continuar
    ↓
FASE 0: Opus lee el .Rmd completo + clasifica + analiza estructura
    ↓
FASE 1: Opus pasa análisis completo a 1 agente Sonnet (implementador)
    ↓
FASE 2: Sonnet redacta + escribe walkthrough.md
    ↓
Muestra resumen al usuario
```

## Proceso detallado

### FASE 0: Lectura y análisis (Opus, inline)

1. Leer el .Rmd completo con `Read` (en partes si >10k tokens)
2. Contar líneas (`wc -l`) y verificar si ya existe `walkthrough.md`
3. Determinar complejidad:
   - Identificar tipo: SCHOICE o CLOZE (buscar `extype:`)
   - Detectar si tiene gráficos (TikZ, Python/reticulate, ggplot2)
   - Detectar si es metacognitivo (pool de errores, Progressive Disclosure)
   - Detectar si es `_neg_` (lógica negativa)
4. **Analizar directamente** (Opus ya tiene el archivo en contexto):
   - Estructura de chunks con líneas inicio-fin y propósito
   - Variables principales y flujo de datos
   - Patrón metacognitivo usado
   - Mecanismo de aleatorización
   - Errores conceptuales (códigos y nombres)
   - Decisiones de diseño NO obvias
   - Puntos de fragilidad
   - Reglas del proyecto que aplican
5. Informar al usuario: `[Modelo: Opus] Analizando [archivo]...`

### FASE 1: Delegación a Sonnet (1 agente implementador)

**Optimización clave**: Como Opus ya leyó y analizó el .Rmd en FASE 0, NO se
lanzan agentes adicionales para re-leer el archivo ni las reglas. En vez de 3
agentes paralelos (2 Haiku + 1 Sonnet), se pasa TODO el análisis como contexto
a un único agente Sonnet que redacta y escribe el walkthrough.

```
Agent(
  subagent_type = "implementador",
  model = "sonnet",
  description = "Redactar walkthrough.md completo",
  prompt = """
  TAREA: Escribir walkthrough.md en [directorio del .Rmd].

  ## ANÁLISIS COMPLETO (ya extraído por Opus — NO releer el archivo)

  [Aquí Opus incluye todo su análisis de FASE 0:
   - Datos generales (tipo, líneas, tema, patrón, metadatos)
   - Estructura del archivo (chunks con líneas y propósito)
   - Errores conceptuales (códigos, categorías)
   - Mecanismo de aleatorización
   - Decisiones de diseño NO obvias
   - Puntos de fragilidad
   - Reglas relevantes del proyecto]

  ## ESTRUCTURA DEL WALKTHROUGH
  [Estructura de 7 secciones definida abajo]

  ## INSTRUCCIONES DE REDACCIÓN
  [Instrucciones de redacción definidas abajo]

  IMPORTANTE: Usa Write para crear el archivo directamente.
  NO devolver el contenido como texto — escribirlo al disco.
  """
)
```

**Justificación del cambio (v1.0 → v1.1):**

En v1.0, el skill especificaba 3 agentes paralelos para FASE 1:
- Haiku: extraer estructura del .Rmd (redundante — Opus ya lo leyó)
- Haiku: recopilar reglas del proyecto (redundante — Opus conoce las reglas por CLAUDE.md)
- Sonnet: analizar patrones (el único trabajo real)

En la práctica, Opus lee el .Rmd completo en FASE 0 para clasificarlo, así que ya tiene
toda la información que los 2 Haiku extraerían. Lanzarlos es trabajo duplicado.
El agente Sonnet único recibe el análisis completo como contexto y produce mejor resultado
porque tiene visión unificada en vez de 3 fragmentos que ensamblar.

### FASE 2: Redacción + escritura (Sonnet, dentro del agente)

El agente Sonnet de FASE 1 redacta Y escribe el walkthrough en una sola operación.
No hay fase separada de ensamblaje.

**Instrucciones clave para la redacción (incluidas en el prompt del agente):**
- Cada concepto técnico DEBE tener al menos 1 analogía del mundo real
- El código se muestra en bloques con comentarios línea por línea
- Progresión cognitiva: vista de pájaro → detalle → receta
- El walkthrough DEBE ser autocontenido — el novato NO necesita leer CLAUDE.md
- Extensión proporcional: ~300 líneas para SCHOICE simple, ~500+ para CLOZE complejo
- Idioma: español con tildes correctas en todo momento

### FASE 3: Verificación (Opus, inline)

Opus verifica que el archivo fue creado:
1. Comprobar existencia y contar líneas (`wc -l`)
2. Leer las primeras ~80 líneas para confirmar estructura correcta
3. Informar al usuario: ruta, extensión y modelos utilizados

## Estructura del walkthrough.md de salida

```markdown
# Walkthrough: [nombre_archivo sin extensión]

> Tutorial generado automáticamente. Explica paso a paso cómo funciona
> este ejercicio .Rmd y cómo crear uno similar.

## Mapa del ejercicio

| Aspecto | Valor |
|---------|-------|
| Tipo | SCHOICE / CLOZE |
| Tema matemático | [tema] |
| Patrón metacognitivo | [patrón identificado] |
| Nivel ICFES | [N1-N4] |
| Competencia | [Interpretación/Formulación/Argumentación] |
| ¿Tiene gráficos? | Sí (TikZ/Python/R) / No |
| Complejidad estimada | Baja / Media / Alta |
| Líneas de código | [N] |

---

## 1. Vista de pájaro

[Analogía del mundo real que capture la esencia del ejercicio en 3-5 oraciones.
Ejemplo: "Imagina que eres detective revisando el trabajo de un estudiante
que cometió un error en su examen. Tu trabajo no es solo encontrar la respuesta
correcta, sino descubrir EXACTAMENTE qué error cometió y por qué."]

[Resumen de qué hace el ejercicio sin jerga técnica]

---

## 2. Anatomía del .Rmd

[Diagrama visual ASCII del archivo con analogías]

```
┌─────────────────────────────────────┐
│ data_generation (La cocina)         │  ← Aquí se preparan los ingredientes
│   ├── Contextos narrativos          │     (datos aleatorios, errores, opciones)
│   ├── Pool de errores               │
│   ├── Distractores                  │
│   └── Validaciones internas         │
├─────────────────────────────────────┤
│ Question (La vitrina)               │  ← Lo que el estudiante ve
│   ├── Enunciado con contexto        │
│   ├── Tabla de datos                │
│   └── Pregunta + Answerlist         │
├─────────────────────────────────────┤
│ Solution (El manual del profesor)   │  ← La explicación completa
│   ├── Análisis del error            │
│   ├── Procedimiento correcto        │
│   ├── Reflexión metacognitiva       │
│   └── Estrategia preventiva         │
├─────────────────────────────────────┤
│ Meta-information (La etiqueta)      │  ← Clasificación y metadatos
│   ├── extype, exsolution            │
│   └── ICFES 6D + DOK/Bloom/SOLO    │
└─────────────────────────────────────┘
```

---

## 3. Bloque por bloque

### 3.1 Generación de datos aleatorios

[Explicar el chunk de data_generation con código anotado]

```r
# [Código del .Rmd con comentarios explicativos añadidos]
```

**¿Qué pasaría si...?**
- [Consecuencia de cambiar parámetro X]
- [Consecuencia de eliminar línea Y]

### 3.2 Pool de errores conceptuales

[Explicar la estructura del pool con analogía]
[Mostrar 1-2 errores del pool con anotaciones]

**Analogía**: "El pool de errores es como un catálogo de errores comunes que
los estudiantes realmente cometen. Cada error tiene un 'nombre', una 'receta'
(función calcula) para reproducirlo, y una 'ficha médica' (causa_raíz) que
explica por qué ocurre."

### 3.3 Construcción de opciones y mezcla

[Explicar cómo se arman las opciones, sample(), vector sol]

### 3.4 Contexto narrativo

[Explicar el sistema de plantillas si existe]

### 3.5 La pregunta (Question)

[Explicar el markdown + chunks inline]

### 3.6 La solución (Solution)

[Explicar las subsecciones y su propósito pedagógico]

### 3.7 Metadatos (Meta-information)

[Explicar cada campo con su propósito]
[Tabla: campo → qué significa → valores válidos → por qué importa]

---

## 4. Patrones clave (Las reglas del juego)

[Lista de patrones NO obvios específicos de ESTE .Rmd]

1. **[Patrón 1]**: [Explicación + por qué existe]
2. **[Patrón 2]**: [Explicación + por qué existe]
...

---

## 5. Cómo crear uno similar (Receta paso a paso)

1. [ ] Ejecutar `/analizar-icfes` con la imagen del ejercicio original
2. [ ] Determinar si requiere gráficos (Flujo B)
3. [ ] Consultar ejemplos funcionales similares
4. [ ] Definir pool de errores conceptuales (mínimo 4-6)
5. [ ] Escribir data_generation con aleatorización
6. [ ] Escribir Question con patrón metacognitivo
7. [ ] Escribir Solution con 6 subsecciones
8. [ ] Agregar metadatos ICFES + cognitivos
9. [ ] Renderizar en 4 formatos
10. [ ] Validar diversidad (250+ versiones únicas)
11. [ ] Pedir aprobación del usuario

---

## 6. Errores comunes y cómo evitarlos

| # | Error | Qué pasa | Cómo evitarlo |
|---|-------|----------|---------------|
| 1 | [error] | [consecuencia] | [solución] |
...

---

## 7. Glosario rápido

| Término | Significado |
|---------|-------------|
| SCHOICE | Selección única (1 correcta, N-1 distractores) |
| CLOZE | Pregunta compuesta con múltiples partes |
| exshuffle | Si R-exams mezcla las opciones automáticamente |
| Progressive Disclosure | Revelar información gradualmente (fácil → difícil) |
| calcula() | Función que reproduce el error del estudiante |
| [más según el .Rmd] | ... |

---

*Generado con `/generar-walkthrough` — [fecha]*
```

## Adaptaciones por tipo de .Rmd

### Si es CLOZE (multi-parte)

- Sección 3 se expande: una subsección por cada parte (Parte 1, Parte 2, etc.)
- Explicar `exclozetype` y cómo cada parte tiene su propio tipo
- Explicar `##ANSWERi##` y su posición obligatoria
- Sección 4 incluye: "Por qué el orden de las partes importa (Progressive Disclosure)"

### Si tiene gráficos

- Sección 3 agrega: subsección dedicada a la generación de gráficos
- Explicar renderizado condicional (LaTeX vs HTML)
- Explicar la lógica de `exshuffle: FALSE` + `sample()` interno
- Incluir ejemplo visual si hay PNGs de preview disponibles

### Si es `_neg_` (lógica negativa)

- Sección 1 explica la inversión lógica ("buscar el error entre correctas")
- Sección 3.3 explica el patrón de opciones equivalentes (Variante A o B)
- Sección 4 incluye: "Por qué lógica negativa aumenta la demanda cognitiva"

### Si NO es metacognitivo (archivo legacy)

- Sección 3.2 se omite (no hay pool de errores)
- Sección 5 incluye nota: "Este ejercicio no sigue el patrón metacognitivo actual.
  Para crear uno nuevo, se recomienda seguir el patrón metacognitivo obligatorio."

## Routing de modelos

| Fase | Modelo | Justificación |
|------|--------|---------------|
| FASE 0: Lectura + análisis | Opus (inline) | Lee el .Rmd y analiza estructura, patrones, fragilidades |
| FASE 1: Redacción + escritura | Sonnet (agente implementador) | Redacta walkthrough con el análisis de Opus como contexto |
| FASE 2: Verificación | Opus (inline) | Confirma creación y estructura del archivo |

**Optimización v1.1**: Se eliminaron 2 agentes Haiku que re-leían información ya
disponible en el contexto de Opus. Resultado: 1 agente Sonnet en vez de 2 Haiku + 1 Sonnet.

**Mostrar en consola** qué modelo se usa en cada fase:
```
[Modelo: Opus] Leyendo y analizando [archivo]...
  → Tipo: [SCHOICE|CLOZE] | [características] | [N] líneas
[Modelo: Sonnet] Redactando y escribiendo walkthrough.md...
[Modelo: Opus] Verificando resultado...
✅ Walkthrough generado: [ruta] ([N] líneas)
```

## Restricciones

1. **NO generar sin leer**: El .Rmd completo DEBE leerse antes de generar
2. **NO inventar código**: Solo explicar código que EXISTE en el .Rmd
3. **NO secciones vacías**: Omitir secciones irrelevantes (sin gráficos → sin sección de gráficos)
4. **NO reemplazar documentación**: El walkthrough complementa, no sustituye rules/ y docs/
5. **NO jerga sin explicar**: Cada término técnico debe tener definición o analogía
6. **Tildes obligatorias**: Todo texto en español con tildes correctas desde el primer borrador
7. **Sobrescritura**: Si ya existe `walkthrough.md`, preguntar antes de sobrescribir

## Antipatrones PROHIBIDOS

### 1. Walkthrough genérico (PROHIBIDO)

```markdown
❌ "Este archivo usa R-exams para generar ejercicios..."
   (Descripción genérica que aplica a CUALQUIER .Rmd)

✅ "Este ejercicio presenta al estudiante una tabla con N datos
   desordenados y le pide identificar qué error cometió un compañero
   al calcular la mediana sin ordenar los datos primero."
   (Descripción específica de ESTE .Rmd)
```

### 2. Código sin contexto (PROHIBIDO)

```markdown
❌ ```r
   n <- sample(7:12, 1)
   ```

✅ ```r
   # Elegir cuántos datos tendrá la tabla (entre 7 y 12)
   # ¿Por qué 7-12? Menos de 7 hace la mediana trivial,
   # más de 12 hace la tabla difícil de leer en un examen
   n <- sample(7:12, 1)
   ```
```

### 3. Analogías forzadas (PROHIBIDO)

```markdown
❌ "El vector sol es como una orquesta donde cada instrumento..."
   (Analogía rebuscada que confunde más de lo que aclara)

✅ "El vector sol marca cuál opción es la correcta: un vector de ceros
   con un solo 1 en la posición de la respuesta correcta. Es como
   marcar con un check (✓) la respuesta en una hoja de examen."
   (Analogía directa y útil)
```

## Ejemplo de invocación

```
Usuario: /generar-walkthrough A-Produccion/03-En-Produccion/.../diagrama_venn_encuesta_metacognitivo_interpretacion_n2_schoice_v1.Rmd

Claude:
[Modelo: Opus] Leyendo y analizando diagrama_venn_encuesta...
  → Tipo: SCHOICE | Metacognitivo | Con gráficos TikZ | 1164 líneas
  → 8 contextos narrativos | 12 errores conceptuales | 4 categorías de región

[Modelo: Sonnet] Redactando y escribiendo walkthrough.md...

[Modelo: Opus] Verificando resultado...

✅ Walkthrough generado:
   → .../diagrama_venn_encuesta_.../walkthrough.md
   → 739 líneas | 7 secciones | Modelos: Opus (análisis) + Sonnet (redacción)
```
