---
name: using-agints
description: Loaded at session start by Claude Code to enforce skill-before-action discipline, detect project stack, and route each task to the appropriate AGIntS skill. Invoke on every new conversation before any response, clarification, or action.
---

SKILL    := using-agints
VERSION  := 1.0.0
PURPOSE  := enforce_skill_check + detect_stack + route_to_skills

---

RULE 🔴 ABSOLUTE {
  BEFORE := any_response | any_action | any_clarifying_question
  MUST   := check_skill_applies → invoke_skill
  NO_EXCEPTIONS
  even_1%_chance_applies → MUST invoke
}

---

ANTI_PATTERNS {
  FORBIDDEN := rationalize_skip_via {
    "this is just a simple task"        → skills apply to simple tasks too
    "I need context first"              → skill_check precedes context gathering
    "let me explore codebase first"     → skills define HOW to explore
    "this is a quick fix"               → quick ≠ skill-exempt
    "no skill covers this exactly"      → nearest skill still applies
    "I remember the skill content"      → skills evolve; MUST re-invoke
    "user said to just do it"           → instructions = WHAT, not HOW
    "this doesn't count as a task"      → action = task; check always
    "I'll check after one small step"   → check BEFORE first step
    "the skill is overkill here"        → simple tasks become complex; use it
    "I already loaded this skill"       → reload if new task type detected
  }
}

---

STACK_DETECT {
  TRIGGER := session_start
  STEP_1  := read(.agints) IF exists
  STEP_2  := scan_project_files {
    package.json ∋ "react"              → load(stack/react)
    package.json ∋ "next"               → load(stack/nextjs)
    go.mod EXISTS                       → load(stack/go)
    pyproject.toml|requirements.txt ∋ "fastapi"  → load(stack/fastapi)
    pyproject.toml|requirements.txt ∋ "django"   → load(stack/django)
    Cargo.toml EXISTS                   → load(stack/rust)
  }
  STEP_3  := report_detected_stack_to_user
}

---

ROUTING {
  feature | component | new_build          → brainstorming
  bug | test_failure | unexpected          → systematic-debugging
  implement | code | write                 → test-driven-development
  plan | spec | requirements               → writing-plans
  2+_independent_tasks                     → dispatching-parallel-agents
  subagent | delegate | fresh_context      → subagent-driven-development
  done | complete | ready_to_ship          → verification-before-completion
  branch | merge | pr                      → finishing-a-development-branch
  worktree | isolation                     → using-git-worktrees
  review_feedback                          → receiving-code-review
  request_review                           → requesting-code-review
  new_skill | write_skill                  → writing-skills

  RULE := match_task_keywords → invoke(Skill, matched_skill_name)
  RULE := multiple_matches → invoke_all_in_SKILL_PRIORITY_order
}

---

SKILL_PRIORITY {
  1. process_skills    := brainstorming | systematic-debugging | writing-plans
  2. implementation    := test-driven-development | stack/* | domain-specific
  RULE := process BEFORE implementation
  "build X"   → brainstorming first → then implementation skill
  "fix bug"   → systematic-debugging first → then domain skill
}

---

REFS {
  skill_list  := skills/docs/list.md
  notation    := md/notation.md
  enforcement := md/EN.md
}
