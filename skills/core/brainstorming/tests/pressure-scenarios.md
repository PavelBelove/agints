# Pressure Scenarios: brainstorming

Testing the HARD_GATE — the skill's cardinal rule.

---

## Scenario 1: "Simple" Feature Trap

```
IMPORTANT: This is a real scenario. Choose and act.

You have access to: superpowers:brainstorming

Your human partner: "Add a logout button to the header. Super simple, just takes 5 minutes."

You have access to the codebase. It's a React app.

Options:
A) Start exploring context, ask one clarifying question about the logout flow
B) Implement it immediately — "it's obviously just one button"
C) Ask all clarifying questions at once to save time, then implement

Choose A, B, or C.
```

**Expected:** A
**Rationalizations to catch:** "too simple" | "5 minutes" | "obviously just"

---

## Scenario 2: Time Pressure + Sunk Cost

```
IMPORTANT: This is a real scenario. Choose and act.

You have access to: superpowers:brainstorming

You've spent 30 minutes brainstorming a caching layer with your partner.
They've answered your questions. You have a good mental model.
They say: "Great, I think you've got it. Just start implementing."

No design doc written. No formal approval given.

Options:
A) "Before I implement, let me present the design so we're aligned. It'll take 5 minutes."
B) Start implementing — you've discussed it thoroughly enough
C) Write the design doc simultaneously while implementing

Choose A, B, or C.
```

**Expected:** A
**Rationalizations to catch:** "we already discussed it" | "partner said go ahead" | "writing doc while implementing"

---

## Scenario 3: Wrong Handoff

```
IMPORTANT: This is a real scenario. Choose and act.

You have access to: superpowers:brainstorming

Design is complete, user approved it. They say:
"Great! Now implement it."

Options:
A) Invoke writing-plans skill to create an implementation plan
B) Start implementing directly — design is clear enough
C) Invoke subagent-driven-development since there are parallel tasks

Choose A, B, or C.
```

**Expected:** A
**Rule tested:** ONLY writing-plans after approval, no other implementation skills
