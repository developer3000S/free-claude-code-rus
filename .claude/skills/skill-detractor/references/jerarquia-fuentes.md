# Jerarquia de Fuentes de Verdad

## Principio

No todas las fuentes tienen el mismo peso. Una objecion basada en documentacion oficial tiene mas autoridad que una basada en un blog post. Esta jerarquia define que fuentes son validas para objetar y con que nivel de confianza.

---

## Nivel 1: Autoritativo (Peso: 100%)

**Definicion**: Fuentes primarias, oficiales, definitivas.

**Caracteristicas**:

- Escritas por creadores/mantenedores del proyecto
- Versionadas junto con el codigo
- Actualizadas con cada release

**Ejemplos**:

| Dominio | Fuentes Nivel 1 |
|---------|-----------------|
| Flutter | flutter.dev/docs, api.flutter.dev |
| Dart | dart.dev/guides, Effective Dart |
| Supabase | supabase.com/docs, github.com/supabase RFCs |
| R-exams | cran.r-project.org/package=exams, vignettes |
| Seguridad | OWASP Top 10, CWE official |
| Ciencia | Papers peer-reviewed (Dunlosky, Hattie) |

**Uso en objeciones**:

```markdown
**Por que** (Fuente Nivel 1):
> "Avoid using BuildContext across async gaps"
> — [Flutter Docs: BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)
```

**Regla**: Objeciones con Nivel 1 son **definitivas**. No requieren corroboracion.

---

## Nivel 2: Fuerte (Peso: 80%)

**Definicion**: Fuentes secundarias altamente confiables.

**Caracteristicas**:

- Escritas por expertos reconocidos
- Basadas en datos o benchmarks
- Ampliamente citadas en la comunidad

**Ejemplos**:

| Dominio | Fuentes Nivel 2 |
|---------|-----------------|
| Flutter | flutter.dev/perf, DevTools profiling results |
| Arquitectura | Martin Fowler, Uncle Bob (libros principales) |
| Testing | Kent Beck, Michael Feathers |
| Pedagogia | Meta-analisis (Visible Learning, IES reports) |
| Performance | Benchmarks reproducibles con metodologia |

**Uso en objeciones**:

```markdown
**Por que** (Fuente Nivel 2):
> "Effect size d=0.62 for retrieval practice across 118 studies"
> — Dunlosky et al. (2013), Psychological Science in the Public Interest
```

**Regla**: Objeciones con Nivel 2 son **muy fuertes**. Pueden objetarse solo con Nivel 1.

---

## Nivel 3: Moderado (Peso: 50%)

**Definicion**: Fuentes respetables pero no definitivas.

**Caracteristicas**:

- Escritas por practitioners experimentados
- Basadas en experiencia documentada
- Consenso de comunidad

**Ejemplos**:

| Dominio | Fuentes Nivel 3 |
|---------|-----------------|
| Flutter | Blog posts de GDEs, Medium de equipos conocidos |
| General | Stack Overflow (respuestas >50 upvotes) |
| Arquitectura | Charlas de conferencias (DartConf, Google I/O) |
| Patrones | Articulos con ejemplos de codigo funcional |

**Uso en objeciones**:

```markdown
**Por que** (Fuente Nivel 3 - requiere verificacion):
> "We saw 40% reduction in build times using this approach"
> — [Very Good Ventures Blog](https://verygood.ventures/blog/...)

⚠️ Nota: Experiencia especifica, puede no generalizar.
```

**Regla**: Objeciones con Nivel 3 requieren **corroboracion** con otra fuente Nivel 2-3, o deben marcarse como "sugerencia" no "objecion".

---

## Nivel 4: Debil (Peso: 20%)

**Definicion**: Opiniones, preferencias, experiencia anecdotica.

**Caracteristicas**:

- Sin datos de respaldo
- Basadas en preferencia personal
- "Asi lo hacemos en mi equipo"

**Ejemplos**:

| Tipo | Ejemplos |
|------|----------|
| Opiniones | "Prefiero X sobre Y" |
| Estilo | "camelCase vs snake_case" |
| Anecdotas | "Una vez me paso que..." |
| Tradicion | "Siempre lo hemos hecho asi" |

**Uso en objeciones**: **PROHIBIDO** como base de objecion.

```markdown
# ❌ INVALIDO
**Por que** (Fuente Nivel 4):
> "I think this pattern is ugly"
> — Random dev on Twitter

# El detractor NO debe emitir esta objecion
```

**Regla**: Nivel 4 **nunca es suficiente** para objetar. Puede usarse solo como contexto adicional.

---

## Casos Especiales

### Conflicto entre Niveles

Si Nivel 2 contradice Nivel 1:

```
Nivel 1 gana SIEMPRE.
Documentar la discrepancia pero seguir Nivel 1.
```

### Documentacion Desactualizada

Si la documentacion oficial (Nivel 1) no cubre un caso:

```
Escalar a Nivel 2.
Marcar como "pendiente de documentacion oficial".
```

### Multiples Fuentes Nivel 3

Tres fuentes Nivel 3 independientes que coinciden:

```
Pueden tratarse como equivalente a Nivel 2.
Documentar las tres fuentes.
```

---

## Fuentes por Dominio (Quick Reference)

### Flutter/Dart

```
Nivel 1:
  - flutter.dev/docs
  - api.flutter.dev
  - dart.dev/guides
  - pub.dev (README oficial del paquete)

Nivel 2:
  - flutter.dev/perf
  - Effective Dart
  - Flutter DevTools results
```

### Supabase

```
Nivel 1:
  - supabase.com/docs
  - github.com/supabase (READMEs, RFCs)
  - PostgREST docs (para API)

Nivel 2:
  - Supabase blog (posts tecnicos)
  - Discord oficial (respuestas de team)
```

### R-exams / ICFES

```
Nivel 1:
  - CRAN vignettes exams
  - exams.R-Forge.R-project.org
  - Marco Conceptual ICFES (documento oficial)

Nivel 2:
  - Papers de Zeileis et al.
  - Dunlosky et al. (2013)
  - Hattie (Visible Learning)
```

### Seguridad

```
Nivel 1:
  - OWASP Top 10
  - CWE (Common Weakness Enumeration)
  - CVE database

Nivel 2:
  - NIST guidelines
  - SANS reports
```

---

## Template para Citar Fuentes

```markdown
**Por que** (Fuente Nivel [1-4]):
> "[Cita textual o parafrasis precisa]"
> — [Nombre Fuente](URL) | [Fecha si relevante]
```

**Ejemplos bien formados**:

```markdown
# Nivel 1
**Por que** (Fuente Nivel 1):
> "Use const constructors whenever possible"
> — [Effective Dart: Usage](https://dart.dev/effective-dart/usage)

# Nivel 2
**Por que** (Fuente Nivel 2):
> "RLS policies should be tested in staging before production"
> — [Supabase Security Best Practices](https://supabase.com/docs/guides/auth/row-level-security)

# Nivel 3 (con advertencia)
**Por que** (Fuente Nivel 3 - verificar):
> "We reduced cold start by 200ms with this optimization"
> — [Blog Post](https://example.com) | Experiencia especifica
```

---

**Version**: 1.0.0
**Fecha**: 2026-02-06
