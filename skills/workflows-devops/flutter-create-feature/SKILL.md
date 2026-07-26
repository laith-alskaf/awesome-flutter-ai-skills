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
  - "Execute vertical-slice workflow (Domain ? Data ? State ? UI ? Test)"
  - "Integrate clean architecture feature components"
negative_triggers:
  - "Single widget bug fix"
  - "DevOps release setup"
---

# Flutter Create Feature Workflow

## Purpose

Execute a complete, production-ready feature from requirements to tested implementation using a standardized, repeatable workflow.

## Workflow Steps

### Step 1: Understand Requirements

Before writing any code, answer:
- What business problem does this feature solve?
- What are the user stories?
- What data does it need? (APIs, local storage, both?)
- What states must the UI support? (loading, error, empty, data)
- What are the edge cases?

### Step 2: Create Feature Folder Structure

```
lib/features/<feature_name>/
  domain/
    entities/
    repositories/      # Abstract interfaces
    usecases/
    failures/           # Sealed failure class
  data/
    datasources/
    models/             # DTOs with JSON annotations
    repositories/       # Concrete implementations
    mappers/
  presentation/
    pages/
    widgets/
    state/              # State holders (Notifiers / Blocs / Cubits / Controllers)
```

### Step 3: Domain Layer (Build First)

1. **Define Entities** — Pure Dart, immutable, no framework imports
2. **Define Failures** — Sealed class for this feature's error cases
3. **Define Repository Interface** — Abstract class with methods returning `Result<T, Failure>`
4. **Define Use Cases** — One class per business action

See: `flutter-clean-architecture`, `flutter-error-handling`

### Step 4: Data Layer

1. **Create DTOs** — @JsonSerializable models matching API contract
2. **Create Mappers** — Extensions converting DTO ↔ Entity
3. **Create Datasources** — Remote (API) and/or Local (database) data access
4. **Implement Repository** — Concrete class implementing domain interface, maps exceptions to failures

See: `flutter-api-integration`, `flutter-local-database`

### Step 5: State Management (Check Project Matrix)

Check project's adopted state management library (`pubspec.yaml` or user prompt):
1. **Riverpod 3.x:** Create `@riverpod` AsyncNotifier/Notifier and functional providers (`flutter-riverpod`).
2. **Bloc 9.x:** Create event-driven Bloc with `freezed` events/states (`flutter-bloc`).
3. **Cubit:** Create method-driven Cubit with `freezed` state (`flutter-cubit`).
4. **GetX 5.x:** Create GetxController with reactive state variables and Bindings (`flutter-getx`).

See: `flutter-riverpod`, `flutter-bloc`, `flutter-cubit`, `flutter-getx`

### Step 6: Presentation Layer

1. **Create Page** — Main screen widget, handles state rendering
2. **Create Widgets** — Small, reusable, single-responsibility components
3. **Handle All States** — Loading, error (with retry), empty, data
4. **Apply Theming** — Use Material 3 tokens, no hardcoded values
5. **Ensure Responsiveness** — Test on phone, tablet, landscape

See: `flutter-ui-engineering`, `flutter-responsive-design`

### Step 7: Navigation

1. **Add Route** — Register in centralized go_router config
2. **Add Type-Safe Route** — With go_router_builder if using typed routes

See: `flutter-routing`

### Step 8: Testing

1. **Unit Tests** — UseCases, Repository (mocked datasource), Notifiers
2. **Widget Tests** — Page rendering for each state
3. **Integration Test** — If critical flow

See: `flutter-unit-testing`, `flutter-widget-testing`

### Step 9: Review

Verify against:
- [ ] Clean Architecture dependency rules
- [ ] All states handled in UI
- [ ] Error mapping complete
- [ ] No business logic in widgets
- [ ] Tests pass with adequate coverage
- [ ] Code formatted and analyzed

See: `flutter-code-review`

## Execution Order Summary

```
1. Domain Entities
2. Domain Failures (sealed class)
3. Domain Repository Interface
4. Domain Use Cases
5. Data DTOs + Mappers
6. Data Datasources
7. Data Repository Implementation
8. State Holders + DI Registration (Riverpod / Bloc / Cubit / GetX)
9. UI Pages + Widgets
10. Route Registration
11. Tests (Unit + Widget)
12. Code Review
```

## Related Skills

- `flutter-clean-architecture` — Layer structure
- `flutter-riverpod` — Riverpod state management
- `flutter-bloc` — Bloc state management
- `flutter-cubit` — Cubit state management
- `flutter-getx` — GetX state management
- `flutter-api-integration` — Networking
- `flutter-ui-engineering` — Widget design
- `flutter-error-handling` — Failure modeling
- `flutter-routing` — Navigation setup
- `flutter-unit-testing` — Test implementation
