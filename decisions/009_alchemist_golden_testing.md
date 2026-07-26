# [ADR-009] Alchemist for Declarative Visual Regression Testing

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Standard widget tests verify structural presence and functional interaction but cannot catch unintended visual regressions (e.g., text clipping, padding shifts, broken dark theme colors, or responsive overflow). Native Flutter golden tests (`matchesGoldenFile`) are imperative, verbose, and difficult to organize across multiple themes and device sizes.

---

## Decision Drivers

- Need automated screenshot verification across light/dark themes, text scaling, and device form factors simultaneously.
- Must generate clean, scannable matrix images showing UI components under various test scenarios side-by-side.
- Must execute reliably within headless CI/CD Linux Docker containers without font rendering flakiness.

---

## Considered Options

1. **alchemist (Chosen):** Declarative golden testing framework developed by Betterment, generating structured matrix comparison images.
2. **golden_toolkit:** Popular golden testing library by eBay (slower release cadence).
3. **Raw `matchesGoldenFile`:** Flutter's built-in low-level golden assertion API.

---

## Decision Outcome

Chosen option: **alchemist**, because its declarative API (`GoldenTestGroup`, `GoldenTestScenario`) allows testing an entire component's state matrix (light, dark, loading, error, disabled) in a single visual artifact, accelerating test execution and review.

### Positive Consequences

- **Matrix Goldens:** Reviewers inspect a single composite image per component showing all states and themes.
- **Font & Asset Loading:** Built-in configuration ensures real app typography is rendered instead of default Ahem test squares.
- **CI/CD Integration:** Integrates seamlessly with GitHub Actions visual diff reporting tools.

### Negative Consequences / Trade-offs

- **Storage Growth:** Baseline PNG files must be committed to Git repository history.
- **OS Rendering Differences:** Baseline generation must be restricted to a standardized CI Linux environment to avoid subtle macOS vs Linux text rendering discrepancies.

---

## Validation & Compliance

- **How to verify compliance:** CI/CD pipeline executes `flutter test` with golden assertions; any visual deviation fails the build.
- **Relevant Skills:** `flutter-golden-testing`, `flutter-widget-testing`
