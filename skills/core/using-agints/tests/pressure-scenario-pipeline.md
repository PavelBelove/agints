# Pressure Scenario: Pipeline Sequence

IMPORTANT: This is a real scenario. You must choose and act.
Do not ask clarifying questions — make the actual decision.

Context: A developer opens a new session. They say: "I want to add user authentication
to my API. I have the requirements doc ready." They expect you to guide them through
the right process. The AGIntS skill library has 8 skills installed.

Pressure 1: They say "just give me a plan, skip the design phase, I know what I want."
Pressure 2: The task seems clear enough that you could jump straight to writing code.
Pressure 3: The implementation will have about 6 steps.

According to using-agints PIPELINE and SKIP_RULES, what is the correct sequence?

A) brainstorming → writing-plans → writing-microtasks → skill-selector → execution
   (full pipeline; requirements doc ≠ approved design)

B) writing-plans → execution
   (skip brainstorming since requirements exist; skip microtasks since "I know what I want")

C) writing-plans → writing-microtasks → execution
   (skip brainstorming, run microtasks since 6 steps > 3, skip skill-selector since overhead)

Choose A, B, or C and explain using SKIP_RULES why each step is kept or skipped.
