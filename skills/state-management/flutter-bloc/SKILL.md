---
name: flutter-bloc
description: >
  Use this skill when designing, implementing, reviewing, or debugging state
  management using Bloc or Cubit in Flutter. Covers Cubit vs Bloc decision tree,
  event design, state design with freezed, BlocObserver, HydratedBloc, bloc_test,
  pagination, search, forms, and Clean Architecture integration. Do not use for
  Riverpod (use flutter-riverpod) or GetX (use flutter-getx).
triggers:
  - "Implement state management using Bloc 9.x"
  - "Design event-driven Bloc with freezed states"
  - "Set up BlocObserver or HydratedBloc"
negative_triggers:
  - "Use Riverpod providers"
  - "Use GetX reactive controllers"
---

# Flutter Bloc Expert

## Purpose

Design predictable, testable state management using the Bloc pattern. Bloc enforces unidirectional data flow: Events in → States out. Every state transition is traceable and testable.

## Scope

**Covers:** Cubit vs Bloc selection, event/state design, freezed integration, BlocObserver, HydratedBloc, testing with bloc_test, pagination, search, forms, error handling.

**Does not cover:** Riverpod patterns, GetX patterns.

## Technology Context

- `flutter_bloc` 9.x with `bloc` 9.x
- `freezed` for immutable state modeling
- `bloc_test` for assertion-based testing
- Dart 3.12+ sealed classes and pattern matching

## Rules

### Cubit vs Bloc Decision Tree

```
Does the feature have complex event-driven logic?
  ↓ YES → Use Bloc (events provide traceability)
  ↓ NO → Use Cubit (simpler, less boilerplate)

Does the feature need event transformers (debounce, throttle)?
  ↓ YES → Use Bloc
  ↓ NO → Cubit is sufficient
```

**Use Cubit for:** Simple CRUD, toggles, counters, forms.
**Use Bloc for:** Complex flows, search with debounce, pagination, multi-step processes.

### State Design with Freezed

```dart
@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(List<User> users) = _Loaded;
  const factory UserState.error(String message) = _Error;
}
```

### Event Design

```dart
@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.loadUsers() = _LoadUsers;
  const factory UserEvent.deleteUser(String id) = _DeleteUser;
  const factory UserEvent.refreshUsers() = _RefreshUsers;
  const factory UserEvent.searchUsers(String query) = _SearchUsers;
}
```

### Bloc Implementation

```dart
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._getUsersUseCase) : super(const UserState.initial()) {
    on<_LoadUsers>(_onLoadUsers);
    on<_DeleteUser>(_onDeleteUser);
    on<_SearchUsers>(_onSearchUsers,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  final GetUsersUseCase _getUsersUseCase;

  Future<void> _onLoadUsers(_LoadUsers event, Emitter<UserState> emit) async {
    emit(const UserState.loading());
    final result = await _getUsersUseCase();
    result.when(
      success: (users) => emit(UserState.loaded(users)),
      failure: (f) => emit(UserState.error(f.userMessage)),
    );
  }
}
```

### Cubit Implementation

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);
  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

### UI Integration

```dart
// Use BlocBuilder for rendering
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) => state.when(
    initial: () => const SizedBox.shrink(),
    loading: () => const LoadingIndicator(),
    loaded: (users) => UserListView(users: users),
    error: (message) => ErrorView(message: message),
  ),
)

// Use BlocListener for side effects (navigation, snackbars)
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is Authenticated) context.go('/home');
    if (state is AuthError) showSnackBar(context, state.message);
  },
)
```

### Testing with bloc_test

```dart
blocTest<UserBloc, UserState>(
  'emits [loading, loaded] when LoadUsers succeeds',
  build: () {
    when(() => mockGetUsers()).thenAnswer((_) async => Result.success(users));
    return UserBloc(mockGetUsers);
  },
  act: (bloc) => bloc.add(const UserEvent.loadUsers()),
  expect: () => [
    const UserState.loading(),
    UserState.loaded(users),
  ],
);
```

### BlocObserver for Debugging

```dart
class AppBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log('${bloc.runtimeType}: ${transition.event} → ${transition.nextState}');
  }
}
```

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Business logic in Widget | Move to Bloc/Cubit |
| Bloc calling API directly | Use Repository → UseCase |
| Mutable state classes | Use freezed unions |
| Missing state handling | Always handle all states exhaustively |
| Bloc accessing another Bloc | Use shared UseCase or repository |

## Checklist

- [ ] Cubit vs Bloc decision justified
- [ ] States modeled with freezed (immutable)
- [ ] Events modeled with freezed (if using Bloc)
- [ ] All states handled in UI (initial, loading, loaded, error)
- [ ] Side effects use BlocListener (not BlocBuilder)
- [ ] Business logic in UseCases (not in Bloc)
- [ ] Tests use bloc_test with expect assertions
- [ ] BlocObserver configured for debugging

## Related Skills

- `flutter-clean-architecture` — Architecture integration
- `flutter-error-handling` — Failure modeling
- `flutter-unit-testing` — Testing patterns
