---
name: requesting-code-review
description: "Use after each task completion, major feature, or before merging — dispatches code-reviewer subagent, gets git SHAs, acts on Critical/Important/Minor feedback"
when_to_use: when completing tasks, implementing features, or before merging to verify work meets requirements
version: 1.0.0
---

SKILL    := requesting-code-review
VERSION  := 1.0.0
PURPOSE  := dispatch_code_reviewer_subagent_and_act_on_feedback

TRIGGERS {
  MANDATORY := [
    after_each_task_in_subagent_driven_development,
    after_each_task_in_executing_plans,
    after_completing_major_feature,
    before_merge_to_main
  ]
  OPTIONAL := [
    when_stuck_need_fresh_perspective,
    before_refactoring_as_baseline_check,
    after_fixing_complex_bug
  ]
}

IRON_LAW 🔴 ABSOLUTE {
  fix_critical_before_any_next_action
  fix_important_before_proceeding_to_next_task
  never_skip_review_because_simple
  never_ignore_critical_issues
  push_back_only_with_technical_reasoning_and_evidence
}

PROCESS {
  ANNOUNCE: "Requesting code review before proceeding."

  1. GET_SHAs {
    BASE_SHA := git rev-parse <previous_milestone>  // HEAD~1 or origin/main or task start commit
    HEAD_SHA := git rev-parse HEAD
    HINT := use "git log --oneline" to find task boundary commit if needed
  }

  2. DISPATCH code-reviewer-subagent {
    TEMPLATE := agents/code-reviewer.md
    FILL {
      {WHAT_WAS_IMPLEMENTED} := what was just built (concrete: function names, files)
      {PLAN_OR_REQUIREMENTS} := reference doc or task description
      {BASE_SHA}             := from step 1
      {HEAD_SHA}             := from step 1
      {DESCRIPTION}          := 1-sentence summary
    }
  }

  3. RECEIVE_AND_ACT {
    CRITICAL  → fix immediately, re-run review if needed, do NOT proceed
    IMPORTANT → fix before next task; note if reviewer acknowledges reasoning
    MINOR     → log for later; may proceed
    PRAISE    → acknowledge, continue
    IF reviewer_wrong → push back with code/test evidence + reasoning
  }
}

FORBIDDEN {
  skip_review_because "it's simple"
  skip_review_because "no time"
  proceed_with_critical_unfixed
  proceed_with_important_unfixed           // exception: user explicit override
  argue_with_valid_technical_feedback
  use_SHA_from_memory                      // always git rev-parse, never guess
}

OUTPUT_FORMAT {
  AFTER_DISPATCH:
  "Review requested: {BASE_SHA}..{HEAD_SHA}
   Reviewer assessing: {DESCRIPTION}"

  AFTER_RECEIVE:
  "Review complete:
     Critical: <N> → [fixing now | none]
     Important: <N> → [fixing before next task | none]
     Minor: <N> → [noting for later | none]
   Proceeding to: <next step>"
}

REFS {
  agents/code-reviewer.md  := reviewer_subagent_template
  FULL.md                  := integration_examples_and_workflows
  list.md                  := related_skills
}
