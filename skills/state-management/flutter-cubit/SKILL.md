---
name: flutter-cubit
description: >
  Use this skill when implementing state management with Cubit (from the
  flutter_bloc package) in a Flutter application. Covers method-driven state
  emissions, immutable state modeling with freezed, async error handling, and
  clean integration with Clean Architecture UseCases and Repositories. Do not
  use for event-driven Bloc (use flutter-bloc) or Riverpod (use
  flutter-riverpod).
triggers:
  - "Implement state management using Cubit"
  - "Design method-driven Cubit state emission"
  - "Emit immutable states using freezed"
negative_triggers:
  - "Event-driven Bloc"
  - "Riverpod code generation"
---

# Flutter Cubit State Management

## Purpose

Implement simplified, method-driven state transitions using Cubit (part of `flutter_bloc`), ensuring strict immutability, clean error mapping, and separation from UI presentation logic. Cubit is the lightweight choice when event-driven traceability of Bloc is not required.

## Scope

**Covers:** Cubit vs Bloc selection decision, immutable state modeling with freezed, async error handling, UseCase integration, DI via BlocProvider/get_it, UI integration with BlocBuilder/BlocConsumer/BlocListener.

**Does not cover:** Event-driven Bloc with event transformers (use `flutter-bloc`), Riverpod providers (use `flutter-riverpod`), GetX reactive state (use `flutter-getx`).

## Technology Context

- `flutter_bloc` 9.x (Cubit is part of `flutter_bloc`)
- `freezed` for immutable state modeling and sealed class unions
- `get_it` + `injectable` for dependency injection
- Dart 3.12+ sealed classes and pattern matching
- `bloc_test` for assertion-based unit testing

### 1. When to Choose Cubit vs. Bloc
- **Use Cubit:** When UI actions map directly to single asynchronous or synchronous operations (e.g., `login(email, pass)`, `fetchUser(id)`, `toggleTheme()`).
- **Use Bloc:** When you need event transformations (debounce, throttle, switchMap), event tracing, or multi-step wizard state machines.

### 2. Immutable State Modeling with Freezed
Always model Cubit state using `freezed` sealed classes or Dart 3 sealed hierarchies representing all UI states (loading, loaded, error, empty):

```dart
// features/user/presentation/cubits/user_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_state.freezed.dart';

@freezed
sealed class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(List<User> users) = _Loaded;
  const factory UserState.error(String message) = _Error;
}
```

### 3. Cubit Implementation
Never execute API or database calls directly inside the Cubit. Always delegate to injected domain UseCases or Repositories:

```dart
// features/user/presentation/cubits/user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._getUsersUseCase) : super(const UserState.initial());

  final GetUsersUseCase _getUsersUseCase;

  Future<void> loadUsers({bool forceRefresh = false}) async {
    emit(const UserState.loading());

    final result = await _getUsersUseCase(forceRefresh: forceRefresh);

    result.when(
      success: (users) {
        if (users.isEmpty) {
          emit(const UserState.loaded([]));
        } else {
          emit(UserState.loaded(users));
        }
      },
      failure: (failure) => emit(UserState.error(failure.userMessage)),
    );
  }
}
```

### 4. Dependency Injection & UI Integration
Provide the Cubit using `BlocProvider` and consume it using `BlocBuilder` or `BlocConsumer`:

```dart
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>()..loadUsers(),
      child: const _UserView(),
    );
  }
}

class _UserView extends StatelessWidget {
  const _UserView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          state.mapOrNull(
            error: (s) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.message)),
            ),
          );
        },
        builder: (context, state) => state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          loaded: (users) => ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) => Text(users[index].name),
          ),
          error: (msg) => Center(child: Text(msg)),
        ),
      ),
    );
  }
}
```

### 5. Best Practices
- Never call `emit()` after the Cubit is closed (use `if (isClosed) return;` across long async delays).
- Use `BlocListener` for one-off side effects (navigation, snackbars, dialogs) and `BlocBuilder` for rebuilding widget trees.
- Never call APIs or databases directly inside the Cubit — always delegate to injected UseCases.
- Prefer `BlocConsumer` only when both state rendering and side-effect listening are required in the same widget.

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Calling `Dio()` or repository directly in Cubit | Always delegate through injected UseCase |
| Mutable state classes | Use `freezed` sealed unions (immutable) |
| Missing `initial` state handling in UI | Always handle all states including `initial()` |
| `emit()` without `isClosed` check | Add guard: `if (isClosed) return;` |
| Mixing business logic in Widget | Move all logic to Cubit methods |
| Using Bloc when Cubit suffices | Cubit is simpler; only use Bloc for debounce/transformers |

## Checklist

- [ ] Cubit vs Bloc decision justified (no event transformers needed → use Cubit)
- [ ] State modeled with `freezed` sealed unions (all states: initial, loading, loaded, error)
- [ ] All states handled exhaustively in UI (`BlocBuilder` / `BlocConsumer`)
- [ ] Side effects use `BlocListener` (navigation, snackbars) not `BlocBuilder`
- [ ] Business logic delegated to injected UseCases (not direct API calls)
- [ ] `isClosed` checked before `emit()` in long async operations
- [ ] Tests use `bloc_test` with explicit `expect` assertions
- [ ] Cubit provided via `BlocProvider` (not instantiated in widget)

## Related Skills

- `flutter-bloc` — Event-driven alternative for complex flows with transformers
- `flutter-riverpod` — Code-generation-based alternative for new projects
- `flutter-clean-architecture` — Layer boundaries (Cubit lives in Presentation)
- `flutter-dependency-injection` — Providing Cubits via get_it / BlocProvider
- `flutter-error-handling` — Failure modeling for Cubit error states
- `flutter-unit-testing` — Testing Cubits with bloc_test
