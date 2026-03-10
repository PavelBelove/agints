---
name: writing-plans
description: "Use when you have a spec or requirements for a multi-step task — produces a bite-sized implementation plan saved to docs/plans/ with exact file paths, complete code snippets, and test commands"
when_to_use: when creating an implementation plan from a spec or requirements, before starting multi-step development
version: 1.0.0
---

SKILL    := writing-plans
VERSION  := 1.0.0
PURPOSE  := write_comprehensive_bite_sized_implementation_plan

IRON_LAW 🔴 ABSOLUTE {
  save_to := "docs/plans/YYYY-MM-DD-<feature-name>.md"
  include_plan_header_with_executing_plans_directive
  exact_file_paths_always   // never "the auth module" — always "src/auth/handler.py:42"
  complete_code_not_descriptions  // "add validation" is NOT a plan step
  exact_commands_with_expected_output
  tdd_structure_per_task    // each task: failing test → verify fails → implement → verify passes → commit
}

AUDIENCE {
  // Write for: skilled developer, zero codebase context, uncertain test design
  assume: knows_the_language
  assume_not: knows_project_architecture
  assume_not: knows_tool_commands
  assume_not: knows_test_design_patterns
  rule: DRY + YAGNI + TDD + frequent_commits
}

PROCESS {
  ANNOUNCE: "I'm using the writing-plans skill to create the implementation plan."

  1. UNDERSTAND_SPEC {
    read: requirements / spec / task description
    identify: components, dependencies, files to touch
    clarify: anything ambiguous BEFORE starting to write
  }

  2. WRITE_PLAN {
    FILE_HEADER {
      "# [Feature Name] Implementation Plan

      > **For Claude:** REQUIRED SUB-SKILL: Use executing-plans to implement this plan task-by-task.

      **Goal:** [one sentence]
      **Architecture:** [2-3 sentences about approach]
      **Tech Stack:** [key technologies]
      ---"
    }

    FOR each task {
      TASK_STRUCTURE {
        ### Task N: [Component Name]

        **Files:**
        - Create: `exact/path/to/file.py`
        - Modify: `exact/path/to/existing.py:line-range`
        - Test: `tests/exact/path/test.py`

        Step 1: Write the failing test  [complete code]
        Step 2: Run test — verify FAIL  [exact command + expected output]
        Step 3: Write minimal implementation [complete code]
        Step 4: Run test — verify PASS  [exact command + expected output]
        Step 5: Commit  [exact git commands + message]
      }
    }
  }

  3. SAVE_PLAN {
    path: docs/plans/YYYY-MM-DD-<feature-name>.md
  }

  4. OFFER_EXECUTION {
    present: "Plan complete. Two execution options:

    1. Subagent-Driven (this session) — fresh subagent per task, review between tasks
    2. Parallel Session (separate) — open new session with executing-plans, batch execution

    Which approach?"

    IF subagent_driven → INVOKE_SKILL := subagent-driven-development
    IF parallel_session → guide: open new session in worktree, use executing-plans
  }
}

FORBIDDEN {
  vague_steps                       // "add error handling" → specify exactly what
  approximate_paths                 // "auth module" → "src/auth/handler.py"
  pseudocode_instead_of_real_code  // plans need copy-paste-ready code
  skip_tdd_structure                // each task must have: failing test → implement → verify
  save_anywhere_but_docs_plans
  start_without_executing_plans_directive_in_header
}

REFS {
  FULL.md       := task_structure_examples_and_complete_plan_template
  list.md       := related_skills
  CAPSULE.md    := machine-first overview for fast routing
}
