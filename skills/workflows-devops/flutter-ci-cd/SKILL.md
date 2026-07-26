---
name: flutter-ci-cd
description: >
  Use this skill when setting up or reviewing continuous integration and deployment pipelines for Flutter projects. Covers GitHub Actions, Codemagic, Fastlane, code analysis, automated testing, build generation, and store deployment. Do not use for release process details (use flutter-release).
triggers:
  - "Set up GitHub Actions or Codemagic CI/CD pipelines"
  - "Automate static analysis, code formatting, and testing"
  - "Automate build generation for Android and iOS"
negative_triggers:
  - "Store release metadata setup"
  - "Git commit conventions"
---

# Flutter CI/CD Pipelines & Continuous Integration

## Purpose

Automate quality control, static analysis, unit/widget/golden testing, and artifact generation on every commit and pull request using industry-standard CI/CD runners.

## Production GitHub Actions Workflow (`.github/workflows/flutter_ci.yml`)

```yaml
name: Flutter CI Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  analyze_and_test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Flutter Engine
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.44.x'
          channel: 'stable'
          cache: true

      - name: Install Dependencies
        run: flutter pub get

      - name: Verify Code Formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Analyze Static Code Quality
        run: flutter analyze .

      - name: Execute Unit and Widget Tests with Coverage
        run: flutter test --coverage

      - name: Upload Test Coverage
        uses: codecov/codecov-action@v4
        with:
          file: coverage/lcov.info
          fail_ci_if_error: true

  build_android:
    needs: analyze_and_test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Setup Flutter Engine
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.44.x'
          channel: 'stable'
          cache: true

      - name: Build Android AppBundle
        run: flutter build appbundle --release --build-number=${{ github.run_number }}

      - name: Upload AppBundle Artifact
        uses: actions/upload-artifact@v4
        with:
          name: app-release-aab
          path: build/app/outputs/bundle/release/app-release.aab
```

## Codemagic CI Configuration (`codemagic.yaml`)

```yaml
workflows:
  flutter-android-ios-build:
    name: Flutter Production Build Workflow
    max_build_duration: 60
    instance_type: mac_mini_m1
    environment:
      flutter: 3.44.x
      xcode: latest
      cocoapods: default
    scripts:
      - name: Get dependencies
        script: flutter pub get
      - name: Run static analysis
        script: flutter analyze
      - name: Run unit tests
        script: flutter test
      - name: Build iOS IPA
        script: flutter build ipa --release --export-options-plist=/Users/builder/export_options.plist
    artifacts:
      - build/ios/ipa/*.ipa
      - build/app/outputs/bundle/release/*.aab
```

## CI/CD Master Checklist

- [ ] Flutter version pinned in CI runner configuration (`3.44.x`)
- [ ] Dependency caching configured (`cache: true`) to accelerate build speed
- [ ] Zero-warning policy enforced via `flutter analyze`
- [ ] Code formatting check fails PR if unformatted code is committed
- [ ] Unit & widget tests run on every Pull Request
- [ ] Release secrets (keystores, API keys) injected strictly via CI repository secrets

## Related Skills
- `flutter-git` — PR branch naming and workflow rules
- `flutter-release` — App Store / Play Store automated publishing
- `flutter-unit-testing` — Test suite execution
