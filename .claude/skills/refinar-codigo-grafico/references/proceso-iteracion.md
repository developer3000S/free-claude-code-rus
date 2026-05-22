# Proceso de Iteracion Sistematico

## Flujo de Refinamiento

```
1. Revisar reporte de comparacion
2. Identificar correcciones prioritarias
3. Planificar cambios al codigo
4. Aplicar modificaciones
5. Validar sintaxis
6. Re-renderizar
7. Comparar nuevamente
8. Repetir si necesario
```

## Paso 1: Analisis del Reporte

1. Leer reporte de comparacion completo
2. Identificar todas las correcciones listadas
3. Clasificar por prioridad (Alta, Media, Baja)
4. Verificar factibilidad de cada correccion
5. Identificar posibles conflictos

## Paso 2: Planificacion de Cambios

Orden recomendado:

1. Estructura y configuracion primero
2. Elementos principales despues
3. Detalles y estilos al final

## Paso 3: Aplicacion de Cambios

1. Mantener copia del codigo original
2. Aplicar correcciones una por una
3. Mantener indentacion y estilo
4. Anadir comentarios explicando cambios
5. Verificar sintaxis despues de cada cambio

## Paso 4: Documentacion

```markdown
## Iteracion [N] - [Lenguaje]

### Correcciones aplicadas

#### Alta Prioridad

1. **Descripcion**: valor anterior -> valor nuevo
   - Linea X: codigo modificado

### Estado despues de refinamiento

- Sintaxis: Valida
- Compilacion: Exitosa
- Elementos corregidos: X/Y
```

## Criterios de Detencion

**Detener y validar cuando**:

- Similitud visual > 95%
- Todas las correcciones de alta prioridad aplicadas
- Usuario indica satisfaccion
- Mejoras marginales (< 2% por iteracion)

**Continuar iterando cuando**:

- Similitud visual < 90%
- Quedan correcciones criticas pendientes
- Errores matematicos presentes
- Elementos importantes faltantes

## Limites Practicos

- Maximo recomendado: 10 iteraciones por lenguaje
- Si no converge en 10: reevaluar enfoque completo
- Considerar regeneracion si iteracion 5 no muestra progreso

## Patrones de Refinamiento Exitoso

### Patron Incremental

```
Iteracion 1: Valores numericos criticos
Iteracion 2: Posiciones y proporciones
Iteracion 3: Colores y estilos
```

### Patron por Capas

```
Iteracion 1: Estructura base y ejes
Iteracion 2: Elementos principales
Iteracion 3: Anotaciones y detalles
```

### Patron Focal

```
Iteracion 1: Identificar problema principal
Iteracion 2: Resolver completamente
Iteracion 3: Problemas secundarios
```
