# Related Skills: skill-selector

## Required (needed before this skill can work)

- [writing-plans](../writing-plans/) — produces the plan that skill-selector annotates
- [writing-skills](../writing-skills/) — all skills in library must have CAPSULE.md for routing to work

## Run after this skill

- [subagent-driven-development](../subagent-driven-development/) — dispatches annotated plan to executor subagents
- [executing-plans](../executing-plans/) — alternative dispatcher for parallel session execution

## Session-level counterpart (different role, not a replacement)

- [using-agints](../using-agints/) — session start dispatcher; detects stack, loads core skills;
  skill-selector is plan-level and runs after using-agints

## Skill Selector feeds into

- [synthesize](../../../synthesizer/) — SKILL_GAPS log → synthesizer queue candidates

## When to switch to these instead

- **Plan not written yet** → [writing-plans](../writing-plans/) first
- **Single-step task** → skip skill-selector, dispatch directly
- **Library < 5 skills** → skip skill-selector, use using-agints for session routing
- **Already executing** → [systematic-debugging](../systematic-debugging/) for failure escalation
