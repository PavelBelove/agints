# AGIntS Stage 1 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create the full AGIntS directory skeleton and implement the `using-agints` core skill (dispatcher + stack detector).

**Architecture:** Own framework (not a Superpowers wrapper). `using-agints` is a standalone core skill that enforces skill-check discipline, detects project stack from files, and routes tasks to the right skills. Based on best practices from `refs/superpowers/skills/using-superpowers/SKILL.md` and `refs/superclaude/` but fully original. SPEC notation per `md/notation.md`.

**Tech Stack:** Markdown (SKILL.md, EN.md, list.md), JSON (MANIFEST.json), bash (.gitkeep creation). No code dependencies.

**References:**
- Design doc: `docs/plans/2026-03-05-stage1-design.md`
- SPEC notation: `md/notation.md`
- Skill format spec: `md/spec.md` (section "Формат навыка")
- Dispatcher reference: `refs/superpowers/skills/using-superpowers/SKILL.md`
- Flags reference: `refs/superclaude/plugins/superclaude/core/FLAGS.md`

**Note:** Project has no git repo yet — Task 1 initializes it.

---

### Task 1: Initialize git repo + create directory skeleton

**Files:**
- Create: `.git/` (via `git init`)
- Create: `skills/core/using-agints/tests/.gitkeep`
- Create: `skills/stack/.gitkeep`
- Create: `skills/task/.gitkeep`
- Create: `synthesizer/output/.gitkeep`
- Create: `docs/plans/` (already exists)

**Step 1: Init git**

```bash
cd /home/pol/dev/agints
git init
```

Expected: `Initialized empty Git repository in /home/pol/dev/agints/.git/`

**Step 2: Create skeleton directories with .gitkeep**

```bash
mkdir -p skills/core/using-agints/tests
mkdir -p skills/stack
mkdir -p skills/task
mkdir -p synthesizer/output
touch skills/core/using-agints/tests/.gitkeep
touch skills/stack/.gitkeep
touch skills/task/.gitkeep
touch synthesizer/output/.gitkeep
```

**Step 3: Create .gitignore**

```
synthesizer/output/
```

Save to `.gitignore` at project root.

**Step 4: Verify structure**

```bash
find . -not -path './.git/*' -not -name '.git' | sort
```

Expected output includes:
```
./docs/plans/
./md/
./refs/
./skills/core/using-agints/tests/.gitkeep
./skills/stack/.gitkeep
./skills/task/.gitkeep
./synthesizer/output/.gitkeep
```

**Step 5: Commit**

```bash
git add -A
git commit -m "chore: init repo + directory skeleton"
```

---

### Task 2: Write `using-agints/SKILL.md`

**Files:**
- Create: `skills/core/using-agints/SKILL.md`

This is the primary file — loaded by Claude Code on every session. Must be compact (SPEC notation), under 150 lines, no prose fluff.

**Step 1: Write the file**

Content:

```markdown
---
name: using-agints
description: "Use at the start of every conversation — detects project stack from
  .agints and project files, routes tasks to appropriate AGIntS skills. MUST be
  invoked before any response or action, including clarifying questions."
---

SKILL := using-agints
VERSION := 1.0.0

PURPOSE := enforce_skill_check + detect_stack + route_to_skills

RULE 🔴 ABSOLUTE
  BEFORE any response or action → check if AGIntS skill applies
  IF applies → invoke it via Skill tool
  NO exceptions

ANTI_PATTERNS := {
  "This is simple"              → simple tasks need skills too
  "I need more context first"   → skill check precedes context gathering
  "I already know this"         → skills evolve, always invoke current version
  "This isn't a real task"      → any action = task, check first
  "Let me explore codebase"     → skills define HOW to explore
  "Just one quick thing"        → check BEFORE doing anything
}

STACK_DETECT
  ON session_start:
    READ .agints IF exists → report active skills
    SCAN project files:
      package.json ∋ "react"   → note: stack/react available
      package.json ∋ "next"    → note: stack/nextjs available
      go.mod                   → note: stack/go available
      pyproject.toml|requirements.txt ∋ "fastapi" → note: stack/fastapi available
      pyproject.toml|requirements.txt ∋ "django"  → note: stack/django available
      Cargo.toml               → note: stack/rust available
    REPORT detected stack to user at session start

ROUTING
  TRIGGER                          → SKILL
  feature|component|new_build      → brainstorming
  bug|test_failure|unexpected      → systematic-debugging
  implement|code|write             → test-driven-development
  plan|spec|requirements           → writing-plans
  2+_independent_tasks             → dispatching-parallel-agents
  subagent|delegate|fresh_context  → subagent-driven-development
  done|complete|ready_to_ship      → verification-before-completion
  branch|merge|pr                  → finishing-a-development-branch
  worktree|isolation               → using-git-worktrees
  review_feedback                  → receiving-code-review
  request_review                   → requesting-code-review
  new_skill|write_skill            → writing-skills

SKILL_PRIORITY
  1. process skills first  (brainstorming, systematic-debugging)
  2. implementation skills (test-driven-development, writing-plans)

REFS := {
  EN.md    ← /agints commands, full routing table, installation guide
  list.md  ← all available skills with descriptions and triggers
}
```

**Step 2: Verify length and format**

File should be under 150 lines. Check:
```bash
wc -l skills/core/using-agints/SKILL.md
```

**Step 3: Verify SPEC format matches notation.md**

Re-read `md/notation.md` and confirm:
- Uses `:=` for assignments
- Uses `→` for implications
- Uses `∋` for membership
- Uses `{}` for blocks
- No explanatory prose in SKILL.md

**Step 4: Commit**

```bash
git add skills/core/using-agints/SKILL.md
git commit -m "feat: add using-agints SKILL.md (core dispatcher)"
```

---

### Task 3: Write `using-agints/EN.md`

**Files:**
- Create: `skills/core/using-agints/EN.md`

Human-readable version. Contains everything that would bloat SKILL.md: full routing table explanation, /agints commands, installation guide.

**Step 1: Write the file**

```markdown
# using-agints — AGIntS Core Dispatcher

## What this skill does

This is the entry point for every AGIntS session. It does three things:
1. **Enforces skill discipline** — ensures you invoke the right skill before acting
2. **Detects project stack** — reads `.agints` and project files at session start
3. **Routes tasks** — tells you which skill to use for which task

## Stack Detection

At the start of each session, `using-agints` scans your project and reports
which skills are active based on your `.agints` file and detected stack.

Copy `.agints.template` to your project root as `.agints` to get started.

## Routing Table

| Task type | Skill |
|-----------|-------|
| New feature, component, system | brainstorming |
| Bug, test failure, unexpected behavior | systematic-debugging |
| Writing code / implementing | test-driven-development |
| Planning, spec, requirements | writing-plans |
| 2+ independent parallel tasks | dispatching-parallel-agents |
| Delegating to subagent | subagent-driven-development |
| Completing / shipping work | verification-before-completion |
| Branch, merge, PR decisions | finishing-a-development-branch |
| Isolated feature work | using-git-worktrees |
| Receiving code review feedback | receiving-code-review |
| Requesting code review | requesting-code-review |
| Writing or improving a skill | writing-skills |

## /agints Commands

These commands manage your `.agints` skills lock file:

```
/agints install <skill>   — add skill to .agints
/agints freeze <skill>    — mark skill as frozen (won't auto-update)
/agints update            — update all non-frozen skills to latest
/agints list              — show installed skills and their status
/agints suggest           — suggest skills based on detected stack
```

## Installation

1. Copy `.agints.template` to your project root as `.agints`
2. Edit to uncomment stack/task skills you need
3. Install AGIntS plugin in Claude Code:
   `/plugin install <path-to-agints-repo>`

## Skill levels

| Level | When loaded | Examples |
|-------|-------------|---------|
| core | Always | brainstorming, tdd, debugging |
| stack | When stack detected | react, fastapi, go |
| task | On demand | graphql, docker, ci-cd |
```

**Step 2: Commit**

```bash
git add skills/core/using-agints/EN.md
git commit -m "feat: add using-agints EN.md (human-readable version)"
```

---

### Task 4: Write `using-agints/list.md`

**Files:**
- Create: `skills/core/using-agints/list.md`

Living document. Lists all available AGIntS skills with when-to-use descriptions.
Starts with core skills only (Phase 1). Stack/task sections exist but are empty.

**Step 1: Write the file**

```markdown
# AGIntS Available Skills

## Core Skills (always loaded)

### brainstorming
**When:** Starting any new feature, component, system, or making a significant design decision.
**Trigger:** "let's build", "add feature", "design", "create component"

### test-driven-development
**When:** Writing any code — feature or bugfix. No exceptions.
**Trigger:** "implement", "write", "code", "add", "fix"

### systematic-debugging
**When:** Bug, test failure, unexpected behavior, error you can't explain.
**Trigger:** "bug", "broken", "failing", "error", "why is this"

### writing-plans
**When:** You have a design and need a step-by-step implementation plan.
**Trigger:** After brainstorming approval, before implementation

### dispatching-parallel-agents
**When:** 2+ independent tasks that don't share state.
**Trigger:** "also do X", multiple unrelated files to change

### subagent-driven-development
**When:** Executing plan tasks — each gets a fresh subagent + code review.
**Trigger:** Implementing from a plan doc

### verification-before-completion
**When:** About to say "done", "fixed", "works", "tests pass".
**Trigger:** Before claiming any work complete

### finishing-a-development-branch
**When:** Implementation complete, deciding how to integrate.
**Trigger:** "done", "merge", "PR", "ship"

### using-git-worktrees
**When:** Starting feature work that needs isolation.
**Trigger:** Before starting any significant feature

### receiving-code-review
**When:** Got code review feedback, before implementing suggestions.
**Trigger:** Review feedback received

### requesting-code-review
**When:** Completing tasks or major features.
**Trigger:** "review", "check my work", "LGTM?"

### writing-skills
**When:** Creating or improving an AGIntS skill.
**Trigger:** "new skill", "improve skill", "write skill"

---

## Stack Skills

*(None yet — added by synthesizer in Phase 2)*

---

## Task Skills

*(None yet — added by synthesizer in Phase 3)*

---

## Install a skill

```
/agints install <skill-name>
```
```

**Step 2: Commit**

```bash
git add skills/core/using-agints/list.md
git commit -m "feat: add using-agints list.md (skill catalog)"
```

---

### Task 5: Write `using-agints/MANIFEST.json`

**Files:**
- Create: `skills/core/using-agints/MANIFEST.json`

**Step 1: Write the file**

```json
{
  "name": "using-agints",
  "version": "1.0.0",
  "level": "core",
  "stack": [],
  "requires": [],
  "source": "original",
  "origin": [
    "superpowers/using-superpowers@4.3.1",
    "superclaude/FLAGS.md@4.2.0"
  ],
  "frozen": false,
  "description": "Core dispatcher: enforces skill-check discipline, detects project stack, routes tasks to appropriate skills.",
  "platforms": ["claude-code"]
}
```

**Step 2: Validate JSON**

```bash
python3 -m json.tool skills/core/using-agints/MANIFEST.json
```

Expected: JSON prints without errors.

**Step 3: Commit**

```bash
git add skills/core/using-agints/MANIFEST.json
git commit -m "feat: add using-agints MANIFEST.json"
```

---

### Task 6: Write `.agints.template`

**Files:**
- Create: `.agints.template`

**Step 1: Write the file**

```
# AGIntS skills lock — copy this file to your project root as .agints
# Format: name@version [frozen]
# frozen = skill is customized locally, do not update from repo

# ── core (always loaded, do not remove) ────────────────────────────
using-agints@1.0.0
brainstorming@1.0.0
test-driven-development@1.0.0
systematic-debugging@1.0.0
writing-plans@1.0.0
subagent-driven-development@1.0.0
verification-before-completion@1.0.0

# ── stack (uncomment what matches your project) ────────────────────
# react@1.0.0
# nextjs@1.0.0
# typescript@1.0.0
# fastapi@1.0.0
# django@1.0.0
# go@1.0.0
# rust@1.0.0

# ── task (add as needed) ───────────────────────────────────────────
# graphql@1.0.0
# docker@1.0.0
# ci-cd@1.0.0
```

**Step 2: Commit**

```bash
git add .agints.template
git commit -m "feat: add .agints.template for new projects"
```

---

### Task 7: Write `synthesizer/queue.md`

**Files:**
- Create: `synthesizer/queue.md`

All 14 core skills from `md/spec.md` queue, plus confidence-check from SuperClaude.

**Step 1: Write the file**

```markdown
# AGIntS Synthesizer Queue

Процесс: агент берёт первый `[ ]` навык, обрабатывает по pipeline из
`task-template.md`, отмечает `[x]` с датой и версией.

---

## Pending

- [ ] brainstorming
- [ ] test-driven-development
- [ ] systematic-debugging
- [ ] writing-plans
- [ ] subagent-driven-development
- [ ] verification-before-completion
- [ ] confidence-check
- [ ] using-git-worktrees
- [ ] requesting-code-review
- [ ] receiving-code-review
- [ ] finishing-a-development-branch
- [ ] dispatching-parallel-agents
- [ ] executing-plans
- [ ] writing-skills

---

## In Progress

*(текущий навык в обработке)*

---

## Done

*(навыки с датой завершения и версией)*
```

**Step 2: Commit**

```bash
git add synthesizer/queue.md
git commit -m "feat: add synthesizer queue (14 core skills pending)"
```

---

### Task 8: Final verification + summary commit

**Step 1: Verify complete structure**

```bash
find . -not -path './.git/*' -not -name '.git' | sort
```

Expected structure matches design doc exactly.

**Step 2: Verify SKILL.md is loadable**

Check that SKILL.md has valid frontmatter:
```bash
head -5 skills/core/using-agints/SKILL.md
```

Expected:
```
---
name: using-agints
description: "Use at the start of every conversation...
---
```

**Step 3: Final summary commit**

```bash
git add -A
git status  # should show nothing untracked except synthesizer/output/
git log --oneline
```

Expected log:
```
feat: add synthesizer queue
feat: add .agints.template
feat: add using-agints MANIFEST.json
feat: add using-agints list.md
feat: add using-agints EN.md
feat: add using-agints SKILL.md
chore: init repo + directory skeleton
```
