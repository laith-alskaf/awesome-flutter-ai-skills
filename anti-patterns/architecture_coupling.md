# Architecture Coupling Anti-Patterns Library

This document catalogs common architectural boundary violations in Flutter projects and demonstrates how to enforce Clean Architecture separation.

---

## 1. Leaking DTOs and JSON Annotations into Domain Entities

### ❌ The Anti-Pattern
Adding `@JsonSerializable()`, `fromJson()`, or API-specific field mapping directly onto business Entities in the domain layer.
```dart
// WRONG: Domain entity depends on external serialization libraries
@JsonSerializable()
class User {
  User({required this.id, @JsonKey(name: 'first_name') required this.firstName});
  final String id;
  final String firstName;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### ⚠️ Why It's Harmful
- Couples core business logic directly to backend API naming quirks and external serialization packages.
- A change in the backend database schema forces edits to core domain entities and use cases.
- Prevents domain models from being reused across different data sources (e.g., local SQLite vs remote REST vs GraphQL).

### ✅ The Refactored Solution
Create a pure, immutable Entity in `domain/entities/`, and a separate DTO in `data/models/` with an explicit mapper:
```dart
// domain/entities/user.dart — Pure Dart, zero annotations!
class User {
  const User({required this.id, required this.firstName});
  final String id;
  final String firstName;
}

// data/models/user_dto.dart — DTO handles serialization
@JsonSerializable()
class UserDto {
  const UserDto({required this.id, @JsonKey(name: 'first_name') required this.firstName});
  final String id;
  final String firstName;
  
  User toEntity() => User(id: id, firstName: firstName);
}
```

---

## 2. Importing Flutter SDK inside Domain Layer

### ❌ The Anti-Pattern
Importing `package:flutter/material.dart`, `BuildContext`, or UI utilities into domain entities, use cases, or repository interfaces.
```dart
// WRONG: Domain layer depends on Flutter UI framework
import 'package:flutter/material.dart';

class ThemeSettings {
  final Color primaryColor;
  final TextStyle headerStyle;
}
```

### ⚠️ Why It's Harmful
- Breaks the platform-agnostic nature of the domain layer (cannot run pure Dart CLI tests or compile for alternative targets).
- Ties business rules to Flutter rendering details.

### ✅ The Refactored Solution
Model domain values using pure Dart primitives or domain-specific enums, mapping them to Flutter UI classes only in the presentation layer:
```dart
// domain/entities/theme_settings.dart
enum AppThemeMode { light, dark, system }
class ThemeSettings {
  const ThemeSettings({required this.mode, required this.primaryHexCode});
  final AppThemeMode mode;
  final String primaryHexCode;
}
```

---

## 3. Presentation Bypassing Domain to Call Data Sources

### ❌ The Anti-Pattern
Instantiating Dio, SharedPreferences, or concrete repositories directly inside a UI screen or widget.
```dart
// WRONG: UI directly instantiates data source
class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Dio().get('https://api.app.com/profile').then((res) { /* ... */ });
  }
}
```

### ⚠️ Why It's Harmful
- Destroys architectural layers; bypasses all domain validation, caching, and error mapping.
- Makes the widget completely untestable without spinning up live HTTP servers.

### ✅ The Refactored Solution
Always communicate through injected Notifiers or UseCases:
```dart
final profile = ref.watch(profileNotifierProvider);
```
