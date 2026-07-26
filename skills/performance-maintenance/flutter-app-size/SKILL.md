---
name: flutter-app-size
description: >
  Use this skill when analyzing or reducing Flutter application binary size
  including APK, AAB, IPA, assets, fonts, dependencies, native libraries, and
  build configuration. Measures before and after every optimization. Do not use
  for runtime performance optimization (use flutter-performance).
triggers:
  - "Analyze and reduce APK, AAB, or IPA binary size"
  - "Optimize assets, fonts, and native library dependencies"
  - "Run flutter build with --analyze-size"
negative_triggers:
  - "Runtime FPS performance profiling"
  - "Memory leak debugging"
---

# Flutter App Size Optimizer

## Purpose

Reduce application download and install size without sacrificing functionality or quality. Every megabyte matters for user acquisition and retention.

## Scope

**Covers:** APK/AAB/IPA analysis, asset optimization, font subsetting, dependency audit, tree shaking, build configuration, native library optimization.

**Does not cover:** Runtime performance, memory usage, CPU optimization.

## Technology Context

- Flutter 3.44.x with Impeller (shader precompilation affects size)
- SwiftPM for iOS (replacing CocoaPods)
- Android App Bundle (AAB) with ABI splitting
- `flutter build` size analysis tools

## Rules

### Analysis First

```bash
# Analyze APK size breakdown
flutter build apk --analyze-size
# Analyze AAB size
flutter build appbundle --analyze-size
# View detailed report
flutter pub run devtools --appSizeBase=apk-analysis.json
```

### Asset Optimization

- Compress all images. Prefer WebP over PNG/JPEG (30-50% smaller).
- Remove unused assets from `pubspec.yaml`.
- Generate multiple resolutions (1x, 2x, 3x) — don't ship 4K images for phones.
- Lazy load assets that aren't needed at startup.
- Use `flutter_svg` for icons instead of PNG (scalable, smaller).

### Font Optimization

- Subset fonts to include only used characters.
- Remove unused font weights (if only using Regular and Bold, don't ship Light/Medium/Black).
- Limit to 1-2 font families maximum.
- Consider system fonts for non-branded text.

### Dependency Audit

```bash
# Check dependency sizes
flutter pub deps --no-dev
```

- Remove unused packages. Audit transitive dependencies.
- Replace heavy packages with lighter alternatives.
- Avoid packages that pull in large native SDKs unnecessarily.

### Build Configuration

```bash
# Production build with all optimizations
flutter build appbundle --release --shrink --obfuscate --split-debug-info=./debug-info/

# Split by ABI for APK (when not using AAB)
flutter build apk --release --split-per-abi
```

- Always use AAB for Play Store (automatic ABI splitting).
- Enable R8 shrinking and resource optimization in `build.gradle`.
- Strip debug symbols from release builds.

### Native Optimization

- Remove unused Android permissions from `AndroidManifest.xml`.
- Remove unused iOS capabilities from `Info.plist`.
- Clean unused native libraries.
- Optimize Gradle configuration (enable `minifyEnabled`, `shrinkResources`).

### Code Optimization

- Delete dead code and unused files.
- Ensure tree shaking is effective (avoid `dart:mirrors`).
- Optimize generated files (freezed, json_serializable).
- Use deferred loading for large feature modules.

```dart
// Deferred import for large features
import 'package:app/features/admin/admin_page.dart' deferred as admin;

// Load when needed
await admin.loadLibrary();
Navigator.push(context, MaterialPageRoute(builder: (_) => admin.AdminPage()));
```

## Checklist

- [ ] Size analyzed with `--analyze-size` before optimizing
- [ ] All images compressed (WebP preferred)
- [ ] Unused assets removed
- [ ] Fonts subsetted (only needed weights/characters)
- [ ] Unused packages removed
- [ ] AAB used for Play Store
- [ ] R8 shrinking and resource optimization enabled
- [ ] Debug symbols stripped from release
- [ ] Unused permissions removed
- [ ] Before/after size comparison documented

## Related Skills

- `flutter-performance` — Runtime performance optimization
- `flutter-release` — Full release build process
- `flutter-ci-cd` — Automated build optimization
