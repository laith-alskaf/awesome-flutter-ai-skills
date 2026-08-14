---
name: flutter-workspace-architecture
description: Design, migrate, or review Flutter and Dart multi-package workspaces, pub workspaces, Melos configuration, package boundaries, shared tooling, and CI orchestration. Use when working with a monorepo, reusable package ecosystem, or cross-package dependency graph; do not use for a single feature folder.
---

# Flutter Workspace Architecture

Use this skill to make a workspace boundary or tooling decision that affects more than one Flutter or Dart package. Preserve an existing workspace unless there is a documented reason to migrate it.

## Start with Evidence

Inspect the workspace root, every `pubspec.yaml`, the lockfile policy, CI workflows, code-generation configuration, platform ownership, and package import graph. Identify whether the repository uses native Pub Workspaces, Melos, another orchestrator, or no workspace tool. Do not infer a workspace design from one package alone.

Record the goal, affected packages, supported Flutter/Dart constraints, CI constraints, and migration risks. Read `references/workspace-decision-guide.md` when deciding between a native Pub Workspace and Melos.

## Select a Boundary Model

Choose package boundaries by stable ownership and release coupling, not by folders that merely look similar. A package should expose a narrow API, own its implementation details, and avoid importing another package's internal `lib/src` API.

1. Keep an app package responsible for composition, platform runners, and app-specific assets.
2. Extract a shared package only when at least two consumers need a stable, independently testable capability.
3. Keep feature packages independent of app composition and platform runners.
4. Separate pure Dart domain or client packages from Flutter UI packages when non-Flutter reuse or faster unit testing is valuable.
5. Define ownership for generated code, localization, assets, and platform channels before moving files.

Do not create packages merely to mirror Clean Architecture layers. Prefer feature or capability packages with clear public APIs.

## Choose Tooling Deliberately

Use native Pub Workspaces when the repository primarily needs a shared dependency resolution model and simple local package development. Use Melos when the workspace needs package filtering, bootstrap scripts, coordinated versioning, release orchestration, or cross-package command execution beyond native Pub capabilities. Keep the decision reversible where possible.

If introducing or changing an orchestrator, write a short decision record containing alternatives, the selected model, developer commands, CI changes, and rollback conditions. Read `templates/workspace-decision.md.template` before writing the record.

## Migrate Incrementally

1. Freeze the current package graph and establish baseline analysis and tests.
2. Define each new package name, owner, public API, and allowed dependencies.
3. Move one cohesive capability at a time, preserving imports through temporary adapters if necessary.
4. Update package references using relative workspace dependencies only where supported by the selected toolchain.
5. Run formatting, analysis, relevant tests, code generation, and the workspace command matrix after every boundary move.
6. Remove compatibility adapters only after all consumers migrate and the removal has a validated release plan.

Do not combine a workspace migration with an unrelated SDK upgrade, feature rewrite, or visual redesign unless the user explicitly accepts the increased risk.

## Configure CI and Developer Experience

Ensure CI derives package selection from changed files or an explicit package matrix. Run static analysis and tests for every affected package, then run integration or app-level checks for changed app composition or platform interfaces. Cache dependencies safely without assuming a single global lockfile policy.

Document one command path for local bootstrap, analysis, tests, code generation, and release. Do not make shell aliases or generated files the only way to understand the workspace.

## Validation

- [ ] The selected workspace model is based on repository evidence and recorded trade-offs.
- [ ] Each affected package has a clear owner, public API, and dependency boundary.
- [ ] No consumer imports another package's internal implementation API.
- [ ] CI and local commands cover every affected package and relevant app integration.
- [ ] The migration order has checkpoints, validation evidence, and a rollback or containment plan.
- [ ] `flutter-dependency-upgrade` is used separately if SDK or package constraints also change.

## Related Skills

Use `flutter-feature-first` for feature-local organization, `flutter-clean-architecture` for layer boundaries, `flutter-dependency-upgrade` for SDK or package migration, and `flutter-ci-cd` for pipeline implementation.
