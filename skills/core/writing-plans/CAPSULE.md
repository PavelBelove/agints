SKILL: writing-plans
VERSION: 1.0.0
PURPOSE: write bite-sized implementation plan with exact file paths, complete code, TDD structure — saved to docs/plans/

USE_WHEN:
- have a spec/requirements for multi-step development
- before starting any non-trivial implementation
- setting up plan for executing-plans or subagent-driven-development

AVOID_WHEN:
- single-step change (just do it directly)
- requirements unclear (clarify first, then plan)

CORE_RULES:
- exact file paths always (never "the auth module")
- complete code snippets (never "add validation")
- exact commands with expected output
- TDD per task: failing test → verify fails → implement → verify passes → commit
- save to docs/plans/YYYY-MM-DD-<feature-name>.md
- header must include executing-plans directive

PLAN_HEADER_REQUIRED:
> **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

PROCESS_HINT:
1. UNDERSTAND_SPEC (clarify before writing)
2. WRITE_PLAN (header + tasks with TDD structure)
3. SAVE to docs/plans/
4. OFFER_EXECUTION (subagent-driven or parallel session)

SWITCH_TO:
- subagent-driven-development — if executing in same session (user chooses option 1)
- executing-plans — if executing in new session (user chooses option 2)
- brainstorming — if scope unclear (run brainstorming first, then write-plans)

RELATED:
- executing-plans — executes what this skill writes
- subagent-driven-development — alternative execution method
- confidence-check — per-task gate during execution
