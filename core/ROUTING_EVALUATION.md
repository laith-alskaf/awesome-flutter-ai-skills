# Routing and Agent-Framework Evaluation

## Purpose

This document defines how maintainers evaluate changes to skills, routing, rules, installers, and validation contracts. It measures **repository contracts and observed evidence**; it does not claim to expose a model's private reasoning or guarantee identical routing across agents and model versions.

Antigravity discovers workspace skills from `.agents/skills/` and workspace rules from `.agents/rules/`; it uses progressive disclosure, where skill metadata supports discovery and detailed instructions load only after activation.[1][2] This repository keeps project state under `.agents/context/` and treats `.agents/skills/` as the native workspace skill location.

## Evaluation Layers

| Layer | Artifact | What a pass establishes | What remains unproven |
|---|---|---|---|
| Skill contract | `SKILL.md`, `metadata.yaml`, resources | Names, frontmatter, paths, dependencies, references, and completion sections are consistent. | A model will always activate the skill. |
| Routing contract | `evaluation/routing-scenarios.yaml` | Every scenario names existing skills and has a non-conflicting primary, supporting, and forbidden set. | A particular model's exact probabilistic choice. |
| Installer contract | PowerShell scripts and CI smoke workflow | Expected project state and native-skill paths are declared and checked. | Behavior on every OS, shell, Flutter SDK, and user environment. |
| Observed compatibility | Documented live-agent run | A named environment produced an observed outcome for a specific prompt. | Generalization to other prompts, versions, or agents. |

## Scenario Contract

A routing scenario is a stable, realistic request that makes one task boundary observable. It contains an identifier, request, primary skill, optional supporting skills, optional forbidden skills, and expected strategy. The primary skill is the authoritative workflow; supporting skills are used only when the request crosses a genuine boundary; forbidden skills prevent likely wasteful or unsafe activation.

Add or revise a scenario whenever a change affects a skill description, trigger, negative trigger, routing matrix, workspace rule, installer, or validator. Avoid writing scenarios that repeat the exact text of a skill description. Instead, use task language a Flutter engineer would naturally use.

## Maintenance Procedure

1. Read the affected skill, metadata, local resources, relevant rule, router entry, and existing scenario.
2. Make the smallest coherent change across all connected contracts.
3. Add or update a scenario if the routing boundary changes.
4. Run `python3 tools/validate_framework.py` from the repository root.
5. For deployment changes, run the non-destructive PowerShell preview where available and rely on the Windows CI smoke test for project initialization.
6. Report structural results separately from untested platform behavior or sampled live-agent behavior.

## Design Constraints

Skill descriptions must state what the skill does and when it should be used, because descriptions drive discovery.[1][3] Keep `SKILL.md` focused and move uncommon detail to a shallow local resource; the Agent Skills specification recommends keeping the main file below 500 lines.[3] Rules remain concise reusable constraints, while detailed task procedure belongs in skills and durable project facts belong in `.agents/context/`.[2]

## References

[1]: https://antigravity.google/docs/skills "Antigravity Agent Skills"
[2]: https://antigravity.google/docs/rules-workflows "Antigravity Rules and Workflows"
[3]: https://agentskills.io/specification "Agent Skills Specification"
