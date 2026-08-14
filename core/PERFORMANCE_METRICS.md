# Framework Quality Metrics and Context Budget

This framework uses progressive disclosure: agents first see skill metadata, then load a selected `SKILL.md`, and read local resources only when needed. Measure quality with reproducible checks and representative evaluation tasks rather than asserting unattainable universal percentages.

## Context guidance

| Layer | Guideline | Rationale |
|---|---|---|
| Discovery metadata | Keep names unique and descriptions specific. | The description determines whether an agent can select the right skill. |
| `SKILL.md` | Keep under 500 lines and focused on one workflow. | The full body is read on activation. |
| Resources and templates | Load only from the selected skill when the task requires them. | Rare details should not occupy every task's context. |
| Compound tasks | Select the smallest skill set that covers the work. | A task may legitimately require more than one skill; do not impose an arbitrary count. |

## Quality indicators

| Indicator | Evidence | Review cadence |
|---|---|---|
| Contract validity | `python3 tools/validate_framework.py` passes. | Every pull request and push to `main`. |
| Routing quality | Representative task prompts select the expected primary skills without unrelated activation. | Before a release and after material routing changes. |
| Instruction safety | Workflows distinguish material uncertainty from reversible low-risk work and do not rely on invented confidence scores. | After governance or workflow changes. |
| Installation integrity | Local initialization writes `.agent/` state and `.agents/skills/`; global deployment targets documented paths. | After installer changes. |
| Context discipline | Long or specialized detail is moved to local resources, and no `SKILL.md` exceeds the line limit. | Every pull request. |

## Audit procedure

Run the repository validator from the root:

```bash
python3 tools/validate_framework.py
```

Use task-level tests to evaluate routing and generated code quality. Record assumptions, decisions, and validation evidence in project-state files only when a project uses persistent agent context; do not infer an agent's internal memory state from a log file.
