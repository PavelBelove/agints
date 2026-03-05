---
name: using-agints
description: "Use at the start of every conversation — detects project stack from
  .agints and project files, routes tasks to appropriate AGIntS skills."
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
    "this is just a simple/quick task or overkill" → skills apply regardless of perceived complexity
    "I need context first"              → skill_check precedes context gathering
    "let me explore codebase first"     → skills define HOW to explore
    "no skill covers this exactly"      → nearest skill still applies
    "I remember/already loaded this skill" → skills evolve; reload if new task type detected
    "user said to just do it"           → instructions = WHAT, not HOW
    "this doesn't count as a task"      → action = task; check always
    "I'll check after one small step"   → check BEFORE first step
  }
}

---

STACK_DETECT {
  TRIGGER := session_start
  STEP_1  := read(.agints) IF exists  # skills lock file
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

REFS := {
  EN.md    ← /agints commands, full routing table, installation guide
  list.md  ← all available skills with trigger descriptions
}
