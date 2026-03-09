# Anthropic Skill Authoring Best Practices — SPEC

SOURCE  := docs.anthropic.com/en/docs/agents-and-tools/agent-skills
VERSION := 2026

---

LOADING {
  at_startup    := name + description only (metadata)
  on_trigger    := SKILL.md loaded
  on_demand     := additional files (heavy ref, examples)
  IMPLICATION   := every_token_in_SKILL.md_costs_context
}

---

NAMING {
  PREFER     := gerund_form  ← "Processing PDFs", "Analyzing Spreadsheets"
  ACCEPTABLE := noun_phrase | action_oriented
  FORBIDDEN  := { "Helper" | "Utils" | "Tools" | vague | generic }
}

---

DESCRIPTION {
  person     := third_person  ← injected into system prompt
  format     := "Use when [trigger] OR [trigger]"
  max_chars  := 1024
  name_max   := 64
  MUST include := { what_skill_does | when_to_use | key_terms_for_discovery }
  FORBIDDEN  := { first_person | vague | "Helps with documents" | "Processes data" }

  BAD  := "Helps with documents"
  GOOD := "Extracts text and tables from PDF files, fills forms. Use when working
           with PDFs or when user mentions PDF, forms, or document extraction."
}

---

SKILL_MD {
  max_lines  := 500           ← hard limit; split if approaching
  assumption := Claude_is_already_smart
  FORBIDDEN  := { explain_what_Claude_knows | justify_token_cost_per_para }
  CHALLENGE_each_line := "Does Claude really need this? Can I assume Claude knows it?"
}

---

PROGRESSIVE_DISCLOSURE {
  SKILL.md  := overview + quick_start + references_to_detail
  heavy_ref → separate_file  ← linked, loaded_on_demand
  organize  := by_domain NOT by_type  ← user asks about sales → load sales.md only
  depth     := one_level_max  ← no deeply_nested: SKILL.md → detail.md (not → sub.md → sub-sub.md)
}

---

DEGREES_OF_FREEDOM {
  high   := text_instructions  ← multiple_approaches_valid | context_dependent
  medium := pseudocode_with_params  ← preferred_pattern + variation_acceptable
  low    := exact_code  ← safety_critical | exact_sequence_required
  RULE   := match_specificity_to_fragility
}

---

WORKFLOW_PATTERNS {
  PREFER  := workflows_over_one_shots  ← for_complex_tasks
  INCLUDE := feedback_loops IF quality_critical
  STEPS   := clear_numbered | verifiable_intermediate_outputs
}

---

EVALUATION_FIRST {
  ORDER := identify_gaps → create_evals → baseline → write_minimal_skill → iterate
  FORBIDDEN := write_extensive_docs_before_testing
  evals_min := 3
  test_with := { real_scenarios | multiple_models }
}

---

SCRIPTS {
  handle_errors    := explicitly  ← NEVER punt_to_Claude
  document_constants := WHY_not_just_what  ← no_voodoo_numbers
  paths            := forward_slashes_only  ← no_Windows_style
  PREFER           := prebuilt_scripts  ← more_reliable + saves_tokens
}

---

ANTI_PATTERNS {
  too_many_options  ← provide_default + escape_hatch
  time_sensitive    ← use_old_patterns_section
  inconsistent_terms ← one_term_per_concept
  deep_nesting      ← max_one_level_of_file_references
}

---

CHECKLIST {
  description_specific_with_key_terms   := MUST
  description_includes_when_to_use      := MUST
  SKILL.md_under_500_lines              := MUST
  no_time_sensitive_content             := MUST
  consistent_terminology                := MUST
  examples_concrete_not_abstract        := MUST
  file_refs_one_level_deep              := MUST
  scripts_handle_errors                 := MUST
  no_windows_paths                      := MUST
  three_evals_minimum                   := MUST
  tested_real_scenarios                 := MUST
}

REFS := {
  anthropic-best-practices-FULL.md ← full original with all examples and patterns
}
