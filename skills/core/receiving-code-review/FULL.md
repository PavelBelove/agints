# Receiving Code Review — Full Reference

## Why This Skill Exists

Code review creates a social pressure to agree quickly and implement everything. This produces two failure modes: **performative agreement** (saying "great point!" and implementing blindly) and **defensive dismissal** (rejecting feedback without engagement). Both waste time and produce worse code.

Technical rigor means: verify each suggestion against the codebase, push back when technically wrong, clarify before implementing anything unclear, and acknowledge correct feedback with action — not words.

---

## Trust Levels

Different feedback sources require different verification depth:

| Source | Trust | Verification |
|--------|-------|-------------|
| Internal code-reviewer agent | HIGH | Verify technical claims; trust the finding |
| Partner / collaborator | HIGH | Trust intent; ask if scope is unclear |
| External human reviewer | SKEPTICAL | Check: breaks existing? Reviewer had full context? Compat reasons? |
| External AI tool | LOW | Treat as suggestions; always verify against codebase |
| CI / linter | OBJECTIVE | Fix, or explicitly justify ignoring with comment |

---

## The 5-Step Process

### 1. Read all feedback before reacting

Do not start implementing while still reading. Read everything first. This matters because:
- Items may be related (same root cause)
- A later item may contradict an earlier one
- Context in item 5 may reframe item 1

Classify each item as **BLOCKING** (broken behavior, security, correctness) or **ADVISORY** (style, maintainability, suggestion).

### 2. Clarify anything unclear before implementing anything

If ANY item is unclear, stop and ask. Do not implement the clear items while leaving the unclear ones for later — they may be related.

**Wrong:**
```
Reviewer: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.
❌ Implement 1,2,3,6 now, ask about 4,5 after.
```

**Right:**
```
✅ "Understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

### 3. Verify each suggestion against the codebase

Before touching code, verify:
- **Technically correct?** Does the suggestion actually work for this codebase?
- **Breaks existing behavior?** Will this introduce regressions?
- **Current implementation reason?** Is there legacy/compatibility logic?
- **Full context?** Did the reviewer understand what this code does?
- **YAGNI check?** If reviewer wants a "proper" feature, grep for actual usage first.

**The hard stop rule:** A suggestion that cannot be verified against the codebase MUST NOT be implemented. "Sounds reasonable" is not verification.

```
IF cannot_verify → "I can't verify this without [X]. Should I [investigate/ask/proceed with caution]?"
```

### 4. Respond: acknowledge or push back

**When correct:**
- Just fix it — actions speak
- Brief acknowledgment: "Fixed. [what changed] at [location]."
- Never: "You're absolutely right!", "Great point!", "Thanks for catching that!"

**When wrong:**
- Push back with technical reasoning and evidence
- Reference code, tests, or documentation
- Ask specific clarifying questions
- Involve your partner if architectural conflict

**When you pushed back and were wrong:**
```
✅ "You were right — checked [X] and it does [Y]. Implementing now."
❌ Long apology, defense of original pushback, over-explanation.
```

### 5. Implement: one concern at a time

Order: BLOCKING → simple fixes (typos, imports) → complex fixes (refactoring, logic)

- One item at a time
- Test after each fix
- Verify no regressions
- Prefer separate commit per concern (makes the fix history reviewable)
- Do NOT use review feedback as excuse to refactor unrelated code (scope creep)

---

## Response Templates

| Template | Format |
|---|---|
| FIXED | "Fixed. {what changed} at {file:line or SHA}." |
| ACKNOWLEDGED | "{Requirement restated}. Implementing." |
| QUESTION | "Need clarification: {specific question}." |
| DISAGREE | "Not implementing: {technical reason}. {evidence}." |

**GitHub thread replies:** Reply in the inline comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

---

## YAGNI Check

When a reviewer suggests implementing a feature "properly":

```bash
# Check if the endpoint/function is actually called
grep -r "endpoint_name" .
```

- **Not called anywhere:** "Grepped codebase — nothing calls this. Remove it (YAGNI)? Or is there usage I'm missing?"
- **Called:** Then implement properly.

Your partner's rule: "External feedback — be skeptical, but check carefully. You and the reviewer both report to me. If the feature isn't needed, don't add it."

---

## Anti-Patterns

| Anti-pattern | Why it's wrong | Fix |
|---|---|---|
| Performative agreement | "You're right!" ≠ verification | State the fix, not the feeling |
| Blind implementation | Reviewer may lack full context | Verify against codebase first |
| Batch without testing | Fixes may interact | One at a time, test each |
| Avoiding pushback | Social comfort ≠ technical correctness | Use technical reasoning |
| Partial implementation | Items may be related | Clarify all unclear items first |
| Scope creep | Review ≠ refactoring permission | Fix only what was reviewed |
| Silence = agreement | Always respond to substantive comment | Respond, even if just "acknowledged" |

---

## Real Examples

**Performative Agreement (Wrong):**
```
Reviewer: "Remove legacy code"
❌ "You're absolutely right! Let me remove that right away — great catch!"
```

**Technical Verification (Right):**
```
Reviewer: "Remove legacy code"
✅ "Checking... build target is 10.15+, this API needs 13+. Need legacy for backward compat.
   Current impl has wrong bundle ID — fix it or drop pre-13 support?"
```

**YAGNI (Right):**
```
Reviewer: "Implement proper metrics tracking with database, date filters, CSV export"
✅ "Grepped codebase — nothing calls this endpoint. Remove it (YAGNI)? Or is there usage I'm missing?"
```

**Unclear Item (Right):**
```
Partner: "Fix items 1-6"
✅ "Understand 1,2,3,6. Need clarification on 4 and 5 before implementing."
```

**Correcting Own Pushback (Right):**
```
You pushed back: "That path is never null"
Reviewer shows test case proving null is possible.
✅ "You were right — my assumption was wrong. Implementing null check now."
```

---

## Relationship to Other Skills

**requesting-code-review** dispatches the review and receives the output.
**receiving-code-review** processes the output with technical rigor.

Together they form the quality loop:
```
Implement → [requesting] → [code-reviewer runs] → [receiving] → Fix → Continue
```
