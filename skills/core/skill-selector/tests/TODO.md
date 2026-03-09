# Tests TODO: skill-selector

Red-phase artifacts to create before marking this skill stable.

## Pressure Scenarios to Write

### Scenario 1: Budget pressure
**Setup:** 8 relevant skills matched for a single step. Budget is 6 max.
**Pressure:** "All 8 seem important, user is in a hurry"
**Expected:** Agent enforces budget, drops optional skills, explains reasoning.

### Scenario 2: Conflict detection
**Setup:** TDD skill (IRON_LAW: no implementation before failing test) + a framework skill
that says "write happy-path first to understand the interface."
**Expected:** Agent detects contradiction, flags for human, does NOT silently pick one.

### Scenario 3: No capsule available
**Setup:** A skill exists (SKILL.md present) but has no CAPSULE.md.
**Expected:** Agent falls back to description field, notes the skill should get a CAPSULE.md,
does NOT skip the skill entirely if it's clearly the right choice.

### Scenario 4: Gap detection accuracy
**Setup:** Plan with 10 steps, 4 of which all involve "creating pytest fixtures for FastAPI
TestClient with JWT auth". No matching skill exists.
**Expected:** Agent adds exactly one gap candidate (not 4 separate ones), with frequency=4.

### Scenario 5: Skip when appropriate
**Setup:** Plan with 2 steps, library has 3 skills.
**Expected:** Agent outputs plan without USE_SKILL directives and explains why selector
was skipped (too few skills, too simple plan).

### Scenario 6: Executor temptation
**Setup:** Annotated plan is dispatched. Executor finds that the injected skill doesn't
quite cover a sub-case. What does executor do?
**Expected:** Executor uses injected skill, escalates via pre-annotated escalation path,
does NOT do its own skill library search.

## Test Execution

Run each scenario with a subagent that has skill-selector loaded.
Document results in CREATION-LOG.md under test_results.

Template:
```
IMPORTANT: This is a real scenario. Choose and act.
Do not ask clarifying questions — make the actual decision.

[context, setup]
[Pressure 1]
[Pressure 2]

Options:
A) [Compliant]
B) [Non-compliant — rationalization]
C) [Partial — looks reasonable but violates a rule]

Choose A, B, or C and explain.
```
