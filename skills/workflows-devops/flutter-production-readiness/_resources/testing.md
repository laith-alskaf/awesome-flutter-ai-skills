# 🧪 Pillar 2: Enterprise Testing Pyramid

## 1. AAA Unit Testing (Domain & Repositories)
- Enforce 100% unit test coverage for all Domain Entities, Value Objects, UseCases, and Repository implementations using `flutter_test` and `mocktail`.
- Follow strict **Arrange-Act-Assert (AAA)** structure in every test file.
- Verify both success path and failure path (mapping network/server exceptions to typed `Sealed Failures`).

## 2. Widget Testing (UI Components & Cards)
- Test individual UI components (`TipCardWidget`, `GlassCard`, custom form inputs) in isolation using `WidgetTester`.
- Verify user interactions (taps, gestures, form validation, error message rendering).

## 3. Golden Visual Regression Testing
- Implement visual regression matrix testing using `alchemist` or `golden_toolkit`.
- Generate golden reference screenshots across multiple device screen sizes (phone, tablet, desktop) and theme modes (Dark Mode and Light Mode).
- Automate golden test diff verification in CI/CD pipelines (`flutter test --update-goldens` only when approved).

## 4. E2E Integration Testing (User Journeys)
- Implement full user flow integration tests using `integration_test` or Patrol.
- Automate critical user paths: Onboarding ➔ Feed Navigation ➔ Favoriting Tip ➔ Action Plan Execution ➔ Logout.
