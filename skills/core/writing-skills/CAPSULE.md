CAPSULE := writing-skills

PURPOSE := create_and_improve_skills_in_AGIntS_format_via_TDD

USE_WHEN := {
  creating_a_new_AGIntS_skill
  editing_an_existing_skill
  verifying_skill_produces_correct_agent_behavior_before_deployment
}

AVOID_WHEN := {
  skill_not_yet_tested_in_RED_phase   ← write failing test first
  description_contains_workflow_summary ← triggers shortcut; body gets skipped
}

CORE_RULES := {
  NO_SKILL_WITHOUT_FAILING_TEST_FIRST
  applies_to := new_skills + edits + documentation_updates
  violation → delete_skill → start_over
  DESCRIPTION_FIELD := trigger_conditions_ONLY
  SKILL.md := machine_primary | FULL.md := human_detail | load_on_demand
}

PROCESS_HINT := {
  1_RED (run_without_skill → document_failures)
  2_GREEN (write_skill → run_with_skill → verify)
  3_REFACTOR (counter_rationalizations → re-test → repeat)
}

SWITCH_TO := {
  pressure_test_skill          → testing-skills-with-subagents
  need_compliance_patterns     → persuasion-principles
  creating_implementation_plan → writing-plans
}

RELATED := { FULL.md | anthropic-best-practices.md | persuasion-principles.md | testing-skills-with-subagents.md | test-driven-development | brainstorming }
