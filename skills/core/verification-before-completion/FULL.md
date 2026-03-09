# Verification Before Completion — Full Guide

## Why This Skill Exists

The most common trust-destroying behavior in agentic development is false completion claims. An agent says "tests pass" without running them. An agent says "fixed!" after changing a line without verifying the symptom is gone. An agent delegates to a subagent, gets back a "success" report, and relays it as fact.

These aren't small mistakes. They break the human-AI partnership at its core. From field experience across 24 documented failure memories:

- Human partner said "I don't believe you" — trust permanently damaged
- Undefined functions shipped — would have crashed in production
- Missing requirements shipped — feature was incomplete but called done
- Time wasted on false completion → redirect → full rework loop

**The principle:** Claiming work is complete without verification is dishonesty, not efficiency.

**The core rule:** Evidence before claims, always.

---

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

"Fresh" means: run in THIS message exchange. A test run from five minutes ago, from the previous turn, from the agent you delegated to — none of these count. If you haven't run the verification command yourself in this response, you cannot claim it passes.

**Spirit over letter.** This rule is written broadly by intent. Using different words doesn't create an exemption:
- "I'm confident it works" = completion claim
- "This looks correct to me" = completion claim
- "Seems to be passing now" = completion claim
- "Great, that should do it!" = completion claim

All of these require running verification before speaking them.

---

## The Gate Function

Every time you are about to make any claim about work status, apply this gate:

```
1. IDENTIFY  — What command proves this claim?
               (If you can't name a command, you cannot make the claim)

2. RUN       — Execute the FULL command, fresh, complete, not cached
               (No shortcuts: run the whole test suite, not just one file)

3. READ      — Read the full output
               Check: exit code, failure count, error messages

4. VERIFY    — Does the output confirm the claim?
               IF NO  → State actual status with evidence ("2 tests still failing: X, Y")
               IF YES → Continue to step 5

5. CLAIM     — Make the claim WITH evidence attached
               ("All 34 tests pass [output: 34/34 pass, exit 0]")
```

**Skipping any step means you are lying, not verifying.** This is not hyperbole — it is a precise description of what happens when you assert without evidence.

---

## What Counts as Verification

The following table shows what each type of claim requires and what does NOT suffice:

| Claim | What It Requires | What Does NOT Suffice |
|-------|------------------|-----------------------|
| "Tests pass" | Test command output: 0 failures, exit 0 | Previous run, "should pass", linter clean |
| "Linter clean" | Linter output: 0 errors or warnings | Partial check, checking only changed files |
| "Build succeeds" | Build command: exit 0 | Linter passing, "logs look good" |
| "Bug fixed" | Test that exercises original symptom: passes | Code changed, assuming fix applied |
| "Regression test works" | Full red-green cycle verified | Test passes once without red phase |
| "Agent completed the task" | VCS diff showing actual changes | Agent report of success |
| "Requirements met" | Line-by-line checklist against original spec | Tests passing, "phase seems done" |
| "No regressions introduced" | Full test suite passing | Subset of tests passing |

---

## Red Flags — Stop and Verify

When you notice any of these, stop immediately and run verification before proceeding:

**Language signals:**
- "should work now" — stop, run it
- "probably passes" — stop, run it
- "seems to be working" — stop, run it
- "I think this is correct" — stop, check it
- "looks good to me" — stop, verify it

**Emotional signals:**
- "Great!" said before verification
- "Perfect!" said before verification
- "Done!" said before verification
- Relief that the work is over
- Desire to move on to the next task

**Situational signals:**
- About to run `git commit` without a test run
- About to create a PR
- About to close an issue or task
- About to hand off to another agent
- About to report completion to the human

**Delegation signals:**
- Agent said it succeeded
- Script printed no errors
- No obvious failures visible in log snippets

None of these are verification. They are precursors to verification.

---

## Rationalization Prevention

The following table maps common rationalizations to the correct response:

| Rationalization | Why It Fails | Correct Response |
|-----------------|--------------|------------------|
| "Should work now" | Assumption is not evidence | Run the command |
| "I'm confident" | Confidence ≠ evidence | Confidence means nothing without data |
| "Just this once" | Exceptions erode discipline permanently | No exceptions exist |
| "Linter passed" | Linter does not compile; compilation ≠ tests | Run the actual test suite |
| "Agent said success" | Agents produce false positives; report ≠ reality | Check VCS diff directly |
| "I'm tired" | Exhaustion increases error rate, doesn't excuse it | Rest or verify; no middle ground |
| "Partial check is enough" | Partial checks leave the unknown unknown | Run the full check |
| "Different words, rule doesn't apply" | Spirit of the rule covers intent, not just form | Re-read the Iron Law |
| "Previous run was fine" | State may have changed since then | Fresh run required |
| "It's a trivial change" | Trivial changes cause subtle regressions | Trivial to run = trivial to verify |

---

## Worked Patterns

### Tests

**Correct:**
```
[Runs: pytest tests/]
[Output: 34 passed in 1.2s]
All 34 tests pass.
```

**Incorrect:**
```
The fix looks correct. The tests should pass now.
```

### Regression Test (TDD Red-Green)

When writing a regression test to prevent a bug from recurring, verification requires the full cycle:

**Correct:**
```
1. Write test that exercises the original symptom
2. Run test suite → test PASSES (bug is still present at this point? Wrong test)
   Actually: if test passes before fix, it's not testing the bug → fix the test
3. Verify test fails when bug is present (remove fix temporarily)
4. Restore fix
5. Run test suite → test PASSES
6. "Regression test verified: red→green cycle confirmed"
```

**Incorrect:**
```
"I've written a regression test for that bug."
```
(Without the red-green cycle, you have no evidence the test actually catches the bug.)

### Build

**Correct:**
```
[Runs: make build]
[Output: Build successful. Exit code: 0]
Build passes.
```

**Incorrect:**
```
"Linter passed, so the build should be fine."
```
(Linter checks syntax and style. Compilation checks linkage, types, and more. They are different tools.)

### Requirements Checklist

**Correct:**
```
Re-reading the original spec:
- [x] Feature A: tested in test_feature_a.py — passes
- [x] Feature B: tested in test_feature_b.py — passes
- [ ] Feature C: no test found — INCOMPLETE

Phase NOT complete. Feature C still needs implementation.
```

**Incorrect:**
```
"Tests are passing, so the phase should be complete."
```

### Agent Delegation

**Correct:**
```
[Agent reported success]
[Checking: git diff --stat HEAD~1]
[Output: 3 files changed, 47 insertions(+), 12 deletions(-)]
Agent completed the task. Verified via VCS diff.
```

**Incorrect:**
```
"The agent said it completed successfully, so we're done."
```

---

## When This Rule Applies

**All of the following:**
- Any claim that work is done, complete, fixed, passing
- Any expression of satisfaction about work state
- Any positive statement about code correctness
- Before any commit, push, or PR creation
- Before closing any task or ticket
- Before moving to the next task in a plan
- Before reporting completion to a human
- After delegating to an agent or subagent

**The rule applies to:**
- Exact phrases ("tests pass")
- Paraphrases ("everything's good now")
- Synonyms ("sorted", "resolved", "working")
- Implications ("let's move on to the next step")
- Emotional signals ("great, that should do it!")

---

## Trust and Honesty

This skill is ultimately about honesty. Making unverified claims about work state isn't neutral optimism — it is a form of deception, even if unintentional. It puts the burden of verification on the human, who trusted the agent to do it. It wastes the human's time when the false completion is discovered. It damages trust in a way that takes many successful interactions to repair.

**Verification is not overhead. It is the work.**

Run the command. Read the output. Then claim the result.

---

## Related Skills

- **systematic-debugging** — when verification fails and you need to find root cause
- **test-driven-development** — red-green cycle for writing verification-first
- **confidence-check** — calibrating certainty about claims in ambiguous situations
