# Operaciones sobre el Estado

## 1. Inicializar Estado

**Cuando**: Al ejecutar `/analizar-imagen` por primera vez

```json
{
  "version": "1.0",
  "timestamp_inicio": "[timestamp actual]",
  "fase_actual": "analisis",
  "analisis_completado": false,
  "tikz": {"estado": "pendiente", "iteracion_actual": 0, "similitud_actual": 0, "similitud_historico": []},
  "python": {"estado": "pendiente", "iteracion_actual": 0, "similitud_actual": 0, "similitud_historico": []},
  "r": {"estado": "pendiente", "iteracion_actual": 0, "similitud_actual": 0, "similitud_historico": []}
}
```

## 2. Marcar Analisis Completado

**Cuando**: Despues de completar analisis inicial

```
analisis_completado = true
timestamp_ultima_actualizacion = [timestamp actual]
```

## 3. Iniciar Fase de Lenguaje

**Cuando**: Al ejecutar `/generar-tikz`, `/generar-python` o `/generar-r`

```
[lenguaje].estado = "en_iteracion"
[lenguaje].iteracion_actual = 1
[lenguaje].timestamp_inicio = [timestamp actual]
fase_actual = "[lenguaje]_iteracion"
```

## 4. Registrar Iteracion

**Cuando**: Al ejecutar `/iterar` o despues de cada refinamiento

```
[lenguaje].iteracion_actual += 1
timestamp_ultima_actualizacion = [timestamp actual]
```

## 5. Registrar Similitud

**Cuando**: Despues de ejecutar `/comparar`

```
[lenguaje].similitud_actual = [valor]
[lenguaje].similitud_historico.push([valor])
timestamp_ultima_actualizacion = [timestamp actual]
```

## 6. Validar Lenguaje

**Cuando**: Usuario aprueba (similitud >= 95% o manual)

```
[lenguaje].estado = "validado"
[lenguaje].timestamp_validacion = [timestamp actual]
fase_actual = "[lenguaje]_validado"

# Si R esta validado:
fase_actual = "completado"
```

## 7. Consultar Estado

**Formato de salida**:

```markdown
## Estado del Workflow

### Progreso General
[indicador] TikZ: [ESTADO] ([N] iteraciones, [X]% similitud)
[indicador] Python: [ESTADO] ([N] iteraciones, [X]% similitud)
[indicador] R: [ESTADO] ([N] iteraciones, [X]% similitud)

### Fase Actual
[descripcion de fase actual]

### Tiempo Transcurrido
- Inicio: [timestamp]
- Duracion: [tiempo]

### Proximos Pasos Sugeridos
1. [paso sugerido]
2. [paso sugerido]
```

## Reglas de Transicion

| De | A | Condicion |
|----|---|-----------|
| analisis | tikz_iteracion | analisis_completado = true |
| tikz_iteracion | tikz_validado | similitud >= 95 o aprobacion manual |
| tikz_validado | python_iteracion | inicio de Python |
| python_iteracion | python_validado | similitud >= 95 o aprobacion manual |
| python_validado | r_iteracion | inicio de R |
| r_iteracion | r_validado | similitud >= 95 o aprobacion manual |
| r_validado | completado | automatico |

## Manejo de Errores

### Estado no encontrado

1. Inicializar estado desde cero
2. Continuar con proceso normal

### Estado corrupto

1. Intentar recuperar datos criticos
2. Reinicializar con datos parciales si posible
3. Informar al usuario

### Recuperacion ante interrupciones

1. Leer estado persistente
2. Identificar ultima fase completada
3. Sugerir continuar desde donde quedo
4. Validar que archivos necesarios existan
