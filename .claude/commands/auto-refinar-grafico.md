---
description: Itera automaticamente un lenguaje hasta alcanzar un umbral de similitud o maximo de iteraciones. (project)
---

# Auto-Refinar Grafico

**REGLA CRITICA**: Ver @.claude/rules/graficador-secuencial.md

**PROCESO SECUENCIAL OBLIGATORIO** - Los lenguajes se procesan UNO A LA VEZ, no simultaneamente.

## ⚠️ ORDEN SECUENCIAL OBLIGATORIO

```
1. TikZ (dinamico desde R) → >=95% + coherencias + aprobacion usuario
2. Python (reticulate) → >=95% + coherencias + aprobacion usuario
3. R (ggplot2 nativo) → >=95% + coherencias + aprobacion usuario
4. Usuario selecciona version final
```

**PROHIBIDO**: Generar o iterar multiples lenguajes simultaneamente.

Ejecuta iteraciones automaticas de refinamiento hasta alcanzar un umbral de similitud especificado o un maximo de iteraciones. Cuando se alcanza el umbral, **SIEMPRE** se debe:
1. Verificar las 5 coherencias (semantica, visual-texto, matematica, codigo, general)
2. Preguntar al usuario si esta satisfecho
3. SOLO continuar al siguiente lenguaje cuando usuario apruebe

## Uso

```
/auto-refinar-grafico [lenguaje] [umbral] [max_iteraciones]
```

**Parámetros**:

- `lenguaje`: tikz|python|r (requerido)
- `umbral`: Puntuación mínima para validar (default: 95)
- `max_iteraciones`: Máximo de iteraciones permitidas (default: 10)

**Ejemplos**:

```
/auto-refinar-grafico tikz 95 10
/auto-refinar-grafico python 90 5
/auto-refinar-grafico r 95 8
```

## Proceso

1. **Validar Parámetros**:
   - Verificar que el lenguaje sea válido (tikz, python, r)
   - Establecer umbral (default: 95)
   - Establecer max_iteraciones (default: 10)
   - Leer estado actual del workflow

2. **Validar Estado**:
   - Verificar que el lenguaje especificado esté en estado "en_iteracion" o "pendiente"
   - Si está pendiente, iniciar generación primero con `/generar-codigo-[lenguaje]`
   - Si está validado, informar que ya está completado

3. **Ciclo Automático de Iteración**:

```
INICIO:
  - Generar/refinar código con /generar-codigo-[lenguaje] o /refinar-codigo-grafico [lenguaje]
  - Comparar con /comparar-similitud-visual [lenguaje]
  - Leer similitud_actual del workflow_state.json

  SI similitud_actual >= umbral:
    - **PREGUNTAR AL USUARIO** si está satisfecho con los resultados
    - Mostrar imagen generada y similitud alcanzada
    - Esperar confirmación del usuario
    - SI usuario confirma: Validar lenguaje
    - SI usuario NO confirma: Continuar iterando o aplicar correcciones solicitadas

  SI iteracion_actual >= max_iteraciones:
    - FIN: Límite alcanzado - Máximo de iteraciones
    - Preguntar al usuario si desea validar con similitud actual o continuar manualmente

  SI NO:
    - Continuar iteración automáticamente (NO preguntar entre iteraciones)
    - Volver a INICIO
```

4. **Actualizar Estado en Cada Iteración**:
   - El comando `/refinar-codigo-grafico` actualiza automáticamente el estado
   - El comando `/comparar-similitud-visual` actualiza similitud_actual e historial
   - Verificar progreso después de cada iteración

5. **Reporte Final**:

```markdown
## Auto-Iteración Completada - [Lenguaje]

### Resultado

✅ **Éxito**: Similitud de [X]% alcanzada en [N] iteraciones
⚠️ **Límite alcanzado**: Máximo de [max_iteraciones] iteraciones alcanzado
❌ **Error**: [descripción del error]

### Estadísticas

- **Iteraciones ejecutadas**: [N]
- **Similitud inicial**: [X]%
- **Similitud final**: [Y]%
- **Mejora total**: [+Z] puntos
- **Mejora promedio por iteración**: [+W] puntos
- **Tiempo total**: [duración]

### Historial de Similitud

[Mostrar progreso: valor1 → valor2 → ... → valor_final]

### Próximos Pasos

- Si éxito: Continuar con siguiente lenguaje o ejecutar `/exportar-graficos`
- Si límite alcanzado: Revisar diferencias y considerar refinamiento manual
- Si error: Revisar logs y corregir problema
```

## Control de Cancelación

El usuario puede cancelar el proceso usando Ctrl+C si es necesario.
El sistema continuará automáticamente hasta alcanzar el umbral o máximo de iteraciones.

**Estado después de cancelación**:
- Mantener estado actual del workflow
- No revertir cambios ya aplicados
- Permitir continuar con `/auto-refinar-grafico` desde donde quedó

## Confirmacion Obligatoria al Alcanzar Umbral

**IMPORTANTE**: Cuando se alcanza el umbral de similitud (default 95%), **SIEMPRE** se debe:

### 1. Verificar las 5 Coherencias (OBLIGATORIO)

Antes de mostrar al usuario, verificar:

```markdown
## Verificacion de Coherencias - [Lenguaje] v[N]

### 1. Coherencia Semantica (Gramatica)
- [ ] Etiquetas de ejes sin errores ortograficos
- [ ] Leyendas correctamente escritas
- [ ] Titulo (si existe) gramaticalmente correcto
- [ ] Numeros con formato apropiado

### 2. Coherencia Visual con Texto
- [ ] Grafico coincide con descripcion del enunciado
- [ ] Valores visuales coinciden con valores mencionados
- [ ] Colores/estilos coherentes con la descripcion

### 3. Coherencia Matematica
- [ ] Formulas/ecuaciones correctas si aplica
- [ ] Proporciones geometricas correctas
- [ ] Relaciones matematicas preservadas

### 4. Coherencia de Codigo
- [ ] Codigo genera grafico dinamicamente (no hardcoded)
- [ ] Variables se interpolan correctamente
- [ ] Compatible con R-exams

### 5. Coherencia General
- [ ] Grafico legible (tamano de fuente adecuado)
- [ ] Estilo visual apropiado para ICFES
- [ ] Calidad de imagen suficiente
```

### 2. Mostrar resultado al usuario:
- Mostrar imagen generada
- Mostrar puntuacion de similitud alcanzada
- Mostrar resultado de verificacion de coherencias
- Mostrar comparacion lado a lado si es posible

### 3. Preguntar explicitamente:
```
Se ha alcanzado [X]% de similitud para [Lenguaje].

Verificacion de Coherencias:
- Semantica: OK/Pendiente
- Visual-Texto: OK/Pendiente
- Matematica: OK/Pendiente
- Codigo: OK/Pendiente
- General: OK/Pendiente

¿Esta satisfecho con el resultado?
- Si, aprobar y continuar con siguiente lenguaje
- No, necesito ajustes especificos: [describir]
- Continuar iterando automaticamente
```

### 4. Esperar respuesta del usuario:
- NO validar automaticamente
- NO continuar con siguiente lenguaje sin confirmacion
- Aplicar correcciones si el usuario las solicita

### 5. Validar solo con confirmacion:
- `[lenguaje].estado` = "validado" **solo despues de confirmacion**
- `[lenguaje].coherencias_verificadas` = true
- `[lenguaje].usuario_aprobo` = true
- `[lenguaje].timestamp_validacion` = timestamp actual
- Actualizar `timestamp_ultima_actualizacion`

### 6. Continuar al siguiente lenguaje (SECUENCIAL):
- Solo despues de aprobacion del lenguaje actual
- tikz.aprobado → iniciar python
- python.aprobado → iniciar r
- r.aprobado → preguntar seleccion final

## Límites y Protecciones

### Límite de Iteraciones

- **Default**: 10 iteraciones máximo
- **Razón**: Evitar bucles infinitos y consumo excesivo de recursos
- **Comportamiento**: Detener automáticamente al alcanzar límite y preguntar al usuario

### Detección de Convergencia

Si la mejora entre iteraciones es < 2 puntos durante 3 iteraciones consecutivas:

- Registrar advertencia de convergencia en el reporte
- Continuar hasta alcanzar umbral o máximo de iteraciones
- NO preguntar al usuario entre iteraciones (solo al alcanzar umbral)

### Detección de Regresión

Si la similitud disminuye entre iteraciones:

- Intentar una corrección diferente (variar estrategia de refinamiento)
- Si persiste por 2 iteraciones consecutivas, detener y reportar
- Preguntar al usuario cómo proceder

## Integración con Otros Comandos

Este comando utiliza internamente:

- `/generar-codigo-[lenguaje]`: Para primera generación (código compatible con r-exams)
- `/refinar-codigo-grafico [lenguaje]`: Para refinamientos subsecuentes
- `/comparar-similitud-visual [lenguaje]`: Para evaluación después de cada iteración
- Skill `gestionar-estado-graficador`: Para actualizar estado del workflow

## Ejemplos de Uso

### Ejemplo 1: Auto-iterar TikZ hasta 95% con confirmación

```
Usuario: /auto-refinar-grafico tikz 95 10

Sistema: Iniciando auto-iteración para TikZ...
         Iteración 1: Generando código compatible con r-exams...
         Comparando... Similitud: 75%
         Iteración 2: Refinando...
         Comparando... Similitud: 82%
         Iteración 3: Refinando...
         Comparando... Similitud: 89%
         Iteración 4: Refinando...
         Comparando... Similitud: 96%

         ✅ Se ha alcanzado 96% de similitud para TikZ.

         [Muestra imagen generada]

         ¿Está satisfecho con el resultado?

Usuario: Sí, validar

Sistema: TikZ validado. Continuando con Python...
```

### Ejemplo 2: Usuario solicita ajustes

```
Sistema: ✅ Se ha alcanzado 95% de similitud para Python.

         [Muestra imagen generada]

         ¿Está satisfecho con el resultado?

Usuario: No, la leyenda debería estar dentro del gráfico

Sistema: Entendido. Aplicando corrección: mover leyenda dentro del gráfico...
         Iteración 5: Refinando...
         Comparando... Similitud: 94%
         Iteración 6: Refinando...
         Comparando... Similitud: 96%

         ✅ Se ha alcanzado 96% de similitud para Python.

         [Muestra imagen con leyenda dentro]

         ¿Está satisfecho con el resultado?
```

### Ejemplo 3: Límite de iteraciones alcanzado

```
Usuario: /auto-refinar-grafico r 95 3

Sistema: Iniciando auto-iteración para R...
         Iteración 1: Similitud: 78%
         Iteración 2: Similitud: 85%
         Iteración 3: Similitud: 88%

         ⚠️ Límite alcanzado: Máximo de 3 iteraciones alcanzado
         Similitud final: 88% (objetivo: 95%)

         ¿Desea validar con 88% o continuar manualmente?
```

## Referencias

- `skills/gestionar-estado-graficador/skill.md` - Skill de gestión de estado del workflow
- `.claude/schemas/workflow_state.schema.json` - Esquema del estado del workflow
- `.claude/commands/refinar-codigo-grafico.md` - Comando de iteración manual
- `.claude/commands/comparar-similitud-visual.md` - Comando de comparación visual

