CAPSULE := skill-selector

PURPOSE := annotate_plan_steps_with_skill_directives_before_executor_dispatch

USE_WHEN := {
  plan_written_and_ready_for_execution
  about_to_dispatch_to_subagents
  skill_library_size ≥ 5
}

AVOID_WHEN := {
  skill_library_small (< 5 skills) ← overhead not worth it
  plan_has_single_step              ← trivial; direct dispatch
  executor_already_running          ← too late; selector runs before dispatch
}

CORE_RULES := {
  runs_once_per_plan_before_dispatch
  loads_capsules_only (not full SKILL.md) for routing decisions
  budget: ≤3 core + ≤6 total skills per step
  executor_MUST_NOT_do_skill_discovery ← defeats the purpose
  gaps → proposals only; human approves before creation
}

PROCESS_HINT := {
  pass-1: read_plan → load_capsules → match_inject_per_step → detect_gaps
          → output: annotated_plan + skill-proposals.md + skill-placement.log (if gaps)
  pass-2: (if proposals approved + skills created)
          read_proposals → read_placement_log → insert_approved → delete_artifacts
}

SWITCH_TO := {
  plan not written                          → writing-plans
  library < 5 skills                        → skip; dispatch directly
  session start                             → using-agints
  proposals_approved_skills_created         → skill-selector pass-2
}
RELATED := {
  writing-plans | subagent-driven-development | executing-plans | using-agints
}
