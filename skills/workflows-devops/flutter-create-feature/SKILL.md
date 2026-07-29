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

- Flutter 3.44.x / Dart 3.12.x
- Feature-First + Clean Architecture (Presentation → Domain → Data)
- Pluggable state management: Riverpod 3.x / Bloc 9.x / Cubit / GetX 5.x
- go_router for declarative navigation

## Workflow Steps

### ⛔ Step 0: Anti-Hallucination Gate (MANDATORY FIRST STEP)

Before writing a single line of code, the AI Agent MUST evaluate requirement clarity.

> [!WARNING]
> **GRILL-ME GATE:** If requirements are ambiguous, state management is unspecified, architectural boundaries are unclear, or confidence score in `.agent/CURRENT_STATE.md` is below **0.80**, the agent MUST NOT proceed to Step 1. Instead, immediately invoke **`flutter-grill-me`** to lock down specifications across the 5 Engineering Dimensions.

**Gate Questions (all must be answered before Step 1):**
1. What exact business problem does this feature solve?
2. What state management library is active in `pubspec.yaml`?
3. What API endpoints or local data sources does this feature require?
4. What are the loading, error, empty, and success UI states?
5. What are the edge cases and failure scenarios?

Only proceed when all 5 questions are answered with **High confidence (score ≥ 0.80)**.

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

> [!CAUTION]
> **STATE MATRIX FIREWALL:** Never mix state management libraries. If `flutter_riverpod` is detected, Bloc/Cubit/GetX skills are strictly locked.

---

### Step 6: Presentation Layer

1. **Create Page** — Main screen widget; renders state, delegates actions to state holders
2. **Create Widgets** — Small, single-responsibility, reusable components
3. **Handle All States** — Loading skeleton, error with retry, empty state, data list/detail
4. **Apply Theming** — Use Material 3 tokens; no hardcoded colors or sizes
5. **Ensure Responsiveness** — Test on phone, tablet, and landscape orientation

See: `flutter-ui-engineering`, `flutter-responsive-design`, `flutter-accessibility`

---

### Step 7: Navigation

1. **Add Route** — Register in centralized `go_router` configuration
2. **Add Type-Safe Route** — With `go_router_builder` if the project uses typed routes
3. **Add Deep Link** — If the feature requires external URL navigation

See: `flutter-routing`

---

### Step 8: Testing

1. **Unit Tests** — UseCases (mocked repository), Repository (mocked datasource), Notifiers/Blocs
2. **Widget Tests** — Page rendering for each state (loading, error, empty, data)
3. **Integration Test** — If this is a critical user flow

See: `flutter-unit-testing`, `flutter-widget-testing`, `flutter-generate-tests`

---

### Step 9: Code Review Gate

Run automated verification before marking the feature as complete:

```bash
dart analyze                             # Zero warnings policy
dart format --output=none --set-exit-if-changed .  # Format check
flutter test                             # All tests pass
dart run scripts/verify_architecture.dart  # Zero domain boundary violations
```

Then request peer review against: `flutter-code-review`

---

## Execution Order Summary

```
0. Grill-Me Gate (confirm requirements & confidence ≥ 0.80)
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

- [ ] Step 0: Grill-Me Gate passed (confidence ≥ 0.80, all 5 questions answered)
- [ ] Feature-first folder structure created
- [ ] Domain layer has zero Flutter or state management imports
- [ ] All entities are immutable, pure Dart
- [ ] Repository interface returns `Result<T, Failure>`, never throws
- [ ] DTOs never leave the data layer
- [ ] State management matches active library in `pubspec.yaml`
- [ ] UI handles loading, error, empty, and data states
- [ ] No hardcoded colors or sizes (uses design system tokens)
- [ ] Route registered in go_router configuration
- [ ] Unit tests written for UseCases and Repository
- [ ] Widget tests written for all UI states
- [ ] `dart analyze` passes with zero warnings
- [ ] `dart run scripts/verify_architecture.dart` passes with zero violations

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
