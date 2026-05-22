# 🔧 Scripts de Automatización - Fase 5

Scripts para la eliminación controlada del comando deprecado `/analizar-ejercicio`.

---

## 📁 Contenido

### Scripts Principales

1. **`fase5_eliminar_comando_deprecado.sh`** - Script principal de eliminación
2. **`fase5_tests_post_eliminacion.sh`** - Tests de validación post-eliminación
3. **`fase5_rollback.sh`** - Plan de rollback en caso de problemas

---

## 🚀 Uso

### 1. Script de Eliminación

**Propósito:** Eliminar el comando `/analizar-ejercicio` después del período de gracia

**Fecha programada:** 2025-03-20

**Uso:**
```bash
bash .claude/scripts/fase5_eliminar_comando_deprecado.sh
```

**Prerequisitos:**

- ✅ Fecha actual ≥ 2025-03-20
- ✅ Checklist pre-eliminación completado
- ✅ Backup manual creado

**Acciones que realiza:**

1. Verifica fecha de ejecución
2. Verifica que no hay referencias activas
3. Crea backup automático
4. Elimina el archivo deprecado
5. Ejecuta tests de validación
6. Genera log de ejecución

**Output:**

- Backup: `.claude/backups/fase5_[FECHA]/analizar-ejercicio.md.backup`
- Log: `.claude/logs/fase5_eliminacion_[FECHA].log`

---

### 2. Tests de Validación Post-Eliminación

**Propósito:** Verificar que la eliminación no rompió el sistema

**Uso:**
```bash
bash .claude/scripts/fase5_tests_post_eliminacion.sh
```

**Tests ejecutados:**

1. ✅ Archivo deprecado eliminado
2. ✅ Comando estándar `/analizar-icfes` existe
3. ✅ Workflow usa `/analizar-icfes`
4. ✅ `generar-schoice` usa `/analizar-icfes`
5. ✅ `generar-cloze` usa `/analizar-icfes`
6. ✅ No hay referencias rotas

**Criterio de éxito:** 6/6 tests pasados

**Output:**
```
Tests pasados: 6/6
Tests fallados: 0/6
✅ TODOS LOS TESTS PASARON
```

---

### 3. Script de Rollback

**Propósito:** Restaurar el comando eliminado si hay problemas

**Uso:**
```bash
bash .claude/scripts/fase5_rollback.sh
```

**Cuándo usar:**

- ❌ Tests post-eliminación fallan
- ❌ Se descubren referencias rotas
- ❌ Workflow deja de funcionar
- ❌ Se reportan errores críticos

**Acciones que realiza:**

1. Busca el backup más reciente
2. Restaura el archivo eliminado
3. Ejecuta tests de validación
4. Genera log de rollback

**Output:**

- Archivo restaurado: `.claude/commands/analizar-ejercicio.md`
- Log: `.claude/logs/fase5_rollback_[FECHA].log`

---

## 📋 Workflow Completo

### Ejecución Normal (Sin Problemas)

```

1. Completar checklist pre-eliminación
   ↓

2. Crear backup manual
   ↓

3. Ejecutar: fase5_eliminar_comando_deprecado.sh
   ↓

4. Verificar: Tests 6/6 pasados
   ↓

5. Actualizar documentación
   ↓

6. ✅ Fase 5 completada
```

### Ejecución con Rollback (Si Hay Problemas)

```

1. Ejecutar: fase5_eliminar_comando_deprecado.sh
   ↓

2. Tests fallan ❌
   ↓

3. Ejecutar: fase5_rollback.sh
   ↓

4. Verificar: Archivo restaurado
   ↓

5. Investigar causa del problema
   ↓

6. Reprogramar eliminación
```

---

## 🔍 Verificación de Scripts

### Verificar que los scripts son ejecutables

```bash
ls -la .claude/scripts/fase5_*.sh
```

**Output esperado:**
```
-rwxr-xr-x ... fase5_eliminar_comando_deprecado.sh
-rwxr-xr-x ... fase5_tests_post_eliminacion.sh
-rwxr-xr-x ... fase5_rollback.sh
```

### Hacer scripts ejecutables (si es necesario)

```bash
chmod +x .claude/scripts/fase5_*.sh
```

---

## 📊 Logs y Backups

### Ubicación de Logs

```
.claude/logs/
├── fase5_eliminacion_[FECHA].log
└── fase5_rollback_[FECHA].log
```

### Ubicación de Backups

```
.claude/backups/
├── fase5_[FECHA]/
│   └── analizar-ejercicio.md.backup
└── manual_backup_[FECHA_HORA].md
```

### Ver logs recientes

```bash
# Ver log de eliminación más reciente
cat .claude/logs/fase5_eliminacion_*.log | tail -50

# Ver log de rollback más reciente
cat .claude/logs/fase5_rollback_*.log | tail -50
```

---

## ⚠️ Notas Importantes

### Antes de Ejecutar

1. ✅ **Leer documentación completa**: `.claude/docs/FASE5_PROCEDIMIENTO_ELIMINACION.md`
2. ✅ **Completar checklist**: `.claude/docs/FASE5_CHECKLIST_PRE_ELIMINACION.md`
3. ✅ **Crear backup manual**: Siempre crear backup adicional
4. ✅ **Verificar fecha**: Respetar período de gracia (2025-03-20)

### Durante la Ejecución

1. ⚠️ **Leer prompts cuidadosamente**: Los scripts piden confirmación
2. ⚠️ **No interrumpir**: Dejar que los scripts completen
3. ⚠️ **Revisar output**: Verificar que no hay errores

### Después de Ejecutar

1. ✅ **Verificar tests**: Deben pasar 6/6
2. ✅ **Actualizar documentación**: COMANDOS_DEPRECADOS.md y CHANGELOG.md
3. ✅ **Guardar logs**: Para referencia futura
4. ✅ **Monitorear sistema**: Primeras 24 horas

---

## 🆘 Troubleshooting

### Problema: Script no es ejecutable

**Solución:**
```bash
chmod +x .claude/scripts/fase5_[nombre_script].sh
```

### Problema: Tests fallan después de eliminación

**Solución:**
```bash
# Ejecutar rollback inmediatamente
bash .claude/scripts/fase5_rollback.sh

# Investigar causa
# Reprogramar eliminación
```

### Problema: No se encuentra backup

**Solución:**
```bash
# Verificar backups disponibles
find .claude/backups/ -name "*.backup" -o -name "manual_backup_*.md"

# Si no hay backups, NO ejecutar eliminación
# Crear backup manual primero
```

---

## 📚 Documentación Relacionada

- **Procedimiento completo**: `.claude/docs/FASE5_PROCEDIMIENTO_ELIMINACION.md`
- **Checklist pre-eliminación**: `.claude/docs/FASE5_CHECKLIST_PRE_ELIMINACION.md`
- **Comandos deprecados**: `.claude/docs/COMANDOS_DEPRECADOS.md`
- **Changelog**: `.claude/docs/CHANGELOG.md`

---

**Última actualización:** 2025-12-20

