---
name: systematic-debugging
description: "Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes"
---

SKILL    := systematic-debugging
VERSION  := 1.0.0
PURPOSE  := find_root_cause_before_fixing | symptom_fixes_are_failure

TRIGGERS := {
  bug_found | test_failure | unexpected_behavior | performance_issue
  build_failure | integration_issue
  ESPECIALLY: time_pressure | "obvious_quick_fix" | multiple_failed_fixes
  NEVER_SKIP_WHEN: issue_seems_simple | you_are_in_a_hurry | manager_wants_NOW
}

IRON_LAW 🔴 ABSOLUTE {
  NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
  IF phase_1_incomplete → fixes_forbidden
  symptom_fix = failure
  violating_letter = violating_spirit
}

FORBIDDEN := {
  "quick fix now, investigate later"
  "just try X and see if it works"
  multiple_changes_at_once
  fix_without_failing_test
  "I'll adapt the pattern" (without reading completely)
  "one more fix attempt" (after ≥2 failed)
  proposing_solutions_before_tracing_data_flow
}

PROCESS {
  PHASE_1: ROOT_CAUSE {
    1. read_error_messages_completely
       - stack traces end-to-end, line numbers, file paths, error codes
       - errors often contain exact solution
    2. reproduce_consistently
       - IF not_reproducible → gather_more_data, NOT guess
    3. check_recent_changes
       - git diff | recent commits | dependencies | config | env differences
    4. IF multi_component_system {
         add_diagnostic_instrumentation at EACH component boundary:
           log_entry_data + log_exit_data + verify_propagation + check_state
         run_once → gather_evidence → identify_failing_component → investigate
         NOT: propose fixes before evidence gathered
       }
    5. IF error_deep_in_stack → trace_data_flow_backward
       - see root-cause-tracing.md for full technique
       - fix at source, NOT at symptom point
  }

  PHASE_2: PATTERN_ANALYSIS {
    1. find_working_examples (similar code in same codebase)
    2. read_reference_implementation COMPLETELY (every line, not skim)
    3. list ALL differences between working and broken (nothing is "too small")
    4. understand_dependencies (config, environment, assumptions)
  }

  PHASE_3: HYPOTHESIS {
    1. form_single_hypothesis: "X is root cause because Y" (write it down, specific)
    2. test_minimally (SMALLEST possible change, one variable at a time)
    3. IF pass → PHASE_4
       IF fail → form NEW hypothesis, NOT add more fixes on top
    4. IF unknown → say "I don't understand X", ask, research more
  }

  PHASE_4: IMPLEMENTATION {
    1. create_failing_test (see superpowers:test-driven-development)
    2. implement_single_fix (root cause only)
       - no "while I'm here" improvements
       - no bundled refactoring
    3. verify: tests_pass AND no_regressions AND issue_resolved
    4. IF fix_fails → STOP, count_attempts:
         IF < 3 → return_to_phase_1 (re-analyze with new information)
         IF ≥ 3 → STOP: question_architecture (see below)
  }

  IF 3+_fixes_failed {
    PATTERN_DETECTED: each_fix_reveals_new_problem_in_different_place
    STOP: question_fundamentals {
      - Is this pattern architecturally sound?
      - Sticking with it through inertia?
      - Refactor architecture vs continue patching symptoms?
    }
    REQUIRE: discuss_with_human_before_any_more_fixes
    NOTE: wrong_architecture ≠ failed_hypothesis
  }
}

RED_FLAGS {
  → STOP → phase_1:
    "quick fix now, investigate later" | "just try changing X"
    multiple_changes_at_once | "it's probably X, let me fix that"
    "I don't fully understand but this might work"
    "here are the main problems: [lists fixes without investigation]"
  → STOP → question_architecture:
    "one more fix attempt" (when ≥2 already tried)
    each_fix_reveals_new_symptom_elsewhere
}

HUMAN_SIGNALS → STOP → phase_1 {
  "Is that not happening?"  ← you assumed without verifying
  "Will it show us...?"     ← you should have added evidence gathering
  "Stop guessing"           ← proposing fixes without understanding
  "Ultrathink this"         ← question fundamentals, not just symptoms
  frustrated "We're stuck?" ← your approach isn't working
}

RATIONALIZATION_TRAPS := {
  "simple bug, no process needed" → simple_bugs_have_root_causes_too
  "emergency, no time"            → systematic_is_FASTER_than_thrashing
  "try first, investigate later"  → first_fix_sets_pattern_do_right_from_start
  "test after confirming"         → untested_fixes_dont_stick
  "multiple fixes save time"      → cannot_isolate_what_worked_causes_new_bugs
  "reference too long, I'll adapt" → partial_understanding_guarantees_bugs
  "I see the problem"             → seeing_symptom ≠ understanding_root_cause
  "one more fix" (after 2+)       → 3+_failures = architectural_problem
}

REFS := {
  CAPSULE.md               ← machine-first overview for fast routing
  FULL.md                  ← prose companion (rationale, examples, impact data)
  root-cause-tracing.md    ← backward stack tracing technique (SPEC)
  condition-based-waiting.md ← replace timeouts with condition polling (SPEC)
  defense-in-depth.md      ← multi-layer validation after root cause found (SPEC)
  list.md                  ← related skills
  scripts/find-polluter.sh ← bisect which test creates unwanted state
}
