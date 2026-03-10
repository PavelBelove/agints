#!/bin/bash
# worktree-cleanup.sh — Remove merged worktrees safely
# Usage: ./worktree-cleanup.sh [--force]
#
# Source: adapted from majiayu000/claude-skill-registry/git-worktree-workflow

set -euo pipefail

FORCE=${1:-""}

echo "Scanning worktrees..."
git worktree list

echo ""
echo "Removing merged branches..."
git branch --merged main 2>/dev/null | grep -v "^\*\|main\|master" | while read -r branch; do
    worktree_path=$(git worktree list --porcelain | grep -B2 "branch refs/heads/$branch" | head -1 | awk '{print $2}')
    if [ -n "$worktree_path" ] && [ "$worktree_path" != "$(git rev-parse --show-toplevel)" ]; then
        echo "Removing worktree: $worktree_path (branch: $branch)"
        if [ "$FORCE" = "--force" ]; then
            git worktree remove --force "$worktree_path"
        else
            git worktree remove "$worktree_path" 2>/dev/null || echo "  ⚠️  Skipped (uncommitted changes). Use --force to override."
        fi
        git branch -d "$branch" 2>/dev/null || true
    fi
done

echo ""
echo "Pruning stale references..."
git worktree prune

echo ""
echo "Done. Current worktrees:"
git worktree list
