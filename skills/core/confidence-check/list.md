# Related Skills: confidence-check

## Required when confidence-check fails

- [systematic-debugging](../systematic-debugging/) — when root cause check (Check 5) fails or confidence is <70%; use to investigate before returning to confidence-check

## Commonly used together

- [test-driven-development](../test-driven-development/) — confidence-check is the pre-gate; TDD is the implementation protocol that runs after confidence ≥90%
- [verification-before-completion](../verification-before-completion/) — confidence-check is PRE-implementation; verification-before-completion is POST-implementation; both form the safety envelope around any coding task

## Adjacent tasks (when to switch)

- [writing-plans](../writing-plans/) — if confidence-check reveals the design itself is unclear (Check 2: architecture not defined), switch to writing-plans before re-running confidence-check
- [brainstorming](../brainstorming/) — if pre-spec confidence check fails (problem not validated), brainstorming can help clarify the problem space
