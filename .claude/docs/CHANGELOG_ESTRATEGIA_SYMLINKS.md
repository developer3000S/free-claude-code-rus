# Changelog: Estrategia de Symlinks en Ejemplos-Funcionales-Rmd/

## 📅 Fecha: 2026-02-07

## 🔄 Cambio de Estrategia

### Antes (v1.0)
- **Mecanismo**: Copias directas
- **Concepto**: "Instantáneas" estáticas de ejercicios validados
- **Sincronización**: Manual (copiar cuando se actualiza)

### Después (v2.0 - ACTUAL)
- **Mecanismo**: Symlinks bidireccionales (como SOURCES/)
- **Concepto**: Referencias dinámicas a ejercicios en producción
- **Sincronización**: Automática (editar en cualquier lugar se refleja en ambos)

---

## 🎯 Razones del Cambio

1. **Consistencia arquitectónica**: SOURCES/ ya usa symlinks exitosamente
2. **Sincronización automática**: Evita desincronización entre original y referencia
3. **Sin duplicación**: Ahorra espacio en disco
4. **Facilita mantenimiento**: Un cambio se refleja automáticamente en todos lados
5. **Ejercicios en producción son estables**: No cambian arbitrariamente

---

## 📋 Archivos Actualizados

### Documentación
- ✅ `.claude/docs/ESTRATEGIA_EJEMPLOS_FUNCIONALES.md`
  - Mecanismo: "Copias directas" → "Symlinks bidireccionales"
  - Tabla de diferencias actualizada
  - Workflow actualizado

- ✅ `A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/README.md`
  - Paso 3: "Copiar .Rmd" → "Crear Symlink"
  - Agregada nota sobre rutas relativas

- ✅ `A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/CATALOGO.md`
  - Paso 1: "Copiar .Rmd" → "Crear Symlink"
  - Agregada nota sobre rutas relativas

### Scripts
- ✅ `.claude/scripts/verificar_symlinks_ejemplos.sh` (NUEVO)
  - Verifica integridad de symlinks
  - Identifica symlinks rotos
  - Identifica archivos regulares legacy

---

## 🔗 Ejemplo de Symlink Creado

### Caso: Ejercicio de Raíz Cúbica y Empaquetamiento

**Archivos originales**:
```
A-Produccion/03-En-Produccion/05-Geometría/Pensamiento-Espacial/
  18-Volumen-Y-Raíz-Cúbica/raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1/
    ├── raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1.Rmd
    └── raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1_cloze.Rmd
```

**Symlinks creados**:
```
A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/
  ├── raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1.Rmd
  │   → ../05-Geometría/Pensamiento-Espacial/18-Volumen-Y-Raíz-Cúbica/.../...Rmd
  └── raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1_cloze.Rmd
      → ../05-Geometría/Pensamiento-Espacial/18-Volumen-Y-Raíz-Cúbica/.../..._cloze.Rmd
```

**Comandos ejecutados**:
```bash
cd A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/

ln -s "../05-Geometría/Pensamiento-Espacial/18-Volumen-Y-Raíz-Cúbica/raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1/raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1.Rmd" \
      "raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1.Rmd"

ln -s "../05-Geometría/Pensamiento-Espacial/18-Volumen-Y-Raíz-Cúbica/raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1/raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1_cloze.Rmd" \
      "raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1_cloze.Rmd"
```

---

## 📊 Estado Actual

### Symlinks activos
- ✅ `raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1.Rmd`
- ✅ `raiz_cubica_empaquetamiento_geometrico_metrico_formulacion_ejecucion_n2_v1_cloze.Rmd`

### Archivos regulares legacy
- ⚠️ `Ejemplo_00_numeros_triangulares_sucesion_argumentacion_n2_v1.Rmd`
- ⚠️ `Ejemplo_01.Rmd`
- ⚠️ `Ejemplo_02.Rmd`
- ⚠️ `Ejemplo_03.Rmd`
- ⚠️ `estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2.Rmd`
- ⚠️ `estadistica_diagramas_caja_interpretacion_representacion_Nivel2_v2_py.Rmd`
- ⚠️ `fracciones_reparto_premio_v1.Rmd`
- ⚠️ `mediana_aleatorio_argumentacion_n2_v1.Rmd`

**Nota**: Los archivos legacy pueden quedarse como están (no es obligatorio convertirlos).

---

## 🛠️ Cómo Crear Nuevos Symlinks

### Opción 1: Manual (Recomendado para casos específicos)

```bash
# 1. Ir al directorio de ejemplos funcionales
cd A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/

# 2. Crear symlink con ruta relativa
ln -s "../[Tema]/Pensamiento-XXX/[carpeta]/[archivo].Rmd" "[archivo].Rmd"

# 3. Verificar
ls -lah [archivo].Rmd

# 4. Probar que funciona
test -f [archivo].Rmd && echo "✓ Symlink OK"
```

### Opción 2: Script Automatizado (Futuro)

```bash
# El script agregar_ejemplo_funcional.sh se actualizará para crear symlinks
.claude/scripts/agregar_ejemplo_funcional.sh \
  A-Produccion/03-En-Produccion/[Tema]/[archivo].Rmd \
  [CODIGO-ID]
```

---

## ✅ Verificación de Symlinks

### Comando de verificación

```bash
# Ejecutar script de verificación
.claude/scripts/verificar_symlinks_ejemplos.sh

# Salida esperada:
# ✓ TODOS LOS SYMLINKS ESTÁN INTACTOS
# ⚠ Hay archivos regulares que podrían convertirse a symlinks (legacy OK)
```

### Qué verifica el script
- ✅ Total de symlinks
- ✅ Symlinks funcionando correctamente
- ❌ Symlinks rotos (requiere atención)
- ⚠️ Archivos regulares legacy

---

## 🔄 Migración de Archivos Legacy (Opcional)

Si quieres convertir archivos legacy a symlinks:

### Paso 1: Identificar origen del archivo

```bash
# ¿Dónde está el archivo original?
find A-Produccion/03-En-Produccion/ -name "Ejemplo_01.Rmd" -not -path "*/Ejemplos-Funcionales-Rmd/*"
```

### Paso 2: Respaldar archivo actual

```bash
cp A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/Ejemplo_01.Rmd \
   A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/Ejemplo_01.Rmd.backup
```

### Paso 3: Eliminar archivo regular

```bash
rm A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/Ejemplo_01.Rmd
```

### Paso 4: Crear symlink

```bash
cd A-Produccion/03-En-Produccion/Ejemplos-Funcionales-Rmd/
ln -s "../[Tema]/[ruta]/Ejemplo_01.Rmd" "Ejemplo_01.Rmd"
```

### Paso 5: Verificar

```bash
.claude/scripts/verificar_symlinks_ejemplos.sh
```

**⚠️ IMPORTANTE**: Solo hacer esto si sabes dónde está el archivo original en la estructura de temas.

---

## 📖 Ventajas de la Nueva Estrategia

### 1. Sincronización Automática

**Antes**:
```
Editas: 03-En-Produccion/06-Estadística-Y-Probabilidad/.../ejercicio.Rmd
Resultado: Ejemplos-Funcionales-Rmd/ejercicio.Rmd queda desactualizado
Acción: Copiar manualmente de nuevo
```

**Ahora**:
```
Editas: 03-En-Produccion/06-Estadística-Y-Probabilidad/.../ejercicio.Rmd
Resultado: Ejemplos-Funcionales-Rmd/ejercicio.Rmd refleja cambio automáticamente
Acción: Ninguna, ya sincronizado
```

### 2. Espacio en Disco

**Antes**:
- Archivo original: 15 KB
- Copia en ejemplos: 15 KB
- **Total**: 30 KB

**Ahora**:
- Archivo original: 15 KB
- Symlink: ~200 bytes
- **Total**: ~15 KB

### 3. Mantenimiento

**Antes**:
- Actualizar ejercicio en producción
- Recordar actualizar copia en ejemplos
- Copiar manualmente
- Verificar que se copió correctamente

**Ahora**:
- Actualizar ejercicio en producción
- Automáticamente sincronizado ✓

---

## 🚨 Posibles Problemas y Soluciones

### Problema 1: Symlink roto

**Síntoma**: El script de verificación reporta symlink roto

**Causa**: El archivo original fue movido o eliminado

**Solución**:
```bash
# Encontrar dónde está ahora el archivo
find A-Produccion/ -name "[nombre_archivo].Rmd"

# Eliminar symlink roto
rm Ejemplos-Funcionales-Rmd/[archivo].Rmd

# Crear nuevo symlink con ruta correcta
cd Ejemplos-Funcionales-Rmd/
ln -s "[nueva_ruta_relativa]" "[archivo].Rmd"
```

### Problema 2: Archivo regular en lugar de symlink

**Síntoma**: El script reporta "ARCHIVO REGULAR - considerar convertir a symlink"

**Causa**: Archivo legacy de antes del cambio de estrategia

**Solución**: Ver sección "Migración de Archivos Legacy" arriba (opcional)

---

## 📝 Notas de Implementación

### Rutas Relativas vs Absolutas

**✅ CORRECTO** (ruta relativa):
```bash
ln -s "../05-Geometría/Pensamiento-Espacial/18-Volumen-Y-Raíz-Cúbica/.../archivo.Rmd" archivo.Rmd
```

**❌ INCORRECTO** (ruta absoluta):
```bash
ln -s "/home/bootcamp/Proyectos-2026/RepositorioMatematicasICFES_R_Exams/A-Produccion/..." archivo.Rmd
```

**Razón**: Las rutas relativas funcionan en cualquier sistema y ubicación del repositorio.

### Git y Symlinks

Git trackea symlinks correctamente:
- ✅ `git add` incluye el symlink (no el contenido del archivo)
- ✅ `git commit` guarda la ruta del symlink
- ✅ `git clone` recrea el symlink en otros sistemas
- ✅ Los cambios en el archivo original se trackean por separado

---

## ✅ Checklist de Verificación Post-Cambio

- [x] Documentación actualizada (ESTRATEGIA, README, CATALOGO)
- [x] Script de verificación creado
- [x] Symlinks de ejemplo creados
- [x] Verificación ejecutada y pasando
- [ ] Actualizar script `agregar_ejemplo_funcional.sh` para crear symlinks (próximo paso)
- [ ] (Opcional) Migrar archivos legacy a symlinks

---

**Versión**: 2.0
**Fecha**: 2026-02-07
**Cambio**: Copias directas → Symlinks bidireccionales
**Autor**: Sistema automatizado
**Aprobado por**: Usuario
