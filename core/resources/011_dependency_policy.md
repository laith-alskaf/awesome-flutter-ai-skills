# [ADR-011] Dependency Selection & Version Management Policy

- **Status:** Accepted
- **Date:** 2026-07-27
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Flutter projects accumulate dependencies over time without a standardized evaluation process. Teams often add packages impulsively (finding them via a blog post or a StackOverflow answer), leading to security vulnerabilities, abandoned packages, incompatible null safety, incompatible licenses, or packages that break on Flutter upgrades. Additionally, manually specifying version constraints in `pubspec.yaml` causes version drift — developers pin to old versions while better, more secure releases exist on pub.dev.

We need a mandatory, auditable policy that governs how packages are evaluated **before** adoption, and how they are added to enforce always-latest-compatible versioning.

---

## Decision Drivers

- Security: Outdated packages are the #1 source of exploitable vulnerabilities in mobile apps.
- Reliability: Unmaintained packages break on Flutter SDK or Dart version upgrades.
- License compliance: Copyleft (GPL) licenses are incompatible with proprietary app distribution.
- Version freshness: Manually editing `pubspec.yaml` version strings leads to stale, insecure dependency ranges.
- Audit trail: Engineers must justify why a package was selected, not just that it was added.

---

## Considered Options

1. **Structured evaluation checklist + `flutter pub add` mandate (Chosen):** Every package passes a 7-criteria gate before adoption, and `flutter pub add` is the only permitted method of adding packages.
2. **Ad hoc selection:** Engineers choose packages by personal preference without a structured process.
3. **Allowlist-only:** Maintain a curated allowlist of approved packages — rejected because it requires manual maintenance and slows down legitimate new package adoption.

---

## Decision Outcome

Chosen option: **Structured Evaluation Checklist + `flutter pub add` Command Mandate.**

Every new pub.dev dependency MUST pass all 7 evaluation criteria below before it can be added to any production project. The `flutter pub add` command is the ONLY permitted way to add or upgrade packages — it always resolves to the latest compatible version automatically.

---

## 📋 The 7-Criteria Dependency Evaluation Gate

Before adding any package, the AI Agent or engineer MUST evaluate all 7 criteria on pub.dev:

### Criterion 1: Pub Score & Popularity (pub.dev Metrics)

```
Required: Pub Points ≥ 120 (out of 160)
Required: Likes ≥ 50 (for non-utility packages)
Preferred: Popularity ≥ 90%
```

| pub.dev Metric | Minimum Threshold | Where to Check |
|---|---|---|
| Pub Points | ≥ 120 / 160 | pub.dev package page → "Scores" tab |
| Popularity | ≥ 90% | pub.dev package page → "Scores" tab |
| Likes | ≥ 50 | pub.dev package page |

> **Exception:** Internal utility packages or niche hardware packages (e.g., BLE, specialized camera SDKs) may have lower popularity but must pass all other criteria.

---

### Criterion 2: Publisher Verification

```
Required: Verified publisher badge (✅) on pub.dev
Preferred: Published by the Flutter/Dart team (dart.dev, flutter.dev) or a well-known OSS org
```

The verified publisher badge confirms that the publisher's identity has been validated by Google's pub.dev system. Unverified publishers represent a higher supply-chain attack risk.

**Red flags to reject immediately:**
- No publisher information
- Publisher account created < 30 days ago with no prior packages
- Publisher name differs significantly from the package name/organization

---

### Criterion 3: Maintenance & Last Update Date

```
Required: Last published version within the last 12 months
Preferred: Active development with regular releases
Reject if: Last update > 18 months ago (unless package is "complete" by design, e.g., a static algorithm library)
```

Check the "Changelog" and "Versions" tabs on pub.dev. A stale package with open GitHub issues and no response from maintainers is a maintenance liability.

---

### Criterion 4: Null Safety & Dart 3 Compatibility

```
Required: Full null safety support (sound)
Required: Compatible with current Dart SDK constraint in pubspec.yaml
Preferred: Supports Dart 3.x+ features (sealed classes, patterns)
```

Check `pubspec.yaml` in the package source for `sdk: '>=3.0.0 <4.0.0'` or compatible range.

> **Hard Rule:** NEVER add packages that are not null-safe. This is a non-negotiable security and stability requirement for Flutter 3.x projects.

---

### Criterion 5: Flutter & Platform Compatibility

```
Required: Compatible with Flutter 3.44.x stable channel
Required: Supports all target platforms (iOS, Android, Web, Desktop as required by the project)
Check: "Platforms" badge row on pub.dev package page
```

Verify the platforms listed on pub.dev match your project's `platforms:` section in `pubspec.yaml`. A package missing Web support when your app targets Flutter Web is an architectural blocker.

---

### Criterion 6: License Compatibility

```
Accepted: MIT, BSD-2, BSD-3, Apache 2.0, ISC
Requires legal review: LGPL, MPL
Rejected: GPL, AGPL, SSPL, Commons Clause, proprietary EULA
```

Check the "License" badge on pub.dev or the `LICENSE` file in the package repository.

> **Critical:** GPL/AGPL licenses require publishing your entire application source code under GPL. This is incompatible with most commercial Flutter apps. Reject immediately without legal sign-off.

---

### Criterion 7: Security Audit

```
Check: pub.dev "Security" tab for known vulnerabilities
Check: Package GitHub repository "Security advisories" section
Check: Dart/Flutter security advisories at https://dart.dev/security
Reject if: Any unpatched critical or high severity CVE is present
```

Additionally, review the package's `pubspec.yaml` for suspicious transitive dependencies (packages that pull in heavyweight SDKs, analytics trackers, or obfuscated native binaries without clear documentation).

---

## 🚀 Mandatory Package Addition Command

### ✅ ALWAYS USE `flutter pub add` — Never Manually Edit `pubspec.yaml`

```bash
# Correct — always resolves to latest compatible version
flutter pub add <package_name>

# Examples:
flutter pub add dio
flutter pub add flutter_riverpod riverpod_annotation
flutter pub add freezed_annotation json_annotation
flutter pub add go_router
flutter pub add flutter_secure_storage

# Add dev dependencies:
flutter pub add --dev build_runner freezed riverpod_generator json_serializable
flutter pub add --dev mocktail flutter_test
```

### ❌ NEVER manually edit version constraints in `pubspec.yaml`

```yaml
# Wrong — manual version pinning causes stale dependencies
dependencies:
  dio: ^5.3.0  # ← Never write this manually

# Correct — flutter pub add writes this for you with the latest compatible version
dependencies:
  dio: ^5.7.0  # ← Written by flutter pub add automatically
```

### Why `flutter pub add` is Mandatory

| Reason | Explanation |
|---|---|
| **Latest version** | Resolves to latest version compatible with your current `pubspec.yaml` constraints automatically |
| **Conflict detection** | Immediately surfaces incompatible dependency version conflicts before they become runtime issues |
| **Atomic update** | Updates `pubspec.yaml` AND runs `flutter pub get` in a single atomic operation |
| **No human error** | Eliminates typos in version strings that cause silent dependency resolution failures |
| **Reproducible** | `pubspec.lock` is updated consistently — every developer on the team gets the same version |

### Upgrading Existing Packages

```bash
# Upgrade a specific package to latest compatible version
flutter pub upgrade <package_name>

# Check what can be upgraded
flutter pub outdated

# Upgrade all packages to latest compatible (run after reviewing `flutter pub outdated`)
flutter pub upgrade

# Upgrade breaking (major) versions — requires testing
flutter pub upgrade --major-versions
```

---

## 📝 Dependency Addition Audit Trail

Every new dependency added to a project MUST be accompanied by a brief comment in `pubspec.yaml` documenting the evaluation result:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # [ADR-011] dio — HTTP client. Pub: 160/160, License: MIT, Publisher: cfug.dev (verified)
  # Criteria: ✅ Score ✅ Verified ✅ Active ✅ Null-safe ✅ All platforms ✅ MIT ✅ No CVEs
  dio: ^5.7.0

  # [ADR-011] flutter_riverpod — State management. Pub: 160/160, License: MIT, Publisher: dash-overflow.net
  # Criteria: ✅ Score ✅ Verified ✅ Active ✅ Null-safe ✅ All platforms ✅ MIT ✅ No CVEs
  flutter_riverpod: ^3.0.0
```

---

## Validation & Compliance

- **AI Agent Enforcement:** When an AI Agent is asked to add a package, it MUST first evaluate all 7 criteria, report findings, and only use `flutter pub add <package>` — never generate a `pubspec.yaml` diff.
- **CI Enforcement:** Run `flutter pub outdated` in CI and fail the build if any dependency has a security advisory.
- **Code Review Gate:** PRs adding new dependencies must include an audit trail comment in `pubspec.yaml`.
- **Relevant Skills:** `flutter-api-integration` (networking packages), `flutter-local-database` (storage packages), `flutter-security` (security implications of dependencies), `flutter-create-feature` (Step 4 in dependency setup)
- **Verification Command:** `flutter pub outdated --json` for machine-readable audit output.
