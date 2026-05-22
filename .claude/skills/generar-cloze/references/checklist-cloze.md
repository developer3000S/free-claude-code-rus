# Checklist CLOZE Metacognitivo

## PASO 10: Checklist pre-promocion

- [ ] Minimo 4 partes con Progressive Disclosure (Identificar → Calcular → Evaluar → Transferir)
- [ ] Pool de errores conceptuales con codigos (minimo 4, estructura con calcula())
- [ ] Pool de afirmaciones verdaderas (minimo 6)
- [ ] Pool de afirmaciones falsas (minimo 6, basadas en errores conceptuales reales)
- [ ] Pool de enunciados V/F (minimo 4)
- [ ] Respuesta erronea ≠ respuesta correcta (test_that confirma, guardia is.na() incluida)
- [ ] Solucion incluye analisis del error (descripcion_larga + causa_raiz)
- [ ] Solucion incluye reflexion metacognitiva (del pool de reflexiones)
- [ ] Metadatos exclozetype, exsolution, extol consistentes y separados por `|`
- [ ] Numero de tipos en exclozetype = numero de partes = numero de ##ANSWERi##
- [ ] Metadatos DOK (>= 3), Bloom (Evaluar), SOLO presentes
- [ ] Test de diversidad > 250 versiones unicas de 300 intentos

## Condiciones criticas

### Pre-generacion

- Analisis ICFES completado con tipo = cloze
- **Estructura Progressive Disclosure planificada (4 partes minimas)**
- **Pool de errores conceptuales definido (minimo 4)**
- **Pool de afirmaciones V/F definido (minimo 6+6)**
- **Pool de enunciados V/F definido (minimo 4)**
- Ejemplo funcional CLOZE metacognitivo identificado y leido
- Nomenclatura calculada (incluye "metacognitivo" y "cloze")
- Carpeta destino creada en `02-En-Desarrollo/`

### Durante generacion

- Funcion `generar_datos()` con aleatorizacion completa
- **Pool de errores con funciones `calcula` deterministicas**
- **Pool de reflexiones metacognitivas** (minimo 4)
- GAPS numerados secuencialmente (##ANSWER1## ... ##ANSWER4##)
- Cada ##ANSWERi## INMEDIATAMENTE despues de su pregunta correspondiente
- exclozetype con tipos por gap separados por `|`
- exsolution con respuestas por gap separadas por `|`
- extol con tolerancias por gap separadas por `|`
- **Metadatos cognitivos: DOK, Bloom, SOLO**
- Formato espanol en todos los numeros
- Guardia `is.na()` antes de comparacion con resultado de `calcula()`

### Post-generacion

- HTML: OK
- PDF: OK
- DOCX: OK
- NOPS: Puede fallar (ESPERADO si hay gaps num/string — no es error)
- **Respuesta erronea diferente de correcta**
- Test de diversidad > 250 versiones unicas
- **Solucion incluye todas las subsecciones obligatorias** (5 secciones)
- Ciclo de validacion completo (FASE 1 → 2A → 2B → 2C → 3)

NO terminar con errores inesperados (error de NOPS con num/string es esperado, no bloquea).

## Metadatos OBLIGATORIOS CLOZE Metacognitivo

```yaml
exname: [nombre]_metacognitivo_argumentacion_n3_cloze_v1
extype: cloze
exclozetype: schoice|num|mchoice|schoice
exsolution: [sol_p1]|[sol_p2]|[sol_p3]|[sol_p4]
exshuffle: TRUE
extol: 0|0.01|0|0

exextra[Type]: CLOZE
exextra[Competencia]: Argumentacion
exextra[Componente]: [Aleatorio|Numerico-Variacional|Geometrico-Metrico]
exextra[Afirmacion]: [descripcion especifica]
exextra[Evidencia]: [descripcion especifica]
exextra[Nivel]: 3

exextra[DOK]: 3
exextra[Bloom]: Evaluar
exextra[SOLO]: Relacional-Extendido
exextra[TipoMetacognicion]: progressive_disclosure
```
