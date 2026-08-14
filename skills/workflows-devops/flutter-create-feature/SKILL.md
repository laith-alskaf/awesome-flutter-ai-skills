---
name: flutter-create-feature
description: >
  Use this skill when creating a new feature end-to-end in a Flutter application.
  Provides a step-by-step workflow from domain analysis through data layer, state
  management, UI implementation, to testing — all following Clean Architecture.
  This is a compound workflow skill that references other skills for detailed
  implementation guidance.
triggers:
  - "Build a new feature end-to-end across all layers"
  - "Execute vertical-slice workflow (Domain → Data → State → UI → Test)"
  - "Integrate clean architecture feature components"
negative_triggers:
  - "Single widget bug fix"
  - "DevOps release setup"
---

# Flutter Create Feature Workflow

## Purpose

Execute a complete, production-ready feature from requirements to tested implementation using a standardized, repeatable workflow. Every feature must respect Clean Architecture layer boundaries, support all UI states, and include automated tests before merging.

## Scope

**Covers:** End-to-end feature creation across all architectural layers — Domain, Data, State Management, Presentation, Navigation, and Testing.

**Does not cover:** New project setup (use `flutter-project-architect`), standalone bug fixes (use `flutter-bug-fixing`), DevOps release pipelines (use `flutter-ci-cd`).

## Technology Context

- Use the target project's declared Flutter/Dart versions and existing architecture as the source of truth.
- Apply Feature-First Clean Architecture only when it is established by the project or selected for this new feature.
- Select state management from the affected feature's existing implementation and `pubspec.yaml` evidence.
- Reuse the project's routing mechanism; use `go_router` only when it is already selected or explicitly adopted.

## Workflow Steps

### Step 0: Establish Decision Readiness

Before implementing a non-trivial feature, inspect the target project's architecture, affected feature, state-management usage, data sources, routes, and relevant `.agent/` state when it exists.

> **Grill-Me rule:** If an unanswered question could change architecture, state management, data, security, dependencies, external contracts, deployment, or user-visible behavior, invoke **`flutter-grill-me`** or record an explicit assumption before the affected implementation step. Do not force unrelated questions or a numerical confidence threshold onto reversible low-risk work.

**Typical questions, when applicable:**
1. What user problem and acceptance criteria define the feature?
2. Which state-management approach does the affected feature already use?
3. What API, local data, privacy, or synchronization decisions are required?
4. Which loading, error, empty, and success states can this user flow exhibit?
5. Which edge cases and failure scenarios require tests or explicit handling?

---

### Step 1: Understand Requirements

- What business problem does this feature solve?
- What are the user stories? (`As a [user], I want to [action], so that [value]`)
- What data does it need? (APIs, local storage, both?)
- What states must the UI support? (loading, error, empty, data)
- What are the edge cases and failure scenarios?

See: `flutter-feature-planner` for structured requirement breakdown.

---

### Step 2: Create Feature Folder Structure

```
lib/features/<feature_name>/
  domain/
    entities/
    repositories/      # Abstract interfaces only
    usecases/
    failures/          # Sealed failure class
  data/
    datasources/
    models/            # DTOs with JSON annotations
    repositories/      # Concrete implementations
    mappers/
  presentation/
    pages/
    widgets/
    state/             # State holders (Notifiers / Blocs / Cubits / Controllers)
```

---

### Step 3: Domain Layer (Build First)

> [!IMPORTANT]
> Domain is the heart of the feature. Build it first — before any UI or networking code. It must be 100% pure Dart with zero Flutter imports.

1. **Define Entities** — Pure Dart, immutable, no framework imports, no JSON annotations
2. **Define Failures** — Sealed class for this feature's typed error cases
3. **Define Repository Interface** — Abstract class with methods returning `Result<T, Failure>`
4. **Define Use Cases** — One class per business action, single `call()` method

See: `flutter-clean-architecture`, `flutter-error-handling`, `flutter-domain-modeling`

---

### Step 4: Data Layer

1. **Create DTOs** — `@JsonSerializable` models matching the API/DB contract
2. **Create Mappers** — Extension methods converting `DTO → Entity`
3. **Create Datasources** — Remote (Dio/API) and/or Local (Drift/Hive) data access classes
4. **Implement Repository** — Concrete class implementing the domain interface; catches all exceptions and maps them to sealed Failures

See: `flutter-api-integration`, `flutter-local-database`, `flutter-repository-pattern`

---

### Step 5: State Management (Check Project Matrix)

Check the active state management library in `pubspec.yaml`:

| Detected Library | Required Skill | Template |
|---|---|---|
| `flutter_riverpod` / `riverpod_generator` | `flutter-riverpod` | `riverpod_notifier.dart.template` |
| `flutter_bloc` + event classes | `flutter-bloc` | `bloc.dart.template` |
| `flutter_bloc` + method calls | `flutter-cubit` | `cubit.dart.template` |
| `get` (GetX) | `flutter-getx` | `getx_controller.dart.template` |

> **State-selection rule:** Reuse the approach already used by the affected feature. `flutter_bloc` alone does not distinguish Bloc from Cubit; inspect the actual classes and request. Do not introduce a second approach into one feature without an explicit migration boundary and removal plan.

---

### Step 6: Presentation Layer

1. **Create Page** — Main screen widget; renders state, delegates actions to state holders
2. **Create Widgets** — Small, single-responsibility, reusable components
3. **Handle All States** — Loading skeleton, error with retry, empty state, data list/detail
4. **Apply Theming** — Reuse the project's design system and avoid unexplained hardcoded visual values.
5. **Ensure Responsiveness** — Test the target form factors and orientations that the project supports.

See: `flutter-ui-engineering`, `flutter-responsive-design`, `flutter-accessibility`

---

### Step 7: Navigation

1. **Add Route** — Register the feature through the routing mechanism already used by the project.
2. **Add Type Safety** — Use typed routes only when the selected router and project support them.
3. **Add Deep Link** — Add and test one only when the feature requires external URL navigation.

See: `flutter-routing`

---

### Step 8: Testing

1. **Unit Tests** — Cover changed business logic and state behavior using the project's test conventions.
2. **Widget Tests** — Cover user-visible states that the changed page can exhibit.
3. **Integration Test** — Add one when the user flow is critical or the project requires it.

See: `flutter-unit-testing`, `flutter-widget-testing`, `flutter-generate-tests`

---

### Step 9: Code Review Gate

Run automated verification before marking the feature as complete:

```bash
dart analyze
dart format --output=none --set-exit-if-changed .
flutter test
dart run .agent/tools/verify_architecture.dart
```

Run only the checks supported by the target project and include relevant platform or integration checks. The architecture verifier applies when the project uses the framework's Clean Architecture layout.

Then request peer review against: `flutter-code-review`

---

## Execution Order Summary

```
0. Establish decision readiness and resolve material uncertainty
1. Domain Entities (pure Dart, immutable)
2. Domain Failures (sealed class with userMessage)
3. Domain Repository Interface (abstract, returns Result<T, Failure>)
4. Domain Use Cases (one per business action)
5. Data DTOs + JSON Serialization
6. Data Mappers (DTO → Entity)
7. Data Datasources (Remote / Local)
8. Data Repository Implementation (catches exceptions, returns Result)
9. State Holders + DI Registration (Riverpod / Bloc / Cubit / GetX)
10. UI Pages + Widgets (all 4 states: loading, error, empty, data)
11. Route Registration (go_router)
12. Tests (Unit + Widget + Integration if critical)
13. Code Review (dart analyze + dart format + flutter test + verify_architecture)
```

## Checklist

- [ ] Material uncertainty was resolved through `flutter-grill-me` or documented assumptions
- [ ] Feature-first folder structure created
- [ ] Domain layer has zero Flutter or state management imports
- [ ] All entities are immutable, pure Dart
- [ ] Repository interface returns `Result<T, Failure>`, never throws
- [ ] DTOs never leave the data layer
- [ ] State management matches the affected feature's established approach or documented selection
- [ ] UI handles loading, error, empty, and data states
- [ ] Visual values follow the project's design system or have an explicit rationale
- [ ] Route registered through the project's routing mechanism when navigation is required
- [ ] Unit tests written for UseCases and Repository
- [ ] Widget tests written for all UI states
- [ ] Applicable analysis, formatting, test, and platform checks pass
- [ ] `dart run .agent/tools/verify_architecture.dart` passes when Clean Architecture verification applies

## Related Skills

- `flutter-grill-me` — Anti-hallucination gate (Step 0)
- `flutter-clean-architecture` — Layer structure and dependency rules
- `flutter-domain-modeling` — Domain entity and value object design
- `flutter-feature-planner` — Requirements breakdown and sprint planning
- `flutter-riverpod` — Riverpod state management
- `flutter-bloc` — Bloc event-driven state management
- `flutter-cubit` — Cubit method-driven state management
- `flutter-getx` — GetX reactive state management
- `flutter-api-integration` — Networking and DTO design
- `flutter-local-database` — Local persistence with Drift/Hive
- `flutter-repository-pattern` — Repository interface and implementation
- `flutter-ui-engineering` — Widget design and Material 3
- `flutter-error-handling` — Failure modeling and propagation
- `flutter-routing` — Navigation with go_router
- `flutter-unit-testing` — UseCase and repository tests
- `flutter-widget-testing` — UI state rendering tests
- `flutter-code-review` — Final quality gate
