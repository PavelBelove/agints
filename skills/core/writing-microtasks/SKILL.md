---
name: writing-microtasks
description: "Use after writing-plans when the implementation plan has been written and
  needs decomposition into atomic 1-session TDD cycles before skill annotation. Skip
  if the plan already has 3 or fewer steps."
---

SKILL    := writing-microtasks
VERSION  := 1.0.0
PURPOSE  := decompose_plan_into_atomic_1session_tdd_cycles

TRIGGERS := {
  plan_written_in_docs/plans/
  plan_has > 3_steps
  about_to_dispatch_to_execution_agents
}

---

MICROTASK_CRITERIA := {
  completable_AND_debuggable_in_1_session_without_context_overflow
  ends_with: green_tests AND commit
  atomic: ONE_logical_change_per_microtask
  size: ~10_to_30_min_real_time
  IF_larger → split_further

  CONTEXT_ESTIMATE := {
    small  ← single function, 1-2 files touched, <50 lines changed
    medium ← single module, 3-5 files, 50-200 lines changed
    large  ← cross-module, >5 files; WARN and suggest splitting
  }
}

---

FORBIDDEN := {
  "write the whole module"     ← not atomic
  microtask_without_tdd_cycle  ← every microtask has test + impl + commit
  microtask_with_context_estimate_large_without_warning
  skip_for_complex_steps       ← complex = MOST needs splitting
  bundle_unrelated_changes     ← even if "related domain"
}

---

PROCESS {
  1. READ full plan (docs/plans/<name>.md)

  2. FOR each plan step:
       a. ASSESS size vs MICROTASK_CRITERIA
       b. IF fits in 1 session → write MICROTASK block
          IF too large → split into N microtasks, each atomic
       c. IDENTIFY test + impl + commit per microtask
       d. DETECT dependencies between microtasks → set DEPENDS_ON

  3. EMBED microtasks into plan file using MICROTASK_FORMAT
     PRESERVE original plan steps as headers (microtasks nested under)

  4. VERIFY: every microtask has TDD_CYCLE block (test + impl + commit)

  5. OUTPUT: same plan file, extended with MICROTASK blocks
}

---

MICROTASK_FORMAT := {
  MICROTASK_N := <slug> {
    DEPENDS_ON := [microtask_ids]   ← [] if independent
    TDD_CYCLE := {
      test:   <test/file/path>::<test_function_name>
      impl:   <implementation/file/path>
      commit: "<conventional commit message>"
    }
    CONTEXT_ESTIMATE := small | medium | large
    NOTE := "<optional: any constraint or risk worth noting>"
  }
}

---

SKIP_RULES := {
  plan_has ≤ 3_steps → skip (already granular; go to skill-selector)
  microtask_already_written → skip (idempotent; don't re-decompose)
}

---

REFS := {
  CAPSULE.md ← machine-first overview for fast routing
  list.md    ← related: writing-plans | skill-selector | test-driven-development
}
