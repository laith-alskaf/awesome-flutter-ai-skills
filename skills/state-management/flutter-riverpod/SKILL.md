---
name: flutter-riverpod
description: >
  Use this skill when designing, implementing, reviewing, or debugging state
  management in Flutter using Riverpod 3.x. Covers provider selection, state
  modeling with freezed/sealed classes, async handling with AsyncValue, code
  generation with @riverpod, performance optimization, and Clean Architecture
  integration. Do not use for Bloc state management (use flutter-bloc) or GetX
  (use flutter-getx).
triggers:
  - "Implement state management using Riverpod 3.x"
  - "Create @riverpod AsyncNotifier or Provider"
  - "Handle Riverpod AsyncValue in UI"
negative_triggers:
  - "Use Bloc or Cubit"
  - "Use GetX state management"
---

# Flutter Riverpod Expert

## Purpose

Design predictable, testable, and performant state management using Riverpod 3.x with code generation, integrated within Clean Architecture.

## Scope

**Covers:** Provider types, state design, async patterns, pagination, forms, caching, performance, testing, offline support, Riverpod code generation.

**Does not cover:** Bloc/Cubit patterns, GetX patterns, UI widget design, API networking details.

## Technology Context

- Riverpod 3.x with `riverpod_generator` and `@riverpod` annotation
- `riverpod_lint` for static analysis
- `freezed` for immutable state models
- Dart 3.12+ sealed classes and pattern matching
- `AsyncValue` for async state handling

## Rules

### Provider Selection

Choose providers intentionally based on the use case.

| Use Case | Provider Type | Example |
|---|---|---|
| Configuration, repositories, services | `@riverpod` (generated) | `userRepositoryProvider` |
| Simple local UI state (toggle, tab) | `StateProvider` | `selectedTabProvider` |
| Synchronous business logic, forms | `@riverpod` Notifier | `loginFormNotifier` |
| API requests, database, auth | `@riverpod` AsyncNotifier | `userListNotifier` |
| Read-only async data, single fetch | `@riverpod` (functional) | `appConfigProvider` |
| Real-time data, Firebase, WebSocket | `StreamProvider` | `chatMessagesProvider` |

### Code Generation Pattern (Preferred)

Always use `riverpod_generator` for new code.

```dart
// Generated functional provider — read-only async data
@riverpod
Future<User> currentUser(Ref ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
}

// Generated Notifier — business logic with mutations
@riverpod
class UserList extends _$UserList {
  @override
  Future<List<User>> build() async {
    final repository = ref.watch(userRepositoryProvider);
    return repository.getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(userRepositoryProvider).getUsers());
  }

  Future<void> deleteUser(String id) async {
    await ref.read(userRepositoryProvider).deleteUser(id);
    ref.invalidateSelf();
  }
}
```

### State Design

State must be immutable. Always model all possible states.

```dart
// Using freezed for complex feature state
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isSubmitting,
    @Default(false) bool showPassword,
    String? emailError,
    String? passwordError,
    AuthFailure? failure,
  }) = _LoginState;
}

// Using sealed classes for simple discriminated states
sealed class CheckoutStatus {
  const CheckoutStatus();
}
final class CheckoutIdle extends CheckoutStatus {
  const CheckoutIdle();
}
final class CheckoutProcessing extends CheckoutStatus {
  const CheckoutProcessing();
}
final class CheckoutSuccess extends CheckoutStatus {
  const CheckoutSuccess(this.orderId);
  final String orderId;
}
final class CheckoutFailed extends CheckoutStatus {
  const CheckoutFailed(this.failure);
  final PaymentFailure failure;
}
```

### Async Handling

Always handle all AsyncValue states. Never ignore loading or error.

```dart
// In Widget — exhaustive state handling
ref.watch(userListProvider).when(
  data: (users) => UserListView(users: users),
  loading: () => const LoadingIndicator(),
  error: (error, stack) => ErrorView(
    message: error.toString(),
    onRetry: () => ref.invalidate(userListProvider),
  ),
);
```

### Feature-Scoped Providers

Every feature owns its providers. Never create global provider files.

```
features/
  authentication/
    presentation/
      notifiers/
        login_notifier.dart
        register_notifier.dart
      providers/
        auth_providers.dart     # Repository/service providers
```

### Dependency Injection via Providers

```dart
// Repository provider — injected, not instantiated
@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(
    remoteDatasource: AuthRemoteDatasource(dio),
    localDatasource: AuthLocalDatasource(secureStorage),
  );
}
```

### Performance Rules

- Use `ref.watch()` for UI rendering, `ref.listen()` for side effects
- Watch the smallest provider possible; use `select()` to filter
- Split large providers into focused ones
- Extract Consumer widgets to minimize rebuild scope
- Use `autoDispose` to prevent memory leaks
- Never watch entire repositories — watch specific data providers

### Listening for Side Effects

```dart
// Use ref.listen for navigation, snackbars, dialogs
ref.listen(loginNotifierProvider, (previous, next) {
  if (next is AsyncData) {
    context.go('/home');
  } else if (next is AsyncError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error.toString())),
    );
  }
});
```

### Refresh Strategy

```dart
// Invalidate for complete refresh (lazy re-evaluation)
ref.invalidate(userListProvider);

// Refresh for immediate execution with return value
final freshData = await ref.refresh(userListProvider.future);
```

### Testing

```dart
// Unit test with provider overrides
test('loads users successfully', () async {
  final container = ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(MockUserRepository()),
    ],
  );
  addTearDown(container.dispose);

  final users = await container.read(userListProvider.future);
  expect(users, hasLength(3));
});
```

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Business logic inside Widget | Move to Notifier → UseCase |
| `StateProvider` for business data | Use `@riverpod` Notifier |
| Global mutable state | Feature-scoped providers |
| Watching entire repository | Watch specific data providers |
| Creating providers inside widgets | Define providers at top level |
| Ignoring AsyncValue.error | Always handle all three states |
| Manual Dio() inside provider | Inject via provider chain |
| Nested AsyncValue handling | Combine providers or use select() |

## Checklist

- [ ] Correct provider type for each use case
- [ ] Code generation with `@riverpod` annotation
- [ ] Immutable state (freezed or sealed classes)
- [ ] All AsyncValue states handled (data, loading, error)
- [ ] Feature-scoped provider files
- [ ] Dependencies injected via provider chain
- [ ] `ref.watch()` for UI, `ref.listen()` for side effects
- [ ] `select()` used to minimize rebuilds
- [ ] `autoDispose` for screen-scoped providers
- [ ] `riverpod_lint` enabled in `analysis_options.yaml`
- [ ] Unit tests with `ProviderContainer` overrides

## Related Skills

- `flutter-clean-architecture` — Architecture integration
- `flutter-error-handling` — Failure modeling with AsyncValue
- `flutter-ui-engineering` — Consumer widget patterns
- `flutter-unit-testing` — Testing providers and notifiers
