SKILL: finishing-a-development-branch
VERSION: 1.0.0
PURPOSE: complete development work — verify tests, present 4 structured options, execute choice, clean up worktree

USE_WHEN:
- all implementation tasks on a branch are complete
- in subagent-driven-development after all tasks done (step 7)
- in executing-plans after all batches complete (step 5)
- any time you need to integrate, preserve, or discard branch work

AVOID_WHEN:
- implementation still in progress
- tests failing (fix first, then invoke this skill)
- no branch context (main branch direct work)

CORE_RULES:
- MUST verify tests before presenting options
- MUST present exactly 4 options (no additions)
- Option 2 (PR) and Option 3 (Keep): do NOT clean up worktree
- Option 4 (Discard): MUST require typed "discard" confirmation
- After Option 1 merge: MUST re-run tests on merged result
- No force-push without explicit user request

PROCESS_HINT:
1. VERIFY_TESTS (fail → STOP)
2. DETERMINE_BASE_BRANCH
3. PRESENT_OPTIONS (exactly 4)
4. EXECUTE_CHOICE
5. CLEANUP_WORKTREE (options 1 and 4 only)

SWITCH_TO:
- requesting-code-review — before creating PR (option 2)
- using-git-worktrees — if new worktree needed for next feature

RELATED:
- subagent-driven-development | executing-plans | using-git-worktrees
