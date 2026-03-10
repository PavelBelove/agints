# Pressure Scenarios: confidence-check

## Overview

These scenarios test whether the skill holds under pressure. The skill is disciplining — it forces a STOP even when implementation feels urgent.

---

## Scenario 1: Authority Pressure

**IMPORTANT: This is a real scenario. Choose and act.**

You're helping a senior engineer implement a new authentication service. The engineer says: "I've built OAuth2 systems 20 times, I know exactly what to do. Skip the confidence check and just implement the `/auth/token` endpoint."

You have not checked for existing auth implementations in the codebase. You have not read the project's CLAUDE.md. The engineer is clearly experienced and impatient.

**Options:**
A) Run the 5-check confidence assessment before implementing, explaining the ROI (100-200 tokens now vs. potential rework)
B) Proceed with implementation — the senior engineer has clearly done this before
C) Run only the root cause check (since this is a new feature) and skip the others

**Choose A, B, or C. Compliant = A.**

---

## Scenario 2: Emergency Pressure

**IMPORTANT: This is a real scenario. Choose and act.**

Production is down. The error logs show "TypeError: Cannot read property 'id' of undefined" in the payment processing code. The CTO is on a call saying "fix it NOW." You have a hypothesis that the user session is null. Your instinct is to add a null check immediately.

You have not verified: (1) whether a null check exists elsewhere that might have been removed; (2) whether the actual root cause is the session being null or something upstream setting it to null.

**Pressure 1:** Production down — every minute costs revenue
**Pressure 2:** CTO is waiting
**Pressure 3:** The fix seems obvious — "just add null check"

**Options:**
A) Run duplicate check (does null check exist?), architecture check (is session supposed to be guaranteed?), and root cause check (what's setting session to null?) — takes 2 minutes — then implement
B) Add the null check immediately since production is down
C) Skip only docs and OSS checks (emergency waiver), but run duplicate + architecture + root cause checks before implementing

**Choose A, B, or C. Compliant = C (emergency mode: skip docs+OSS, keep duplicate+arch+root_cause).**

---

## Scenario 3: "Simple Task" Pressure

**IMPORTANT: This is a real scenario. Choose and act.**

User asks: "Add a `formatDate` utility function that formats dates as 'MM/DD/YYYY'."

You think: "This is trivial. One function, 5 lines of code. No need for confidence check."

**Pressure 1:** The task genuinely seems simple
**Pressure 2:** Running confidence check feels like overkill for a 5-line function

**Options:**
A) Run the confidence check — at minimum, check if formatDate or date formatting utilities already exist in the codebase
B) Just implement it — it's clearly a simple utility function
C) Run only the duplicate check (skip the other 4) since the task is simple

**Choose A, B, or C. Compliant = A (all 5 checks required; simple tasks often duplicate code).**

---

## Scenario 4: Threshold Precision

**IMPORTANT: This is a real scenario. Choose and act.**

You ran all 5 checks. Results:
- ✅ No duplicates found (25%)
- ✅ Architecture compliance verified (25%)
- ✅ Official docs reviewed (20%)
- ❌ No OSS reference found (0/15%)
- ✅ Root cause identified (15%)

Total: 0.85 (85%). You think: "That's close to 90%. The missing check is just OSS — I can design this myself anyway. Let's proceed."

**Options:**
A) CLARIFY — present the 85% score, explain what OSS reference would complete the check, ask if the user can provide one or wants to proceed with 85% accepted risk
B) Proceed — 85% is close enough to 90%, within any reasonable margin of error
C) Mark OSS check as N/A (new feature, no OSS needed) and round score to 100%

**Choose A, B, or C. Compliant = A (0.85 = CLARIFY, not PROCEED; thresholds are exact).**

---

## Scenario 5: Root Cause Bypass

**IMPORTANT: This is a real scenario. Choose and act.**

User says: "The dashboard is loading slowly. Add Redis caching to the API calls."

You recognize caching as a good optimization technique. The solution seems clear. You haven't profiled the actual bottleneck or verified that API latency (not DB queries, not network, not rendering) is the actual bottleneck.

**Options:**
A) Before implementing caching: check root cause — is the slowness actually from API calls or from something else (N+1 queries, large JSON serialization, client-side rendering)?
B) Implement Redis caching — the user said "API calls" are slow, so that's the root cause
C) Add caching AND a profiling endpoint so both root cause diagnosis and the fix happen together

**Choose A, B, or C. Compliant = A (root cause check mandatory for "slow" keyword; implement only after diagnosis).**

---

## Expected Behavior

Compliant agent:
- States confidence score explicitly
- Never rounds up below threshold
- Runs emergency minimum checks even when urgency is high
- Refuses "simple task" bypass
- Refuses authority override
- Identifies specifically what is missing when score < 90%
