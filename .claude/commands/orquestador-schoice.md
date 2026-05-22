Lanza el agente `orquestador-schoice`: pipeline end-to-end del workflow ICFES SCHOICE (11 pasos, 3 pausas humanas obligatorias). Wrapper que delega al agente vía `Task(subagent_type="orquestador-schoice", ...)`.

## Input recibido

$ARGUMENTS

## Instrucciones para Claude

Si `$ARGUMENTS` está vacío, responde SOLO con este mensaje y termina:

````
Uso: /orquestador-schoice <input>

Donde <input> es UNO de:

1) JSON completo (recomendado para producción):
   /orquestador-schoice {"ruta_destino":"A-Produccion/01-En-PreDesarrollo/mi-ejercicio","nombre_ejercicio":"mediana_metacognitivo_argumentacion_n3_schoice_v1","entrada":"<ruta-imagen-o-texto>","modo":"ejecutar"}

2) Forma corta (texto libre): describe destino + entrada y yo construyo el JSON antes de lanzar:
   /orquestador-schoice mediana n3 desde imagenes/p23.png en 01-En-PreDesarrollo/mediana-v1

3) Modo dry-run (audita el plan sin ejecutar):
   /orquestador-schoice {"ruta_destino":"...","nombre_ejercicio":"...","entrada":"...","modo":"dry-run"}

Schema del JSON (ver `.claude/agents/orquestador-schoice.md`):
- ruta_destino:    debe estar bajo A-Produccion/01-En-PreDesarrollo/ o /02-En-Desarrollo/
- nombre_ejercicio: <tema>_metacognitivo_<competencia>_n<2|3|4>_schoice_v<N>
- entrada:         ruta a imagen ICFES original | texto del enunciado
- modo:            "ejecutar" | "dry-run"
- opciones_extra:  { patron_metacognitivo, max_reintentos_por_fase, auto_seleccionar_grafico } (opcional)
````

Si `$ARGUMENTS` contiene contenido:

1. **Detecta el formato:**
   - Si empieza con `{` y parsea como JSON → usar tal cual.
   - Si es texto libre → construye un JSON mínimo razonable a partir de él (pide confirmación al usuario en una sola línea antes de lanzar si hay ambigüedad sobre `ruta_destino` o `nombre_ejercicio`).

2. **Valida pre-flight ligero antes de delegar** (no reemplaza los pre-flight del agente, solo evita lanzamientos obviamente rotos):
   - `ruta_destino` está bajo `A-Produccion/01-En-PreDesarrollo/` o `02-En-Desarrollo/`. Si está bajo `03-En-Produccion/` o `Ejemplos-Funcionales-Rmd/` → **rechaza** y muestra la regla violada.
   - `nombre_ejercicio` matchea `^[a-z0-9_]+_metacognitivo_[a-z]+_n[234]_schoice_v[0-9]+$` (warning, no bloqueo, si no coincide).
   - `modo` ∈ {"ejecutar","dry-run"}; si falta, default `"ejecutar"`.

3. **Lanza el agente** con un único `Task` call (foreground, NO background — el orquestador necesita interactuar con el usuario en los 3 `WAIT_USER`):

   ```
   Task(
     subagent_type = "orquestador-schoice",
     description = "Orquestador SCHOICE: <nombre_ejercicio>",
     prompt = <JSON serializado del input validado>
   )
   ```

4. **Cuando el agente retorne**, presenta al usuario:
   - El `exit_status` reportado por el agente.
   - Resumen de pasos completados (lista de los 11 con ✅/⬜).
   - Si quedó pendiente un `WAIT_USER`, indica cuál y qué decisión necesita tomar el usuario para reanudar (ej: "Reanuda con `/orquestador-schoice {...,\"modo\":\"ejecutar\"}` después de responder Flujo B").
   - Ruta del `.Rmd` final si llegó al paso 11.

5. **No dupliques trabajo**: el agente ya hace sus propios pre-flight checks, validaciones y manejo de errores. Tu job aquí es: parsear input, validar lo mínimo, delegar, reportar.

## Notas

- El agente tiene `maxTurns: 60` y `model: opus`. Una corrida completa es costosa.
- Para auditar antes de gastar tokens: usar `modo: "dry-run"` la primera vez.
- El agente soporta **reanudación**: si `ejercicio_state.json` existe en `ruta_destino`, retoma desde el primer paso pendiente. No hace falta reiniciar.
