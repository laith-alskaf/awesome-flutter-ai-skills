---
name: flutter-dependency-injection
description: >
  Use this skill when implementing dependency injection (DI) in Flutter
  applications. Covers multi-state management DI patterns: Riverpod (as built-in
  DI), get_it / injectable / RepositoryProvider (for Bloc / Cubit), and GetX
  Bindings. Enforces Clean Architecture dependency inversion and testing
  overrides. Do not use for state management details (use flutter-riverpod,
  flutter-bloc, flutter-cubit, or flutter-getx).
triggers:
  - "Set up dependency injection container"
  - "Configure Riverpod / get_it / injectable / GetX Bindings"
  - "Inject usecases and repositories into state holders"
negative_triggers:
  - "State management logic"
  - "Database queries"
---

# Flutter Dependency Injection

## Purpose

Decouple components through dependency injection, enabling testability, flexibility, and Clean Architecture compliance across all supported state management solutions.

## Rules

### 1. Riverpod DI Pattern (For Riverpod Projects)

With Riverpod, dependency injection is built directly into the functional provider graph:

```dart
@riverpod
Dio dio(Ref ref) => Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

@riverpod
AuthRemoteDatasource authRemoteDatasource(Ref ref) =>
    AuthRemoteDatasource(ref.watch(dioProvider));

@riverpod
AuthRepository authRepository(Ref ref) => AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
);

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));
```

### 2. get_it & RepositoryProvider (For Bloc & Cubit Projects)

When using Bloc or Cubit, register Core, Data, and Domain layers in a centralized `get_it` container, and provide Blocs/Cubits via `BlocProvider` or `RepositoryProvider`:

```dart
final sl = GetIt.instance;

void setupDI() {
  // 1. External & Core
  sl.registerLazySingleton(() => Dio(BaseOptions(baseUrl: Env.apiBaseUrl)));

  // 2. Datasources
  sl.registerLazySingleton(() => AuthRemoteDatasource(sl()));

  // 3. Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // 4. UseCases
  sl.registerFactory(() => LoginUseCase(sl()));

  // 5. Blocs / Cubits (always factory to ensure fresh state on new screens!)
  sl.registerFactory(() => AuthCubit(sl()));
}
```

In Presentation Layer:
```dart
BlocProvider(
  create: (context) => sl<AuthCubit>(),
  child: const AuthPage(),
);
```

### 3. GetX Bindings (For GetX Projects)

When using GetX, NEVER scatter raw `Get.put()` calls inside UI build methods or widget constructors. Always use centralized `Bindings`:

```dart
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRemoteDatasource(Get.find<Dio>()));
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find()));
    Get.lazyPut(() => LoginUseCase(Get.find()));
    Get.lazyPut(() => AuthController(Get.find()));
  }
}
```

### 4. General DI Rules Across All Libraries

- Always inject dependencies via constructor arguments (not property injection or method injection).
- Register abstractions (interfaces like `AuthRepository`), and resolve concrete implementations (`AuthRepositoryImpl`).
- Datasources and Repositories should be Singletons or Lazy Singletons.
- UseCases and Presentation State Holders (Notifiers / Blocs / Cubits / Controllers) should be Factories or scoped auto-disposing instances.
- Never instantiate infrastructure classes (`Dio()`, `Hive.box()`) inside UI screens or widgets.

## Related Skills

- `flutter-riverpod` — Riverpod DI and state
- `flutter-bloc` / `flutter-cubit` — BlocProvider rules
- `flutter-getx` — GetX bindings and controllers
- `flutter-clean-architecture` — Layer boundaries

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
