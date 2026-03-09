---
name: verification-before-completion
description: "Use when about to claim work is complete, fixed, or passing; before committing, creating PRs, or moving to the next task; when expressing any form of satisfaction or success about current work state."
---

SKILL    := verification-before-completion
VERSION  := 1.0.0
PURPOSE  := enforce_evidence_before_completion_claims | no_assertion_without_verification

TRIGGERS := {
  about_to_say: "done" | "fixed" | "complete" | "works" | "passes" | "looks good"
  about_to_express: satisfaction | confidence | relief | positive_assessment
  about_to_commit | create_PR | close_task | move_to_next_task
  about_to_delegate_to_agent_and_trust_their_report
  just_made_a_change_and_assuming_it_works
}

IRON_LAW 🔴 ABSOLUTE {
  NO_COMPLETION_CLAIM_WITHOUT_FRESH_VERIFICATION_EVIDENCE
  IF have_not_run_verification_command_in_this_message → CANNOT claim it passes
  Spirit_over_letter: paraphrasing or synonyms do NOT exempt from rule
  No_exceptions: tired | confident | "just this once" → still_must_verify
}

FORBIDDEN := {
  "should work now" without running verification
  "looks correct" without evidence
  "I'm confident" as substitute for evidence
  trusting_agent_success_reports without independent check
  partial_verification as sufficient (linter ≠ compiler ≠ tests)
  expressing satisfaction before verification ("Great!", "Done!", "Perfect!")
  using modal verbs implying success: "should", "probably", "seems to"
}

GATE_FUNCTION {
  BEFORE any status claim or satisfaction expression:
  1. IDENTIFY  → what_command_proves_this_claim?
  2. RUN       → execute_FULL_command (fresh, complete, not cached)
  3. READ      → full_output + exit_code + failure_count
  4. VERIFY    → does_output_confirm_claim?
     IF NO  → state_actual_status_with_evidence
     IF YES → state_claim_WITH_evidence attached
  5. ONLY_THEN → make_claim
  Skip_any_step = lying_not_verifying
}

VERIFICATION_TABLE {
  claim: "tests pass"       → requires: test_cmd_output_0_failures  | NOT: previous_run | "should pass"
  claim: "linter clean"     → requires: linter_output_0_errors       | NOT: partial_check | extrapolation
  claim: "build succeeds"   → requires: build_cmd_exit_0             | NOT: linter_passing | logs_look_good
  claim: "bug fixed"        → requires: test_original_symptom_passes | NOT: code_changed_assumed_fixed
  claim: "regression works" → requires: red_green_cycle_verified     | NOT: test_passes_once
  claim: "agent completed"  → requires: VCS_diff_shows_changes       | NOT: agent_reports_success
  claim: "requirements met" → requires: line_by_line_checklist       | NOT: tests_passing
}

RED_FLAGS {
  STOP when detecting:
  - hedging language: "should" | "probably" | "seems to" | "I think"
  - premature satisfaction: "Great!" | "Perfect!" | "Done!" | "Excellent!"
  - about to commit | push | PR without fresh verification
  - trusting_delegation: "the agent says it worked"
  - partial_substitution: "linter passed" for build | "tests pass" for requirements
  - rationalization: "just this once" | "I'm tired" | "I'm confident"
  - ANY wording implying success without having run verification this message
}

RATIONALIZATION_PREVENTION {
  "Should work now"              → RUN the verification
  "I'm confident"                → confidence ≠ evidence
  "Just this once"               → no exceptions
  "Linter passed"                → linter ≠ compiler
  "Agent said success"           → verify independently
  "I'm tired"                    → exhaustion ≠ excuse
  "Partial check is enough"      → partial proves nothing
  "Different words, rule exempt" → spirit over letter
}

PATTERNS {
  tests: {
    DO:   [run_test_cmd] → [see: 34/34 pass] → "All tests pass"
    DONT: "Should pass now" | "Looks correct"
  }
  regression_tdd: {
    DO:   write_test → run(PASS) → revert_fix → run(MUST_FAIL) → restore → run(PASS)
    DONT: "I've written a regression test" without red-green verification
  }
  build: {
    DO:   [run_build] → [see: exit_0] → "Build passes"
    DONT: "Linter passed" (linter does not check compilation)
  }
  requirements: {
    DO:   re_read_plan → create_checklist → verify_each → report_gaps_or_completion
    DONT: "Tests pass, phase complete"
  }
  agent_delegation: {
    DO:   agent_reports_success → check_VCS_diff → verify_changes → report_actual_state
    DONT: trust_agent_report
  }
}

REFS := {
  FULL.md      ← full prose version with context and worked examples
  CAPSULE.md   ← machine-first overview for fast routing
  list.md      ← related skills
}
