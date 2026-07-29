# Release Readiness Checklist

Use this checklist before building and publishing production release artifacts to the Google Play Store or Apple App Store.

## 1. Versioning & Configuration
- [ ] Semantic version and build number incremented correctly in `pubspec.yaml` (`MAJOR.MINOR.PATCH+BUILD`).
- [ ] All environment configurations point to production servers (no staging URLs, mock databases, or test flags).
- [ ] App display name, bundle identifier, package name, and icon icons verified across iOS and Android configs.

## 2. Quality Gates
- [ ] Full regression test suite (`flutter test`) passes 100%.
- [ ] End-to-end integration smoke tests pass on real device targets.
- [ ] Zero static analysis warnings (`dart analyze`) across the entire codebase.

## 3. Build & Hardening
- [ ] Android App Bundle (AAB) built with obfuscation: `flutter build appbundle --release --obfuscate --split-debug-info=./debug-info/`.
- [ ] iOS Archive (IPA) built with obfuscation: `flutter build ipa --release --obfuscate --split-debug-info=./debug-info/`.
- [ ] Binary size analyzed (`--analyze-size`) to ensure no bloated or unused assets/fonts were accidentally bundled.

## 4. Store Compliance & Metadata
- [ ] Privacy Policy URL is live, accessible, and accurately reflects all SDK data collection practices.
- [ ] Target SDK versions comply with latest Google Play (API 34+) and Apple iOS store mandates.
- [ ] App Store screenshots, feature graphics, and release notes localized and staged.
