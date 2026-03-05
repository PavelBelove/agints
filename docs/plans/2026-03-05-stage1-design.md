# AGIntS Stage 1 Design: Directory Structure + using-agints

Date: 2026-03-05
Status: Approved

---

## Goal

Create the full AGIntS directory skeleton and implement the `using-agints` core skill —
the dispatcher that replaces `using-superpowers` in the AGIntS framework.

## What is NOT in scope

- Content of stack/ and task/ skills (Phases 2+)
- synthesizer/task-template.md and agints-night-runner.sh (Phase 3)
- Pressure tests for using-agints (Phase 2 pilot validation)

---

## Directory Structure

```
agints/
├── skills/
│   ├── core/
│   │   └── using-agints/
│   │       ├── SKILL.md        ← SPEC notation, primary file for model
│   │       ├── EN.md           ← prose for humans + /agints commands
│   │       ├── list.md         ← all available skills with when-to-use
│   │       ├── MANIFEST.json   ← metadata, level=core
│   │       └── tests/          ← empty, pressure scenarios added in Phase 2
│   ├── stack/                  ← .gitkeep
│   └── task/                   ← .gitkeep
├── synthesizer/
│   ├── queue.md                ← checklist of 14 core skills to process
│   ├── task-template.md        ← placeholder (Phase 3)
│   └── output/                 ← .gitkeep, night agent writes here
├── docs/
│   └── plans/                  ← this file + future design docs
└── .agints.template            ← template for new projects
```

---

## using-agints Architecture

Three logical blocks in one skill:

### 1. Enforcement (from using-superpowers, adapted)
Hard rule: check for applicable skill before any response or action.
Anti-patterns list covers known rationalization patterns.
🔴 ABSOLUTE priority — without this the whole framework is inert.

### 2. Stack Detector
Runs at session start. Reads project files + .agints file.
Maps file presence to skill loading:
- package.json ∋ react/next/vue → stack skill
- go.mod → stack/go
- pyproject|requirements ∋ fastapi|django → stack skill
- Cargo.toml → stack/rust
Reports active skills to user.

### 3. AGIntS Routing
Maps task type → skill name. Covers all core skills.
Stack/task slots are present but marked as empty until library grows.

---

## SKILL.md Structure (SPEC notation per notation.md)

```
---
name: using-agints
description: "Use at the start of every conversation — detects project stack,
  loads relevant skills from .agints, routes tasks to appropriate skills."
---

SKILL := using-agints
VERSION := 1.0.0
PURPOSE := dispatch_to_skills + detect_stack + enforce_skill_check

RULE 🔴 ABSOLUTE
  BEFORE any response or action → check if skill applies

ANTI_PATTERNS := { ... }

STACK_DETECT { ... }

ROUTING { task_type → skill_name }

REFS := { EN.md, list.md }
```

---

## Supporting Files

**MANIFEST.json**
- level: core
- stack: [] (language-agnostic)
- requires: []
- source: original
- frozen: false

**list.md**
Lists all 14 core skills from Superpowers queue with when-to-use descriptions.
Living document — updated as library grows.

**EN.md**
- Full routing table (prose)
- /agints commands: install, list, suggest, freeze, update
- Installation instructions

**.agints.template**
Ready-to-copy template with all core skills uncommented, stack/task sections commented out with instructions.

**synthesizer/queue.md**
All 14 core skills from spec.md in [ ] state, ready for Phase 3.

---

## Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| using-agints vs wrapper over using-superpowers | Full replacement | Own framework, no layering overhead |
| /agints commands placement | EN.md only | Rarely needed at runtime, save context |
| Stack detection trigger | Session start | Proactive, not reactive |
| queue.md format | Markdown checklist | Simple, sufficient for episodic use |
