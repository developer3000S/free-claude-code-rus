# Ortografía Española - Diccionario de Referencia

**Copiar palabras TAL CUAL de aquí. No improvisar.**

## REGLA DE GENERACIÓN (OBLIGATORIA)

**Al generar o escribir CUALQUIER archivo .Rmd (Write/Edit), Claude DEBE incluir tildes correctas en TODO texto español visible al estudiante DESDE EL PRIMER BORRADOR.**

No es aceptable generar sin tildes y corregir después. La generación con tildes correctas es obligatoria en:

1. **Strings `paste0()`** en plantillas de contextos narrativos
2. **Strings `paste0()`** en descripciones de errores conceptuales (descripcion_corta, descripcion_larga, causa_raiz)
3. **Strings `c()`** en reflexiones metacognitivas
4. **Strings `paste0()`** en sol_texts del Answerlist de Solution
5. **Texto Markdown** en secciones Question y Solution
6. **Encabezados Markdown** (### Análisis, ### Reflexión, etc.)

**Errores frecuentes de generación (detectados 2026-02-26):**

| Palabra sin tilde (ERROR) | Palabra correcta | Contexto típico |
|---------------------------|------------------|-----------------|
| `realizo` | `realizó` | Plantillas narrativas (pretérito) |
| `pregunto` | `preguntó` | Plantillas narrativas |
| `organizo` | `organizó` | Plantillas narrativas |
| `descubrio` | `descubrió` | Plantillas narrativas |
| `publico` | `publicó` | Plantillas narrativas |
| `encuesto` | `encuestó` | Plantillas narrativas |
| `identifico` | `identificó` | Descripción de errores |
| `excluyo` | `excluyó` | Descripción de errores |
| `confundio` | `confundió` | Descripción de errores |
| `sombreo` | `sombreó` | Descripción de errores |
| `cometio` | `cometió` | Descripción de errores |
| `aplico` | `aplicó` | Descripción de errores |
| `interpreto` | `interpretó` | Descripción de errores |
| `cafeteria` | `cafetería` | Contextos narrativos |
| `boletin` | `boletín` | Contextos narrativos |
| `periodico` | `periódico` | Contextos narrativos |
| `companeros` | `compañeros` | sujeto del contexto |
| `interseccion` | `intersección` | Errores + Solution |
| `exclusion` | `exclusión` | Errores + Solution (NO en variables R) |
| `union` (texto) | `unión` | Errores + Solution (NO en variables R) |
| `omision` | `omisión` | causa_raiz |
| `confusion` | `confusión` | causa_raiz |
| `region` | `región` | Solution markdown |
| `operacion` | `operación` | Solution markdown |
| `expresion` | `expresión` | Solution markdown |
| `analisis` | `análisis` | Encabezados Solution |
| `opcion` | `opción` | Solution ("Opción A") |
| `reflexion` | `reflexión` | Encabezados Solution |
| `tambien` | `también` | Solution markdown |
| `ademas` | `además` | Descripciones errores |
| `calculo` | `cálculo` | Solution markdown |
| `asi` | `así` | Plantillas narrativas |
| `area` | `área` | Descripciones errores |
| `Cual` | `¿Cuál` | Pregunta Question (agregar ¿) |
| `Que` (interrogativo) | `¿Qué` | Pregunta retórica (agregar ¿) |
| `como` (interrogativo) | `cómo` | Reflexiones metacognitivas |

---

## Palabras Frecuentes

```
más  según  así  después  también  además  aquí  ahí

ángulo  gráfica  gráfico  función  número  cálculo  método  código  propósito  patrón  máximo  mínimo  análisis  éxito

dispersión  solución  ecuación  relación  variación  descripción  información  configuración  clasificación  validación  explicación  distribución  combinación  iteración  sección  versión  dimensión  selección

intersección  exclusión  unión  omisión  confusión  reflexión  operación  expresión  región  opción  comprensión  metacognición  interpretación  argumentación  formulación

matemático  estadística  científico  parabólico  geométrico  numérico  teórico  único  dinámico  automático  semántico  simbólico  simultáneo

realizó  preguntó  organizó  descubrió  publicó  encuestó  identificó  excluyó  confundió  sombreó  cometió  aplicó  interpretó  calculó  obtuvo

cafetería  boletín  periódico  compañeros  jóvenes  líder  géneros  área  comité  gastronómica
```

## Excepciones (SIN tilde)

### 1. Variables R
- `angulos`, `solucion`, `grafica`, `numero`, `codigo`, `metodo`
- Razón: Nombres de variables R deben ser ASCII para compatibilidad

### 2. Metadatos R-exams (OBLIGATORIO ASCII)
Los siguientes campos NUNCA llevan tildes porque R-exams los usa como identificadores:

```
exname: nombre_ejercicio_sin_tildes
exsection: Numerico-Variacional/Argumentacion
extype: schoice
exsolution: 1000
exshuffle: TRUE
extol: 0.01
exextra[Competencia]: Interpretacion
exextra[Componente]: Aleatorio
```

**Razón**: R-exams parsea estos campos como identificadores. Las tildes pueden causar errores de codificación en algunos sistemas.

### 3. Inglés técnico
- TikZ, LaTeX, R-exams, chunk, hash, reticulate, ggplot2

### 4. Pronombres demostrativos
- "Esta/Estas" (≠ "Está" verbo estar)
- "Este/Estos" (≠ "Esté" subjuntivo)

## Validación Automática

El proyecto tiene DOS checkers ortográficos complementarios:

### Checker Python (v2.0, RECOMENDADO) — `.claude/scripts/corregir_ortografia_espanol.py`

- **Diccionario**: ~500+ palabras (vs ~140 del checker R legacy)
- **Detección multilínea**: maneja strings en `paste0()`, `cat()`, strings en listas
- **Cobertura**: detecta errores que el checker R omite (~95% de falsos negativos eliminados)

```bash
# Verificar errores (sin corregir)
python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd

# Aplicar correcciones
python3 .claude/scripts/corregir_ortografia_espanol.py archivo.Rmd --fix

# Procesar directorio completo
python3 .claude/scripts/corregir_ortografia_espanol.py directorio/ --fix
```

### Checker R (v1.0, legacy) — `.claude/scripts/corregir_ortografia_espanol.R`

Se mantiene como fallback. Limitación conocida: su diccionario reducido (~140 palabras)
no detecta errores dentro de strings R multilínea.

```bash
# Verificar errores (sin corregir)
Rscript .claude/scripts/corregir_ortografia_espanol.R archivo.Rmd

# Aplicar correcciones
Rscript .claude/scripts/corregir_ortografia_espanol.R archivo.Rmd --fix
```

El script excluye automáticamente:
1. Metadatos R-exams (exname, exsection, extype, etc.)
2. Nombres de variables R en contexto de código
3. Código inline `` `r variable` ``

## NUNCA usar --no-verify

Si el hook de ortografía detecta errores:
1. Verificar si son falsos positivos (metadatos R-exams → ya excluidos)
2. Si son errores reales → corregirlos con `--fix`
3. **NUNCA** usar `git commit --no-verify` para evadir el hook
