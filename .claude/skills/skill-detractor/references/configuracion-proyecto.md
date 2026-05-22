# Configuracion del Proyecto — Detractor

## Archivo de configuracion opcional

Crear `.claude/detractor-config.yaml` para personalizar el comportamiento:

```yaml
# Umbrales personalizados (defaults mostrados)
severidad_minima: media        # Solo media, alta, critica
fuente_minima: 2               # Solo Nivel 1-2
max_objeciones_inline: 3       # Limite para modo inline

# Dominios prioritarios (todos activos por default)
dominios:
  - codigo_rexams
  - pedagogico
  - visual
  - gramatica
  - coherencia_matematica
  - icfes_metacognitivo
  - testing
  - coherencia_semantica

# Ignorar directorios/archivos
ignorar:
  - tests/
  - "*.generated.dart"

# Fuentes adicionales de verdad locales
fuentes_locales:
  - .claude/rules/
  - .claude/docs/
  - A-Produccion/Ejemplos-Funcionales-Rmd/
  - docs/arquitectura.md

# Bloqueos automaticos
bloqueos:
  critica: true                # Bloquear si hay objeciones criticas
  alta: true                   # Bloquear si hay objeciones altas
  media: false                 # Solo reportar, no bloquear
```

## Activacion automatica segun .claude/rules/detractor-obligatorio.md

```yaml
activacion:
  post_generacion: true        # Despues de /generar-schoice o /generar-cloze
  fase_2c: true                # En ciclo de validacion (FASE 2C)
  pre_promocion: true          # Antes de /promover-ejercicio
  post_validacion_pedagogico: true
```

## Significado de umbrales

| Nivel | Criterio | Accion |
|-------|----------|--------|
| Critica | Seguridad, perdida datos, crash, errores matematicos graves | Bloquear, corregir inmediatamente |
| Alta | Distractores invalidos, metadatos faltantes, rendimiento severo | Priorizar correccion |
| Media | Optimizaciones pedagogicas, deuda tecnica, mejoras menores | Agregar a backlog |
| Baja | Convenciones, estilo, naming | Ignorar (delegar a linter) |

## Regla: Solo objetar con fuentes Nivel 1-2

```
Nivel 1 (Autoritativo): Docs oficiales, RFCs, papers peer-reviewed
Nivel 2 (Fuerte): Best practices core teams, meta-analisis
Nivel 3 (Moderado): Blogs maintainers, consenso comunidad — requiere corroboracion
Nivel 4 (Debil): Opiniones, preferencias estilisticas — NUNCA suficiente
```

Ver detalle en [jerarquia-fuentes.md](jerarquia-fuentes.md).
