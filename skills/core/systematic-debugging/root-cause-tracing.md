ROOT_CAUSE_TRACING := technique | companion_to(systematic-debugging)
PURPOSE := trace_backward_through_call_stack_to_find_original_trigger

PRINCIPLE := {
  bugs_manifest_deep_in_stack
  instinct = fix_where_error_appears
  instinct = WRONG (that is symptom)
  CORRECT = trace_to_original_trigger → fix_at_source
}

WHEN_TO_USE := {
  error_happens_deep_in_execution (not at entry point)
  stack_trace_shows_long_call_chain
  unclear_where_invalid_data_originated
  need_to_find_which_test_triggers_problem
}

PROCESS {
  1. observe_symptom
     e.g.: "git init failed in wrong directory"

  2. find_immediate_cause
     what code directly causes this?
     e.g.: execFileAsync('git', ['init'], { cwd: projectDir })

  3. ask: "what called this?"
     trace_up: WorktreeManager → Session.initializeWorkspace → Session.create → test

  4. keep_tracing_up
     what value was passed?
     where does that value come from?
     e.g.: projectDir = '' (empty string!) → resolves to process.cwd()

  5. find_original_trigger
     where did empty string originate?
     e.g.: context.tempDir accessed before beforeEach ran

  6. fix_at_source (not at symptom point)
  7. THEN add defense-in-depth (see defense-in-depth.md)
}

INSTRUMENTATION := {
  when: cannot_trace_manually
  HOW {
    add_stack_trace_logging before problematic_operation:
      const stack = new Error().stack
      console.error('DEBUG:', { directory, cwd: process.cwd(), stack })

    use: console.error() NOT logger (logger may be suppressed in tests)
    log BEFORE dangerous operation, not after failure
    include: directory, cwd, env_vars, timestamps, full_stack
  }
  CAPTURE: npm test 2>&1 | grep 'DEBUG'
  ANALYZE: find test filenames, line numbers, patterns (same test? same param?)
}

FINDING_TEST_POLLUTER := {
  when: state_appears_during_tests, unclear_which_test
  tool: scripts/find-polluter.sh
  usage: ./find-polluter.sh '.git' 'src/**/*.test.ts'
  how: runs_tests_one_by_one, stops_at_first_polluter
}

RULE 🔴 := NEVER_FIX_JUST_WHERE_ERROR_APPEARS
          Trace back to find original trigger
          Fix at source + add validation at each layer

REFS := {
  root-cause-tracing-FULL.md   ← full prose with worked example
  defense-in-depth.md          ← add multi-layer validation after fix
  scripts/find-polluter.sh     ← bisect polluting test
}
