# Pull Request (PR) Review Checklist

Use this checklist before submitting or approving a Pull Request to ensure production-ready quality.

## 1. Automated Verification
- [ ] `dart analyze` passes with zero warnings, errors, or lints.
- [ ] `dart format --output=none --set-exit-if-changed .` passes with zero changes needed.
- [ ] `flutter test` executes and passes all unit and widget tests.

## 2. Code Quality & Style
- [ ] Follows Dart 3.12+ features (pattern matching, sealed classes, private named parameters where appropriate).
- [ ] No `dynamic` types used unless strictly necessary for interoperability (with explicit comment).
- [ ] No magic numbers or hardcoded text strings (uses design tokens and localization keys).
- [ ] All new public classes, functions, and parameters have descriptive, self-documenting names.

## 3. State & UI Performance
- [ ] All widget constructors use `const` where possible.
- [ ] Large build methods are decomposed into separate, private `StatelessWidget` classes to restrict rebuild scopes.
- [ ] Lists with dynamic data use `.builder` constructors (`ListView.builder`, `SliverList.builder`).
- [ ] `ref.watch(provider.select(...))` is used when components only depend on a sub-property of state.

## 4. Error Handling & Security
- [ ] All network or local storage operations handle potential failures and expose user-friendly error messages.
- [ ] No sensitive keys, passwords, or PII are written to console logs or committed in source code.
