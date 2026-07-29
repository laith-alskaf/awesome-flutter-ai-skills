# [ADR-010] Patrol for Native E2E Integration Testing

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Flutter's official `integration_test` SDK operates strictly within the Flutter rendering view. It cannot interact with OS-level native dialogs, such as camera/location permission prompts, OAuth web browser redirects, push notification banners, or system settings toggles. When an E2E test encounters a native system permission dialog, the standard test runner hangs and fails.

---

## Decision Drivers

- Must automate end-to-end user journeys that trigger OS permission requests (location, notifications, camera).
- Must interact with native system UI (toggling Wi-Fi/Cellular, interacting with notifications, backgrounding/foregrounding the app).
- Need unified test syntax that works on both physical Android and iOS devices or emulators.

---

## Considered Options

1. **Patrol by LeanCode (Chosen):** Advanced E2E testing framework combining Flutter widget automation with native UI automation (UIAutomator on Android, XCUITest on iOS).
2. **Raw `integration_test`:** Built-in Flutter SDK integration test package.
3. **Appium / Maestro:** External cross-platform black-box mobile automation tools.

---

## Decision Outcome

Chosen option: **Patrol**, because it extends Flutter's native testing capabilities with a concise, powerful syntax (`$.native.grantPermissionOnlyThisTime()`) allowing automated tests to bridge the gap between Flutter widgets and OS native dialogs seamlessly.

### Positive Consequences

- **Full Journey Automation:** Tests can log in via web OAuth, accept location permissions, take a photo, and receive notifications in a single automated script.
- **Concise Syntax:** Patrol's custom finder syntax (`$(#loginButton).tap()`) is significantly less verbose than standard `WidgetTester` boilerplate.
- **Cloud Compatible:** Runs natively on Firebase Test Lab, AWS Device Farm, and Bitrise E2E environments.

### Negative Consequences / Trade-offs

- **Setup Complexity:** Requires initial native gradle/podfile setup to link Patrol's native test servers.

---

## Validation & Compliance

- **How to verify compliance:** Core critical user journeys (Authentication, Checkout, Permission Onboarding) must be automated using Patrol test suites in `integration_test/`.
- **Relevant Skills:** `flutter-integration-testing`
