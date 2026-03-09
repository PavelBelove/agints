# AGIntS — Adaptive Skills for Claude Code

An adaptive skill library for Claude Code: SPEC-notation skills, partial loading by stack, and an agentic pipeline for structured development.

## What is this?

AGIntS provides high-quality, synthesized skills (system prompts) for Claude Code that enforce disciplined development workflows: test-first, root-cause debugging, structured brainstorming, and more.

Skills are written in **SPEC notation** — a compact, machine-readable format that loads efficiently and avoids prose overhead.

## Core Skills

| Skill | Purpose |
|-------|---------|
| `using-agints` | Session orchestrator — loads core skills, detects stack, routes tasks |
| `skill-selector` | Plan-level router — annotates plan steps with `USE_SKILL` directives |
| `writing-plans` | Decomposes requirements into atomic microtasks |
| `writing-microtasks` | Structures each task as a TDD cycle |
| `brainstorming` | Explores design space before any implementation |
| `subagent-driven-development` | Dispatches independent tasks to fresh subagents |
| `systematic-debugging` | Root-cause tracing before fixing |
| `test-driven-development` | Enforces test-first discipline |
| `verification-before-completion` | Requires fresh evidence before claiming success |
| `confidence-check` | Prevents wrong-direction work via pre-implementation check |
| `writing-skills` | Creates and improves skills in AGIntS format |

## Agent Pipeline

```
User Request
    ↓
using-agints          ← session start: detect stack, load core skills
    ↓
writing-plans         ← decompose into microtasks
    ↓
skill-selector        ← annotate each step with USE_SKILL directives (runs once)
    ↓
subagent-driven-development  ← dispatch each step to a fresh subagent
```

## Skill Format

Each skill follows the SPEC-first structure:

```
skills/skill-name/
  SKILL.md        # SPEC notation (machine-readable, what agent loads)
  FULL.md         # prose companion (human-readable, full detail)
  CAPSULE.md      # ≤40 lines, for skill-selector routing
  list.md         # related skills
  MANIFEST.json   # metadata
  tests/          # pressure scenarios and examples
```

## Installation

Skills can be loaded via Claude Code's plugin system or by referencing them directly in your CLAUDE.md / system prompt.

```bash
# Reference a skill in your project
cat skills/core/using-agints/SKILL.md >> .claude/CLAUDE.md
```

Or install via the Claude Code plugin system (see `plugin.json`).

## Project Structure

```
skills/
  core/           # always-loaded skills (TDD, debugging, brainstorming, etc.)
  stack/          # stack-specific skills (planned)
  task/           # task-specific skills (GraphQL, migrations, CI, etc.) (planned)
commands/         # Claude Code slash commands
synthesizer/      # local synthesis pipeline (not published)
docs/             # architecture docs
```

## Synthesizer

The `synthesizer/` directory contains a local pipeline for finding, comparing, and synthesizing skills from the broader ecosystem (Superpowers, SuperClaude, etc.). Only the synthesized results (`skills/`) are published — the pipeline itself runs locally.

## License

MIT
