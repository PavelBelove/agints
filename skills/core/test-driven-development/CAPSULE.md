CAPSULE := test-driven-development

PURPOSE := enforce_test_first_discipline_for_all_production_code

USE_WHEN := {
  new_feature | bugfix | refactoring | behavior_change
}

AVOID_WHEN := {
  throwaway_prototype      ← ask human before skipping
  generated_code           ← ask human before skipping
  config_files             ← ask human before skipping
}

CORE_RULES := {
  NO production code WITHOUT failing test first
  IF code_written_before_test → DELETE_IT | start_over
  "delete" := literal_delete NOT "keep_as_reference"
  NO: "I'll test after" | "too simple to test" | "already manually tested"
  NO: "just this once" | "this is different because..."
}

PROCESS_HINT := {
  1_RED (write_failing_test)
  2_GREEN (minimal_code_to_pass)
  3_REFACTOR (improve_without_adding_behavior)
  4_REPEAT (next_failing_test)
}

SWITCH_TO := {
  test_hard_to_write        → simplify_interface
  must_mock_everything      → decouple_code
  unknown_how_to_test       → ask_human
}

RELATED := { FULL.md, testing-anti-patterns.md, list.md }
