CAPSULE := writing-microtasks

PURPOSE := decompose_plan_into_atomic_1session_tdd_cycles

USE_WHEN := {
  plan_written (docs/plans/ exists)
  plan_has > 3_steps
  before_skill-selector_annotation
  before_dispatching_to_executors
}

AVOID_WHEN := {
  plan_has ≤ 3_steps      ← already granular; go to skill-selector directly
  microtasks_already_exist ← idempotent; skip
  no_plan_yet              ← write-plans first
}

CORE_RULES := {
  every_microtask: 1_session + green_tests + commit
  atomic: ONE_logical_change
  FORBIDDEN: "write the whole module"
  large_estimate → split_further (don't accept large)
}

PROCESS_HINT := {
  1_READ_plan
  2_ASSESS_each_step (fits 1 session? split if not)
  3_WRITE_MICROTASK_blocks (embed in plan file)
  4_VERIFY (every microtask has TDD_CYCLE)
}

SWITCH_TO := {
  plan_not_yet_written    → writing-plans
  microtasks_done         → skill-selector
  step_unclear            → clarify with human before decomposing
}

RELATED := { writing-plans, skill-selector, test-driven-development }
