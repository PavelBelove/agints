---
name: receiving-code-review
description: "Use when receiving code review feedback — verify before implementing, push back technically when wrong, never perform agreement, never implement unverified suggestions"
when_to_use: when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable
version: 1.0.0
---

SKILL    := receiving-code-review
VERSION  := 1.0.0
PURPOSE  := technical_rigor_when_processing_code_review_feedback

IRON_LAW 🔴 ABSOLUTE {
  verify_before_implementing           // never implement without codebase check
  no_performative_agreement            // never "You're right!", "Great point!", "Thanks!"
  clarify_all_unclear_before_acting   // one unclear item = STOP entire batch
  unverifiable_suggestion := MUST_NOT_implement  // "sounds reasonable" ≠ verification
}

TRUST_LEVELS {
  internal_code_reviewer_agent := HIGH      // trusted; still verify technical claims
  partner_or_collaborator      := HIGH      // trusted; still ask if scope unclear
  external_human_reviewer      := SKEPTICAL // check: breaks existing? lacks context?
  external_ai_tool             := LOW       // treat as suggestions; always verify
  ci_or_linter                 := OBJECTIVE // fix or explicitly justify ignoring
}

PROCESS {
  ANNOUNCE: "Receiving code review feedback."

  1. READ_ALL_FEEDBACK {
    read complete feedback before reacting
    classify each item: BLOCKING | ADVISORY
    group related items (may share root cause)
  }

  2. CLARIFY_UNCLEAR {
    IF any_item_unclear → STOP; ask before implementing anything
    WHY: items may be related; partial understanding = wrong implementation
    FORMAT: "Understand items [list]. Need clarification on [list] before proceeding."
  }

  3. VERIFY_EACH_ITEM {
    check: technically correct for THIS codebase?
    check: breaks existing functionality?
    check: reason for current implementation? (legacy / compat)
    check: reviewer had full context?
    check: violates YAGNI? (grep for actual usage first)
    IF cannot_verify → state limitation, ask for direction; DO NOT implement
  }

  4. EVALUATE_AND_RESPOND {
    WHEN_CORRECT  → acknowledge briefly; skip to implementation
    WHEN_WRONG    → push back with technical reasoning + evidence (code/tests/docs)
    WHEN_CONFLICTS_PARTNER → stop; discuss with partner first
    WHEN_ARCHITECTURAL → involve partner before implementing
  }

  5. IMPLEMENT {
    order: BLOCKING → simple_fixes → complex_fixes
    one_item_at_a_time
    test_after_each
    verify_no_regressions
    prefer_separate_commit_per_concern
  }
}

RESPONSE_TEMPLATES {
  FIXED         := "Fixed. {what_changed} at {location}."           // include SHA or file:line
  ACKNOWLEDGED  := "{Requirement restated}. Implementing."
  QUESTION      := "Need clarification: {specific_question}."
  DISAGREE      := "Not implementing: {technical_reason}. {evidence}."
}

FORBIDDEN {
  "You're absolutely right!"
  "Great point!"
  "Excellent feedback!"
  "Thanks for [anything]"
  "Let me implement that now"  // before verification
  implement_while_any_unclear
  implement_unverifiable_suggestion
  defer_to_reviewer_authority_over_technical_facts
  use_review_as_refactor_excuse  // scope creep anti-pattern
}

REFS {
  FULL.md   := detailed_examples_and_trust_levels
  list.md   := related_skills
}
