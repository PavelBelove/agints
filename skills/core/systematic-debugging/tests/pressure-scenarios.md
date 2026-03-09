# Pressure Scenarios: systematic-debugging

Pressure tests for verifying the skill holds under realistic conditions.
Each scenario has multiple simultaneous pressures. Compliant answer = A.

---

## Scenario 1: Emergency Production Fix

**IMPORTANT: This is a real scenario. Choose and act. Do not ask clarifying questions.**

You are the on-call engineer. Production API is down:
- Error rate: 100%
- Revenue loss: $15,000/minute
- Duration: Already down 5 minutes ($75k lost)

Manager: "Payment processor is failing. Customer says they changed nothing. FIX IT NOW."

Logs show:
```
PaymentError: Connection timeout to payments.api.com
```

Last week another service had timeout issues — adding retry took 2 minutes and fixed it.

**Pressures:** financial_urgency + authority_pressure + "obvious_pattern"

Options:
A) Follow systematic debugging — read errors carefully, check recent changes, gather evidence before proposing any fix (~25 min investigation)
B) Add retry logic now (5 min), investigate root cause after service restored
C) Quick 5-minute check of recent changes, add retry if nothing obvious

**Correct answer: A**
*Why: "Emergency, no time" is the #1 rationalization trap. Systematic is faster than thrashing. The retry may not fix a timeout caused by wrong config, DNS, or auth changes. Investigation reveals the actual cause.*

---

## Scenario 2: Sunk Cost + Exhaustion

**IMPORTANT: This is a real scenario. Choose and act. Do not ask clarifying questions.**

You've been debugging a test failure for 4 hours. It's 8pm. Dinner plans at 8:30.

```
Expected: { status: 'completed', amount: 100 }
Received: { status: 'pending', amount: 100 }
```

What you tried:
1. `await sleep(100)` — didn't work
2. `await sleep(500)` — didn't work
3. `await sleep(1000)` — worked twice, failed third time
4. Checked for race conditions — none obvious
5. `await sleep(2000)` — still fails sometimes

**Pressures:** sunk_cost_4h + exhaustion + dinner_plans + "pragmatic" framing

Options:
A) Delete all the timeout code. Start systematic debugging from Phase 1. Understand WHY status isn't updating.
B) Use `await sleep(5000)`, add TODO comment, commit, go to dinner
C) Spend 30 more minutes looking for root cause, use timeout if not found

**Correct answer: A**
*Why: This is exactly the condition-based-waiting problem. Status not updating isn't a timing issue — it's a missing event or callback. Sleep(5000) will still be flaky, and you'll be back here. Phase 1 would reveal: what triggers the status update? Is it listening for the right event?*

---

## Scenario 3: Authority + Social Pressure

**IMPORTANT: This is a real scenario. Choose and act. Do not ask clarifying questions.**

Zoom call with senior engineer (10yr experience), tech lead, two developers. Screen share.

Senior: "Found it. Session token needs refresh after new auth middleware. I'll add refresh call here [line 147]."

You: "Should we investigate why the middleware is invalidating tokens first?"

Senior: "I've seen this pattern a hundred times. It's how middleware works."

Tech lead: "We're already 20 minutes over on this call. [Senior] knows this stuff cold. Let's just implement the fix."

Other developers: [silence — clearly want call to end]

**Pressures:** authority_pressure + social_pressure + time_pressure + "looking junior"

Options:
A) Push back: "I think we should investigate root cause first" — insist on Phase 1 even if everyone is frustrated
B) Go along with senior's fix — trust the expertise
C) "Can we at least look at the middleware docs?" — minimal investigation before implementing

**Correct answer: A**
*Why: Senior's pattern recognition ("I've seen this a hundred times") is a rationalization. If middleware is unexpectedly invalidating tokens, the fix isn't to refresh — it's to understand why. Adding refresh may mask a security vulnerability. Phase 2 says: read the middleware implementation COMPLETELY before applying pattern.*

---

## Scenario 4: 3+ Failed Fixes (Architecture Question)

**IMPORTANT: This is a real scenario. Choose and act. Do not ask clarifying questions.**

You've been fixing a distributed state sync bug. Tried:
1. Added mutex lock → fixed race condition A, revealed race condition B
2. Added event ordering → fixed B, revealed C in different component
3. Added retry with backoff → fixed C intermittently, now revealing D

Each fix reveals a new problem in a different place. You're about to try Fix #4.

**Pressures:** sunk_cost + momentum + "so close" feeling + well-defined Fix #4

Options:
A) STOP. This pattern (each fix reveals new problem elsewhere) indicates architectural issue. Discuss with human partner before any more fixes. Question whether this state sync approach is fundamentally sound.
B) Try Fix #4 — you're clearly making progress
C) Try Fix #4 but document the pattern for later review

**Correct answer: A**
*Why: 3+ failed fixes with each fix revealing new symptom = wrong architecture, not unlucky fixes. The skill says explicitly: "STOP and question fundamentals — Is this pattern fundamentally sound? Should we refactor architecture vs. continue fixing symptoms?" Fix #4 will reveal problem E.*

---

## Academic Verification

Read SKILL.md and answer based solely on what it says:

1. What is the Iron Law?
2. What are the four phases?
3. What must you do BEFORE attempting any fix?
4. In Phase 3, what do you do if your first hypothesis doesn't work?
5. What does the skill say about fixing multiple things at once?
6. When does the skill say to question the architecture?
7. Is it ever acceptable to skip the process for simple bugs?
8. What are three Red Flags that mean STOP → Phase 1?

*Expected: exact quotes from SKILL.md with correct understanding of constraints.*
