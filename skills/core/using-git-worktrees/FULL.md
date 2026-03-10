# Using Git Worktrees — Full Reference

## Why Worktrees

Git worktrees let you have multiple working directories from a single repository — each on a different branch — without switching branches or cloning the repo. This enables:

- **Branch isolation:** Implement features without disturbing the current working tree
- **Parallel agent workflows:** Multiple agents work on independent tasks simultaneously
- **Clean baselines:** Each worktree starts from a verified clean state
- **Safe experimentation:** A/B comparisons, hotfixes while feature work continues

---

## Step 1: Directory Selection

Always follow this priority order before creating a worktree:

### Priority 1: Check Existing Directories

```bash
ls -d .worktrees 2>/dev/null     # Preferred (hidden, project-local)
ls -d worktrees 2>/dev/null      # Alternative
```

- If `.worktrees/` exists → use it
- If `worktrees/` exists → use it
- If both exist → `.worktrees/` wins

### Priority 2: Check CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

If a preference is specified, use it without asking the user.

### Priority 3: Ask User

Only if no directory exists and CLAUDE.md has no preference:

```
No worktree directory found. Where should I create worktrees?

1. .worktrees/ (project-local, hidden)
2. ~/.config/superpowers/worktrees/<project-name>/ (global, outside repo)

Which would you prefer?
```

---

## Step 2: Safety Verification (Project-Local Only)

**MUST verify directory is gitignored before creating project-local worktrees.**

```bash
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:** Fix it immediately (per "fix broken things immediately" principle):
1. Add `.worktrees/` (or `worktrees/`) to `.gitignore`
2. `git add .gitignore && git commit -m "chore: add worktrees dir to gitignore"`
3. Then proceed with worktree creation

**Why this matters:** If the worktree directory is tracked, every file inside every worktree gets indexed by git, polluting `git status` and potentially getting committed accidentally.

**Global directory** (`~/.config/superpowers/worktrees/`): No gitignore check needed — it's outside the project entirely.

---

## Step 3: Create the Worktree

```bash
# Detect project name
project=$(basename "$(git rev-parse --show-toplevel)")

# Create worktree with new branch
git worktree add .worktrees/feature-name -b feature/feature-name
```

**Naming convention for project-local:**
```
.worktrees/<branch-or-topic>
```

**Naming convention for global:**
```
~/.config/superpowers/worktrees/<project-name>/<branch-name>
```

---

## Step 4: Dependency Setup

Auto-detect and run appropriate setup commands:

```bash
if [ -f package.json ]; then npm install; fi
if [ -f Cargo.toml ]; then cargo build; fi
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi
if [ -f go.mod ]; then go mod download; fi
```

If none of these files exist, skip silently.

---

## Step 5: Baseline Test Verification

Run tests in the new worktree to confirm a clean starting state:

```bash
npm test          # Node.js
cargo test        # Rust
pytest            # Python
go test ./...     # Go
```

**If tests fail:** Report the failures explicitly and ask whether to proceed or investigate:
```
⚠️ Baseline tests failing (3 failures):
  - test_auth_token: AssertionError
  - test_session_expiry: TimeoutError
  - test_refresh_token: TypeError

These may be pre-existing failures. Should I proceed with implementation
anyway, or investigate these first?
```

**Never silently proceed with failing tests** — you won't be able to distinguish new bugs from pre-existing ones.

---

## Step 6: Report

```
Worktree ready at /Users/jesse/myproject/.worktrees/auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

---

## Parallel Workflow Patterns

### Pattern 1: Multi-Feature Development

Create multiple worktrees for truly independent features:

```bash
git worktree add .worktrees/api -b feature/api-endpoints
git worktree add .worktrees/ui -b feature/ui-components
git worktree add .worktrees/tests -b feature/integration-tests
```

Each agent or terminal session owns one worktree. Never share a worktree between agents.

### Pattern 2: Feature + Hotfix

Current feature work blocked? Create a hotfix worktree from main:

```bash
git worktree add .worktrees/hotfix-123 -b hotfix/issue-123 main
# Fix the issue, merge, come back to feature
```

### Pattern 3: A/B Implementation Comparison

Compare two approaches to the same problem:

```bash
git worktree add .worktrees/approach-redis -b try/redis-caching
git worktree add .worktrees/approach-memcache -b try/memcache-caching
# Implement each, benchmark, choose winner
```

### Pattern 4: Subagent Verification

Main agent creates a read-only verification worktree:

```bash
git worktree add --detach .worktrees/verify HEAD
# Subagent verifies implementation in isolation
```

---

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| `fatal: branch already checked out` | Branch exists in another worktree | `git worktree list` to find it; remove or use different branch |
| `cannot remove worktree` | Uncommitted changes present | Commit, stash, or `git worktree remove --force` |
| Stale worktree references | Worktree directory deleted manually | `git worktree prune` |
| Lock file exists | Previous operation interrupted | Remove `.git/worktrees/<name>/locked` |
| Path already exists | Directory exists at target path | Choose different path or `rm -rf <path>` |

---

## Validation Checklist

Before claiming setup complete:

1. `git worktree list` shows expected path + branch
2. Project setup commands exited with code 0 (if applicable)
3. Baseline tests pass (or user explicitly acknowledged failures)
4. Full worktree path reported to user

---

## Cleanup

After work is merged and branch no longer needed:

```bash
git worktree remove .worktrees/feature-name
git branch -d feature/feature-name
git worktree prune   # Remove stale metadata
```

For larger cleanup, see `scripts/worktree-cleanup.sh`.

Use **finishing-a-development-branch** for the full cleanup workflow after a branch is merged.

---

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| Skipping gitignore check | Worktree contents tracked, pollute `git status` | Always `git check-ignore` before project-local |
| Assuming directory location | Creates inconsistency with project conventions | Always follow priority: existing > CLAUDE.md > ask |
| Proceeding with failing tests | Can't distinguish new bugs from pre-existing | Report failures, get explicit permission |
| Hardcoding setup commands | Breaks on different project types | Auto-detect from package.json, Cargo.toml, etc. |
| Creating worktree inside project | Nested git state confusion | Always use `.worktrees/` at project root or global |
