# Workspace Decision Guide

Read this guide only when selecting or changing workspace tooling.

## Native Pub Workspaces

Prefer a native Pub Workspace when package development needs shared dependency resolution, local package references, and straightforward repository commands. Confirm that the target Dart and Flutter SDK constraints support the chosen workspace configuration before editing manifests.

Use a root manifest to describe the workspace, keep package manifests independently valid, and decide explicitly whether the repository uses one shared lockfile or package-level lockfiles. Do not mix incompatible lockfile assumptions in CI.

## Melos

Use Melos when the repository needs filtered cross-package commands, bootstrap automation, coordinated releases, package graph-aware scripts, or a consistent contributor command surface that native Pub Workspace behavior does not cover. Keep Melos commands thin wrappers around documented `dart` and `flutter` commands so failure output remains understandable.

## Boundary Review Questions

| Question | Healthy answer |
|---|---|
| Who owns this package? | One team, feature, or capability has a named responsibility. |
| Who consumes it? | Consumers use documented public libraries, not `lib/src`. |
| Can it be tested independently? | Unit or package-level tests run without the app package. |
| Does it need Flutter? | It depends on Flutter only when UI, plugins, or bindings require it. |
| Is release coupling intentional? | The dependency and release relationship is explicit. |

## Migration Containment

Keep adapters temporary, track every consumer migration, and delete an adapter only after all consumers and relevant tests move. When a move changes public APIs, version and communicate the change separately from unrelated refactoring.
