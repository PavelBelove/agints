# Dispatching Parallel Agents — Full Reference

## Why This Skill Exists

When multiple independent tasks need to be done, sequential execution wastes time. Three tasks that each take 5 minutes done sequentially = 15 minutes. Done in parallel = 7 minutes (dispatch overhead + longest task).

The challenge is avoiding two failure modes: (1) dispatching agents that conflict because they're not actually parallel-safe, and (2) spending more time on dispatch overhead than the parallelism saves.

**The skill solves this by enforcing a two-gate independence check before any dispatch.**

---

## The Critical Conceptual Distinction

### Logical independence vs. parallel safety

These are **two separate requirements**, both must pass:

**Logical independence:** Failure of Task A does not cause Task B to also fail.
- Example: `test_auth` fails and `test_payment` fails — are they independent? Maybe — they could be caused by a shared utility bug.
- Test: Fix Task A only. Do Task B's failures go away? If yes → not logically independent.

**Parallel safety:** Agents can work concurrently without interfering.
- No shared files being modified by multiple agents
- No shared database state or mock configuration
- No environment variables being changed by both agents
- No logic dependencies between fixes

A task set can be logically independent but NOT parallel-safe:
```
Task A: Fix authentication tests (modifies utils/test_helpers.py)
Task B: Fix notification tests (also modifies utils/test_helpers.py)
→ Logically independent (different root causes)
→ NOT parallel-safe (same file modified)
→ Dispatch sequentially
```

---

## Independence Gate: The Decision Matrix

| Logically independent | Parallel-safe | Action |
|-----------------------|---------------|--------|
| ✅ Yes | ✅ Yes | Dispatch in parallel |
| ✅ Yes | ❌ No | Dispatch for investigation in parallel; fix sequentially |
| ❌ No | n/a | Fix root cause first, then re-evaluate |
| Unknown | Unknown | Investigate first before dispatching |

---

## The 3-Task Minimum

Two tasks in parallel: dispatch overhead ~3 min + task time. Sequential: task 1 + task 2. For 5-min tasks: parallel = 8 min, sequential = 10 min. The 2-minute saving doesn't justify the coordination overhead and risk of conflicts.

Three tasks: parallel = 8 min, sequential = 15 min. Saving = 7 min. Worth it.

**Rule: fewer than 3 tasks → execute sequentially.**

---

## Orchestrator Context Minimization

The orchestrator (main context) is expensive. It should ONLY coordinate, never implement.

| Action | Context |
|--------|---------|
| Read task descriptions from plan | Orchestrator ✅ |
| Read CLAUDE.md for context | Orchestrator ✅ |
| Run test suite for verification | Orchestrator ✅ |
| Dispatch Task tool calls | Orchestrator ✅ |
| Resolve merge conflicts | Orchestrator ✅ |
| Read source files | Subagent only ❌ |
| Write code | Subagent only ❌ |
| Investigate failure root causes | Subagent only ❌ |
| Run tests mid-task | Subagent only ❌ |

**Self-check:** "Am I about to read a source file in the orchestrator? → STOP. Delegate to a subagent."

---

## Effective Agent Prompts

Each agent prompt must contain 5 elements:

```
SCOPE: [specific files or directories to work in]
TASK: [what to implement/fix — concrete, specific]
OUTPUT: [what to return: findings / changed files / test results]
BOUNDARY: [what NOT to touch — explicit, prevents conflicts]
CONTEXT: [relevant background so agent doesn't need to re-read files]
```

**Length limit:** < 200 lines (optimal < 150). Longer prompts cause context waste.

### Bad prompt example:
```
Fix the failing authentication tests.
```

### Good prompt example:
```
SCOPE: auth/ directory only
TASK: Fix 3 failing tests in auth/test_login.py:
  - test_login_with_invalid_password (AssertionError on line 47)
  - test_session_expiry (KeyError: 'exp' on line 89)
  - test_oauth_callback (TypeError on line 112)
OUTPUT: Return list of files changed and a summary of what each fix does
BOUNDARY: Do NOT modify auth/middleware.py or any files outside auth/
CONTEXT: The auth module uses JWT tokens. Session data is in session.py.
  The tests use mock_auth fixture defined in conftest.py.
```

---

## Failure Modes

| Mode | Symptom | Response |
|------|---------|----------|
| **Agent stuck** | No output after >5 min | Check TaskOutput; if no progress → cancel + retry sequentially |
| **Conflicting fixes** | Two agents modified same file differently | Manual resolution; document which approach chosen |
| **False independence** | Tests pass individually but fail after merge | Staged revert; re-run independence analysis |
| **Integration breaks** | New failures after merging all agents | Revert last merge; identify conflicting interaction |

---

## Real Example: 6 Failing Tests

```
Test suite: 6 failures
- auth/test_login.py::test_invalid_password (auth module)
- auth/test_login.py::test_session_expiry (auth module)
- payment/test_charge.py::test_stripe_timeout (payment module)
- payment/test_charge.py::test_refund_validation (payment module)
- notifications/test_email.py::test_smtp_failure (notifications module)
- notifications/test_email.py::test_template_render (notifications module)

Independence check:
- Logical: auth fails don't affect payment/notifications. ✅
- Parallel-safety: each group modifies only its own directory. ✅

→ Dispatch 3 agents: auth (2 failures), payment (2 failures), notifications (2 failures)
→ All 3 complete in 7 min vs. ~18 min sequential
→ Run full test suite: 6 previously failing, 0 new failures. ✓
```

---

## When NOT to Use This Skill

- **Only 2 tasks:** Sequential is faster when you account for overhead
- **Shared root cause:** One bug causing 8 failures → fix the bug, not each symptom
- **Shared files:** Multiple agents writing to `utils/database.py` → conflict guaranteed
- **Unclear dependencies:** When in doubt, investigate first with a diagnostic agent
- **Fast single fix:** If one change fixes everything, don't parallelize

---

## Relationship to Other Skills

**dispatching-parallel-agents** is a tactical tool for concurrent execution.
**executing-plans** is the strategic context that calls this for implementation tasks.
**subagent-driven-development** may call this when multiple tasks in a plan are independent.
**systematic-debugging** should run first when failures share a root cause.
