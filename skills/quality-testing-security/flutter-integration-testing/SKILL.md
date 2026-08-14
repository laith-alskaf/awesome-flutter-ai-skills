---
name: flutter-integration-testing
description: >
  Use this skill when implementing end-to-end (E2E) integration tests in Flutter
  using integration_test or Patrol. Covers test setup, device automation,
  interacting with real widgets, network mocking vs staging APIs, handling native
  dialogs (permissions), and CI automation. Do not use for unit testing (use
  flutter-unit-testing) or isolated widget testing (use flutter-widget-testing).
triggers:
  - "Write end-to-end (E2E) integration tests with Patrol"
  - "Automate app user flows across real devices"
  - "Test native dialogs and system permissions"
negative_triggers:
  - "Isolated unit testing"
  - "Single widget testing"
---

# Flutter Integration Testing

## Purpose

Validate full user journeys and end-to-end application flows on real devices or emulators, ensuring all architectural layers work together seamlessly in production-like environments.

## Technology Context

- `integration_test` SDK package (built-in)
- `patrol` (recommended for advanced E2E, handling native iOS/Android dialogs and permissions)
- Firebase Test Lab / AWS Device Farm for cloud execution

## Rules

### Test Directory Structure

```
integration_test/
  app_test.dart               # Complete app boot & smoke test
  flows/
    auth_flow_test.dart       # Login → Home → Logout
    checkout_flow_test.dart   # Cart → Shipping → Payment → Success
  robots/
    login_robot.dart          # Page Object Model / Robot pattern
    home_robot.dart
```

### Robot Pattern (Page Object Model)

Always separate test choreography from widget interaction specifics using Robots.

```dart
// integration_test/robots/login_robot.dart
class LoginRobot {
  LoginRobot(this.tester);
  final WidgetTester tester;

  Future<void> enterEmail(String email) async {
    await tester.enterText(find.byKey(const Key('email_field')), email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    await tester.enterText(find.byKey(const Key('password_field')), password);
    await tester.pump();
  }

  Future<void> tapLogin() async {
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pumpAndSettle();
  }
}
```

### Writing the Flow Test

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full authentication flow', (tester) async {
    app.main(); // Boot the actual app
    await tester.pumpAndSettle();

    final loginRobot = LoginRobot(tester);
    await loginRobot.enterEmail('test@example.com');
    await loginRobot.enterPassword('password123');
    await loginRobot.tapLogin();

    // Assert navigation to home
    expect(find.text('Welcome back!'), findsOneWidget);
  });
}
```

### Patrol for Native Interactions

When testing permissions (location, camera, notifications) or OAuth browser redirects, use Patrol:

```dart
patrolTest('grants location permission and finds nearby stores', ($) async {
  await $.pumpWidgetAndSettle(const App());
  await $(#findStoresButton).tap();
  
  // Handle OS-level native permission dialog
  if (await $.native.isPermissionDialogVisible()) {
    await $.native.grantPermissionOnlyThisTime();
  }
  
  await $(#storeList).waitUntilVisible();
});
```

### Best Practices

- Use explicit `Key('unique_id')` on interactive widgets for reliable finders
- Avoid hardcoded `Future.delayed` — use `pumpAndSettle()` or Patrol's `waitUntilVisible()`
- Isolate test state by resetting database/secure storage in `setUp()` and `tearDown()`
- Run against staging environments or deterministic RAG/mock servers in CI

## Related Skills

- `flutter-widget-testing` — Component-level testing
- `flutter-unit-testing` — Logic testing
- `flutter-ci-cd` — Automating test runs in CI pipelines

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
