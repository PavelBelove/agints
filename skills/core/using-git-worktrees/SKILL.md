---
name: using-git-worktrees
description: "Use when starting feature work that needs isolation from the current workspace, before executing implementation plans with subagents, or when multiple parallel branches need to be open simultaneously. Creates isolated git worktrees with smart directory selection and mandatory safety verification."
---

SKILL    := using-git-worktrees
VERSION  := 1.0.0
PURPOSE  := create_isolated_workspace_via_git_worktree_with_safety_verification

TRIGGERS := {
  about_to_start_feature_implementation_needing_isolation
  before_executing_plans_with_subagent_driven_development
  before_executing_plans_with_executing_plans_skill
  need_parallel_branches_open_simultaneously
  brainstorming_approved_design_and_implementation_follows
}

---

FORBIDDEN := {
  creating_worktree_without_gitignore_verification_for_project_local_dirs
  skipping_baseline_test_verification
  proceeding_with_failing_tests_without_explicit_user_permission
  assuming_directory_location_without_checking_existing_dirs_or_CLAUDE_md
  creating_worktree_inside_main_project_directory
}

---

PROCESS {
  ANNOUNCE: "I'm using the using-git-worktrees skill to set up an isolated workspace."

  1. SELECT_DIRECTORY (priority order):
       a. Check existing: .worktrees/ (preferred) or worktrees/
          IF both exist → use .worktrees/
          IF one exists → use it
       b. IF neither: grep -i "worktree.*director" CLAUDE.md 2>/dev/null
          IF preference found → use it without asking
       c. IF no preference → ASK user:
            "No worktree directory found. Where should I create worktrees?
             1. .worktrees/ (project-local, hidden)
             2. ~/.config/superpowers/worktrees/<project-name>/ (global)"

  2. SAFETY_VERIFY (project-local only; skip for global path):
       git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
       IF NOT ignored:
         → Add to .gitignore
         → Commit the change
         → Then proceed
       WHY: prevents accidentally committing worktree contents

  3. CREATE_WORKTREE:
       project=$(basename "$(git rev-parse --show-toplevel)")
       git worktree add "$SELECTED_PATH/$BRANCH_NAME" -b "$BRANCH_NAME"

  4. SETUP_DEPENDENCIES (auto-detect):
       IF package.json  → npm install
       IF Cargo.toml    → cargo build
       IF requirements.txt OR pyproject.toml → pip/poetry install
       IF go.mod        → go mod download
       IF none found    → skip

  5. VERIFY_CLEAN_BASELINE:
       Run project test command (npm test / cargo test / pytest / go test ./...)
       IF tests FAIL → report failures, ask whether to proceed or investigate
       IF tests PASS → report ready

  6. REPORT:
       "Worktree ready at <full-path>
        Tests passing (<N> tests, 0 failures)
        Ready to implement <feature-name>"
}

---

ERROR_HANDLING := {
  "branch already checked out"  → find which worktree has it: git worktree list
  "cannot remove worktree"      → commit or stash changes first
  "stale worktree references"   → git worktree prune
  "lock file exists"            → remove .git/worktrees/<name>/locked
}

---

QUICK_REFERENCE := {
  .worktrees/ exists             → use it (verify ignored)
  worktrees/ exists              → use it (verify ignored)
  both exist                     → use .worktrees/
  neither exists                 → check CLAUDE.md → ask user
  directory NOT ignored          → add to .gitignore + commit
  tests fail at baseline         → report + ask before proceeding
  no package.json/Cargo.toml     → skip dependency install
}

---

REFS := {
  CAPSULE.md            ← machine-first overview for fast routing
  FULL.md               ← parallel patterns, examples, cleanup guide
  scripts/worktree-cleanup.sh ← cleanup helper script
  list.md               ← related: brainstorming | executing-plans | finishing-a-development-branch
}
