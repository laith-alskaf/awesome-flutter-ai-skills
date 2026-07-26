---
name: flutter-golden-testing
description: >
  Use this skill when implementing visual regression testing in Flutter using
  golden tests (alchemist or golden_toolkit). Covers golden file generation,
  multi-device/multi-theme matrix testing, font loading, CI/CD visual regression
  automation, and handling rendering differences across platforms. Do not use for
  functional interaction testing (use flutter-widget-testing).
triggers:
  - "Implement visual regression golden tests"
  - "Test multi-theme and multi-device screenshot matrix"
  - "Configure Alchemist / golden_toolkit visual tests"
negative_triggers:
  - "Functional unit testing"
  - "API networking"
---

# Flutter Golden Testing

## Purpose

Catch unintended visual regressions, UI layout shifts, clipping, and responsive breaks across multiple devices, themes (light/dark), and locales (LTR/RTL) using automated screenshot comparisons.

## Technology Context

- `alchemist` (preferred) or `golden_toolkit` for declarative golden test suites
- `flutter test --update-goldens` to generate baseline images
- Impeller / Skia rendering awareness across OS platforms

## Rules

### Setup with Alchemist

```yaml
# dev_dependencies:
  alchemist: ^0.8.0
```

```dart
// test/flutter_test_config.dart
import 'package:alchemist/alchemist.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: const AlchemistConfig(
      theme: AlchemistThemeConfig(),
      platformGoldensConfig: PlatformGoldensConfig(enabled: true),
    ),
    run: testMain,
  );
}
```

### Writing a Multi-Scenario Golden Test

Always test UI components across multiple states and themes in a single golden matrix.

```dart
void main() {
  group('UserCard Golden Tests', () {
    goldenTest(
      'renders correctly across themes and states',
      fileName: 'user_card_matrix',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'Light Theme - Standard',
            child: UserCard(user: mockUser),
          ),
          GoldenTestScenario(
            name: 'Dark Theme - Standard',
            child: Theme(
              data: ThemeData.dark(),
              child: UserCard(user: mockUser),
            ),
          ),
          GoldenTestScenario(
            name: 'Long Text Overflow',
            child: SizedBox(
              width: 200,
              child: UserCard(user: mockUserWithVeryLongName),
            ),
          ),
        ],
      ),
    );
  });
}
```

### Font and Asset Loading in Goldens

Never allow default visual blocks (grey boxes for images, Ahem font rectangles for text).

```dart
setUpAll(() async {
  // Load real fonts and icons for accurate goldens
  await loadAppFonts();
});
```

### CI/CD and Platform Consistency

- Golden test renderings differ subtly between macOS, Linux, and Windows due to text rendering engines.
- **Rule:** Generate and validate final baseline goldens on a standardized OS (typically Linux in CI/CD using Docker or GitHub Actions ubuntu-latest).
- Commit `.png` baseline files in a `goldens/` directory next to the tests.

## Related Skills

- `flutter-widget-testing` — Functional widget testing
- `flutter-ui-engineering` — Responsive and adaptive layout rules
- `flutter-ci-cd` — Running visual regression checks in CI
