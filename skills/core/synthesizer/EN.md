# synthesizer — Full Prose Guide

## Overview

The synthesizer is the AGIntS automated quality improvement pipeline. Given a skill name from `synthesizer/queue.md`, it:

1. Reads the source skill from `refs/` or `skills/`
2. Searches skill hubs for analogues by keywords extracted from the source description
3. Compares all candidates against 6 quality criteria, producing a scored table
4. Selects the best base, then merges strengths from the others
5. Writes the result in AGIntS format: `SKILL.md` (SPEC), `EN.md`, `list.md`, `MANIFEST.json`
6. Marks the skill done in `queue.md`

The night runner (`synthesizer/agints-night-runner.sh`) calls this pipeline automatically via cron. One run = one skill. Results land in `synthesizer/output/<skill-name>/` and require manual developer review before promotion to the main library.

---

## When to Use synthesizer vs writing-skills

| Situation | Skill to use |
|-----------|--------------|
| Processing a skill from `queue.md` (existing source) | **synthesizer** |
| Improving an existing AGIntS skill via hub comparison | **synthesizer** |
| Creating a brand-new skill with no prior art | **writing-skills** |
| Editing a skill based on test failures | **writing-skills** |

The synthesizer _produces output in writing-skills format_. Think of writing-skills as the format specification, and synthesizer as the pipeline that fills it using external sources.

---

## Full Pipeline Walkthrough

### Step 1 — Read source_file

Load the source skill and extract:
- `description` field (used as search query)
- Key nouns and verbs from `PURPOSE` and section headers
- Any explicit `REFS` to other skills (signals relationships for `list.md`)

Example: for `brainstorming`, keywords would be `brainstorm diverge ideas exploration lateral thinking`.

### Step 2 — Search hubs for analogues

Search each hub in priority order (local hubs first, remote last). For each hub:
- Match skills whose name or description overlaps with extracted keywords
- Collect up to 5 candidates per hub
- Record path and hub name for provenance

If a hub is unavailable (not cloned, network down), log the skip and continue. Do not abort the pipeline.

### Step 3 — Compare by CRITERIA

Build a score table with one row per candidate and one column per criterion. Score 0–10 for each. Example:

| Skill | clarity | constraint_precision | token_efficiency | verifiability | safety | no_redundancy | TOTAL |
|-------|---------|---------------------|-----------------|--------------|--------|--------------|-------|
| superpowers/brainstorming | 8 | 7 | 6 | 7 | 9 | 8 | 45 |
| awesome-agent-skills/explore | 7 | 6 | 8 | 6 | 9 | 7 | 43 |
| official/brainstorm-plugin | 6 | 5 | 9 | 5 | 8 | 9 | 42 |

Annotate each row with key strengths and weaknesses before moving on. This annotation drives Step 5.

### Step 4 — Select best base

Pick the candidate with the highest total score. On a tie, prefer `source_file` (the original). The selected skill becomes the structural skeleton of the synthesized output.

### Step 5 — Synthesize

Start with the base, then:
- For each strength found in a non-base candidate: add it if it does not contradict existing rules
- For each weakness in the base: look for a better formulation in another candidate
- Collapse redundant rules (same constraint stated twice in different words → keep one)
- Ensure every criterion reaches ≥ 7/10 in the final result

Example: the base has excellent clarity but verbose token usage. The third candidate has compact SPEC blocks. Merge the compact blocks into the base structure.

### Step 6 — Convert to AGIntS SPEC

Read `skills/core/writing-skills/SKILL.md` for FORMAT rules and `md/notation.md` for compression patterns. Then write `SKILL.md`:

- YAML frontmatter: `name` + `description` (trigger conditions only, ≤1024 chars)
- Body: `SKILL`, `VERSION`, `PURPOSE`, blocks, `REFS`
- Target: ≤130 lines for core skills
- Use `:=`, `→`, `∈`, `{}` blocks throughout; no explanatory prose in SPEC body

### Step 7 — Write EN.md

The prose companion. Include:
- What the skill does and why
- The criteria score table from Step 3
- Key synthesis decisions (what was taken from where and why)
- Origin notes (which hubs contributed what)

EN.md is the place for nuance, examples, and reasoning that would bloat the SPEC.

### Step 8 — Write list.md

Derive related skills from the _content_ of the synthesized skill:
- Skills that are prerequisites (read before this one)
- Skills often used alongside
- Skills that extend or specialize this one

Use the `## sections` format matching the AGIntS spec example. Reference actual paths in the `skills/` tree.

### Step 9 — Write MANIFEST.json

Key fields:
```json
{
  "source": "synthesized",
  "origin": [
    "superpowers/brainstorming@4.3.1",
    "awesome-agent-skills/explore-patterns"
  ]
}
```

`origin` lists every source that materially contributed to the synthesized output. Omit sources that were searched but not used.

### Step 10 — Run pressure test (conditional)

If a `tests/` directory exists in the source skill directory, run the pressure scenarios against the freshly written `SKILL.md`. If any scenario fails (agent doesn't comply with the new skill), return to Step 5 and revise.

This step is skipped, not failed, when `tests/` is absent. Full pressure testing is a manual review responsibility.

### Step 11 — Save to output_dir

Verify all four files are present: `SKILL.md`, `EN.md`, `list.md`, `MANIFEST.json`. The output directory is `synthesizer/output/<skill-name>/`.

### Step 12 — Update queue.md

Change the skill's entry in `queue.md`:

Before: `- [ ] brainstorming`
After: `- [x] brainstorming — 2026-03-05 v1.0.0`

Move it from `## Pending` to `## Done`. The `## In Progress` section is used only during active processing (move there at start, move to Done when complete).

---

## Hub Sources Explained

### Priority 1: Official Claude marketplace
Path: `~/.claude/plugins/marketplaces/claude-plugins-official/plugins/`

The authoritative source for Claude-native skills. These have been vetted for Claude-specific behavior. Search here first because format compatibility is highest.

### Priority 2: awesome-agent-skills (VoltAgent)
Repo: `https://github.com/VoltAgent/awesome-agent-skills` (500+ skills)
Local clone: `refs/awesome-agent-skills/`

Broad coverage of agent methodology skills. Clone locally for offline access and consistent search during night runs.

### Priority 3 & 4: awesome-openclaw-skills (VoltAgent)
Repo: `https://github.com/VoltAgent/awesome-openclaw-skills` (5400+ skills)
Local clone: `refs/awesome-openclaw-skills/`

Larger corpus; higher noise ratio. Use for niche or stack-specific skills not covered by priority 1–2.

---

## Criteria Scoring Guide

### clarity (0–10)
Does an agent reading this skill know exactly what to do in every situation?

- **0**: Instructions are ambiguous or contradictory; agent will guess
- **5**: Most cases covered; edge cases require interpretation
- **10**: Every branch explicit; agent never needs to infer

### constraint_precision (0–10)
Are FORBIDDEN and MUST rules specific and actionable?

- **0**: "Be careful with X" — no actionable constraint
- **5**: "Avoid X unless necessary" — partially actionable
- **10**: "FORBIDDEN := delete_without_backup" — unambiguous

### token_efficiency (0–10)
Is every token earning its place?

- **0**: Paragraph prose where one DSL line would suffice
- **5**: Mix of SPEC and prose; some redundancy
- **10**: Pure SPEC notation; nothing that could be compressed further

### verifiability (0–10)
Can the agent (or reviewer) confirm the skill was followed?

- **0**: Outputs are subjective; no way to check compliance
- **5**: Some outputs checkable; others require judgment
- **10**: Every output has a defined format or observable state change

### safety (0–10)
Does the skill avoid instructing destructive operations without guards?

- **0**: Instructs `rm -rf` or equivalent with no condition
- **5**: Destructive ops present but behind soft conditions
- **10**: All destructive ops behind explicit MUST-confirm guards; no ambient risk

### no_redundancy (0–10)
Is each rule stated exactly once?

- **0**: Same constraint restated 3+ times in different words
- **5**: Minor duplication; mostly consolidated
- **10**: Single source of truth for every rule; zero restatements

---

## How to Search for Analogues

1. Extract the noun phrases from the source skill's `description` field
2. Extract the verb from `PURPOSE` (e.g., `synthesize`, `debug`, `plan`)
3. Search hub directories for files containing 2+ of these terms
4. Also match on skill type: Technique, Pattern, or Reference (from writing-skills taxonomy)

If a hub has its own index or README, read that first — it often maps skill names to descriptions, enabling faster matching without opening every file.

---

## Synthesis Strategy

The goal is a skill better than any single source, not a mashup of all sources.

**Rule of thumb:** take the _structure_ from the best base, take _specific rules_ from others where the base is weak.

When two sources conflict (e.g., source A says "always X", source B says "never X"):
1. Check which rule has higher verifiability — prefer the more testable constraint
2. If still ambiguous, prefer the more restrictive rule and add a comment in EN.md
3. Never silently drop a constraint; if you remove it, document why in EN.md

---

## queue.md Format

```markdown
# Synthesizer Queue

## Pending
- [ ] brainstorming
- [ ] test-driven-development

## In Progress
- [ ] systematic-debugging   ← currently being processed

## Done
- [x] writing-skills — 2026-03-01 v1.0.0
- [x] using-agints — 2026-02-28 v1.0.0
```

The queue is a simple checklist. It is not a state machine. Edit it manually when adding new skills to process. The night runner only reads the first `[ ]` entry and processes it.

---

## Night Runner Context

The night runner (`synthesizer/agints-night-runner.sh`) is invoked by cron. It:
1. Finds the first `- [ ]` entry in `queue.md`
2. Moves it to `## In Progress`
3. Launches `claude --print --dangerously-skip-permissions` with the synthesis task
4. Logs output to `synthesizer/runner.log`

One cron entry per desired hour (e.g., 1am–4am) = one skill processed per hour. This respects subscription rate limits. `--dangerously-skip-permissions` is scoped to the `synthesizer/output/` blast radius; no other directories are written.

All results require manual developer review before promotion to `skills/core/`, `skills/stack/`, or `skills/task/`.

---

## Manual Invocation

To process a single skill outside the night runner:

```
Read synthesizer/task-template.md.
Process skill: brainstorming.
Follow the synthesizer pipeline exactly.
```

Or pass the full INPUT block directly to Claude Code with `source_file`, `hubs`, and `output_dir` filled in. The SKILL.md PROCESS block is the canonical instruction set.
