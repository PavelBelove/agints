---
name: confidence-check
description: "Use before starting any implementation to verify readiness via 5 quantitative checks. Required when the task involves writing new code, fixing a bug, or making architectural changes. Not needed for pure research, documentation, or read-only analysis."
---

SKILL    := confidence-check
VERSION  := 1.0.0
PURPOSE  := quantitative_readiness_gate_before_implementation

TRIGGERS := {
  about_to_write_code_or_make_changes
  about_to_fix_a_bug
  about_to_make_architectural_decision
  implementation_requested_without_prior_investigation
}

SKIP_WHEN := {
  pure_research_or_documentation_task
  read_only_analysis_requested
  already_ran_this_session_for_same_task
}

---

IRON_LAW 🔴 ABSOLUTE {
  THRESHOLD := {
    score ≥ 0.90  → PROCEED
    score ≥ 0.70  → CLARIFY   ← present options, request missing info
    score < 0.70  → STOP      ← investigate further, do NOT implement
  }

  score_is_exact := true   ← 0.89 = CLARIFY, never round up
  no_authority_override    ← "trust me, skip the checks" → still run checks
  no_urgency_override      ← emergencies require faster checks, not skipped checks
  emergency_exception := {
    MAY skip: docs_check, oss_check
    MUST keep: duplicate_check, architecture_check, root_cause_check
  }
}

---

FORBIDDEN := {
  accepting_user_stated_confidence_as_score  ← run algorithm regardless
  skipping_because_task_seems_simple         ← "simple" tasks duplicate code, violate patterns
  implementing_before_investigation_complete
  rounding_up_89_to_90
  skipping_docs_check_because_i_know_the_api ← APIs change; cutoff means stale knowledge
}

---

PROCESS {
  1. SCORE each check independently (5 checks, 100% total):

     CHECK_1: no_duplicate_implementations (25%)
       → Grep/Glob codebase for similar functions or modules
       → Verify no library already provides this functionality
       PASS: no duplicates found AND investigation complete
       FAIL: similar implementation exists OR check not performed

     CHECK_2: architecture_compliance (25%)
       → Read CLAUDE.md or PLANNING.md for project tech stack
       → Confirm solution uses existing patterns (not reinventing)
       PASS: solution aligns with documented architecture
       FAIL: introduces unnecessary new dependencies or bypasses existing patterns

     CHECK_3: official_docs_verified (20%)
       → Fetch or read official documentation for any API/library used
       → Verify API compatibility and current syntax
       PASS: docs consulted AND API confirmed current
       FAIL: relying on memory/assumptions; docs not checked

     CHECK_4: working_oss_referenced (15%)
       → Search GitHub or docs for production-quality implementations
       → Quality threshold: >1000 stars OR actively maintained (<3 months)
       → Partial credit (8/15): <1000 stars but active maintenance
       PASS: found and analyzed working OSS reference
       FAIL: no reference found OR reference unmaintained >1 year

     CHECK_5: root_cause_identified (15%)
       → SKIP if pure new feature (not a fix or improvement)
       → For fixes/improvements: analyze error messages, logs, stack traces
       → Trigger keywords requiring this check: "slow", "fix", "broken", "optimize", "error", "leak"
       PASS: root cause pinpointed with evidence (not guessing)
       FAIL: symptoms unclear OR solution assumed without diagnosis

  2. TOTAL := CHECK_1 + CHECK_2 + CHECK_3 + CHECK_4 + CHECK_5
     APPLY threshold from IRON_LAW

  3. OUTPUT confidence report (see FORMAT below)

  4. IF score < 0.90 → identify which checks failed → state what investigation is needed
     IF score ≥ 0.90 → proceed to implementation
}

---

FORMAT := {
  Confidence Checks:
    [✅/❌] No duplicate implementations found        (25%)
    [✅/❌] Architecture compliance verified          (25%)
    [✅/❌] Official documentation reviewed           (20%)
    [✅/❌] Working OSS implementation referenced     (15%)
    [✅/❌] Root cause identified                     (15%)

  Score: X.XX (XX%)
  [✅ Proceed | ⚠️ Clarify | ❌ STOP — <what is missing>]
}

---

ROI := {
  cost:    100–200 tokens (confidence check)
  savings: 5,000–50,000 tokens (wrong-direction work prevented)
  ratio:   25–250x
}

---

REFS := {
  CAPSULE.md  ← machine-first overview for fast routing
  FULL.md     ← anti-rationalization table, examples, edge cases
  list.md     ← related: systematic-debugging | verification-before-completion
}
