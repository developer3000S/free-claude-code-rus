# Patron Completo de Retroalimentacion ICFES

## Estructura de Solution (5 secciones obligatorias)

### 1. Encabezado Diagnostico

```markdown
Solution
========

### Informacion de la Pregunta

| Aspecto | Descripcion |
|---------|-------------|
| **Competencia** | [Interpretacion y representacion / Formulacion y ejecucion / Argumentacion] |
| **Componente** | [Numerico-variacional / Geometrico-metrico / Aleatorio] |
| **Afirmacion** | [Descripcion de lo que evalua segun estandar MEN] |
| **Evidencia** | [Lo que el estudiante demuestra al responder correctamente] |
| **Tarea** | [Accion especifica que el estudiante debe realizar] |
| **Nivel de dificultad** | [N1/N2/N3/N4] |
```

### 2. ¿Que Evalua Esta Pregunta?

```markdown
### ¿Que evalua esta pregunta?

Esta pregunta evalua la capacidad del estudiante para [DESCRIPCION ESPECIFICA
de la habilidad o conocimiento matematico evaluado, en 2-3 oraciones].
```

### 3. Justificacion de la Respuesta Correcta

```markdown
### Respuesta Correcta: [LETRA]

**Justificacion matematica:**

**Paso 1:** [Descripcion del primer paso]
$$[Formula LaTeX]$$

**Paso 2:** [Descripcion del segundo paso]
$$[Formula LaTeX]$$

[Continuar hasta el resultado final]

**Por lo tanto**, la respuesta correcta es **[LETRA]** porque [conclusion].
```

### 4. Analisis de Opciones No Validas (por cada opcion incorrecta)

```markdown
### Opciones No Validas

**Opcion [LETRA]:**
Es posible que los estudiantes que eligen la opcion [LETRA] [DESCRIPCION DEL
ERROR CONCEPTUAL ESPECIFICO]. Este error se presenta cuando [CAUSA RAIZ DEL
ERROR]. Para evitar este error, el estudiante debe [ESTRATEGIA CORRECTIVA].

**Opcion [LETRA]:**
Es posible que los estudiantes que eligen la opcion [LETRA] [DESCRIPCION DEL
ERROR CONCEPTUAL ESPECIFICO]. Este error se presenta cuando [CAUSA RAIZ DEL
ERROR]. Para evitar este error, el estudiante debe [ESTRATEGIA CORRECTIVA].

[Repetir para CADA opcion incorrecta]
```

### 5. Reflexion Metacognitiva

```markdown
### Reflexion Metacognitiva

`r sample(reflexiones_metacognitivas, 1)`

**Estrategias para evitar errores comunes:**
1. [Estrategia especifica 1]
2. [Estrategia especifica 2]
3. [Verificacion final recomendada]
```

---

## Patrones de Error por Componente

### Componente Numerico-Variacional

| Codigo Error | Descripcion | Patron "Es posible que..." |
|--------------|-------------|---------------------------|
| ALG-OPE-01 | Inversion de operacion | "...inviertan el orden de las operaciones o apliquen la operacion inversa incorrectamente" |
| ALG-SIG-01 | Error de signo | "...cometan errores al operar con signos negativos, especialmente en productos o cocientes" |
| ALG-DIS-01 | Distributiva incorrecta | "...no apliquen correctamente la propiedad distributiva al expandir expresiones" |
| ARI-FRA-01 | Suma de fracciones | "...sumen numeradores y denominadores directamente sin buscar denominador comun" |
| ARI-POR-01 | Porcentaje como cantidad | "...confundan el valor del porcentaje con la cantidad que representa" |

### Componente Geometrico-Metrico

| Codigo Error | Descripcion | Patron "Es posible que..." |
|--------------|-------------|---------------------------|
| GEO-ARE-01 | Confusion area/perimetro | "...confundan las formulas de area y perimetro o apliquen la formula incorrecta" |
| GEO-UNI-01 | Error de unidades | "...olviden convertir unidades o mezclen unidades incompatibles en el calculo" |
| GEO-ESC-01 | Error de escala | "...no apliquen correctamente el factor de escala en problemas de semejanza" |
| GEO-ANG-01 | Angulos complementarios/suplementarios | "...confundan angulos complementarios (90 grados) con suplementarios (180 grados)" |

### Componente Aleatorio

| Codigo Error | Descripcion | Patron "Es posible que..." |
|--------------|-------------|---------------------------|
| EST-MTC-01 | Confusion medidas centrales | "...confundan la media con la mediana o la moda, o calculen la medida incorrecta" |
| EST-PRO-01 | Probabilidad > 1 | "...obtengan probabilidades mayores que 1 al no normalizar correctamente" |
| EST-GRA-01 | Lectura incorrecta de grafico | "...lean incorrectamente la escala del eje vertical o confundan las categorias" |
| EST-FRE-01 | Frecuencia vs frecuencia relativa | "...confundan frecuencia absoluta con frecuencia relativa o porcentaje" |

---

## Ejemplo Completo: Estadistica (Graficos de Barras)

```markdown
Solution
========

### Informacion de la Pregunta

| Aspecto | Descripcion |
|---------|-------------|
| **Competencia** | Interpretacion y representacion |
| **Componente** | Aleatorio |
| **Afirmacion** | Interpretar informacion presentada en tablas y graficos |
| **Evidencia** | Representa un conjunto de datos mediante graficos de barras |
| **Nivel de dificultad** | N2 |

### ¿Que evalua esta pregunta?

Esta pregunta evalua la capacidad del estudiante para representar graficamente
informacion estadistica presentada en forma de porcentajes, convirtiendo estos
valores a cantidades absolutas y seleccionando la representacion visual correcta.

### Respuesta Correcta: A

**Justificacion matematica:**

**Paso 1:** Calcular cantidad para gatos (30%)
$$120 \times \frac{30}{100} = 120 \times 0.30 = 36 \text{ personas}$$

**Paso 2:** Calcular cantidad para perros (45%)
$$120 \times \frac{45}{100} = 120 \times 0.45 = 54 \text{ personas}$$

**Paso 3:** Calcular cantidad para hamsteres (25%)
$$120 \times \frac{25}{100} = 120 \times 0.25 = 30 \text{ personas}$$

**Por lo tanto**, la respuesta correcta es **A** porque representa correctamente
las barras con alturas 36, 54 y 30 para gatos, perros y hamsteres respectivamente.

### Opciones No Validas

**Opcion B:**
Es posible que los estudiantes que eligen la opcion B pongan en las barras de
cada mascota el valor correspondiente al porcentaje (30, 45, 25) sin convertir
el porcentaje a cantidad de personas. Este error se presenta cuando el estudiante
no comprende que el porcentaje es una proporcion que debe aplicarse al total.
Para evitar este error, el estudiante debe recordar que:
$$\text{Cantidad} = \text{Total} \times \frac{\text{Porcentaje}}{100}$$

**Opcion C:**
Es posible que los estudiantes que eligen la opcion C confundan la relacion
entre las categorias e intercambien los valores de gatos y perros. Este error
se presenta cuando el estudiante no verifica cuidadosamente la correspondencia
entre cada categoria y su valor. Para evitar este error, el estudiante debe
etiquetar claramente cada calculo con su categoria correspondiente.

**Opcion D:**
Es posible que los estudiantes que eligen la opcion D calculen incorrectamente
dividiendo el total por el porcentaje en lugar de multiplicar. Este error
produce valores como $120 \div 30 = 4$. Para evitar este error, el estudiante
debe recordar que "porcentaje de" significa multiplicacion, no division.

### Reflexion Metacognitiva

Identificar errores en representaciones graficas nos ayuda a comprender mejor
las relaciones entre porcentajes y cantidades absolutas. La metacognicion es
fundamental para detectar y corregir nuestros propios errores.

**Estrategias para evitar errores comunes:**
1. Siempre verificar que los porcentajes sumen 100%
2. Calcular cada cantidad usando la formula: Total x (Porcentaje/100)
3. Verificar que las cantidades calculadas sumen el total original
```

Ver tambien: [references/plantilla-solution.md](plantilla-solution.md) para plantilla reutilizable.
