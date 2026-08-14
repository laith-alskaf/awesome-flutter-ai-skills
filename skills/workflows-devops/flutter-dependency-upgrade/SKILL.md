---
name: flutter-dependency-upgrade
description: Plan and execute safe Flutter, Dart, or package upgrades. Use when updating SDK constraints, resolving package conflicts, reading breaking changes, sequencing migrations, or preparing rollback and validation evidence; do not use for selecting a stack for a new project.
---

# Flutter Dependency Upgrade

Use this skill for a compatibility change with an existing project baseline. Treat an upgrade as a migration with evidence, not as a version edit.

## Establish the Upgrade Scope

Inspect `pubspec.yaml`, lockfiles, dependency overrides, workspace configuration, platform folders, CI, generated code configuration, and the code paths that use the target dependency. Run the project's supported inventory command, such as `flutter pub outdated`, without treating its output as an automatic upgrade order.

Define the target version or range, affected platforms, package owners, user-visible risk, and a stopping condition. Read `references/upgrade-impact-guide.md` before changing SDK constraints, a major package version, a plugin with native code, or a dependency shared across a workspace.

## Classify the Change

| Change class | Required approach |
|---|---|
| Patch version with no public API impact | Review release notes, update one dependency, and run targeted checks. |
| Minor version with feature or deprecation impact | Identify affected APIs, update code and tests, and document the compatibility decision. |
| Major version, Flutter/Dart SDK, or plugin-native change | Build a migration plan, validate platforms, stage changes, and prepare rollback or containment. |
| Dependency conflict | Identify the constraint owners and select a compatible version, fork, replacement, or delayed upgrade; do not force an override without recording the cost. |

Never update a package merely because a newer version exists. Preserve intentional constraints and explain any direct manifest edit that cannot be performed safely with the package command.

## Plan Before Editing

Create a small migration record using `templates/upgrade-record.md.template`. Include the baseline, target, changelog or migration evidence, affected code and platforms, compatibility adaptations, checks, owner, and rollback condition.

For a material upgrade, split work into independently verifiable commits: preparation, version constraint change, source migration, generated-code refresh, platform updates, and cleanup. Do not combine an SDK upgrade with unrelated feature work.

## Execute and Validate

1. Update the smallest compatible set of constraints.
2. Refresh dependencies and generated code only through the project-supported commands.
3. Address compiler, analyzer, test, runtime, and platform failures in dependency order.
4. Run formatting, static analysis, targeted and full tests, generated-code verification, and relevant platform builds.
5. Compare lockfile, manifest, generated files, and native project changes against the migration record.
6. Record residual warnings, deferred migrations, and rollback trigger before finalizing.

Use `flutter-api-contract-evolution` when an upgrade changes an external API or schema contract, `flutter-workspace-architecture` when the impact spans multiple packages, and `flutter-ci-cd` when the pipeline must change.

## Validation

- [ ] The upgrade need, baseline, target, and affected platforms are documented.
- [ ] Release notes or migration guidance were reviewed proportionately to risk.
- [ ] Dependency overrides and lockfile policy were preserved or deliberately changed.
- [ ] Source, generated code, tests, and native platform changes were validated.
- [ ] A material upgrade has a rollback or containment condition.
- [ ] Unrelated refactoring and feature changes are separated from the migration.
