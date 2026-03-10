# Related Skills: receiving-code-review

## Используются вместе (review loop pair)

- [requesting-code-review](../requesting-code-review/) — dispatch side of the same loop; dispatches code-reviewer, passes output to receiving-code-review
- [verification-before-completion](../verification-before-completion/) — post-implementation quality gate; use after all review feedback is resolved

## Часто используются до (предшествующие скиллы)

- [requesting-code-review](../requesting-code-review/) — always runs before receiving; initiates the review
- [subagent-driven-development](../subagent-driven-development/) — context where review cycles happen after each task

## Часто используются после (последующие скиллы)

- [finishing-a-development-branch](../finishing-a-development-branch/) — after all review feedback resolved, branch can be finished
- [systematic-debugging](../systematic-debugging/) — when a Critical finding requires deep root cause investigation

## Смежные задачи

- [confidence-check](../confidence-check/) — PRE-implementation gate (before writing code)
- [executing-plans](../executing-plans/) — review-and-fix cycles are part of plan execution
