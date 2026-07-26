---
name: flutter-local-database
description: >
  Use this skill when implementing local data persistence in Flutter. Covers Drift
  (type-safe SQL), sqflite, Hive, SharedPreferences, and database selection
  criteria. Do not use for remote API networking (use flutter-api-integration) or
  secure credential storage (use flutter-security).
triggers:
  - "Implement local database persistence with Drift / Hive / sqflite"
  - "Write type-safe SQL tables and offline cache repositories"
  - "Manage database migrations and secure storage"
negative_triggers:
  - "Remote API networking"
  - "Secure credential storage"
---

# Flutter Local Database

## Purpose

Select and implement the right local storage solution based on data complexity, query requirements, and performance needs.

## Rules

### Selection Guide

| Need | Solution | When to Use |
|---|---|---|
| Type-safe SQL, complex queries, migrations | **Drift** | Structured data, relationships, offline-first |
| Simple SQL, direct control | **sqflite** | Legacy projects, simple queries |
| Key-value, fast reads | **Hive** | Caching, user preferences, small data |
| Simple key-value | **SharedPreferences** | App settings, flags, non-sensitive config |
| Encrypted key-value | **flutter_secure_storage** | Tokens, passwords, secrets |

### Drift (Recommended for Structured Data)

```dart
@DriftDatabase(tables: [Users, Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.addColumn(users, users.avatarUrl);
    },
  );
}
```

### Architecture Integration

Local databases are Data layer datasources. Never import database packages in Domain.

```dart
// Domain — defines interface
abstract class TaskRepository {
  Future<List<Task>> getLocalTasks();
}

// Data — implements with Drift
class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._localDatasource);
  final TaskLocalDatasource _localDatasource;
}
```

### Offline-First Strategy

1. Always read from local cache first
2. Fetch from remote in background
3. Update local cache on successful fetch
4. Handle conflicts with timestamp-based resolution
5. Queue offline writes for later sync

## Related Skills

- `flutter-clean-architecture` — Data layer placement
- `flutter-api-integration` — Remote data synchronization
- `flutter-security` — Encrypted storage for secrets
