SKILL: dispatching-parallel-agents
VERSION: 1.0.0
PURPOSE: dispatch 3+ independent, parallel-safe tasks simultaneously via Task tool to reduce total implementation time

USE_WHEN:
- 3 or more tasks need to be done and are logically independent
- failures have different root causes (not one bug causing all failures)
- agents can work without modifying the same files or shared state
- total work savings > dispatch overhead (~2-3 min per agent)

AVOID_WHEN:
- only 2 tasks (overhead not worth it)
- tasks share files being modified
- failures share a root cause (fix the root, not symptoms)
- dependencies between tasks are unclear (verify first)
- one fast fix covers all cases

CORE_RULES:
- minimum 3 tasks for parallel dispatch
- BOTH independence tests must pass: logical (A doesn't cause B) AND parallel-safe (no shared files/state)
- orchestrator must NOT read source files or write code — only coordinate
- each agent prompt needs: scope, task, output format, boundary, context
- prompt length < 200 lines (optimal < 150)
- run full test suite after all merges — mandatory
- if agent stuck > 5 min → cancel and retry sequentially

PROCESS_HINT:
1. ASSESS (3+ tasks?)
2. INDEPENDENCE_GATE (logical + parallel-safety)
3. DISPATCH (parallel via Task tool)
4. MONITOR (collect results, handle stuck agents)
5. MERGE (check conflicts)
6. VERIFY (full test suite)

SWITCH_TO:
- systematic-debugging — when failures share a root cause (fix first, then parallelize)
- executing-plans — broader orchestration context

RELATED:
- subagent-driven-development | requesting-code-review