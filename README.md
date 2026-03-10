# AGIntS — Adaptive Skill Runtime for AI Agents

> **Skills are modules. Core is a dispatcher. Loading is dynamic. Evolution is automated.**

AGIntS is an open skill library for Claude Code and other AI coding agents — built on the principle that your model's context window is a finite, precious resource that most skill systems waste.

---

## The Problem with Existing Skill Systems

Every popular skill framework (Superpowers, SuperClaude, etc.) loads everything upfront. Your agent starts a React bug fix and gets 40KB of Go migration instructions it will never use. That's context budget burned before a single line of code is written.

Beyond bloat, skills written as plain prose are inherently wasteful: the same constraint expressed in natural language costs 10× more tokens than in structured notation — with no gain in model compliance.

AGIntS fixes both problems.

---

## How It Works

### 1. SPEC Notation — Compact by Design

Every skill is written in **SPEC**, a minimal declarative DSL tuned for LLM consumption:

```
PROCESS
  1. Explore project context
  2. Ask one clarifying question
  IF design_approved → invoke writing-plans
  FORBIDDEN := write_code_before_design_approval
```

Compared to prose equivalents: **3–5× fewer tokens**, better constraint compliance, and activation of the model's latent structural patterns. The full prose version (`FULL.md`) is always available — for humans and for when the model needs extra attention on a critical task.

### 2. Three-Tier Partial Loading

```
core/     ← always loaded: planning, TDD, debugging, brainstorming
stack/    ← detected from project files: react, typescript, fastapi, go...
task/     ← on demand: graphql, migrations, ci-cd, sql-optimization...
```

A `.agints` file (think `requirements.txt` for behaviors) pins exactly which skills your project needs:

```
brainstorming@1.1.0
test-driven-development@2.0.0 frozen
react@1.0.0
graphql@1.0.0
```

The `using-agints` core skill auto-detects your stack on session start and loads only what's relevant.

### 3. Skill Selector — The Plan-Level Router

When your project grows to dozens of skills, who decides which skill applies to each step of an implementation plan? In most systems: every executor agent figures it out independently — burning context, producing inconsistent results, missing conflicts between steps.

AGIntS introduces a dedicated **Skill Selector Agent** that runs once per plan:

```
Planning Agent (writing-plans)
    ↓  plan without directives
Skill Selector Agent      ← reads full plan + all CAPSULE.md files
    ↓  annotated plan: USE_SKILL directives per step
Execution Agents          ← follow directives, skip skill discovery
```

It reads only `CAPSULE.md` files — ≤40 lines each, purpose-built for routing:

```
300 skills × ~50 tokens/capsule = ~15K tokens (once, up front)
```

Every executor gets precise instructions. No context wasted on discovery. No conflicting decisions across steps.

### 4. Synthesizer — Skills That Get Better Overnight

AGIntS doesn't just ship skills — it ships a pipeline that **automatically improves them**:

```
PHASE 0: Discovery     → inventory source dir + search skill hubs via GitHub
PHASE 1: Analysis      → read all sources, score on 6 criteria, pick best base
PHASE 2: Synthesis     → merge best-of-all, convert to SPEC, write FULL.md
PHASE 3: Validation    → no contradictions, no broken refs, no prompt injection
PHASE 4: Testing       → subagent pressure test with the new skill
PHASE 5: Documentation → CREATION-LOG.md with sources, decisions, test results
```

Scoring criteria: `clarity · constraint_precision · token_efficiency · verifiability · safety · no_redundancy`

Sources scanned: Superpowers, SuperClaude, awesome-agent-skills, official Claude marketplace. The synthesizer runs autonomously via cron — queue a skill, wake up to a synthesized, tested result.

---

## Complete Agentic Pipeline

```
User Request
    │
    ▼
using-agints              session start: detect stack, load core skills
    │
    ▼
brainstorming             explore design space, get approval before any code
    │
    ▼
writing-plans             decompose into atomic microtasks with TDD cycles
    │
    ▼
skill-selector            annotate each step with USE_SKILL directives (once)
    │
    ▼
subagent-driven-development   dispatch independent steps to fresh agents
    │
    ▼
verification-before-completion   require fresh evidence before claiming done
```

Every stage is a skill. Every skill is replaceable, upgradeable, freezable.

---

## What's Included

18 production-ready core skills, synthesized from the best available sources:

| Skill | Purpose |
|-------|---------|
| `using-agints` | Session orchestrator — stack detection, core loading, routing |
| `skill-selector` | Plan-level router — injects USE_SKILL directives |
| `brainstorming` | Design-first discipline before any implementation |
| `writing-plans` | Decomposes requirements into atomic microtasks |
| `writing-microtasks` | Structures each task as a TDD cycle |
| `subagent-driven-development` | Dispatches independent tasks to isolated subagents |
| `test-driven-development` | Enforces test-first with hard gates |
| `systematic-debugging` | Root-cause tracing before any fix |
| `verification-before-completion` | Evidence required before claiming success |
| `confidence-check` | Stops wrong-direction work pre-implementation |
| `writing-skills` | Creates and improves skills in AGIntS format |
| `synthesizing-skills` | Full synthesis pipeline for sourcing from ecosystems |
| `using-git-worktrees` | Isolated feature work with safety checks |
| `writing-plans` | Implementation plan structure |
| `executing-plans` | Plan execution with review checkpoints |
| `requesting-code-review` | Pre-merge verification workflow |
| `receiving-code-review` | Technical rigor in applying review feedback |
| `finishing-a-development-branch` | Structured completion: merge, PR, or cleanup |

---

## Skill Structure

```
skills/skill-name/
  SKILL.md       ← SPEC notation (what the agent loads)
  FULL.md        ← prose companion (human-readable, full detail)
  CAPSULE.md     ← ≤40 lines, for skill-selector routing
  list.md        ← related skills with when-to-use guidance
  MANIFEST.json  ← version, level, stack, dependencies, origin
  tests/         ← pressure scenarios and edge cases
```

A skill without `CAPSULE.md` is invisible to the router. A skill without `FULL.md` has no human-readable explanation. Both are required artifacts.

---

## Installation

**Option 1 — Claude Code plugin:**
```bash
# Add to your project's .claude/settings.json
{
  "plugins": ["path/to/agints"]
}
```

**Option 2 — Direct CLAUDE.md reference:**
```bash
cat skills/core/using-agints/SKILL.md >> .claude/CLAUDE.md
```

**Option 3 — Per-project .agints file:**
```
# .agints — skill lock for this project
using-agints@1.0.0
brainstorming@1.1.0
test-driven-development@2.0.0 frozen
react@1.0.0
```

---

## Why AGIntS Over Alternatives

| | Superpowers | SuperClaude | **AGIntS** |
|--|--|--|--|
| Partial loading | — | — | ✓ core + stack + task |
| SPEC notation | — | partial | ✓ all skills |
| Plan-level routing | — | — | ✓ Skill Selector |
| Autonomous synthesis | — | — | ✓ overnight pipeline |
| Dual format | — | — | ✓ SPEC + prose |
| Skill testing | partial | — | ✓ pressure scenarios |
| Origin tracking | — | — | ✓ CREATION-LOG.md |

AGIntS doesn't replace Superpowers — it synthesizes from it. The best skills from every ecosystem, re-encoded for efficiency, tested, and automatically kept up to date.

---

## Long-Term Vision

AGIntS is designed to become a **package manager for agent behavior** — where skills are versioned modules, stacks are dependency groups, and the synthesizer is the upgrade mechanism. Today it works with Claude Code. The SPEC format and skill architecture are agent-environment agnostic.

---

## License

MIT
