---
name: synthesizer
description: "Use when processing a skill from synthesizer/queue.md, when improving an
  existing AGIntS skill through source comparison, or when the night runner executes
  an automated synthesis pass."
---

SKILL    := synthesizer
VERSION  := 1.0.0
PURPOSE  := automated_pipeline_search_compare_synthesize_skill_in_AGIntS_format

---

INPUT := {
  skill_name  := string            ← taken from queue.md pending item
  source_file := path              ← refs/ or skills/ path to source SKILL.md
  hubs        := list[path|url]    ← ordered by priority (see HUBS block)
  output_dir  := "synthesizer/output/<skill-name>/"
}

---

PROCESS {
  1.  read(source_file)
        → extract: description, keywords, purpose, criteria_signals

  2.  search(hubs, keywords_from_description)
        → collect: analogues[]      ← max 5 per hub; skip if not found
        → record: analogue_path + hub_name for each

  3.  compare(source + analogues[]) BY CRITERIA
        → build: score_table[skill × criterion]  ← 0-10 each
        → annotate: strengths[] + weaknesses[] per skill

  4.  select_base := argmax(sum(scores))
        IF tie → prefer source_file

  5.  synthesize {
        start_with := select_base
        ADD strengths FROM others WHERE no_contradiction
        REMOVE redundancy + contradictions
        ENSURE coverage OF all CRITERIA ≥ 7/10
      }

  6.  convert_to_SPEC {
        read(skills/core/writing-skills/SKILL.md)  ← follow FORMAT rules
        read(md/notation.md)                        ← apply compression
        write: SKILL.md in output_dir
        target: ≤130 lines
      }

  7.  write(EN.md)
        → full prose companion
        → include: criteria_table + synthesis_decisions + origin_notes

  8.  write(list.md)
        → related skills derived FROM synthesized content
        → format: ## sections by relationship type

  9.  write(MANIFEST.json) {
        source  := "synthesized"
        origin  := [source_file_ref] + [analogue_refs used]
        version := "1.0.0"
      }

  10. IF tests/ EXISTS IN source_dir → run_pressure_test(output_dir/SKILL.md)
        IF test_fails → iterate PROCESS from step 5

  11. save_all_files(output_dir)
        VERIFY: SKILL.md + EN.md + list.md + MANIFEST.json all present

  12. update(synthesizer/queue.md) {
        MOVE skill_name FROM "## Pending" TO "## Done"
        FORMAT := "- [x] <skill_name> — <date_ISO> v1.0.0"
      }
}

---

CRITERIA := {
  clarity           := 0-10  ← instructions unambiguous; agent follows without guessing
  constraint_precision := 0-10  ← FORBIDDEN/MUST are specific; no vague "be careful"
  token_efficiency  := 0-10  ← SPEC notation; no prose where DSL suffices
  verifiability     := 0-10  ← outputs checkable; agent can confirm compliance
  safety            := 0-10  ← no destructive ops without explicit guard
  no_redundancy     := 0-10  ← each rule stated once; no restatements
}

SCORE_THRESHOLD := 7   ← synthesized skill MUST reach ≥7 on each criterion

---

HUBS := {
  priority_1 := "~/.claude/plugins/marketplaces/claude-plugins-official/plugins/"
  priority_2 := "refs/awesome-agent-skills/"
  priority_3 := "refs/awesome-openclaw-skills/"
  priority_4 := "https://github.com/VoltAgent/awesome-agent-skills"
  priority_5 := "https://github.com/VoltAgent/awesome-openclaw-skills"
  search_method := keyword_match(description_terms) + skill_type_match
  IF hub_unavailable → skip + log + continue
}

---

OUTPUT := {
  dir: "synthesizer/output/<skill-name>/"
  files: {
    SKILL.md      ← SPEC notation; ≤130 lines; PRIMARY
    EN.md         ← full prose; synthesis rationale + criteria table
    list.md       ← related skills by content
    MANIFEST.json ← source=synthesized; origin=[refs used]
  }
  queue_update: synthesizer/queue.md ← skill marked [x] with ISO date
  promotion: manual_review → skills/core/ | skills/stack/ | skills/task/
}

---

REFS := {
  EN.md   ← full prose: pipeline walkthrough, criteria scoring guide, hub descriptions,
             synthesis strategy, queue format, night runner context, manual invocation
  list.md ← related skills: writing-skills, test-driven-development, using-agints,
             systematic-debugging, hub sources
}
