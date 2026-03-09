---
name: test-driven-development
description: Use when implementing any feature or bugfix, before writing implementation code
---

SKILL    := test-driven-development
VERSION  := 1.1.0
PURPOSE  := enforce_test_first_discipline

TRIGGERS := {
  new_feature | bugfix | refactoring | behavior_change
  EXCEPTIONS: throwaway_prototype | generated_code | config_files
    → ask human partner before skipping
}

IRON_LAW 🔴 ABSOLUTE {
  NO production code WITHOUT failing test first
  IF code_written_before_test → DELETE_IT | start_over
  "delete" := literal_delete NOT "keep_as_reference" NOT "adapt_while_writing_tests"
  Violating the letter = violating the spirit
}

PROCESS {
  RED {
    1. write_one_minimal_test := desired_behavior
       STRUCTURE    := Arrange | Act | Assert (AAA)
       REQUIREMENTS := one_behavior | one_assertion | clear_name | real_code_not_mocks
    2. run_tests
       IF passes  → wrong test | fix_test
       IF errors  → fix_errors | rerun
       VERIFY := failure_reason := feature_missing NOT typo
  }

  GREEN {
    3. write_MINIMAL_code_to_pass
       FORBIDDEN := add_features | over_engineer | refactor_other_code
    4. run_tests
       MUST := test_passes + all_others_green + output_pristine
       IF fails → fix_code NOT fix_test
  }

  REFACTOR {
    5. remove_duplication | improve_names | extract_helpers
       FORBIDDEN := add_behavior
    6. run_tests → MUST stay_green
  }

  7. repeat → next_failing_test_for_next_feature
}

FORBIDDEN := {
  code_before_test
  "I'll test after" | "too simple to test" | "already manually tested"
  "keep as reference" | "adapt existing code"
  "X hours wasted — deleting is wasteful"    ← sunk_cost_fallacy
  "TDD is dogmatic, I'm being pragmatic"
  "tests after achieve the same goals — spirit not ritual"
  "this is different because..."
  "just this once"
}

WHEN_STUCK {
  IF test_hard_to_write     → simplify_interface (hard_to_test = hard_to_use)
  IF must_mock_everything   → decouple_code | use_dependency_injection
  IF test_setup_huge        → simplify_design
  IF unknown_how_to_test    → write_wished_for_API | write_assertion_first | ask_human
}

VERIFY_COMPLETE {
  ALL: {
    every_new_function → test_exists + watched_fail
    each_failure_was_for_right_reason (feature_missing NOT typo)
    wrote_minimal_code_to_pass
    all_tests_pass | output_pristine (no errors/warnings)
    mocks_only_if_unavoidable
    edge_cases + error_paths_covered
    coverage ≥ 80% (line + branch + function)
    unit_tests_fast (< 50ms each)
    each_test_independent (no_shared_state between tests)
  }
  IF cannot_check_all → skipped_TDD → start_over
}

REFS := {
  CAPSULE.md                  <- machine-first overview for fast routing
  FULL.md                     <- prose companion with examples and rationalization rebuttals
  testing-anti-patterns.md    <- mock/test anti-patterns (SPEC)
  list.md                     <- related skills
}
