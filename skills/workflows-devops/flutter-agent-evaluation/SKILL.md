---
name: flutter-agent-evaluation
description: Evaluate Flutter agent skills, rules, and routing scenarios with reproducible fixtures and evidence. Use when adding or changing skills, rules, installation behavior, or validation contracts; do not use for modifying a Flutter application feature.
---

# Flutter Agent Evaluation

Use this skill to test the framework that guides an agent, not the Flutter application being built. Evaluate explicit contracts and observed evidence; do not claim to measure an agent's private reasoning or guarantee behavior across every model.

## Define the Change Boundary

Identify whether the change affects skill discovery, a frontmatter description, routing, a rule, a workflow, installation, generated project state, or a validation script. Read the affected `SKILL.md`, `metadata.yaml`, resource files, workspace rule, installer, and existing scenario fixture before changing any contract.

Select a small representative scenario set that includes an expected primary skill, supporting skills only when needed, forbidden skills where confusion is likely, and expected strategic behavior. Read `references/evaluation-protocol.md` before adding a new category or interpreting a result.

## Build Scenarios as Contracts

Store scenarios in the repository evaluation fixture. Every scenario must have a stable identifier, a realistic user request, one primary skill, optional supporting and forbidden skills, and a short expected strategy. Keep requests task-oriented rather than testing the exact wording of a single description.

Use this sequence:

1. Add a scenario before or with any material routing change.
2. Verify every named skill exists and every identifier is unique.
3. Specify a primary skill only when the task has a clear authoritative workflow.
4. Specify supporting skills only when the task genuinely spans boundaries.
5. Specify forbidden skills when the scenario could cause harmful or wasteful activation.
6. Record whether the expected outcome is structural validation, a dry-run installer check, or a human evaluation on a supported agent.

## Evaluate Installation and Rules

For installation changes, test the smallest supported setup first. Verify that project state is written to `.agents/context/`, workspace skills are written to `.agents/skills/`, and workspace rules are available from `.agents/rules/`. Use `-WhatIf` for deployment and uninstallation checks before a destructive run.

Rules should constrain reusable behavior, while skills should describe focused task workflows. Do not duplicate long technical procedures inside a workspace rule. If a rule changes, add or update a scenario that would expose a regression.

## Interpret Results Safely

A passing structural validator proves consistency of names, paths, metadata, scenarios, and declared contracts. It does not prove that every model will make the same routing decision. Treat live-agent runs as sampled compatibility evidence; record the agent version, task prompt, observed selected skill, output quality, and limitations.

Use `templates/evaluation-record.md.template` to report evidence. Escalate failures caused by ambiguous scope by improving descriptions, negative triggers, decision trees, or scenario design rather than adding a broad always-on rule.

## Validation

- [ ] The change boundary and affected contracts are identified.
- [ ] Scenario fixtures cover the new or changed behavior and pass structural validation.
- [ ] Every assertion distinguishes static contract evidence from observed live-agent behavior.
- [ ] Installation checks use non-destructive preview where supported.
- [ ] Rules, skills, metadata, installers, documentation, and validation tests change together when their shared contract changes.
- [ ] Remaining model, platform, or SDK limitations are recorded clearly.
