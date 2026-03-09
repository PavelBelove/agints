# Skill Selector — Full Documentation

## Why This Skill Exists

As the AGIntS skill library grows to 100–300 skills, a fundamental problem emerges: **who decides which skills an executor agent should use on a given microtask?**

Without Skill Selector, each executor must answer this itself. The problem:

- **Context explosion**: an executor loading all 300 skill descriptions uses its entire context budget before touching the actual task
- **Non-determinism**: different executors make different routing decisions for the same type of task — inconsistent behavior
- **Conflicting instructions**: executor A loads TDD + a framework skill that contradicts TDD's RED phase rule; executor B loads neither
- **No global view**: executor working on step 3 doesn't know what skills step 7 needs, can't detect cross-step conflicts
- **No gap detection**: recurring patterns (e.g., every FastAPI task reinventing the same test fixtures) go unnoticed

**The solution: separate skill selection from skill execution.**

## Architecture Position

```
User request
    ↓
Planning Agent (writing-plans)
    ↓ raw plan: steps with tasks but no skill directives
Skill Selector Agent  ← THIS SKILL
    ↓ annotated plan: USE_SKILL directives inside each step
Execution Agents (subagent-driven-development / executing-plans)
    ↓ each executor reads its step, loads specified skills, does the work
```

This is **plan-level** skill routing, not **session-level** (that's `using-agints`).

## The Economics Argument

**Without Skill Selector (N executors do their own routing):**
```
N × (skill discovery overhead + risk of wrong skill + risk of missing skill)
```
For 10 executors: 10× the overhead, 10× the risk, no cross-step conflict resolution.

**With Skill Selector (one routing pass before dispatch):**
```
1 × (load all capsules ~15K tokens + analyze plan)
```
300 skills × ~50 tokens per capsule = ~15,000 tokens. One time. The selector sees the whole library and the whole plan simultaneously — the only agent that ever has this view.

**The capsule format is what makes this economical.** Full SKILL.md files average 80–130 lines. All capsules together (~15K tokens) cost less than loading 3–4 full skills.

## The Capsule Mechanism

Each skill in AGIntS has a `CAPSULE.md` — a ≤40-line structured summary. The Skill Selector loads only capsules, never full SKILL.md files, for its routing work.

**What a capsule provides for routing:**
```
USE_WHEN := { trigger conditions }      ← does this step need this skill?
AVOID_WHEN := { anti-patterns }         ← should skip even if USE_WHEN matches?
CORE_RULES := { key constraints }       ← do any conflict with other selected skills?
RELATED := { companion skills }         ← what else should come with this skill?
```

The executor then loads the skill at the level specified in `USE_SKILL: name LOAD: level`.

## PROCESS: Detailed Walkthrough

### Step 1: Read the Full Plan

Read the entire plan text upfront — all steps, all context. The Skill Selector needs the full picture to:
- Detect cross-step conflicts
- Identify patterns across multiple steps (gap detection)
- Understand which step is a dependency of which

Never read step-by-step; always read everything before making routing decisions.

### Step 2: Load All Capsules

```
FOR each installed skill:
  READ skills/{level}/{name}/CAPSULE.md
  EXTRACT: USE_WHEN, AVOID_WHEN, CORE_RULES, RELATED, SWITCH_TO
BUILD: in-context routing table
```

At 300 skills, this is ~15K tokens. At 50 skills (early AGIntS), it's ~2.5K tokens. Always load all — never try to pre-filter which capsules to load, because you need the full picture to detect what's missing.

### Step 3: Match, Conflict-Check, Budget

For each step:

**a. Match:** Does the step intent match any capsule's `USE_WHEN`? Look at:
- The action being performed (implement, test, refactor, plan, debug)
- The domain (Python, React, database, CI/CD)
- The methodology implied (write-first or test-first?)

**b. Conflict detection:** Do any two selected skills have contradictory `CORE_RULES`?
- Example conflict: one skill says "no implementation before failing test" + another says "write happy-path first to understand the interface"
- Resolution: prefer higher lifecycle (core > stable > experimental). If still unclear, flag for human.

**c. Budget enforcement:**
```
SKILL_BUDGET := {
  core_skills_per_step ≤ 3
  total_skills_per_step ≤ 6
}
```
If over budget: use a bundle if one covers the needed skills, or drop the lowest-priority skills (optional > standard > critical).

**d. Load level decision:**

| Skill type | Default load | Rationale |
|---|---|---|
| Core discipline (TDD, debugging, verification) | spec | Executor needs full rules |
| Process skills (planning, brainstorming) | capsule | Reference only |
| Stack/task skills (react, graphql) | capsule | Executor decides depth |
| Escalation skill | spec | Always full rules when escalating |
| Explicitly requested by step | full | Rare; step says "consult full docs" |

### Step 4: Gap Detection

During step matching, track patterns that have no matching skill:

```
IF step_pattern appears ≥ 3 times across plan AND no skill matches:
  record as gap candidate
```

Good gap candidates:
- Repeated test fixture setup (same framework, same pattern)
- Repeated API response parsing
- Repeated environment configuration

Bad gap candidates (not worth a skill):
- Step appears once
- Trivial one-liner tasks
- Domain-specific to this one project

**Gaps are proposals, never automatic.** Always output them in the `SKILL_GAPS` block for human review.

### Step 5: Escalation Rules

Pre-annotate known failure modes:

```
IF step involves testing or assertions:
  → ensure systematic-debugging LOAD: spec is available on escalation

IF step produces output for human review:
  → ensure verification-before-completion LOAD: capsule present

IF step involves AI-generated content:
  → check if confidence-check applies
```

Escalation means: the executor knows what to load if it hits a failure, without doing skill discovery itself.

## Output Format

### Annotated Plan (example)

```
TASK: implement_jwt_validation

STEP 1: Write failing test
USE_SKILL: test-driven-development LOAD: spec PRIORITY: critical
USE_SKILL: verification-before-completion LOAD: capsule PRIORITY: standard

ACTION:
Create test_expired_token() in tests/test_auth.py
Assert: expired token raises TokenExpiredError
Run: all tests should fail at this point

---

STEP 2: Implement minimal validation logic
USE_SKILL: test-driven-development LOAD: capsule PRIORITY: critical
USE_SKILL: fastapi LOAD: spec PRIORITY: standard

ACTION:
Implement validate_token() in auth/jwt.py
Only enough code to pass the failing test from STEP 1

---

STEP 3: Refactor
USE_SKILL: test-driven-development LOAD: capsule PRIORITY: standard

ACTION:
Extract token parsing logic
Add type hints
All tests still pass

---

STEP 4: Verify completion
USE_SKILL: verification-before-completion LOAD: spec PRIORITY: critical

ACTION:
Run full test suite
Check coverage ≥ 80%
Confirm no regressions
```

### SKILL_GAPS (example)

```
SKILL_GAPS:

  candidate: fastapi-endpoint-testing
  frequency: 7      ← appeared in 7 of 12 steps with no matching skill
  context:   pytest fixtures for FastAPI TestClient setup, repeated pattern
  creation_method: synthesize

  candidate: jwt-test-fixtures
  frequency: 4
  context:   creating test JWTs with different expiry/payload combos
  creation_method: quick_write
```

## What Skill Selector Does NOT Do

- **Does not execute tasks.** It annotates; executors execute.
- **Does not create skills.** It proposes gaps; human approves; synthesizer creates.
- **Does not replace using-agints.** `using-agints` handles session start and stack detection. Skill Selector handles plan annotation.
- **Does not run during execution.** It runs once, before dispatch. If a new skill is needed mid-execution, that's an escalation (pre-annotated) or a post-execution gap.
- **Does not load full SKILL.md files** for its own routing decisions. Only capsules.

## Relationship to CAPSULE.md Standard

The Skill Selector is the primary consumer of the `CAPSULE.md` format. Without Skill Selector, capsules are optional. With Skill Selector, capsules are required for any skill to participate in automated routing.

**This means:** every skill added to AGIntS MUST have a `CAPSULE.md`. Skills without capsules are invisible to the Skill Selector and will never be automatically injected.

## Lifecycle and When to Skip

**Skip Skill Selector when:**
- Library has < 5 skills (overhead not worth it)
- Plan has 1–2 steps (trivial dispatch)
- You are the executor, not the orchestrator

**Required when:**
- Library has 5+ skills
- Plan has 3+ independent microtasks
- Using subagent-driven-development or executing-plans

## Future Extensions

The current design covers the essential case. Potential future additions (not implemented):
- **Usage tracking**: log which skills were injected per plan → synthesizer gets real usage data
- **Skill performance metrics**: did plans with skill X have fewer iterations?
- **Adaptive bundles**: discover which skills are always injected together → formalize as bundle
- **Skill pruning proposals**: skills never injected in N plans → deprecation candidate
