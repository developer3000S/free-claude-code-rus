# Regla: Flujo B (Graficador Experto) OBLIGATORIO

## Principio Fundamental

**SIEMPRE que se detecten graficos en un ejercicio ICFES, el Flujo B (Graficador Experto) es OBLIGATORIO.**

Esta regla NO tiene excepciones. No importa si el grafico parece "simple" o "facil de describir".

## Deteccion Automatica de Graficos

### Criterios de Deteccion (SI cualquiera aplica = Flujo B OBLIGATORIO)

1. **En el enunciado**:
   - Imagen contiene grafico de barras, lineas, dispersion, circular, etc.
   - Imagen contiene diagrama geometrico (triangulos, circulos, cuadrilateros)
   - Imagen contiene plano cartesiano con funciones
   - Imagen contiene tabla con datos que requieren visualizacion
   - Imagen contiene cualquier elemento visual matematico

2. **En las opciones de respuesta**:
   - Opciones incluyen graficos diferentes
   - Opciones muestran variaciones de un mismo grafico
   - Opciones contienen diagramas o figuras

3. **En la solucion**:
   - Solucion requiere generar o interpretar grafico
   - Explicacion usa representacion visual

### Palabras Clave que Activan Flujo B

Si el ejercicio contiene alguna de estas palabras/frases:
- "Segun la grafica..."
- "Observa el diagrama..."
- "En la figura..."
- "La tabla muestra..."
- "Representa graficamente..."
- "El plano cartesiano..."
- "La distribucion de datos..."
- "El histograma/grafico de barras/lineas/dispersion..."

## Bloqueo de Generacion sin Flujo B

### PROHIBIDO: Generar .Rmd con graficos sin Flujo B

```
SI ejercicio_tiene_graficos AND NOT flujo_b_completado:
    BLOQUEAR generacion de .Rmd
    MOSTRAR mensaje de error
    REDIRIGIR a Flujo B
```

### Mensaje de Bloqueo

```markdown
## BLOQUEO: Flujo B Obligatorio

Se han detectado graficos en este ejercicio pero el Flujo B (Graficador Experto)
no ha sido ejecutado.

**Graficos detectados**:
- [lista de graficos identificados]

**Accion requerida**:
1. Ejecutar analisis de imagen con skill `analizar-imagen-grafica`
2. Generar las tres versiones (TikZ, Python, R) SECUENCIALMENTE
3. Iterar cada version hasta >=95% similitud
4. Obtener aprobacion del usuario para cada version
5. Solo entonces proceder con generacion del .Rmd

**NO SE PUEDE CONTINUAR SIN COMPLETAR FLUJO B**
```

## Verificacion de Flujo B Completado

### Archivo de Estado Requerido

Antes de generar cualquier .Rmd con graficos, verificar existencia de:

```
outputs/[nombre_ejercicio]/
├── workflow_state.json          # OBLIGATORIO
├── output_tikz_vN.tex           # OBLIGATORIO (N = version final)
├── output_python_vN.py          # OBLIGATORIO
├── output_r_vN.R                # OBLIGATORIO
├── tikz_output_vN.png           # OBLIGATORIO
├── python_output_vN.png         # OBLIGATORIO
└── r_output_vN.png              # OBLIGATORIO
```

### Contenido de workflow_state.json

```json
{
  "flujo_b_completado": true,
  "tikz": {
    "estado": "validado",
    "similitud_final": 95,
    "usuario_aprobo": true,
    "iteraciones": 4
  },
  "python": {
    "estado": "validado",
    "similitud_final": 96,
    "usuario_aprobo": true,
    "iteraciones": 3
  },
  "r": {
    "estado": "validado",
    "similitud_final": 95,
    "usuario_aprobo": true,
    "iteraciones": 3
  },
  "version_seleccionada": "tikz"
}
```

## Responsabilidad de Cada Comando

### /analizar-icfes

- DEBE detectar graficos y reportar decision de Flujo
- DEBE registrar `requiere_flujo_b: true/false` en analisis
- NO puede terminar sin declarar explicitamente la decision

### /generar-schoice y /generar-cloze

- DEBEN verificar si `requiere_flujo_b == true`
- SI es true: VERIFICAR que `flujo_b_completado == true`
- SI flujo_b_completado == false: BLOQUEAR y mostrar mensaje
- SOLO proceder si flujo_b_completado == true O requiere_flujo_b == false

### /auto-refinar-grafico

- Es el comando que ejecuta el Flujo B
- DEBE seguir proceso SECUENCIAL (ver regla graficador-secuencial.md)
- DEBE obtener aprobacion del usuario para CADA lenguaje

## Coherencias a Verificar Durante Flujo B

Ademas de similitud visual >= 95%, verificar:

1. **Coherencia Semantica (Gramatica)**
   - Etiquetas sin errores ortograficos
   - Texto claro y correcto

2. **Coherencia Visual con Texto**
   - Grafico coincide con descripcion del enunciado
   - Valores en grafico coinciden con valores mencionados
   - Ejes y leyendas coherentes con el problema

3. **Coherencia Matematica**
   - Ecuaciones/formulas correctas
   - Escalas apropiadas
   - Proporciones correctas

4. **Coherencia de Codigo**
   - Codigo genera exactamente lo esperado
   - Sin hardcoding de valores (aleatorizable)
   - Compatible con R-exams (dinamico)

5. **Coherencia General**
   - Grafico apropiado para el nivel de dificultad
   - Estilo visual consistente con ICFES
   - Legible y claro para estudiantes

## Excepciones (NINGUNA)

No hay excepciones a esta regla. Si hay graficos, hay Flujo B.

---

**Fecha de creacion**: 2025-12-30
**Version**: 1.0
**Autor**: Sistema automatizado
**Razon**: Garantizar calidad visual y coherencia en ejercicios ICFES
