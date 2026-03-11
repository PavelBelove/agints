SKILL: receiving-code-review
VERSION: 1.0.0
PURPOSE: process code review feedback with technical rigor — verify before implementing, push back when wrong, no performative agreement

USE_WHEN:
- receiving feedback from code-reviewer subagent
- receiving human reviewer feedback on a PR
- processing inline review comments on GitHub
- any context where someone is giving feedback on implemented code

AVOID_WHEN:
- initiating a review (use requesting-code-review instead)
- general implementation tasks with no feedback to process

CORE_RULES:
- READ all feedback before reacting
- CLARIFY all unclear items before implementing anything
- VERIFY each suggestion against codebase (never implement blindly)
- unverifiable suggestion = MUST NOT implement ("sounds reasonable" ≠ verification)
- no performative agreement: never "Great point!", "Thanks!", "You're right!"
- push back when technically wrong — with evidence, not defensiveness
- YAGNI: grep for actual usage before implementing "proper" features
- one concern at a time, test after each fix

TRUST: internal=HIGH | external_human=SKEPTICAL | AI_tool=LOW | CI=OBJECTIVE

PROCESS_HINT:
1. READ_ALL → classify BLOCKING/ADVISORY
2. CLARIFY_UNCLEAR (stop entire batch if any unclear)
3. VERIFY_EACH (codebase check, breaks?, context?, YAGNI?)
4. RESPOND (brief ack or technical pushback)
5. IMPLEMENT (blocking→simple→complex, one at a time, test each)

SWITCH_TO:
- requesting-code-review — to initiate a new review round after fixes
- systematic-debugging — when a Critical finding needs deep root cause diagnosis
- finishing-a-development-branch — when all feedback resolved

RELATED:
- requesting-code-review | verification-before-completion
