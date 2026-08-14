---
name: flutter-firebase
description: >
  Use this skill when integrating Firebase services into Flutter applications.
  Covers Authentication, Cloud Firestore, Cloud Storage, Cloud Messaging (FCM),
  Crashlytics, Analytics, and Remote Config with Clean Architecture integration.
  Do not use for Supabase (use flutter-supabase) or REST APIs (use
  flutter-api-integration).
triggers:
  - "Integrate Firebase Auth, Firestore, Storage, or FCM"
  - "Set up Crashlytics, Analytics, or Remote Config"
  - "Wire Firebase data sources to Clean Architecture"
negative_triggers:
  - "Supabase database"
  - "REST API integration"
---

# Flutter Firebase Integration

## Purpose

Integrate Firebase services following Clean Architecture boundaries. Firebase is an infrastructure detail — it belongs in the Data layer only.

## Rules

### Architecture Integration

Firebase services are Data layer dependencies. Never import Firebase in Domain or Presentation.

```
Domain: abstract class AuthRepository
Data: class FirebaseAuthRepositoryImpl implements AuthRepository
```

### Firebase Auth

```dart
class FirebaseAuthDatasource {
  FirebaseAuthDatasource(this._auth);
  final FirebaseAuth _auth;

  Future<UserDto> signInWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email, password: password,
    );
    return UserDto.fromFirebaseUser(credential.user!);
  }
}
```

### Cloud Firestore

- Use typed converters for Firestore documents
- Add indexes for queries used in production
- Enable offline persistence
- Paginate queries with `startAfterDocument`
- Never expose `DocumentSnapshot` outside Data layer

### Cloud Messaging (FCM)

- Request permission early with clear explanation
- Handle foreground and background messages
- Deep link from notifications using go_router
- Test on physical devices (not emulators)

### Crashlytics

```dart
void main() {
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const App());
}
```

### Security Rules

- Never use test/open rules in production
- Apply least-privilege principles
- Validate data server-side (Security Rules + Cloud Functions)

## Related Skills

- `flutter-clean-architecture` — Data layer placement
- `flutter-security` — Auth token management
- `flutter-error-handling` — Firebase exception mapping

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
