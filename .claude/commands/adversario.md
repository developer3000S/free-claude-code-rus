Lanza un análisis adversarial con Convicción Epistémica, anti-sicofancia estructural, verificación formal output-first y multi-perspectiva sobre el contenido proporcionado.

## Input recibido

$ARGUMENTS

## Instrucciones

Si el input está vacío, responde SOLO con:
"Uso: `/adversario <contenido>` donde contenido puede ser: texto libre, un path a archivo, o un bloque de código."

Si el input NO está vacío, sigue estos pasos:

### Fase 1: Análisis

#### Paso 1: Leer el contenido

- Si el input parece un path a archivo (empieza con `/` o `~` o `./`), lee el archivo primero con Read

#### Paso 2: Detectar si hay contenido visual o PDF fuente

Analiza el contenido leído y determina si:
- Es un documento de alineación curricular (contiene "Tabla Maestra", "Fichas Detalladas", respuestas de evaluación)
- Hace referencia a un PDF fuente (cuadernillo de evaluación)

#### Paso 3: Verificación con NotebookLM (si aplica)

Si hay notebooks de NotebookLM vinculados:
1. Usa `mcp__notebooklm__notebook_query` para consultas puntuales
2. Útil para verificar marco ICFES, afirmaciones y evidencias

#### Paso 4: Lanzar el agente adversario

Pasa el contenido al agente adversario usando Agent tool con subagent_type="adversario". El prompt DEBE incluir:

1. El contenido original a analizar (path al archivo para que el agente lo lea)
2. Si extrajiste contexto multimedia en el Paso 3, inclúyelo

**IMPORTANTE**: El agente adversario opera con Convicción Epistémica y es output-first con Chain of Verification integrado. No necesitas darle instrucciones sobre metodología — su prompt interno ya define el orden: Factual Recall → simular outputs → multi-perspectiva → CoVe → resistencia ToF → código. Solo pásale el contenido.

**NOTA ANTI-SICOFANCIA**: Si el agente adversario reporta premisas erróneas del usuario, presentarlas SIN atenuación. No suavizar las correcciones del agente para "proteger" al usuario. La utilidad técnica prevalece sobre el confort social.

#### Paso 5: Presentar resultado y evaluación honesta

Presenta el resultado del agente adversario. Luego agrega tu evaluación:
- ¿Cuántos bugs pasaron CoVe (verificación cruzada)?
- ¿La confianza global del reporte es ALTA, MEDIA o BAJA?
- ¿Cuántos bugs son realmente impactantes para el usuario final?
- ¿Cuántos son ruido que no vale la pena corregir?
- Recomendación: implementar, descartar, o mezcla.

---

### Fase 2: Implementación de correcciones (post-análisis)

Esta fase se activa SOLO cuando el usuario responde con "Proceder", "Corregir", "Implementar", etc.

**PROTOCOLO:**

#### Paso 6: Filtrar sin piedad

Del reporte del adversario, SOLO implementar bugs que cumplan TODOS los criterios:
1. Tiene ejemplo concreto con valores que reproducen el problema
2. Pasó Chain of Verification (confianza ALTA o MEDIA)
3. Un usuario real vería algo incorrecto

Presentar al usuario qué se implementa y qué se descarta ANTES de proceder.

#### Paso 7: Implementar

Para los fixes que pasen el filtro, lanzar agente implementador (máximo 5 fixes por lote):

```
Agent(subagent_type="implementador", model="sonnet", prompt="
  Archivo: [path completo]
  Lee el archivo completo PRIMERO. Luego aplica estas correcciones EN ORDEN:
  ### Fix 1: [título]
  - old: `[fragmento a reemplazar]`
  - new: `[fragmento corregido]`
  ...
  IMPORTANTE:
  - Lee el archivo ANTES de cada Edit
  - NO hagas cambios adicionales fuera de los listados
")
```

#### Paso 8: Verificar

Después de cada implementador, verificar con Grep (NUNCA `git diff` en archivos untracked).

#### Paso 9: Validación post-implementación (OBLIGATORIA)

1. **R-exams .Rmd**: Si el archivo es .Rmd, ejecutar `exams2html("archivo.Rmd", n=1)` para verificar que los fixes no rompieron el renderizado. Si falla, revertir el fix que causó la rotura.
2. **JS/HTML**: Ejecutar validación con node
3. **Re-run CoVe**: Para cada fix aplicado, verificar que el bug original ya no se reproduce
4. **Resumen**: Tabla de fixes aplicados vs descartados

**Lección aprendida (2026-03-23)**: Un fix del adversario eliminó `library(exams)` de un .Rmd causando `Error: no se pudo encontrar la función "answerlist"`. El renderizado de prueba lo habría detectado inmediatamente.

#### Regla anti-duplicación

NUNCA re-aplicar un fix que ya está presente. Verificar con Grep antes de cada lote.
