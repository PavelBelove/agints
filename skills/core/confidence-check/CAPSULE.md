CAPSULE := confidence-check

PURPOSE := prevent_wrong_direction_work_via_quantitative_pre_implementation_check

USE_WHEN := {
  about_to_write_code_without_prior_readiness_check
  starting_implementation_of_bug_fix_or_improvement
  adding_feature_to_existing_codebase
  rework_cost_if_wrong > 500_tokens
}

AVOID_WHEN := {
  quick_1_line_typo_fix_with_obvious_location
  already_completed_confidence_check_this_task
}

CORE_RULES := {
  🔴 score < 0.90 → NEVER proceed, no exceptions
  🔴 stated_confidence ≠ calculated_score: always run 5-check algorithm
  🔴 thresholds exact: 89.9% = CLARIFY not PROCEED
  simple_task does NOT exempt from checks
  urgency does NOT exempt from checks (emergency mode reduces, not removes)
}

PROCESS_HINT := {
  1. classify_task (fix vs new feature → root_cause mandatory or auto-pass)
  2. run_5_checks: duplicate(25%) + architecture(25%) + docs(20%) + oss(15%) + root_cause(15%)
  3. calculate_score + apply threshold
  4. output: PROCEED / CLARIFY / STOP + gap list if not PROCEED
}

SWITCH_TO := {
  score < 0.70 → systematic-debugging (root cause investigation)
  design unclear → writing-plans first
}

RELATED := {
  systematic-debugging | test-driven-development | verification-before-completion
}
