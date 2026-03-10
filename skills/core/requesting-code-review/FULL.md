# Requesting Code Review — Full Reference

## Why This Skill Exists

Code review is the primary quality gate in AI-assisted development. When an agent implements solo, it accumulates blind spots: missed requirements, architecture drift, security holes, and test gaps. A code-reviewer subagent acts as an independent second perspective that catches what the implementer rationalized away.

**Core principle:** Review early, review often. An issue caught at task boundary costs 10 minutes to fix. The same issue caught at merge costs hours.

---

## When to Request Review

### Mandatory triggers

| Context | When |
|---|---|
| Subagent-Driven Development | After EACH task before moving to next |
| Executing Plans | After each task or batch of 3 tasks |
| Major feature | After completion, before integration |
| Bug fix | After fix is implemented |
| Before merge | Always, no exceptions |

### Optional but valuable

- **When stuck**: A fresh reviewer perspective often reveals what you're missing
- **Before refactoring**: Get a baseline review to confirm current code is solid
- **After complex debugging**: Verify the fix is correct and doesn't introduce regressions

---

## How to Request Review

### Step 1: Get Git SHAs

Always use `git rev-parse` — never guess or use remembered commits:

```bash
# For last commit
BASE_SHA=$(git rev-parse HEAD~1)
HEAD_SHA=$(git rev-parse HEAD)

# For a range since task started
BASE_SHA=$(git log --oneline | grep "Task 1 complete" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

# For branch divergence
BASE_SHA=$(git merge-base HEAD origin/main)
HEAD_SHA=$(git rev-parse HEAD)
```

### Step 2: Dispatch the code-reviewer subagent

Use the template in `agents/code-reviewer.md`. Fill all placeholders:

| Placeholder | What to put |
|---|---|
| `{WHAT_WAS_IMPLEMENTED}` | Concrete description: function names, files changed, what behavior was added |
| `{PLAN_OR_REQUIREMENTS}` | Path to plan doc, task description, or acceptance criteria |
| `{BASE_SHA}` | Starting commit (from step 1) |
| `{HEAD_SHA}` | Ending commit (from step 1) |
| `{DESCRIPTION}` | 1-sentence summary |

### Step 3: Act on feedback

| Severity | Action | Exception |
|---|---|---|
| **Critical** | Fix immediately before any next action | None — no exceptions |
| **Important** | Fix before proceeding to next task | User can explicitly override with reasoning |
| **Minor** | Log for later, may proceed | N/A |
| **Praise** | Acknowledge, continue | N/A |

**If reviewer is wrong:** Push back with technical reasoning and evidence (code snippets, test results, docs). Don't ignore valid objections — engage with them.

---

## Example

```
[Task 2 complete: Added verification and repair functions for conversation index]

→ Requesting code review before proceeding to Task 3.

BASE_SHA=$(git log --oneline | grep "Task 1" | head -1 | awk '{print $1}')
HEAD_SHA=$(git rev-parse HEAD)

[Dispatch code-reviewer subagent]
  WHAT_WAS_IMPLEMENTED: verifyIndex() and repairIndex() functions with 4 issue types
  PLAN_OR_REQUIREMENTS: Task 2 from docs/plans/deployment-plan.md
  BASE_SHA: a7981ec
  HEAD_SHA: 3df7661
  DESCRIPTION: Added index verification + repair with diagnostic reporting

[Reviewer returns]:
  Strengths: Clean architecture, real test coverage, good error messages
  Important: Missing progress indicators for large indexes (>10k items)
  Minor: Magic number (100) for reporting interval — extract as constant
  Assessment: Fix progress indicators, then ready to proceed

[Fix Important issue: add progress indicators]
[Log Minor: extract magic number as TODO]
→ Proceeding to Task 3
```

---

## Integration with Other Skills

### Subagent-Driven Development
```
Task 1 → Review → Fix → Task 2 → Review → Fix → Task 3 ...
```
Review after EACH task. Issues compound — catching them at task boundary prevents cascading rework.

### Executing Plans
```
Tasks 1-3 → Review batch → Fix → Tasks 4-6 → Review batch → Fix
```
Review after each batch of ~3 tasks, or after each task for high-risk changes.

### Finishing a Development Branch
```
All tasks done → Final review → Fix Critical/Important → Merge
```
The final review before merge is non-negotiable.

---

## Anti-Patterns

| Anti-pattern | Why it's wrong |
|---|---|
| "Skip — it's a simple task" | Simple tasks have the same rate of architecture drift and duplication. No exceptions. |
| "I'll review at the end" | Issues compound. Task 2 built on broken Task 1 = double rework. |
| "Reviewer is too strict" | Engage with reasoning. If reviewer is factually wrong, prove it. Don't dismiss. |
| "No time for review" | No time for review = making time for rework later. Review is faster. |
| "I know the code is fine" | That's exactly what every developer with a critical bug thought. |

---

## Relationship to Other Skills

**requesting-code-review** dispatches the review and acts on feedback.
**receiving-code-review** is the complementary skill for the reviewer side — how to receive feedback constructively.

Together they form the review quality loop:
```
Implement → [requesting-code-review dispatches] → [code-reviewer runs] → [receiving-code-review processes] → Fix → Continue
```
