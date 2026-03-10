---
name: finishing-a-development-branch
description: "Use when implementation is complete and tests pass — verifies tests, presents 4 structured options (merge/PR/keep/discard), executes choice, cleans up worktree"
when_to_use: when all implementation tasks are complete and work needs to be integrated, preserved, or discarded
version: 1.0.0
---

SKILL    := finishing-a-development-branch
VERSION  := 1.0.0
PURPOSE  := guide_completion_of_development_branch_with_structured_options
RIGIDITY := LOW_FREEDOM  // process steps are mandatory; option choice belongs to user

IRON_LAW 🔴 ABSOLUTE {
  verify_tests_before_offering_options
  present_exactly_4_options          // no additions, no omissions
  no_auto_cleanup_for_option_2_or_3  // worktree cleanup only for 1 and 4
  confirm_discard_with_typed_word    // require user types "discard"
  no_force_push_without_explicit_request
  no_merge_without_post_merge_test_verification
}

PROCESS {
  ANNOUNCE: "I'm using the finishing-a-development-branch skill to complete this work."

  1. VERIFY_TESTS {
    run_test_suite := project_test_command
    IF tests_fail → {
      report: "Tests failing (<N> failures). Must fix before completing.\n[Show failures]\nCannot proceed until tests pass."
      STOP  // do not present options
    }
    IF tests_pass → continue_to_step_2
  }

  2. DETERMINE_BASE_BRANCH {
    cmd: "git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null"
    IF unclear → ask user: "This branch split from main — is that correct?"
  }

  3. PRESENT_OPTIONS {
    output:
    "Implementation complete. What would you like to do?

    1. Merge back to <base-branch> locally
    2. Push and create a Pull Request
    3. Keep the branch as-is (I'll handle it later)
    4. Discard this work

    Which option?"

    RULE: no additional explanation; keep options concise
  }

  4. EXECUTE_CHOICE {
    OPTION_1_MERGE {
      git checkout <base-branch>
      git pull
      git merge <feature-branch>
      run_tests_on_merged_result        // MANDATORY: re-verify after merge
      IF pass → git branch -d <feature-branch>
      IF fail → abort merge, report failures; branch preserved
      → goto STEP_5_CLEANUP
    }
    OPTION_2_PR {
      git push -u origin <feature-branch>
      gh pr create --title "<title>" --body "## Summary\n<2-3 bullets>\n\n## Test Plan\n- [ ] <steps>"
      KEEP_WORKTREE                     // do not cleanup
    }
    OPTION_3_KEEP {
      report: "Keeping branch <name>. Worktree preserved at <path>."
      KEEP_WORKTREE                     // do not cleanup
    }
    OPTION_4_DISCARD {
      confirm_first: "This will permanently delete:\n- Branch <name>\n- All commits: <list>\n- Worktree at <path>\n\nType 'discard' to confirm."
      WAIT_FOR_EXACT_WORD := "discard"
      IF confirmed → {
        git checkout <base-branch>
        git branch -D <feature-branch>
        → goto STEP_5_CLEANUP
      }
    }
  }

  5. CLEANUP_WORKTREE {
    APPLIES_TO := [OPTION_1, OPTION_4]
    check_if_in_worktree: "git worktree list | grep $(git branch --show-current)"
    IF in_worktree → git worktree remove <worktree-path>
    SKIP_FOR := [OPTION_2, OPTION_3]
  }
}

FORBIDDEN {
  proceed_with_failing_tests
  merge_without_post_merge_test_verification
  delete_work_without_typed_confirmation
  auto_cleanup_worktree_for_option_2_or_3
  force_push_without_explicit_user_request
  open_ended_question_instead_of_4_options  // never "what should I do?"
  add_5th_option_or_modify_option_list
}

QUICK_REFERENCE {
  | Option              | Merge | Push | Keep Worktree | Delete Branch |
  | 1. Merge locally    |  ✓    |  -   |      -        |    ✓ (clean)  |
  | 2. Create PR        |  -    |  ✓   |      ✓        |    -          |
  | 3. Keep as-is       |  -    |  -   |      ✓        |    -          |
  | 4. Discard          |  -    |  -   |      -        |    ✓ (force)  |
}

INTEGRATION {
  CALLED_BY := [subagent-driven-development, executing-plans]
  PAIRS_WITH := using-git-worktrees   // cleans up worktree created by that skill
}

REFS {
  FULL.md  := examples_and_anti_patterns
  list.md  := related_skills
}
