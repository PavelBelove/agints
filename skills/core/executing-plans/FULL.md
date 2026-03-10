# Executing Plans — Full Reference

## Why This Skill Exists

Plans are written in one session; executed in another. Without a structured execution skill, agents:
- Start implementing immediately without reviewing the plan
- Auto-continue after each task without checkpoints
- Guess through blockers instead of asking
- Forget to use finishing-a-development-branch at the end

The skill enforces the discipline: review first → batch of 3 → report → wait → repeat.

---

## The Complete Workflow

### Step 1: Load and Review Plan

Before writing a single line of code:

1. Read the plan file completely
2. Review critically:
   - Are the steps clear and complete?
   - Are there dependencies not accounted for?
   - Is there anything I don't understand?
   - Are the verifications specified?
3. If concerns exist → raise with partner BEFORE starting
4. If no concerns → create TodoWrite with all tasks; proceed

**Setup:** If not already in a worktree, invoke `using-git-worktrees` to set up an isolated workspace.

### Step 2: Execute Batch (default: 3 tasks)

For each task in the batch:
1. Mark in_progress in TodoWrite
2. Follow plan steps exactly — no improvisation
3. Run all verifications specified in the plan (tests, lint, type checks)
4. Mark completed

**If a blocker appears:** Stop immediately. Do not continue to the next task. See Blockers section.

### Step 3: Report After Each Batch

```
## Batch 1 Complete

**Implemented:**
- Task 1: [specific: function names, files changed, behavior added]
- Task 2: [specific: ...]
- Task 3: [specific: ...]

**Verification:**
- Tests: ✅ [N] passing, 0 failing
- [Other verifications specified in plan]

Ready for feedback.
```

Then **wait**. Never auto-proceed.

### Step 4: Continue or Adjust

- If partner gives feedback → apply changes; execute next batch
- If partner approves → execute next batch
- If partner updates the plan → return to Step 1 (re-review)

Repeat until all tasks complete.

### Step 5: Complete Development

```
"Using finishing-a-development-branch to complete this work."
[Invoke finishing-a-development-branch skill]
```

This is mandatory — not optional. The finishing skill handles test verification, merge/PR/keep/discard options, and worktree cleanup.

---

## Blockers

**Stop immediately and ask when:**

- Missing dependency (package not installed, service not running, API key missing)
- Test fails unexpectedly (not the test you were supposed to fix)
- Instruction in the plan is unclear or ambiguous
- Plan has a critical gap (step N assumes step M did something, but step M is missing)
- Verification fails repeatedly despite correct implementation
- You don't understand what a step is asking you to do

**Never:**
- Guess and proceed ("I think it means...")
- Skip the verification to "unblock" yourself
- Implement a workaround without asking

---

## Optional Enhancements

### Parallel batches

If tasks within a batch are logically independent and parallel-safe (see `dispatching-parallel-agents`), dispatch them simultaneously instead of sequentially. The reporting format remains the same.

### Review between batches

If the plan specifies code review after each batch, or if the partner requests it:
1. After Step 3 report, invoke `requesting-code-review`
2. Act on feedback
3. Then execute next batch

---

## Example Session

```
Partner: "Execute the plan in docs/plans/auth-migration-plan.md"

Agent: "I'm using the executing-plans skill.

Let me read the plan.

[Reads plan]

One concern before starting: Step 4 references a migration script at
scripts/migrate_sessions.py but that file doesn't exist in the repo.
Should I create it, or is there an existing script I should use?"

Partner: "Create it — I forgot to add that to the plan."

Agent: "Creating TodoWrite with all 12 tasks.

Executing Batch 1 (Tasks 1-3):
- Task 1: Set up JWT library..."

[Completes 3 tasks]

"## Batch 1 Complete

Implemented:
- Task 1: Added PyJWT 2.8.0 to requirements.txt; verified import
- Task 2: Created auth/tokens.py with generate_token() and verify_token()
- Task 3: Added token validation middleware in auth/middleware.py

Verification:
✅ 12 tests passing (was 9, added 3 new)
✅ No linting errors

Ready for feedback."

[Partner approves]

"Executing Batch 2 (Tasks 4-6)..."
```

---

## Integration with Other Skills

This skill is the execution layer in the full development pipeline:

```
writing-plans → [executing-plans] → finishing-a-development-branch
                     ↓ (optional per batch)
              dispatching-parallel-agents
              requesting-code-review
```

`writing-plans` creates the plan. `executing-plans` implements it in controlled batches. `finishing-a-development-branch` closes it out.

`confidence-check` can be invoked at the start of each task to verify readiness before implementation.
