---
name: executing-plans
description: "Use when a written implementation plan exists — loads and critically reviews plan, executes in 3-task batches with review checkpoints, stops on blockers, finishes with branch completion skill"
when_to_use: when partner provides a complete implementation plan to execute in controlled batches with review checkpoints
version: 1.0.0
---

SKILL    := executing-plans
VERSION  := 1.0.0
PURPOSE  := batch_execution_of_implementation_plans_with_architect_review_checkpoints

IRON_LAW 🔴 ABSOLUTE {
  review_plan_critically_before_first_task    // raise questions BEFORE starting
  batch_size := 3                             // default; adjustable by partner
  report_after_each_batch_and_wait            // never auto-continue
  stop_on_blocker_never_guess                 // blockers → stop + ask
  no_start_on_main_without_explicit_consent
  use_finishing_a_development_branch_at_end   // mandatory sub-skill
}

PROCESS {
  ANNOUNCE: "I'm using the executing-plans skill to implement this plan."

  1. LOAD_AND_REVIEW {
    read: plan_file
    review_critically {
      questions? → raise_with_partner BEFORE starting
      concerns?  → raise_with_partner BEFORE starting
      ambiguities? → clarify BEFORE starting
    }
    IF no_concerns → create_TodoWrite; proceed_to_step_2
    RULE: start worktree via using-git-worktrees if not already in worktree
  }

  2. EXECUTE_BATCH {
    batch_size := 3  // or as specified by plan/partner
    FOR each task in batch:
      1. mark_in_progress
      2. follow_plan_steps_exactly        // no improvising
      3. run_verifications_as_specified   // don't skip
      4. mark_completed
    IF blocker_encountered → STOP_IMMEDIATELY; goto BLOCKERS
  }

  3. REPORT {
    show: what_was_implemented (specific: functions, files, behaviors)
    show: verification_output  (test results, lint, etc.)
    say: "Ready for feedback."
    WAIT_FOR_PARTNER_RESPONSE             // never auto-proceed
  }

  4. CONTINUE_OR_ADJUST {
    IF partner_gives_feedback → apply_changes; goto STEP_2_next_batch
    IF no_feedback / approved → goto STEP_2_next_batch
    REPEAT until all_tasks_complete
  }

  5. COMPLETE_DEVELOPMENT {
    announce: "Using finishing-a-development-branch to complete this work."
    INVOKE_SKILL := finishing-a-development-branch
    follow_that_skill_exactly
  }
}

BLOCKERS {
  STOP_IMMEDIATELY_WHEN := [
    missing_dependency,
    test_fails_unexpectedly,
    instruction_unclear,
    plan_has_critical_gap,
    verification_fails_repeatedly,
    dont_understand_instruction
  ]
  ACTION := ask_partner_for_clarification
  NEVER := guess_and_proceed
  NEVER := skip_verification_to_unblock
}

REVISIT_STEP_1_WHEN := [
  partner_updates_plan,
  fundamental_approach_needs_rethinking
]

OPTIONAL_INTEGRATION {
  IF plan_tasks_are_independent_and_parallel_safe →
    dispatching-parallel-agents  // for individual batches
  AFTER_EACH_BATCH →
    requesting-code-review       // if plan specifies or partner requests
}

FORBIDDEN {
  start_tasks_without_reviewing_plan_first
  auto_proceed_after_batch_without_feedback
  guess_through_blockers
  skip_plan_specified_verifications
  improvise_steps_not_in_plan
  start_on_main_or_master_without_consent
  skip_finishing_a_development_branch
}

INTEGRATION {
  SETUP      := using-git-worktrees
  PLAN_FROM  := writing-plans
  PARALLEL   := dispatching-parallel-agents   // optional, within batches
  REVIEW     := requesting-code-review        // optional, after batches
  COMPLETE   := finishing-a-development-branch  // mandatory
}

REFS {
  FULL.md  := workflow_integration_and_examples
  list.md  := related_skills
}
