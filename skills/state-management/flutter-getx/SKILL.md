---
name: flutter-getx
description: >
  Use this skill when maintaining, extending, reviewing, or debugging existing
  Flutter applications built with GetX. Applies GetX in a disciplined, scalable
  manner while preserving Clean Architecture and SOLID. Provides migration
  guidance toward Riverpod for new projects. Do not use for new projects where
  Riverpod is recommended (use flutter-riverpod). Do not use for Bloc (use
  flutter-bloc).
triggers:
  - "Maintain or extend GetX reactive state management"
  - "Create GetxController with reactive .obs variables"
  - "Set up GetX Bindings"
negative_triggers:
  - "New project architecture (prefer Riverpod/Bloc)"
  - "Pure Clean Architecture domain layers"
---

# Flutter GetX Expert

## Purpose

Maintain and evolve GetX-based Flutter applications with disciplined architecture. GetX is a tool — not the architecture. Clean Architecture defines the project; GetX manages state, navigation, and DI only.

## Scope

**Covers:** GetX controllers, bindings, state management, navigation, DI, migration strategy, performance, testing.

**Does not cover:** New project architecture (use Riverpod), Bloc patterns.

## Technology Context

- GetX for legacy project maintenance
- Clean Architecture integration
- Migration path toward Riverpod 3.x for new features

## Rules

### Controller Rules

Controllers coordinate UI state. They are NOT repositories, services, or business logic.

```dart
// Correct — Controller calls UseCase
class LoginController extends GetxController {
  LoginController(this._loginUseCase);
  final LoginUseCase _loginUseCase;

  final _state = Rx<LoginState>(const LoginState());
  LoginState get state => _state.value;

  Future<void> login(String email, String password) async {
    _state.value = state.copyWith(isLoading: true);
    final result = await _loginUseCase(email: email, password: password);
    result.when(
      success: (user) => _state.value = state.copyWith(isLoading: false, user: user),
      failure: (f) => _state.value = state.copyWith(isLoading: false, failure: f),
    );
  }
}
```

- Maximum ~200 lines per controller
- One controller per feature
- Always use Bindings for DI, never `Get.put()` scattered throughout the app

### Architecture Flow

```
Widget → Controller → UseCase → Repository → Datasource → API
```

Never: Controller → API (skip domain) or Widget → API.

### Migration Strategy

When migrating from legacy GetX:
1. Move business logic to Use Cases
2. Move API logic to Repositories
3. Keep Controllers lightweight
4. Replace global dependencies gradually
5. Refactor feature by feature — avoid big-bang rewrites
6. New features should use Riverpod

### Performance

- Use `GetBuilder` for simple rebuilds (no reactive streams)
- Use `Obx` only where reactivity is required
- Avoid wrapping entire pages in `Obx`
- Dispose workers, streams, and controllers properly

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Business logic in Controller | Move to UseCase |
| API calls in Controller | Use Repository → Datasource |
| `Get.find()` everywhere | Use Bindings for centralized DI |
| Huge Controllers (500+ lines) | Split by responsibility |
| Static Controllers | Proper lifecycle management |
| Navigation mixed with business logic | Separate concerns |

## Related Skills

- `flutter-riverpod` — Recommended for new projects/features
- `flutter-clean-architecture` — Architecture that outlasts any state manager
- `flutter-refactoring` — Safe migration patterns
