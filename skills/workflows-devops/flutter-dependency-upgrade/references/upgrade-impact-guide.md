# Upgrade Impact Guide

Read this guide before a major SDK, plugin, or package upgrade.

## Evidence to Collect

Collect the current and target constraints, changelog or migration guide, known breaking changes, supported Flutter/Dart versions, affected platforms, package graph, generated-code dependencies, and CI versions. For plugins, include Android Gradle Plugin, Kotlin, Xcode, CocoaPods, iOS deployment target, and platform permissions when relevant.

## Migration Order

Update the foundation before dependents. Resolve SDK compatibility first, then build tooling and platform constraints, direct dependencies, generated code, adapters, application code, and tests. Keep an issue list for deprecations that can be safely deferred; do not suppress errors without a removal condition.

## Rollback and Containment

A rollback may be a Git revert, a release-channel hold, a feature flag, a staged distribution halt, or retaining a compatibility adapter. Choose one that matches the exposure of the upgrade. Rollback is not a promise that every database or server-side change can be undone; identify irreversible changes before deployment.

## Verification Matrix

| Impact area | Example evidence |
|---|---|
| Dart source | Analyzer, format, targeted tests, full tests |
| Generated code | Generation command completes and tracked output is intentional |
| Android | Build and any affected device or emulator flow |
| iOS/macOS | Dependency resolution, build, and affected runtime flow |
| Web/Desktop | Build and changed integration path |
| CI | Updated runner, action, cache, and command behavior |
