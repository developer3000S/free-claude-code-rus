# 🚀 Guía Rápida Visual: De Imagen a Ejercicio R-Exams

**Referencia rápida del workflow completo en formato visual**

---

## 📸 INICIO: Tengo una Imagen de Ejercicio ICFES

```
┌─────────────────────────────────────────────────────────┐
│  📷 IMAGEN DEL EJERCICIO ICFES                         │
│                                                         │
│  ┌───────────────────────────────────────────────┐    │
│  │ Enunciado: En un triángulo rectángulo...     │    │
│  │                                                │    │
│  │     [Diagrama geométrico]                     │    │
│  │                                                │    │
│  │ A) 12 cm                                      │    │
│  │ B) 15 cm                                      │    │
│  │ C) 18 cm                                      │    │
│  │ D) 20 cm                                      │    │
│  └───────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────┘
```

**¿Qué hago?** → Subir la imagen a Claude Code

---

## 🔄 PASO A PASO VISUAL

### PASO 1: Subir Imagen

```
┌──────────────────────────────────────────────────────────┐
│  VSCode + Claude Code                                    │
│  ┌────────────────────────────────────────────────────┐ │
│  │  💬 Chat de Claude Code                           │ │
│  │                                                    │ │
│  │  [Arrastrar imagen aquí] 📎                       │ │
│  │                                                    │ │
│  │  O escribir:                                      │ │
│  │  /analizar-icfes [ruta/imagen.png]               │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

**Acción:** Arrastrar imagen o usar comando `/analizar-icfes`

---

### PASO 2: Análisis Automático

```
┌──────────────────────────────────────────────────────────┐
│  🤖 Claude Code Analiza la Imagen                        │
│                                                          │
│  ✅ Nivel de Dificultad: 3                              │
│  ✅ Competencia: Formulación y Ejecución                │
│  ✅ Componente: Geométrico-Métrico                      │
│  ✅ Pensamiento: Espacial                               │
│  ✅ Contenido: Geometría                                │
│  ✅ Eje: Aplicado                                       │
│                                                          │
│  🎨 Gráficos detectados: SÍ → FLUJO B (TikZ)           │
│  📝 Tipo: SCHOICE                                       │
│                                                          │
│  ➡️  Próximo paso: /generar-schoice                     │
└──────────────────────────────────────────────────────────┘
```

**Resultado:** Clasificación completa + Decisión de flujo

---

### PASO 3: Generar Ejercicio

```
┌──────────────────────────────────────────────────────────┐
│  💬 Ejecutar Comando                                     │
│                                                          │
│  > /generar-schoice                                     │
│                                                          │
│  🔄 Generando...                                        │
│     ├─ Consultando ejemplos funcionales                │
│     ├─ Generando código .Rmd                           │
│     ├─ Creando código TikZ para gráfico                │
│     ├─ Configurando aleatorización                     │
│     └─ Agregando metadatos ICFES                       │
│                                                          │
│  ✅ Archivo generado:                                   │
│     A-Produccion/En-Desarrollo/                         │
│     Triangulos_Geometrico_Formulacion_n3_v1.Rmd         │
└──────────────────────────────────────────────────────────┘
```

**Resultado:** Archivo .Rmd completo en `/En-Desarrollo/`

---

### PASO 4: Revisar Archivo

```
┌──────────────────────────────────────────────────────────┐
│  📝 Archivo .Rmd Generado                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │ ---                                                │ │
│  │ output: pdf_document, html_document               │ │
│  │ ---                                                │ │
│  │                                                    │ │
│  │ ```{r inicio}                                     │ │
│  │ library(exams)                                    │ │
│  │ set.seed(sample(1:100000, 1))                     │ │
│  │ ```                                               │ │
│  │                                                    │ │
│  │ ```{r data_generation}                            │ │
│  │ generar_datos <- function() { ... }              │ │
│  │ ```                                               │ │
│  │                                                    │ │
│  │ ```{r tikz_diagram}                               │ │
│  │ include_tikz(...)                                 │ │
│  │ ```                                               │ │
│  │                                                    │ │
│  │ Question / Solution / Meta-information            │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

**Acción:** Revisar estructura y contenido

---

### PASO 5: Validar Diversidad

```
┌──────────────────────────────────────────────────────────┐
│  💬 Validar Versiones Únicas                             │
│                                                          │
│  > /validar-diversidad [archivo.Rmd]               │
│                                                          │
│  🔄 Generando 1000 versiones de prueba...              │
│                                                          │
│  ✅ RESULTADO: 847 versiones únicas                     │
│                                                          │
│  📊 Estadísticas:                                       │
│     • Versiones generadas: 1000                        │
│     • Versiones únicas: 847                            │
│     • Mínimo requerido: 250 versiones únicas           │
│     • Estado: ✅ APROBADO                              │
└──────────────────────────────────────────────────────────┘
```

**Criterio:** ≥ 250 versiones únicas (de 300 intentos)

---

### PASO 6: Compilar en RStudio

```
┌──────────────────────────────────────────────────────────┐
│  🔨 RStudio - Compilación                                │
│  ┌────────────────────────────────────────────────────┐ │
│  │ > library(exams)                                  │ │
│  │                                                    │ │
│  │ > exams2pdf("archivo.Rmd", n=3)                   │ │
│  │   ✅ PDF generado correctamente                   │ │
│  │                                                    │ │
│  │ > exams2html("archivo.Rmd", n=3)                  │ │
│  │   ✅ HTML generado correctamente                  │ │
│  │                                                    │ │
│  │ 📁 Output:                                        │ │
│  │    ├─ prueba1.pdf                                 │ │
│  │    ├─ prueba2.pdf                                 │ │
│  │    ├─ prueba3.pdf                                 │ │
│  │    ├─ prueba1.html                                │ │
│  │    ├─ prueba2.html                                │ │
│  │    └─ prueba3.html                                │ │
│  └────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

**Verificar:** PDF y HTML sin errores

---

### PASO 7: Promover a Producción

```
┌──────────────────────────────────────────────────────────┐
│  🚀 Promoción a Producción                               │
│                                                          │
│  > /promover-ejercicio [archivo.Rmd]                    │
│                                                          │
│  ✅ Verificando criterios de calidad...                 │
│     ├─ Diversidad: ✅ 847 versiones                    │
│     ├─ Compilación PDF: ✅ Sin errores                 │
│     ├─ Compilación HTML: ✅ Sin errores                │
│     ├─ Metadatos ICFES: ✅ Completos                   │
│     └─ Calidad matemática: ✅ Verificada               │
│                                                          │
│  📦 Moviendo archivo a:                                 │
│     A-Produccion/03-En-Produccion/[categoría]/          │
│                                                          │
│  ✅ EJERCICIO EN PRODUCCIÓN                             │
└──────────────────────────────────────────────────────────┘
```

**Resultado:** Ejercicio listo para uso

---

## ⏱️ TIEMPOS ESTIMADOS

```
┌─────────────────────────────────────────────────────────┐
│  FLUJO A (Sin Gráficas)          FLUJO B (Con TikZ)    │
│  ═══════════════════════          ═══════════════════   │
│                                                         │
│  📸 Subir imagen: 1 min           📸 Subir imagen: 1 min│
│  🔍 Analizar: 2-3 min             🔍 Analizar: 2-3 min  │
│  🛠️  Generar: 5-10 min            🛠️  Generar: 10-20 min│
│  📝 Revisar: 10-15 min            📝 Revisar: 10-15 min │
│  ✅ Validar: 2-3 min              ✅ Validar: 2-3 min   │
│  🔨 Compilar: 5-10 min            🔨 Compilar: 5-10 min │
│  🚀 Promover: 2-3 min             🚀 Promover: 2-3 min  │
│  ─────────────────────            ─────────────────────  │
│  ⏱️  TOTAL: 28-47 min             ⏱️  TOTAL: 38-57 min  │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 DECISIÓN DE FLUJO

```
                    ┌─────────────────┐
                    │  Imagen ICFES   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │ ¿Tiene gráficos?│
                    └────────┬────────┘
                             │
                ┌────────────┴────────────┐
                │                         │
           ┌────▼────┐              ┌────▼────┐
           │   NO    │              │   SÍ    │
           └────┬────┘              └────┬────┘
                │                         │
           ┌────▼────┐              ┌────▼────┐
           │ FLUJO A │              │ FLUJO B │
           │Sin TikZ │              │Con TikZ │
           └────┬────┘              └────┬────┘
                │                         │
                └────────────┬────────────┘
                             │
                    ┌────────▼────────┐
                    │ Generar .Rmd    │
                    └─────────────────┘
```

---

## 📋 CHECKLIST VISUAL

```
┌─────────────────────────────────────────────────────────┐
│  ANTES DE PROMOVER A PRODUCCIÓN                         │
│                                                         │
│  [ ] ✅ Imagen subida correctamente                     │
│  [ ] ✅ Análisis completo (6 dimensiones)               │
│  [ ] ✅ Archivo .Rmd generado                           │
│  [ ] ✅ Estructura revisada                             │
│  [ ] ✅ Diversidad ≥ 250 versiones únicas               │
│  [ ] ✅ PDF compila sin errores                         │
│  [ ] ✅ HTML compila sin errores                        │
│  [ ] ✅ Gráficos correctos (si aplica)                  │
│  [ ] ✅ Metadatos ICFES completos                       │
│  [ ] ✅ Distractores plausibles                         │
│                                                         │
│  ✅ TODO LISTO → /promover-ejercicio                    │
└─────────────────────────────────────────────────────────┘
```

---

## 🆘 TROUBLESHOOTING RÁPIDO

```
┌─────────────────────────────────────────────────────────┐
│  PROBLEMA                    SOLUCIÓN                   │
│  ═══════════════════════════════════════════════════    │
│                                                         │
│  ❌ Análisis incompleto      → Solicitar 6 dimensiones │
│  ❌ Error compilación PDF    → /corregir-error-imagen  │
│  ❌ < 250 versiones únicas   → Aumentar rangos         │
│  ❌ Gráfico TikZ mal         → Solicitar mejora        │
│  ❌ Error Python             → Consultar ejemplos      │
│  ❌ Error LaTeX              → Ver patrones-errores    │
└─────────────────────────────────────────────────────────┘
```

---

## 🎓 COMANDOS CLAVE

```
┌─────────────────────────────────────────────────────────┐
│  COMANDO                     CUÁNDO USAR                │
│  ═══════════════════════════════════════════════════    │
│                                                         │
│  /analizar-icfes            → Después de subir imagen  │
│  /generar-schoice           → Si tipo es SCHOICE       │
│  /generar-cloze             → Si tipo es CLOZE         │
│  /validar-diversidad        → Antes de compilar        │
│  /corregir-error-imagen     → Si error de imagen       │
│  /promover-ejercicio        → Cuando todo esté OK      │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 DOCUMENTACIÓN COMPLETA

Para más detalles, consultar:

- **Guía paso a paso completa**: `.claude/docs/WORKFLOW_PASO_A_PASO.md`
- **Guía de usuario**: `.claude/docs/GUIA_USUARIO.md`
- **Troubleshooting**: `.claude/docs/TROUBLESHOOTING.md`

---

**Última actualización:** 2025-12-20  
**Versión:** 1.0

