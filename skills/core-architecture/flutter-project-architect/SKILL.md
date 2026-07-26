---
name: flutter-project-architect
description: >
  Use this skill when starting a new Flutter project, designing application
  architecture, selecting packages, planning folder structure, or making
  foundational technical decisions. Transforms business requirements into
  production-ready Flutter architectures with scalable package selection and
  project classification. Do not use for feature-level planning (use
  flutter-feature-planner) or specific implementation patterns (use domain
  skills like flutter-riverpod).
triggers:
  - "Start new Flutter project from scratch"
  - "Select technology stack and packages"
  - "Define foundational architecture standards"
negative_triggers:
  - "Feature-level planning"
  - "Single widget refactoring"
---

# Flutter Project Architect

## Purpose

Transform vague product ideas into production-ready Flutter architectures. Guide every phase from requirements to release planning. Think before coding — never jump directly into implementation.

## Scope

**Covers:** Project classification, requirements analysis, architecture design, package selection, folder structure, dependency strategy, risk assessment, production readiness.

**Does not cover:** Feature-level user stories/sprints (use flutter-feature-planner), specific widget implementation, state management details.

## Technology Context

- Flutter 3.44.x Stable / Dart 3.12.x
- Impeller (default on iOS and Android, no opt-out)
- SwiftPM (default for iOS, CocoaPods sunsetting December 2026)
- Material 3 (default)
- Agentic Hot Reload (for AI-assisted development)
- Genkit Dart (for AI-powered features)

## Rules

### Thinking Process

Always follow this order. Never skip steps.

1. Understand business goals
2. Collect user requirements
3. Identify technical constraints
4. Classify project size
5. Divide into independent features
6. Design architecture
7. Choose packages (justify each)
8. Plan folder structure
9. Identify risks and mitigations
10. Generate code only after architecture approval

### Project Classification

Architecture decisions must depend on project size.

| Classification | Criteria | Architecture |
|---|---|---|
| **Small** | <15 screens, local storage, 1 developer | Riverpod + simple repository |
| **Medium** | Auth, REST APIs, push notifications, 20-60 screens | Feature-first + Clean Architecture |
| **Large** | Enterprise, multi-team, CI/CD, 60+ screens | Modular Clean Architecture + feature packages |

### Default Architecture

Feature-First + Clean Architecture. Each feature contains Presentation, Domain, Data. Shared code only inside `core/` and `shared/`.

### Recommended Package Stack (July 2026)

| Concern | Package | Why |
|---|---|---|
| State Management | `riverpod` + `riverpod_generator` | Compile-safe, testable, code gen |
| Routing | `go_router` + `go_router_builder` | Declarative, typed routes, deep linking |
| Networking | `dio` | Interceptors, retry, cancellation |
| DI | Riverpod providers (primary) | Built-in with state management |
| Models | `freezed` | Immutable, copyWith, sealed unions |
| Serialization | `json_serializable` | Code gen, type-safe |
| Local Database | `drift` | Type-safe SQL, migrations |
| Secure Storage | `flutter_secure_storage` | Encrypted key-value |
| Image Caching | `cached_network_image` | Disk + memory cache |
| Logging | `logger` | Pretty console output |
| Environment | `envied` | Compile-time env variables |
| Linting | `riverpod_lint` + `flutter_lints` | Static analysis |
| Analytics | Firebase Analytics | Industry standard |
| Crash Reporting | Firebase Crashlytics | Real-time crash data |
| Code Gen | `build_runner` | Unified code generation |

Every dependency must justify its existence. Avoid unnecessary packages. Prefer actively maintained packages.

### Folder Structure

```
lib/
  app/                    # App-level config (MaterialApp, theme, router)
  core/
    network/              # ApiClient, interceptors
    errors/               # Base failure classes
    theme/                # ThemeData, colors, typography
    utils/                # Extensions, helpers, constants
  shared/
    widgets/              # Cross-feature widgets
    extensions/           # Dart extensions
  features/
    authentication/
      data/
      domain/
      presentation/
    home/
      data/
      domain/
      presentation/
    profile/
    settings/
test/
  features/               # Mirrors lib/features/ structure
integration_test/
```

### State Management Selection

| App Size | Recommendation |
|---|---|
| Small | Riverpod functional providers + simple notifiers |
| Medium | Riverpod + AsyncNotifier + Repository pattern |
| Large | Riverpod + AsyncNotifier + UseCase + Repository |

### Error Handling Strategy

Use sealed classes for typed failures. Never expose raw exceptions.

```dart
sealed class AppFailure {
  const AppFailure();
  String get userMessage;
}
```

### Security Defaults

- flutter_secure_storage for tokens (never SharedPreferences)
- envied for compile-time secrets (never hardcoded)
- HTTPS only
- Certificate pinning for financial/health apps

## Output Format

When architecting a project, always provide:

1. **Requirements Summary** — Business + technical + non-functional
2. **Project Classification** — Small / Medium / Large
3. **Architecture Decision** — With justification
4. **Package Selection** — With pros/cons for each
5. **Folder Structure** — Complete tree
6. **Feature List** — Prioritized with dependencies
7. **Risk Assessment** — Technical + business risks
8. **Implementation Order** — What to build first
9. **Production Readiness** — Checklist for launch

## Checklist

- [ ] Project classified (Small/Medium/Large)
- [ ] Requirements collected (business, functional, non-functional)
- [ ] Architecture chosen with justification
- [ ] All packages justified and actively maintained
- [ ] Folder structure defined
- [ ] Features identified and prioritized
- [ ] Risks documented with mitigations
- [ ] Security strategy defined
- [ ] Testing strategy defined
- [ ] CI/CD approach planned

## Related Skills

- `flutter-feature-planner` — Feature breakdown, user stories, sprints
- `flutter-clean-architecture` — Layer design and dependency rules
- `flutter-riverpod` — State management implementation
- `flutter-routing` — Navigation architecture
- `flutter-security` — Security implementation
