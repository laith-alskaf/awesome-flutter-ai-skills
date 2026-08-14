# Flutter Agent Framework Evaluation

Use this rule when changing a skill description, trigger boundary, metadata dependency, workspace rule, installer, validator, or routing scenario in this repository.

Treat the change as a connected contract. Read the affected `SKILL.md`, `metadata.yaml`, referenced resources, `core/ROUTER_MANIFESTO.md`, and any related scenario before editing. When a new skill or routing boundary is added, include a realistic scenario with an expected primary skill and, where useful, supporting or forbidden skills.

Keep assertions evidence-based. A structural validator can prove names, paths, links, schema, and declared scenario consistency. It cannot prove that every model selects a skill identically. Label live-agent or platform checks as observed evidence, including the environment and limits.

Keep rules concise and reusable. Put task-specific procedures in skills, persistent project facts in `.agent/`, and repository acceptance checks in validation tooling. Before finalizing, run `python3 tools/validate_framework.py`, report the result, and state any unverified PowerShell, Flutter SDK, or IDE behavior.
