# Confidence Check — Full Reference

## Overview

The confidence-check skill prevents the most expensive failure mode in agentic development: building the right thing wrong, or building the wrong thing right. It enforces a structured pre-implementation gate that requires ≥90% confidence before any code is written.

**ROI**: Spending 100–200 tokens on the check saves 5,000–50,000 tokens of wrong-direction work (25–250x ROI).

**Origin**: Core concept from SuperClaude Framework (superclaude-org), hardened with anti-rationalization rules from production experience.

---

## When to Use

Use this skill BEFORE:
- Writing any new code or making significant changes
- Starting a bug fix or performance improvement
- Implementing a feature in an existing codebase
- Any task where undoing wrong-direction work would cost >500 tokens

Do NOT use for:
- Obvious 1-line typo fixes where location is certain
- If a confidence check was already done for this task

---

## The 5 Checks

The algorithm produces a score from 0.0 to 1.0 (0–100%) across five weighted checks.

### Check 1: No Duplicate Implementations (25%)

**Goal**: Confirm no existing code already solves this problem.

**How to run**:
- Use `Grep` to search for similar function names, patterns, or logic
- Use `Glob` to find related modules or files
- Check project dependencies for libraries that provide this functionality

**PASS**: No duplicate found — proceed with new implementation.
**FAIL**: Duplicate found — point the agent/user to existing code instead.

**Common trap**: "I'll write my own because it's slightly different." — Even partial duplication is a signal to refactor, not duplicate.

### Check 2: Architecture Compliance (25%)

**Goal**: Confirm the solution fits the project's established patterns and tech stack.

**How to run**:
- Read `CLAUDE.md`, `PLANNING.md`, `README.md` for tech stack definition
- Identify the existing infrastructure (e.g., Supabase, Next.js, pytest)
- Confirm the proposed approach uses existing patterns, not new dependencies

**PASS**: Solution uses existing tech stack.
**FAIL**: Solution introduces unnecessary new dependencies or reinvents existing solutions.

**Example**: Project uses Supabase for auth → never add a custom JWT library.

### Check 3: Official Documentation Verified (20%)

**Goal**: Confirm API/library usage against current official documentation.

**Why this matters**: APIs change between versions. Memory of an older API can cause subtle bugs that are hard to diagnose. Example: Redis 3.x → 4.x introduced breaking changes in client API.

**How to run**:
- Use `WebFetch` to pull current API reference for libraries in scope
- Use `WebSearch` if the URL is unknown
- Verify the specific methods/signatures being used

**PASS**: Official docs consulted, usage confirmed.
**FAIL**: Relying on memory or training data without fresh verification.

**Zero points for**: Saying "I know this API" without looking it up.

### Check 4: Working OSS Reference Found (15%)

**Goal**: Find a production-proven implementation to learn from and validate approach.

**Quality tiers**:
| Quality | Score | Criteria |
|---------|-------|----------|
| Production-grade | 15/15 | >1000 GitHub stars OR active maintenance (<3 months) |
| Active lower-quality | 8/15 | Active but <1000 stars |
| Zero credit | 0/15 | <100 stars AND unmaintained (>1 year no commits) |

**How to run**:
- Use `WebSearch` or GitHub search
- Look for libraries used in production (check stars + recent commits)

**Why this matters**: Proven implementations have handled edge cases (race conditions, network partitions, conflicts) that a custom design will miss.

**Zero points for**: Finding a 50-star 2-year-old hobby project.

### Check 5: Root Cause Identified (15%)

**Goal**: For fixes and improvements, diagnose the actual problem before implementing a solution.

**When this check applies**:
- Task contains keywords: fix, improve, slow, broken, error, leak, crash, optimize
- Symptoms are visible but cause is unconfirmed

**When this check is N/A (auto-pass)**:
- Purely new feature with no bug/performance component
- Example: "Build user authentication system" — root cause check is not applicable

**How to run**:
- Analyze error messages, logs, stack traces
- Use profiler output or metrics for performance issues
- Identify the specific failing component, not just the symptom

**PASS**: Root cause clearly identified with evidence.
**FAIL**: Solving symptoms without diagnosis ("API slow → add caching" without profiling).

---

## Score Thresholds

```
Total = Check1(25%) + Check2(25%) + Check3(20%) + Check4(15%) + Check5(15%)

≥90%  → PROCEED     — implement with confidence
≥70%  → CLARIFY     — present gaps, ask specific questions
 <70%  → STOP        — request more context, do NOT implement
```

**Thresholds are exact.** 89.9% = CLARIFY, not PROCEED. No rounding.

---

## Anti-Rationalization Reference

Agents systematically rationalize skipping checks. Here are the most common patterns and counters:

| Rationalization | Why it fails | Rule |
|----------------|-------------|------|
| "User seems confident" | User's stated confidence ≠ calculated score | Algorithm overrides stated confidence |
| "Simple task, skip validation" | Simple tasks often duplicate existing code | No task too simple to validate |
| "I know the API" | APIs change; memory is fallible | Always verify official docs |
| "I can design this" | Custom designs miss edge cases proven OSS handles | OSS research is mandatory for complex features |
| "Obvious problem" | "Obvious" problems often have non-obvious causes | Diagnose before prescribing |
| "85% is close enough" | 5% gap reveals critical missing validation | Thresholds are exact |
| "Authority override" | Algorithm is objective | No authority exceptions |
| "Emergency bypass" | Wrong fix wastes more time than 2-minute check | Emergency reduces (not removes) checks |
| "Within margin of error" | 89.9% = incomplete validation | 90.0% means 90.0% |
| "Found some OSS" | Hobby projects don't prove production viability | Quality criteria apply |
| "New feature, skip root cause" | Improvements/fixes masquerading as features | Check keywords in task description |

---

## Emergency Mode

When production is down or a critical blocker exists:

**May skip with assumed PASS**: Official docs (20%), OSS reference (15%)
**Remain mandatory**: Duplicate check (25%), Architecture (25%), Root cause (15%)

Rationale: The 65% from mandatory checks provides enough safety. Skipping duplicate and architecture checks in an emergency causes more damage than the emergency itself.

---

## Phase-Specific Checklists

For multi-phase workflows (spec → design → tasks → implementation), you can run phase-specific versions:

### Pre-Spec (Idea → Spec)
| Check | Weight | Key Question |
|-------|--------|--------------|
| Problem validated | 25% | Evidence people have this problem? |
| Market gap | 25% | Room for new solution? |
| Target audience | 20% | WHO specifically? |
| Value proposition | 15% | Why would they switch/pay? |
| Capability fit | 15% | Can this actually be built? |

### Pre-Design (Spec → Design)
| Check | Weight | Key Question |
|-------|--------|--------------|
| Requirements clear | 25% | All requirements unambiguous? |
| Acceptance criteria testable | 25% | All AC measurable? |
| No contradictions | 20% | Requirements don't conflict? |
| Scope defined | 15% | Clear what's NOT included? |
| Dependencies known | 15% | External systems identified? |

### Pre-Task (Design → Tasks)
| Check | Weight | Key Question |
|-------|--------|--------------|
| Architecture decided | 25% | No open technical questions? |
| Patterns established | 25% | Following codebase conventions? |
| No duplicate work | 20% | Existing implementations checked? |
| Dependencies mapped | 15% | Task order clear? |
| Complexity understood | 15% | Estimates reasonable? |

### Pre-Implementation (Task → Code)
This is the standard 5-check algorithm described above.

---

## Output Format

```
Confidence Checks:
  [PASS] No duplicate implementations — searched for <pattern>, none found
  [PASS] Architecture compliance — solution uses <existing-tech>
  [FAIL] Official docs not verified — assumed from memory
  [PASS] OSS reference — <lib> (18k stars, active)
  [PASS] Root cause identified — profiler shows N+1 query in <file>

Score: 80% — CLARIFY

Questions to answer first:
1. Which version of <library> is this project using? Docs link needed.
```

---

## The TypeScript Reference Implementation

The `confidence.ts` file in the original SuperClaude source demonstrates:
- `ConfidenceChecker.assess(context)` — runs all 5 checks
- `getRecommendation(score)` — maps score to action string
- Context interface with boolean flags for each check

The TypeScript implementation is useful as a reference for automated testing harnesses but the skill itself is primarily a cognitive protocol for the agent to follow, not code to execute.

---

## Related Skills

- **systematic-debugging** — use when root cause check (Check 5) fails
- **test-driven-development** — use after confidence-check passes to begin implementation
- **verification-before-completion** — the post-implementation counterpart to this skill
