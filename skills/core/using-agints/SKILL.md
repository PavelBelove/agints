---
name: using-agints
description: "Use at the start of every conversation — establishes the AGIntS pipeline,
  detects project stack from .agints and project files, routes tasks to appropriate skills."
---

SKILL    := using-agints
VERSION  := 2.0.0
PURPOSE  := enforce_skill_check + document_pipeline + detect_stack + route_to_skills

---

RULE 🔴 ABSOLUTE {
  BEFORE := any_response | any_action | any_clarifying_question
  MUST   := check_skill_applies → invoke_skill
  NO_EXCEPTIONS
  even_1%_chance_applies → MUST invoke
}

---

PIPELINE := {
  1. brainstorming           ← design → approval → docs/plans/YYYY-MM-DD-<topic>-design.md
  2. writing-plans           ← TDD plan → docs/plans/YYYY-MM-DD-<name>.md
  3. writing-microtasks      ← decompose plan → 1-session TDD microtasks
  4. skill-selector pass-1   ← annotate steps + skill-proposals.md + skill-placement.log
     IF skill-proposals.md created:
       5a. human reviews skill-proposals.md (approve/reject/change method)
       5b. skill creation: writing-skills (fast) OR synthesize (quality) per approval
       5c. skill-selector pass-2 ← insert USE_SKILL for approved skills per placement log
  6. execution               ← subagent-driven-development | executing-plans
}

SKIP_RULES := {
  writing-microtasks  → skip IF plan_has ≤ 3_steps
  skill-selector      → skip IF skill_library < 5_skills
  creation_loop       → skip IF user_rejects_all_proposals OR no_proposals_found
  pass-2              → skip IF creation_loop_was_skipped
}

---

ANTI_PATTERNS {
  FORBIDDEN := rationalize_skip_via {
    "this is just a simple/quick task or overkill"  → skills apply regardless
    "I need context first"                          → skill_check precedes context
    "let me explore codebase first"                 → skills define HOW to explore
    "no skill covers this exactly"                  → nearest skill still applies
    "I remember/already loaded this skill"          → skills evolve; reload if new task
    "user said to just do it"                       → instructions = WHAT, not HOW
    "this doesn't count as a task"                  → action = task; check always
    "I'll check after one small step"               → check BEFORE first step
  }
}

---

STACK_DETECT {
  TRIGGER := session_start
  STEP_1  := read(.agints) IF exists
  STEP_2  := scan_project_files {
    package.json ∋ "react"            → load(stack/react)
    package.json ∋ "next"             → load(stack/nextjs)
    go.mod EXISTS                     → load(stack/go)
    pyproject.toml ∋ "fastapi"        → load(stack/fastapi)
    pyproject.toml ∋ "django"         → load(stack/django)
    Cargo.toml EXISTS                 → load(stack/rust)
  }
  STEP_3  := report_detected_stack_to_user
}

---

ROUTING {
  feature | component | new_build         → brainstorming
  bug | test_failure | unexpected         → systematic-debugging
  implement | code | write                → test-driven-development
  plan | spec | requirements              → writing-plans
  plan_written → decompose_tasks          → writing-microtasks
  plan_with_microtasks → annotate_skills  → skill-selector
  2+_independent_tasks                    → dispatching-parallel-agents
  subagent | delegate | fresh_context     → subagent-driven-development
  done | complete | ready_to_ship         → verification-before-completion
  branch | merge | pr                     → finishing-a-development-branch
  worktree | isolation                    → using-git-worktrees
  review_feedback                         → receiving-code-review
  request_review                          → requesting-code-review
  new_skill | write_skill                 → writing-skills
  synthesize_skill | improve_skill        → synthesizer

  RULE := match_task_keywords → invoke(Skill, matched_skill_name)
  RULE := multiple_matches → invoke_all_in_SKILL_PRIORITY_order
}

---

SKILL_PRIORITY {
  1. process_skills    := brainstorming | systematic-debugging | writing-plans
  2. planning_skills   := writing-microtasks | skill-selector
  3. implementation    := test-driven-development | stack/* | domain-specific
  RULE := process BEFORE planning BEFORE implementation
}

---

REFS := {
  CAPSULE.md ← machine-first overview for fast routing
  list.md    ← all available skills with trigger descriptions
}
