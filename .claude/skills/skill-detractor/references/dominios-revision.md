# Dominios de Revision — 8 Obligatorios

El detractor revisa en exactamente 8 dominios para ejercicios ICFES:

## 1. Codigo R-exams

- Coherencia de codigo R-exams
- Uso correcto de exshuffle, exsolution, extype
- Distractores basados en errores conceptuales (no aleatorios)
- Metadatos ICFES completos (6 dimensiones)
- Pool de errores con funciones calcula()

Fuentes: Documentacion R-exams (Nivel 1), Ejemplos funcionales locales (Nivel 1), Vignettes CRAN.

## 2. Pedagogico

- Aplicacion de Progressive Disclosure
- Estructura metacognitiva correcta
- Reflexiones pedagogicas apropiadas
- Nivel de dificultad coherente con metadatos
- Distractores diagnosticables

Fuentes: Marco Conceptual ICFES 2026 (N1), Dunlosky et al. 2013 (N1), Schraw & Dennison 1994 (N1), Anderson & Krathwohl 2001 (N1).

## 3. Visual/Grafica

- Coherencia visual-texto (grafico vs enunciado)
- Etiquetas legibles y correctas
- Escalas y proporciones apropiadas
- Compatibilidad con 4 formatos de salida

Fuentes: Estandares visuales ICFES (N1), Documentacion TikZ/pgfplots (N1).

## 4. Gramatica/Ortografia

- Tildes en palabras frecuentes
- Gramatica espanola correcta
- Redaccion estilo ICFES
- Terminologia matematica apropiada

Fuentes: RAE (N1), `.claude/rules/ortografia-espanol.md` (N1).

## 5. Coherencia Matematica

- Formulas y ecuaciones correctas
- Calculos verificables paso a paso
- Proporciones y escalas correctas
- Respuesta correcta matematicamente valida
- Distractores plausibles pero incorrectos (no absurdos)
- Consistencia entre datos del enunciado y opciones
- Variables sin NA/NaN/Inf

Fuentes: Definiciones matematicas estandar (N1), Wolfram Alpha (N1), `.claude/scripts/validar_coherencia_matematica.R` (N1).

## 6. ICFES Metacognitivo

- Aplicacion de Progressive Disclosure (4+ partes en CLOZE)
- Pool de errores conceptuales con codigos y funciones `calcula()`
- Metadatos cognitivos completos (DOK >= 2, Bloom, SOLO)
- Seccion Solution con 6 subsecciones obligatorias:
  1. Analisis del error
  2. Procedimiento correcto
  3. Propiedades del concepto
  4. Caso especifico
  5. Reflexion metacognitiva
  6. Estrategia para evitar el error
- Antipatron detectado: ejercicio puramente procedimental
- Distractores basados en errores conceptuales reales

Fuentes: `.claude/rules/ejercicios-metacognitivos.md` (N1), Marco Conceptual ICFES 2026 (N1).

## 7. Testing y Regresion

- Tests unitarios para componentes criticos
- Cobertura >= 100% para scripts de validacion
- Tests de diversidad (200+ versiones unicas)
- Sin regresiones en funcionalidad existente
- Git hooks nativos configurados (pre-commit, pre-push)
- CI/CD activo y pasando

Fuentes: `tests/testthat/` (N1), `.claude/rules/testing-obligatorio.md` (N1), `.git/hooks/` (N1), `.github/workflows/ci-testing.yml` (N1).

## 8. Coherencia Semantica (Nivel 4)

- Campo `precondicion` declarado en errores con restricciones — Capa A
- Descripciones de errores coherentes con datos generados — 21 keywords, Capa B
- `calcula()` produce valor diferente al correcto — Capa C
- Errores ERR_SEM_A/B/C (bloqueantes) y WARN_SEM_B (bugs latentes)
- Patron de seleccion generico basado en `precondicion` (no filtros hardcoded)
- `calcula()` determinista — sin sample()/runif()/rnorm() — Capa D

Fuentes: `.claude/scripts/validar_coherencia_matematica.R` — `REGLAS_SEMANTICAS_KEYWORDS` (N1), `.claude/rules/ejercicios-metacognitivos.md` (N1), `tests/testthat/test_validacion_semantica.R` (N1).
