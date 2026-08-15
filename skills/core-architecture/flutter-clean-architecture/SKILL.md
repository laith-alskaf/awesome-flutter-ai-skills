---
name: flutter-clean-architecture
description: >
  Use this skill when designing, implementing, reviewing, or refactoring Flutter
  application architecture. Enforces Clean Architecture with feature-first
  organization, strict dependency boundaries, SOLID principles, and
  production-grade layer separation (Presentation → Domain → Data). Do not use
  for UI widget implementation details (use flutter-ui-engineering), state
  management specifics (use flutter-riverpod, flutter-bloc, flutter-cubit, or
  flutter-getx), or API networking details (use flutter-api-integration).
triggers:
  - "Design or review Clean Architecture boundaries"
  - "Separate presentation, domain, and data layers"
  - "Enforce zero Flutter imports in domain layer"
negative_triggers:
  - "UI widget styling only"
  - "State management library setup"
  - "API networking details"
---

# Flutter Clean Architecture

## Purpose

Define and enforce a scalable, testable, maintainable Flutter application architecture using Clean Architecture with feature-first organization. Every architectural decision must improve long-term project health.

## Scope

**Covers:** Layer design, dependency direction, feature organization, entity design, repository interfaces, use case patterns, DTO/mapper boundaries, shared code rules, folder structure.

**Does not cover:** Specific state management implementation, UI widget design, API client configuration, testing implementation.

## Technology Context

- Flutter 3.44.x Stable / Dart 3.12.x
- Impeller rendering engine (default)
- SwiftPM for iOS dependencies (default)
- Dart sealed classes and pattern matching for error modeling
- Private named parameters for cleaner constructors

## Rules

### Feature-First Organization

Organize by business capability, never by technical type.

```
# Correct — Feature-First
lib/
  features/
    authentication/
    home/
    profile/
    settings/

# Wrong — Layer-First
lib/
  screens/
  widgets/
  providers/
  services/
  models/
```

### Three-Layer Architecture

Every feature contains exactly three layers. Dependencies always point inward.

```
Presentation  →  Domain  →  Data
   (UI)        (Business)  (Infrastructure)
```

**Allowed:** Presentation → Domain, Data → Domain (implements interfaces).

**Forbidden:** Presentation → Data, Domain → Flutter, Domain → Dio/Firebase.

### Feature Folder Structure

```
features/
  authentication/
    presentation/
      pages/
      widgets/
      state/            # State holders (Notifiers / Blocs / Cubits / Controllers)
    domain/
      entities/
      repositories/     # Abstract interfaces only
      usecases/
      failures/         # Sealed failure classes
    data/
      datasources/
      models/           # DTOs with JSON annotations
      repositories/     # Concrete implementations
      mappers/
```

### Domain Layer Rules

The domain layer is the heart of the application. It must:

> [!CAUTION]
> **ABSOLUTE DOMAIN ISOLATION RULE (0% State & UI Imports):** The Domain layer MUST remain 100% pure Dart 3.12. You are strictly forbidden from importing `@riverpod`, `flutter_riverpod`, `flutter_bloc`, `bloc`, `get`, `get_it`, `injectable`, `dio`, `drift`, `hive`, or any Flutter UI library (`package:flutter/material.dart`, `dart:ui`). All state management providers/controllers must live in Presentation or DI containers, injecting domain repositories into UseCases via interfaces. Use `dart run .agents/tools/verify_architecture.dart` to verify.

- Contain zero Flutter or State Management library imports
- Compile independently of any framework
- Define entities as pure, immutable Dart objects
- Define repository interfaces (abstract classes)
- Contain all business rules in Use Cases
- Model failures using sealed classes

```dart
// Domain Entity — Pure Dart, no annotations
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;
}

// Domain Failure — Sealed class with pattern matching
sealed class AuthFailure {
  const AuthFailure();
}
final class InvalidCredentials extends AuthFailure {
  const InvalidCredentials();
}
final class NetworkError extends AuthFailure {
  const NetworkError(this.message);
  final String message;
}
final class ServerError extends AuthFailure {
  const ServerError(this.code);
  final int code;
}

// Domain Repository — Abstract interface
abstract class AuthRepository {
  Future<Result<User, AuthFailure>> login({
    required String email,
    required String password,
  });
  Future<Result<void, AuthFailure>> logout();
}

// Domain Use Case — Single business action
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<User, AuthFailure>> call({
    required String email,
    required String password,
  }) => _repository.login(email: email, password: password);
}
```

### Data Layer Rules

The data layer implements domain interfaces and handles external communication.

```dart
// DTO — JSON serializable, lives only in data layer
@JsonSerializable()
class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

// Mapper — Converts DTO ↔ Entity
extension UserDtoMapper on UserDto {
  User toEntity() => User(id: id, name: name, email: email);
}

// Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDatasource);
  final AuthRemoteDatasource _remoteDatasource;

  @override
  Future<Result<User, AuthFailure>> login({
    required String email,
    required String password,
  }) async {
    try {
      final dto = await _remoteDatasource.login(email: email, password: password);
      return Result.success(dto.toEntity());
    } on DioException catch (e) {
      return Result.failure(_mapException(e));
    }
  }
}
```

### Presentation Layer Rules

- Communicates only with Use Cases or State Holders (Notifiers / Blocs / Cubits / Controllers)
- Never calls APIs, accesses databases, parses JSON, or executes SQL
- Contains UI widgets, screens, and state holders

### Shared Code Rules

Shared code belongs only if used by 2+ features.

```
# Allowed
core/network/
core/errors/
core/theme/
core/utils/
shared/widgets/
shared/extensions/

# Forbidden — Business logic is not shared
shared/profile/
shared/orders/
shared/payment/
```

### Dependency Injection

Always inject dependencies. Never instantiate manually.

```dart
// Wrong
final api = Dio();

// Correct — Constructor injection
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);
  final AuthRemoteDatasource _datasource;
}
```

### Entity Rules

- Immutable (all fields `final`)
- No framework imports
- No JSON annotations
- No serialization logic
- Pure business meaning

### DTO Rules

- Exist only inside the Data layer
- Handle JSON serialization/deserialization
- Map to/from Entities at the Repository boundary
- Never exposed outside the Data layer

## Anti-Patterns

| Anti-Pattern | Why It's Harmful |
|---|---|
| Business logic in Widgets | Untestable, violates SRP |
| DTO exposed to UI | Couples UI to API contract |
| Entity with @JsonSerializable | Couples domain to serialization |
| Flutter imports in Domain | Breaks domain independence |
| Repository calling Repository | Creates hidden coupling |
| God Repository/Service | Violates SRP, becomes unmaintainable |
| Presentation → Data (skip Domain) | Breaks dependency direction |
| Circular dependencies | Creates untestable, fragile code |

## Checklist

- [ ] Feature-first folder organization
- [ ] Clean dependency flow (Presentation → Domain → Data)
- [ ] Domain layer has zero Flutter imports
- [ ] All entities are immutable, pure Dart
- [ ] Repository interfaces in Domain, implementations in Data
- [ ] DTOs never leave the Data layer
- [ ] Mapper at Repository boundary
- [ ] Typed Failures (sealed classes), not raw exceptions
- [ ] Dependency injection for all external services
- [ ] Each Use Case handles exactly one business action
- [ ] No business logic in Widgets
- [ ] Shared code only for cross-feature concerns

## Related Skills

- `flutter-riverpod` — Riverpod state management integration
- `flutter-bloc` — Bloc event-driven state management integration
- `flutter-cubit` — Cubit method-driven state management integration
- `flutter-getx` — GetX reactive state management integration
- `flutter-api-integration` — Data layer networking implementation
- `flutter-ui-engineering` — Presentation layer widget design
- `flutter-feature-first` — Detailed feature organization patterns
- `flutter-repository-pattern` — Repository interface and implementation details
- `flutter-dependency-injection` — DI setup with Riverpod and get_it
- `flutter-error-handling` — Failure modeling and propagation patterns
