# 📚 Guía de Usuario - Sistema Claude Code ICFES R-Exams

Guía completa para usar el sistema de automatización Claude Code para generación de ejercicios ICFES R-Exams.

---

## 🤖 Sobre los Skills

Este sistema utiliza **Skills de Claude Code** (no comandos shell). Los skills son comandos especializados que comienzan con `/` y ejecutan flujos de trabajo completos. Están configurados en `.claude/skills/` con permisos preconfigurados para ejecución sin confirmación.

**Skills disponibles:** 7 (ver lista completa abajo)

---

## 🚀 INICIO RÁPIDO

**¿Primera vez usando el sistema?**

1. **Guía paso a paso completa**: `.claude/docs/WORKFLOW_PASO_A_PASO.md`
   - Tutorial detallado desde subir imagen hasta ejercicio en producción
   - Incluye ejemplos, tiempos estimados y troubleshooting

2. **Referencia visual rápida**: `.claude/docs/GUIA_RAPIDA_VISUAL.md`
   - Diagramas visuales del workflow
   - Checklist rápido
   - Skills clave

3. **Esta guía**: Referencia de skills y recursos

---

## 🎯 Skills Principales (Workflow)

### 1. Análisis de Ejercicios ICFES

#### `/analizar-icfes` ✅ COMANDO ESTÁNDAR

**Propósito:** Analizar y clasificar ejercicios ICFES según las 6 dimensiones oficiales del Mermaid Chart

**Uso:**
```bash
/analizar-icfes [ruta/a/imagen.png]
```

**Ejemplo:**
```bash
/analizar-icfes A-Produccion/imagenes/ejercicio_geometria.png
```

**Salida esperada:**
```
Análisis ICFES completado:

1. **Nivel de Dificultad**: 3 (Intermedio Alto)
2. **Competencia**: Formulación y Ejecución
3. **Componente**: Geométrico-Métrico
4. **Pensamiento**: Pensamiento Espacial
5. **Contenido**: Geometría (Contenidos No Genéricos)
6. **Eje**: Aplicado/Contextualizado

Decisión de Flujo: Flujo B (Con gráficas TikZ)
```

**Siguiente paso:** Usar `/generar-schoice` o `/generar-cloze` según el tipo de ejercicio

**Documentación completa:** `.claude/skills/analizar-icfes/skill.md`

---

### 2. Generación de Ejercicios

#### `/generar-schoice`

**Propósito:** Generar ejercicio R-exams tipo SCHOICE (selección única)

**Prerequisito:** Haber ejecutado `/analizar-icfes` primero

**Uso:**
```bash
/generar-schoice
```

**Salida:** Archivo `.Rmd` en `/A-Produccion/En-Desarrollo/`

**Documentación completa:** `.claude/skills/generar-schoice/skill.md`

#### `/generar-cloze`

**Propósito:** Generar ejercicio R-exams tipo CLOZE (pregunta compuesta)

**Prerequisito:** Haber ejecutado `/analizar-icfes` primero

**Uso:**
```bash
/generar-cloze
```

**Salida:** Archivo `.Rmd` en `/A-Produccion/En-Desarrollo/`

**Documentación completa:** `.claude/skills/generar-cloze/skill.md`

---

### 3. Validación y Corrección

#### `/validar-diversidad`

**Propósito:** Validar que el ejercicio genera 250+ versiones únicas (de 300 intentos)

**Uso:**
```bash
/validar-diversidad [archivo.Rmd]
```

#### `/corregir-error-imagen`

**Propósito:** Corregir errores de imágenes faltantes reemplazando con código TikZ

**Uso:**
```bash
/corregir-error-imagen [archivo.Rmd]
```

**Documentación completa:** `.claude/skills/corregir-error-imagen/skill.md`

---

### 4. Promoción a Producción

#### `/promover-ejercicio`

**Propósito:** Mover ejercicio testeado desde En-Desarrollo a 03-En-Produccion/[categoría ICFES]/

**Prerequisitos:**

- ✅ Diversidad de 250+ versiones únicas verificada
- ✅ Compilación exitosa en PDF y HTML
- ✅ Metadatos ICFES completos
- ✅ Calidad del contenido validada

**Uso:**
```bash
/promover-ejercicio [nombre.Rmd]
```

**Documentación completa:** `.claude/skills/promover-ejercicio/skill.md`

---

## 🔄 Workflow Completo

### Workflow Estándar: Nuevo Ejercicio

```

1. /analizar-icfes [imagen.png]
   ↓

2. /generar-schoice (o /generar-cloze)
   ↓

3. Revisar archivo .Rmd generado
   ↓

4. /validar-diversidad [archivo.Rmd]
   ↓

5. Compilar PDF y HTML en RStudio
   ↓

6. Si todo OK → /promover-ejercicio [archivo.Rmd]
```

**Documentación completa:** `.claude/docs/TROUBLESHOOTING.md`

---

## ⚠️ Comandos Deprecados

### `/analizar-ejercicio` ❌ NO USAR

**Estado:** DEPRECADO desde 2025-12-20

**Razón:** Análisis incompleto (solo 3 de 6 dimensiones ICFES)

**Alternativa:** Usar `/analizar-icfes` en su lugar

**Documentación:** `.claude/docs/COMANDOS_DEPRECADOS.md`

---

## 📚 Recursos Adicionales

### Documentación Técnica

- **Sistema general:** `.claude/docs/README.md`
- **Tres niveles de validación:** `.claude/docs/TRES_NIVELES_VALIDACION.md`
- **Patrones de errores conocidos:** `.claude/docs/patrones-errores-conocidos.md`
- **Comandos deprecados:** `.claude/docs/COMANDOS_DEPRECADOS.md`
- **Changelog:** `.claude/docs/CHANGELOG.md`

### Agentes Especializados

- **ClasificadorICFES:** `.claude/agents/clasificador-icfes.md`
- **AgenteTikZ:** `.claude/agents/graficador-tikz.md`

### Ejemplos Funcionales

```bash
# Ver ejercicios en producción
ls A-Produccion/En-Produccion/**/*.Rmd

# Ver ejercicios en pre-desarrollo (también funcionales)
ls A-Produccion/En-PreDesarrollo/**/*.Rmd

# Ver templates
ls A-Produccion/Templates/*.Rmd

# Ver ejemplos funcionales
ls A-Produccion/Ejemplos-Funcionales-Rmd/
```

---

## 🆘 Troubleshooting

### Problema: Error de compilación PDF

**Solución:**

1. Revisar `.claude/docs/patrones-errores-conocidos.md`
2. Si es error de imagen faltante: `/corregir-error-imagen`
3. Verificar logs de compilación

### Problema: Menos de 250 versiones únicas

**Solución:**

1. Revisar función `generar_datos()` en el .Rmd
2. Aumentar rangos de aleatorización
3. Ejecutar `/validar-diversidad` nuevamente

### Problema: Metadatos ICFES incompletos

**Solución:**

1. Verificar que usaste `/analizar-icfes` (no `/analizar-ejercicio`)
2. Revisar que el análisis incluyó las 6 dimensiones
3. Regenerar el ejercicio con `/generar-schoice` o `/generar-cloze`

---

## 📞 Soporte

Para más ayuda, consultar:

- **Troubleshooting completo:** `.claude/docs/TROUBLESHOOTING.md`
- **Tests de validación:** `.claude/tests/test_comandos_workflow.md`

---

**Última actualización:** 2025-12-28
**Versión:** 1.1

