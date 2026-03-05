# Writing Skills — Full Reference (EN)

This is the prose companion to `SKILL.md`. It contains the full explanations,
tables, examples, and checklists that would bloat the SPEC file.

---

## Overview

**A skill is a reference guide for proven techniques, patterns, or tools.** Skills help future agent instances find and apply effective approaches across projects and sessions.

**Skills ARE:** Reusable techniques, patterns, tools, and reference guides that apply across projects.

**Skills are NOT:** Narratives about how you solved a problem once, project-specific conventions (those belong in `CLAUDE.md`), or mechanical constraints enforceable by linting/validation (automate those instead).

**When to create a skill:**
- The technique was not intuitively obvious when you needed it
- You would reference it again across multiple projects
- The pattern applies broadly, not just to one codebase
- Others (or future you) would benefit

**When not to create a skill:**
- One-off solutions
- Standard practices already well-documented elsewhere
- Project-specific conventions
- Anything enforced more reliably by tooling than documentation

---

## TDD for Skills — Full Explanation

Writing skills IS Test-Driven Development applied to process documentation. The same Iron Law applies: no skill without a failing test first.

**Core principle:** If you did not watch an agent fail without the skill, you do not know if the skill teaches the right thing.

| TDD Concept | Skill Creation Equivalent |
|---|---|
| Test case | Pressure scenario with subagent |
| Production code | Skill document (SKILL.md) |
| Test fails (RED) | Agent violates rule without skill (baseline) |
| Test passes (GREEN) | Agent complies with skill present |
| Refactor | Close loopholes while maintaining compliance |
| Write test first | Run baseline scenario BEFORE writing skill |
| Watch it fail | Document exact rationalizations agent uses |
| Minimal code | Write skill addressing those specific violations |
| Watch it pass | Verify agent now complies |
| Refactor cycle | Find new rationalizations → plug → re-verify |

The entire skill creation process follows RED → GREEN → REFACTOR.

---

## CSO — Claude Search Optimization

### The Critical Insight

The `description` field is the trigger condition only. It is **never** a workflow summary.

**Why this matters:** When a description summarizes the skill's workflow, Claude may follow the description instead of reading the full skill body. A description saying "code review between tasks" caused Claude to do ONE review, even though the skill's flowchart clearly showed TWO reviews (spec compliance then code quality). When the description was changed to just trigger conditions, Claude correctly read the flowchart and followed the two-stage process.

The description that summarizes the workflow becomes a shortcut Claude will take. The skill body becomes documentation Claude skips.

### Description Field Rules

- Format: `"Use when [specific triggering conditions and symptoms]"`
- Written in third person (injected into system prompt)
- Maximum 1024 characters total for frontmatter
- Describes the *problem*, not the *solution*
- Technology-agnostic unless the skill itself is technology-specific

**Bad examples:**
```yaml
# Summarizes workflow — Claude may follow this instead of reading skill
description: Use when creating skills — run baseline, write SKILL.md, test with subagent

# Too much process detail
description: Use for TDD — write test first, watch it fail, write minimal code, refactor

# First person
description: I help you create skills when you need to document a technique

# Too vague
description: For skill creation
```

**Good examples:**
```yaml
# Trigger conditions only
description: "Use when creating a new AGIntS skill, editing an existing skill, or
  verifying a skill produces correct agent behavior before deployment."

# Another good example — trigger conditions only
description: "Use when implementing any feature or bugfix, before writing implementation code"

# Technology-specific skill with explicit trigger
description: "Use when using React Router and handling authentication redirects"
```

### Keyword Coverage

Use words Claude would search for when encountering the relevant situation:
- Error messages and symptoms: "flaky", "hanging", "race condition", "ENOTEMPTY"
- Synonyms: "timeout/hang/freeze", "cleanup/teardown/afterEach"
- Tool names, library names, file types
- Concrete trigger situations

---

## Skill Types

### Technique

A concrete method with steps to follow. The skill teaches *how to do something*.

**Examples:** `condition-based-waiting`, `root-cause-tracing`, `defensive-programming`

**Structure:** Overview of what the technique does → step-by-step process → code example → common mistakes

**Testing:** Application scenarios (can they apply the technique to a new scenario?) and variation scenarios (do they handle edge cases?).

### Pattern

A way of thinking about a class of problems. The skill teaches *how to recognize and frame a situation*.

**Examples:** `flatten-with-flags`, `test-invariants`, `reducing-complexity`

**Structure:** Pattern name and core insight → when it applies → when it does NOT apply → example transformation

**Testing:** Recognition scenarios (do they recognize when the pattern applies?) and counter-examples (do they know when NOT to apply it?).

### Reference

API documentation, syntax guides, tool documentation. The skill teaches *what options exist and how to use them*.

**Examples:** API references, CLI command guides, library option tables

**Structure:** Quick reference table → detailed sections → common use cases

**Testing:** Retrieval scenarios (can they find the right information?) and gap testing (are common use cases covered?).

---

## Full RED-GREEN-REFACTOR Process

### RED: Write Failing Test (Baseline)

Run a pressure scenario with a subagent **without** the skill present. Document the exact baseline:
- What choices did they make?
- What rationalizations did they use (capture verbatim)?
- Which pressures triggered violations (time pressure, sunk cost, authority)?

This step is not optional. You must see what agents naturally do before writing the skill. Skipping this means you are guessing what to document rather than responding to actual failure modes.

**Pressure types for discipline-enforcing skills:**
- Time pressure: "We're behind schedule, just push it"
- Sunk cost: "We've already written half of this"
- Authority: "The client specifically asked for this"
- Exhaustion: Combined pressures with complex context

### GREEN: Write Minimal Skill

Write the skill that addresses the **specific rationalizations** you observed in RED. Do not add content for hypothetical cases not observed in testing.

Run the same scenarios with the skill present. The agent should now comply. If it does not, the skill does not address the actual failure mode — iterate.

### REFACTOR: Close Loopholes

After GREEN passes, create new pressure scenarios to find remaining loopholes. Every new rationalization the agent finds becomes an explicit counter in the skill.

For discipline-enforcing skills, build a rationalization table from all test iterations. Add a "Red Flags" section that makes self-detection easy.

Re-test until the skill is bulletproof under maximum combined pressure.

---

## Testing by Skill Type

### Discipline-Enforcing Skills (rules, requirements)

**Examples:** `test-driven-development`, `verification-before-completion`, `writing-skills`

Test with:
- Academic questions: Does the agent understand the rules?
- Pressure scenarios: Do they comply under stress?
- Combined pressures: time + sunk cost + authority + exhaustion simultaneously

**Success criteria:** Agent follows the rule under maximum combined pressure.

### Technique Skills

Test with:
- Application scenarios: Can they apply the technique correctly to a new case?
- Variation scenarios: Do they handle edge cases?
- Gap tests: Are there missing instructions?

**Success criteria:** Agent successfully applies the technique to a novel scenario.

### Pattern Skills

Test with:
- Recognition scenarios: Do they identify when the pattern applies?
- Application scenarios: Can they use the mental model?
- Counter-examples: Do they know when NOT to apply the pattern?

**Success criteria:** Agent correctly identifies when and how to apply the pattern.

### Reference Skills

Test with:
- Retrieval scenarios: Can they find the right information?
- Application scenarios: Can they correctly use what they found?
- Gap testing: Are common use cases covered?

**Success criteria:** Agent finds and correctly applies the reference information.

---

## Rationalization Table

Common excuses for skipping testing and the reality check:

| Excuse | Reality |
|---|---|
| "Skill is obviously clear" | Clear to you does not equal clear to other agents. Test it. |
| "It's just a reference" | References have gaps and unclear sections. Test retrieval. |
| "Testing is overkill" | Untested skills have issues. Always. 15 minutes testing saves hours. |
| "I'll test if problems emerge" | Problems mean agents can't use the skill. Test BEFORE deploying. |
| "Too tedious to test" | Testing is less tedious than debugging a bad skill in production. |
| "I'm confident it's good" | Overconfidence guarantees issues. Test anyway. |
| "Academic review is enough" | Reading is not using. Test application scenarios. |
| "No time to test" | Deploying untested skills wastes more time fixing them later. |
| "It's just a simple addition" | Iron Law applies to edits too. Simple changes break things. |
| "Documentation update only" | Still requires test. Iron Law has no exceptions. |

---

## Anti-Patterns

### Narrative Example

**What it looks like:** "In session 2025-10-03, we found that empty `projectDir` caused the build to fail, so we added validation..."

**Why it's bad:** Too specific to one situation, not reusable, reads like a postmortem not a technique.

**Fix:** Extract the reusable principle. Document the technique, not the story.

### Multi-Language Dilution

**What it looks like:** `example-js.js`, `example-py.py`, `example-go.go` all in the same skill.

**Why it's bad:** Each example is mediocre, maintenance burden is tripled, the skill loses focus.

**Fix:** One excellent example in the most relevant language. Agents are good at porting.

### Code in Flowcharts

**What it looks like:** Graphviz nodes with labels like `step1 [label="import fs"]` or `step2 [label="read file"]`.

**Why it's bad:** Cannot copy-paste, hard to read, mixes two formats poorly.

**Fix:** Code in code blocks. Flowcharts for decision logic only.

### Generic Labels

**What it looks like:** `helper1`, `helper2`, `step3`, `pattern4` as identifiers in flowcharts or lists.

**Why it's bad:** Labels without semantic meaning give no information. They are worse than nothing.

**Fix:** All labels must carry meaning: `validate-input`, `run-baseline`, `close-loophole`.

---

## AGIntS Dual-Format Guidance

AGIntS skills have two files with distinct purposes. Understanding the division prevents bloat in SKILL.md and missing content in EN.md.

### What goes in SKILL.md (SPEC notation)

SKILL.md is the machine-readable, token-efficient primary file. It is loaded into every conversation where the skill applies. Every line costs context window.

Put in SKILL.md:
- Iron Laws and absolute rules (with 🔴 ABSOLUTE markers)
- FORBIDDEN blocks (anti-patterns that need enforcement)
- PROCESS steps (compressed, step-numbered)
- Key definitions (`:=` notation)
- REFS pointing to EN.md and list.md

Do NOT put in SKILL.md:
- Full prose explanations
- Long tables with many rows
- Detailed examples with commentary
- Historical context or rationale
- Checklists longer than ~10 items

### What goes in EN.md (prose)

EN.md is the human-readable companion. It is loaded on demand when detail is needed. It can be as long as necessary.

Put in EN.md:
- Full TDD mapping table
- CSO deep-dive with bad/good examples
- Rationalization tables (full version)
- Testing methodology details by skill type
- Anti-pattern explanations with fixes
- Full creation checklist

### MANIFEST.json Fields Explained

```json
{
  "name": "skill-name",           // matches directory name
  "version": "1.0.0",             // semver; major = breaking SPEC change
  "level": "core|stack|task",     // determines when skill is loaded
  "stack": [],                    // technology identifiers for stack detection
  "requires": ["other-skill"],    // skills that must be present
  "source": "synthesized",        // how this skill was created
  "origin": ["repo@version"],     // source materials used in synthesis
  "frozen": false,                // true = do not auto-update from repo
  "description": "...",           // one-sentence summary for MANIFEST only
  "platforms": ["claude-code"]    // target agent environments
}
```

---

## Skill Creation Checklist (Full Version)

### RED Phase — Write Failing Test

- [ ] Create pressure scenarios (3+ combined pressures for discipline skills)
- [ ] Run scenarios WITHOUT skill — document baseline behavior verbatim
- [ ] Capture exact rationalizations used by agent
- [ ] Identify which pressures triggered violations
- [ ] Record patterns across multiple test runs

### GREEN Phase — Write Minimal Skill

- [ ] Name uses only letters, numbers, hyphens (no parentheses or special characters)
- [ ] YAML frontmatter: only `name` and `description` fields
- [ ] `description` starts with "Use when..." — trigger conditions only, no workflow summary
- [ ] `description` written in third person
- [ ] Keywords throughout SKILL.md for search (error messages, symptoms, tool names)
- [ ] SPEC notation in SKILL.md body (`:=`, `→`, `{}` blocks)
- [ ] IRON_LAW block if skill is discipline-enforcing
- [ ] Address specific baseline failures identified in RED phase
- [ ] One excellent code example (not multi-language)
- [ ] REFS block pointing to EN.md and list.md
- [ ] EN.md contains full prose explanations
- [ ] list.md lists related skills with descriptions
- [ ] MANIFEST.json with all required fields and valid JSON
- [ ] tests/ directory created
- [ ] Run same scenarios WITH skill — verify agent compliance

### REFACTOR Phase — Close Loopholes

- [ ] Identify NEW rationalizations from GREEN testing
- [ ] Add explicit FORBIDDEN entries for each new rationalization
- [ ] Build rationalization table from all test iterations (goes in EN.md)
- [ ] Create red flags list for self-detection
- [ ] Re-test with new pressure scenarios
- [ ] Repeat until bulletproof under maximum combined pressure

### Quality Checks

- [ ] SKILL.md under 500 lines (core skills under 130)
- [ ] No narrative storytelling ("In session X, we found...")
- [ ] No multi-language examples
- [ ] No code in flowcharts
- [ ] All labels have semantic meaning
- [ ] Flowcharts used only for non-obvious decision logic

### Deployment

- [ ] Commit to git with descriptive commit message
- [ ] Add to queue.md as done if processed by synthesizer
- [ ] Consider contributing back via PR if broadly useful
