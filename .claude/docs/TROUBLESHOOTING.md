# Guía Rápida de Troubleshooting - R/exams

> **Índice rápido de errores conocidos y soluciones verificadas**

---

## 📋 Errores Comunes

### 1. ❌ File '*.png' not found

**Error completo:**
```
Package pdftex.def Error: File 'imagen.png' not found: using draft setting.
Error: LaTeX failed to compile archivo.tex
```

**Causa:** Uso de `include_tikz()` en chunk de generación

**Solución rápida:**

1. Mover `include_tikz()` fuera del chunk de generación
2. Usar renderizado condicional con `knitr::is_latex_output()`
3. Para LaTeX: `cat(tikz_code)` directamente
4. Para HTML: mantener `include_tikz()`

**Documentación completa:** `.claude/docs/patrones-errores-conocidos.md#error-1`

**Skill automático:**
```bash
/corregir-error-imagen
```

---

### 2. ⚠️ Diversidad insuficiente (< 250 versiones únicas)

**Error:**
```
Solo se generaron X versiones únicas. Se requieren al menos 250.
```

**Solución:**

- Aumentar rango de valores aleatorios
- Agregar más vocabulario aleatorio
- Verificar que no haya `set.seed()` fijos

**Validar con:**
```bash
/validar-diversidad
```

---

### 3. ⚠️ Metadatos ICFES incompletos

**Error:**
Falta información en el YAML header

**Solución:**
Verificar que el YAML incluya:
```yaml
icfes:
  competencia: [interpretacion_representacion|formulacion_ejecucion|argumentacion]
  nivel_dificultad: [1|2|3|4]
  componente: [geometrico_metrico|numerico_variacional|aleatorio]
  contenido:
    categoria: [geometria|algebra|estadistica]
    tipo: [generico|no_generico]
```

**Validar con:**
```bash
/validar-icfes
```

---

### 4. 🖼️ Errores de Gráficos (Ciclo de Validación Visual)

**Categorías de errores gráficos:**

| Código | Error | Síntoma | Solución |
|--------|-------|---------|----------|
| ERR_G1 | No visualizadas | Imagen ausente en PDF | `/corregir-graficos` |
| ERR_G2 | Solapadas | Elementos superpuestos | Ajustar márgenes/posición |
| ERR_G3 | Renderizado incorrecto | Distorsión visible | Revisar código TikZ/Python |
| ERR_G4 | Tamaño inadecuado | Muy grande/pequeño | Ajustar scale/width |

**Workflow de corrección:**
```

1. /validar-renderizado
2. Si hay errores gráficos → /diagnosticar-errores
3. Aplicar corrección según tipo → /corregir-graficos
4. Re-ejecutar /validar-renderizado
5. Repetir hasta éxito en 4 formatos
```

---

### 5. 🔗 Errores de Coherencia

| Código | Error | Ejemplo |
|--------|-------|---------|
| ERR_C1 | Coherencia matemática | Fórmula incorrecta |
| ERR_C2 | Coherencia imagen-texto | Descripción ≠ gráfico |
| ERR_C3 | Coherencia de código | `abs(variable_formateada)` |

**Validar con:**
```bash
/validar-coherencia
```

---

### 6. 🧠 Errores de Coherencia Semántica (Nivel 4)

Detectados automáticamente por `validar_coherencia_matematica.R` (3 capas).

| Código | Capa | Error | Ejemplo |
|--------|------|-------|---------|
| ERR_SEM_A | A (Precondición) | Error seleccionado no cumple `precondicion` | EST-MTC-04 ("par") con n=7 (impar) |
| ERR_SEM_B | B (Keywords) | Descripción del error incoherente con datos | "datos desordenados" pero datos ya ordenados |
| WARN_SEM_B | B (Keywords) | Bug latente en pool (error no seleccionado) | Error con "bimodal" pero datos nunca bimodales |
| ERR_SEM_C | C (Cross-validación) | `calcula()` produce mismo valor que correcto | Distractor = respuesta correcta |

**Soluciones:**

- **ERR_SEM_A**: Agregar campo `precondicion = function(params) { ... }` al error y usar filtro genérico:
  ```r
  errores_aplicables_idx <- which(sapply(errores_conceptuales, function(err) {
    if (is.null(err$precondicion)) return(TRUE)
    err$precondicion(params)
  }))
  ```

- **ERR_SEM_B/WARN_SEM_B**: Revisar `descripcion_corta` y `descripcion_larga` del error. Ajustar redacción o agregar `precondicion`.

- **ERR_SEM_C**: Verificar que `calcula()` produce un valor diferente al correcto para todos los datos posibles.

**Validar con:**
```bash
Rscript .claude/scripts/validar_coherencia_matematica.R archivo.Rmd
```

---

### 7. 🎯 Errores de Correctitud de Respuesta (Nivel 5)

Detectados automáticamente por `validar_coherencia_matematica.R` (sub-niveles 5A-5E) y `validar_multisemilla.R`.

| Código | Sub-nivel | Error | Ejemplo |
|--------|-----------|-------|---------|
| ERR_ANS_A | 5A (exsolution dinámico) | exsolution dinámico evalúa a formato inválido | `` `r paste(sol)` `` produce "00" en vez de "0100" |
| ERR_ANS_B | 5B (Cross-check) | Respuesta marcada no coincide con valor correcto | `opciones[which(sol==1)]` ≠ `valor_correcto` |
| ERR_ANS_C | 5C (Unicidad) | Opciones duplicadas en SCHOICE | Dos opciones con mismo valor numérico |
| ERR_ANS_D | 5D (Rangos) | Valor fuera de rango matemático válido | Mediana fuera de [min(datos), max(datos)] |
| ERR_ANS_E | 5E (Distractor=Correcto) | Distractor idéntico a respuesta correcta | `digest(distractor) == digest(correcto)` |

**Soluciones:**

- **ERR_ANS_A**: Verificar que la expresión inline en `exsolution` produce un string binario válido (ej: "0100" para SCHOICE con 4 opciones).

- **ERR_ANS_B**: Verificar que `sol` marca la posición correcta y que `opciones_mezcladas[which(sol==1)]` coincide con `valor_correcto`.

- **ERR_ANS_C**: Verificar que `sample()` genera opciones todas diferentes. Ampliar rango de distractores si hay colisiones frecuentes.

- **ERR_ANS_D**: Verificar que los cálculos de mediana, cuartiles, probabilidades producen valores dentro de rangos válidos.

- **ERR_ANS_E**: Verificar que `calcula()` de cada error produce un valor diferente al correcto.

**Validar con:**
```bash
# Validación rápida (1 semilla)
Rscript .claude/scripts/validar_coherencia_matematica.R archivo.Rmd

# Multi-semilla rápida (20 semillas)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --n 20

# Multi-semilla exhaustiva (100 semillas)
Rscript .claude/scripts/validar_multisemilla.R archivo.Rmd --modo exhaustivo
```

---

## 🚀 Workflows de Corrección

### Workflow 1: Error de Compilación PDF

```

1. Copiar mensaje de error completo
2. Buscar en .claude/docs/patrones-errores-conocidos.md
3. Si existe patrón → Aplicar solución documentada
4. Si es nuevo → NO documentar hasta verificar solución
5. Probar con exams2pdf() y exams2html()
6. Solo si ambos funcionan → Documentar
```

### Workflow 2: Nuevo Ejercicio

```

1. /analizar-icfes [imagen]
2. /generar-schoice
3. Revisar .Rmd generado
4. /validar-diversidad
5. Compilar PDF y HTML
6. Si todo OK → /promover-ejercicio
```

---

## 📚 Recursos

### Documentación Principal

- **Patrones de error:** `.claude/docs/patrones-errores-conocidos.md`
- **Sistema general:** `.claude/docs/README.md`
- **Resumen TikZ:** `.claude/docs/RESUMEN_CORRECCION_TIKZ.md`

### Skills Disponibles

**Generación:**

- `/analizar-icfes` - Analizar ejercicio ICFES
- `/generar-schoice` - Generar SCHOICE
- `/generar-cloze` - Generar CLOZE
- `/promover-ejercicio` - Promover a producción

**Validación:**

- `/validar-renderizado` - Ciclo completo exams2* (html, pdf, docx, nops)
- `/validar-diversidad` - Validar 250+ versiones únicas (de 300 intentos)
- `/validar-coherencia` - Verificar coherencia matemática/imagen/código

**Diagnóstico y Corrección:**

- `/diagnosticar-errores` - Clasificar errores (Gráficos/Texto/Estructura/Coherencia)
- `/corregir-error-imagen` - Corregir errores TikZ (renderizado condicional)
- `/corregir-graficos` - Solucionar problemas de visualización

### Ejemplos Funcionales
```bash
# Ver ejercicios en producción
ls A-Produccion/En-Produccion/**/*.Rmd

# Ver ejercicios en pre-desarrollo (también funcionales)
ls A-Produccion/En-PreDesarrollo/**/*.Rmd

# Ver templates
ls A-Produccion/Templates/*.Rmd
```

---

## 🔍 Diagnóstico Rápido

### Pregunta 1: ¿El error es de compilación?

- **Sí** → Revisar `.claude/docs/patrones-errores-conocidos.md`
- **No** → Continuar

### Pregunta 2: ¿Es un error de imagen PNG no encontrada?

- **Sí** → Usar `/corregir-error-imagen`
- **No** → Continuar

### Pregunta 3: ¿Es un error de diversidad?

- **Sí** → Aumentar aleatorización, probar `/validar-diversidad`
- **No** → Continuar

### Pregunta 4: ¿Es un error nuevo?

- **Sí** → Investigar, NO documentar hasta verificar solución
- **No** → Consultar documentación

---

## ✅ Checklist Pre-Promoción

Antes de usar `/promover-ejercicio`, validar en **TRES NIVELES**:

### **Nivel 1: RStudio (Run > Run all)**

- [ ] Todos los chunks ejecutan sin errores
- [ ] El output configurado en YAML se genera correctamente
- [ ] Los gráficos TikZ se visualizan

### **Nivel 2: Generación Masiva (SemilleroUnico_v2.R)**

- [ ] `exams2html()` exitoso
- [ ] `exams2pdf()` exitoso
- [ ] `exams2pandoc()` (DOCX) exitoso
- [ ] `exams2nops()` (escaneables) exitoso
- [ ] Tasa de éxito: 4 de 4 formatos (100%)
- [ ] Diagramas/gráficos visibles en TODOS los formatos

### **Validación Adicional**

- [ ] Diversidad ≥ 250 versiones únicas (de 300 intentos)
- [ ] Metadatos ICFES completos
- [ ] Solución matemática correcta
- [ ] Sin errores en tests unitarios

### **Nivel 3: Terreno (Estudiantes)**

- [ ] Enunciado claro y sin ambigüedades
- [ ] Contexto apropiado para el nivel
- [ ] Distractores plausibles
- [ ] Tiempos de resolución razonables
- [ ] Sin errores reportados por estudiantes

> **Nota:** El Nivel 3 se valida después de la promoción, en el aula.

---

## 🆘 Soporte

### Si el error no está documentado:

1. ✋ **NO documentar** hasta tener solución verificada
2. 🔬 Investigar causa raíz
3. 🧪 Desarrollar solución candidata
4. ✅ Validar completamente (PDF + HTML)
5. 📝 Documentar en `patrones-errores-conocidos.md`
6. 🤖 Crear skill si es generalizable

### Principio fundamental:
> **Solo documentamos soluciones 100% verificadas y reproducibles**

---

## 📞 Comandos de Emergencia

```bash
# Ver logs recientes
find . -name "*.log" -type f -mmin -10

# Limpiar archivos temporales
rm -rf /tmp/Rtmp*

# Verificar instalación de paquetes
R -e "library(exams); library(tikzDevice)"

# Compilación de prueba simple
R -e "exams::exams2html('archivo.Rmd', n=1)"
```

---

**Última actualización:** 2026-02-14
**Versión:** 1.2

### Cambios v1.2 (2026-02-14)
- Agregada sección de errores de correctitud de respuesta (ERR_ANS_A/B/C/D/E)
- Documentadas soluciones para errores de validación Nivel 5
- Referencia a `validar_multisemilla.R` para stress-testing

### Cambios v1.1 (2026-02-13)
- Agregada sección de errores de coherencia semántica (ERR_SEM_A/B/C, WARN_SEM_B)
- Documentadas soluciones para errores de validación Nivel 4
