CAPSULE := subagent-driven-development

PURPOSE := execute_plan_via_fresh_subagent_per_task_with_spec_then_quality_review

USE_WHEN := {
  have_implementation_plan_with_mostly_independent_tasks
  staying_in_current_session
  need_automated_per_task_review_checkpoints
}

AVOID_WHEN := {
  tasks_tightly_coupled              → manual_execution
  parallel_sessions_preferred        → executing-plans
  no_plan_yet                        → writing-plans
}

CORE_RULES := {
  spec_review_BEFORE_quality_review   ← mandatory order
  never_dispatch_parallel_implementers
  never_let_subagent_read_plan_file   ← provide full text instead
  never_proceed_with_open_review_issues
  answer_subagent_questions_before_proceeding
}

PROCESS_HINT := {
  SETUP: read_plan_once → extract_all_tasks → create_todowrite
  PER_TASK: implementer → spec_reviewer → quality_reviewer → mark_complete
  REVIEW_LOOP: issues_found → fix → re_review → repeat_until_approved
  FINISH: final_review → finishing-a-development-branch
}

SWITCH_TO := {
  no_plan_yet             → writing-plans
  parallel_sessions       → executing-plans
  parallel_bug_fixes      → dispatching-parallel-agents
  branch_ready_to_merge   → finishing-a-development-branch
  subagent_failed         → systematic-debugging
}

RELATED := { test-driven-development | requesting-code-review | using-git-worktrees }
