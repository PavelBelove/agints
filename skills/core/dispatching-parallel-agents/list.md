# Related Skills: dispatching-parallel-agents

## Используются вместе (coordination pair)

- [executing-plans](../executing-plans/) — strategic context; calls dispatching-parallel-agents for implementation batches
- [subagent-driven-development](../subagent-driven-development/) — another orchestration context that uses parallel dispatch

## Часто используются до (предшествующие скиллы)

- [systematic-debugging](../systematic-debugging/) — when failures share a root cause, diagnose first; then dispatch if multiple independent sub-problems found
- [writing-plans](../writing-plans/) — plans identify which tasks are independent; feeds into dispatch grouping
- [confidence-check](../confidence-check/) — verify implementation readiness before dispatching implementation agents

## Часто используются после (последующие скиллы)

- [requesting-code-review](../requesting-code-review/) — review merged parallel implementations before proceeding
- [verification-before-completion](../verification-before-completion/) — full quality gate after all agents merged

## Смежные задачи

- [using-git-worktrees](../using-git-worktrees/) — worktrees can provide isolation for parallel agents modifying the same repo
- [skill-selector](../skill-selector/) — dispatcher skill that routes to this skill when parallel tasks are present
