CAPSULE := brainstorming

PURPOSE := turn_idea_into_approved_design_before_any_implementation

USE_WHEN := {
  requirements_unclear_or_ambiguous
  design_decisions_needed_before_coding
  creating_features | building_components | adding_functionality | modifying_behavior
  about_to_invoke_writing_plans
}

AVOID_WHEN := {
  design_already_approved   ← go directly to writing-plans
  task_is_pure_refactor_with_no_design_choice
}

CORE_RULES := {
  NO_CODE_until_design_presented_AND_user_approved   ← HARD_GATE, no exceptions
  one_question_per_message                           ← ABSOLUTE, never ask multiple
  YAGNI_ruthlessly                                   ← remove unnecessary from all designs
  propose_2_to_3_approaches                          ← minimal | clean | pragmatic
  incremental_validation                             ← present → approve → next_section
  ONLY_handoff_to_writing-plans                      ← no other implementation skills
}

PROCESS_HINT := {
  1_EXPLORE    (read files, check docs, scan commits)
  2_ASK        (clarify purpose + constraints + success_criteria)
  3_APPROACHES (propose 2-3, lead with recommendation)
  4_DESIGN     (sections: architecture | components | data_flow | error_handling | testing)
  5_APPROVE    (must get explicit approval, revise until approved)
  6_DOC        (write to docs/plans/YYYY-MM-DD-<topic>-design.md, commit)
  7_HANDOFF    (invoke writing-plans only)
}

SWITCH_TO := {
  design_approved → writing-plans
}

RELATED := { FULL.md, list.md }
