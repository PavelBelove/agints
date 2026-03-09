DEFENSE_IN_DEPTH := technique | companion_to(systematic-debugging)
PURPOSE := after_root_cause_found → make_bug_structurally_impossible
           add_validation_at_EVERY_layer_data_passes_through

PRINCIPLE := {
  single_validation = "we fixed the bug"
  multiple_layers   = "we made the bug impossible"
  single_check_bypassed_by: different_code_paths | refactoring | mocks
}

WHY_MULTIPLE_LAYERS := {
  entry_validation   → catches most_bugs
  business_logic     → catches edge_cases
  environment_guards → prevents context_specific_dangers
  debug_logging      → helps when other_layers_fail
  EACH layer catches what OTHERS miss
}

FOUR_LAYERS {
  LAYER_1: ENTRY_POINT_VALIDATION {
    purpose := reject_obviously_invalid_input_at_API_boundary
    example:
      IF !workingDirectory → throw "cannot be empty"
      IF !existsSync(dir)  → throw "does not exist"
      IF !isDirectory(dir) → throw "not a directory"
  }

  LAYER_2: BUSINESS_LOGIC_VALIDATION {
    purpose := ensure_data_makes_sense_for_this_operation
    example:
      IF !projectDir → throw "projectDir required for workspace initialization"
  }

  LAYER_3: ENVIRONMENT_GUARDS {
    purpose := prevent_dangerous_operations_in_specific_contexts
    example (test guard):
      IF process.env.NODE_ENV === 'test' {
        IF !normalized.startsWith(tmpDir)
          → throw "Refusing git init outside temp dir during tests"
      }
  }

  LAYER_4: DEBUG_INSTRUMENTATION {
    purpose := capture_context_for_forensics
    example:
      logger.debug('About to git init', { directory, cwd, stack: new Error().stack })
  }
}

APPLYING_THE_PATTERN {
  1. trace_data_flow (see root-cause-tracing.md)
  2. map_all_checkpoints: list every point data passes through
  3. add_validation_at_each_layer (all four)
  4. test_each_layer: try to bypass layer_1, verify layer_2 catches it
}

WORKED_EXAMPLE {
  bug: empty projectDir → git init in source code
  data_flow:
    1. test_setup → empty_string
    2. Project.create(name, '')
    3. WorkspaceManager.createWorkspace('')
    4. git_init runs in process.cwd()

  four_layers_added:
    layer_1: Project.create() validates not_empty | exists | writable
    layer_2: WorkspaceManager validates projectDir not_empty
    layer_3: WorktreeManager refuses git_init outside tmpdir in tests
    layer_4: stack_trace logging before git_init

  result: 1847 tests PASS, bug structurally impossible
}

KEY_INSIGHT := {
  all_four_layers_were_necessary
  different_code_paths bypassed entry_validation
  mocks bypassed business_logic checks
  edge_cases on different platforms needed environment_guards
  debug_logging identified structural_misuse
  DO NOT stop at one validation point
}

REFS := {
  defense-in-depth-FULL.md  ← full prose with complete code examples
  root-cause-tracing.md     ← find the root cause first, then apply this
}
