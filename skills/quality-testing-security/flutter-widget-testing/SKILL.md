---
name: flutter-widget-testing
description: >
  Use this skill when writing widget tests for Flutter UI components. Covers
  WidgetTester, finders, matchers, pumping widgets, mocking providers, testing
  user interactions, form validation, and navigation. Do not use for unit tests
  of business logic (use flutter-unit-testing) or full app integration tests
  (use flutter-integration-testing).
triggers:
  - "Write widget tests for Flutter UI components"
  - "Test user interactions, button taps, and text input"
  - "Verify widget states (loading, error, data)"
negative_triggers:
  - "Domain unit testing"
  - "Full app integration testing"
---

# Flutter Widget Testing

## Purpose

Verify UI components render correctly, respond to user interactions, and display proper states (loading, error, empty, data) without requiring a physical device.

## Technology Context

- `flutter_test` package
- `mocktail` for mocking dependencies
- Riverpod `ProviderScope.overrides` for widget tests
- Golden file comparison for visual regression

## Rules

### Widget Test Structure

```dart
void main() {
  group('LoginPage', () {
    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authRepositoryProvider.overrideWithValue(MockAuthRepo())],
          child: const MaterialApp(home: LoginPage()),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('shows error when submitting empty form', (tester) async {
      await tester.pumpWidget(/* ... */);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email required'), findsOneWidget);
    });

    testWidgets('shows loading indicator during login', (tester) async {
      await tester.pumpWidget(/* ... */);
      await tester.enterText(find.byKey(const Key('email')), 'test@test.com');
      await tester.enterText(find.byKey(const Key('password')), 'password');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Don't settle — check loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

### Testing Interactions

```dart
await tester.tap(find.byType(ElevatedButton));
await tester.enterText(find.byType(TextField), 'input');
await tester.drag(find.byType(ListView), const Offset(0, -300));
await tester.longPress(find.text('Item'));
```

### Pumping Strategies

```dart
await tester.pump();              // Single frame
await tester.pump(Duration(seconds: 1));  // Advance by duration
await tester.pumpAndSettle();     // Pump until no more frames scheduled
```

## Checklist

- [ ] All pages tested for each state (loading, error, empty, data)
- [ ] User interactions tested (tap, type, scroll)
- [ ] Form validation tested
- [ ] Providers mocked via ProviderScope.overrides
- [ ] Widget keys assigned for testability

## Related Skills

- `flutter-unit-testing` — Business logic testing
- `flutter-golden-testing` — Visual regression testing
- `flutter-ui-engineering` — Widget design patterns
