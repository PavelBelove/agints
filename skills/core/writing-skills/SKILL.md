---
name: writing-skills
description: "Use when creating a new AGIntS skill, editing an existing skill, or
  verifying a skill produces correct agent behavior before deployment."
---

SKILL    := writing-skills
VERSION  := 1.1.0
PURPOSE  := create_and_improve_skills_in_AGIntS_format_via_TDD

---

IRON_LAW 🔴 ABSOLUTE {
  NO_SKILL_WITHOUT_FAILING_TEST_FIRST
  applies_to := new_skills + edits + documentation_updates
  FORBIDDEN := {
    write_skill → skip_test           | edit_skill → skip_test
    "it's just a simple addition"     → still requires test
    "documentation update only"       → still requires test
    "I'll test if problems emerge"    → test BEFORE deploy
  }
  violation → delete_skill → start_over
  delete_means_delete := no_reference | no_adapting | no_peeking
}

---

NOTATION := md/notation.md {           # full spec in md/notation.md
  :=  → definition    →  → implication    {}  → block/set
  ←   → annotation    |  → OR             #   → comment
  🔴 ABSOLUTE | FORBIDDEN | MUST | PREFER | ALLOWED  := strength_markers
  BLOCK { key := value | CONDITION → action }        ← template pattern
  use(symbol) IF reduces_tokens AND keeps_clarity
}

---

AUTHORING {
  1. write_EN.md    := full_prose (WHY + HOW + examples + rationale)
  2. write_SKILL.md := compress_EN → SPEC_notation (apply NOTATION above)
  IF unsure → EN.md; NEVER compress prematurely
  SKILL.md := machine_primary | EN.md := human_detail | load_EN := on_demand
}

---

CSO {
  DESCRIPTION_FIELD := trigger_conditions_ONLY
  FORBIDDEN_IN_DESCRIPTION := {
    workflow_summary    ← agent follows description instead of reading skill body
    process_details     ← creates shortcut; skill body becomes skipped documentation
  }
  FORMAT := "Use when [specific triggering conditions and symptoms]"
  person := third_person | max_chars := 1024
  KEYWORD_COVERAGE := { include := symptoms | triggers | errors | synonyms
                         avoid   := technology_lock UNLESS skill_is_specific }
  BAD  := "Use when creating skills — run baseline, write SKILL.md, test with subagent"
  GOOD := "Use when creating a new AGIntS skill, editing an existing skill, or verifying a skill produces correct agent behavior before deployment"
}

---

FORMAT {
  SKILL_DIR := skills/{level}/{skill-name}/
  FILES := {
    SKILL.md      ← SPEC; machine-readable; PRIMARY
    EN.md         ← prose; human-readable; load on demand
    list.md       ← related skills + when each is needed
    MANIFEST.json ← name | version | level | stack | requires | origin
    tests/        ← pressure scenarios (RED phase artifacts)
  }
  FRONTMATTER    { fields := name + description | max_total := 1024 chars }
  SKILL_MD_BODY  { max_lines := 500 | core_target := ≤130 | notation := SPEC }
  LEVELS := { core/ ← always loaded | stack/ ← by detector | task/ ← on demand }
}

---

PROCESS {
  RED     { 1. run_scenario WITHOUT skill
            2. document := exact_choices + verbatim_rationalizations + triggers
            3. MUST see_failure before writing }
  GREEN   { 4. write_skill addressing_specific_baseline_failures
            5. no_extra_content_for_hypothetical_cases
            6. run_same_scenarios WITH skill → verify_compliance }
  REFACTOR { 7. IF new_rationalization → add_counter → re-test
              8. REPEAT until_bulletproof
              9. build_rationalization_table }
}

---

SKILL_TYPES := Technique | Pattern | Reference   # see EN.md for definitions

FORBIDDEN {
  Narrative_Example  := "In session 2025-10-03 we found..."
  Multi_Language     := example-js + example-py + example-go
  Code_in_Flowcharts := step1[label="import fs"]
  Generic_Labels     := helper1 | step2 | pattern3
  No_Test            := deploy_without_RED_phase
  Workflow_In_Desc   := summarizing_process_in_description
}

---

REFS := {
  CAPSULE.md                     ← machine-first overview for fast routing
  FULL.md                        ← prose: TDD mapping | CSO deep-dive | AUTHORING guide |
                                           rationalization table | anti-patterns | checklist
  anthropic-best-practices.md   ← official Anthropic guidance (SPEC); -FULL.md = full
  persuasion-principles.md      ← compliance psychology (SPEC); -FULL.md = full + citations
  testing-skills-with-subagents.md ← pressure testing protocol (SPEC); -FULL.md = full
  tests/pressure-scenarios.md   ← Red-фаза: готовые сценарии для тестирования
  list.md                       ← related: test-driven-development | brainstorming |
                                            verification-before-completion | using-agints
}
