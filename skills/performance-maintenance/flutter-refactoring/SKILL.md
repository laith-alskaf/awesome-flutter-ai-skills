---
name: flutter-refactoring
description: >
  Use this skill when refactoring Flutter code to improve structure, readability, or maintainability without changing external behavior. Covers safe refactoring patterns, incremental approach, migration strategies, and anti-pattern removal. Do not use for performance optimization (use flutter-performance) or new feature development (use flutter-create-feature).
triggers:
  - "Refactor legacy Flutter code without changing external behavior"
  - "Extract complex widgets safely without breaking state"
  - "Remove code smells and anti-patterns"
negative_triggers:
  - "Adding new features"
  - "Performance optimization profiling"
---

# Flutter Refactoring & Code Modernization

## Purpose

Systematically improve Flutter codebase structure, remove technical debt, and modernize legacy codebases while maintaining 100% behavior parity and zero regression bugs.

## Core Refactoring Principles

1. **Behavior Preservation:** Refactoring changes internal structure only; external behavior must remain identical.
2. **Incremental Small Diffs:** Never rewrite an entire module in a single commit. Make small, testable transformations.
3. **Green Test Gate:** Run `flutter test` before and after every single refactoring step.
4. **Safety Net:** If tests do not exist for the legacy code, write a safety-net characterization test first before modifying the implementation.

## Common Refactoring Transformations

### 1. Extract Large Build Method into Private StatelessWidget
**Anti-Pattern (Heavy Build Method):**
```dart
// BAD: 150-line build method rebuilding entire screen on single state update
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Column(
      children: [
        // 50 lines of header widgets
        // 50 lines of complex list items
        // 50 lines of bottom buttons
      ],
    ),
  );
}
```

**Refactored (Widget Extraction):**
```dart
// GOOD: Extracted isolated StatelessWidget instances with const constructors
@override
Widget build(BuildContext context) {
  return const Scaffold(
    body: Column(
      children: [
        _HeaderSection(),
        _UserListView(),
        _BottomActionBar(),
      ],
    ),
  );
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) { ... }
}
```

### 2. Migrating Raw Callbacks to Clean UseCases
**Anti-Pattern (Direct Data Access in Widget):**
```dart
// BAD: Widget calling HTTP or DB directly inside setState
onPressed: () async {
  final response = await http.post(Uri.parse('https://api.com/user'), body: {...});
  setState(() { _user = jsonDecode(response.body); });
}
```

**Refactored (Clean Layer Separation):**
```dart
// GOOD: Delegate to Notifier -> UseCase -> Repository
onPressed: () {
  ref.read(userNotifierProvider.notifier).updateProfile(userDto);
}
```

### 3. Replacing Deprecated APIs with Modern Dart 3.12 Patterns
- Replace `WillPopScope` with `PopScope(canPop: false, onPopInvokedWithResult: ...)`
- Replace `FlatButton` / `RaisedButton` with `TextButton` / `ElevatedButton`
- Replace `switch` statements with Dart 3.12 exhaustive pattern matching `switch (state)`
- Replace raw error handling with Dart 3 sealed `Failure` classes

## Refactoring Step-by-Step Execution Checklist

- [ ] Run `flutter test` to establish baseline pass state
- [ ] Extract monolithic widget subtrees into const `StatelessWidget` classes
- [ ] Replace `dynamic` types with explicit sound type definitions
- [ ] Convert raw exceptions to sealed `Failure` types
- [ ] Run `dart analyze` to verify zero compiler warnings
- [ ] Run `dart format .` to format modified files
- [ ] Re-run `flutter test` to verify zero regression bugs

## Related Skills
- `flutter-clean-architecture` — Target layer boundaries
- `flutter-unit-testing` — Safety net unit testing
- `flutter-performance` — Performance impact verification

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
