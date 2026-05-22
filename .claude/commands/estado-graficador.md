---
description: Muestra el estado actual del workflow y el progreso de cada lenguaje.
---

# Estado del Graficador

Visualiza el estado actual del workflow de Graficador-Experto, mostrando progreso, tiempos y próximos pasos sugeridos.

## Proceso

1. **Leer Estado Persistente**:
   - Cargar `outputs/workflow_state.json`
   - Si no existe, informar que el workflow no ha sido iniciado

2. **Calcular Métricas**:
   - Tiempo transcurrido desde `timestamp_inicio`
   - Progreso por lenguaje según estado
   - Próximos pasos sugeridos según `fase_actual`

3. **Generar Reporte Visual**:

```markdown
## 📊 ESTADO DEL WORKFLOW - Graficador Experto

### Progreso General

🟢 TikZ: VALIDADO (4 iteraciones, 96% similitud)
🟡 Python: EN ITERACIÓN (2 iteraciones, 88% similitud)
⚪ R: PENDIENTE

**Leyenda**:
- 🟢 Validado: Lenguaje completado y validado
- 🟡 En iteración: Lenguaje en proceso de refinamiento
- ⚪ Pendiente: Lenguaje aún no iniciado

### Fase Actual

**Python - Iteración 2**

### Tiempo Transcurrido

- **Inicio**: 2025-12-29 10:30:00
- **Última actualización**: 2025-12-29 11:45:00
- **Duración**: 1h 15min

### Historial de Similitud

**TikZ**: 75 → 82 → 89 → 96 ✅
**Python**: 78 → 88 (en progreso)
**R**: (pendiente)

### Próximos Pasos Sugeridos

1. Ejecutar `/comparar-similitud-visual python` para evaluar iteración actual
2. Si similitud < 95%: Ejecutar `/refinar-codigo-grafico python` para refinar
3. Si similitud ≥ 95%: Ejecutar `/generar-codigo-r` para continuar con R

### Archivos Generados

✅ `outputs/workflow_state.json`
✅ `outputs/analisis_inicial.json`
✅ `outputs/output_tikz.tex`
✅ `outputs/tikz_render.png`
✅ `outputs/output_python.py`
✅ `outputs/python_render.png`
⏳ `outputs/output_r.R` (pendiente)
⏳ `outputs/r_render.png` (pendiente)

### Estadísticas del Proyecto

- **Iteraciones totales**: 6 (TikZ: 4, Python: 2, R: 0)
- **Similitud promedio actual**: 92% (TikZ: 96%, Python: 88%)
- **Mejora promedio por iteración**: +7 puntos
- **Tiempo promedio por iteración**: 12 minutos
```

## Lógica de Próximos Pasos

### Si fase_actual es "analisis":
- Próximo paso: Ejecutar `/generar-codigo-tikz` para iniciar generación TikZ

### Si fase_actual es "tikz_iteracion":
- Próximo paso: Ejecutar `/comparar-similitud-visual tikz` para evaluar iteración actual
- Si similitud < 95%: Ejecutar `/refinar-codigo-grafico tikz`
- Si similitud ≥ 95%: Ejecutar `/generar-codigo-python`

### Si fase_actual es "tikz_validado":
- Próximo paso: Ejecutar `/generar-codigo-python` para continuar con Python

### Si fase_actual es "python_iteracion":
- Próximo paso: Ejecutar `/comparar-similitud-visual python` para evaluar iteración actual
- Si similitud < 95%: Ejecutar `/refinar-codigo-grafico python`
- Si similitud ≥ 95%: Ejecutar `/generar-codigo-r`

### Si fase_actual es "python_validado":
- Próximo paso: Ejecutar `/generar-codigo-r` para continuar con R

### Si fase_actual es "r_iteracion":
- Próximo paso: Ejecutar `/comparar-similitud-visual r` para evaluar iteración actual
- Si similitud < 95%: Ejecutar `/refinar-codigo-grafico r`
- Si similitud ≥ 95%: Ejecutar `/exportar-graficos`

### Si fase_actual es "r_validado" o "completado":
- Próximo paso: Ejecutar `/exportar-graficos` para generar reporte final

## Indicadores de Estado

### Por Lenguaje

- **🟢 Validado**: `estado === "validado"`
  - Muestra: "VALIDADO (N iteraciones, X% similitud)"
  
- **🟡 En iteración**: `estado === "en_iteracion"`
  - Muestra: "EN ITERACIÓN (N iteraciones, X% similitud)"
  
- **⚪ Pendiente**: `estado === "pendiente"`
  - Muestra: "PENDIENTE"

### Cálculo de Tiempo

- Calcular diferencia entre `timestamp_inicio` y `timestamp_ultima_actualizacion`
- Formatear en formato legible (ej: "1h 15min", "45min", "2h 30min")

### Historial de Similitud

- Mostrar array `similitud_historico` como progreso visual
- Formato: `[valor1] → [valor2] → [valor3] → [valor_final] ✅`
- Si está en iteración, mostrar sin ✅ al final

## Archivos a Verificar

Listar archivos generados según estado:

- **Siempre presentes** (si workflow iniciado):
  - `outputs/workflow_state.json`
  - `outputs/analisis_inicial.json`

- **Si TikZ iniciado**:
  - `outputs/output_tikz.tex`
  - `outputs/tikz_render.png` (si compilado)

- **Si Python iniciado**:
  - `outputs/output_python.py`
  - `outputs/python_render.png` (si ejecutado)

- **Si R iniciado**:
  - `outputs/output_r.R`
  - `outputs/r_render.png` (si ejecutado)

- **Si completado**:
  - `outputs/reporte_matematico.md`

## Referencias

- `skills/gestionar-estado-graficador/skill.md` - Skill de gestión de estado del workflow
- `.claude/schemas/workflow_state.schema.json` - Esquema del estado del workflow

