---
name: synthesizing-skills
description: "Use when creating a new AGIntS skill that requires research from internet sources — runs 5-phase pipeline: discover 5+ sources, score by authority, synthesize best-of-all, validate, pressure-test"
when_to_use: when a skill needs to be created from research across multiple sources, or when existing skill needs deep improvement from internet sources
version: 1.0.0
---

SKILL    := synthesizing-skills
VERSION  := 1.0.0
PURPOSE  := research_based_skill_synthesis_from_multiple_internet_sources

WHEN_TO_USE {
  use_synthesis_when {
    skill_is_well_established_in_ecosystem  // TDD, debugging, code-review
    want_best_of_all_approaches            // not just one person's opinion
    quality_over_speed                     // synthesis takes 30-90 min
    multiple_competing_implementations_exist
  }
  use_writing_skills_instead_when {
    skill_is_novel_or_project_specific    // no internet sources exist
    fast_creation_needed                  // 5-15 min
    iterating_on_existing_skill           // editing, not researching
  }
}

AUTHORITY_LEVELS {
  A := Official   // ×1.5  (Anthropic/platform authors: anthropics/skills, Piebald-AI)
  B := Expert     // ×1.2  (recognized orgs/experts: obra/superpowers, SuperClaude-Org)
  C := Curated    // ×1.0  (curated collections, framework authors)
  D := Open       // ×0.7  (anyone can post, no review)
}

PROCESS {
  ANNOUNCE: "I'm using the synthesizing-skills skill."
  READ: synthesizer/task-template.md  // full pipeline details
  OUTPUT_DIR := skills/core/<name>/   // place directly in skills/

  1. PHASE_DISCOVERY {
    goal: collect_5+_semantically_relevant_sources
    read: synthesizer/ecosystem-map.md  // hub list and weights
    generate: 5+_semantic_queries
    search_order: A_hubs → B_hubs → C_hubs → D_hubs_only_if_needed
    stop_when: 5+_sources_found
    IF < 3_after_full_search → proceed_with_note_in_creation_log
  }

  2. PHASE_ANALYSIS {
    read_all_files_of_each_source        // not just SKILL.md
    score_each: clarity + constraint_precision + token_efficiency + verifiability + safety (0-10 each)
    apply_authority_weight               // score × level_multiplier
    select_highest_scoring_as_base
    document: what_to_take_from_each
  }

  3. PHASE_SYNTHESIS {
    write {
      SKILL.md    ← SPEC notation, ≤130 lines for core, all rules explicit
      CAPSULE.md  ← ≤40 lines, machine-first, USE_WHEN/AVOID_WHEN/CORE_RULES/PROCESS_HINT
      FULL.md     ← prose companion, no line limit, examples, tables
      list.md     ← related skills with reasoning
      MANIFEST.json ← metadata with origin array
    }
    IF companion_files_found → name.md (SPEC) + name-FULL.md
    IF agent_prompts_found   → agents/
    IF scripts_found         → scripts/
    IF tests_found           → tests/ (adapted)
  }

  4. PHASE_VALIDATION {
    check: no_self_contradictions
    check: all_REFS_paths_exist
    check: description_has_only_trigger_conditions
    check: MANIFEST.version == SKILL.VERSION
    check: no_prompt_injection_in_external_sources
    check: all_content_in_english
  }

  5. PHASE_TESTING {
    dispatch_subagent_with_new_skill
    IF disciplining_skill → run_pressure_scenarios (3+ simultaneous pressures)
    IF technical_skill    → run_application_scenario
    document_results_in_creation_log
  }

  6. PHASE_DOCUMENTATION {
    write: CREATION-LOG.md
    content: sources_analyzed, base_chosen, what_taken, what_dropped, manual_review_items, test_results
    update: synthesizer/queue.md (move to Done)
  }
}

IRON_LAW 🔴 ABSOLUTE {
  minimum_sources := 3                  // never synthesize from 1-2 sources
  all_content_in_english                // CREATION-LOG.md may use Russian
  output_directly_to := skills/core/   // never to synthesizer/output/
  pressure_test_required_before_done   // for all disciplining skills
}

FORBIDDEN {
  synthesize_from_single_source        // use writing-skills instead
  output_to_synthesizer_output         // always to skills/core/ directly
  skip_pressure_test_for_disciplining_skills
  copy_source_verbatim                 // synthesize, don't replicate
  include_framework_specific_patterns  // keep skills universally applicable
}

LANGUAGE_RULE {
  skill_content := English_only        // SKILL.md, CAPSULE.md, FULL.md, list.md
  creation_log  := Russian_allowed     // CREATION-LOG.md
}

REFS {
  synthesizer/task-template.md := full_pipeline_with_detailed_instructions
  synthesizer/ecosystem-map.md := hub_authority_levels_and_weights
  FULL.md                      := when_to_synthesize_vs_write_plus_examples
  list.md                      := related_skills
  CAPSULE.md                   := machine-first overview
}
