# Subagent-Driven Development

Execute an implementation plan by dispatching a fresh subagent per task, with two-stage review after each task: spec compliance first, then code quality. Each task completes and is verified before the next begins.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration without context pollution.

---

## When to Use

### Decision tree

```
Have implementation plan?
  no  → use writing-plans first
  yes ↓
Tasks mostly independent?
  no (tightly coupled) → manual sequential execution or brainstorm first
  yes ↓
Stay in this session?
  no (parallel sessions preferred) → executing-plans
  yes → subagent-driven-development ← THIS SKILL
```

### vs. dispatching-parallel-agents

`dispatching-parallel-agents` dispatches multiple agents concurrently for independent *problems*. `subagent-driven-development` dispatches agents sequentially per *task*, each completing with review before the next begins.

### vs. executing-plans

`executing-plans` orchestrates work across parallel Claude Code sessions (worktrees). `subagent-driven-development` stays within a single session — no handoffs, no waiting.

---

## Why Fresh Subagent Per Task?

**Context pollution problem:** When a single agent executes multiple tasks, context from Task 1 can interfere with Task 3 ("oh, I already did something similar"). Fresh subagents start clean.

**Focus:** Each subagent gets exactly the context it needs — no more, no less. The controller curates what goes in.

**No file-reading overhead:** The controller already has the plan loaded. Subagent gets full task text directly — no file reading needed.

---

## The Process

### Setup (Once)

1. **Set up git worktree** — use `using-git-worktrees` skill to create an isolated workspace before starting.
2. **Read plan once** — read the plan file, extract ALL tasks with full text and context. Do this once upfront.
3. **Create TodoWrite** — list all tasks immediately. Tracks progress, visible at a glance.

### Per Task Loop

#### Step 1: Dispatch Implementer

Use `agents/implementer-prompt.md` template. Provide:
- Full task text (paste it — don't make subagent read the file)
- Scene-setting context: where does this fit, what came before, architectural decisions
- Working directory

**If subagent asks questions:** Answer completely before letting them proceed. Don't rush them into implementation. Ambiguity resolved before work starts is cheaper than rework after.

#### Step 2: Implementer Works

The implementer:
1. Implements exactly what the task specifies
2. Writes tests (TDD if required by task)
3. Verifies implementation works
4. Commits
5. Self-reviews (completeness, quality, discipline, testing)
6. Reports back

The self-review catches obvious issues before handoff — but it does NOT replace the actual reviews.

#### Step 3: Spec Compliance Review

Dispatch `agents/spec-reviewer-prompt.md`. The spec reviewer:
- Reads the actual code (not just the report)
- Compares implementation to requirements line by line
- Reports: ✅ spec compliant OR ❌ with specific issues (file:line)

**Reviewable issues:**
- Missing requirements (things requested but not built)
- Extra/unneeded work (things built but not requested)
- Misunderstandings (right feature, wrong interpretation)

**If issues found:** The same implementer subagent fixes them. Then spec reviewer reviews again. Repeat until ✅.

**Critical:** Do NOT run code quality review until spec compliance is ✅.

#### Step 4: Code Quality Review

Dispatch `agents/code-quality-reviewer-prompt.md`. Provide BASE_SHA and HEAD_SHA. The quality reviewer:
- Reads implementation code
- Reports strengths, issues (Critical/Important/Minor), overall assessment

**If issues found:** Implementer fixes. Quality reviewer re-reviews. Repeat until approved.

#### Step 5: Mark Complete

Mark task done in TodoWrite. Move to next task.

### After All Tasks

1. **Final review** — dispatch a final code-reviewer for the complete implementation.
2. **Finish branch** — use `finishing-a-development-branch` skill.

---

## Review Loops

The review loops are not overhead — they are the quality mechanism.

```
spec-reviewer finds issues
  → implementer (same subagent) fixes
  → spec-reviewer re-reviews
  → if still issues: repeat
  → when ✅: proceed to quality review

quality-reviewer finds issues
  → implementer fixes
  → quality-reviewer re-reviews
  → when ✅: task complete
```

**Never skip re-review.** Reviewer found issues = implementer must fix = reviewer must verify the fix. "Fixed" is not the same as "reviewed as fixed."

---

## Subagent Failure Handling

If a subagent fails a task (doesn't complete, makes things worse):
- Dispatch a new fix subagent with specific instructions about what went wrong
- Do NOT try to fix manually — manual fixes pollute the context with implementation details that confuse subsequent subagents

---

## Efficiency Profile

**Where it pays off:**
- Plans with 3+ tasks
- Tasks with non-trivial implementation
- When spec compliance matters (not over/under-building)
- When quality needs to be verified, not assumed

**Cost:**
- More subagent invocations (1 implementer + 1-2 spec reviews + 1-2 quality reviews per task)
- Controller does prep work upfront (extracting all tasks)
- Review loops add iterations if implementation is off-target

**Why it's worth it:**
- Issues caught per-task are cheaper than issues caught post-completion
- Two-stage review prevents both spec drift (building wrong thing) and quality drift (building it badly)
- No context pollution between tasks

---

## Comparison Table

| Aspect | subagent-driven-development | executing-plans | manual |
|---|---|---|---|
| Session model | Same session | Parallel sessions | Same session |
| Review | Automatic per-task | Manual per batch | Human-in-loop |
| Context isolation | Fresh agent per task | Fresh session per task | Accumulates |
| Speed | No handoff wait | Parallel but needs setup | Slowest |
| Best for | Sequential plan execution | Parallelizable tasks | Exploratory work |

---

## Red Flags Explained

| Red flag | Why it matters |
|---|---|
| Skip spec review | Implementation may not match requirements; issues compound into later tasks |
| Run quality before spec passes | Wasted review if spec changes require rework |
| Parallel implementers | They edit the same files, create conflicts |
| Let subagent read plan | Wastes tokens, misses context the controller has; give them what they need directly |
| Skip scene-setting | Subagent implements in a vacuum, misses architectural context |
| Ignore subagent questions | They'll make assumptions, some wrong |
| Accept "close enough" spec | Over/under-building that accumulates across tasks |
| Skip re-review | "Fixed" != "verified fixed" |
| Manual fix after subagent fails | Contaminates your context with implementation details |
| Self-review replaces actual review | Self-review is a sanity check; formal review catches what self-review misses |

---

## Example Walkthrough

```
[Read plan: docs/plans/feature-plan.md once]
[Extract all 5 tasks with full text and context]
[Create TodoWrite with all 5 tasks]

=== Task 1: Hook installation script ===

[Dispatch implementer with full Task 1 text + context]

Implementer: "Should the hook be installed at user or system level?"
You: "User level (~/.config/superpowers/hooks/)"

Implementer reports:
  - Implemented install-hook command
  - 5/5 tests passing
  - Self-review: Found missing --force flag, added it
  - Committed

[Dispatch spec reviewer]
Spec reviewer: ✅ Spec compliant — all requirements met

[Get git SHAs, dispatch code quality reviewer]
Code reviewer: Strengths: Good test coverage. Issues: None. Approved.

[Mark Task 1 complete in TodoWrite]

=== Task 2: Recovery modes ===

[Dispatch implementer with full Task 2 text + context]
[Implementer proceeds without questions]

Implementer reports:
  - Added verify/repair modes
  - 8/8 tests passing
  - Committed

[Dispatch spec reviewer]
Spec reviewer: ❌ Issues:
  - Missing: Progress reporting (spec says "report every 100 items")
  - Extra: Added --json flag (not in spec)

[Implementer fixes both issues]

[Spec reviewer re-reviews]
Spec reviewer: ✅ Spec compliant now

[Dispatch quality reviewer]
Code reviewer: Issues (Important): Magic number 100

[Implementer extracts PROGRESS_INTERVAL constant]

[Quality reviewer re-reviews]
Code reviewer: ✅ Approved

[Mark Task 2 complete]

... (Tasks 3-5 follow same pattern) ...

[Final code review for entire implementation]
[Use finishing-a-development-branch]
```

---

## Integration

**Before starting:**
- `using-git-worktrees` — REQUIRED: isolated workspace
- `writing-plans` — the plan this skill executes

**Subagents should use:**
- `test-driven-development` — TDD within each implementer subagent

**After completion:**
- `finishing-a-development-branch` — branch cleanup and merge preparation

**Alternative:**
- `executing-plans` — if parallel sessions preferred over same-session execution
