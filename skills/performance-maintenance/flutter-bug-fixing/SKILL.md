---
name: flutter-bug-fixing
description: >
  Use this skill when analyzing, diagnosing, and resolving bugs in Flutter
  applications. Provides structured diagnostic methodology, common bug patterns,
  and systematic resolution approach. For workflow-based bug fixing, use
  flutter-fix-bug. Do not use for new feature implementation.
triggers:
  - "Diagnose, reproduce, and fix bugs in Flutter code"
  - "Perform root-cause analysis and minimal-diff bug fixing"
  - "Write regression tests for fixed bugs"
negative_triggers:
  - "New feature creation"
  - "Architecture design"
---

# Flutter Bug Fixing

## Purpose

Provide common Flutter bug patterns, diagnostic techniques, and resolution strategies to accelerate bug resolution.

## Common Bug Patterns

### Build Errors

| Error | Likely Cause | Fix |
|---|---|---|
| `type 'Null' is not a subtype of type 'X'` | Null safety violation | Check null assertions, add null checks |
| `Could not find the correct Provider` | Missing ProviderScope | Wrap app with ProviderScope |
| `RenderFlex overflowed` | Content exceeds constraints | Wrap in Flexible/Expanded/ScrollView |
| `setState() called after dispose()` | Async callback after unmount | Check `mounted` before setState |
| `MissingPluginException` | Missing platform setup | Run `flutter clean && flutter pub get` |

### Runtime Errors

| Issue | Diagnosis | Fix |
|---|---|---|
| White/blank screen | Missing return in build | Check all code paths return widgets |
| Infinite loading | Provider never resolves | Check async flow, add timeout |
| Data not refreshing | Stale provider | Use `ref.invalidate()` or `ref.refresh()` |
| Form not validating | Missing Form key | Add `GlobalKey<FormState>` |
| Navigation not working | Missing route | Check go_router configuration |

### Performance Bugs

| Symptom | Cause | Fix |
|---|---|---|
| UI jank during scroll | Heavy build methods | Extract widgets, use const |
| Memory growing | Undisposed resources | Dispose controllers, cancel subscriptions |
| Slow first frame | Too much work in initState | Defer with `WidgetsBinding.addPostFrameCallback` |

## Diagnostic Methodology

1. Read the error message completely — Dart errors are descriptive
2. Check the stack trace — find YOUR code in it (not framework code)
3. Check recent changes — `git diff` to see what changed
4. Isolate — comment out code until the bug disappears
5. Fix — address root cause, not symptom
6. Test — add regression test

## Related Skills

- `flutter-fix-bug` — Complete bug fix workflow
- `flutter-debugging` — DevTools and profiling
- `flutter-error-handling` — Error propagation

---
name: flutter-fix-bug
description: >
  Use this skill when diagnosing and fixing bugs in Flutter applications. Provides
  a systematic workflow from reproduction through root cause analysis, fix
  implementation, regression testing, and documentation. Do not use for performance
  optimization (use flutter-optimize-performance).
---

# Flutter Fix Bug Workflow

## Purpose

Systematically diagnose and resolve bugs using evidence-based analysis, preventing regressions and documenting findings.

## Workflow

### Step 1: Understand the Bug
- Read the bug description carefully
- Identify: What is expected? What actually happens?
- What platform? What device? What Flutter version?

### Step 2: Reproduce Consistently
- Find exact reproduction steps
- Reproduce on multiple devices if possible
- If cannot reproduce, gather more evidence before proceeding

### Step 3: Root Cause Analysis
```
Symptom → Evidence (logs, stack trace, screenshots)
  → Observation (what the evidence shows)
  → Root Cause (why it's happening)
  → Impact (what else is affected)
```

### Step 4: Implement Fix
- Fix the root cause, not the symptom
- Make the smallest possible change
- Follow Clean Architecture boundaries
- Ensure fix doesn't break other functionality

### Step 5: Prevent Regression
- Add unit test that fails before fix and passes after
- Add widget test if UI-related
- Verify existing tests still pass

### Step 6: Document
- Describe what caused the bug
- Describe what was changed and why
- Note any related areas that should be monitored

## Related Skills

- `flutter-debugging` — DevTools and diagnosis tools
- `flutter-error-handling` — Error propagation patterns
- `flutter-unit-testing` — Regression test creation

