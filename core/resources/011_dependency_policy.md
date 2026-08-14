# [ADR-011] Dependency Selection and Version Management

| Field | Value |
|---|---|
| Status | Accepted |
| Date | 2026-07-27 |
| Owner | Flutter Architecture Board |
| Scope | Production and development dependencies in Flutter projects |

## Context

Dependencies can introduce incompatible SDK constraints, unsupported platforms, security exposure, operational burden, and license obligations. A useful policy must improve those decisions without replacing engineering judgement with arbitrary popularity scores, a rigid release-age rule, or undocumented edits to project configuration.

## Decision

Evaluate every new dependency against the target project's actual requirements and constraints. Prefer package-manager commands for ordinary changes, preserve intentional project configuration, and record a short decision note where the impact warrants it. The target project—not this framework—is the source of truth for supported Flutter/Dart versions, platforms, licenses, and release obligations.

| Decision area | Required evidence | Typical response |
|---|---|---|
| Need and alternatives | The package solves a concrete requirement that existing code or SDK libraries do not reasonably solve. | State why the selected package is preferable to the viable alternatives. |
| Compatibility | The package supports the project's SDK constraints, target platforms, build tooling, and dependency graph. | Test resolution with the project configuration; do not silently widen SDK constraints. |
| Maintenance | Recent releases, issue response, ownership, and project maturity are credible for the risk of the feature. | Apply higher scrutiny to authentication, payments, background work, and native plugins. |
| Security and privacy | Advisories, permissions, native code, telemetry, and transitive dependencies are understood. | Escalate material concerns rather than assuming absence of evidence means safety. |
| License | The package license is compatible with the project's distribution model and legal policy. | Request legal review where project policy requires it; do not impose a universal allowlist. |
| Cost and operability | Bundle size, platform setup, API stability, and vendor lock-in are proportionate to the benefit. | Document mitigations for material operational risk. |

## Change procedure

Use the following commands for ordinary dependency operations:

```bash
flutter pub add <package>
flutter pub add --dev <package>
flutter pub remove <package>
flutter pub outdated
flutter pub upgrade <package>
```

Do not hand-edit generated lockfiles. Preserve intentional constraints, overrides, workspace settings, and package sources. Edit `pubspec.yaml` directly only when the package command cannot represent a necessary change—for example, a documented SDK-constraint adjustment, a Git/path dependency, or a project-specific override—and explain that exception in the change record or pull request.

## Proportionate audit trail

A dependency addition with non-trivial security, platform, or operational impact must include a concise PR or ADR note covering the requirement, compatibility evidence, license conclusion, and security/maintenance review. Do not use YAML comments as the primary audit system: they are hard to search, easy to drift, and do not explain the decision context adequately.

## Validation

Run the relevant project checks after a dependency change. At minimum, resolve packages and run the affected analysis and test commands. For releases or high-risk dependencies, also verify target platforms and follow the project's security and legal processes. `flutter pub outdated` informs maintenance work; it is not by itself a reason to fail CI or upgrade a dependency.

## Consequences

This policy preserves reproducible routine updates while allowing explicit, reviewable exceptions. It reduces false certainty, avoids destructive version churn, and directs detailed scrutiny toward decisions that can materially affect users or releases.
