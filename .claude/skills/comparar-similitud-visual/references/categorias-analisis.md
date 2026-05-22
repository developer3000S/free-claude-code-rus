# Categorias de Analisis Visual

## 1. Analisis de Colores

**Deteccion**:

- Identificar todos los colores presentes en ambas imagenes
- Comparar paletas de colores
- Detectar diferencias de tonalidad, saturacion y brillo
- Verificar transparencia y opacidad

**Correcciones**: Proporcionar codigos de color exactos (RGB, Hex)

## 2. Analisis de Posiciones y Coordenadas

**Deteccion**:

- Comparar posicion de todos los elementos
- Verificar alineacion y distribucion espacial
- Detectar desplazamientos o rotaciones
- Validar escalas y proporciones

**Correcciones**: Especificar coordenadas exactas, ajustes de transformacion

## 3. Analisis de Valores Numericos

**Deteccion**:

- Extraer todos los valores numericos visibles
- Comparar etiquetas, escalas y anotaciones
- Verificar rangos de ejes
- Validar valores en graficos (alturas de barras, puntos de datos)

**Correcciones**: Listar valores incorrectos con sus valores correctos

## 4. Analisis de Proporciones y Escalas

**Deteccion**:

- Comparar proporciones entre elementos
- Verificar aspect ratio (relacion de aspecto)
- Validar escalas de ejes
- Detectar distorsiones

**Correcciones**: Usar `aspect='equal'` o equivalente, ajustar rangos de ejes

## 5. Analisis de Estilos

**Deteccion**:

- Comparar grosores de lineas
- Verificar tipos de linea (solida, punteada, discontinua)
- Comparar tamanos de fuente
- Validar marcadores y simbolos

**Correcciones**: Especificar estilos exactos (linewidth, linestyle, etc.)

## 6. Analisis de Elementos

**Deteccion**:

- Inventariar todos los elementos presentes
- Identificar elementos faltantes
- Detectar elementos extra no presentes en original
- Verificar completitud

**Correcciones**: Listar elementos a anadir/eliminar

## Casos Especiales

### Funciones Matematicas

- Verificar puntos clave (interceptos, maximos, minimos)
- Validar continuidad y suavidad de curvas
- Comparar asintotas y comportamiento en extremos

### Geometria

- Validar angulos y medidas
- Verificar teoremas geometricos aplicables
- Comprobar simetrias y proporciones

### Estadistica

- Validar valores de datos
- Verificar calculos (promedios, medianas, etc.)
- Comparar distribuciones visuales
