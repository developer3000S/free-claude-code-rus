# Formato de Reporte de Comparacion Visual

## Plantilla Estandar

```markdown
## Comparacion Visual - [TikZ/Python/R] - Iteracion [N]

### Puntuacion Cuantitativa

**Similitud Total: [X]/100 puntos**

| Categoria | Puntuacion | Criterio Aplicado |
|-----------|------------|-------------------|
| Colores | [X]/20 | [criterio] |
| Posiciones | [X]/20 | [criterio] |
| Valores | [X]/20 | [criterio] |
| Proporciones | [X]/15 | [criterio] |
| Estilos | [X]/15 | [criterio] |
| Elementos | [X]/10 | [criterio] |

### Recomendacion

[Validar / Considerar validar o iterar / Iterar / Iterar o regenerar]

[Justificacion basada en puntuacion]
```

## Seccion de Analisis Detallado

Para cada categoria:

```markdown
#### N. [Categoria]
**Estado**: Correcto / Parcial / Incorrecto

**Diferencias**:

- [ ] Diferencia 1: Original X -> Generado Y
- [x] Diferencia 2: Descripcion del problema

**Correcciones**:
```[lenguaje]
# Codigo de correccion
```

**Impacto**: Alto / Medio / Bajo
```

## Seccion de Priorizacion

```markdown
### Priorizacion de Correcciones

#### Alta Prioridad (Impacto visual significativo):

1. Correccion 1
2. Correccion 2

#### Media Prioridad (Mejoras importantes):

3. Correccion 3
4. Correccion 4

#### Baja Prioridad (Detalles menores):

5. Correccion 5
```

## Seccion de Historial

```markdown
### Historial de Similitud

**Progreso de Similitud**:

- Iteracion 1: 75 puntos
- Iteracion 2: 82 puntos
- Iteracion 3: 89 puntos
- **Tendencia**: Mejora constante (+7 puntos por iteracion promedio)
```

## Seccion de Evaluacion Final

```markdown
### Evaluacion Final

**Puntuacion Actual**: X/100 puntos
**Puntuacion Esperada tras correcciones**: Y-Z puntos
**Recomendacion**: [decision]
**Justificacion**: [texto]

**Proximos Pasos Sugeridos**:

1. Si **Validar**: Continuar al siguiente lenguaje
2. Si **Iterar**: Aplicar correcciones y re-comparar
3. Si **Regenerar**: Regenerar desde cero
```
