# Colección de Ejercicios ICFES Analizados

Este documento contiene **ejemplos completos** de ejercicios matemáticos tipo ICFES con su **análisis detallado** según las 6 dimensiones oficiales.

Usa estos ejemplos como **referencia** cuando analices nuevos ejercicios con el skill `analizar-icfes`.

---

## 📋 Índice de Ejemplos

### Por Nivel de Dificultad
- [Ejercicio 1](#ejercicio-1-área-de-cuadrado-nivel-1): Nivel 1 - Área de Cuadrado
- [Ejercicio 2](#ejercicio-2-teorema-de-pitágoras-nivel-2): Nivel 2 - Teorema de Pitágoras
- [Ejercicio 3](#ejercicio-3-llenado-de-piscina-nivel-3): Nivel 3 - Llenado de Piscina
- [Ejercicio 8](#ejercicio-8-demostración-suma-ángulos-nivel-4): Nivel 4 - Demostración Suma Ángulos

### Por Competencia
- **Interpretación y Representación**: [Ejercicio 4](#ejercicio-4-interpretar-gráfico-de-barras), [Ejercicio 7](#ejercicio-7-interpretar-función-lineal)
- **Formulación y Ejecución**: [Ejercicio 1](#ejercicio-1-área-de-cuadrado-nivel-1), [Ejercicio 2](#ejercicio-2-teorema-de-pitágoras-nivel-2), [Ejercicio 3](#ejercicio-3-llenado-de-piscina-nivel-3), [Ejercicio 5](#ejercicio-5-ecuación-lineal)
- **Argumentación**: [Ejercicio 6](#ejercicio-6-validar-procedimiento), [Ejercicio 8](#ejercicio-8-demostración-suma-ángulos-nivel-4)

### Por Componente
- **Numérico-Variacional**: [Ejercicio 5](#ejercicio-5-ecuación-lineal), [Ejercicio 7](#ejercicio-7-interpretar-función-lineal)
- **Geométrico-Métrico**: [Ejercicio 1](#ejercicio-1-área-de-cuadrado-nivel-1), [Ejercicio 2](#ejercicio-2-teorema-de-pitágoras-nivel-2), [Ejercicio 3](#ejercicio-3-llenado-de-piscina-nivel-3), [Ejercicio 8](#ejercicio-8-demostración-suma-ángulos-nivel-4)
- **Aleatorio**: [Ejercicio 4](#ejercicio-4-interpretar-gráfico-de-barras), [Ejercicio 9](#ejercicio-9-probabilidad-dados)

---

## Ejercicio 1: Área de Cuadrado (Nivel 1)

### Enunciado

> Un cuadrado tiene lado de 5 cm. ¿Cuál es su área?
>
> **Opciones:**
> - A) 10 cm²
> - B) 20 cm²
> - C) 25 cm²
> - D) 30 cm²
> - E) 50 cm²

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 1 (Básico)
- **Justificación**: Aplicación directa de fórmula conocida A = lado²
- **Puntos estimados**: 30/100
- **Número de pasos**: 1 (A = 5² = 25)

#### Dimensión 2: Competencia
- **Competencia**: Formulación y Ejecución
- **Justificación**: Debe aplicar fórmula y calcular resultado
- **No es Interpretación**: No hay gráfico ni representación múltiple
- **No es Argumentación**: No pide justificar ni demostrar

#### Dimensión 3: Componente
- **Componente**: Geométrico-Métrico
- **Justificación**: Trata sobre figura geométrica (cuadrado) y medida (área)
- **Área específica**: Geometría plana + medición

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Espacial + Métrico
- **Predominante**: Métrico
- **Justificación**:
  - Espacial: Visualizar el cuadrado
  - Métrico: Calcular el área (medida)

#### Dimensión 5: Contenido Curricular
- **Área**: Geometría
- **Tipo**: Genérico
- **Tema específico**: Áreas de figuras planas (cuadrado)
- **Grado típico**: 6-7

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: No hay contexto narrativo, solo matemática abstracta

### Metadatos R/exams Generados

```yaml
exname: Area Cuadrado Basico
extype: schoice
exsolution: 00100
exshuffle: TRUE  # Nota: FALSE en SCHOICE con opciones gráficas PNG (ver graficos-como-opciones.md)
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Geométrico-Métrico
exextra[Afirmacion]: Calcula áreas de figuras planas básicas
exextra[Evidencia]: Aplica fórmula del área del cuadrado
exextra[Nivel]: 1
```

### Decisión de Flujo
- **Flujo seleccionado**: A (Estándar)
- **Razón**: No requiere gráficos complejos
- **Siguiente paso**: `/generar-schoice`

---

## Ejercicio 2: Teorema de Pitágoras (Nivel 2)

### Enunciado

> Un triángulo rectángulo tiene catetos de 3 cm y 4 cm. ¿Cuál es la longitud de la hipotenusa?
>
> **Opciones:**
> - A) 5 cm
> - B) 7 cm
> - C) 12 cm
> - D) 25 cm
> - E) 49 cm

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 2 (Intermedio)
- **Justificación**: Requiere identificar que es Pitágoras y aplicar fórmula (2-3 pasos)
- **Puntos estimados**: 40/100
- **Pasos**:
  1. Identificar que es triángulo rectángulo → usar Pitágoras
  2. Aplicar c² = a² + b² = 3² + 4² = 9 + 16 = 25
  3. Calcular c = √25 = 5

#### Dimensión 2: Competencia
- **Competencia**: Formulación y Ejecución
- **Justificación**: Plantea ecuación (Pitágoras) y resuelve

#### Dimensión 3: Componente
- **Componente**: Geométrico-Métrico
- **Justificación**: Teorema geométrico aplicado a medidas

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Espacial + Métrico + Numérico
- **Predominante**: Espacial
- **Justificación**:
  - Espacial: Visualizar triángulo rectángulo
  - Métrico: Medidas de lados
  - Numérico: Cálculo de raíz cuadrada

#### Dimensión 5: Contenido Curricular
- **Área**: Geometría
- **Tipo**: Genérico
- **Tema específico**: Teorema de Pitágoras
- **Grado típico**: 8-9

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: Enunciado abstracto sin contexto real

### Metadatos R/exams Generados

```yaml
exname: Teorema Pitagoras Basico
extype: schoice
exsolution: 10000
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Geométrico-Métrico
exextra[Afirmacion]: Aplica el teorema de Pitágoras en triángulos rectángulos
exextra[Evidencia]: Calcula la hipotenusa dado los catetos
exextra[Nivel]: 2
```

### Decisión de Flujo
- **Flujo seleccionado**: A (Estándar)
- **Razón**: No requiere gráfico complejo (se puede describir textualmente)
- **Siguiente paso**: `/generar-schoice`

---

## Ejercicio 3: Llenado de Piscina (Nivel 3)

### Enunciado

> Una piscina rectangular tiene dimensiones de 8 m de largo, 6 m de ancho y se desea llenar hasta 1.5 m de altura. Si una manguera vierte agua a razón de 2 litros por minuto, ¿cuántos días tardará en llenarse completamente?
>
> **Opciones:**
> - A) 15 días
> - B) 20 días
> - C) 25 días
> - D) 30 días
> - E) 35 días

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 3 (Avanzado)
- **Justificación**: Requiere modelado matemático y múltiples conversiones (6 pasos)
- **Puntos estimados**: 60/100
- **Pasos**:
  1. Calcular volumen: V = largo × ancho × altura = 8 × 6 × 1.5 = 72 m³
  2. Convertir m³ a litros: 72 m³ × 1000 L/m³ = 72,000 L
  3. Calcular tiempo en minutos: t = 72,000 L ÷ 2 L/min = 36,000 min
  4. Convertir minutos a horas: 36,000 min ÷ 60 = 600 horas
  5. Convertir horas a días: 600 horas ÷ 24 = 25 días
  6. Verificar resultado

#### Dimensión 2: Competencia
- **Competencia**: Formulación y Ejecución
- **Justificación**: Plantea modelo matemático (volumen, caudal, tiempo) y ejecuta cálculos

#### Dimensión 3: Componente
- **Componente**: Geométrico-Métrico
- **Justificación**: Volumen de figura geométrica + conversión de medidas

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Métrico + Variacional + Numérico
- **Predominante**: Métrico
- **Justificación**:
  - Métrico: Volumen, conversiones de unidades
  - Variacional: Relación caudal-tiempo
  - Numérico: Múltiples operaciones

#### Dimensión 5: Contenido Curricular
- **Área**: Geometría + Medición
- **Tipo**: Genérico
- **Tema específico**: Volumen de prismas rectangulares + conversión de unidades
- **Grado típico**: 8-9

#### Dimensión 6: Eje Axial
- **Eje**: Aplicado/Contextualizado
- **Contexto**: Situación real de llenado de piscina
- **Justificación**: Hay narrativa del mundo real que requiere modelado

### Metadatos R/exams Generados

```yaml
exname: Llenado Piscina Volumen Tiempo
extype: schoice
exsolution: 00100
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Geométrico-Métrico
exextra[Afirmacion]: Resuelve problemas de volumen y conversión de unidades en contextos reales
exextra[Evidencia]: Calcula volumen de prisma rectangular y relaciona con caudal y tiempo
exextra[Nivel]: 3
```

### Decisión de Flujo
- **Flujo seleccionado**: B (Con Graficador)
- **Razón**: Beneficiaría tener diagrama de piscina con dimensiones etiquetadas
- **Siguiente paso**: Activar Graficador Experto → Generar código TikZ para piscina 3D

---

## Ejercicio 4: Interpretar Gráfico de Barras

### Enunciado

> El siguiente gráfico muestra las ventas mensuales (en miles de pesos) de una tienda durante el primer semestre:
>
> [Gráfico de barras: Ene=50, Feb=60, Mar=55, Abr=70, May=65, Jun=80]
>
> ¿En qué mes hubo el mayor incremento porcentual respecto al mes anterior?
>
> **Opciones:**
> - A) Febrero
> - B) Marzo
> - C) Abril
> - D) Mayo
> - E) Junio

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 3 (Avanzado)
- **Justificación**: Requiere interpretar gráfico Y calcular incrementos porcentuales (4-5 pasos)
- **Puntos estimados**: 55/100
- **Pasos**:
  1. Leer valores del gráfico
  2. Calcular diferencias: Feb-Ene=10, Mar-Feb=-5, Abr-Mar=15, May-Abr=-5, Jun-May=15
  3. Calcular incrementos porcentuales: Feb=(10/50)×100=20%, Abr=(15/55)×100=27%, Jun=(15/65)×100=23%
  4. Comparar porcentajes
  5. Identificar el mayor: Abril (27%)

#### Dimensión 2: Competencia
- **Competencia**: Interpretación y Representación
- **Justificación**: Debe leer e interpretar gráfico de barras

#### Dimensión 3: Componente
- **Componente**: Aleatorio
- **Justificación**: Análisis de datos estadísticos presentados en gráfico

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Aleatorio + Variacional + Numérico
- **Predominante**: Aleatorio
- **Justificación**:
  - Aleatorio: Interpretar datos estadísticos
  - Variacional: Analizar cambios (incrementos)
  - Numérico: Calcular porcentajes

#### Dimensión 5: Contenido Curricular
- **Área**: Estadística
- **Tipo**: Genérico (Estadística Descriptiva)
- **Tema específico**: Interpretación de gráficos de barras + incrementos porcentuales
- **Grado típico**: 7-8

#### Dimensión 6: Eje Axial
- **Eje**: Aplicado/Contextualizado
- **Contexto**: Ventas de tienda (economía/comercio)

### Metadatos R/exams Generados

```yaml
exname: Interpretar Grafico Barras Incremento Porcentual
extype: schoice
exsolution: 00100
exshuffle: FALSE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Interpretación y Representación
exextra[Componente]: Aleatorio
exextra[Afirmacion]: Interpreta gráficos estadísticos y analiza variaciones porcentuales
exextra[Evidencia]: Calcula incrementos porcentuales a partir de gráfico de barras
exextra[Nivel]: 3
```

### Decisión de Flujo
- **Flujo seleccionado**: B (Con Graficador)
- **Razón**: Requiere generar gráfico de barras con valores específicos
- **Siguiente paso**: Activar Graficador → Generar código R/ggplot2 para gráfico de barras

---

## Ejercicio 5: Ecuación Lineal

### Enunciado

> Resuelve la ecuación: 3x - 7 = 14
>
> **Opciones:**
> - A) x = 3
> - B) x = 5
> - C) x = 7
> - D) x = 21
> - E) x = 63

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 2 (Intermedio)
- **Justificación**: Requiere 2-3 pasos para despejar (no es aplicación directa)
- **Puntos estimados**: 38/100
- **Pasos**:
  1. Sumar 7 a ambos lados: 3x = 14 + 7 = 21
  2. Dividir por 3: x = 21 / 3 = 7

#### Dimensión 2: Competencia
- **Competencia**: Formulación y Ejecución
- **Justificación**: Ejecuta procedimiento algebraico (despeje)

#### Dimensión 3: Componente
- **Componente**: Numérico-Variacional
- **Justificación**: Álgebra (ecuación lineal)

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Variacional + Numérico
- **Predominante**: Variacional
- **Justificación**:
  - Variacional: Relación entre variable y constante
  - Numérico: Operaciones aritméticas

#### Dimensión 5: Contenido Curricular
- **Área**: Álgebra
- **Tipo**: Genérico
- **Tema específico**: Ecuaciones lineales de primer grado
- **Grado típico**: 7-8

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: Ecuación abstracta sin contexto

### Metadatos R/exams Generados

```yaml
exname: Ecuacion Lineal Basica
extype: schoice
exsolution: 00100
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Numérico-Variacional
exextra[Afirmacion]: Resuelve ecuaciones lineales de primer grado
exextra[Evidencia]: Despeja la incógnita mediante operaciones inversas
exextra[Nivel]: 2
```

### Decisión de Flujo
- **Flujo seleccionado**: A (Estándar)
- **Razón**: No requiere gráficos
- **Siguiente paso**: `/generar-schoice`

---

## Ejercicio 6: Validar Procedimiento

### Enunciado

> Juan resolvió la ecuación 2x + 5 = 13 de la siguiente manera:
>
> Paso 1: Restó 5 a ambos lados → 2x = 8
> Paso 2: Dividió por 2 → x = 4
>
> ¿Es correcto el procedimiento de Juan? Justifica tu respuesta.
>
> **Opciones:**
> - A) Sí, porque aplicó operaciones inversas correctamente
> - B) No, porque debió sumar 5 en lugar de restar
> - C) No, porque debió multiplicar por 2 en lugar de dividir
> - D) Sí, pero olvidó verificar la solución
> - E) No, porque el orden de operaciones es incorrecto

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 2 (Intermedio)
- **Justificación**: Requiere evaluar procedimiento y justificar (3 pasos)
- **Puntos estimados**: 45/100
- **Pasos**:
  1. Revisar paso 1 (resta 5): ¿Es correcto?
  2. Revisar paso 2 (divide por 2): ¿Es correcto?
  3. Justificar usando propiedades de la igualdad

#### Dimensión 2: Competencia
- **Competencia**: Argumentación
- **Justificación**: Debe validar procedimiento y justificar por qué es correcto

#### Dimensión 3: Componente
- **Componente**: Numérico-Variacional
- **Justificación**: Álgebra (ecuaciones lineales)

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Variacional + Numérico
- **Predominante**: Variacional
- **Justificación**: Razonamiento sobre ecuaciones y operaciones inversas

#### Dimensión 5: Contenido Curricular
- **Área**: Álgebra
- **Tipo**: Genérico
- **Tema específico**: Propiedades de la igualdad, operaciones inversas
- **Grado típico**: 7-8

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: Sin contexto aplicado

### Metadatos R/exams Generados

```yaml
exname: Validar Procedimiento Ecuacion Lineal
extype: schoice
exsolution: 10000
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Argumentación
exextra[Componente]: Numérico-Variacional
exextra[Afirmacion]: Valida procedimientos algebraicos usando propiedades matemáticas
exextra[Evidencia]: Justifica la corrección de un método de solución de ecuaciones
exextra[Nivel]: 2
```

### Decisión de Flujo
- **Flujo seleccionado**: A (Estándar)
- **Razón**: No requiere gráficos
- **Siguiente paso**: `/generar-schoice`

---

## Ejercicio 7: Interpretar Función Lineal

### Enunciado

> La función f(x) = 3x - 2 está representada en el plano cartesiano. ¿Cuál es el valor de la pendiente?
>
> [Gráfico: Línea recta que pasa por (0,-2) y (1,1)]
>
> **Opciones:**
> - A) -2
> - B) 0
> - C) 1
> - D) 2
> - E) 3

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 2 (Intermedio)
- **Justificación**: Requiere identificar pendiente de función lineal (2 pasos)
- **Puntos estimados**: 40/100
- **Pasos**:
  1. Identificar formato y = mx + b
  2. Reconocer que m = 3 es la pendiente

#### Dimensión 2: Competencia
- **Competencia**: Interpretación y Representación
- **Justificación**: Interpreta representación algebraica y gráfica de función

#### Dimensión 3: Componente
- **Componente**: Numérico-Variacional
- **Justificación**: Funciones lineales (álgebra)

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Variacional + Espacial
- **Predominante**: Variacional
- **Justificación**:
  - Variacional: Análisis de función y tasa de cambio (pendiente)
  - Espacial: Visualizar gráfico en plano cartesiano

#### Dimensión 5: Contenido Curricular
- **Área**: Álgebra
- **Tipo**: Genérico
- **Tema específico**: Función lineal, pendiente
- **Grado típico**: 8-9

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: Función abstracta sin contexto aplicado

### Metadatos R/exams Generados

```yaml
exname: Interpretar Funcion Lineal Pendiente
extype: schoice
exsolution: 00001
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Interpretación y Representación
exextra[Componente]: Numérico-Variacional
exextra[Afirmacion]: Interpreta funciones lineales y sus parámetros
exextra[Evidencia]: Identifica la pendiente de una función lineal
exextra[Nivel]: 2
```

### Decisión de Flujo
- **Flujo seleccionado**: B (Con Graficador)
- **Razón**: Requiere gráfico de función lineal en plano cartesiano
- **Siguiente paso**: Activar Graficador → Generar código R/ggplot2 o TikZ para función lineal

---

## Ejercicio 8: Demostración Suma Ángulos (Nivel 4)

### Enunciado

> Demuestra que la suma de los ángulos internos de cualquier polígono de n lados es (n-2) × 180°.

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 4 (Superior)
- **Justificación**: Requiere demostración formal, generalización, razonamiento abstracto (8+ pasos)
- **Puntos estimados**: 80/100
- **Pasos**:
  1. Entender el problema (generalización para n lados)
  2. Proponer estrategia (dividir polígono en triángulos)
  3. Identificar número de triángulos: n - 2
  4. Recordar suma ángulos triángulo: 180°
  5. Multiplicar: (n-2) × 180°
  6. Verificar con casos particulares (triángulo n=3, cuadrilátero n=4)
  7. Generalizar el argumento
  8. Escribir demostración formal

#### Dimensión 2: Competencia
- **Competencia**: Argumentación
- **Justificación**: Requiere demostrar proposición matemática

#### Dimensión 3: Componente
- **Componente**: Geométrico-Métrico
- **Justificación**: Propiedad geométrica de polígonos

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Espacial + Variacional
- **Predominante**: Espacial
- **Justificación**:
  - Espacial: Visualizar polígonos y triangulación
  - Variacional: Generalizar para cualquier n

#### Dimensión 5: Contenido Curricular
- **Área**: Geometría
- **Tipo**: No Genérico
- **Tema específico**: Propiedades de polígonos, demostración formal
- **Grado típico**: 10-11

#### Dimensión 6: Eje Axial
- **Eje**: Puramente Matemático
- **Justificación**: Demostración teórica sin aplicación

### Metadatos R/exams Generados

```yaml
exname: Demostracion Suma Angulos Poligono
extype: cloze
exsolution: num|string
exshuffle: FALSE
extol: 0.01

exextra[Type]: CLOZE
exextra[Competencia]: Argumentación
exextra[Componente]: Geométrico-Métrico
exextra[Afirmacion]: Demuestra proposiciones geométricas usando razonamiento deductivo
exextra[Evidencia]: Generaliza propiedades de polígonos mediante demostración formal
exextra[Nivel]: 4
```

### Decisión de Flujo
- **Flujo seleccionado**: B (Con Graficador)
- **Razón**: Beneficiaría tener diagramas de polígonos con triangulación
- **Siguiente paso**: Activar Graficador → Generar código TikZ para polígonos triangulados

---

## Ejercicio 9: Probabilidad Dados

### Enunciado

> Al lanzar dos dados, ¿cuál es la probabilidad de que la suma sea 7?
>
> **Opciones:**
> - A) 1/12
> - B) 1/9
> - C) 1/6
> - D) 1/4
> - E) 1/3

### Análisis ICFES Completo

#### Dimensión 1: Nivel de Dificultad
- **Nivel**: 2 (Intermedio)
- **Justificación**: Requiere enumerar casos favorables y espacio muestral (3-4 pasos)
- **Puntos estimados**: 45/100
- **Pasos**:
  1. Identificar espacio muestral: 6 × 6 = 36 resultados
  2. Enumerar casos favorables (suma=7): (1,6), (2,5), (3,4), (4,3), (5,2), (6,1) = 6 casos
  3. Calcular probabilidad: P = 6/36 = 1/6
  4. Simplificar fracción

#### Dimensión 2: Competencia
- **Competencia**: Formulación y Ejecución
- **Justificación**: Plantea espacio muestral y calcula probabilidad

#### Dimensión 3: Componente
- **Componente**: Aleatorio
- **Justificación**: Probabilidad de eventos

#### Dimensión 4: Tipo de Pensamiento
- **Pensamiento(s)**: Aleatorio + Numérico
- **Predominante**: Aleatorio
- **Justificación**:
  - Aleatorio: Razonamiento bajo incertidumbre
  - Numérico: Conteo, operaciones con fracciones

#### Dimensión 5: Contenido Curricular
- **Área**: Probabilidad
- **Tipo**: Genérico (Probabilidad Básica)
- **Tema específico**: Probabilidad clásica, eventos equiprobables
- **Grado típico**: 8-9

#### Dimensión 6: Eje Axial
- **Eje**: Aplicado/Contextualizado
- **Contexto**: Juego de dados (situación concreta)

### Metadatos R/exams Generados

```yaml
exname: Probabilidad Suma Dados
extype: schoice
exsolution: 00100
exshuffle: TRUE
extol: 0.01

exextra[Type]: SCHOICE
exextra[Competencia]: Formulación y Ejecución
exextra[Componente]: Aleatorio
exextra[Afirmacion]: Calcula probabilidades de eventos simples
exextra[Evidencia]: Aplica la regla de Laplace en experimentos aleatorios
exextra[Nivel]: 2
```

### Decisión de Flujo
- **Flujo seleccionado**: A (Estándar)
- **Razón**: No requiere gráficos complejos (se puede describir)
- **Siguiente paso**: `/generar-schoice`

---

## Resumen Estadístico de Ejemplos

### Por Nivel de Dificultad
| Nivel | Cantidad | Porcentaje |
|-------|----------|------------|
| 1 | 1 | 11% |
| 2 | 5 | 56% |
| 3 | 2 | 22% |
| 4 | 1 | 11% |

### Por Competencia
| Competencia | Cantidad | Porcentaje |
|-------------|----------|------------|
| Interpretación y Representación | 2 | 22% |
| Formulación y Ejecución | 5 | 56% |
| Argumentación | 2 | 22% |

### Por Componente
| Componente | Cantidad | Porcentaje |
|------------|----------|------------|
| Numérico-Variacional | 3 | 33% |
| Geométrico-Métrico | 4 | 45% |
| Aleatorio | 2 | 22% |

### Por Eje Axial
| Eje | Cantidad | Porcentaje |
|-----|----------|------------|
| Puramente Matemático | 5 | 56% |
| Aplicado/Contextualizado | 4 | 44% |

---

## Cómo Usar Este Documento

### 1. Como Referencia al Analizar

Cuando analices un nuevo ejercicio:
1. Identifica el nivel aproximado (cuántos pasos requiere)
2. Busca un ejemplo similar en esta colección
3. Compara tu análisis con el ejemplo
4. Ajusta según diferencias específicas

### 2. Como Plantilla

Usa la estructura de análisis de cualquier ejemplo como plantilla:
- Dimensión 1-6 con justificación
- Metadatos R/exams completos
- Decisión de flujo

### 3. Como Validación

Si tienes dudas sobre tu clasificación:
- Busca ejemplos similares (mismo tema, mismo nivel)
- Compara las justificaciones
- Verifica consistencia en las dimensiones

---

## Agregar Nuevos Ejemplos

Cuando analices un ejercicio exitosamente:

1. **Documentar análisis completo** (6 dimensiones + metadatos)
2. **Agregar a este archivo** en la categoría apropiada
3. **Actualizar resumen estadístico** al final
4. **Commit con mensaje descriptivo**

**Formato estándar:**
```markdown
## Ejercicio N: Título Descriptivo

### Enunciado
[Texto completo del ejercicio]

### Análisis ICFES Completo
[6 dimensiones con justificación detallada]

### Metadatos R/exams Generados
[YAML completo]

### Decisión de Flujo
[Flujo A/B + razón + siguiente paso]
```

---

**Última actualización**: 2025-12-30
**Versión**: 1.0
**Uso**: Referencia para `analizar-icfes` skill
**Total ejercicios**: 9
