---
name: flutter-bug-fixing
description: >
  Use this skill when analyzing, diagnosing, and resolving bugs in Flutter
  applications. Provides a structured 6-step diagnostic methodology covering
  reproduction, root-cause analysis, minimal-diff fix implementation, regression
  testing, and documentation. Do not use for new feature implementation (use
  flutter-create-feature) or general performance profiling (use flutter-performance).
triggers:
  - "Diagnose, reproduce, and fix bugs in Flutter code"
  - "Perform root-cause analysis and minimal-diff bug fixing"
  - "Write regression tests for fixed bugs"
negative_triggers:
  - "New feature creation"
  - "Architecture design"
  - "Performance profiling and optimization"
---

# Flutter Bug Fixing

## Purpose

Provide a systematic, evidence-based methodology for diagnosing, reproducing, fixing, and preventing bugs in Flutter applications. The goal is always to fix the root cause — not mask the symptom.

## Scope

**Covers:** Bug reproduction, root-cause analysis, minimal-diff fix implementation, regression test creation, and fix documentation.

**Does not cover:** Performance profiling (use `flutter-performance`), new feature implementation (use `flutter-create-feature`), general DevTools usage (use `flutter-debugging`).

## Technology Context

- Flutter 3.44.x / Dart 3.12.x
- Flutter DevTools for diagnostics
- mocktail / mockito for regression test mocking
- Clean Architecture error propagation patterns

## Rules

### The 6-Step Bug Resolution Workflow

#### Step 1: Understand the Bug
- Read the full bug report and error message completely — Dart errors are descriptive
- Identify: **What is expected?** vs **What actually happens?**
- Gather context: Which platform? Which device? Which Flutter version? Which screen/flow?
- Check the **full stack trace** — find YOUR code in it (not framework-level code)

#### Step 2: Reproduce Consistently
- Find the exact minimum reproduction steps
- Reproduce on multiple devices/platforms if possible
- If you cannot reproduce it consistently, gather more evidence (logs, screenshots, device info) before proceeding
- Create an isolated test case if needed

#### Step 3: Root Cause Analysis

Use the SEED framework:

```
Symptom  → What the user or system observes
Evidence → Error messages, logs, stack traces, screenshots
Origin   → Which file/function/layer introduced the issue
Defect   → The exact code line or logic causing the bug
```

Common root cause categories:
- **Null safety violation** — unchecked nulls, wrong optional usage
- **Async race condition** — multiple async operations with unguarded state updates
- **Widget lifecycle issue** — `setState()` after `dispose()`, missing `mounted` check
- **Architecture boundary violation** — UI calling API directly, domain importing Flutter
- **State management bug** — stale provider, wrong scope, undisposed controller
- **Navigation/routing bug** — missing route, wrong context, navigator stack issues

#### Step 4: Implement Fix

- **Fix the root cause, not the symptom** — never add `try/catch` to silence exceptions
- **Make the smallest possible change** — minimal diff reduces regression risk
- **Follow Clean Architecture boundaries** — if the bug is in the wrong layer, fix the layer first
- **Verify the fix doesn't break other functionality** — check related screens and flows

#### Step 5: Prevent Regression

Always add a test that:
1. Fails on the original buggy code
2. Passes after the fix is applied

```dart
// Regression test pattern
test('user profile loads after network timeout and retry', () async {
  // Arrange: simulate the exact bug condition
  when(() => mockRepo.getProfile()).thenThrow(const NetworkError());

  // Act: trigger the failing flow
  final cubit = ProfileCubit(mockRepo);
  await cubit.loadProfile();

  // Assert: verify the error is handled correctly (not crashed)
  expect(cubit.state, isA<ProfileError>());
});
```

#### Step 6: Document the Fix

In commit message or PR description:
- What caused the bug
- What was changed and why
- Any related areas that should be monitored

```
fix(profile): handle network timeout during profile load

Root cause: ProfileCubit did not catch DioException on timeout,
causing unhandled exception crash on slow connections.

Fix: Added timeout catch in ProfileRepositoryImpl._mapDioException()
and emitted ProfileError state with user-friendly message.

Regression test added in test/features/profile/profile_cubit_test.dart
```

---

## Common Bug Pattern Reference

### Build / Compile Errors

| Error | Likely Cause | Fix |
|---|---|---|
| `type 'Null' is not a subtype of type 'X'` | Null safety violation | Check null assertions, add null checks or default values |
| `Could not find the correct Provider` | Missing ProviderScope | Wrap app root with `ProviderScope` |
| `RenderFlex overflowed` | Content exceeds layout constraints | Wrap in `Flexible`, `Expanded`, or `SingleChildScrollView` |
| `setState() called after dispose()` | Async callback after widget unmount | Check `if (!mounted) return;` before `setState()` |
| `MissingPluginException` | Missing platform plugin setup | Run `flutter clean && flutter pub get`, rebuild |
| `Bad state: Stream already listened` | Single-subscription stream reused | Use `StreamController.broadcast()` or cancel before re-listen |

### Runtime Errors

| Issue | Diagnosis | Fix |
|---|---|---|
| White/blank screen | Missing `return` in `build()` or unhandled null | Check all code paths return a Widget |
| Infinite loading spinner | Provider/Cubit never emits data or error state | Add timeout; check async chain for missing `emit` |
| Data not refreshing | Stale provider or missing `invalidate` | Use `ref.invalidate()`, `ref.refresh()`, or `emit()` fresh state |
| Form validation not triggering | Missing `GlobalKey<FormState>` or wrong `validator` usage | Add `_formKey.currentState?.validate()` call on submit |
| Navigation not working | Missing route in go_router, wrong context | Verify route name, check `context.go()` vs `context.push()` |
| Memory growing on navigation | Undisposed controllers or streams | Implement `dispose()` for `AnimationController`, `TextEditingController`, subscriptions |

### Performance Bugs

| Symptom | Cause | Fix |
|---|---|---|
| UI jank during scroll | Heavy build methods, missing `const`, full list rebuild | Extract widgets, add `const`, use `ListView.builder` |
| Memory leak on screen pop | Undisposed resources | Dispose controllers in `dispose()`, cancel stream subscriptions |
| Slow first frame | Heavy work in `initState` synchronously | Defer with `WidgetsBinding.addPostFrameCallback` or `Future.microtask` |
| Unnecessary widget rebuilds | Watching too-broad a provider | Use `ref.watch(provider.select(fn))` to narrow rebuild scope |

---

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Wrapping everything in `try/catch {}` silently | Map exceptions to typed Failures at the repository boundary |
| Fixing symptoms without understanding root cause | Always run SEED analysis before touching code |
| Making a large "shotgun" fix across many files | Minimal-diff fix targeting the exact root cause |
| Skipping regression tests | Always add a test that fails before and passes after the fix |
| Mixing bug fix with refactoring in same commit | Separate bug-fix commits from refactoring commits |

## Checklist

- [ ] Full error message and stack trace read completely
- [ ] Bug reproduced consistently with exact reproduction steps
- [ ] Root cause identified using SEED framework (not just symptom)
- [ ] Smallest possible change made (minimal diff)
- [ ] Clean Architecture boundaries respected in the fix
- [ ] Regression test added (fails before fix, passes after)
- [ ] All existing tests still pass after the fix
- [ ] Fix documented in commit message with root cause explanation

## Related Skills

- `flutter-debugging` — DevTools, widget inspector, network inspector, and profiler usage
- `flutter-error-handling` — Typed failure modeling and exception propagation
- `flutter-performance` — Performance profiling for performance-related bugs
- `flutter-unit-testing` — Regression test creation patterns
- `flutter-clean-architecture` — Understanding layer boundaries for architecture bugs
