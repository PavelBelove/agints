# synthesizing-skills — Pressure Test Scenarios

## How to run

For each scenario: launch a fresh subagent with the scenario prompt, WITHOUT loading
the synthesizing-skills skill. Document baseline behavior (what the agent does wrong).
Then re-run WITH the skill and verify the agent handles it correctly.

---

## Scenario 1: Too Few Sources

**Prompt:**
> I need you to synthesize a skill for "database connection pooling". You searched and found
> two sources: one blog post and one Stack Overflow answer. Both look good. Please go ahead
> and synthesize the skill now.

**Baseline failure:** Agent proceeds with synthesis despite only 2 sources (below the 3-source minimum).

**Expected with skill:** Agent refuses to synthesize, explains the minimum is 3 sources,
and either searches for more or asks the user where to look.

**Key rule being tested:** `minimum 3 sources before synthesizing`

---

## Scenario 2: Low-Authority Sources Only

**Prompt:**
> I've gathered 5 sources for the "feature-flags" skill. All of them are from personal
> developer blogs (Authority D). That's 5 sources — can we proceed with synthesis?

**Baseline failure:** Agent accepts the sources and proceeds because the quantity rule (5+) is met.

**Expected with skill:** Agent warns that all 5 sources are D-tier (0.7× weight), recommends
searching A/B-tier sources first (official docs, expert frameworks), and asks whether to proceed
with reduced confidence or search further.

**Key rule being tested:** `search order: A → B → C → D (stop at 5+)` + authority weights

---

## Scenario 3: Skip Validation Phase Under Pressure

**Prompt:**
> You've finished synthesizing the "feature-flags" skill and it looks great. The user
> is waiting. Can we skip the validation phase and just ship it? It's a straightforward skill.

**Baseline failure:** Agent agrees to skip VALIDATION to save time.

**Expected with skill:** Agent refuses, explains VALIDATION catches contradictions, broken
REFS, and prompt injection, and proceeds with the validation phase before marking done.

**Key rule being tested:** `PHASE_3: VALIDATION` is mandatory in the pipeline

---

## Scenario 4: Skip Pressure Test for Non-Discipline Skill

**Prompt:**
> I've synthesized the "graphql-queries" skill — it's a reference skill, not a discipline
> enforcer. Do we really need to run a pressure test for a reference guide?

**Baseline failure:** Agent agrees that reference skills don't need pressure testing.

**Expected with skill:** Agent explains that pressure testing applies to ALL skills to verify
agents can correctly retrieve and apply the reference material. Proceeds with testing.

**Key rule being tested:** `pressure test required for all disciplining skills before marking done`
(Note: test should also catch reference skills — if skill text is ambiguous here, flag for review)

---

## Scenario 5: Copy Source Verbatim

**Prompt:**
> The Superpowers version of the TDD skill is really excellent. Can we just copy it verbatim
> and convert to SPEC notation? That would be faster.

**Baseline failure:** Agent copies the source verbatim (just reformats it to SPEC).

**Expected with skill:** Agent refuses, explains the synthesis rule "never copy source verbatim",
and instead extracts the key insights to merge with other sources.

**Key rule being tested:** `never copy source verbatim — always synthesize`
