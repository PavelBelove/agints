---
name: subagent-driven-development
description: "Use when executing an implementation plan with mostly independent tasks in the current session, requiring fresh-context subagents per task plus sequential two-stage review (spec compliance then code quality) before proceeding to the next task."
---

SKILL    := subagent-driven-development
VERSION  := 1.0.0
PURPOSE  := execute_plan_via_fresh_subagents + two_stage_review_per_task

TRIGGERS := {
  have_implementation_plan
  tasks_are_mostly_independent
  stay_in_current_session           ← vs. executing-plans for parallel sessions
  need_automated_review_checkpoints
}

FORBIDDEN := {
  start_on_main_without_user_consent
  skip_spec_review
  skip_quality_review
  run_code_quality_before_spec_passes
  dispatch_parallel_implementers     ← conflicts on shared state
  let_subagent_read_plan_file        ← provide full text instead
  skip_scene_setting_context
  ignore_subagent_questions          ← answer before proceeding
  accept_close_enough_on_spec
  skip_re_review_after_fix
  let_self_review_replace_actual_review
  move_to_next_task_with_open_issues
}

SETUP {
  1. Set up git worktree (using-git-worktrees skill)
  2. Read plan file ONCE — extract all tasks with full text and context
  3. Create TodoWrite with all tasks
}

PROCESS {
  PER_TASK {
    1. Dispatch implementer subagent (agents/implementer-prompt.md)
       — include: full task text, scene-setting context, working directory
    IF subagent_asks_questions → answer_clearly_before_proceeding

    2. Implementer: implement → test → commit → self-review → report

    3. Dispatch spec-reviewer subagent (agents/spec-reviewer-prompt.md)
       — include: full task requirements, implementer report
       — spec reviewer MUST read code independently, not trust report
    IF issues_found → implementer_fixes → spec_reviewer_re_reviews
    REPEAT until spec_reviewer = ✅

    4. Dispatch code-quality-reviewer subagent (agents/code-quality-reviewer-prompt.md)
       — provide: BASE_SHA, HEAD_SHA, description
    IF issues_found → implementer_fixes → quality_reviewer_re_reviews
    REPEAT until quality_reviewer = ✅

    5. Mark task complete in TodoWrite
  }

  AFTER_ALL_TASKS {
    6. Dispatch final code-reviewer subagent for entire implementation
    7. Use finishing-a-development-branch skill
  }

  IF subagent_fails_task →
    dispatch_fix_subagent_with_specific_instructions
    FORBIDDEN := try_to_fix_manually  ← context pollution
}

REFS := {
  CAPSULE.md                        ← machine-first overview for fast routing
  FULL.md                           ← full prose explanation
  list.md                           ← related skills
  agents/implementer-prompt.md      ← implementer subagent template
  agents/spec-reviewer-prompt.md    ← spec compliance reviewer template
  agents/code-quality-reviewer-prompt.md  ← code quality reviewer template
}
