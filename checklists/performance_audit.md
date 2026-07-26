# Performance Audit Checklist

Use this checklist when auditing application responsiveness, memory usage, and rendering smoothness.

## 1. Profiling & Measurement
- [ ] App tested on physical Android and iOS devices in `--profile` mode (never evaluate performance on debug builds or emulators).
- [ ] Flutter DevTools Timeline inspected for UI and Raster thread spikes (>16ms for 60fps target, >8ms for 120fps target).
- [ ] Memory allocation graph inspected during repetitive screen navigation to confirm zero heap growth leaks.

## 2. Rendering & Layout
- [ ] No `Opacity` widget used for fading or hiding content (uses `FadeTransition` or `Color.withAlpha` instead).
- [ ] No `ClipRRect` or heavy clipping applied inside scrolling list items without profiling.
- [ ] `RepaintBoundary` wraps complex, frequently animating widgets that do not affect sibling layouts.
- [ ] `itemExtent` or `prototypeItem` is specified on uniform height `ListView`s to allow O(1) scroll position calculations.

## 3. Memory & Resource Management
- [ ] All `ScrollController`, `TextEditingController`, `AnimationController`, and `StreamSubscription` instances are disposed in `dispose()`.
- [ ] Network images specify `memCacheWidth` / `memCacheHeight` to avoid decoding 4K images into memory for small UI slots.
- [ ] Heavy JSON parsing or encryption tasks are offloaded to background threads using `Isolate.run()`.
