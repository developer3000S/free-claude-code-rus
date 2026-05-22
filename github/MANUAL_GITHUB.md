# Manual de GitHub — Fork, Sync y Pull Requests

> **Proyecto**: free-claude-code / ICFES R-exams  
> **Usuario**: alvaretto  
> **Última actualización**: 2026-05-18  
> **Herramienta**: `gh` CLI (GitHub CLI)

---

## 1. Configuración inicial

### Remotos configurados

| Remoto | URL | Rol | Permiso |
|--------|-----|-----|---------|
| `origin` | `https://github.com/alvaretto/free-claude-code.git` | Tu fork | Escritura |
| `upstream` | `https://github.com/Alishahryar1/free-claude-code.git` | Repo original | Lectura |

```bash
# Verificar configuración actual
git remote -v
```

### Autenticación `gh`

```bash
# Verificar estado
gh auth status

# Si no está autenticado:
gh auth login
```

---

## 2. Flujo diario — 3 casos de uso

### Caso A: Sincronizar fork con upstream

Cuando el repo original recibió cambios nuevos y quieres traerlos a tu fork:

```bash
# Automático (recomendado)
bash .claude/scripts/sync-upstream.sh

# Manual (3 pasos)
git fetch upstream main          # 1. Bajar cambios del repo original
git rebase upstream/main         # 2. Re-aplicar commits locales encima
git push origin main             # 3. Subir a tu fork
```

**Cuándo usarlo**: antes de empezar a trabajar cada día, o cuando vas a crear un PR.

### Caso B: Contribuir cambios nuevos

Flujo completo para enviar una contribución al repo original:

```bash
# 1. Hacer cambios
git add <archivos>
git commit -m "feat(icfes): descripción breve"

# 2. Sincronizar con upstream (por si hubo cambios)
bash .claude/scripts/sync-upstream.sh

# 3. Push a tu fork
git push origin main

# 4. Crear PR hacia el repo original
gh pr create \
  --repo Alishahryar1/free-claude-code \
  --head alvaretto:main \
  --base main \
  --title "feat(icfes): descripción breve" \
  --body "Descripción detallada del cambio."
```

### Caso C: Solo actualizar local (sin push)

```bash
git fetch upstream main
git rebase upstream/main
```

**Cuándo usarlo**: para ver cambios recientes sin modificarlos.

---

## 3. Gestión de Pull Requests

### Crear PR

```bash
gh pr create \
  --repo Alishahryar1/free-claude-code \
  --head alvaretto:main \
  --base main \
  --title "feat: descripción" \
  --body "$(cat <<'EOF'
## Resumen

Descripción detallada.

## Archivos cambiados

- `ruta/archivo.Rmd`

## Test plan

- [ ] Renderiza en 4 formatos
- [ ] Ortografía verificada
EOF
)"
```

### Ver estado de un PR

```bash
gh pr view <número> --repo Alishahryar1/free-claude-code
```

### Listar mis PRs abiertos

```bash
gh pr list --repo Alishahryar1/free-claude-code --author alvaretto
```

### Ver comentarios/reviews en un PR

```bash
gh pr view <número> --repo Alishahryar1/free-claude-code --comments
```

---

## 4. Resolver conflictos de rebase

Si `git rebase upstream/main` falla con conflictos:

```bash
# 1. Ver archivos en conflicto
git status

# 2. Editar archivos conflictivos y resolver
# (buscar marcadores <<<<<<<, =======, >>>>>>>)

# 3. Marcar como resueltos
git add <archivo-resuelto>

# 4. Continuar rebase
git rebase --continue

# 5. Si todo falla, abortar
git rebase --abort
```

---

## 5. Comandos rápidos de referencia

| Acción | Comando |
|--------|---------|
| Sincronizar fork | `bash .claude/scripts/sync-upstream.sh` |
| Ver estado | `git status` |
| Ver remotos | `git remote -v` |
| Ver ramas | `git branch -a` |
| Ver log local | `git log --oneline -5` |
| Ver PRs abiertos | `gh pr list --repo Alishahryar1/free-claude-code` |
| Ver PR específico | `gh pr view <n> --repo Alishahryar1/free-claude-code` |
| Crear PR | `gh pr create --repo Alishahryar1/free-claude-code --head alvaretto:main --base main --title "..." --body "..."` |
| Abrir PR en navegador | `gh pr view <n> --repo Alishahryar1/free-claude-code --web` |
| Forzar push (⚠️ cuidado) | `git push origin main --force-with-lease` |

---

## 6. Diagrama del flujo

```
Alishahryar1/free-claude-code  (upstream)  ← PRs apuntan aquí
       ↑                                      (repo original, solo lectura)
       │ gh pr create
       │
alvaretto/free-claude-code     (origin)    ← git push va aquí
       ↑                                      (tu fork, escritura)
       │ git push origin main
       │
Tu máquina local               (local)     ← trabajas aquí
                                              (git commit, git add)
```

```
Flujo completo:

  upstream (original)          origin (fork)            local
  ┌─────────────┐           ┌─────────────┐        ┌─────────────┐
  │  commit #1  │           │  commit #1  │        │  commit #1  │
  │  commit #2  │ ←fetch──  │  commit #2  │ ←pull  │  commit #2  │
  │  commit #3  │           │  commit #3  │        │  commit #3  │
  └─────────────┘           └─────────────┘        │  TU TRABAJO │
                                                    └─────────────┘
                                                           │
                                              git add + git commit
                                                           │
                                              git push origin main
                                                           │
                                                    ┌──────▼──────┐
                                                    │  origin/fork │
                                                    └──────┬──────┘
                                                           │
                                                    gh pr create
                                                           │
                                                    ┌──────▼──────┐
                                                    │  upstream   │
                                                    └─────────────┘
```

---

## 7. Solución de problemas comunes

### "Permission denied" al hacer push a upstream

```bash
# ✓ Correcto: siempre pushear a origin (tu fork), no a upstream
git push origin main

# ✗ Incorrecto: upstream es solo lectura
git push upstream main
```

### "rejected - fetch first"

Significa que el fork remoto tiene commits que tu local no tiene. Sincroniza:

```bash
bash .claude/scripts/sync-upstream.sh
```

### "branches have diverged"

Tus commits locales y los remotos tomaron caminos distintos. Rebasea:

```bash
git fetch upstream main
git rebase upstream/main
git push origin main --force-with-lease
```

### Stash (guardar cambios sin commit)

```bash
git stash push -m "descripción"    # Guardar
git stash pop                       # Recuperar último
git stash list                      # Ver todos
```

---

**Scripts relacionados**:

- `.claude/scripts/sync-upstream.sh` — sincronización automática fork↔upstream

**Referencias**:

- [GitHub CLI Manual](https://cli.github.com/manual/)
- [GitHub Fork Guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks)
