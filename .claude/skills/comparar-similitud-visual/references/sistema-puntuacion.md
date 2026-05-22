# Sistema de Puntuacion Cuantitativa (0-100 puntos)

## Resumen de Categorias

| Categoria | Peso | Descripcion |
|-----------|------|-------------|
| Colores | 20 pts | Coincidencia de paleta RGB |
| Posiciones | 20 pts | Coordenadas exactas |
| Valores | 20 pts | Etiquetas, escalas, anotaciones |
| Proporciones | 15 pts | Aspect ratio y escalas |
| Estilos | 15 pts | Grosor, tipo linea, fuente |
| Elementos | 10 pts | Inventario completo |

## 1. Colores (0-20 puntos)

**Calculo**: Distancia RGB `sqrt((R1-R2)^2 + (G1-G2)^2 + (B1-B2)^2)`

| Puntuacion | Criterio |
|------------|----------|
| 20 | Diferencia RGB < 1% |
| 15 | Diferencia RGB 1-10% |
| 10 | 1-2 colores con diferencia > 10% |
| 5 | 3+ colores incorrectos o diferencias > 20% |
| 0 | Paleta completamente diferente |

## 2. Posiciones y Coordenadas (0-20 puntos)

**Calculo**: `|valor_generado - valor_original| / rango_total * 100`

| Puntuacion | Criterio |
|------------|----------|
| 20 | Diferencia < 1% del rango |
| 15 | Diferencia < 5% del rango |
| 10 | Diferencia 5-10% del rango |
| 5 | Diferencia 10-20% del rango |
| 0 | Diferencia > 20% del rango |

## 3. Valores Numericos (0-20 puntos)

**Calculo**: Conteo de valores incorrectos (etiquetas, escalas, anotaciones)

| Puntuacion | Criterio |
|------------|----------|
| 20 | Todos los valores correctos |
| 15 | 1-2 valores incorrectos (no criticos) |
| 10 | 3-4 valores incorrectos |
| 5 | 5+ valores incorrectos |
| 0 | Valores criticos incorrectos (ejes, puntos clave) |

## 4. Proporciones y Escalas (0-15 puntos)

**Calculo**: Comparar aspect ratio y escalas de ejes

| Puntuacion | Criterio |
|------------|----------|
| 15 | Proporciones perfectas |
| 10 | Diferencia < 5% en aspect ratio |
| 5 | Diferencia 5-15% o escalas diferentes |
| 0 | Diferencia > 15% o distorsion visible |

## 5. Estilos (0-15 puntos)

**Calculo**: Comparar grosor, tipo linea, fuente, marcadores

| Puntuacion | Criterio |
|------------|----------|
| 15 | Todos los estilos coinciden |
| 10 | Diferencias menores |
| 5 | 1-2 estilos diferentes |
| 0 | 3+ estilos incorrectos |

## 6. Elementos (0-10 puntos)

**Calculo**: Inventario de elementos presentes/faltantes/extra

| Puntuacion | Criterio |
|------------|----------|
| 10 | Todos presentes, ninguno extra |
| 7 | 1 elemento faltante o extra |
| 4 | 2-3 elementos faltantes o extra |
| 0 | 4+ elementos faltantes o extra |

## Recomendacion segun Puntuacion Total

| Rango | Recomendacion | Accion |
|-------|---------------|--------|
| 95-100 | Validar | Listo para produccion |
| 85-94 | Considerar validar/iterar | Mejoras menores posibles |
| 70-84 | Iterar | Necesita refinamiento |
| < 70 | Iterar o regenerar | Requiere correcciones mayores |

## Formato JSON de Metricas

```json
{
  "timestamp": "2025-12-29T11:45:00Z",
  "lenguaje": "tikz",
  "iteracion": 3,
  "puntuacion_total": 89,
  "categorias": {
    "colores": { "puntuacion": 18, "criterio_aplicado": "colores_similares" },
    "posiciones": { "puntuacion": 17, "criterio_aplicado": "diferencias_menores_5pct" },
    "valores": { "puntuacion": 20, "criterio_aplicado": "todos_correctos" },
    "proporciones": { "puntuacion": 12, "criterio_aplicado": "diferencias_menores" },
    "estilos": { "puntuacion": 13, "criterio_aplicado": "estilos_similares" },
    "elementos": { "puntuacion": 9, "criterio_aplicado": "1_faltante_extra" }
  },
  "recomendacion": "considerar_validar"
}
```
