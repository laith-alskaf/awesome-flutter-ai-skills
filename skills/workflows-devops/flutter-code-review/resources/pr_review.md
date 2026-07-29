# Pull Request (PR) Review Checklist

Use this checklist before submitting or approving a Pull Request to ensure production-ready quality.
Reference skill: `flutter-code-review`

---

## 1. Automated Verification

- [ ] `dart analyze` passes with zero warnings, errors, or lints.
- [ ] `dart format --output=none --set-exit-if-changed .` passes with zero changes needed.
- [ ] `flutter test` executes and passes all unit and widget tests.
- [ ] `dart run scripts/verify_architecture.dart` passes with zero domain boundary violations.

## 2. Code Quality & Style

- [ ] Follows Dart 3.12+ features (pattern matching, sealed classes, private named parameters where appropriate).
- [ ] No `dynamic` types used unless strictly necessary for interoperability (with explicit comment).
- [ ] No magic numbers or hardcoded text strings (uses design tokens and localization keys).
- [ ] All new public classes, functions, and parameters have descriptive, self-documenting names.
- [ ] All public APIs have explicit types; local variable types are inferred.

## 3. Architecture Boundaries (Clean Architecture)

- [ ] Domain layer contains zero imports from `package:flutter/`, state management libraries, or networking packages.
- [ ] Data layer (DTOs, datasources, repositories) contains zero imports from Flutter UI widgets.
- [ ] No DTO is passed upward to domain or presentation layers (mapping happens at repository boundary).
- [ ] All Repositories return `Result<T, Failure>` — they never `throw` exceptions to callers.
- [ ] All business logic lives in UseCases, not in Notifiers, Blocs, Cubits, or Widgets.

## 4. State & UI Performance

- [ ] All widget constructors use `const` where possible.
- [ ] Large build methods are decomposed into separate, private `StatelessWidget` classes to restrict rebuild scopes.
- [ ] Lists with dynamic data use `.builder` constructors (`ListView.builder`, `SliverList.builder`).
- [ ] `ref.watch(provider.select(...))` is used when components only depend on a sub-property of state.
- [ ] All screens handle all 4 states: loading, error (with retry), empty, and data.

## 5. Error Handling & Security

- [ ] All network or local storage operations handle potential failures and expose user-friendly error messages.
- [ ] No sensitive keys, passwords, or PII are written to console logs or committed in source code.
- [ ] Sealed failure classes with `userMessage` are used; raw exception strings never reach the UI.
- [ ] Tokens and secrets stored in `flutter_secure_storage` (never `SharedPreferences`).

## 6. Testing Coverage

- [ ] New business logic has corresponding unit tests (UseCase, Repository, Notifier/Bloc).
- [ ] New UI screens have widget tests covering all state transitions (loading, error, empty, data).
- [ ] Any bug fix includes a regression test that fails before the fix and passes after.
- [ ] `flutter test --coverage` checked — no critical code paths left uncovered.

---

**Related Skills:** `flutter-code-review` · `flutter-error-handling` · `flutter-security` · `flutter-unit-testing` · `flutter-widget-testing`
