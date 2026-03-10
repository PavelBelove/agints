# Writing Plans — Full Reference

## Why This Skill Exists

Plans written with vague steps ("add error handling", "update the auth module") produce ambiguous instructions that skilled agents still fail on. The agent has to guess what "add validation" means, where to put it, and how to test it. This skill enforces a writing standard that makes plans executable by a zero-context developer.

**Core assumption:** Write for someone who is a skilled programmer but knows nothing about this codebase, its tools, or its test conventions.

---

## Plan File Header

Every plan must start with this exact header:

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about the approach and key design decisions]

**Tech Stack:** [Key technologies, libraries, versions]

---
```

The `> **For Claude:**` directive is mandatory — it tells the executing agent which skill to use.

---

## Task Granularity

Each step is **one atomic action (2-5 minutes)**. Not "implement authentication" but:

```
Step 1: Write the failing test
Step 2: Run it — verify it fails
Step 3: Write minimal implementation
Step 4: Run tests — verify they pass
Step 5: Commit
```

This ensures:
- Tests are written before implementation (TDD enforced)
- Each step is verifiable
- Blockers surface early (at step 1-2, not step 3)

---

## Task Template

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/new_file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/test_new_file.py`

**Step 1: Write the failing test**

```python
# tests/exact/path/test_new_file.py
def test_function_returns_expected_value():
    result = my_function("input")
    assert result == "expected_output"
```

**Step 2: Run test — verify it fails**

```bash
pytest tests/exact/path/test_new_file.py::test_function_returns_expected_value -v
```
Expected: `FAILED — NameError: name 'my_function' is not defined`

**Step 3: Write minimal implementation**

```python
# exact/path/to/new_file.py
def my_function(input_val: str) -> str:
    return "expected_output"
```

**Step 4: Run test — verify it passes**

```bash
pytest tests/exact/path/test_new_file.py::test_function_returns_expected_value -v
```
Expected: `PASSED`

**Step 5: Commit**

```bash
git add tests/exact/path/test_new_file.py exact/path/to/new_file.py
git commit -m "feat: add my_function with initial implementation"
```
````

---

## Quality Checklist

Before saving the plan:

- [ ] Every file reference is an exact path from repo root
- [ ] Every code snippet is copy-paste-ready (no pseudocode)
- [ ] Every test step has the exact command + expected output (PASS or FAIL)
- [ ] Every task follows TDD order: test → fail → implement → pass → commit
- [ ] Plan header includes the executing-plans directive
- [ ] Plan is saved to `docs/plans/YYYY-MM-DD-<feature-name>.md`

---

## Execution Handoff

After saving, offer the two execution paths:

```
Plan complete and saved to docs/plans/<filename>.md.

Two execution options:

1. Subagent-Driven (this session)
   I dispatch a fresh subagent per task, review between tasks.
   Fast iteration, stays in this context.

2. Parallel Session (separate)
   Open a new Claude Code session in the worktree.
   Use executing-plans for batch execution with checkpoints.

Which approach?
```

**Option 1 (Subagent-Driven):** Invoke `subagent-driven-development` skill immediately.
**Option 2 (Parallel Session):** Guide user to open new session and invoke `executing-plans`.

---

## Common Mistakes

| Mistake | Problem | Fix |
|---------|---------|-----|
| "Update the auth module" | Which file? Which function? | `src/auth/handler.py:42-67` |
| "Add validation" | What validation? Where? | Exact code + test |
| "Run the tests" | Which tests? Expected output? | `pytest tests/auth/ -v` + `Expected: 3 passed` |
| Task = "Implement auth" | 1 task = 1 hour+ = not bite-sized | Split: token generation, validation, middleware, tests |
| Implementation before test | Violates TDD | Always: write failing test first |
| Pseudocode | "something like this..." | Real, runnable code |

---

## Relationship to Other Skills

`writing-plans` produces the plan. `executing-plans` executes it in batches. `subagent-driven-development` executes it task-by-task with subagents.

```
requirements → [writing-plans] → docs/plans/plan.md → [executing-plans or subagent-driven-development] → working code
```
