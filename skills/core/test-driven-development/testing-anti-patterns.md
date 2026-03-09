COMPANION := testing-anti-patterns
LOAD_WHEN  := writing_tests | adding_mocks | tempted_to_add_test_only_methods

IRON_LAW 🔴 ABSOLUTE {
  1. NEVER test mock behavior
  2. NEVER add test-only methods to production classes
  3. NEVER mock without understanding dependencies
}

ANTI_PATTERNS {
  AP1_MOCK_BEHAVIOR {
    FORBIDDEN  := assert_on_mock_elements (e.g. data-testid="*-mock")
    FIX        := test_real_component | unmock_it
    GATE       := "Am I testing real behavior or mock existence?"
                  IF mock_existence → DELETE_assertion | unmock
  }

  AP2_TEST_ONLY_METHODS {
    FORBIDDEN  := production_method_only_called_from_test_files
    FIX        := move_to_test_utilities/
    GATE       := "Is this only used by tests?"
                  IF yes → put_in_test_utils NOT production_class
                  "Does this class own this resource's lifecycle?"
                  IF no  → wrong_class
  }

  AP3_MOCK_WITHOUT_UNDERSTANDING {
    FORBIDDEN  := mock_before_understanding_side_effects
    PROCESS    := understand_real_method → identify_side_effects →
                  mock_at_lowest_level → preserve_necessary_behavior
    GATE       := "What side effects does the real method have?"
                  "Does this test depend on any of those?"
                  IF unsure → run_test_with_real_impl_first | observe | THEN mock
    RED_FLAGS  := "I'll mock this to be safe" | "might be slow, better mock"
  }

  AP4_INCOMPLETE_MOCKS {
    FORBIDDEN  := partial_mock (only_fields_you_know_about)
    RULE       := mock_COMPLETE_data_structure_as_it_exists_in_reality
    FIX        := mirror_real_API_completely (all_fields_system_may_consume)
    GATE       := "What fields does the real API response contain?"
                  IF uncertain → include_all_documented_fields
  }

  AP5_TESTS_AS_AFTERTHOUGHT {
    FORBIDDEN  := implementation_complete_before_tests_exist
    FIX        := TDD_cycle (tests first always)
    SYMPTOM    := "Ready for testing" after code is done
  }

  AP6_TESTING_IMPLEMENTATION_DETAILS {
    FORBIDDEN  := assert_on_internal_state (component.state.count, private_vars)
    FIX        := test_user_visible_behavior (what_user_sees NOT how_code_works)
    GATE       := "Would a user notice if this changed?"
                  IF no → testing_implementation_detail → rewrite_test
    EXAMPLES   := {
      BAD:  expect(component.state.count).toBe(5)
      GOOD: expect(screen.getByText('Count: 5')).toBeInTheDocument()
    }
  }

  AP7_NO_TEST_ISOLATION {
    FORBIDDEN  := tests_depending_on_each_other | shared_mutable_state_between_tests
    FIX        := each_test_sets_up_own_data | use_beforeEach | clean_afterEach
    GATE       := "Can this test run alone, in any order, and still pass?"
                  IF no → tests_coupled → isolate_each
    SYMPTOM    := test_passes_only_when_run_after_specific_other_test
  }
}

WHEN_MOCKS_TOO_COMPLEX {
  WARNING_SIGNS := {
    mock_setup_longer_than_test_logic
    mocking_everything_to_make_test_pass
    mocks_missing_methods_real_components_have
    test_breaks_when_mock_changes
  }
  CONSIDER := integration_tests_with_real_components (often simpler)
}

RED_FLAGS := {
  assertion_checks_for_*-mock_testIDs
  method_only_called_from_test_files
  mock_setup > 50% of test
  test_fails_when_mock_removed
  can't_explain_why_mock_is_needed
  "I'll mock this to be safe"
  asserting_on_internal_state_not_output
  test_passes_only_in_specific_order
  tests_share_mutable_variables
}

RULE := mocks_are_tools_to_isolate NOT things_to_test
IF testing_mock_behavior → violated_TDD → fix_test_or_remove_mock

REFS := {
  testing-anti-patterns-FULL.md <- full prose with code examples
}
