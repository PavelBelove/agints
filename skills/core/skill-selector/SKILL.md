---
name: skill-selector
description: "Use when an implementation plan has been written and needs skill directives
  injected into each step before dispatching to execution agents. Run after writing-plans
  and before subagent-driven-development or executing-plans, when the AGIntS skill
  library has 5 or more installed skills."
---

SKILL    := skill-selector
VERSION  := 1.0.0
PURPOSE  := inject_skill_directives_into_plan_steps_before_execution

TRIGGERS := {
  plan_written_and_ready_for_dispatch
  skill_library_size ≥ 5            ← fewer skills → direct dispatch is fine
  using_subagent_driven_development OR executing_plans
}

ROLE := plan_level_agent {
  NOT session_level                  ← using-agints handles that
  NOT executor                       ← executors receive directives, don't select
  runs_once_per_plan                 ← single pass before dispatch
  sees_full_plan + all_capsules      ← only agent with this dual context
}

---

FORBIDDEN := {
  executor_doing_skill_discovery     ← frees executor context for the actual task
  loading_full_skill_when_capsule_sufficient
  exceed_budget := {
    core_skills_per_step > 3
    total_skills_per_step > 6
  }
  inject_conflicting_skills_same_step  ← check CORE_RULES in capsules for clash
  use_lifecycle_deprecated           ← check MANIFEST.lifecycle before injecting
  inject_skill_without_matching_trigger ← capsule USE_WHEN must match step intent
}

---

PROCESS {
  1. READ plan (all steps/microtasks — full text, not file path)
  2. LOAD all CAPSULE.md from installed skills
     cost := ~50 tokens × N skills   ← 300 skills ≈ 15K tokens, one-time
  3. FOR each step:
       a. MATCH step intent → capsule USE_WHEN fields
       b. CHECK conflicts: CORE_RULES clash between matched skills?
       c. ENFORCE budget: ≤3 core + ≤6 total
          IF exceeded → use bundle OR consolidate
       d. DECIDE load level per skill (see LOAD_LEVELS)
       e. INJECT USE_SKILL directives inside step body (not separate block)
  4. DETECT gaps:
       IF step repeats pattern ≥3 times with no matching skill →
         add candidate to SKILL_GAPS log
  5. ESCALATION_RULES:
       IF step involves testing → ensure systematic-debugging is available
       IF conflict unresolvable → flag for human review, do not guess
  6. OUTPUT annotated_plan + skill-proposals.md + skill-placement.log (omit artifacts if no gaps)
}

---

LOAD_LEVELS := {
  capsule   ← routing hint only; ≤40 lines; default for standard practices
  spec      ← execution rules + process steps; default for discipline skills
  extended  ← anti-patterns, sub-skills; for complex critical steps
  full      ← complete prose; only if spec insufficient AND agent requests
}

LOAD_DEFAULTS := {
  core discipline skills (TDD, debugging, verification) → spec
  process skills (writing-plans, brainstorming)         → capsule
  stack/task skills                                     → capsule
  skill referenced in escalation                        → spec
}

---

USE_SKILL_FORMAT := {
  EMBED inside step body (not a separate block)
  FORMAT: "USE_SKILL: <name> LOAD: <level> PRIORITY: critical|standard|optional"
  EXAMPLE:
    STEP 1: Write failing test
    USE_SKILL: test-driven-development LOAD: spec PRIORITY: critical
    USE_SKILL: verification-before-completion LOAD: capsule PRIORITY: standard
    ACTION: create test_expired_token() ...
}

---

SKILL_GAPS_FORMAT := {
  SKILL_GAPS:
    candidate:        <name>
    frequency:        N      ← how many steps had this pattern
    context:          <what the recurring task looks like>
    creation_method:  synthesize | quick_write

  NOTE: gaps are proposals only → human approval required before creation
}

---

PROPOSAL_ARTIFACTS := {
  skill-proposals.md {
    location: same_dir_as_plan_file
    format:   human_readable_markdown
    purpose:  user_reviews_approves_rejects_changes_method
    lifecycle: temporary → deleted after pass-2
    fields_per_proposal: {
      skill_name
      needed_in: [microtask_ids]
      why: one_line_rationale
      creation_method: write | synthesize
      approve: "[ ] yes  [ ] no"   ← user checks
    }
  }

  skill-placement.log {
    location: same_dir_as_plan_file
    format:   SPEC_notation
    purpose:  agent_internal_record_of_where_to_insert
    lifecycle: temporary → deleted after pass-2
    format: PLACEMENT_LOG := [
      {skill: "<name>", microtasks: [ids], load: spec|capsule, priority: critical|standard|optional},
    ]
  }
}

PASS_2 := {
  TRIGGER: user_has_reviewed_skill-proposals.md AND approved_skills_created

  STEPS {
    1. READ skill-proposals.md → collect approved := entries where "[x] yes"
    2. READ skill-placement.log → load placement coordinates
    3. FOR each approved skill:
         find microtasks in placement log
         INSERT USE_SKILL directive at logged position
         FORMAT: "USE_SKILL: <name> LOAD: <level> PRIORITY: <priority>"
    4. FOR each rejected skill:
         skip → no insertion
    5. DELETE skill-proposals.md AND skill-placement.log
    6. REPORT: "Added N skills to M microtasks. Removed proposal artifacts."
  }

  FORBIDDEN := {
    re_run_full_pass_1       ← use placement log, not re-analysis
    insert_rejected_skills   ← user said no
    leave_artifacts_behind   ← always delete after pass-2
  }
}

---

OUTPUT := {
  annotated_plan          ← USE_SKILL directives injected per step
  skill-proposals.md      ← IF gaps found: human-readable proposals (omit if no gaps)
  skill-placement.log     ← IF gaps found: internal placement coordinates (omit if no gaps)
}

REFS := {
  CAPSULE.md  ← machine-first overview for fast routing
  FULL.md     ← detailed process, economics, examples, escalation
  list.md     ← related: writing-plans | subagent-driven-development | using-agints
}
