---
name: brainstorming
description: "Use before any creative or implementation work — creating features, building components, adding functionality, modifying behavior. Use when requirements are unclear, when design decisions are needed, or before invoking writing-plans."
---

SKILL    := brainstorming
VERSION  := 1.0.0
PURPOSE  := turn_idea_into_approved_design_before_any_implementation

---

HARD_GATE 🔴 ABSOLUTE {
  NO_CODE | NO_SCAFFOLD | NO_IMPLEMENTATION_ACTION
  until := design_presented AND user_approved
  applies_to := ALL_projects  ← including "simple" ones
  FORBIDDEN := "this is too simple to need a design"
}

---

PROCESS {
  1. EXPLORE   := read_files | check_docs | scan_recent_commits
                  IF complex_codebase → spawn_parallel_explore_agents
  2. ASK       := one_question_at_a_time | prefer_multiple_choice
                  focus := purpose + constraints + success_criteria
  3. APPROACHES := propose_2_to_3 {
                    minimal   ← smallest_change, maximum_reuse
                    clean     ← maintainability, elegant_abstractions
                    pragmatic ← balance_speed_and_quality
                  }
                  lead_with_recommendation + reasoning
  4. DESIGN    := present_in_sections | ask_approval_per_section
                  covers := architecture | components | data_flow | error_handling | testing
                  scale_each_section_to_complexity
  5. APPROVE   := MUST get_explicit_approval | revise_until_approved
  6. DOC       := write_to docs/plans/YYYY-MM-DD-<topic>-design.md | commit
  7. HANDOFF   := invoke writing-plans ONLY  ← no_other_implementation_skills
}

---

PRINCIPLES {
  one_question_per_message    := ABSOLUTE
  YAGNI_ruthlessly            := remove_unnecessary_from_all_designs
  incremental_validation      := present → approve → next_section
  multiple_choice_preferred   := easier_than_open_ended_when_possible
  go_back_freely              := clarify_when_something_unclear
}

---

FORBIDDEN {
  multiple_questions_at_once  ← overwhelming
  skip_design_for_simple      ← "simple" = most_wasted_work_from_unexamined_assumptions
  invoke_other_skills         ← ONLY writing-plans after approval
  implement_before_approved   ← violates HARD_GATE
}

---

REFS := {
  CAPSULE.md ← machine-first overview for fast routing
  FULL.md    ← prose: process detail | question techniques | design format | examples
  list.md    ← related: writing-plans | subagent-driven-development | writing-skills
}
