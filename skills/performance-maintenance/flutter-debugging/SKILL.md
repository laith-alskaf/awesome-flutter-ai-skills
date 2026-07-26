---
name: flutter-debugging
description: >
  Use this skill when debugging Flutter applications using DevTools, Impeller
  timeline, memory profiler, widget inspector, network inspector, and common
  debugging techniques. Do not use for code optimization (use flutter-performance)
  or logging setup (use flutter-logging).
triggers:
  - "Debug Flutter issues using Flutter DevTools"
  - "Inspect widget tree, memory profiler, and network logs"
  - "Diagnose crashes and unexpected runtime state"
negative_triggers:
  - "Code refactoring"
  - "Production release preparation"
---

# Flutter Debugging

## Purpose

Systematically diagnose and resolve Flutter issues using DevTools, Impeller timeline analysis, memory profiling, and structured debugging techniques.

## Technology Context

- Flutter DevTools (built-in profiling suite)
- Impeller timeline (rendering analysis, replaces Skia timeline)
- Dart VM Observatory for memory analysis

## Rules

### Debugging Process

1. **Reproduce** — Find consistent reproduction steps
2. **Isolate** — Narrow to the smallest possible scope
3. **Diagnose** — Use appropriate DevTools tab
4. **Fix** — Apply targeted fix
5. **Verify** — Confirm fix, check for regressions

### DevTools Usage

| Problem | DevTools Tab | What to Look For |
|---|---|---|
| UI jank / dropped frames | Performance / Timeline | Long frame build/render times |
| Memory leak | Memory | Growing heap, undisposed objects |
| Widget rebuild issues | Widget Inspector | Unnecessary rebuilds, deep trees |
| Slow API calls | Network | Response times, failed requests |
| Layout overflow | Widget Inspector | RenderFlex overflow errors |

### Common Debugging Commands

```bash
# Open DevTools
flutter run --debug
# Press 'd' in terminal for DevTools URL

# Profile mode for performance analysis
flutter run --profile

# Verbose logging
flutter run --verbose

# Check for analysis issues
dart analyze
```

### Common Issues and Solutions

| Issue | Likely Cause | Solution |
|---|---|---|
| `RenderFlex overflowed` | Fixed content in constrained space | Wrap in `SingleChildScrollView` or use `Expanded` |
| `setState() called after dispose()` | Async callback after widget unmounted | Check `mounted` or use `AutoDisposeMixin` |
| Provider not found | Missing ProviderScope | Wrap app in `ProviderScope` |
| Image not loading | Incorrect asset path or CORS | Check `pubspec.yaml` assets and server config |
| Infinite rebuild loop | Provider watching itself | Break circular dependency |

### Breakpoint Debugging

```dart
// Programmatic breakpoint
debugger(when: someCondition);

// Print widget tree
debugDumpApp();

// Print render tree
debugDumpRenderTree();

// Print layer tree
debugDumpLayerTree();
```

## Related Skills

- `flutter-performance` — Performance optimization
- `flutter-logging` — Structured logging
- `flutter-error-handling` — Error diagnosis patterns
