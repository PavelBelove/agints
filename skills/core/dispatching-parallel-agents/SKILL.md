---
name: dispatching-parallel-agents
description: "Use when 3+ independent, parallel-safe tasks exist — dispatches them simultaneously via Task tool, monitors results, merges back, verifies full test suite passes"
when_to_use: when multiple independent, parallel-safe tasks can be solved concurrently to reduce total time
version: 1.0.0
---

SKILL    := dispatching-parallel-agents
VERSION  := 1.0.0
PURPOSE  := parallel_task_dispatch_to_reduce_total_implementation_time
RIGIDITY := MEDIUM_FREEDOM  // gate checks are rigid; prompt structure is flexible

IRON_LAW 🔴 ABSOLUTE {
  minimum_tasks_for_parallel := 3   // 2 tasks = sequential; overhead not worth it
  independence_gate_required         // BOTH tests must pass before dispatch
  orchestrator_must_not_read_files   // context minimization: delegate all file work
  verify_full_test_suite_after_merge // integration check mandatory
  never_assume_independence          // verify each pair explicitly
}

INDEPENDENCE_GATE {
  // Two separate tests — BOTH must pass to dispatch in parallel
  TEST_1_LOGICAL_INDEPENDENCE {
    question: "Does failure of Task A cause Task B to also fail?"
    // if YES → sequential; if NO for all pairs → PASS
    examples {
      PASS: "test_auth fails, test_payment fails" (separate systems)
      FAIL: "null pointer in base class causes all subclass tests to fail"
    }
  }
  TEST_2_PARALLEL_SAFETY {
    question: "Can agents work concurrently without conflicting?"
    check: no_shared_files_being_modified
    check: no_shared_db_state_or_mock_config
    check: no_shared_config_being_changed
    check: no_logic_dependencies_between_fixes
    examples {
      PASS: auth tests in auth/ + payment tests in payment/ + notification tests in notifications/
      FAIL: agents both modify utils/database.py (shared file conflict)
      FAIL: agents both change environment variables / test fixtures
    }
  }
  IF either_test_fails → sequential_execution
  IF both_pass → proceed_to_dispatch
}

PROCESS {
  ANNOUNCE: "I'm using the dispatching-parallel-agents skill."

  1. ASSESS_CANDIDATES {
    identify: what tasks need to be done?
    count: are there 3+ tasks?
    IF count < 3 → execute_sequentially; exit_skill
  }

  2. VERIFY_INDEPENDENCE {
    apply INDEPENDENCE_GATE to all task pairs
    group_independent_parallel_safe_tasks
    remaining_tasks → sequential_queue
  }

  3. DISPATCH_PARALLEL {
    use_task_tool_for_each_agent
    each_prompt MUST contain {
      SCOPE    := specific files/dirs to work on
      TASK     := what to implement/fix (concrete)
      OUTPUT   := what to return (findings / code / analysis)
      BOUNDARY := what NOT to touch
      CONTEXT  := relevant background (no file reads needed by agent)
    }
    prompt_length_limit := <200 lines // optimal <150 lines
    announce: "Dispatching N agents in parallel: [task list]"
  }

  4. MONITOR_AND_COLLECT {
    wait_for_all_agents
    IF agent_stuck_beyond_5_min → check_output, cancel_and_retry_sequentially
    collect: all agent outputs
  }

  5. REVIEW_AND_MERGE {
    scan_for_conflicts {
      same_file_modified_differently?
      conflicting_implementations?
      contradictory_logic?
    }
    IF conflicts → resolve_manually; document_resolution
    apply_all_changes
  }

  6. VERIFY {
    run_full_test_suite               // MANDATORY — not just affected tests
    IF tests_fail → identify_regression; fix; re-run
    IF tests_pass → report_completion
  }
}

ORCHESTRATOR_CONTEXT_MINIMIZATION {
  // Orchestrator MUST NOT do implementation work — ONLY coordinate
  FORBIDDEN_IN_ORCHESTRATOR := [
    read_source_files,
    write_code,
    run_tests_in_main_context,
    investigate_failures_directly
  ]
  ALLOWED := [
    read_task_descriptions,
    dispatch_agents,
    collect_results,
    run_test_suite_for_verification,
    resolve_merge_conflicts
  ]
  IF_TEMPTED_TO_READ_FILE: "STOP — delegate to a subagent instead"
}

DISPATCH_DECISION {
  USE_PARALLEL_AGENTS_WHEN {
    3+_logically_independent_tasks
    all_parallel_safe
    total_time_saving > dispatch_overhead (est 2-3 min per agent)
    failures_have_different_root_causes
  }
  STAY_SEQUENTIAL_WHEN {
    only_2_tasks
    tasks_share_files
    failures_share_root_cause (one_bug_many_symptoms)
    unclear_dependencies       // verify first
    fast_single_fix           // sequential faster than dispatch
  }
}

FAILURE_MODES {
  agent_stuck      := { detect: >5min no output; action: cancel + retry_sequentially }
  conflicting_fixes := { detect: same_file_modified; action: manual_resolution + document }
  false_independence := { detect: test_failures_after_merge; action: revert + reanalyze }
  integration_breaks := { detect: passing_individually_failing_together; action: staged_revert }
}

FORBIDDEN {
  dispatch_fewer_than_3_tasks_in_parallel
  skip_independence_gate
  dispatch_agents_that_modify_same_files
  assume_tests_pass_without_running_suite
  read_source_files_in_orchestrator_context
  dispatch_without_scope_boundary_in_prompt
}

REFS {
  FULL.md  := detailed_examples_independence_test_cases_failure_modes
  list.md  := related_skills
}
