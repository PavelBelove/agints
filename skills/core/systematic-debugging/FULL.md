# Systematic Debugging — Full Reference

## Why This Skill Exists

Random fixes waste time and create new bugs. Quick patches mask underlying issues. The natural urge when facing a bug is to immediately try something — but that urge is the enemy of good debugging.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

Real-world data from battle-tested debugging sessions:
- Systematic approach: 15–30 minutes to fix
- Random fixes approach: 2–3 hours of thrashing
- First-time fix rate: 95% (systematic) vs 40% (guessing)
- New bugs introduced: near zero vs common

---

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes. This is not a suggestion. It is not "usually good practice." It is an absolute rule that holds under all circumstances — including time pressure, social pressure, sunk cost, and authority pressure.

---

## When to Use

Use for **any** technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Never skip when:**
- Issue seems simple — simple bugs have root causes too, and systematic process is fast for simple bugs
- You're in a hurry — rushing guarantees rework; systematic is faster than thrashing
- Manager wants it fixed NOW — the empirical data is clear: systematic wins on time

---

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

#### 1. Read Error Messages Carefully
Don't skip past errors or warnings. They often contain the exact solution. Read stack traces completely. Note line numbers, file paths, error codes. This takes 2 minutes and can save hours.

#### 2. Reproduce Consistently
- Can you trigger it reliably?
- What are the exact steps?
- Does it happen every time?
- If not reproducible → gather more data, **don't guess**

A bug you can't reproduce consistently cannot be fixed reliably.

#### 3. Check Recent Changes
- What changed that could cause this?
- Git diff, recent commits
- New dependencies, config changes
- Environmental differences

Most bugs have a cause in recent changes.

#### 4. Gather Evidence in Multi-Component Systems

When the system has multiple components (CI → build → signing, API → service → database), **before proposing fixes**, add diagnostic instrumentation:

```
For EACH component boundary:
  - Log what data enters component
  - Log what data exits component
  - Verify environment/config propagation
  - Check state at each layer

Run once to gather evidence showing WHERE it breaks
THEN analyze evidence to identify failing component
THEN investigate that specific component
```

Example for a multi-layer CI/signing system:
```bash
# Layer 1: Workflow
echo "=== Secrets available in workflow: ==="
echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

# Layer 2: Build script
echo "=== Env vars in build script: ==="
env | grep IDENTITY || echo "IDENTITY not in environment"

# Layer 3: Signing script
echo "=== Keychain state: ==="
security list-keychains
security find-identity -v

# Layer 4: Actual signing
codesign --sign "$IDENTITY" --verbose=4 "$APP"
```

This reveals which layer fails: "secrets → workflow ✓, workflow → build ✗"

#### 5. Trace Data Flow

When the error is deep in the call stack, trace backward through the call chain until you find the original trigger. Fix at the source, not at the symptom.

See `root-cause-tracing.md` for the complete backward tracing technique with instrumentation patterns.

---

### Phase 2: Pattern Analysis

Find the pattern before fixing.

1. **Find Working Examples** — Locate similar working code in the same codebase. What works that's similar to what's broken?

2. **Compare Against References** — If implementing a pattern, read the reference implementation COMPLETELY. Don't skim — read every line. Understand the pattern fully before applying.

3. **Identify Differences** — What's different between working and broken? List every difference, however small. Don't assume "that can't matter."

4. **Understand Dependencies** — What other components does this need? What settings, config, environment? What assumptions does it make?

---

### Phase 3: Hypothesis and Testing

Scientific method applied to debugging.

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top of a failed fix

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

---

### Phase 4: Implementation

Fix the root cause, not the symptom.

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use `superpowers:test-driven-development` for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - If ≥ 3: STOP and question the architecture (see below)
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   Pattern indicating architectural problem:
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   STOP and question fundamentals:
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes.**

   This is NOT a failed hypothesis — this is a wrong architecture.

---

## Red Flags — STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- "One more fix attempt" (when already tried 2+)
- Each fix reveals new problem in different place

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

---

## Your Human Partner's Signals You're Doing It Wrong

Watch for these redirections:
- "Is that not happening?" — You assumed without verifying
- "Will it show us...?" — You should have added evidence gathering
- "Stop guessing" — You're proposing fixes without understanding
- "Ultrathink this" — Question fundamentals, not just symptoms
- "We're stuck?" (frustrated) — Your approach isn't working

**When you see these:** STOP. Return to Phase 1.

---

## Rationalization Traps

The most important bulletproofing element: seeing the exact shortcuts you might rationalize creates cognitive friction that stops you.

| Excuse | Reality |
|--------|---------|
| "Issue is simple, don't need process" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time for process" | Systematic debugging is FASTER than guess-and-check thrashing. |
| "Just try this first, then investigate" | First fix sets the pattern. Do it right from the start. |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it. |
| "Multiple fixes at once saves time" | Can't isolate what worked. Causes new bugs. |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely. |
| "I see the problem, let me fix it" | Seeing symptoms ≠ understanding root cause. |
| "One more fix attempt" (after 2+ failures) | 3+ failures = architectural problem. Question pattern, don't fix again. |

---

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

---

## When Process Reveals "No Root Cause"

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

---

## Supporting Techniques

These companion files are part of systematic debugging:

- **`root-cause-tracing.md`** — Trace bugs backward through call stack to find original trigger. Includes instrumentation patterns and a real worked example (5-level trace).

- **`defense-in-depth.md`** — After finding root cause, add validation at multiple layers to make the bug structurally impossible. Four-layer pattern: entry validation, business logic, environment guards, debug logging.

- **`condition-based-waiting.md`** — Replace arbitrary `setTimeout`/`sleep` delays with condition-based polling. Fixes flaky tests. Includes generic `waitFor()` implementation and domain-specific helpers.

- **`scripts/find-polluter.sh`** — Bisection script that finds which test creates unwanted files or state. Runs tests one-by-one, stops at first polluter.

## Related Skills

- **`superpowers:test-driven-development`** — For creating the failing test case in Phase 4, Step 1
- **`superpowers:verification-before-completion`** — Verify fix actually worked before claiming success
