---
name: flutter-code-review
description: >
  Use this skill when reviewing Flutter code for architecture compliance, code
  quality, performance, security, and production readiness. Provides a systematic
  review checklist covering SOLID, Clean Architecture, error handling, testing,
  naming, accessibility, and common mistakes. Do not use for performance profiling
  (use flutter-performance) or security auditing (use flutter-security).
triggers:
  - "Review Flutter pull request or code changes"
  - "Perform 6-step PR quality audit (Architecture, State, UI, Security, Test)"
  - "Check SOLID compliance and production readiness"
negative_triggers:
  - "Performance DevTools profiling"
  - "Security audit scan"
---

# Flutter Code Review

## Purpose

Systematically verify code quality across architecture, performance, security, accessibility, and maintainability dimensions before approval.

## Review Process

1. **Architecture** — Does it follow Clean Architecture? Correct dependency flow?
2. **Code Quality** — SOLID, DRY, KISS? Readable? Properly named?
3. **Error Handling** — All exceptions mapped? All states handled in UI?
4. **Performance** — Const constructors? Builder lists? No unnecessary rebuilds?
5. **Security** — Tokens secure? No hardcoded secrets? Input validated?
6. **Testing** — Unit tests for business logic? Widget tests for UI?
7. **Accessibility** — Semantics? Touch targets? Contrast?
8. **Documentation** — Public APIs documented? Complex logic explained?
9. **👑 Principal Engineer Review** — Does code align with PRD? Any overengineering? Is technical debt minimized? Will this scale to 100k DAU?

## Master Checklist

### 👑 Principal Engineer & Product Alignment
- [ ] Code directly serves the Product Requirements Document (`.ai/PRODUCT_REQUIREMENTS.md`)
- [ ] Rich Domain Models used only when business rules/transitions exist (no overengineered DTOs)
- [ ] Zero overengineering or speculative complexity (YAGNI & KISS respected)
- [ ] Technical debt explicitly documented in `.ai/AGENTS_MEMORY.md` if shortcuts taken
- [ ] Scalability verified: Database queries and state trees scale to 100,000+ DAU without rewriting

### Architecture
- [ ] Feature-first organization
- [ ] Dependency flow: Presentation → Domain → Data
- [ ] Domain has zero Flutter imports
- [ ] Repository interfaces in Domain, implementations in Data
- [ ] DTOs confined to Data layer
- [ ] UseCases for business logic (not in widgets/controllers)

### Code Quality
- [ ] Follows Dart style guide (`dart format`)
- [ ] Zero `dart analyze` warnings
- [ ] No `dynamic` types without justification
- [ ] Meaningful variable/function/class names
- [ ] No magic numbers (use constants)
- [ ] No code duplication
- [ ] Functions ≤ 30 lines (guideline)
- [ ] Classes have single responsibility

### Error Handling
- [ ] Sealed failure classes for typed errors
- [ ] Repository returns Result, never throws
- [ ] UI handles loading, error, empty, data states
- [ ] Global error handler configured
- [ ] No silently swallowed exceptions

### Performance
- [ ] `const` constructors used everywhere possible
- [ ] Lists use `.builder` constructors
- [ ] Consumer widgets extracted for minimal rebuilds
- [ ] Images cached with size constraints
- [ ] No Opacity widget (use color alpha)

### Security
- [ ] Tokens in flutter_secure_storage
- [ ] No hardcoded secrets
- [ ] No sensitive data in logs
- [ ] HTTPS only

### Testing
- [ ] UseCases have unit tests
- [ ] Critical UI has widget tests
- [ ] Mocks use mocktail
- [ ] Tests follow AAA pattern

### Naming
- [ ] Files: snake_case
- [ ] Classes: PascalCase
- [ ] Variables: camelCase
- [ ] Entities: bare name (User, not UserEntity)
- [ ] DTOs: NameDto
- [ ] Failures: sealed FeatureFailure

## Related Skills

- `flutter-clean-architecture` — Architecture rules
- `flutter-performance` — Performance profiling
- `flutter-security` — Security audit
- `flutter-unit-testing` — Test patterns

## Workflow Steps

### Step 1: Automated Verification
Before manual architectural review, ensure basic automated quality gates pass:
- Run `dart analyze` — must return zero warnings or informational notices
- Run `dart format --output=none --set-exit-if-changed .` — code must be formatted
- Run `flutter test` — all existing unit and widget tests must pass
- Run `dart run scripts/verify_architecture.dart` — must return zero domain layer violations (no Flutter or state management imports in `domain/`)

### Step 2: Architecture & Boundary Review
Check layer separation against `flutter-clean-architecture`:
- [ ] Feature files are placed inside `lib/features/<name>/{presentation,domain,data}/`
- [ ] **Domain Layer:** Contains ZERO Flutter imports or external package dependencies (no Dio, Hive, JSON annotations)
- [ ] **Data Layer:** DTOs are isolated here; mapper functions explicitly convert DTOs to Entities before returning from repositories
- [ ] **Presentation Layer:** Widgets only talk to State Holders (Notifiers / Blocs / Cubits / Controllers) or UseCases (never directly to data sources or repositories)

### Step 3: State Management Review
Check state modeling against project matrix (`flutter-riverpod`, `flutter-bloc`, `flutter-cubit`, or `flutter-getx`):
- [ ] No raw state mutation or scattered `Get.put()` calls in UI widget tree
- [ ] State is managed cleanly via `@riverpod` / `Bloc` / `Cubit` / `GetxController`
- [ ] UI handles all async states (loading, error, empty, data)
- [ ] State objects are immutable (using `freezed` or Dart 3.12 sealed classes)

### Step 4: UI & Responsive Review
Check widget structure against `flutter-ui-engineering` and `flutter-responsive-design`:
- [ ] Build methods are concise (<100 lines); large widgets are extracted into private or reusable `StatelessWidget` classes
- [ ] No hardcoded spacing or colors (uses design system constants and `Theme.of(context).colorScheme`)
- [ ] Lists use `ListView.builder` or `SliverList.builder` instead of instantiating all children upfront
- [ ] Interactive elements have `Semantics` labels and 48x48 minimum touch targets

### Step 5: Security & Error Handling Review
Check against `flutter-security` and `flutter-error-handling`:
- [ ] No raw `try/catch` blocks in UI widgets; exceptions are caught in repositories and mapped to sealed `Failure` classes
- [ ] Tokens and secrets are stored in `flutter_secure_storage` or obfuscated via `envied`
- [ ] No sensitive user PII, passwords, or tokens in console logs

### Step 6: Test Coverage Review
Check against `flutter-unit-testing`:
- [ ] Domain logic (UseCases) includes unit tests verifying success and failure paths
- [ ] Repositories include unit tests with mocked datasources
- [ ] New interactive UI components include basic widget tests

## Review Output Template

When reporting review findings, format the output as follows:

```markdown
## Code Review Summary: [Feature/PR Name]
**Status:** ❌ Request Changes / ⚠️ Approved with Suggestions / ✅ Approved

### 🔴 Critical Issues (Must Fix)
- [Architecture] `lib/features/auth/domain/entities/user.dart` imports `package:flutter/material.dart`. Remove Flutter dependencies from domain layer.
- [Error Handling] Raw `DioException` thrown from repository in `user_repository_impl.dart:L42`. Map to sealed `UserFailure`.

### 🟡 Suggestions (Should Fix)
- [UI] In `profile_page.dart:L85`, extract the heavy 120-line profile header column into a separate `_ProfileHeader` widget to minimize rebuilds.

### 🟢 Positive Observations
- Excellent use of Dart 3.12 pattern matching for error handling in the UI!
```

## Related Skills

- `flutter-code-review` — Detailed quality checklists
- `flutter-clean-architecture` — Architectural rules
- `flutter-security` — Security audit standards

