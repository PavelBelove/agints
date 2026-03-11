# writing-plans — Pressure Test Scenarios

## How to run

For each scenario: launch a fresh subagent with the scenario prompt WITHOUT loading
the writing-plans skill. Document baseline behavior (what the agent does wrong).
Then re-run WITH the skill and verify the agent handles it correctly.

---

## Scenario 1: Skip Brainstorming

**Prompt:**
> I want to add JWT authentication to my FastAPI app. Please write the implementation plan now.

**Baseline failure:** Agent writes the plan immediately without noting that brainstorming
should happen first (requirements are underspecified — what type of JWT? refresh tokens?
protected routes?).

**Expected with skill:** Agent detects that requirements aren't clearly defined and invokes
brainstorming first (or asks clarifying questions before writing the plan).

**Key rule being tested:** `requirements unclear → brainstorming first, then write-plans`

---

## Scenario 2: Vague Task Descriptions

**Prompt:**
> Write a plan for implementing the user authentication module. You don't need exact file
> paths — I'll figure those out when I implement it.

**Baseline failure:** Agent writes tasks like "implement auth logic" and "add token validation"
without exact file paths or code snippets.

**Expected with skill:** Agent insists on exact file paths (e.g., `src/api/auth.py:45-60`),
complete code snippets, and exact test commands — or asks for the information needed to provide them.

**Key rule being tested:** `exact file paths always (never "the auth module")` +
`complete code snippets (never "add validation")`

---

## Scenario 3: Resist "Rough Plan" Requests

**Prompt:**
> Just give me a rough plan for the feature. I don't need exact commands or code snippets —
> just the high-level steps.

**Baseline failure:** Agent produces a vague high-level plan without TDD structure, file paths,
or implementation details.

**Expected with skill:** Agent explains that plans must include exact file paths and TDD
structure to be useful to execution agents, and either provides a complete plan or explains
what information it needs.

**Key rule being tested:** `complete code snippets` + `exact commands with expected output`

---

## Scenario 4: Missing TDD Structure

**Prompt:**
> Write a plan to add a rate limiter to our API. Each task should just describe what to implement.

**Baseline failure:** Agent writes tasks as pure implementation steps: "Add rate limiting middleware",
"Configure rate limit rules", "Add error responses" — no failing tests, no verification steps.

**Expected with skill:** Agent writes each task with the full TDD structure:
failing test → verify fails → implement → verify passes → commit.

**Key rule being tested:** `TDD per task: failing test → verify fails → implement → verify passes → commit`

---

## Scenario 5: No Executing-Plans Header

**Prompt:**
> Write an implementation plan for adding email notifications. Save it to docs/plans/email.md.

**Baseline failure:** Agent writes the plan but omits the required header with the
`REQUIRED SUB-SKILL: Use executing-plans` directive.

**Expected with skill:** Plan file includes the mandatory header:
```
> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.
```

**Key rule being tested:** `PLAN_HEADER_REQUIRED: > **For Claude:** REQUIRED SUB-SKILL: Use executing-plans`
