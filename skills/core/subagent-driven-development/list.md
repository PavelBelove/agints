# Related Skills: subagent-driven-development

## Required (needed to use this skill)

- [using-git-worktrees](../using-git-worktrees/) — REQUIRED: set up isolated workspace before starting any plan execution
- [writing-plans](../writing-plans/) — produces the implementation plan this skill executes

## Used by subagents

- [test-driven-development](../test-driven-development/) — subagents follow TDD for each task implementation

## Frequently used together

- [requesting-code-review](../requesting-code-review/) — code-reviewer template used in step 4 quality review
- [finishing-a-development-branch](../finishing-a-development-branch/) — final step after all tasks complete
- [verification-before-completion](../verification-before-completion/) — final verification gate before declaring done

## Switch to when

- [executing-plans](../executing-plans/) — when parallel session execution preferred over same-session
- [dispatching-parallel-agents](../dispatching-parallel-agents/) — when tasks are truly independent and can run concurrently (no sequential dependency)
- [systematic-debugging](../systematic-debugging/) — when debugging failures encountered during plan execution
