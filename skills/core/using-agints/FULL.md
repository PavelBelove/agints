# using-agints — AGIntS Core Dispatcher

## What this skill does

This is the entry point for every AGIntS session. Three responsibilities:

1. **Enforces skill discipline** — checks that you invoke the right skill before acting
2. **Detects project stack** — reads `.agints` (skills lock file) and project files at session start
3. **Routes tasks** — tells you which skill to use for each task type

## Stack Detection

At session start, `using-agints` scans your project and reports which skills are active.
Detection is based on file presence and content:

| Signal | Loaded skill |
|--------|-------------|
| `package.json` contains "react" | stack/react |
| `package.json` contains "next" | stack/nextjs |
| `go.mod` exists | stack/go |
| `requirements.txt` or `pyproject.toml` contains "fastapi" | stack/fastapi |
| `requirements.txt` or `pyproject.toml` contains "django" | stack/django |
| `Cargo.toml` exists | stack/rust |

Copy `.agints.template` from the repo root to your project root as `.agints` to get started.

## Routing Table

| Task type | Skill to invoke |
|-----------|----------------|
| New feature, component, system design | `brainstorming` |
| Bug, test failure, unexpected behavior | `systematic-debugging` |
| Writing or implementing code | `test-driven-development` |
| Planning, spec, requirements | `writing-plans` |
| 2+ independent parallel tasks | `dispatching-parallel-agents` |
| Delegating to a subagent | `subagent-driven-development` |
| Completing or shipping work | `verification-before-completion` |
| Branch, merge, PR decisions | `finishing-a-development-branch` |
| Isolated feature work | `using-git-worktrees` |
| Receiving code review feedback | `receiving-code-review` |
| Requesting a code review | `requesting-code-review` |
| Writing or improving a skill | `writing-skills` |

**Priority:** invoke process skills first (brainstorming, systematic-debugging), then implementation skills.

## /agints Commands

These commands manage your `.agints` skills lock file:

```
/agints install <skill>   — add skill to .agints
/agints freeze <skill>    — mark skill frozen (won't auto-update from repo)
/agints update            — update all non-frozen skills to latest
/agints list              — show installed skills and their status
/agints suggest           — suggest skills based on detected stack
```

## Skill Levels

| Level | When loaded | Examples |
|-------|-------------|---------|
| `core` | Every session | brainstorming, test-driven-development, systematic-debugging |
| `stack` | When stack detected | react, fastapi, go, django |
| `task` | On demand | graphql, docker, ci-cd |

## Installation

1. Copy `.agints.template` from the AGIntS repo root to your project root as `.agints`
2. Uncomment stack and task skills that match your project
3. Install AGIntS plugin in Claude Code:
   ```
   /plugin install <path-to-agints-repo>
   ```

## See also

- `list.md` — full catalog of available AGIntS skills
- `md/spec.md` — full project spec
