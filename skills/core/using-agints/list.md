# AGIntS Available Skills

## Core Skills (always loaded)

### brainstorming
**When:** Starting any new feature, component, system, or significant design decision.
**Triggers:** "let's build", "add feature", "design", "create", "new component"

### test-driven-development
**When:** Writing any code — feature or bugfix. No exceptions.
**Triggers:** "implement", "write", "code", "add", "fix"

### systematic-debugging
**When:** Bug, test failure, unexpected behavior, error you can't explain.
**Triggers:** "bug", "broken", "failing", "error", "why is this"

### writing-plans
**When:** Design approved, need step-by-step implementation plan before coding.
**Triggers:** After brainstorming approval; "plan", "spec", "requirements"

### dispatching-parallel-agents
**When:** 2+ independent tasks that don't share state or have sequential dependencies.
**Triggers:** Multiple unrelated files to change, "also do X", parallel work

### subagent-driven-development
**When:** Executing a plan — each task gets a fresh subagent + two-stage review.
**Triggers:** Implementing from a plan doc, "execute plan"

### verification-before-completion
**When:** About to claim work is done, fixed, or passing.
**Triggers:** "done", "fixed", "works", "tests pass" — before saying any of these

### finishing-a-development-branch
**When:** Implementation complete, deciding how to integrate the work.
**Triggers:** "merge", "PR", "ship", "ready to push"

### using-git-worktrees
**When:** Starting feature work that needs isolation from current workspace.
**Triggers:** Before starting any significant feature

### receiving-code-review
**When:** Got code review feedback, before implementing any suggestions.
**Triggers:** Review feedback received, "they said to change"

### requesting-code-review
**When:** Completing a task or major feature, verifying work meets requirements.
**Triggers:** "review", "check my work", "LGTM?", "is this good"

### writing-skills
**When:** Creating a new AGIntS skill or improving an existing one.
**Triggers:** "new skill", "improve skill", "write skill", "add to library"

---

## Stack Skills

*(None yet — added by synthesizer in Phase 2)*

Planned: react, nextjs, typescript, fastapi, django, go, rust

---

## Task Skills

*(None yet — added by synthesizer in Phase 3)*

Planned: graphql, docker, ci-cd, db-migrations, sql-optimization

---

## Install a skill

```
/agints install <skill-name>
```

To suggest skills based on your project stack:
```
/agints suggest
```
