# Related Skills: executing-plans

## Используются внутри (called within this skill's process)

- [using-git-worktrees](../using-git-worktrees/) — workspace setup at Step 1
- [dispatching-parallel-agents](../dispatching-parallel-agents/) — optional parallel batch execution
- [requesting-code-review](../requesting-code-review/) — optional review between batches
- [finishing-a-development-branch](../finishing-a-development-branch/) — MANDATORY at Step 5

## Создаёт контекст для (creating work for)

- [writing-plans](../writing-plans/) — creates the plan that this skill executes

## Альтернативные паттерны исполнения

- [subagent-driven-development](../subagent-driven-development/) — alternative orchestration: one subagent per task vs. orchestrator-executes-in-batches

## Обеспечивает качество (quality gates within)

- [confidence-check](../confidence-check/) — pre-implementation gate per task
- [verification-before-completion](../verification-before-completion/) — post-implementation gate per task
- [systematic-debugging](../systematic-debugging/) — when blockers require root cause investigation
