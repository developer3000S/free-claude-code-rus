# Estructura Progressive Disclosure — CLOZE

## PASO 0: Planificacion obligatoria de 4 partes minimas

Antes de cualquier otra accion, definir la secuencia cognitiva:

```
Parte 1 (schoice): IDENTIFICAR el error conceptual
    ↓ Bloom: Analizar | DOK: 3
Parte 2 (num): CALCULAR la respuesta correcta
    ↓ Bloom: Aplicar | DOK: 2
Parte 3 (mchoice): EVALUAR afirmaciones sobre el concepto
    ↓ Bloom: Evaluar | DOK: 3
Parte 4 (schoice V/F): TRANSFERIR a caso especifico
    | Bloom: Analizar/Evaluar | DOK: 3
```

La secuencia DEBE ir de menor a mayor nivel cognitivo. No es valido repetir el mismo nivel.

## Tipos de gap disponibles

| Tipo | Cuando usar | Ejemplo |
|------|-------------|---------|
| schoice | Seleccion unica (errores, V/F) | A, B, C, D |
| mchoice | Seleccion multiple (afirmaciones verdaderas) | Checkbox multiple |
| num | Respuesta numerica exacta | 42.5 |
| string | Texto libre corto | "exponencial" |

## Estructura del Question (plantilla obligatoria)

```markdown
Question
========

[Contexto realista con datos dinamicos — plantilla narrativa del pool]

[Tabla o grafico con datos]

[Descripcion del error cometido por otro estudiante]

**Parte 1.** ¿Cual error conceptual cometio [estudiante]?

##ANSWER1##

**Parte 2.** ¿Cual es el valor correcto?

##ANSWER2##

**Parte 3.** Seleccione las afirmaciones correctas sobre [concepto].

##ANSWER3##

**Parte 4.** Determine si es verdadera o falsa: [enunciado especifico]

##ANSWER4##
```

**CRITICO**: Cada `##ANSWERi##` va INMEDIATAMENTE despues de la pregunta de su parte,
NO al final de todas las partes. Ver regla #12 en `.claude/rules/codigo-rmd.md`.

## Metadatos CLOZE obligatorios

```yaml
extype: cloze
exclozetype: schoice|num|mchoice|schoice
exsolution: [sol_p1]|[sol_p2]|[sol_p3]|[sol_p4]
exshuffle: TRUE
extol: 0|0.01|0|0

exextra[DOK]: 3
exextra[Bloom]: Evaluar
exextra[SOLO]: Relacional-Extendido
exextra[TipoMetacognicion]: progressive_disclosure
```

Nota: `exshuffle: FALSE` solo aplica a SCHOICE con PNGs graficos — ver `.claude/rules/graficos-como-opciones.md`.
