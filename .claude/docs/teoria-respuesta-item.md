# Teoría de Respuesta al Ítem (TRI)

## 🎯 Propósito

Guía para aplicar la Teoría de Respuesta al Ítem (Item Response Theory - IRT) en el diseño, análisis y optimización de ejercicios ICFES matemáticos.

---

## 📚 Fundamento Teórico

### Definición

> **TRI es un conjunto de modelos matemáticos que relacionan la probabilidad de responder correctamente un ítem con la habilidad latente del estudiante y las características psicométricas del ítem.**

**Diferencia clave con Teoría Clásica de Tests (TCT)**:
- **TCT**: Puntaje = suma de aciertos (dependiente del test)
- **TRI**: Habilidad estimada independiente del conjunto de ítems

### Principios Fundamentales

1. **Habilidad Latente (θ - theta)**: Constructo no observable que se infiere
2. **Independencia Local**: Respuestas a ítems son independientes dado θ
3. **Unidimensionalidad**: Ítems miden un solo constructo latente
4. **Curva Característica del Ítem (CCI)**: Relación θ → P(acierto)

---

## 📊 MODELOS TRI PRINCIPALES

### Modelo 1PL (Rasch)

**Ecuación**:
$$P(\theta) = \frac{e^{(\theta - b)}}{1 + e^{(\theta - b)}}$$

**Parámetro**:
- **b**: Dificultad del ítem (en escala θ)

**Interpretación**:
- b = 0: Ítem de dificultad media
- b > 0: Ítem difícil (requiere alta habilidad)
- b < 0: Ítem fácil (requiere baja habilidad)
- P(θ = b) = 0.50 (probabilidad 50% cuando habilidad = dificultad)

**Ventajas**:
- Simple, interpretable
- Requiere menos datos (≥200 estudiantes)
- Asume discriminación constante

**Desventajas**:
- Poco realista (ítems discriminan diferente)

**Uso en ICFES**: Calibración preliminar, screening inicial

---

### Modelo 2PL (2 Parámetros)

**Ecuación**:
$$P(\theta) = \frac{e^{a(\theta - b)}}{1 + e^{a(\theta - b)}}$$

**Parámetros**:
- **b**: Dificultad
- **a**: Discriminación (pendiente de CCI)

**Interpretación de a**:
- a = 0: Ítem no discrimina (inútil)
- 0 < a < 0.5: Discriminación muy baja
- 0.5 ≤ a < 1.0: Discriminación baja
- 1.0 ≤ a < 1.5: Discriminación moderada
- 1.5 ≤ a < 2.0: Discriminación alta
- a ≥ 2.0: Discriminación muy alta
- a < 0: Ítem mal diseñado (más habilidad → menos acierto)

**Ventajas**:
- Más realista que 1PL
- Identifica ítems problemáticos (a < 0.5)

**Desventajas**:
- Requiere más datos (≥500 estudiantes)

**Uso en ICFES**: Modelo estándar recomendado

---

### Modelo 3PL (3 Parámetros)

**Ecuación**:
$$P(\theta) = c + (1 - c) \frac{e^{a(\theta - b)}}{1 + e^{a(\theta - b)}}$$

**Parámetros**:
- **b**: Dificultad
- **a**: Discriminación
- **c**: Pseudo-azar (asíntota inferior)

**Interpretación de c**:
- c = 0: No hay azar (equivalente a 2PL)
- c = 0.25: Probabilidad de acierto por azar en 4 opciones
- c > número_opciones^(-1): Ítem con pistas inadvertidas

**Ventajas**:
- Más realista para selección múltiple
- Modela comportamiento de adivinación

**Desventajas**:
- Requiere muchos datos (≥1000 estudiantes)
- Difícil estimar c con precisión
- Puede sobreajustar

**Uso en ICFES**: Banco de ítems grande, análisis final

---

### Modelo 4PL (4 Parámetros) - Avanzado

**Ecuación**:
$$P(\theta) = c + (d - c) \frac{e^{a(\theta - b)}}{1 + e^{a(\theta - b)}}$$

**Parámetro adicional**:
- **d**: Asíntota superior (< 1)

**Interpretación de d**:
- d = 1: No hay límite superior (equivalente a 3PL)
- d < 1: Estudiantes de alta habilidad cometen errores (descuido, trampa)

**Uso en ICFES**: Raramente, solo investigación

---

## 📈 CURVA CARACTERÍSTICA DEL ÍTEM (CCI)

### Anatomía de la CCI

```
P(θ)
  1.0 ┤                    ___________  ← d (asíntota superior)
      │                  /
      │                /
      │              /
  0.5 ┤           • ← P(θ=b) = 0.5 + (c/2)
      │         /
      │      /
      │   /
    c ┤__/__________________________ ← c (asíntota inferior/azar)
      │
  0.0 └─────────────────────────────→ θ
        -3   -2   -1   0 b  1   2   3
```

### Información del Ítem

**Función de Información**:
$$I(\theta) = a^2 P(\theta) [1 - P(\theta)]$$

**Interpretación**:
- Máximo en θ = b (ítem informa más en su nivel de dificultad)
- Mayor a → mayor información
- I(θ) se usa para optimizar composición de tests

---

## 🎯 APLICACIÓN AL DISEÑO DE ÍTEMS ICFES

### Fase 1: Diseño Inicial (Pre-Pilotaje)

#### Objetivo: Crear ítems con parámetros objetivo

**Dificultad (b) objetivo según nivel ICFES**:

| Nivel ICFES | Habilidad (θ) | Dificultad (b) Recomendada | P(acierto) esperada |
|-------------|---------------|---------------------------|-------------------|
| **N1 (Mínimo)** | θ < -1.0 | -2.0 a -1.0 | 70-85% |
| **N2 (Satisfactorio)** | -1.0 ≤ θ < 0 | -1.0 a 0.0 | 50-70% |
| **N3 (Avanzado)** | 0 ≤ θ < 1.0 | 0.0 a 1.0 | 30-50% |
| **N4 (Superior)** | θ ≥ 1.0 | 1.0 a 2.0 | 15-30% |

**Discriminación (a) objetivo**:
- **Mínimo aceptable**: a ≥ 0.80
- **Recomendado**: 1.0 ≤ a ≤ 2.0
- **Óptimo**: a ≈ 1.5

**Azar (c) objetivo** (modelo 3PL):
- **Teórico**: c = 1/k (k = número de opciones)
- **ICFES (4 opciones)**: c ≈ 0.25
- **Aceptable**: 0.15 ≤ c ≤ 0.30
- **Alerta**: c > 0.35 (pistas inadvertidas)

---

### Fase 2: Pilotaje

#### Requisitos de Muestra

| Modelo | Tamaño Mínimo | Recomendado | Óptimo |
|--------|--------------|-------------|--------|
| **1PL** | 200 | 300 | 500+ |
| **2PL** | 500 | 700 | 1000+ |
| **3PL** | 1000 | 1500 | 2000+ |

**Composición de muestra**:
- Representativa de población objetivo
- Distribución de habilidad aproximadamente normal
- Incluir extremos (estudiantes muy débiles y muy fuertes)

#### Indicadores de Ajuste

**1. INFIT/OUTFIT (Rasch)**:
- **INFIT**: Ajuste ponderado (información)
- **OUTFIT**: Ajuste no ponderado (sensible a outliers)
- **Rango aceptable**: 0.7 - 1.3
- **Óptimo**: 0.9 - 1.1

**2. Chi-cuadrado de ajuste**:
- H₀: Datos se ajustan al modelo
- p > 0.05: Buen ajuste
- p < 0.01: Mal ajuste (revisar ítem)

**3. Residuos**:
- Diferencia entre P(θ) predicha y proporción observada
- Residuos grandes → ítem no se comporta como esperado

---

### Fase 3: Análisis Post-Pilotaje

#### Diagnóstico de Problemas

**Problema 1: a < 0 (Discriminación negativa)**

**Causa**:
- Clave incorrecta (respuesta "correcta" está mal)
- Distractor más atractivo para estudiantes fuertes
- Ítem ambiguo o mal redactado

**Solución**:
- Verificar clave
- Revisar distractor más elegido por estudiantes fuertes
- Reescribir ítem

---

**Problema 2: a < 0.5 (Discriminación muy baja)**

**Causa**:
- Ítem demasiado fácil o difícil (todos aciertan/fallan)
- Distractores débiles (descartables)
- Múltiples interpretaciones válidas

**Solución**:
- Ajustar dificultad (modificar números, contexto)
- Mejorar distractores (basarse en errores reales)
- Clarificar enunciado

---

**Problema 3: c > 0.35 (Azar alto)**

**Causa**:
- Pistas en enunciado o distractores
- Patrón en respuestas correctas (ej: siempre opción B)
- Distractores implausibles

**Solución**:
- Eliminar pistas
- Aleatorizar posición de correcta (exshuffle: TRUE; excepción: FALSE en SCHOICE con PNGs gráficos — ver `graficos-como-opciones.md`)
- Mejorar plausibilidad de distractores

---

**Problema 4: b muy extremo (|b| > 3)**

**Causa**:
- Ítem demasiado fácil (b < -3): Todos aciertan
- Ítem demasiado difícil (b > 3): Casi nadie acierta

**Solución**:
- Ajustar complejidad matemática
- Modificar contexto
- Cambiar nivel de abstracción

---

### Fase 4: Optimización de Banco de Ítems

#### Cobertura de Dificultad

**Objetivo**: Tener ítems distribuidos en todo el rango de θ

**Distribución ideal** (para test adaptativo):

| Rango θ | Porcentaje Ítems | Propósito |
|---------|-----------------|-----------|
| θ < -2.0 | 10% | Estudiantes muy débiles |
| -2.0 ≤ θ < -1.0 | 20% | Nivel 1 (Mínimo) |
| -1.0 ≤ θ < 0.0 | 25% | Nivel 2 (Satisfactorio) |
| 0.0 ≤ θ < 1.0 | 25% | Nivel 3 (Avanzado) |
| 1.0 ≤ θ < 2.0 | 15% | Nivel 4 (Superior) |
| θ ≥ 2.0 | 5% | Estudiantes excepcionales |

---

#### Función de Información del Test

**Objetivo**: Maximizar información en rangos de interés

**Ejemplo - Test ICFES**:
```
I(θ)
  12 ┤
     │     _______________
  10 ┤   /                 \
     │  /                   \
   8 ┤ /                     \
     │/                       \___
   6 ┤
     │
   4 ┤
     │
   2 ┤
     │
   0 └─────────────────────────────→ θ
      -3  -2  -1   0   1   2   3
           ↑       ↑
        Nivel 1  Nivel 3
```

**Meta ICFES**: I(θ) ≥ 8 en rango [-1.5, 1.5] (cubre N1-N3)

---

## 🧮 ESTIMACIÓN DE PARÁMETROS

### Software Recomendado

| Software | Modelos | Ventajas | Costo |
|----------|---------|----------|-------|
| **R (mirt, ltm)** | 1PL-4PL | Gratuito, flexible, integrable | Free |
| **IRTPRO** | 1PL-4PL | GUI amigable, potente | Pagado |
| **BILOG-MG** | 1PL-3PL | Estándar industria | Pagado |
| **TAM (R)** | Rasch, 2PL | Excelente para educación | Free |

### Código R Básico (mirt)

```r
library(mirt)

# Datos: matriz (estudiantes × ítems)
# 1 = correcto, 0 = incorrecto
datos <- matrix(...)

# Modelo 2PL
modelo_2pl <- mirt(datos, model = 1, itemtype = "2PL")

# Extraer parámetros
parametros <- coef(modelo_2pl, simplify = TRUE)$items
#          a      b
# Item1  1.23  -0.45
# Item2  1.78   0.12
# ...

# Graficar CCI
itemplot(modelo_2pl, item = 1, type = "trace")

# Función de información
plot(modelo_2pl, type = "info")

# Detectar ítems problemáticos
itemfit(modelo_2pl)
```

---

## 📋 CHECKLIST TRI PARA DISEÑO DE ÍTEMS

### Fase Diseño

- [ ] Dificultad objetivo definida según nivel ICFES
- [ ] Distractores basados en errores conceptuales documentados
- [ ] Enunciado claro y sin ambigüedades
- [ ] Opciones balanceadas en longitud y formato
- [ ] Clave verificada independientemente

### Fase Pilotaje

- [ ] Muestra ≥ tamaño mínimo para modelo elegido
- [ ] Distribución de habilidad aproximadamente normal
- [ ] Datos limpios (sin patrones de respuesta sospechosos)

### Fase Análisis

- [ ] Estimar parámetros (1PL, 2PL o 3PL)
- [ ] Verificar ajuste (INFIT/OUTFIT, chi-cuadrado)
- [ ] Revisar parámetros:
  - [ ] a ≥ 0.80 (discriminación aceptable)
  - [ ] |b| < 3.0 (dificultad en rango útil)
  - [ ] 0.15 ≤ c ≤ 0.30 (azar razonable, si aplica)
- [ ] Analizar CCI visualmente
- [ ] Revisar función de información

### Fase Decisión

- [ ] **SI a < 0.5**: Revisar/eliminar ítem
- [ ] **SI c > 0.35**: Buscar y eliminar pistas
- [ ] **SI ajuste malo**: Reescribir ítem
- [ ] **SI parámetros OK**: Aprobar para banco

---

## 🎓 INTEGRACIÓN CON ANÁLISIS PEDAGÓGICO

### Módulo TRI Adicional (Propuesto)

Agregar a los 5 módulos existentes:

**MÓDULO 6: Análisis Psicométrico TRI (Post-Pilotaje)**

**Input necesario**:
- Matriz de respuestas (estudiantes × ítem)
- Mínimo 200-500 estudiantes

**Análisis**:
1. Estimar parámetros (modelo 2PL recomendado)
2. Evaluar ajuste del ítem
3. Comparar parámetros con objetivos
4. Generar CCI
5. Calcular información del ítem

**Output**:
```markdown
## Módulo 6: Análisis Psicométrico TRI

### Parámetros Estimados (Modelo 2PL)
- Dificultad (b): 0.45 [Objetivo N2: -1.0 a 0.0] ⚠️
- Discriminación (a): 1.32 [Objetivo: 1.0-2.0] ✓
- Información máxima: I(θ=0.45) = 0.44

### Ajuste del Modelo
- INFIT: 0.98 [Rango 0.7-1.3] ✓
- OUTFIT: 1.05 [Rango 0.7-1.3] ✓
- Chi²: p = 0.23 [p > 0.05] ✓

### Evaluación
- ✓ Discriminación excelente (a = 1.32)
- ⚠️ Dificultad más alta que objetivo (b = 0.45 vs [-1.0, 0.0])
- ✓ Ajuste del modelo aceptable

### Recomendaciones
1. Considerar facilitar ligeramente (objetivo b ≈ -0.3)
2. Mantener estructura de distractores (buena discriminación)
3. Aprobar para banco con nota sobre dificultad
```

---

## 📚 Referencias Bibliográficas

1. **Fundamentos TRI**
   - Lord, F. M., & Novick, M. R. (1968). *Statistical Theories of Mental Test Scores*. Addison-Wesley.
   - Hambleton, R. K., Swaminathan, H., & Rogers, H. J. (1991). *Fundamentals of Item Response Theory*. SAGE.

2. **Modelos Avanzados**
   - Embretson, S. E., & Reise, S. P. (2000). *Item Response Theory for Psychologists*. Psychology Press.
   - Baker, F. B., & Kim, S. H. (2004). *Item Response Theory: Parameter Estimation Techniques* (2nd ed.). CRC Press.

3. **Aplicaciones Educativas**
   - De Ayala, R. J. (2009). *The Theory and Practice of Item Response Theory*. Guilford Press.
   - Ostini, R., & Nering, M. L. (2006). *Polytomous Item Response Theory Models*. SAGE.

4. **Software**
   - Chalmers, R. P. (2012). mirt: A multidimensional item response theory package for the R environment. *Journal of Statistical Software*, 48(6), 1-29.
   - Rizopoulos, D. (2006). ltm: An R package for latent variable modeling and item response theory analyses. *Journal of Statistical Software*, 17(5), 1-25.

5. **ICFES**
   - ICFES. (2013). *Sistema Nacional de Evaluación Estandarizada de la Educación: Alineación del examen Saber 11°*. Bogotá: ICFES.

---

## ⚠️ LIMITACIONES Y CONSIDERACIONES

### Cuándo NO usar TRI

1. **Muestra pequeña** (n < 200): TCT es más robusta
2. **Ítems dicotómicos no son apropiados**: Usar modelos politómicos
3. **Multidimensionalidad**: Usar MIRT (TRI multidimensional)
4. **Falta de independencia local**: Testlets, dependencia local

### Supuestos a Verificar

- [ ] **Unidimensionalidad**: Análisis factorial confirma 1 dimensión dominante
- [ ] **Independencia local**: Residuos no correlacionados
- [ ] **Monotonicidad**: P(θ) aumenta con θ
- [ ] **Invarianza**: Parámetros estables en subgrupos

---

**Versión**: 1.0.0
**Fecha**: 2026-02-04
**Actualización**: Incluye modelos 1PL-4PL estándar
**Uso**: Base de conocimiento para AgentePedagogoICFES (Módulo 6 opcional)
**Nota**: TRI requiere datos de pilotaje. Módulo 6 se activa solo si hay datos disponibles.
