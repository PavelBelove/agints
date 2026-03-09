# Code Quality Reviewer Prompt Template

Use this template when dispatching a code quality reviewer subagent.

**Purpose:** Verify implementation is well-built — clean, tested, and maintainable.

**Only dispatch AFTER spec compliance review passes (✅).**

```
Task tool (superpowers:code-reviewer or general-purpose):
  description: "Code quality review for Task N"
  prompt: |
    Use template at requesting-code-review/code-reviewer.md

    WHAT_WAS_IMPLEMENTED: [from implementer's report]
    PLAN_OR_REQUIREMENTS: Task N from [plan-file]
    BASE_SHA: [commit before task started]
    HEAD_SHA: [current commit after task]
    DESCRIPTION: [brief task summary]
```

**Code quality reviewer returns:** Strengths, Issues (Critical/Important/Minor), overall assessment.

**After review:**
- Critical issues: must fix immediately, block proceeding
- Important issues: fix before moving to next task
- Minor issues: note, fix if quick, otherwise log for later
- Fix → re-review until approved
