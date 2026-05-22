# Plantilla — Retrospectiva de Sesión

> **Cómo usar:** copia este archivo a `.claude/docs/casos-resueltos/<YYYY-MM-DD>-<tema>.md`, completa los placeholders entre `[CORCHETES]` y borra esta línea de instrucciones. Después agrega una entrada al índice `.claude/docs/INDICE_LECCIONES.md` §5.

---

# Retrospectiva: [Título corto del incidente o sesión]

**Fecha:** [YYYY-MM-DD]
**Duración aproximada:** [HH:MM]
**Modelo principal:** [Opus 4.7 | Sonnet 4.6 | Haiku 4.5 | otro]
**Tipo:** [Bug fix | Feature | Refactor | Auditoría | Migración | Recuperación]

## TL;DR (1-3 líneas)

[Qué pasó, qué se decidió, qué cambió en el repo. Máximo 3 líneas. Si necesitas más, hay algo mal en el alcance.]

---

## 1. Contexto

[Qué estabas intentando hacer cuando apareció el problema. Qué archivo/comando/agente disparó el incidente. Estado del repo (rama, commit, working tree limpio o no).]

## 2. Síntoma

[Mensaje de error literal, comportamiento inesperado, o resultado divergente. Si aplica, incluir exit code, captura de la consola, o ruta del log.]

```
[Salida literal del error o comando]
```

## 3. Causa raíz

[Explicación técnica precisa de por qué pasó. Si tomó varios intentos identificarla, listar las hipótesis falsas con un guión "rechazada porque…". No mezclar con la solución.]

### Hipótesis evaluadas

| Hipótesis | Validada | Razón |
|---|---|---|
| [H1] | ❌ | [Por qué se descartó] |
| [H2] | ✅ | [Evidencia que la confirmó] |

## 4. Solución aplicada

### Pasos ejecutados

1. [Paso 1, con comando exacto]
   ```bash
   [comando]
   ```
2. [Paso 2…]
3. [Paso N]

### Archivos modificados

| Archivo | Tipo de cambio | Líneas | Commit |
|---|---|---|---|
| [path] | [agregar | editar | borrar] | [+N -M] | [hash] |

### Verificación

```bash
[Comando que verifica que el fix funciona]
# Salida esperada: [...]
```

## 5. Decisiones tomadas

[Si la sesión tomó decisiones que afectan el futuro del repo, listarlas aquí. Si la decisión es lo suficientemente grande, **abrir un ADR** en `.claude/docs/ADR/00X-<titulo>.md` y enlazar desde aquí.]

| Decisión | Rationale | ADR |
|---|---|---|
| [Decisión 1] | [Por qué] | [ADR-00X o "no requiere"] |

## 6. Lecciones aprendidas

### Qué funcionó bien

- [Práctica 1 que valió la pena repetir]
- [Práctica 2]

### Qué no funcionó

- [Práctica 1 a evitar en el futuro]
- [Por qué falló]

### Qué haría diferente

- [Cambio de aproximación 1]

## 7. Garantías de no-regresión

[Cómo se evita que esto vuelva a pasar. Test agregado, regla codificada, hook activado, doc de referencia.]

| Mecanismo | Archivo | Cubre |
|---|---|---|
| Test de regresión | `tests/testthat/test_<X>.R` | [escenario 1] |
| Regla en `.claude/rules/` | `<nombre>.md` | [comportamiento esperado] |
| Patrón documentado | `patrones-errores-conocidos.md` §Error N | [síntoma → fix] |

## 8. Referencias cruzadas

- Reglas afectadas: `.claude/rules/[nombre].md`
- Tests asociados: `tests/testthat/test_[nombre].R`
- Documentos relacionados: `.claude/docs/[ruta].md`
- Commits: `[hash1]`, `[hash2]`
- ADR: `[ADR-00X]` (si aplica)
- Conversación con Claude (si vale la pena guardar): `[ruta o id]`

## 9. Pendientes derivados

[Tareas que esta sesión dejó pendientes y que conviene hacer después.]

- [ ] [Pendiente 1] — owner: [tú | otro]
- [ ] [Pendiente 2]

---

**Última actualización:** [YYYY-MM-DD]
**Estado:** [Cerrado | En seguimiento | Revisitar el YYYY-MM-DD]
