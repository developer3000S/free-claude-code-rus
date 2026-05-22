# Principios de Aprendizaje Basados en Evidencias

## 🎯 Propósito

Guía práctica para aplicar principios de aprendizaje científicamente validados al diseño de ejercicios ICFES matemáticos.

---

## 📚 Fundamentos Teóricos

**Base científica**: Meta-análisis de >300 estudios en ciencias cognitivas del aprendizaje (Dunlosky et al., 2013; Brown et al., 2014).

**Principio rector**: Diseñar ejercicios que optimicen **retención a largo plazo** y **transferencia de conocimiento**, no solo desempeño inmediato.

---

## 1️⃣ RETRIEVAL PRACTICE (Práctica de Recuperación)

### Fundamento Científico

**Investigación clave**: Karpicke & Roediger (2008) - *Science*

**Hallazgo**: Recuperar información de memoria fortalece más el aprendizaje que re-estudiar el mismo material.

**Efecto cuantificado**:
- Re-estudio: 34% retención después de 1 semana
- Retrieval practice: 61% retención después de 1 semana
- **Tamaño de efecto**: d = 0.50 (Cohen's d)

### Mecanismo Cognitivo

1. **Esfuerzo de recuperación** activa rutas neuronales específicas
2. **Reconsolidación** fortalece trazos de memoria cada vez que se recuperan
3. **Elaboración automática** al intentar recordar (conecta con conocimiento previo)

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Ejemplo 1: Pregunta que requiere recuperación**
```
Un triángulo rectángulo tiene catetos de 6 cm y 8 cm.
¿Cuál es la longitud de la hipotenusa?

A) 10 cm  ✓
B) 14 cm
C) 48 cm
D) 100 cm
```

**Por qué funciona**:
- Estudiante debe RECUPERAR Teorema de Pitágoras de memoria
- No hay pistas visuales (fórmula visible, diagrama con etiquetas)
- Requiere aplicar conocimiento recuperado activamente

**Ejemplo 2: Pregunta de concepto sin fórmula visible**
```
La pendiente de una recta que pasa por (2, 5) y (6, 13) es:

A) 2  ✓
B) 4
C) 8
D) 1/2
```

**Por qué funciona**:
- Debe recordar m = (y₂ - y₁)/(x₂ - x₁)
- No hay fórmula visible en el enunciado
- Recuperación activa del procedimiento

#### ❌ ANTIPATRÓN

**Ejemplo MALO: Fórmula visible (no requiere recuperación)**
```
Usando la fórmula A = πr², calcula el área de un círculo con radio 5 cm.

A) 25π cm²  ✓
B) 10π cm²
C) 5π cm²
D) 25 cm²
```

**Por qué es malo**:
- Fórmula explícita → no hay recuperación de memoria
- Solo requiere sustitución mecánica
- No fortalece retención a largo plazo

### Implementación en R-exams

```r
# ✓ BIEN - Sin pistas visuales
question_text <- "Un auto viaja a 80 km/h durante 2.5 horas. ¿Qué distancia recorre?"
# Estudiante debe recordar d = v × t

# ❌ MAL - Fórmula visible
question_text <- "Usando d = v × t, si v = 80 km/h y t = 2.5 h, calcula d."
```

---

## 2️⃣ SPACED REPETITION (Repetición Espaciada)

### Fundamento Científico

**Investigación clave**: Cepeda et al. (2006) - *Psychological Bulletin*

**Hallazgo**: Distribuir práctica en múltiples sesiones separadas en el tiempo produce retención superior a práctica masiva.

**Curva óptima de espaciamiento**:
- 1ra revisión: 1 día después
- 2da revisión: 3 días después
- 3ra revisión: 7 días después
- 4ta revisión: 14 días después
- 5ta revisión: 30 días después

**Efecto cuantificado**: d = 0.71 (grande)

### Mecanismo Cognitivo

1. **Olvido intencional**: Permitir que información se debilite parcialmente
2. **Reconsolidación mejorada**: Cada recuperación post-olvido fortalece más la memoria
3. **Discriminación contextual**: Múltiples contextos de recuperación mejoran transferencia

### Aplicación a Ejercicios ICFES

#### Estrategia 1: Familias de Ejercicios Relacionados

**Concepto clave**: Área de figuras compuestas

**Ejercicio 1 (Sesión 1)**:
```
Calcula el área de un rectángulo con lados 8 cm y 5 cm.
```

**Ejercicio 2 (Sesión 2 - 3 días después)**:
```
Un terreno rectangular mide 12 m de largo y 7 m de ancho. ¿Cuál es su área?
```

**Ejercicio 3 (Sesión 3 - 7 días después)**:
```
Una figura en forma de L se compone de dos rectángulos:
- Rectángulo A: 10 cm × 4 cm
- Rectángulo B: 6 cm × 3 cm
¿Cuál es el área total?
```

**Por qué funciona**:
- Mismo concepto (área rectángulo) en contextos diferentes
- Complejidad incremental
- Espaciamiento permite consolidación

#### Estrategia 2: Interleaving con Revisión

**No hacer**: 10 ejercicios de Pitágoras en secuencia

**Hacer**: Alternar conceptos y revisar Pitágoras espaciadamente
- Día 1: Pitágoras (Ej. 1)
- Día 1: Áreas
- Día 1: Proporciones
- Día 4: Pitágoras (Ej. 2) ← Primera revisión
- Día 4: Ecuaciones
- Día 11: Pitágoras (Ej. 3) ← Segunda revisión

### Implementación en R-exams

```r
# Metadatos para tracking de espaciamiento
exextra[ConceptoFamilia]: "area_rectangulo"
exextra[NivelEspaciamiento]: 2  # 1=primera exposición, 2=revisión_3dias, 3=revisión_7dias
exextra[ConceptosPrerequisito]: "multiplicacion_basica,unidades_area"
```

---

## 3️⃣ INTERLEAVING (Intercalado)

### Fundamento Científico

**Investigación clave**: Rohrer & Taylor (2007) - *Applied Cognitive Psychology*

**Hallazgo**: Mezclar problemas de diferentes tipos produce mejor transferencia que practicar un tipo a la vez (blocked practice).

**Experimento clásico**:
- **Blocked**: AAAA BBBB CCCC → 38% retención
- **Interleaved**: ABC ABC ABC ABC → 63% retención
- **Tamaño de efecto**: d = 0.42

### Mecanismo Cognitivo

1. **Discriminación**: Fuerza al estudiante a identificar QUÉ tipo de problema es
2. **Contraste**: Comparar/contrastar estrategias diferentes
3. **Generalización**: Aprender cuándo aplicar cada método

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Secuencia intercalada de problemas de geometría**:

**Problema 1 (Área de círculo)**:
```
Un círculo tiene radio 4 cm. ¿Cuál es su área?
```

**Problema 2 (Perímetro de rectángulo)**:
```
Un rectángulo mide 7 cm × 3 cm. ¿Cuál es su perímetro?
```

**Problema 3 (Volumen de cilindro)**:
```
Un cilindro tiene radio 2 cm y altura 5 cm. ¿Cuál es su volumen?
```

**Problema 4 (Área de círculo - revisión)**:
```
Un parque circular tiene diámetro 20 m. ¿Cuál es su área?
```

**Por qué funciona**:
- Estudiante debe identificar qué fórmula usar (discriminación)
- Compara área vs perímetro vs volumen (contraste)
- Aprende a seleccionar estrategia apropiada (transferencia)

#### ❌ ANTIPATRÓN

**Secuencia bloqueada (EVITAR)**:
```
Problema 1: Área círculo radio 3
Problema 2: Área círculo radio 5
Problema 3: Área círculo radio 7
Problema 4: Área círculo diámetro 10
```

**Por qué es malo**:
- Estudiante no necesita identificar tipo de problema
- Solo sustituye valores en misma fórmula repetidamente
- No desarrolla discriminación ni transferencia

### Implementación en R-exams

```r
# Examen con intercalado
problemas <- sample(c(
  "area_circulo",
  "perimetro_rectangulo",
  "volumen_cilindro",
  "area_triangulo",
  "perimetro_circulo"
), size = 5, replace = FALSE)  # Sin reemplazo = intercalado garantizado

exextra[SecuenciaIntercalada]: TRUE
exextra[TiposConceptos]: "area,perimetro,volumen"
```

---

## 4️⃣ ELABORATIVE INTERROGATION (Interrogación Elaborativa)

### Fundamento Científico

**Investigación clave**: Dunlosky et al. (2013) - *Psychological Science in the Public Interest*

**Hallazgo**: Preguntar "¿POR QUÉ esto es cierto?" mejora comprensión y retención más que simplemente estudiar hechos.

**Efectividad**: Moderada a alta (d = 0.30-0.60 según dominio)

### Mecanismo Cognitivo

1. **Elaboración causal**: Conectar nueva información con conocimiento previo
2. **Coherencia**: Construir modelo mental integrado
3. **Monitoreo metacognitivo**: Detectar lagunas en comprensión

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Ejemplo 1: Pregunta con justificación**
```
María afirma: "Si duplico el radio de un círculo, su área se duplica".

¿Por qué esta afirmación es INCORRECTA?

A) Porque el área es proporcional al radio, no al diámetro
B) Porque el área depende de π, que es constante
C) Porque el área es proporcional al cuadrado del radio,
   entonces se cuadruplica al duplicar el radio  ✓
D) Porque el área se mide en cm², no en cm
```

**Por qué funciona**:
- Requiere explicar CAUSA del error
- No basta con saber la respuesta correcta
- Fortalece comprensión conceptual

**Ejemplo 2: Razonamiento explícito en opciones**
```
¿Por qué 0.999... = 1?

A) Porque 0.999... es muy cercano a 1, entonces los redondeamos
B) Porque es una convención matemática arbitraria
C) Porque (10 × 0.999...) - 0.999... = 9, entonces 9 × 0.999... = 9,
   por lo tanto 0.999... = 1  ✓
D) Porque en la recta numérica no hay espacio entre 0.999... y 1
```

**Por qué funciona**:
- Cada opción presenta un razonamiento completo
- Estudiante evalúa lógica de cada argumento
- Desarrolla pensamiento crítico

#### ❌ ANTIPATRÓN

**Ejemplo MALO: Pregunta sin elaboración**
```
¿Cuánto es 2 + 2?

A) 3
B) 4  ✓
C) 5
D) 6
```

**Por qué es malo**:
- No requiere elaboración ni justificación
- Solo reconocimiento de hecho memorizado
- No desarrolla comprensión profunda

### Implementación en R-exams

```r
# Estructura de pregunta con elaboración
question_text <- paste0(
  "Juan dice: '", misconception, "'\n\n",
  "¿Por qué este razonamiento es incorrecto?\n\n",
  "Selecciona la explicación MÁS COMPLETA:"
)

# Opciones incluyen razonamientos completos
answerlist <- c(
  "Porque [explicación superficial]",
  "Porque [explicación con causa raíz]",  # Correcta
  "Porque [error conceptual alternativo]",
  "Porque [confusión de términos]"
)
```

---

## 5️⃣ CONCRETE EXAMPLES (Ejemplos Concretos)

### Fundamento Científico

**Investigación clave**: Bruner (1966) - *Toward a Theory of Instruction*

**Hallazgo**: Aprendizaje progresa de:
1. **Enactivo** (manipulación física)
2. **Icónico** (representación visual)
3. **Simbólico** (abstracción formal)

**Efecto**: Ejemplos concretos facilitan transferencia a abstracto (d = 0.50)

### Mecanismo Cognitivo

1. **Anclaje perceptual**: Conceptos abstractos se anclan en experiencias concretas
2. **Transferencia analógica**: Lo concreto sirve de modelo para lo abstracto
3. **Reducción de carga cognitiva**: Concreto es más fácil de procesar

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Ejemplo 1: Probabilidad con contexto concreto**
```
En una bolsa hay 3 bolas rojas y 7 bolas azules.
Si sacas una bola al azar, ¿cuál es la probabilidad de que sea roja?

A) 3/7
B) 3/10  ✓
C) 7/10
D) 3/13
```

**Versión abstracta (más difícil)**:
```
Si P(A) = 0.3 y P(B) = 0.7, y A y B son mutuamente excluyentes,
¿cuál es P(A)?

[Mismas opciones numéricas]
```

**Por qué concreto funciona mejor**:
- "Bolas en bolsa" es manipulable mentalmente
- Estudiante puede visualizar situación
- Facilita razonamiento sobre espacio muestral

**Ejemplo 2: Proporcionalidad con contexto real**
```
Si 3 obreros construyen un muro en 12 días,
¿cuánto tardan 6 obreros en construir el mismo muro?

A) 24 días
B) 12 días
C) 6 días  ✓
D) 3 días
```

**Versión abstracta (más difícil)**:
```
Si x · y = k (constante), y x = 3 cuando y = 12,
encuentra y cuando x = 6.

[Mismas opciones numéricas]
```

**Por qué concreto funciona mejor**:
- "Obreros construyendo muro" activa conocimiento del mundo
- Relación inversa es intuitiva (más obreros → menos tiempo)
- Contexto ayuda a discriminar relación directa vs inversa

#### Progresión Recomendada: Concreto → Abstracto

**Nivel 1 (Concreto)**:
```
Ana tiene $50,000 y gasta $2,000 cada día.
¿Cuántos días puede mantener este gasto?
```

**Nivel 2 (Semi-concreto)**:
```
Un tanque con 500 litros se vacía a razón de 20 litros/hora.
¿Cuánto tarda en vaciarse?
```

**Nivel 3 (Semi-abstracto)**:
```
Una variable disminuye linealmente desde 1000 a razón de 40 unidades/tiempo.
¿Cuándo llega a cero?
```

**Nivel 4 (Abstracto)**:
```
Si f(t) = a - bt, con f(0) = 1000 y b = 40,
encuentra t tal que f(t) = 0.
```

### Implementación en R-exams

```r
# Generar contextos concretos variados
contextos_concretos <- c(
  "dinero_gastos",
  "tanque_agua",
  "distancia_viaje",
  "poblacion_animales",
  "produccion_fabrica"
)

contexto <- sample(contextos_concretos, 1)

if (contexto == "dinero_gastos") {
  cantidad_inicial <- sample(seq(10000, 100000, 5000), 1)
  tasa <- sample(seq(500, 5000, 500), 1)
  pregunta <- paste0(
    "María tiene $", cantidad_inicial,
    " y gasta $", tasa, " cada día. ",
    "¿Cuántos días puede mantener este gasto?"
  )
}

exextra[TipoRepresentacion]: "concreto"  # vs "abstracto"
exextra[Contexto]: contexto
```

---

## 6️⃣ DUAL CODING (Codificación Dual)

### Fundamento Científico

**Investigación clave**: Paivio (1971) - *Imagery and Verbal Processes*

**Hallazgo**: Información codificada en AMBOS canales (verbal y visual) se recuerda mejor que información en un solo canal.

**Efecto cuantificado**:
- Solo verbal: 40% retención
- Solo visual: 45% retención
- Verbal + Visual: 70% retención
- **Tamaño de efecto**: d = 0.65

### Mecanismo Cognitivo

1. **Dos trazos de memoria**: Verbal y visual independientes
2. **Redundancia beneficiosa**: Dos rutas de acceso a misma información
3. **Procesamiento profundo**: Traducir entre representaciones requiere elaboración

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Ejemplo 1: Función cuadrática (Dual coding)**
```
[GRÁFICO: Parábola y = x² - 4x + 3]

La función representada en el gráfico tiene sus raíces en:

A) x = 1 y x = 3  ✓
B) x = -1 y x = -3
C) x = 0 y x = 4
D) x = 2 (raíz doble)
```

**Por qué funciona**:
- Representación VISUAL (gráfico) + representación VERBAL (descripción)
- Estudiante conecta ambas representaciones
- Fortalece comprensión del concepto "raíz"

**Ejemplo 2: Estadística (Tabla + Gráfico)**
```
[TABLA]
Edad | Frecuencia
-----|----------
10   | 5
11   | 8
12   | 12
13   | 7

[GRÁFICO DE BARRAS correspondiente]

¿Cuál es la mediana de las edades?

A) 11
B) 11.5  ✓
C) 12
D) 11.75
```

**Por qué funciona**:
- Información en TRES formatos: tabla, gráfico, texto
- Estudiante integra múltiples representaciones
- Desarrolla flexibilidad representacional

#### ❌ ANTIPATRÓN

**Ejemplo MALO: Solo texto sin soporte visual**
```
Una función cuadrática tiene raíces en x = 1 y x = 3,
y su vértice está en x = 2. ¿Cuál es la función?

[Sin gráfico de apoyo]
```

**Por qué es subóptimo**:
- Solo codificación verbal
- Pierde oportunidad de dual coding
- Más difícil de procesar (mayor carga cognitiva)

### Implementación en R-exams

```r
# SIEMPRE incluir representación visual cuando sea posible

# Generar datos
x <- seq(1, 5, 0.1)
y <- x^2 - 4*x + 3

# Gráfico (representación visual)
library(ggplot2)
p <- ggplot(data.frame(x, y), aes(x, y)) +
  geom_line(linewidth = 1.2) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Función cuadrática",
       x = "x", y = "y = f(x)") +
  theme_minimal(base_size = 14)

ggsave("grafico_funcion.png", p, width = 6, height = 4)

# Texto (representación verbal)
question_text <- paste0(
  "La función representada en el gráfico tiene raíces en:\n\n",
  "<<include_supplement('grafico_funcion.png', height='4cm')>>"
)

exextra[DualCoding]: TRUE
exextra[TiposRepresentacion]: "visual,verbal"
```

---

## 7️⃣ METACOGNITION (Metacognición)

### Fundamento Científico

**Investigación clave**: Schraw & Dennison (1994) - *Contemporary Educational Psychology*

**Hallazgo**: Estudiantes con alta metacognición (conciencia de su propio aprendizaje) tienen mejor desempeño académico.

**Componentes**:
1. **Conocimiento metacognitivo**: Saber qué sé y qué no sé
2. **Regulación metacognitiva**: Planificar, monitorear, evaluar aprendizaje

**Efecto cuantificado**: d = 0.62

### Mecanismo Cognitivo

1. **Monitoreo de comprensión**: Detectar cuándo no entiendo
2. **Calibración**: Ajustar confianza con desempeño real
3. **Corrección autogenerada**: Identificar y corregir errores propios

### Aplicación a Ejercicios ICFES

#### ✅ BUENAS PRÁCTICAS

**Ejemplo 1: Pregunta con autoevaluación de confianza**
```
Resuelve: Si 3x + 7 = 22, entonces x = ?

A) 5  ✓
B) 7
C) 15
D) 29/3

Después de seleccionar tu respuesta, evalúa tu confianza:
□ Muy seguro (90-100%)
□ Seguro (70-89%)
□ Inseguro (50-69%)
□ Muy inseguro (<50%)
```

**Por qué funciona**:
- Fuerza reflexión sobre nivel de certeza
- Desarrolla calibración (alinear confianza con precisión)
- Identifica áreas que requieren más estudio

**Ejemplo 2: Pregunta con verificación explícita**
```
Un triángulo tiene lados 5, 12 y 13 cm.
Es un triángulo rectángulo porque:

A) Tiene un ángulo de 90°
B) Sus lados cumplen a² + b² = c², es decir, 5² + 12² = 13²  ✓
C) Tiene dos lados perpendiculares
D) Su área es 30 cm²

Verifica tu respuesta calculando: 5² + 12² = ___ y 13² = ___
¿Son iguales? Sí / No
```

**Por qué funciona**:
- Prompt explícito para verificación
- Estudiante practica estrategia metacognitiva (checking)
- Desarrolla hábito de validar respuestas

#### Estrategias Metacognitivas para Enseñar

**1. Predict-Observe-Explain (POE)**
```
Predice: ¿Qué pasa con el área de un círculo si duplico su radio?
Opciones: Se duplica / Se cuadruplica / Se reduce a la mitad

Observa: A₁ = π(r)² = πr²
         A₂ = π(2r)² = 4πr²

Explica: El área se cuadruplica porque el radio está elevado al cuadrado.
```

**2. Common Errors Checklist**
```
Antes de responder, pregúntate:

□ ¿Leí el problema completo?
□ ¿Identifiqué qué me están preguntando?
□ ¿Confundí área con perímetro?
□ ¿Apliqué la fórmula correcta?
□ ¿Verifiqué las unidades?
□ ¿Mi respuesta tiene sentido?
```

**3. Self-Explanation Prompts**
```
Después de resolver:

¿Por qué elegiste esta estrategia?
¿Qué fórmula/concepto usaste?
¿Cómo sabes que tu respuesta es correcta?
¿Qué harías diferente si tuvieras que resolver un problema similar?
```

### Implementación en R-exams

```r
# Incluir en Solution sección de metacognición
solution_text <- paste0(
  "**Solución correcta**: ", respuesta_correcta, "\n\n",
  "**¿Cómo verificar tu respuesta?**\n",
  "1. ", paso_verificacion_1, "\n",
  "2. ", paso_verificacion_2, "\n\n",
  "**Errores comunes en este tipo de problema**:\n",
  "- ", error_comun_1, "\n",
  "- ", error_comun_2, "\n\n",
  "**Estrategia general**:\n",
  estrategia_metacognitiva
)

exextra[IncludeMetacognicion]: TRUE
exextra[TipoMetacognicion]: "verificacion,errores_comunes,estrategia"
```

---

## 🎯 Aplicación Integrada de los 7 Principios

### Ejemplo Completo: Ejercicio de Proporcionalidad

```r
<<include=FALSE>>=
# 1. RETRIEVAL PRACTICE - Sin fórmula visible
# 2. SPACED REPETITION - Parte de familia "proporcionalidad_inversa"
# 3. INTERLEAVING - Mezclado con directa/compuesta
# 4. ELABORATIVE INTERROGATION - Pregunta por "¿por qué?"
# 5. CONCRETE EXAMPLES - Contexto real (obreros)
# 6. DUAL CODING - Tabla + texto
# 7. METACOGNITION - Verificación explícita

n_obreros_inicial <- sample(c(3, 4, 5, 6), 1)
dias_inicial <- sample(c(12, 15, 18, 20, 24), 1)
n_obreros_nuevo <- n_obreros_inicial * 2

# Relación inversa: días = (n_inicial * dias_inicial) / n_nuevo
dias_nuevo <- (n_obreros_inicial * dias_inicial) / n_obreros_nuevo

# Distractores basados en errores conceptuales documentados
distractor_directa <- dias_inicial * 2  # Error: aplica proporcionalidad directa
distractor_suma <- dias_inicial + n_obreros_nuevo  # Error: suma en lugar de producto
distractor_sin_cambio <- dias_inicial  # Error: ignora cambio de obreros
@

**Question**

[TABLA]
| Obreros | Días para construir muro |
|---------|-------------------------|
| `r n_obreros_inicial` | `r dias_inicial` |
| `r n_obreros_nuevo` | ? |

`r n_obreros_inicial` obreros tardan `r dias_inicial` días en construir un muro.

¿Por qué `r n_obreros_nuevo` obreros tardarán `r dias_nuevo` días
(y no `r distractor_directa` días)?

**Answerlist**

* Porque más obreros → más tiempo (proporcionalidad directa)
* Porque el trabajo total es constante (`r n_obreros_inicial` × `r dias_inicial` = `r n_obreros_nuevo` × `r dias_nuevo`), entonces más obreros → menos tiempo (proporcionalidad inversa)  [CORRECTA]
* Porque se suman los obreros nuevos al tiempo original
* Porque el tiempo no depende del número de obreros

**Solution**

**Solución correcta**: `r dias_nuevo` días

**¿Cómo verificar?**

1. Calcula el "trabajo total": `r n_obreros_inicial` obreros × `r dias_inicial` días = `r n_obreros_inicial * dias_inicial` obreros-día

2. Con `r n_obreros_nuevo` obreros: `r n_obreros_inicial * dias_inicial` obreros-día ÷ `r n_obreros_nuevo` obreros = `r dias_nuevo` días

3. Verifica la relación inversa: Si obreros se duplican, tiempo se reduce a la mitad ✓

**Errores comunes**:
- Aplicar proporcionalidad directa (más obreros → más tiempo) ✗
- Sumar o restar en lugar de usar producto constante ✗

**Estrategia general para proporcionalidad inversa**:
1. Identifica que una variable aumenta mientras otra disminuye
2. Calcula el producto constante (k = x₁ × y₁)
3. Despeja la incógnita usando k = x₂ × y₂

---

**Meta**: `r n_obreros_inicial` obreros, `r dias_inicial` días
**Solución**: `r dias_nuevo` días
**Tipo**: Proporcionalidad inversa
**Nivel**: 2
**Competencia**: Razonamiento
**Componente**: Cambio y Variación
**Principios aplicados**: Retrieval, Elaboration, Concrete, Dual, Metacognition
```

---

## 📊 Matriz de Aplicación por Tipo de Ejercicio

| Tipo de Ejercicio | Retrieval | Spaced | Interleaving | Elaboration | Concrete | Dual | Metacog |
|------------------|-----------|--------|-------------|-------------|----------|------|---------|
| Cálculo numérico | ✓✓✓ | ✓✓ | ✓✓✓ | ✓ | ✓✓ | ✓ | ✓✓ |
| Geometría | ✓✓ | ✓✓✓ | ✓✓ | ✓✓ | ✓✓✓ | ✓✓✓ | ✓✓ |
| Álgebra | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓ | ✓✓ | ✓✓✓ |
| Probabilidad | ✓✓ | ✓✓ | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓ |
| Estadística | ✓✓ | ✓✓ | ✓✓ | ✓✓ | ✓✓✓ | ✓✓✓ | ✓✓ |
| Funciones | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓✓ | ✓✓ | ✓✓✓ | ✓✓✓ |

**Leyenda**:
- ✓ = Aplicable
- ✓✓ = Recomendado
- ✓✓✓ = Crítico/Esencial

---

## 📚 Referencias Bibliográficas

1. **Retrieval Practice**
   - Karpicke, J. D., & Roediger, H. L. (2008). The critical importance of retrieval for learning. *Science*, 319(5865), 966-968.

2. **Spaced Repetition**
   - Cepeda, N. J., Pashler, H., Vul, E., Wixted, J. T., & Rohrer, D. (2006). Distributed practice in verbal recall tasks: A review and quantitative synthesis. *Psychological Bulletin*, 132(3), 354-380.

3. **Interleaving**
   - Rohrer, D., & Taylor, K. (2007). The shuffling of mathematics problems improves learning. *Instructional Science*, 35(6), 481-498.

4. **Elaborative Interrogation**
   - Dunlosky, J., Rawson, K. A., Marsh, E. J., Nathan, M. J., & Willingham, D. T. (2013). Improving students' learning with effective learning techniques. *Psychological Science in the Public Interest*, 14(1), 4-58.

5. **Concrete Examples**
   - Bruner, J. S. (1966). *Toward a theory of instruction*. Harvard University Press.

6. **Dual Coding**
   - Paivio, A. (1971). *Imagery and verbal processes*. Holt, Rinehart, and Winston.

7. **Metacognition**
   - Schraw, G., & Dennison, R. S. (1994). Assessing metacognitive awareness. *Contemporary Educational Psychology*, 19(4), 460-475.

8. **Meta-análisis**
   - Brown, P. C., Roediger III, H. L., & McDaniel, M. A. (2014). *Make it stick: The science of successful learning*. Harvard University Press.

---

**Versión**: 1.0.0
**Fecha**: 2026-02-04
**Actualización**: Incluye investigación hasta 2025
**Uso**: Base de conocimiento para AgentePedagogoICFES
