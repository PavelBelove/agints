---
name: writing-skills
description: "Use when creating a new AGIntS skill, editing an existing skill, or
  verifying a skill produces correct agent behavior before deployment."
---

SKILL    := writing-skills
VERSION  := 1.0.0
PURPOSE  := create_and_improve_skills_in_AGIntS_format_via_TDD

---

IRON_LAW 🔴 ABSOLUTE {
  NO_SKILL_WITHOUT_FAILING_TEST_FIRST
  applies_to := new_skills + edits + documentation_updates
  FORBIDDEN := {
    write_skill → skip_test
    edit_skill  → skip_test
    "it's just a simple addition"     → still requires test
    "documentation update only"       → still requires test
    "I'll test if problems emerge"    → test BEFORE deploy
  }
  violation → delete_skill → start_over
  delete_means_delete := no_reference | no_adapting | no_peeking
}

---

CSO {
  DESCRIPTION_FIELD := trigger_conditions_ONLY
  FORBIDDEN_IN_DESCRIPTION := {
    workflow_summary    ← Claude follows description instead of reading skill body
    process_details     ← creates shortcut; body becomes skipped documentation
    step_by_step_recap  ← defeats purpose of full skill content
  }
  FORMAT := "Use when [specific triggering conditions and symptoms]"
  person := third_person
  max_chars := 1024
  KEYWORD_COVERAGE := {
    include := symptoms | triggers | tool_names | error_messages | synonyms
    avoid   := technology_lock UNLESS skill_is_technology_specific
  }
  BAD  := "Use when creating skills — run baseline, write SKILL.md, test with subagent"
  GOOD := "Use when creating a new AGIntS skill, editing an existing skill, or verifying a skill produces correct agent behavior before deployment"
}

---

FORMAT {
  SKILL_DIR := skills/{level}/{skill-name}/
  FILES := {
    SKILL.md      ← SPEC notation; machine-readable; PRIMARY (this file)
    EN.md         ← full prose; human-readable; expandable detail
    list.md       ← related skills + when each is needed
    MANIFEST.json ← metadata (name, version, level, stack, requires, origin)
    tests/        ← pressure scenarios (RED phase artifacts)
  }

  FRONTMATTER {
    fields := name + description
    name        := letters-numbers-hyphens ONLY
    description := trigger_conditions_only | third_person | ≤1024_chars
    max_total   := 1024 chars
  }

  SKILL_MD_BODY {
    max_lines  := 500
    notation   := SPEC (`:=` `→` `∈` `{}` blocks)
    core_skills_target := ≤130 lines
    SECTIONS := SKILL + VERSION + PURPOSE + blocks + REFS
  }

  LEVELS := {
    core/   ← methodology skills; always loaded
    stack/  ← technology-specific; loaded by stack detector
    task/   ← task-specific; loaded on demand
  }
}

---

PROCESS {
  RED {
    1. run_pressure_scenario WITHOUT skill
    2. document_baseline := exact_choices + verbatim_rationalizations + pressure_triggers
    3. MUST see_failure before writing skill
  }
  GREEN {
    4. write_skill addressing_specific_baseline_failures
    5. no_extra_content_for_hypothetical_cases
    6. run_same_scenarios WITH skill → verify_compliance
  }
  REFACTOR {
    7. IF agent_finds_new_rationalization → add_explicit_counter → re-test
    8. REPEAT until_bulletproof
    9. build_rationalization_table from_all_test_iterations
  }
}

---

SKILL_TYPES {
  Technique  := concrete_method_with_steps    # condition-based-waiting, root-cause-tracing
  Pattern    := mental_model_for_problems     # flatten-with-flags, test-invariants
  Reference  := api_docs_syntax_tool_guides   # office-docs, cli-references
}

---

FORBIDDEN {
  Narrative_Example   := "In session 2025-10-03 we found..."   # not reusable
  Multi_Language      := example-js + example-py + example-go  # mediocre quality, maintenance burden
  Code_in_Flowcharts  := step1[label="import fs"]              # can't copy-paste
  Generic_Labels      := helper1 | step2 | pattern3            # no semantic meaning
  No_Test             := deploy_without_RED_phase              # Iron Law violation
  Workflow_In_Desc    := summarizing_process_in_description    # CSO violation; body gets skipped
}

---

REFS := {
  EN.md   ← full prose: TDD mapping table, CSO deep-dive, skill types, rationalization table,
             anti-patterns, AGIntS dual-format guidance, creation checklist
  list.md ← related skills: test-driven-development, brainstorming, verification-before-completion,
             systematic-debugging, synthesizer, using-agints
}
