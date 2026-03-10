SKILL: requesting-code-review
VERSION: 1.0.0
PURPOSE: dispatch code-reviewer subagent after implementation, act on feedback before proceeding

USE_WHEN:
- completing any task in subagent-driven-development or executing-plans
- finishing a major feature implementation
- before merge to main branch
- when stuck and need fresh perspective

AVOID_WHEN:
- mid-implementation (wait until task complete)
- no git history exists (nothing to diff)

CORE_RULES:
- MANDATORY after each task in SDD/executing-plans workflows
- fix Critical before ANY next action
- fix Important before next task
- Minor may proceed with note
- never skip because "it's simple"
- always get SHAs via git rev-parse (never guess)
- push back on wrong reviewer feedback with evidence

PROCESS_HINT:
1. GET_SHAs (git rev-parse HEAD~1 + HEAD)
2. DISPATCH agents/code-reviewer.md with filled placeholders
3. ACT: Critical→fix now, Important→fix before next, Minor→log

SWITCH_TO:
- receiving-code-review — when processing detailed reviewer output
- finishing-a-development-branch — after all reviews pass
- systematic-debugging — when Critical issue requires deep diagnosis

RELATED:
- subagent-driven-development — review after each task
- executing-plans — review after each batch
- verification-before-completion — post-implementation quality gate (complementary)
