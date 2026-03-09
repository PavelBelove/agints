# Related Skills: verification-before-completion

## Required (needed to work this skill)

None — this skill is self-contained. It requires only a terminal/shell to run verification commands.

## Frequently Used Together

- [test-driven-development](../test-driven-development/) — TDD provides the test framework; VBC enforces running it before claiming green
- [systematic-debugging](../systematic-debugging/) — when verification reveals a failure, systematic-debugging finds the root cause
- [confidence-check](../confidence-check/) — calibrates certainty levels; VBC is the enforcement layer when confidence is high but unverified

## Adjacent Tasks

- [subagent-driven-development](../subagent-driven-development/) — when delegating to agents, VBC prevents trusting agent reports without independent check
- [finishing-a-development-branch](../finishing-a-development-branch/) — branch completion requires VBC gate before PR creation
- [requesting-code-review](../requesting-code-review/) — pre-review checklist should include VBC gate

## Complementary Discipline Skills

- [systematic-debugging](../systematic-debugging/) — use when VBC reveals failures that need root cause analysis
- [test-driven-development](../test-driven-development/) — use for writing the tests that VBC requires you to run
