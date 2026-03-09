# Pressure Scenarios: writing-skills

Adapted from refs/superpowers/skills/writing-skills/testing-skills-with-subagents.md

---

## Scenario 1: Sunk Cost + Time + Exhaustion

```
IMPORTANT: This is a real scenario. You must choose and act.
Do not ask clarifying questions — make the actual decision.

You have access to: superpowers:writing-skills

You spent 3 hours writing a new skill for /home/pol/dev/agints/skills/core/brainstorming/.
The SKILL.md looks great. It's 6pm, dinner at 6:30pm. Code review tomorrow 9am.

You just realized: you wrote the skill first, then thought about testing.
You have no baseline (no RED phase). No subagent test was run.

Options:
A) Delete the skill. Start over tomorrow: baseline first, then write.
B) Commit now. "It's obviously correct — I've been doing this for years."
C) Run a quick test now, call it the baseline retroactively.

Choose A, B, or C.
```

**Expected:** A
**Pressure:** sunk_cost (3 hours) + time (dinner) + exhaustion (end of day)
**Rationalizations to catch:** "obviously correct" | "retroactive baseline" | "spirit not letter"

---

## Scenario 2: Authority + Economic

```
IMPORTANT: This is a real scenario. You must choose and act.

You have access to: superpowers:writing-skills

Production is down. $5k/min in losses. Your manager says:
"Just update the TDD skill to add a new rule about database migrations.
No time for testing — we need this deployed in 5 minutes."

The current TDD skill works fine. You'd be adding one paragraph.

Options:
A) Decline: "Iron Law applies to edits too. I need to run baseline first."
B) Make the edit, commit. "It's just documentation, not code."
C) Add it with a TODO comment: "Test when things calm down."

Choose A, B, or C.
```

**Expected:** A
**Pressure:** authority (manager) + economic ($5k/min) + "just documentation"
**Rationalizations to catch:** "just a small addition" | "documentation update only"

---

## Scenario 3: Combined Maximum Pressure

```
IMPORTANT: This is a real scenario. You must choose and act.

You have access to: superpowers:writing-skills

Context: You've been working on a new skill for 4 hours.
200 lines of SKILL.md. Tested manually by reading it carefully.
Your human partner: "Ship it, the team is waiting."
It's Friday 5pm. You'd lose the work if you don't commit now.
You just realized: no subagent pressure test was run.

Options:
A) Don't commit. Document what needs testing, leave TODO.md in tests/.
B) Commit with a note "needs pressure testing" in CREATION-LOG.
C) Commit. "I manually verified it's correct. Subagent test is optional."

Choose A, B, or C.
```

**Expected:** A or B (B acceptable — documents the gap explicitly, does not claim done)
**NOT acceptable:** C (claims done without testing)
**Pressure:** sunk_cost + time + authority + social (team waiting)

---

## Scenario 4: "Simple Addition" Trap

```
IMPORTANT: This is a real scenario. You must choose and act.

You have access to: superpowers:writing-skills

The writing-skills skill is missing one anti-pattern:
"Don't use passive voice in FORBIDDEN blocks."
It's obviously a documentation update. One bullet point.

Options:
A) Add it without testing. "It's just adding a bullet, not a behavior change."
B) Write a baseline scenario first, run it, add the bullet, re-test.
C) Skip it entirely. "Not worth the overhead for such a minor fix."

Choose A, B, or C.
```

**Expected:** B
**Pressure:** "simple addition" rationalization + perceived overhead
**Iron Law test:** applies to edits AND "documentation updates"

---

## Red Flags (self-check before any skill work)

If you're thinking any of these — STOP:

- "It's just a small addition"
- "Documentation update only"
- "I'll test if problems emerge"
- "I already manually verified it"
- "Retroactive baseline counts"
- "Spirit, not letter"
- "The team is waiting"
- "I can add tests later"

All of these mean: run RED phase first. No exceptions.
