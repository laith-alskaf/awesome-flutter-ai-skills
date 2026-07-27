# Architecture Review Checklist

Use this checklist during code reviews, refactoring, or milestone audits to ensure strict adherence to Clean Architecture and Feature-First organization.

## 1. Feature Organization
- [ ] Code is structured by business capability in `lib/features/<name>/` (not by technical layer like `screens/` or `controllers/`).
- [ ] Features do not directly import internal presentation or data code from other features.
- [ ] Shared widgets or cross-feature logic are placed in `lib/shared/` or `lib/core/`.

## 2. Domain Layer Integrity
- [ ] Domain layer (`domain/entities`, `domain/usecases`, `domain/repositories`) has zero Flutter SDK or UI library imports.
- [ ] No serialization annotations (`@JsonSerializable`, `@freezed` JSON converters) exist on Domain Entities.
- [ ] Domain Entities are immutable (`final` fields) and implement value equality.
- [ ] Repository interfaces in `domain/repositories/` return `Result<T, Failure>` or `Either<Failure, T>`, never throwing exceptions.

## 3. Data Layer Isolation
- [ ] DTOs (`data/models/`) encapsulate all JSON serialization/deserialization logic.
- [ ] Extension mappers explicitly convert DTOs to Entities at the repository boundary before returning to domain.
- [ ] Data sources catch third-party exceptions (`DioException`, `HiveError`, `DriftException`) and repositories convert them to sealed `Failure` classes.

## 4. Presentation & State Management
- [ ] Presentation layer never directly invokes repositories or data sources; it communicates solely via Notifiers or UseCases.
- [ ] State management models all async UI states (`AsyncValue.when`: loading, error, data).
- [ ] Build methods do not contain asynchronous calls or complex business calculation loops.

## 5. Automated Verification

- [ ] Run `dart run scripts/verify_architecture.dart` — must report **zero** domain or data boundary violations.
- [ ] Run `dart analyze` — must return zero warnings, errors, or lints.
- [ ] Run `flutter test` — all unit and widget tests pass with no failures.

---

**Related Skills:** `flutter-clean-architecture` (layer rules) · `flutter-code-review` (PR review process)
**Related ADR:** `decisions/001_clean_architecture.md` (original architectural decision)
**Verification Tool:** `dart run scripts/verify_architecture.dart [path_to_project_root]`
