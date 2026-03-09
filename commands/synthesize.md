---
description: "Run AGIntS synthesizer pipeline for one skill. Without argument, takes first Pending from synthesizer/queue.md."
argument-hint: "[skill-name]"
allowed-tools: [Read, Glob, Grep, Bash, mcp__github__search_repositories, mcp__github__get_file_contents, mcp__github__search_code]
---

Resolve INPUT as follows:

IF an argument was provided to this command:
  skill_name := <argument>
  source_dir := "refs/superpowers/skills/<skill_name>/"
  output_dir := "synthesizer/output/<skill_name>/"
ELSE:
  Read synthesizer/queue.md.
  skill_name := name from the first "- [ ]" entry under "## Pending"
               (strip everything after "←" including whitespace)
  source_dir := "refs/superpowers/skills/<skill_name>/"
               UNLESS the queue entry contains "← источник: <path>" → use that path instead
  output_dir := "synthesizer/output/<skill_name>/"

Move the skill entry in synthesizer/queue.md from "## Pending" to "## In Progress"
(change "- [ ]" to "- [ ]" and move the line — keep the "←" annotation if present).

Now read synthesizer/task-template.md and follow the pipeline exactly
with the INPUT values resolved above.
