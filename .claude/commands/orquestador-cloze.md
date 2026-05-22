Lanza el agente `orquestador-cloze`: pipeline end-to-end del workflow ICFES CLOZE (11 pasos, 3 pausas humanas obligatorias). Wrapper que delega al agente vía `Task(subagent_type="orquestador-cloze", ...)`.

## Input recibido

$ARGUMENTS

## Instrucciones para Claude

Si `$ARGUMENTS` está vacío, responde SOLO con este mensaje y termina:

````
Uso: /orquestador-cloze <input>

Donde <input> es UNO de:

1) JSON completo (recomendado para producción):
   /orquestador-cloze {"ruta_destino":"A-Produccion/01-En-PreDesarrollo/mi-ejercicio","nombre_ejercicio":"promedios_metacognitivo_argumentacion_n3_cloze_v1","entrada":"<ruta-imagen-o-texto>","modo":"ejecutar"}

2) Forma corta (texto libre): describe destino + entrada y yo construyo el JSON antes de lanzar:
   /orquestador-cloze promedios n3 cloze desde enunciado "Un profesor registró..." en 01-En-PreDesarrollo/promedios-v1

3) Modo dry-run (audita el plan sin ejecutar):
   /orquestador-cloze {"ruta_destino":"...","nombre_ejercicio":"...","entrada":"...","modo":"dry-run"}

Schema del JSON (ver `.claude/agents/orquestador-cloze.md`):
- ruta_destino:       debe estar bajo A-Produccion/01-En-PreDesarrollo/ o /02-En-Desarrollo/
- nombre_ejercicio:   <tema>_metacognitivo_<competencia>_n<3|4>_cloze_v<N>
- entrada:            ruta a imagen ICFES original | texto del enunciado
- modo:               "ejecutar" | "dry-run"
- opciones_extra:     { estructura_cloze, num_partes, max_reintentos_por_fase, auto_seleccionar_grafico } (opcional)

Diferencias clave vs /orquestador-schoice:
- CLOZE requiere mínimo 4 partes con Progressive Disclosure (Identificar→Calcular→Evaluar→Transferir)
- exclozetype multi-gap (ej: schoice|num|mchoice|schoice)
- NOPS espera fallar si hay gaps num/string (no es error)
- DOK mínimo: 3 (vs 2 para SCHOICE)
- Nivel mínimo: n3 (vs n2 para SCHOICE)
````

Si `$ARGUMENTS` contiene contenido:

1. **Detecta el formato:**
   - Si empieza con `{` y parsea como JSON → usar tal cual.
   - Si es texto libre → construye un JSON mínimo razonable a partir de él (pide confirmación al usuario en una sola línea antes de lanzar si hay ambigüedad sobre `ruta_destino` o `nombre_ejercicio`).

2. **Valida pre-flight ligero antes de delegar** (no reemplaza los pre-flight del agente, solo evita lanzamientos obviamente rotos):
   - `ruta_destino` está bajo `A-Produccion/01-En-PreDesarrollo/` o `02-En-Desarrollo/`. Si está bajo `03-En-Produccion/` o `Ejemplos-Funcionales-Rmd/` → **rechaza** y muestra la regla violada.
   - `nombre_ejercicio` matchea `^[a-z0-9_]+_metacognitivo_[a-z]+_n[34]_cloze_v[0-9]+$` (warning, no bloqueo, si no coincide). **Nota**: CLOZE requiere `n3` o `n4` como nivel mínimo.
   - `modo` ∈ {"ejecutar","dry-run"}; si falta, default `"ejecutar"`.
   - Si `opciones_extra.num_partes` < 4 → advertir que se usará 4 como mínimo (regla `ejercicios-metacognitivos.md`).

3. **Lanza el agente** con un único `Task` call (foreground, NO background — el orquestador necesita interactuar con el usuario en los 3 `WAIT_USER`):

   ```
   Task(
     subagent_type = "orquestador-cloze",
     description = "Orquestador CLOZE: <nombre_ejercicio>",
     prompt = <JSON serializado del input validado>
   )
   ```

4. **Cuando el agente retorne**, presenta al usuario:
   - El `exit_status` reportado por el agente.
   - Resumen de pasos completados (lista de los 11 con ✅/⬜).
   - La estructura CLOZE generada (número de partes y tipos).
   - Si quedó pendiente un `WAIT_USER`, indica cuál y qué decisión necesita tomar el usuario para reanudar.
   - Ruta del `.Rmd` final si llegó al paso 11.

5. **No dupliques trabajo**: el agente ya hace sus propios pre-flight checks, validaciones CLOZE (V1-V4) y manejo de errores. Tu job aquí es: parsear input, validar lo mínimo, delegar, reportar.

## Notas

- El agente tiene `maxTurns: 65` y `model: opus`. Una corrida completa es costosa (~15-20% más turnos que SCHOICE por la complejidad multi-parte).
- Para auditar antes de gastar tokens: usar `modo: "dry-run"` la primera vez.
- El agente soporta **reanudación**: si `ejercicio_state.json` existe en `ruta_destino`, retoma desde el primer paso pendiente. No hace falta reiniciar.
- La complejidad de un CLOZE (4+ tipos de gap, Progressive Disclosure, validación por parte) justifica el presupuesto extra de turnos respecto a SCHOICE.
- NOPS fallará si el CLOZE tiene gaps `num` o `string` (casi siempre). Esto **no es un error**, es una limitación conocida de R-exams. El agente lo maneja automáticamente.
