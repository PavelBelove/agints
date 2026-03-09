CAPSULE := using-agints

PURPOSE := enforce_skill_check + document_full_pipeline + route_tasks_to_skills

USE_WHEN := {
  session_start
  unsure_which_skill_to_use
  need_to_understand_full_pipeline_sequence
}

AVOID_WHEN := {
  never_skip  ← loaded at every session start
}

CORE_RULES := {
  check_skill_applies_BEFORE_any_response  ← absolute, no exceptions
  even_1%_chance → invoke_skill
  instructions_say_WHAT_not_HOW
}

PROCESS_HINT := {
  PIPELINE: brainstorming → writing-plans → writing-microtasks
            → skill-selector (pass-1 + optional creation loop + pass-2)
            → execution
  SKIP_RULES: writing-microtasks if ≤3 steps | skill-selector if <5 skills
}

SWITCH_TO := {
  feature_work        → brainstorming
  bug                 → systematic-debugging
  plan_needed         → writing-plans
  plan_has_microtasks → skill-selector
}

RELATED := { list.md }
