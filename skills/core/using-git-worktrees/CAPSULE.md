CAPSULE := using-git-worktrees

PURPOSE := create_isolated_git_worktree_with_safety_checks_before_implementation

USE_WHEN := {
  starting_feature_work_needing_branch_isolation
  before_subagent_driven_development_or_executing_plans
  multiple_parallel_branches_needed_simultaneously
  brainstorming_approved_design_and_implementation_starts
}

AVOID_WHEN := {
  already_in_correct_worktree_for_current_task
  simple_changes_that_dont_need_branch_isolation
  cleanup_phase_after_merge  ← use finishing-a-development-branch instead
}

CORE_RULES := {
  ALWAYS verify dir is gitignored before creating project-local worktree
  ALWAYS run baseline tests after setup; ask before proceeding if they fail
  FOLLOW directory priority: existing > CLAUDE.md > ask user
  NEVER create worktree inside main project directory
}

PROCESS_HINT := {
  1. select_directory (existing → CLAUDE.md → ask)
  2. safety_verify gitignore (project-local only)
  3. create_worktree
  4. setup_dependencies (auto-detect)
  5. verify_clean_baseline (run tests)
  6. report_ready
}

SWITCH_TO := {
  work_complete_and_ready_to_merge → finishing-a-development-branch
  need_parallel_independent_tasks  → dispatching-parallel-agents
}

RELATED := {
  finishing-a-development-branch  ← post-implementation cleanup
  dispatching-parallel-agents     ← when dispatching multiple worktree agents
  executing-plans                 ← calls this before task execution
  subagent-driven-development     ← calls this before dispatching
}
