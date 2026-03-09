# Persuasion Principles for Skill Design — SPEC

SOURCE   := Meincke et al. 2025 (N=28,000) + Cialdini 2021
FINDING  := persuasion_techniques → compliance 33% → 72% (p<.001)
RATIONALE := LLMs trained_on_human_text → respond_to_same_patterns

---

PRINCIPLES := {
  Authority    ← imperative_language, non-negotiable_framing, eliminates_rationalization
  Commitment   ← public_declaration_before_action, TodoWrite_tracking
  Scarcity     ← time-bound: "IMMEDIATELY after X", sequential_dependencies
  Social_Proof ← "Every time", "X without Y = failure", universal_patterns
  Unity        ← "our codebase", shared_goals, collaborative_language
  Reciprocity  ← RARELY; can_feel_manipulative
  Liking       ← NEVER for compliance; creates_sycophancy
}

---

BY_SKILL_TYPE := {
  Discipline-enforcing  → Authority + Commitment + Social_Proof | AVOID: Liking + Reciprocity
  Guidance/technique    → Moderate_Authority + Unity            | AVOID: heavy_authority
  Collaborative         → Unity + Commitment                    | AVOID: Authority + Liking
  Reference             → Clarity_only                          | AVOID: all_persuasion
}

---

AUTHORITY {
  USE   := "YOU MUST" | "NEVER" | "No exceptions" | "Delete means delete"
  AVOID := "Consider..." | "when possible" | "generally"
  EFFECT := eliminates_"is_this_an_exception?"_question
}

COMMITMENT {
  USE   := require_announcement_before_action
  FORMAT := 'Announce: "I am using [skill] to [purpose]"'
  EFFECT := public_declaration → consistency_pressure
}

SOCIAL_PROOF {
  USE   := "Checklists without TodoWrite = steps get skipped. Every time."
  AVOID := "Some people find X helpful"
}

BRIGHT_LINE_RULE {
  WHY   := absolute_rules → no_wiggle_room → no_rationalization_possible
  HOW   := close_specific_loopholes_from_testing
  EXAMPLE := "Delete means delete. No reference. No adapting. No peeking."
             ← each clause closes one rationalization found in pressure testing
}

---

ETHICAL_USE {
  LEGITIMATE   := ensure_critical_practices_followed | prevent_predictable_failures
  ILLEGITIMATE := manipulate_for_gain | false_urgency | guilt_compliance
  TEST         := "Would this serve user's genuine interests if fully understood?"
}

REFS := {
  persuasion-principles-FULL.md ← full text with examples, research citations, quick reference
}
