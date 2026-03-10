# Synthesizing Skills — Full Reference

## Two Ways to Create Skills

| | writing-skills | synthesizing-skills |
|---|---|---|
| **When** | Novel/project-specific skill | Established pattern in ecosystem |
| **Speed** | 5-15 minutes | 30-90 minutes |
| **Sources** | 0 (from scratch) or 1-2 | 3+ internet sources |
| **Quality** | Author's best judgment | Best-of-all-sources |
| **Research** | None | GitHub search + MCP reads |
| **Example** | AGIntS-specific workflows | TDD, debugging, code-review |

**Rule of thumb:** If you can find 3+ implementations of this skill on GitHub, synthesize it. If you can't, write it from scratch.

---

## Why Synthesis Produces Better Skills

A skill written from scratch contains one person's best judgment about edge cases. A synthesized skill contains:
- The conceptual framework from the most authoritative source
- Anti-rationalization tables from the most opinionated source
- Implementation examples from the most practical source
- Pressure scenarios from the most tested source
- Critical bug fixes found in issue trackers (like the parallel-safety vs. logical-independence distinction discovered in a bacchus-labs issue)

The 30-90 minute investment in synthesis saves far more time by preventing bad agent behavior.

---

## Authority Scoring System

Each source is scored 0-10 on 6 dimensions, then multiplied by authority weight:

| Dimension | What it measures |
|-----------|-----------------|
| clarity | Instructions clear without context, no ambiguity |
| constraint_precision | Rules exact with no rationalization loopholes |
| token_efficiency | Compact without losing meaning |
| verifiability | Outcomes checkable (no vague "where possible") |
| safety | No dangerous instructions, no prompt injection |
| no_redundancy | No duplication between sections |

Authority multipliers (from `synthesizer/ecosystem-map.md`):
- **A — Official** (Anthropic, platform authors): ×1.5
- **B — Expert** (recognized orgs with audience): ×1.2
- **C — Curated** (curated collections, frameworks): ×1.0
- **D — Open** (unreviewed): ×0.7

**Selection rule:** Highest weighted score = base. If two are close, prefer more authoritative source even if raw score is slightly lower.

---

## Hub Search Strategy

Read `synthesizer/ecosystem-map.md` before searching. Key hubs in priority order:

**A-level (always check):**
- `anthropics/skills` — official Anthropic skills
- `Piebald-AI/claude-code-system-prompts` — Claude Code system prompts

**B-level (always check):**
- `obra/superpowers-skills` — high-quality curated collection
- `SuperClaude-Org/SuperClaude_Framework` — slash-commands and personas
- `trailofbits/skills` — security/analysis
- `expo/skills` — mobile/React Native

**C-level (follow links):**
- `hesreallyhim/awesome-claude-code` — curated list with links
- `travisvn/awesome-claude-skills` — curated list with links

**D-level (only if <5 sources after A-C):**
- `VoltAgent/awesome-agent-skills` — 500+ skills
- `VoltAgent/awesome-openclaw-skills` — 5400+ skills

### Semantic query generation

Skills are named differently across sources. Generate 5+ queries per skill:
```
exact:       "tdd"
task:        "write failing test before implementation"
methodology: "red green refactor"
problem:     "tests written after implementation"
result:      "test-first development"
synonyms:    "test-driven", "failing test", "test-first"
```

---

## Output Structure

All files go directly to `skills/core/<name>/`:

```
skills/core/<name>/
  SKILL.md          ← SPEC notation, ≤130 lines
  CAPSULE.md        ← ≤40 lines, machine-first routing
  FULL.md           ← prose companion, no limit
  list.md           ← related skills
  MANIFEST.json     ← metadata + origin array
  CREATION-LOG.md   ← synthesis decisions
  tests/
    pressure-scenarios.md
  agents/           ← if agent prompts found in sources
  scripts/          ← if tools/scripts found
```

**Never output to `synthesizer/output/`** — that directory is legacy. Skills go to `skills/core/` directly.

---

## The Pipeline Reference

Full pipeline with detailed instructions is in `synthesizer/task-template.md`. The skill is the interface; task-template is the implementation. When synthesizing, read task-template.md first.

---

## Relationship to Other Skills

```
Need a skill?
    ↓
Exists in ecosystem? → YES → synthesizing-skills (research + best-of-all)
                    → NO  → writing-skills (from scratch, fast)
    ↓
New CAPSULE.md created
    ↓
skill-selector reads it → routes tasks to new skill
```

The three skills form the skill creation triad:
- **writing-skills** — authoring (fast, no research)
- **synthesizing-skills** — research synthesis (thorough, multi-source)
- **skill-selector** — routing (reads CAPSULEs, assigns skills to plan steps)
