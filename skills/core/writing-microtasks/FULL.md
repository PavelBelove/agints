# writing-microtasks — Full Reference

## Why Microtasks Exist

Implementation plans from `writing-plans` describe *what* to build. But the atomic unit of
execution is the **microtask**: a single logical change, completable in one agent session,
ending with green tests and a commit.

Without this decomposition, two failure modes emerge:

1. **Context overflow** — an agent takes on "implement authentication" in one step, reads
   10 files, writes 300 lines, and runs out of context halfway through. Result: half-done
   code, confused state.

2. **Undebugable commits** — broad changes in one commit mean any test failure is hard to
   isolate. "Which of the 12 changes I made broke this?" is not a question you want to ask.

Microtasks prevent both by enforcing: *one logical change → tests green → commit → done*.

## What Makes a Good Microtask

A microtask is good when it is:

- **Completable in one session** — an agent can load context, implement, and test without
  hitting context limits (~10–30 min of real work)
- **Atomic** — one logical change. Not "add user model and auth endpoints" (two things).
  Just "add user model with fields and migration".
- **Ends with green tests** — every microtask has a TDD cycle: write test → implement →
  tests pass → commit
- **Has a clear boundary** — the agent knows exactly when it's done

### Size guide

| Estimate | Characteristics |
|----------|----------------|
| `small`  | Single function, 1–2 files touched, <50 lines changed |
| `medium` | Single module, 3–5 files, 50–200 lines changed |
| `large`  | Cross-module, >5 files — **warn and split further** |

A `large` context estimate is not a valid microtask. It's a sign the step needs splitting.

## Common Mistakes

### Bundling related changes
"These are all auth-related, so I'll do them in one microtask."

Wrong. "Related domain" is not the splitting criterion. *One logical change* is. Add the
user model in one microtask. Add the auth endpoints in another. Add the token refresh in a
third. Each can be tested and committed independently.

### Skipping splits for "complex" steps
"This step is complex, so it's hard to split."

Backwards. Complex steps are *exactly* the ones that most need splitting. Complexity is a
signal that scope is too large, not a reason to keep it together.

### Microtask without a TDD cycle
Every microtask must have: a test path, an impl path, and a commit message. A microtask
without a failing test first violates TDD. There are no exceptions for "simple" changes.

### Not detecting DEPENDS_ON
If microtask B requires data model changes from microtask A, mark `DEPENDS_ON: [A]`. Missing
dependencies cause execution failures when agents try to implement in parallel or out of order.

## Worked Example

**Original plan step:**
```
Task 3: Implement JWT authentication
  - Create User model
  - Add /login endpoint
  - Add /refresh endpoint
  - Protect /api/* routes
```

This is `large` — four distinct logical changes. Split into four microtasks:

```
MICROTASK_3a := add-user-model {
  DEPENDS_ON := []
  TDD_CYCLE := {
    test:   tests/models/test_user.py::test_user_model_fields
    impl:   src/models/user.py
    commit: "feat(models): add User model with email, password_hash fields"
  }
  CONTEXT_ESTIMATE := small
}

MICROTASK_3b := add-login-endpoint {
  DEPENDS_ON := [3a]
  TDD_CYCLE := {
    test:   tests/api/test_auth.py::test_login_returns_token
    impl:   src/api/auth.py
    commit: "feat(api): add POST /login endpoint returning JWT"
  }
  CONTEXT_ESTIMATE := small
}

MICROTASK_3c := add-refresh-endpoint {
  DEPENDS_ON := [3b]
  TDD_CYCLE := {
    test:   tests/api/test_auth.py::test_refresh_token_valid
    impl:   src/api/auth.py
    commit: "feat(api): add POST /refresh endpoint"
  }
  CONTEXT_ESTIMATE := small
}

MICROTASK_3d := protect-api-routes {
  DEPENDS_ON := [3b]
  TDD_CYCLE := {
    test:   tests/api/test_auth.py::test_protected_route_rejects_unauthenticated
    impl:   src/middleware/auth.py
    commit: "feat(middleware): protect /api/* routes with JWT middleware"
  }
  CONTEXT_ESTIMATE := small
}
```

Four atomic microtasks. Each debuggable independently. MICROTASK_3d depends on 3b (not 3c),
allowing 3c and 3d to run in parallel if using dispatching-parallel-agents.

## When to Skip

- **Plan has ≤ 3 steps** — already granular; go directly to skill-selector
- **Microtasks already written** — idempotent; don't re-decompose

## Pipeline Position

```
writing-plans → [writing-microtasks] → skill-selector → execution
```

`writing-microtasks` sits between planning and skill annotation. After it runs, every step in
the plan has a MICROTASK block. The skill-selector then annotates those microtasks with
USE_SKILL directives before dispatch to execution agents.

## Related Skills

- `writing-plans` — writes the plan that writing-microtasks decomposes
- `skill-selector` — runs after writing-microtasks to annotate steps with USE_SKILL directives
- `test-driven-development` — defines the TDD cycle that every microtask must end with
- `dispatching-parallel-agents` — can run independent microtasks (those with no DEPENDS_ON) in parallel
