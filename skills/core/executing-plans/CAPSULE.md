SKILL: executing-plans
VERSION: 1.0.0
PURPOSE: execute implementation plans in 3-task batches with review checkpoints — review critically first, stop on blockers, finish with branch completion

USE_WHEN:
- a written implementation plan exists (from writing-plans or from partner)
- executing in a separate session from planning
- structured review checkpoints are needed between task batches
- complex multi-task implementation requiring oversight

AVOID_WHEN:
- no written plan exists (write plan first with writing-plans)
- single-task simple changes (direct implementation is faster)
- exploratory work without defined tasks

CORE_RULES:
- ALWAYS review plan critically before first task — raise questions FIRST
- batch size = 3 tasks by default (adjustable)
- ALWAYS report after each batch: "what was implemented + verification + Ready for feedback"
- NEVER auto-continue — wait for partner response
- STOP on blockers immediately — never guess through them
- DO NOT start on main/master without explicit consent
- ALWAYS use finishing-a-development-branch at the end (mandatory)
- follow plan steps exactly — no improvisation

PROCESS_HINT:
1. LOAD_AND_REVIEW (critical review, raise concerns before starting)
2. EXECUTE_BATCH (3 tasks, follow exactly, run verifications)
3. REPORT ("Ready for feedback." — then wait)
4. CONTINUE_OR_ADJUST (apply feedback, next batch)
5. COMPLETE (finishing-a-development-branch — mandatory)

SWITCH_TO:
- using-git-worktrees — before starting (worktree setup)
- dispatching-parallel-agents — when batch tasks are independent
- requesting-code-review — after batch if review needed
- finishing-a-development-branch — at the end (always)

RELATED:
- writing-plans — creates the plan this skill executes
- subagent-driven-development — alternative execution pattern (subagents per task)
- confidence-check — run before starting implementation of each task
