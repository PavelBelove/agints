# Related Skills: finishing-a-development-branch

## Называется из (вызывающие скиллы)

- [subagent-driven-development](../subagent-driven-development/) — calls this at Step 7 after all tasks complete
- [executing-plans](../executing-plans/) — calls this at Step 5 after all batches complete

## Используются вместе (companion skills)

- [using-git-worktrees](../using-git-worktrees/) — creates the worktree; finishing-a-development-branch tears it down (Options 1 and 4)
- [requesting-code-review](../requesting-code-review/) — should run before Option 2 (PR creation) in formal workflows

## Часто используются до (предшествующие скиллы)

- [verification-before-completion](../verification-before-completion/) — final quality gate before this skill is invoked
- [receiving-code-review](../receiving-code-review/) — resolve all review feedback before finishing

## Смежные задачи

- [confidence-check](../confidence-check/) — the start of the quality envelope (PRE-implementation); this skill is the end
