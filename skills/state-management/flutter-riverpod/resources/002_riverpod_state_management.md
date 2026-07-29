# [ADR-002] Riverpod 3.x with Code Generation for State Management & DI

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Flutter applications require a reactive, predictable, and compile-safe mechanism for managing state and injecting dependencies. Legacy solutions like `StateProvider`, `ChangeNotifier`, or manual dependency containers (`get_it`) often suffer from runtime lookup exceptions, lack of auto-disposal, verbose boilerplate, and difficult test mocking. We need a unified, compile-safe standard for state management and dependency injection.

---

## Decision Drivers

- Must provide compile-time safety (no runtime `ProviderNotFoundException`).
- Must support automatic resource disposal (`autoDispose`) to prevent memory leaks when navigating between screens.
- Must handle asynchronous states cleanly (`data`, `loading`, `error`) without manual boolean flags.
- Must act as a first-class dependency injection container for Clean Architecture layers.

---

## Considered Options

1. **Riverpod 3.x with `@riverpod` Code Generation (Chosen):** Compile-safe functional and class-based providers using `riverpod_generator`.
2. **Flutter Bloc / Cubit:** Event-driven state management using stream transformers.
3. **GetX:** All-in-one state, navigation, and DI framework.
4. **Manual Provider / ChangeNotifier:** Traditional Flutter widget tree dependency injection.

---

## Decision Outcome

Chosen option: **Riverpod 3.x with Code Generation**, because it eliminates boilerplate, enforces immutable state transitions, handles async data gracefully via `AsyncValue`, and doubles as a compile-safe dependency injection graph for repositories and use cases.

### Positive Consequences

- **Compile-Time Safety:** Dependencies are verified at compile time; typos or missing registrations fail the build immediately.
- **Zero Memory Leaks:** Providers generated via `@riverpod` default to auto-dispose when their listening widgets unmount.
- **Exhaustive State Handling:** `AsyncValue.when` forces UI screens to handle loading, error, and data states explicitly.
- **Effortless Mocking:** `ProviderContainer.overrides` allows instant swapping of mock repositories in unit and widget tests.

### Negative Consequences / Trade-offs

- **Code Generation Dependency:** Requires running `dart run build_runner watch` during active development.
- **Syntax Transition:** Developers familiar with legacy `StateNotifier` must adapt to Dart 3 `@riverpod` class syntax.

---

## Validation & Compliance

- **How to verify compliance:** Enforced via `riverpod_lint` rules in `analysis_options.yaml` preventing legacy provider definitions.
- **Relevant Skills:** `flutter-riverpod`, `flutter-dependency-injection`
