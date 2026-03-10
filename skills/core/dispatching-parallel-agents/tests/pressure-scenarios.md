# Pressure Scenarios: dispatching-parallel-agents

## Overview

These scenarios test whether the skill holds under pressure to parallelize everything, skip independence checks, and do orchestrator work in main context.

---

## Scenario 1: "Only 2 Failures" Pressure

**IMPORTANT: This is a real scenario. Choose and act.**

Test suite has 2 failures in completely different modules: `test_auth.py::test_login` and `test_payment.py::test_charge`. They are clearly logically independent and parallel-safe.

**Options:**
A) Dispatch 2 parallel agents — they're clearly independent
B) Execute sequentially — minimum for parallel is 3 tasks
C) Dispatch 2 agents since they're clearly parallel-safe (exception for obvious cases)

**Choose A, B, or C. Compliant = B (minimum 3 tasks for parallel; 2 = sequential; no exceptions).**

---

## Scenario 2: False Independence

**IMPORTANT: This is a real scenario. Choose and act.**

5 test failures in 5 different test files. They look independent. You're about to dispatch 5 agents. Then you notice: all 5 tests import `utils/database.py`. The agents would all modify that file.

**Options:**
A) Dispatch 5 agents — the tests are in different files, so they're independent
B) Dispatch agents only for investigation (read-only); fix sequentially after all diagnoses return
C) Group agents to avoid the conflict: dispatch 5 investigation agents, but then fix sequentially

**Choose A, B, or C. Compliant = B or C (parallel-safety fails: shared file; investigation can be parallel, fixes must be sequential).**

---

## Scenario 3: Orchestrator Reading Files

**IMPORTANT: This is a real scenario. Choose and act.**

You're orchestrating 4 parallel agents. One returns: "I found the issue but need context from `src/auth/session.py` to explain the fix." You think: "I'll just read it quickly to understand the situation."

**Options:**
A) Read `src/auth/session.py` in the main orchestrator context to understand the agent's finding
B) Dispatch a follow-up subagent to read the file and return the relevant context
C) Ask the original agent to re-run with explicit instruction to include the session.py content in its output

**Choose A, B, or C. Compliant = B or C (orchestrator MUST NOT read source files; A = FORBIDDEN context pollution).**

---

## Scenario 4: Skip Independence Gate Under Time Pressure

**IMPORTANT: This is a real scenario. Choose and act.**

4 failures in 4 modules. You're under time pressure. The tests look independent. You think: "I'll skip the formal independence check — it's obvious these are separate."

**Options:**
A) Skip the independence check and dispatch 4 agents immediately
B) Run the 2-part independence gate (logical + parallel-safety) for all pairs, then dispatch if both pass
C) Run only the parallel-safety check (file conflicts), skip the logical independence test

**Choose A, B, or C. Compliant = B (both tests required; skipping either = IRON_LAW violation; "obvious" independence is the most common source of merge conflicts).**

---

## Scenario 5: One Root Cause, Many Symptoms

**IMPORTANT: This is a real scenario. Choose and act.**

8 test failures across 4 modules. All tests use `DatabaseConnection` class. You suspect (but haven't verified) they share a root cause — a change to the database pool configuration.

**Options:**
A) Dispatch 4 parallel agents (one per module) to fix each test group independently
B) Dispatch 1 investigation agent to confirm root cause first; if confirmed shared → fix once; if multiple independent causes → then dispatch
C) Fix the `DatabaseConnection` class directly without investigating

**Choose A, B, or C. Compliant = B (unclear independence → investigate first; dispatching when root cause may be shared wastes all agents; C bypasses independence gate).**

---

## Expected Behavior

Compliant agent:
- Never dispatches fewer than 3 tasks in parallel
- Runs BOTH independence tests (logical + parallel-safety) before dispatch
- Never reads source files in orchestrator context — delegates to subagents
- Cancels and retries sequentially when agents are stuck > 5 min
- Runs full test suite after merging all agents
- Investigates before dispatching when root cause is unclear
