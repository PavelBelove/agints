SKILL: synthesizing-skills
VERSION: 1.0.0
PURPOSE: create skills from multi-source internet research — discovers 5+ sources, scores by authority, synthesizes best-of-all

USE_WHEN:
- creating a skill that exists in the ecosystem (TDD, debugging, code-review, etc.)
- want best practices from multiple authoritative sources, not one opinion
- quality matters more than speed (synthesis takes 30-90 min)
- improving an existing skill with deep research

AVOID_WHEN:
- skill is novel/project-specific (no internet sources) → use writing-skills
- fast iteration needed (5-15 min) → use writing-skills
- just editing an existing skill → use writing-skills

AUTHORITY_WEIGHTS:
A (Official) ×1.5 | B (Expert) ×1.2 | C (Curated) ×1.0 | D (Open) ×0.7

CORE_RULES:
- minimum 3 sources before synthesizing
- search order: A → B → C → D (stop at 5+)
- output directly to skills/core/<name>/ (never synthesizer/output/)
- all skill content in English
- pressure test required for all disciplining skills before marking done
- never copy source verbatim — always synthesize

PROCESS_HINT:
1. DISCOVERY (5+ sources, ecosystem-map.md hubs)
2. ANALYSIS (score + authority weight, choose base)
3. SYNTHESIS (SKILL.md + CAPSULE.md + FULL.md + list.md + MANIFEST.json)
4. VALIDATION (no contradictions, paths exist, no injection)
5. TESTING (subagent pressure test)
6. DOCUMENTATION (CREATION-LOG.md, update queue.md)

PIPELINE:
→ full details in synthesizer/task-template.md
→ hub list in synthesizer/ecosystem-map.md

SWITCH_TO:
- writing-skills — if skill is novel or fast iteration needed
- skill-selector — to update routing after new skill is added

RELATED:
- writing-skills — fast alternative (no research)
- skill-selector — reads CAPSULE.md of all skills for routing
