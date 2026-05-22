#!/bin/bash
# sync-upstream.sh — Sincronizar fork con upstream y push
# Uso: bash .claude/scripts/sync-upstream.sh
#
# Workflow completo:
#   1. Traer cambios nuevos del repo original (upstream)
#   2. Rebase commits locales encima de upstream/main
#   3. Push al fork (origin)
#
# Ver: .claude/docs/WORKFLOW_PASO_A_PASO.md (sección "Git y Fork")

set -e

echo "=== Sincronizando fork alvaretto/free-claude-code ==="
echo ""

# 1. Fetch del repo original
echo "1/3 Fetch upstream (Alishahryar1/free-claude-code)..."
git fetch upstream main

# 2. Rebase local encima de upstream
echo "2/3 Rebase local sobre upstream/main..."
git rebase upstream/main

# 3. Push al fork
echo "3/3 Push a origin (alvaretto/free-claude-code)..."
git push origin main

echo ""
echo "=== Sincronización completa ==="
echo "Commits locales: $(git rev-list --count upstream/main..main) por delante de upstream"
