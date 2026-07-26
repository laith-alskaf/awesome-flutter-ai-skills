# 📦 Pillar 5: Enterprise Release & CI/CD Pipelines

## 1. Automated Build & Signing Automation
- Automate Android App Bundle (AAB) and iOS App Store IPA generation using GitHub Actions, Codemagic, or Fastlane.
- Manage release signing keystores and provisioning profiles securely via CI/CD secrets variables.

## 2. Code Quality & Formatting Gating
- Enforce strict CI build gating: NO release build may proceed unless `dart analyze` reports zero warnings and `dart format --output=none --set-exit-if-changed .` passes.

## 3. Semantic Versioning & Store Metadata
- Enforce strict semantic versioning (`MAJOR.MINOR.PATCH+BUILD`) synchronized automatically in `pubspec.yaml`.
- Ensure app store listing metadata (privacy policy URL, screenshots, descriptions, age rating) is verified before submission.
