CAPSULE := confidence-check

PURPOSE := quantitative_readiness_gate_before_any_implementation

USE_WHEN := {
  about_to_write_code_or_make_changes
  about_to_fix_a_bug
  implementation_requested_without_prior_investigation
  about_to_make_architectural_decision
}

AVOID_WHEN := {
  pure_research_or_read_only_analysis
  already_ran_this_session_for_same_task
  no_code_changes_involved
}

CORE_RULES := {
  score ≥ 0.90 → PROCEED
  score ≥ 0.70 → CLARIFY (present options, request missing info)
  score < 0.70 → STOP (investigate further, do NOT implement)
  thresholds_are_exact   ← 0.89 = CLARIFY, never round up to PROCEED
  no_authority_override  ← run checks regardless of who asks to skip
}

PROCESS_HINT := {
  1. score_5_checks: duplicate(25) + architecture(25) + docs(20) + oss(15) + root_cause(15)
  2. apply_threshold
  3. output_confidence_report
  4. IF < 0.90: identify_missing_items
}

SWITCH_TO := {
  after_implementation → verification-before-completion
  bug_not_reproduced   → systematic-debugging
}

RELATED := {
  verification-before-completion   ← POST-implementation counterpart
  systematic-debugging             ← when root cause unknown, use this first
}
