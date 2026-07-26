---
name: flutter-error-handling
description: >
  Use this skill when designing, implementing, or reviewing error handling
  strategies in Flutter. Covers typed failure modeling with sealed classes,
  Result/Either patterns, exception-to-failure mapping, error propagation across
  Clean Architecture layers, user-facing error messages, and global error
  handling. Do not use for performance debugging (use flutter-debugging) or
  logging specifics (use flutter-logging).
triggers:
  - "Design sealed failure class hierarchy for typed errors"
  - "Map exceptions to domain failures across layers"
  - "Handle error states in UI with AsyncValue / pattern matching"
negative_triggers:
  - "Performance profiling"
  - "Logging configuration"
---

# Flutter Error Handling

## Purpose

Design a robust, type-safe error handling system that converts raw exceptions into domain-specific failures, propagates them cleanly across architecture layers, and presents meaningful messages to users.

## Scope

**Covers:** Sealed failure classes, Result pattern, exception mapping, error propagation, global error handling, user-facing messages, crash reporting integration.

## Technology Context

- Dart 3.12+ sealed classes and pattern matching
- Clean Architecture error flow: Exception → Datasource → Repository → Failure → UseCase → State → UI

## Rules

### Typed Failures with Sealed Classes

```dart
// Base failure for a feature
sealed class AuthFailure {
  const AuthFailure();

  String get userMessage => switch (this) {
    InvalidCredentials() => 'Invalid email or password',
    AccountLocked(:final retryAfter) =>
      'Account locked. Try again in ${retryAfter.inMinutes} minutes',
    NetworkError() => 'No internet connection. Check your network.',
    ServerError(:final code) => 'Server error ($code). Please try later.',
    UnknownError() => 'Something went wrong. Please try again.',
  };
}

final class InvalidCredentials extends AuthFailure { const InvalidCredentials(); }
final class AccountLocked extends AuthFailure {
  const AccountLocked(this.retryAfter);
  final Duration retryAfter;
}
final class NetworkError extends AuthFailure { const NetworkError(); }
final class ServerError extends AuthFailure {
  const ServerError(this.code);
  final int code;
}
final class UnknownError extends AuthFailure { const UnknownError(); }
```

### Result Pattern

```dart
// Simple Result type (or use package:result_type)
sealed class Result<S, F> {
  const Result();
}
final class Success<S, F> extends Result<S, F> {
  const Success(this.value);
  final S value;
}
final class Failure<S, F> extends Result<S, F> {
  const Failure(this.error);
  final F error;
}

// Repository returns Result, never throws
abstract class AuthRepository {
  Future<Result<User, AuthFailure>> login({
    required String email,
    required String password,
  });
}
```

### Exception Mapping at Repository Boundary

```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Result<User, AuthFailure>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _datasource.login(email: email, password: password);
      return Success(dto.toEntity());
    } on DioException catch (e) {
      return Failure(_mapDioException(e));
    } on FormatException {
      return const Failure(UnknownError());
    } catch (_) {
      return const Failure(UnknownError());
    }
  }

  AuthFailure _mapDioException(DioException e) => switch (e.response?.statusCode) {
    401 => const InvalidCredentials(),
    423 => AccountLocked(Duration(seconds:
      int.tryParse(e.response?.headers.value('retry-after') ?? '300') ?? 300)),
    >= 500 => ServerError(e.response!.statusCode!),
    _ => switch (e.type) {
      DioExceptionType.connectionError => const NetworkError(),
      DioExceptionType.connectionTimeout => const NetworkError(),
      _ => const UnknownError(),
    },
  };
}
```

### Error Propagation Flow

```
API Exception → Datasource → Repository → Failure (sealed class)
                                              ↓
                                          UseCase → returns Result<T, Failure>
                                              ↓
                                          Notifier → sets AsyncError or state.failure
                                              ↓
                                          UI → shows userMessage
```

### UI Error Handling

```dart
// Pattern match on failure in the UI
ref.watch(loginProvider).when(
  data: (_) => const HomePage(),
  loading: () => const LoadingIndicator(),
  error: (error, _) => ErrorView(
    message: switch (error) {
      AuthFailure failure => failure.userMessage,
      _ => 'An unexpected error occurred',
    },
    onRetry: () => ref.invalidate(loginProvider),
  ),
);
```

### Global Error Handling

```dart
// In main.dart — catch unhandled errors
void main() {
  FlutterError.onError = (details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const App());
}
```

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Catching and swallowing exceptions | Map to typed Failure |
| Raw `Exception` strings in UI | Sealed class with `userMessage` |
| `try/catch` in Widget | Handle in Repository, propagate via state |
| Generic `catch (e)` without mapping | Map every exception type |
| Throwing exceptions from Repository | Return `Result<T, Failure>` |

## Checklist

- [ ] Every feature has a sealed Failure class
- [ ] Repositories return Result<T, Failure>, never throw
- [ ] All exceptions mapped at the Repository boundary
- [ ] User-facing messages defined in Failure class
- [ ] UI handles error state with retry option
- [ ] Global error handler configured (Crashlytics)
- [ ] No exceptions swallowed silently

## Related Skills

- `flutter-clean-architecture` — Error flow across layers
- `flutter-api-integration` — DioException mapping
- `flutter-riverpod` — AsyncValue error handling
- `flutter-logging` — Error logging practices
