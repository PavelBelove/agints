CAPSULE := verification-before-completion

PURPOSE := enforce_fresh_evidence_before_any_completion_or_success_claim

USE_WHEN := {
  about to say "done", "fixed", "works", "passes", "complete", "looks good"
  about to express satisfaction, confidence, or relief about work state
  about to commit, create PR, close task, or move to next task
  about to trust an agent's success report without independent check
  just made a change and feeling it works without verifying
}

AVOID_WHEN := {
  actively investigating without claiming | stating explicit uncertainty | planning without asserting status
}

CORE_RULES := {
  NO_COMPLETION_CLAIM_WITHOUT_FRESH_VERIFICATION_EVIDENCE   ← absolute, no exceptions
  Run the command THIS message — previous runs do not count
  Spirit_over_letter: paraphrases and synonyms still trigger the rule
  agent_report ≠ verification — check VCS diff independently
  partial_check ≠ full_check — linter ≠ compiler ≠ tests ≠ requirements
}

PROCESS_HINT := {
  1_IDENTIFY   → what command proves this claim?
  2_RUN        → execute full command fresh
  3_READ       → full output + exit code + failure count
  4_VERIFY     → does output confirm claim?
  5_CLAIM      → only then state claim WITH evidence attached
}

SWITCH_TO := {
  need_to_find_root_cause_first → systematic-debugging
  writing_a_regression_test     → test-driven-development
}
RELATED := {
  systematic-debugging | test-driven-development | confidence-check
}
