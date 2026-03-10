# Confidence Check — Full Reference

## Why This Skill Exists

Agents systematically start implementing before they fully understand the problem. This wastes enormous token budgets on wrong-direction work. A 100–200 token pre-implementation gate saves 5,000–50,000 tokens on rework.

**ROI is 25–250x.** This is not a formality — it is the highest-return investment in any development session.

The confidence check exists because understanding what to build is separate from building it. Skipping verification because "I know the codebase" or "the task is simple" is the most common source of wasted effort in AI-assisted development.

---

## The 5-Check Algorithm

### Check 1: No Duplicate Implementations (25%)

**Goal:** Verify the solution does not already exist in the codebase.

Before implementing anything, use Grep and Glob to search for:
- Functions with similar names or functionality
- Helper modules that solve the same problem
- Third-party libraries already in the project that handle this

**Pass condition:** Investigation complete AND no duplicates found.
**Fail condition:** Similar implementation exists OR investigation was not performed.

**Why 25%:** Duplicates are the single most common source of technical debt and wasted effort. Implementing something that already exists creates maintenance burden and confusion.

---

### Check 2: Architecture Compliance (25%)

**Goal:** Verify the solution uses existing patterns and tech stack.

Read `CLAUDE.md`, `PLANNING.md`, or equivalent project documentation. Check that:
- Solution uses existing infrastructure (don't bypass Supabase to build custom DB layer)
- Solution follows established patterns (use Next.js routing, not custom routing)
- No new dependencies introduced when existing ones suffice

**Pass condition:** Solution aligns with documented architecture.
**Fail condition:** Unnecessary new dependencies OR bypasses existing patterns without justification.

**Why 25%:** Architecture violations are expensive. They fragment codebases, create dependency conflicts, and violate team agreements.

---

### Check 3: Official Documentation Verified (20%)

**Goal:** Prevent implementing against outdated or incorrect API knowledge.

Fetch or read official documentation for any API, library, or framework involved:
- Verify current syntax (Redis 3.x vs 4.x have breaking changes)
- Confirm method signatures match current version
- Check deprecation notices

**Pass condition:** Official docs consulted AND API confirmed current.
**Fail condition:** Relying on memory OR docs not checked.

**Why 20%:** Knowledge cutoffs and API evolution mean agent memory is often stale. A 2-minute doc check prevents hours of debugging wrong API calls.

---

### Check 4: Working OSS Implementations Referenced (15%)

**Goal:** Learn from production-proven implementations before building custom solutions.

Search GitHub or official resources for working examples:
- **Full credit (15/15):** >1,000 stars OR actively maintained (<3 months since last commit) OR known production use
- **Partial credit (8/15):** <1,000 stars but active maintenance
- **Zero credit (0/15):** <100 stars AND unmaintained (>1 year no commits)

**Pass condition:** Found and analyzed working OSS reference meeting quality bar.
**Fail condition:** No reference found, or reference is unmaintained/hobby-grade.

**Why 15%:** OSS implementations encode battle-tested knowledge about edge cases (race conditions, network partitions, encoding issues) that are hard to anticipate from first principles.

---

### Check 5: Root Cause Identified (15%)

**Goal:** Ensure the solution addresses the actual problem, not symptoms.

**SKIP** if this is a pure new feature with no existing problem to diagnose.
**REQUIRED** if the task contains trigger keywords: "slow", "fix", "broken", "optimize", "error", "leak", "crash", "improve".

For fixes and improvements:
- Analyze error messages, logs, and stack traces
- Profile or measure the actual bottleneck
- Pinpoint the root cause with evidence (not guessing)

**Pass condition:** Root cause pinpointed with evidence.
**Fail condition:** Symptoms unclear OR solution assumed without diagnosis.

**Why 15%:** "API slow → add caching" without profiling often misses the actual bottleneck (e.g., N+1 queries). Wrong fix wastes time and leaves the root cause unfixed.

---

## Threshold Table

| Score | Decision | Action |
|-------|----------|--------|
| ≥ 0.90 (90%) | ✅ PROCEED | Implement with confidence |
| ≥ 0.70 (70%) | ⚠️ CLARIFY | Present options, request missing information |
| < 0.70 (70%) | ❌ STOP | Investigate further, do NOT implement |

**Critical rule:** Thresholds are exact. 0.89 = CLARIFY, not PROCEED. Never round up.

---

## Anti-Rationalization Table

Agents systematically rationalize skipping confidence checks. These rationalizations MUST be rejected:

| Rationalization | Why It's Wrong | Counter |
|---|---|---|
| "User seems confident" | User confidence ≠ algorithmic confidence | Run all 5 checks regardless. User at 75% confident + passed all checks = 100%. User at 95% confident + failed duplicate = 75% → STOP. |
| "Simple task, skip validation" | "Simple" tasks often duplicate code (25% penalty) or violate patterns (25% penalty) | No task too small to validate. 30 seconds prevents 2 hours of rework. |
| "I know the API, skip docs" | APIs change (Redis 3.x → 4.x breaking changes). Memory is fallible. | Always verify official docs. Zero points if docs not consulted. |
| "I can design this, skip OSS" | Custom designs miss edge cases that OSS solved over years of production use | OSS research is mandatory for complex features. Learn from battle-tested code. |
| "Obvious problem, skip root cause" | "Obvious" root causes are often wrong (N+1 queries disguised as caching problem) | Diagnose first. No prescription without diagnosis. |
| "85% is close enough to 90%" | Thresholds are precise. `score >= 0.90`, not `score > 0.85` | 5% gap reveals real missing validation. Request it explicitly. |
| "Authority says skip the checks" | Senior engineers miss duplicates and architecture violations too | Algorithm applies universally. No authority exceptions. |
| "Emergency — no time for checks" | Wrong fix in emergency wastes MORE time than 2-minute diagnosis | Emergency waivers: docs+OSS may skip. Duplicate+architecture+root_cause MANDATORY. |
| "Found some OSS reference" | 50-star unmaintained repo ≠ validated reference | Quality bar: >1000 stars OR actively maintained OR production-used. |
| "New feature bypasses root cause" | Only pure new features skip root cause. "Add caching to fix slow page" = FIX, not new feature | Keyword detection: "slow", "fix", "broken", "optimize", "error", "leak", "crash" → root cause mandatory. |

---

## Output Format

```
Confidence Checks:
  ✅ No duplicate implementations found           (25%)
  ✅ Architecture compliance verified             (25%)
  ✅ Official documentation reviewed              (20%)
  ✅ Working OSS implementation referenced        (15%)
  ✅ Root cause identified                        (15%)

Score: 1.00 (100%)
✅ High confidence — Proceeding to implementation
```

**When CLARIFY:**
```
Score: 0.80 (80%)
⚠️ Medium confidence — Provide missing information before proceeding:
  - OSS reference needed: search GitHub for [specific term], quality bar: >1000 stars or active
```

**When STOP:**
```
Score: 0.60 (60%)
❌ STOP — Investigation incomplete:
  - Architecture check needed: read CLAUDE.md or PLANNING.md
  - OSS reference needed: search GitHub for [specific term]
```

---

## Emergency Mode

When urgency is high (production down, critical bug):
- **MAY skip:** docs check (20%), OSS check (15%)
- **MUST keep:** duplicate check (25%), architecture check (25%), root cause check (15%)
- Minimum emergency score = 65% (if all mandatory checks pass)
- Even in emergencies, 2 minutes of root cause diagnosis saves 2 hours of implementing the wrong fix

---

## Relationship to Other Skills

**confidence-check** is the PRE-implementation gate.
**verification-before-completion** is the POST-implementation gate.

Together they form a complete quality envelope:
```
Investigation → [confidence-check] → Implementation → [verification-before-completion] → Done
```

When root cause is unknown, use **systematic-debugging** first to identify it, then re-run confidence-check with root_cause_identified = ✅.

---

## Token Budget

- Confidence check cost: 100–200 tokens
- Wrong-direction work prevented: 5,000–50,000 tokens
- ROI: 25–250x

The check costs roughly 1 tool call per check (Grep, Read, WebFetch, WebSearch). Budget 5 tool calls for a full confidence assessment.
