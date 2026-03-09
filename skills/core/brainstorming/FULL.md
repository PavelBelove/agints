# Brainstorming — Full Reference

Prose companion to `SKILL.md`. Load on demand for details.

---

## Overview

Turns an idea into an approved design through structured dialogue. The only output is a call to writing-plans. Implementation does not begin until the user explicitly approves the design.

**Anti-pattern:** "This is too simple for a design." Wrong. Simple projects are exactly where unverified assumptions cause the most wasted time. The design can be short (a few sentences), but it must exist.

---

## Step 1: Context Research

Before asking questions — understand what already exists:
- Read key files, documentation, recent commits
- For complex codebases: launch parallel subagent researchers with different focuses:
  - "Find similar features and trace the implementation"
  - "Show the architecture and abstractions for this area"
  - "Analyze the current implementation of a similar feature"

## Step 2: Clarifying Questions

**One question at a time** — the cardinal rule. If a topic requires multiple questions, split them across separate messages.

Focus: purpose, constraints, success criteria.

Prefer multiple-choice when possible:
```
What approach to session storage?
A) In-memory (Redis)
B) JWT in cookie
C) Database
D) No preference — your call
```

For implicit requirements: ask explicitly. For example:
- Is backward compatibility needed?
- Which edge cases are critical?
- Are there performance requirements?

## Step 3: Three Approaches

Always propose 2–3 approaches. Never jump straight to one "correct" answer:

| Approach | Summary | Pros | Cons |
|---|---|---|---|
| **Minimal** | Minimal changes, maximum reuse | Fast, low risk | Technical debt |
| **Clean** | Clean architecture, elegant abstractions | Maintainability | More files, refactoring |
| **Pragmatic** | Balance of speed and quality | Fits most situations | Compromises throughout |

Lead with a recommendation and explain why it fits this specific context.

## Step 4: Design Presentation

Cover these sections (depth of each scales with complexity):
- **Architecture** — components, how they interact
- **Data flow** — where data comes from, where it goes, how it is transformed
- **Error handling** — what errors exist, how they are handled
- **Testing** — what is tested and how

After each section: "Does this look right?" — do not wait until the entire design is finished.

Apply YAGNI ruthlessly: remove everything that "might be useful" but is not needed now.

## Step 5: Documentation and Handoff

Save the final design to `docs/plans/YYYY-MM-DD-<topic>-design.md` and commit it.

After approval — invoke **only** `writing-plans`. Do not invoke any other implementation skills.

---

## Example Questions by Focus Area

**Purpose:**
- What problem does this feature solve?
- Who will use it?

**Constraints:**
- Are there performance requirements?
- Is backward compatibility needed?
- Deadline / time constraints?

**Success:**
- How will we know the feature works correctly?
- Which edge cases are critical?
- What is the minimum acceptable result (MVP)?
