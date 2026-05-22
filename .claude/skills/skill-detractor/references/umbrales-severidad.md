# Umbrales de Severidad

## Proposito

Evitar paralisis por analisis. El detractor solo levanta banderas cuando el problema supera un umbral configurable. Problemas menores se ignoran o se agrupan en seccion "Notas menores".

---

## Niveles de Severidad

### Critica (4)

**Definicion**: Problema que causa dano inmediato o irreversible.

**Criterios** (cualquiera activa):

- Vulnerabilidad de seguridad explotable
- Perdida de datos del usuario
- Crash en flujo principal
- Exposicion de credenciales/tokens
- Violacion de privacidad (GDPR, etc.)

**Ejemplos**:

| Problema | Por que es critico |
|----------|-------------------|
| SQL injection | Acceso no autorizado a BD |
| Token en logs | Credenciales expuestas |
| Sin validacion de input | XSS/injection posible |
| Backup sin encriptar | Datos sensibles legibles |

**Accion**: Detener desarrollo. Corregir inmediatamente.

### Alta (3)

**Definicion**: Problema serio que afecta funcionalidad o experiencia.

**Criterios**:

- Rendimiento inaceptable (>3s en operacion comun)
- UX rota en flujo principal
- Inconsistencia de datos probable
- Bug reproducible en casos normales
- Dependencia con vulnerabilidad conocida

**Ejemplos**:

| Problema | Por que es alto |
|----------|-----------------|
| N+1 queries (100+ items) | 5+ segundos de carga |
| Sin manejo de errores en API | App crashea silenciosamente |
| Race condition en checkout | Cobros duplicados posibles |
| Paquete con CVE activo | Vulnerabilidad heredada |

**Accion**: Priorizar en sprint actual. No deployar sin fix.

### Media (2)

**Definicion**: Problema que afecta mantenibilidad o calidad.

**Criterios**:

- Deuda tecnica significativa
- Violacion de principios SOLID
- Codigo no testeable
- Duplicacion >50 lineas
- Documentacion faltante en API publica

**Ejemplos**:

| Problema | Por que es medio |
|----------|------------------|
| Logica en Widget | No testeable unitariamente |
| Magic numbers | Mantenimiento dificil |
| Sin types en TypeScript | Bugs silenciosos |
| Funcion >100 lineas | Dificil de entender |

**Accion**: Agregar a backlog. Corregir en proximo refactor.

### Baja (1)

**Definicion**: Problema menor, preferencia o estilo.

**Criterios**:

- Naming conventions
- Formato de codigo
- Orden de imports
- Comentarios faltantes (no en API)
- Preferencias estilisticas

**Ejemplos**:

| Problema | Por que es bajo |
|----------|-----------------|
| camelCase vs snake_case | Solo estilo |
| Linea >80 caracteres | Preferencia |
| Import no usado | Linter lo detecta |
| Variable `x` en vez de `index` | Menor claridad |

**Accion**: Ignorar en detractor. Delegar a linter/formatter.

---

## Configuracion de Umbrales

### Defaults del Sistema

```yaml
# .claude/detractor-config.yaml (defaults)
umbrales:
  severidad_minima: media      # Solo media, alta, critica
  fuente_minima: 2             # Nivel 1-2 requerido
  max_objeciones_inline: 3     # Limite modo inline
  ignorar_estilistico: true    # Nivel 1 (bajo) ignorado
  agrupar_menores: true        # Bajas en seccion aparte
```

### Configuracion Estricta (Seguridad)

```yaml
# Para proyectos con datos sensibles
umbrales:
  severidad_minima: media
  fuente_minima: 1             # Solo docs oficiales
  max_objeciones_inline: 5
  ignorar_estilistico: true
  dominios_prioritarios:
    - seguridad
    - privacidad
```

### Configuracion Relajada (Prototipo)

```yaml
# Para MVPs o pruebas de concepto
umbrales:
  severidad_minima: alta       # Solo alta y critica
  fuente_minima: 2
  max_objeciones_inline: 2
  ignorar_estilistico: true
  ignorar_arquitectura: true   # Permitir shortcuts
```

### Configuracion Auditoria Completa

```yaml
# Para revisiones exhaustivas
umbrales:
  severidad_minima: baja       # Todo incluido
  fuente_minima: 3             # Permitir Nivel 3
  max_objeciones_inline: 10
  ignorar_estilistico: false   # Incluir estilo
  agrupar_menores: true
```

---

## Matriz de Decision

```
┌─────────────────────────────────────────────────────────────┐
│                    SEVERIDAD DEL PROBLEMA                    │
├──────────┬──────────┬──────────┬──────────┬─────────────────┤
│          │ Critica  │   Alta   │  Media   │     Baja        │
├──────────┼──────────┼──────────┼──────────┼─────────────────┤
│ Fuente 1 │ OBJETAR  │ OBJETAR  │ OBJETAR  │ Ignorar/Nota    │
│ Fuente 2 │ OBJETAR  │ OBJETAR  │ OBJETAR  │ Ignorar         │
│ Fuente 3 │ OBJETAR  │ OBJETAR  │ Sugerir  │ Ignorar         │
│ Fuente 4 │ Escalar  │ Ignorar  │ Ignorar  │ Ignorar         │
└──────────┴──────────┴──────────┴──────────┴─────────────────┘

Leyenda:
- OBJETAR: Incluir en reporte con formato completo
- Sugerir: Mencionar sin formato de objecion formal
- Ignorar: No incluir en reporte
- Nota: Agrupar en "Notas menores" al final
- Escalar: Buscar fuente mejor antes de objetar
```

---

## Reglas de Aplicacion

### Regla 1: Severidad Critica Siempre Pasa

Sin importar configuracion, severidad critica SIEMPRE se reporta.

```python
if severidad == "critica":
    reportar()  # Sin excepciones
```

### Regla 2: Fuente Minima Requerida

No objetar si la fuente no alcanza el nivel configurado.

```python
if fuente.nivel < config.fuente_minima:
    if severidad < "alta":
        ignorar()
    else:
        buscar_fuente_mejor()
```

### Regla 3: Limite de Objeciones Inline

En modo inline, respetar limite configurado.

```python
if modo == "inline" and len(objeciones) >= config.max_inline:
    priorizar_por_severidad()
    truncar()
```

### Regla 4: Agrupar Menores

Si `agrupar_menores: true`, severidad baja va en seccion aparte.

```markdown
## Notas Menores (no requieren accion inmediata)

- Variable `x` podria llamarse `index` (claridad)
- Import no usado en linea 45
- Comentario desactualizado en header
```

---

## Escalamiento de Severidad

### Por Contexto

Un mismo problema puede tener diferente severidad segun contexto:

| Problema | Contexto | Severidad |
|----------|----------|-----------|
| Sin validacion email | Formulario interno | Media |
| Sin validacion email | Registro publico | Alta |
| Sin validacion email | Financiero | Critica |

### Por Frecuencia

Multiples instancias del mismo problema escalan:

| Instancias | Escalamiento |
|------------|--------------|
| 1-2 | Mantener severidad original |
| 3-5 | +1 nivel (Media → Alta) |
| 6+ | +2 niveles, marcar como "sistemico" |

### Por Impacto

Considerar alcance del problema:

| Alcance | Factor |
|---------|--------|
| Afecta 1 pantalla | x1 |
| Afecta flujo completo | x1.5 (Media → Alta) |
| Afecta toda la app | x2 (Media → Critica) |

---

## Ejemplos de Clasificacion

### Ejemplo 1: SharedPreferences para token

```
Problema: Token JWT en SharedPreferences
Severidad base: Alta (seguridad)
Contexto: App de finanzas personales
Escalamiento: +1 (datos sensibles)
Severidad final: CRITICA
```

### Ejemplo 2: Funcion larga

```
Problema: Funcion de 150 lineas
Severidad base: Media (mantenibilidad)
Contexto: Prototipo interno
Configuracion: ignorar_arquitectura: true
Resultado: IGNORAR
```

### Ejemplo 3: N+1 query

```
Problema: N+1 en listado
Severidad base: Alta (rendimiento)
Instancias: 1
Items afectados: 10 (paginado)
Latencia real: 500ms
Escalamiento: -1 (impacto menor al tipico)
Severidad final: MEDIA
```

---

## Reporte de Umbrales

Al inicio de cada auditoria, reportar configuracion:

```markdown
## Configuracion de Auditoria

| Parametro | Valor |
|-----------|-------|
| Severidad minima | Media |
| Fuente minima | Nivel 2 |
| Max objeciones inline | 3 |
| Ignorar estilistico | Si |

Objeciones que pasaron filtro: 5
Objeciones ignoradas por umbral: 12
```

---

**Version**: 1.0.0
**Fecha**: 2026-02-06
