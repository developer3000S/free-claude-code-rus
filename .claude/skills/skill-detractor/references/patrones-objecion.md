# Patrones de Objecion

## Estructura Obligatoria

Toda objecion DEBE seguir este formato exacto:

```markdown
## Objecion: [Titulo descriptivo y conciso]

**Que se cuestiona**: [Decision/codigo/afirmacion especifica]

**Por que** (Fuente Nivel X):
> "[Cita textual o parafrasis precisa]"
> — [Fuente con enlace]

**Riesgo concreto**: [Consecuencia cuantificada si es posible]

**Alternativa propuesta**:
[Codigo o solucion implementable]

**Veredicto**: MANTENER | MODIFICAR | REEMPLAZAR
```

---

## Patrones por Tipo de Problema

### Patron 1: Seguridad

```markdown
## Objecion: Token JWT almacenado en SharedPreferences sin encriptacion

**Que se cuestiona**:
```dart
await prefs.setString('auth_token', token);
```

**Por que** (Fuente Nivel 1):
> "Sensitive data like tokens should be stored using flutter_secure_storage
> which uses Keychain on iOS and KeyStore on Android"
> — [Flutter Security Best Practices](https://docs.flutter.dev/security)

**Riesgo concreto**:
En dispositivos rooteados/jailbroken, SharedPreferences es un archivo XML
plano legible. Un atacante puede extraer el token y suplantar al usuario.
CVSS Score estimado: 7.5 (Alto)

**Alternativa propuesta**:
```dart
final storage = FlutterSecureStorage();
await storage.write(key: 'auth_token', value: token);
```

**Veredicto**: REEMPLAZAR
```

### Patron 2: Rendimiento

```markdown
## Objecion: Query N+1 en listado de productos

**Que se cuestiona**:
```dart
final products = await supabase.from('products').select();
for (final p in products) {
  final category = await supabase.from('categories').select().eq('id', p['category_id']);
}
```

**Por que** (Fuente Nivel 1):
> "Use foreign key joins to fetch related data in a single query"
> — [Supabase Docs: Querying Joins](https://supabase.com/docs/guides/database/joins)

**Riesgo concreto**:
Con 100 productos = 101 queries. Latencia estimada: 100 * 50ms = 5 segundos.
Con join: 1 query, ~50ms total. Factor 100x de diferencia.

**Alternativa propuesta**:
```dart
final products = await supabase
  .from('products')
  .select('*, categories(name, slug)');
```

**Veredicto**: REEMPLAZAR
```

### Patron 3: Arquitectura

```markdown
## Objecion: Logica de negocio en Widget

**Que se cuestiona**:
```dart
class ProductScreen extends StatefulWidget {
  Future<void> _calculateDiscount() {
    // 50 lineas de logica de precios
  }
}
```

**Por que** (Fuente Nivel 2):
> "Widgets should be concerned only with building UI.
> Business logic belongs in the domain layer."
> — Clean Architecture, Robert C. Martin

**Riesgo concreto**:
- Imposible de testear unitariamente (requiere widget test)
- Duplicacion cuando otra pantalla necesite la misma logica
- Violacion de Single Responsibility Principle

**Alternativa propuesta**:
```dart
// domain/services/pricing_service.dart
class PricingService {
  double calculateDiscount(Product product, User user) {
    // Logica extraida, testeable
  }
}

// presentation/screens/product_screen.dart
class ProductScreen extends StatelessWidget {
  final PricingService _pricing;
  // Widget solo construye UI
}
```

**Veredicto**: MODIFICAR
```

### Patron 4: Pedagogia (ICFES)

```markdown
## Objecion: Distractores generados aleatoriamente sin base conceptual

**Que se cuestiona**:
```r
distractores <- respuesta_correcta + sample(-10:10, 3)
```

**Por que** (Fuente Nivel 2):
> "Effective distractors should represent common misconceptions
> or procedural errors, not random values"
> — Haladyna et al. (2002), Applied Measurement in Education

**Riesgo concreto**:
- Distractores no diagnostican errores conceptuales
- Estudiante puede descartarlos por "no tener sentido"
- Reduce validez del item (discriminacion baja)

**Alternativa propuesta**:
```r
errores_conceptuales <- list(
  list(
    codigo = "EST-MTC-01",
    nombre = "Confusion promedio-mediana",
    calcula = function(datos) median(datos)  # En vez de mean
  ),
  list(
    codigo = "EST-MTC-02",
    nombre = "Olvida excluir valor",
    calcula = function(datos) mean(datos[-length(datos)])
  )
)

distractores <- sapply(errores_conceptuales, function(e) e$calcula(datos))
```

**Veredicto**: REEMPLAZAR
```

### Patron 5: Mantenibilidad

```markdown
## Objecion: Magic numbers sin constantes

**Que se cuestiona**:
```dart
if (user.points > 1000) {
  applyDiscount(0.15);
}
```

**Por que** (Fuente Nivel 1):
> "Avoid magic numbers. Use named constants to make code self-documenting"
> — [Effective Dart: Style](https://dart.dev/effective-dart/style)

**Riesgo concreto**:
- "1000" aparece en 5 lugares del codigo
- Cambiar el umbral requiere buscar todos los lugares
- No es claro que representa 0.15 (15%? ratio?)

**Alternativa propuesta**:
```dart
class LoyaltyTiers {
  static const int goldThreshold = 1000;
  static const double goldDiscount = 0.15;
}

if (user.points > LoyaltyTiers.goldThreshold) {
  applyDiscount(LoyaltyTiers.goldDiscount);
}
```

**Veredicto**: MODIFICAR
```

---

## Patrones de Veredicto

### MANTENER

Usar cuando:

- El riesgo es bajo y aceptable
- El costo de cambio supera el beneficio
- Es una decision consciente documentada

```markdown
**Veredicto**: MANTENER

**Justificacion**: Aunque tecnicamente suboptimo, el impacto es minimo
(<5% de usuarios afectados) y el refactor requeriria cambios en 15 archivos.
Documentar como deuda tecnica para futura iteracion.
```

### MODIFICAR

Usar cuando:

- Se necesita ajuste puntual
- No requiere rediseno
- Puede hacerse incrementalmente

```markdown
**Veredicto**: MODIFICAR

**Cambio requerido**: Extraer constantes, agregar null check,
renombrar variable. Estimado: 15 minutos.
```

### REEMPLAZAR

Usar cuando:

- Problema fundamental de diseno
- Seguridad comprometida
- Rendimiento inaceptable

```markdown
**Veredicto**: REEMPLAZAR

**Alcance**: Requiere redisenar el modulo de autenticacion.
Crear ticket separado, no es hotfix.
```

---

## Anti-patrones de Objecion

### Invalido: Sin fuente

```markdown
# ❌ INVALIDO
## Objecion: Este codigo es feo

**Por que**: Me parece que no es elegante.

# Falta fuente verificable
```

### Invalido: Sin alternativa

```markdown
# ❌ INVALIDO
## Objecion: No deberian usar este patron

**Alternativa propuesta**: No usar este patron.

# "No hacer X" no es alternativa, es repetir la objecion
```

### Invalido: Estilistico

```markdown
# ❌ INVALIDO
## Objecion: Usan tabs en vez de spaces

# Preferencia de estilo, no problema real
```

### Invalido: Severidad inflada

```markdown
# ❌ INVALIDO
## Objecion: Variable mal nombrada

**Riesgo concreto**: El proyecto va a fallar completamente.

# Severidad no corresponde al problema
```

---

## Plantillas Rapidas

### Seguridad

```markdown
## Objecion: [Vulnerabilidad]
**Que se cuestiona**: [Codigo vulnerable]
**Por que** (Fuente Nivel 1): [OWASP/CWE]
**Riesgo**: [CVSS o impacto]
**Alternativa**: [Codigo seguro]
**Veredicto**: REEMPLAZAR
```

### Rendimiento

```markdown
## Objecion: [Bottleneck]
**Que se cuestiona**: [Codigo lento]
**Por que** (Fuente Nivel 1-2): [Benchmark/Docs]
**Riesgo**: [Latencia/memoria cuantificada]
**Alternativa**: [Codigo optimizado]
**Veredicto**: MODIFICAR|REEMPLAZAR
```

### Arquitectura

```markdown
## Objecion: [Violacion principio]
**Que se cuestiona**: [Estructura problematica]
**Por que** (Fuente Nivel 2): [Clean/SOLID]
**Riesgo**: [Deuda tecnica/testabilidad]
**Alternativa**: [Estructura correcta]
**Veredicto**: MODIFICAR
```

---

**Version**: 1.0.0
**Fecha**: 2026-02-06
