# Regla: Contextos Narrativos Creativos (OBLIGATORIO)

## Principio Fundamental

**Los contextos narrativos de los ejercicios DEBEN ser variados, naturales y no mecánicos. PROHIBIDO el patrón repetitivo "Un(a) [oficio], [nombre], [verbo genérico]..."**

---

## El Problema

El patrón mecánico produce enunciados predecibles que el estudiante deja de leer:

```
❌ "Una profesora de estadística, Mariana, registró las calificaciones..."
❌ "Un entrenador de baloncesto, Carlos, registró los puntos anotados..."
❌ "Una nutricionista escolar, Elena, registró el consumo diario..."
❌ "Un coordinador académico, Eduardo, registró las horas de estudio..."
```

Todos siguen la misma estructura: `Un(a) [oficio], [nombre], [registró/recopiló] [datos]`.
El estudiante detecta el patrón y deja de procesar el contexto como información significativa.

---

## Solución: Pool de Plantillas Narrativas

En lugar de una sola plantilla, cada ejercicio DEBE definir un **pool de plantillas narrativas** que varían la estructura gramatical, el tono y la perspectiva.

### Estructura del Pool

```r
# Pool de contextos con plantillas narrativas variadas
contextos <- list(
  list(
    # --- Datos del contexto (igual que antes) ---
    tema = "calificaciones",
    unidad = "puntos",
    rango_min = 50, rango_max = 100,

    # --- NUEVO: Plantilla narrativa ---
    # Función que recibe (protagonista, n) y devuelve el enunciado
    plantilla = function(prot, n) {
      paste0(
        "Al final del semestre, ", prot,
        " reunió las calificaciones de ", n,
        " estudiantes para analizar el rendimiento del grupo."
      )
    },
    # Protagonistas con contexto integrado (no solo nombres)
    protagonistas = c(
      "la profesora de estadística",
      "el director del programa",
      "la coordinadora del área de ciencias"
    )
  ),
  # ... más contextos
)
```

### Tipos de Plantillas (Mínimo 5 tipos diferentes por ejercicio)

| Tipo | Ejemplo | Estructura |
|------|---------|-----------|
| **Acción en curso** | "Durante la última jornada deportiva, se midieron los tiempos de 10 corredores." | Circunstancia temporal + acción pasiva |
| **Descubrimiento** | "Al revisar los registros de la biblioteca, la coordinadora encontró datos interesantes sobre los préstamos del mes." | Acción + hallazgo |
| **Situación problema** | "El comité de evaluación necesita determinar si el rendimiento del grupo mejoró. Para ello, recopilaron las siguientes notas:" | Necesidad + acción |
| **Narración periodística** | "En el colegio San Martín, los estudiantes de décimo grado presentaron sus resultados en la feria de ciencias. Las puntuaciones obtenidas fueron:" | Lugar + evento + datos |
| **Diálogo implícito** | "—Necesitamos estos datos para el informe —dijo la rectora. Los resultados del simulacro fueron:" | Cita + contexto |
| **Perspectiva del estudiante** | "Para su proyecto de clase, Valentina recopiló las edades de sus compañeros de grupo." | Motivación + acción |
| **Contexto institucional** | "El boletín trimestral del colegio reportó las siguientes cifras de asistencia para cada salón:" | Documento + datos |
| **Pregunta retórica** | "¿Cuántas horas dedican los estudiantes al estudio independiente? Una encuesta en el colegio arrojó los siguientes resultados:" | Pregunta + respuesta |

### Ejemplo Completo de Pool Variado

```r
contextos <- list(
  # Tipo: Acción en curso
  list(
    plantilla = function(prot, n) {
      paste0("Durante la última jornada de evaluación, se registraron ",
             "las calificaciones de ", n, " estudiantes del curso de ", prot, ".")
    },
    protagonistas = c("matemáticas", "ciencias naturales", "lenguaje"),
    unidad = "puntos", rango_min = 50, rango_max = 100
  ),

  # Tipo: Situación problema
  list(
    plantilla = function(prot, n) {
      paste0("El comité de bienestar del colegio quiere saber si los estudiantes ",
             "duermen lo suficiente. Se preguntó a ", n, " estudiantes de ", prot,
             " cuántas horas durmieron la noche anterior.")
    },
    protagonistas = c("décimo grado", "noveno A", "undécimo"),
    unidad = "horas", rango_min = 4, rango_max = 11
  ),

  # Tipo: Narración periodística
  list(
    plantilla = function(prot, n) {
      paste0("En ", prot, ", ", n, " atletas compitieron en la carrera de ",
             "velocidad. Los tiempos registrados (en segundos) fueron:")
    },
    protagonistas = c(
      "los Juegos Intercolegiados de Bogotá",
      "el campeonato departamental de atletismo",
      "la final de los Juegos Supérate"
    ),
    unidad = "segundos", rango_min = 10, rango_max = 18
  ),

  # Tipo: Perspectiva del estudiante
  list(
    plantilla = function(prot, n) {
      paste0(prot, " necesita analizar datos para su proyecto de estadística. ",
             "Preguntó a ", n, " compañeros cuántos libros leyeron el año pasado ",
             "y obtuvo las siguientes respuestas:")
    },
    protagonistas = c("Valentina", "Santiago", "Isabela", "Mateo", "Luciana"),
    unidad = "libros", rango_min = 1, rango_max = 15
  ),

  # Tipo: Contexto institucional
  list(
    plantilla = function(prot, n) {
      paste0("El informe mensual de ", prot, " incluye el número de ",
             "actividades extracurriculares en las que participó cada uno de ",
             n, " estudiantes seleccionados al azar:")
    },
    protagonistas = c(
      "la oficina de orientación",
      "coordinación académica",
      "la secretaría del colegio"
    ),
    unidad = "actividades", rango_min = 0, rango_max = 8
  ),

  # Tipo: Pregunta retórica
  list(
    plantilla = function(prot, n) {
      paste0("¿Cuánto gastan en transporte los estudiantes cada semana? ",
             "Una encuesta realizada por ", prot, " a ", n,
             " estudiantes arrojó estos montos (en miles de pesos):")
    },
    protagonistas = c(
      "el consejo estudiantil",
      "el grupo de investigación del colegio",
      "la clase de sociales de décimo"
    ),
    unidad = "miles de pesos", rango_min = 5, rango_max = 40
  ),

  # Tipo: Descubrimiento
  list(
    plantilla = function(prot, n) {
      paste0("Al organizar los archivos del laboratorio, ", prot,
             " encontró los registros de temperatura (en °C) tomados por ", n,
             " equipos de trabajo durante el último experimento:")
    },
    protagonistas = c(
      "la profesora de química",
      "el monitor del laboratorio",
      "el técnico de ciencias"
    ),
    unidad = "°C", rango_min = 15, rango_max = 45
  ),

  # Tipo: Diálogo implícito
  list(
    plantilla = function(prot, n) {
      paste0("—Necesito que analicen estos datos antes de la próxima clase —indicó ",
             prot, " a sus estudiantes. Los ", n, " valores corresponden ",
             "a las puntuaciones del último quiz:")
    },
    protagonistas = c(
      "el profesor de álgebra",
      "la profesora de geometría",
      "el docente de trigonometría"
    ),
    unidad = "puntos", rango_min = 10, rango_max = 50
  )
)
```

### Uso en data_generation

```r
# Seleccionar contexto aleatorio
ctx <- contextos[[sample(length(contextos), 1)]]

# Seleccionar protagonista aleatorio del contexto
prot <- sample(ctx$protagonistas, 1)

# Generar enunciado usando la plantilla
enunciado_contexto <- ctx$plantilla(prot, n)

# Resultado: texto variado y natural cada vez
```

---

## Reglas Específicas

### 1. Mínimo 6 plantillas por ejercicio con al menos 5 tipos diferentes

No repetir el mismo tipo de estructura narrativa.

### 2. PROHIBIDO el verbo "registró" como default

El verbo "registró" (o "recopiló", "anotó") no debe aparecer en más del 25% de las plantillas.

### 3. Los protagonistas NO son siempre personas con oficio

Pueden ser:
- Instituciones ("el colegio", "la secretaría")
- Estudiantes ("Para su proyecto, Valentina...")
- Documentos ("El boletín trimestral reportó...")
- Eventos ("Durante los Juegos Intercolegiados...")
- Encuestas ("Una encuesta realizada por...")

### 4. La plantilla es una FUNCIÓN, no un string con `paste0` fijo

```r
# ❌ PROHIBIDO: string fijo interpolado
enunciado <- paste0("Un(a) ", rol, ", ", nombre, ", registró ", datos)

# ✅ CORRECTO: función que genera variedad
plantilla = function(prot, n) { ... }
```

### 5. Cada plantilla debe poder leerse de forma independiente

No depender de variables externas más allá de `prot` y `n` (y opcionalmente `unidad`).

---

## Antipatrones PROHIBIDOS

### 1. Estructura repetitiva "Un(a) [oficio], [nombre], [verbo]..."

```r
# ❌ PROHIBIDO: todas las plantillas siguen el mismo patrón
list(rol = "profesora", nombre = "Mariana", ...)
list(rol = "entrenador", nombre = "Carlos", ...)
list(rol = "nutricionista", nombre = "Elena", ...)
```

### 2. Solo cambiar el nombre y el oficio

```r
# ❌ PROHIBIDO: misma estructura, diferentes nombres
"Una profesora, Mariana, registró..."
"Un entrenador, Carlos, registró..."
# ↑ Esto NO es variedad narrativa
```

### 3. Pool de 2-3 contextos (insuficiente)

```r
# ❌ PROHIBIDO: pocos contextos = repetición
contextos <- list(ctx1, ctx2)  # Solo 2
```

### 4. Plantillas que suenan artificiales

```r
# ❌ PROHIBIDO: suena a ejercicio generado por máquina
"El sujeto X midió la variable Y para N unidades experimentales."
```

---

## Checklist Pre-Generación

- [ ] ¿Hay al menos 6 contextos con plantillas narrativas?
- [ ] ¿Hay al menos 5 tipos de estructura diferentes?
- [ ] ¿El verbo "registró" aparece en máximo 25% de plantillas?
- [ ] ¿Los protagonistas incluyen al menos 2 categorías (personas, instituciones, eventos)?
- [ ] ¿Las plantillas suenan naturales al leerlas en voz alta?
- [ ] ¿Cada plantilla es una función, no un string fijo?

---

## Integración con Detractor

El dominio `pedagogico` del detractor DEBE verificar:

1. Pool de contextos tiene 6+ plantillas
2. Al menos 5 tipos de estructura narrativa diferentes
3. No más del 25% de plantillas usan "registró" como verbo principal
4. Las plantillas son funciones, no strings fijos
5. Los enunciados generados suenan naturales

---

**Versión**: 1.0
**Fecha**: 2026-02-10
**Estado**: ACTIVO Y OBLIGATORIO
**Aplica a**: Todo .Rmd generado A PARTIR de esta fecha
**NO aplica retroactivamente** a ejercicios ya escritos
