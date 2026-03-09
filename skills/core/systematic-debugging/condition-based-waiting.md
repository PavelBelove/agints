CONDITION_BASED_WAITING := technique | companion_to(systematic-debugging)
PURPOSE := replace_arbitrary_timeouts_with_condition_polling → eliminate_flaky_tests

PRINCIPLE := {
  arbitrary_delays = guessing_at_timing → race_conditions → flaky_tests
  CORRECT = wait_for_actual_condition_you_care_about
}

WHEN_TO_USE := {
  tests_have_arbitrary_delays (setTimeout, sleep, time.sleep)
  tests_are_flaky (pass_sometimes, fail_under_load)
  tests_timeout_when_run_in_parallel
  waiting_for_async_operations
}

DO_NOT_USE_WHEN := {
  testing_actual_timing_behavior (debounce, throttle intervals)
  arbitrary_timeout_IS_correct (see below)
  IF using_arbitrary_timeout → document_WHY_clearly
}

PATTERN {
  BEFORE (flaky):
    await new Promise(r => setTimeout(r, 50))
    const result = getResult()
    expect(result).toBeDefined() // fails randomly

  AFTER (reliable):
    await waitFor(() => getResult() !== undefined)
    const result = getResult()
    expect(result).toBeDefined() // always passes
}

QUICK_PATTERNS := {
  wait_for_event:   waitFor(() => events.find(e => e.type === 'DONE'))
  wait_for_state:   waitFor(() => machine.state === 'ready')
  wait_for_count:   waitFor(() => items.length >= 5)
  wait_for_file:    waitFor(() => fs.existsSync(path))
  complex:          waitFor(() => obj.ready && obj.value > 10)
}

GENERIC_IMPLEMENTATION {
  async function waitFor(condition, description, timeoutMs = 5000) {
    const startTime = Date.now()
    while (true) {
      const result = condition()
      if (result) return result
      if (Date.now() - startTime > timeoutMs)
        throw new Error(`Timeout waiting for ${description} after ${timeoutMs}ms`)
      await new Promise(r => setTimeout(r, 10)) // poll every 10ms
    }
  }

  rules:
    poll_interval := 10ms (not 1ms: wastes_CPU, not 100ms: too_slow)
    always_include_timeout_with_clear_error
    call_getter_inside_loop (not cached before loop — stale_data bug)
}

WHEN_ARBITRARY_TIMEOUT_IS_CORRECT := {
  EXAMPLE: tool_ticks_every_100ms, need_2_ticks_to_verify_partial_output
    await waitForEvent(manager, 'TOOL_STARTED') // first: wait for condition
    await new Promise(r => setTimeout(r, 200))   // then: wait for timed behavior
    // 200ms = 2 ticks at 100ms — documented and justified

  REQUIREMENTS:
    1. first_wait_for_triggering_condition
    2. based_on_known_timing (not guessing)
    3. comment_explaining_WHY
}

COMMON_MISTAKES := {
  polling_too_fast (setTimeout 1ms) → wastes_CPU → use_10ms
  no_timeout → loop_forever_if_condition_never_met → always_add_timeout
  stale_data → cache_state_before_loop → call_getter_inside_loop
}

IMPACT := {
  from_debugging_session_2025_10_03:
    fixed: 15 flaky tests across 3 files
    pass_rate: 60% → 100%
    execution_time: 40% faster
    race_conditions: eliminated
}

REFS := {
  condition-based-waiting-FULL.md         ← full prose explanation
  scripts/condition-based-waiting-example.ts ← complete TS implementation with
                                              waitForEvent, waitForEventCount,
                                              waitForEventMatch helpers
}
