---
name: confidence-check
description: "Use before starting any implementation, design, or major refactoring to verify
  readiness through a structured 5-check assessment. Triggers when the agent is about to
  write code or make significant changes and has not yet confirmed: no duplicate exists,
  architecture is compliant, official docs have been reviewed, a working OSS reference is
  found, and the root cause (for fixes/improvements) is identified. Required before any
  task where wrong-direction work would cost >500 tokens to undo."
---

SKILL    := confidence-check
VERSION  := 1.0.0
PURPOSE  := prevent_wrong_direction_work_via_pre_implementation_confidence_assessment

TRIGGERS := {
  about_to_write_code_or_design
  starting_implementation_without_explicit_prior_check
  fixing_bug_or_performance_issue
  adding_feature_to_existing_codebase
  rework_cost_estimate > 500_tokens
}

IRON_LAW 🔴 ABSOLUTE {
  NEVER proceed if calculated_score < 0.90
  NEVER accept stated confidence in place of calculated score
  NEVER skip checks because task "seems simple"
  NEVER round up: 89.9% = CLARIFY, not PROCEED
  Score thresholds are exact: ≥0.90 proceed | ≥0.70 clarify | <0.70 STOP
}

FORBIDDEN := {
  skipping_checks_due_to_user_stated_confidence
  skipping_checks_due_to_urgency_or_authority
  rounding_scores: "close enough to 90%" counts as CLARIFY
  accepting_low_quality_oss: <100_stars_AND_unmaintained = 0_points
  using_memory_instead_of_checking_official_docs
}

PROCESS {
  1. Identify_phase := classify_task {
       IF fixing/improving/debugging → root_cause_check MANDATORY
       IF new_feature_from_scratch   → root_cause_check = N/A (auto-pass)
     }

  2. Run 5 checks (weights sum to 100%):

     CHECK_1 := no_duplicate_implementations (25%)
       USE Grep, Glob to search codebase for similar functions/modules
       PASS if no existing implementation solves same problem
       FAIL if duplicate exists → point to existing code instead

     CHECK_2 := architecture_compliance (25%)
       READ CLAUDE.md, PLANNING.md, README for project tech stack
       PASS if solution uses existing patterns and dependencies
       FAIL if introducing unnecessary new dependencies

     CHECK_3 := official_docs_verified (20%)
       USE WebFetch or WebSearch to check current official documentation
       PASS if API/library usage confirmed against live docs
       FAIL if relying on memory or assumptions (API version may have changed)

     CHECK_4 := oss_reference_found (15%)
       USE WebSearch or GitHub search for proven implementations
       PASS_FULL (15) if OSS has >1000 stars OR active maintenance (<3 months)
       PASS_PARTIAL (8) if active but lower quality
       FAIL (0) if no working OSS reference, or repo <100 stars AND unmaintained

     CHECK_5 := root_cause_identified (15%)
       IF task is fix/improvement: analyze logs, errors, metrics FIRST
       PASS if root cause clearly identified with evidence
       FAIL if solving symptoms without diagnosis
       N/A (auto-pass) if purely new feature with no bug component

  3. Calculate score := sum of passed check weights

  4. Decision:
     IF score >= 0.90 → PROCEED — output check results + "proceeding"
     IF score >= 0.70 → CLARIFY — list gaps, ask specific questions
     IF score < 0.70  → STOP — request more context before ANY implementation

  5. Output format:
     Confidence Checks:
       [PASS/FAIL] check_name — brief evidence note
       ...
     Score: X% — [PROCEED / CLARIFY / STOP]
     IF not PROCEED: Questions to answer first: [numbered list]
}

EMERGENCY_MODE {
  IF production_down OR critical_blocker:
    docs (20) and oss (15) MAY be skipped with assumed PASS
    duplicate (25), architecture (25), root_cause (15) REMAIN MANDATORY
    Reason: wrong fix wastes more time than 2-minute diagnosis
}

REFS := {
  FULL.md     ← detailed explanation + rationalization tables + examples
  CAPSULE.md  ← machine-first overview for fast routing
  list.md     ← related skills
}
