# Principio de Documentación Verificada

## Solo documentamos lo que está 100% verificado y funcionando

Este principio fundamental asegura que:

- ✅ Todas las soluciones documentadas han sido probadas
- ✅ Cada patrón incluye código de ejemplo funcional
- ✅ Los resultados son reproducibles
- ✅ La documentación es confiable como referencia

## ❌ Qué NO documentamos

- Errores sin solución confirmada
- Soluciones parciales o incompletas
- "Posibles soluciones" o aproximaciones
- Teorías o hipótesis sin validación
- Código que no ha sido probado en archivos .Rmd reales

## ✅ Qué SÍ documentamos

- Errores identificados con solución verificada
- Código antes/después completamente funcional
- Pruebas de validación exitosas (PDF + HTML mínimo)
- Referencias a archivos .Rmd en producción funcionando
- Historial con resultados específicos de pruebas
- Patrón utilizado de ejemplos funcionales (SUBFASE 3C)

## Proceso para Documentar un Patrón

### 1. Identificar el error recurrente
- Error debe aparecer en múltiples archivos o sesiones
- Mensaje de error específico y reproducible

### 2. Desarrollar y probar la solución
- Aplicar en archivo .Rmd real
- NO usar archivos de prueba aislados

### 3. Validar completamente
```r
# Mínimo requerido:
exams2pdf("archivo.Rmd", n = 1)   # ✓ Debe pasar
exams2html("archivo.Rmd", n = 1)  # ✓ Debe pasar

# Recomendado adicional:
exams2pandoc("archivo.Rmd", n = 1, type = "docx")
exams2nops("archivo.Rmd", n = 1)
```

### 4. Documentar en patrones-errores-conocidos.md

Estructura OBLIGATORIA:
```markdown
## Error N: [Título descriptivo]

### ❌ Mensaje de Error
[Error exacto del log]

### 🔍 Causa Raíz
[Explicación técnica del problema]

### ✅ Solución Verificada
[Código COMPLETO antes/después]

### 🧪 Validación de la Solución
[Comandos ejecutados y resultados]

### 📋 Checklist de Corrección
[Pasos específicos para aplicar solución]

### 📚 Ejemplo Funcional Utilizado
[Referencia a archivo en /A-Produccion/Ejemplos-Funcionales-Rmd/]

### 📅 Historial
[Tabla con fecha, archivo, resultado]
```

### 5. Agregar resultados de validación

Tabla de resultados OBLIGATORIA:
```markdown
| Fecha | Archivo | PDF | HTML | DOCX | NOPS | Versiones únicas |
|-------|---------|-----|------|------|------|------------------|
| 2025-12-30 | ejercicio_1.Rmd | ✓ | ✓ | ✓ | ✓ | 287/300 |
```

## Actualización de Patrones Existentes

Si un patrón documentado necesita actualización:

1. ✅ Probar nueva solución completamente
2. ✅ Validar en múltiples archivos .Rmd
3. ✅ Actualizar sección de código
4. ✅ Agregar nueva entrada en historial con fecha
5. ✅ Incrementar versión (v1.0 → v1.1)
6. ✅ NO eliminar solución anterior (preservar historial)

## Obsolescencia de Patrones

Si un patrón ya no es relevante:

1. NO eliminar (preservar historial completo)
2. Agregar nota al inicio: `⚠️ OBSOLETO - Ver [nuevo_patron.md]`
3. Explicar por qué quedó obsoleto
4. Referenciar nuevo enfoque recomendado
5. Mantener código original para referencia histórica

---

**Criterio final**: Si no puedes reproducir la solución en un archivo .Rmd real con resultado exitoso en PDF y HTML, NO está listo para documentar.
