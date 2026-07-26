---
name: flutter-performance
description: >
  Use this skill when profiling, analyzing, debugging, or optimizing Flutter
  application performance including rendering, memory, CPU, GPU, startup time,
  scrolling, battery life, and app size. Always profiles before optimizing —
  never guesses. Requires measurable evidence before any recommendation. Do not
  use for general code quality (use flutter-code-review) or app size reduction
  specifics (use flutter-app-size).
triggers:
  - "Profile and optimize Flutter app performance"
  - "Diagnose frame jank, memory leaks, and CPU/GPU bottlenecks"
  - "Verify Impeller rendering at 60/120 FPS"
negative_triggers:
  - "App binary size reduction"
  - "General code quality review"
---

# Flutter Performance Expert

## Purpose

Maximize application responsiveness, frame stability, memory efficiency, and battery life through evidence-based optimization. Performance is an engineering discipline — not trial and error.

## Scope

**Covers:** Rendering pipeline, Impeller profiling, widget rebuilds, memory leaks, CPU/GPU analysis, startup optimization, scroll performance, battery, DevTools usage.

**Does not cover:** App binary size optimization, general code quality review.

## Technology Context

- Flutter 3.44.x with Impeller rendering engine (default, no Skia fallback on Android 10+)
- Flutter DevTools for profiling
- Dart VM and isolates for CPU-intensive work
- 120fps target on high-refresh displays

## Rules

### Fundamental Law

**Never optimize blindly. Always: Measure → Analyze → Locate Bottleneck → Estimate Impact → Optimize → Measure Again → Compare → Document.**

If there are no measurable gains, the optimization must be reconsidered.

### Performance Budget

| Metric | Target |
|---|---|
| Cold Start | < 2 seconds |
| Warm Start | < 500ms |
| Frame Time (60fps) | < 16ms |
| Frame Time (120fps) | < 8ms |
| Memory | Stable growth, no leaks |
| Jank | 0% |
| Dropped Frames | Minimal |
| Battery | Minimal background usage |

### Bottleneck Classification

Always identify the primary bottleneck first. Never optimize multiple simultaneously.

```
Application feels slow
  ↓ UI freezing? → CPU analysis
  ↓ Dropped frames? → Rendering analysis (Impeller timeline)
  ↓ Memory growing? → Memory analysis (DevTools heap)
  ↓ Slow startup? → Startup analysis (timeline events)
  ↓ Slow scrolling? → List analysis (builder patterns)
  ↓ Battery drain? → Background analysis (isolates, timers)
```

### Root Cause Analysis

Before any recommendation: Symptom → Evidence → Root Cause → Impact → Optimization Strategy → Expected Improvement → Verification Method.

### Severity Classification

| Severity | Examples |
|---|---|
| **Critical** | Freezes, memory leaks, crashes, extreme jank |
| **High** | Scrolling issues, slow startup, heavy animations |
| **Medium** | Large rebuilds, slow API rendering, image loading |
| **Low** | Minor repaint, small allocations, micro-optimizations |

### Widget Optimization

```dart
// Use const constructors
const Text('Hello');
const SizedBox(height: 16);
const Icon(Icons.home);

// Extract widgets to minimize rebuild scope
// Wrong — entire screen rebuilds
class MyPage extends ConsumerWidget {
  Widget build(context, ref) {
    final count = ref.watch(counterProvider);
    return Column(children: [
      const HeavyHeader(),     // Rebuilds unnecessarily!
      Text('Count: $count'),
    ]);
  }
}

// Correct — only counter text rebuilds
class MyPage extends StatelessWidget {
  Widget build(context) => Column(children: [
    const HeavyHeader(),       // Const — never rebuilds
    const CounterDisplay(),    // Isolated consumer
  ]);
}
class CounterDisplay extends ConsumerWidget {
  const CounterDisplay();
  Widget build(context, ref) {
    final count = ref.watch(counterProvider);
    return Text('Count: $count');
  }
}
```

### List Performance

- Always use `ListView.builder` or `SliverList.builder` for dynamic lists
- Add `const` item separators
- Use `itemExtent` when item height is fixed (enables O(1) scroll position calculation)
- Use `AutomaticKeepAliveClientMixin` sparingly for tab preservation

### Image Performance

- Use `CachedNetworkImage` with placeholder
- Set `cacheWidth`/`cacheHeight` to display size (prevents decoding full resolution)
- Use WebP format where possible
- Lazy load below-fold images

### Isolate Usage

```dart
// Move heavy computation off the main thread
final result = await Isolate.run(() => parseHugeJson(rawData));
```

### Impeller Shader Warmup & Rendering Gotchas

- **Custom Shaders & Paint:** On Impeller (Metal/Vulkan), pre-warm complex custom shaders during app startup or splash screen to prevent shader compilation stutter on first frame render.
- **SaveLayer Penalties:** Avoid unnecessary `Canvas.saveLayer()` calls in custom rendering; Impeller handles opacity and blending more efficiently when applied directly to paint objects or using alpha properties.
- **Multi-Platform Verification:** Always verify visual rendering and raster cache performance across both iOS (Metal/Impeller) and Android (Vulkan/Impeller) using alchemist golden regression tests.

### Golden Rules

1. Architecture affects performance more than widget count
2. Widget rebuilds matter more than widget count
3. Measure before optimizing
4. Avoid premature optimization
5. Never sacrifice readability without measurable gains
6. Optimize user experience — not benchmarks
7. Every optimization must be reversible

## Anti-Patterns

| Anti-Pattern | Impact |
|---|---|
| Optimizing without profiling | Wastes time, may degrade readability |
| `ListView(children:)` for large data | Builds all items upfront |
| Missing `const` constructors | Unnecessary rebuilds |
| `Opacity` widget for hiding | Creates extra layer; use color alpha |
| `IntrinsicHeight` in lists | O(n) layout calculation |
| JSON parsing on main thread | UI jank during deserialization |
| Missing `RepaintBoundary` | Unnecessary repaints cascade |

## Checklist

- [ ] Profiled with DevTools before optimizing
- [ ] Primary bottleneck identified and classified
- [ ] Root cause analysis documented
- [ ] `const` constructors used everywhere possible
- [ ] Lists use `.builder` constructors
- [ ] Images cached with size constraints
- [ ] Heavy work runs in isolates
- [ ] No Opacity widgets (use color alpha)
- [ ] Consumer widgets extracted for minimal rebuilds
- [ ] Before/after measurements documented

## Related Skills

- `flutter-app-size` — Binary size optimization
- `flutter-debugging` — DevTools and Impeller timeline usage
- `flutter-ui-engineering` — Widget composition patterns

## Optimization Workflow Steps

### Step 1: Establish Baseline Measurements
Never touch code before measuring existing metrics on a **physical device** in `--profile` mode:
```bash
flutter run --profile
```
- Open Flutter DevTools (Performance / Timeline tab)
- Record a trace while reproducing the slow interaction or scrolling jank
- Note frame build times (must be <16ms for 60fps, <8ms for 120fps)
- Check memory heap allocation graphs for growth trends

### Step 2: Categorize the Bottleneck
Analyze the timeline trace to pinpoint the exact root cause:
- **UI Thread / Build Jank:** Widget tree takes too long to build. Likely caused by massive build methods, missing `const`, or Provider over-rebuilding.
- **Raster / GPU Jank:** Impeller takes too long to render. Likely caused by complex clipping (`ClipRRect`), overdraw, or blur effects (`BackdropFilter`).
- **Main Thread Stutter:** UI freezes during data parsing. Caused by synchronous JSON deserialization or heavy loops on the main isolate.
- **Memory Leak:** Heap grows continuously on screen navigation without dropping during garbage collection.

### Step 3: Execute Targeted Optimization

#### For UI Rebuild Jank:
- Extract inline widget creation into separate `StatelessWidget` classes with `const` constructors
- Replace general `ref.watch(provider)` calls with filtered `ref.watch(provider.select((v) => v.property))` to prevent rebuilds when unrelated state changes
- Replace `ListView(children: ...)` with `ListView.builder` for lazy rendering

#### For Main Thread Stutter:
- Move JSON deserialization or data processing to background isolates:
```dart
final users = await Isolate.run(() => parseUsersJson(responseBody));
```

#### For Image & Memory Optimization:
- Constraint decoded image sizes in memory:
```dart
CachedNetworkImage(
  imageUrl: url,
  memCacheWidth: 600, // Do not decode 4K images into memory for phone screens
)
```
- Ensure controllers (`ScrollController`, `TextEditingController`, `AnimationController`) and stream subscriptions are canceled in `dispose()`.

### Step 4: Verify with Post-Optimization Profiling
- Re-run the exact same user scenario in `--profile` mode
- Record a new DevTools timeline trace
- Compare baseline vs. optimized metrics:
  - Average frame time reduced?
  - Dropped frames eliminated?
  - Memory heap stabilized?

### Step 5: Document Results
Record the optimization in commit messages or PR descriptions:
```
perf(feed): reduce list scroll frame time from 24ms to 6ms

- Extract PostCard into const widget
- Add memCacheWidth=600 to image loading
- Use select() on user provider to avoid rebuilds on like toggle
```

## Related Skills

- `flutter-performance` — Core performance rules and benchmarks
- `flutter-debugging` — DevTools profiling techniques
- `flutter-app-size` — Binary and asset size optimization

