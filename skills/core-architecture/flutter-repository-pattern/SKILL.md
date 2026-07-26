---
name: flutter-repository-pattern
description: >
  Use this skill when designing or implementing repository interfaces and concrete
  classes in Flutter following Clean Architecture. Covers abstract interfaces in
  Domain, concrete implementations in Data, data source orchestration, caching
  strategies (offline-first, write-through, read-through), and error mapping to
  typed failures. Do not use for general Clean Architecture rules (use
  flutter-clean-architecture) or API networking specifics (use
  flutter-api-integration).
triggers:
  - "Implement repository interface and concrete implementation"
  - "Orchestrate data sources and caching in repository"
  - "Map DTOs to Domain Entities at repository boundary"
negative_triggers:
  - "Direct API networking setup"
  - "UI widget state handling"
---

# Flutter Repository Pattern

## Purpose

Decouple business logic from data sources by defining clean domain contracts (interfaces) and implementing them in the data layer. Repositories orchestrate remote and local data sources, manage caching, and map raw exceptions to domain failures.

## Rules

### Interface in Domain Layer

```dart
// domain/repositories/user_repository.dart
abstract class UserRepository {
  Future<Result<User, UserFailure>> getUser(String id);
  Future<Result<List<User>, UserFailure>> getUsers({bool forceRefresh = false});
  Future<Result<void, UserFailure>> updateUser(User user);
}
```

- Abstract class only — zero implementation details
- No references to Dio, Hive, Drift, SharedPreferences, or JSON
- Returns `Result<T, Failure>` or `Either<Failure, T>`
- Accepts and returns Domain Entities (never DTOs)

### Concrete Implementation in Data Layer

```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  final UserRemoteDatasource remoteDatasource;
  final UserLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  @override
  Future<Result<User, UserFailure>> getUser(String id) async {
    try {
      if (await networkInfo.isConnected) {
        final dto = await remoteDatasource.getUser(id);
        await localDatasource.cacheUser(dto);
        return Success(dto.toEntity());
      } else {
        final localDto = await localDatasource.getUser(id);
        if (localDto != null) {
          return Success(localDto.toEntity());
        }
        return const Failure(UserFailure.offlineAndNoCache());
      }
    } on DioException catch (e) {
      return Failure(_mapDioException(e));
    } on CacheException {
      return const Failure(UserFailure.cacheError());
    } catch (_) {
      return const Failure(UserFailure.unknown());
    }
  }
}
```

### Caching Strategies

| Strategy | Behavior | When to Use |
|---|---|---|
| **Cache-First (Offline-First)** | Read local cache; if expired/missing, fetch remote & update cache. | Feed, user profile, catalog |
| **Network-First** | Try remote fetch & cache; fallback to local cache if offline. | Real-time dashboards, inventory |
| **Stale-While-Revalidate** | Return local cache immediately, fetch remote in background, emit update. | News, social media streams |
| **Write-Through** | Write to local cache and remote API simultaneously. | User preferences, cart items |

### Exception Mapping

Never let exceptions escape the repository. Catch all data source exceptions (`DioException`, `DriftWrappedException`, `HiveError`) and convert them to domain `Failure` sealed classes.

## Related Skills

- `flutter-clean-architecture` — Layer rules
- `flutter-api-integration` — Remote data source implementation
- `flutter-local-database` — Local data source implementation
- `flutter-error-handling` — Sealed failure classes and Result pattern
