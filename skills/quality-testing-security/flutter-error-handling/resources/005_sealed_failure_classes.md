# [ADR-005] Sealed Failure Classes & Result Pattern for Error Handling

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Throwing unhandled exceptions across architectural boundaries leads to fragile apps, mysterious runtime crashes, and generic "An error occurred" messages shown to users. When repositories throw raw exceptions (`Exception`, `DioException`, `HiveError`), presentation logic is forced to write verbose, error-prone `try/catch` blocks without knowing all possible failure modes.

---

## Decision Drivers

- Must eliminate runtime crashes caused by unhandled exceptions escaping data layers.
- Need compile-time verification that UI screens handle all possible error states exhaustively.
- Must provide localized, user-friendly error messages decoupled from raw technical stack traces.
- Need type-safe return types from domain repositories (`Result<T, Failure>`).

---

## Considered Options

1. **Sealed Failure Classes + Result Pattern (Chosen):** Dart 3.12+ sealed hierarchies for domain failures returned via explicit `Result<S, F>` container types.
2. **fpdart / dartz (`Either<L, R>`):** Functional programming libraries providing monadic error handling.
3. **Raw Exceptions + `try/catch`:** Traditional imperative exception throwing across layers.

---

## Decision Outcome

Chosen option: **Sealed Failure Classes + Result Pattern**, because Dart 3.12+ pattern matching (`switch` expressions) enables exhaustive compile-time checking without the heavy functional programming boilerplate of external libraries like `fpdart`.

### Positive Consequences

- **Exhaustive Pattern Matching:** The compiler enforces that every specific failure case (`NetworkFailure`, `ServerFailure`, `UnauthorizedFailure`) is handled in the UI or Notifier.
- **Zero Thrown Exceptions:** Repositories guarantee a safe return value, dramatically stabilizing application runtime flows.
- **Clean Separation:** Technical exceptions are converted into business-meaningful failures at the data/domain boundary.

### Negative Consequences / Trade-offs

- **Explicit Return Wrapping:** Requires wrapping successful repository returns in `Success(data)` and errors in `Failure(f)`.

---

## Validation & Compliance

- **How to verify compliance:** Code reviews verify that repository interface methods return `Result<T, Failure>` and never declare `throws` documentation or allow exceptions to bubble up.
- **Relevant Skills:** `flutter-error-handling`, `flutter-clean-architecture`
