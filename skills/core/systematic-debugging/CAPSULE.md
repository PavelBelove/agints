CAPSULE := systematic-debugging

PURPOSE := find_root_cause_before_fixing | symptom_fixes_are_failure

USE_WHEN := {
  bug_found | test_failure | unexpected_behavior | performance_issue
  build_failure | integration_issue
  ESPECIALLY: time_pressure | "obvious_quick_fix" | multiple_failed_fixes
}

AVOID_WHEN := {
  no_code_involved      ← pure design or planning task
  already_at_root_cause ← skip investigation, proceed to PHASE_3 hypothesis
}

CORE_RULES := {
  NO_FIXES_WITHOUT_ROOT_CAUSE_INVESTIGATION_FIRST
  IF phase_1_incomplete → fixes_forbidden
  symptom_fix = failure
  no_multiple_changes_at_once
  no_fix_without_failing_test
  IF ≥3_fixes_failed → question_architecture, discuss_with_human
}

PROCESS_HINT := {
  PHASE_1_ROOT_CAUSE
  PHASE_2_PATTERN_ANALYSIS
  PHASE_3_HYPOTHESIS
  PHASE_4_IMPLEMENTATION
}

SWITCH_TO := {
  deep_stack_trace                 → root-cause-tracing.md
  need_timeout_replacement         → condition-based-waiting.md
  fix_found_need_validation_layer  → defense-in-depth.md
  need_failing_test_first          → test-driven-development
  3+_fixes_failed                  → discuss_architecture_with_human
}

RELATED := { FULL.md, root-cause-tracing.md, condition-based-waiting.md, defense-in-depth.md, list.md, scripts/find-polluter.sh }
