---
name: flutter-production-readiness
description: Use this skill when auditing a Flutter application for SaaS and Mobile production release, setting up release gates, checking accessibility, verifying security, or evaluating monitoring and monetization. Enforces the 6 Readiness Pillars (Security, Testing, Analytics, Monetization, Release, Observability) and generates PRODUCTION_CHECKLIST.md.
triggers:
  - production readiness
  - production check
  - release gate
  - saas readiness
  - production audit
  - release audit
  - go live
negative_triggers:
  - flutter run
  - git commit
  - widget test
  - ui layout
---

# 🚀 Flutter Production Readiness & Release Gate (`flutter-production-readiness`)

This skill acts as the **Principal DevOps Architect, Site Reliability Engineer (SRE), and Chief Security Officer (CSO)** for autonomous AI Agents (**Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, **Roo Code**, **GitHub Copilot**).

**Core Mandate:** Never approve a production build or app store submission without auditing and validating all 6 foundational readiness pillars plus mandatory Accessibility gating.

---

## 🏛️ The 6 Readiness Pillars & Sub-Resources

To prevent monolithic skill complexity, detailed inspection rules and checklists are modularized into 6 specialized sub-resources located in `_resources/`:

1. 🛡️ **Security Architecture (`_resources/security.md`):** Secrets management, HTTPS SSL pinning, certificate handling, environment separation, API key protection, secure storage (`flutter_secure_storage`).
2. 🧪 **Testing Pyramid (`_resources/testing.md`):** AAA Unit tests (Domain/Repos), Widget tests, Golden visual regression matrix, and E2E Integration flows.
3. 📈 **Analytics & Telemetry (`_resources/analytics.md`):** Event tracking (Firebase Analytics, PostHog, Amplitude), funnel conversion, and user retention tracking.
4. 💰 **Monetization & SaaS Strategy (`_resources/monetization.md`):** Paywall architecture, free vs. premium tiers, subscription models, course gating.
5. 📦 **Enterprise Release & CI/CD (`_resources/release.md`):** App signing (AAB/IPA), GitHub Actions / Fastlane automation, versioning, store metadata.
6. 👁️ **Observability & Monitoring (`_resources/observability.md`):** Crashlytics, Sentry, Datadog, performance monitoring, structured logging strategy.

---

## ♿ Mandatory Accessibility Gate (A11y Release Gating)

In addition to the 6 pillars, **NO release may pass** without verifying compliance with `flutter-accessibility`:
- [ ] **Contrast Check:** Text and background contrast ratio exceeds WCAG AA (4.5:1 for normal text, 3:1 for large text).
- [ ] **Screen Reader Support:** All interactive elements (`GlassCard`, buttons, icons) have descriptive `Semantics(label: ...)`.
- [ ] **Dynamic Text Support:** UI layouts use `Expanded`, `Flexible`, or scrollable containers to survive system font scaling up to 200% without overflow.

---

## 📄 Scaffolding `.agent/PRODUCTION_CHECKLIST.md` (READY Phase)

Before authorizing production deployment, the AI Agent MUST generate and verify `PRODUCTION_CHECKLIST.md` in the `.agent/` workspace directory (`.agent/PRODUCTION_CHECKLIST.md`):

```markdown
# PRODUCTION_CHECKLIST.md — Enterprise Go-Live Verification

## 1. 🛡️ Security Audit (Status: [PASS/FAIL])
- [ ] Zero hardcoded secrets or API keys in source code.
- [ ] JWT and sensitive tokens stored exclusively in `flutter_secure_storage`.
- [ ] HTTPS enforced with certificate pinning for backend communication.

## 2. 🧪 Testing Pyramid Gate (Status: [PASS/FAIL])
- [ ] 100% domain logic unit test coverage passed (`flutter test`).
- [ ] Golden visual regression matrix verified across Dark/Light modes.

## 3. 📈 Analytics & Telemetry Gate (Status: [PASS/FAIL])
- [ ] Core funnel events (OnboardingCompleted, TipFavorited, ActionPlanCreated) logged.

## 4. 💰 Monetization & SaaS Gate (Status: [PASS/FAIL])
- [ ] Paywall state transitions and premium entitlement checks verified.

## 5. 📦 Release & CI/CD Gate (Status: [PASS/FAIL])
- [ ] Zero warnings on `dart analyze` and code formatting verified.
- [ ] Release bundles (Android AAB / iOS IPA) successfully generated via CI/CD.

## 6. 👁️ Observability Gate (Status: [PASS/FAIL])
- [ ] Firebase Crashlytics / Sentry initialized in `main.dart` error handler.
```

---

## 🧭 Next Pipeline Phase Routing

Once `.agent/PRODUCTION_CHECKLIST.md` passes all 6 pillars and accessibility gates, the AI Agent routes to:
👉 **`flutter-code-review`** (For final Principal Engineer architectural review before store submission).

---

## Related Skills

- `flutter-code-review` — Final code quality and architecture review gate
- `flutter-security` — Detailed security audit rules (Pillar 1)
- `flutter-unit-testing` — Testing pyramid verification (Pillar 2)
- `flutter-widget-testing` — UI regression testing (Pillar 2)
- `flutter-golden-testing` — Visual regression matrix (Pillar 2)
- `flutter-accessibility` — Mandatory A11y gate before release
- `flutter-ci-cd` — CI/CD pipeline for automated release gates (Pillar 5)
- `flutter-release` — App signing and store submission (Pillar 5)
- `flutter-logging` — Crash reporting and observability setup (Pillar 6)
