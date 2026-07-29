---
name: flutter-animations
description: >
  Use this skill when implementing animations in Flutter. Covers implicit
  animations, explicit animations with AnimationController, Hero transitions,
  page transitions, Impeller-optimized rendering, and performance-safe animation
  patterns. Do not use for general UI design (use flutter-ui-engineering).
triggers:
  - "Implement implicit or explicit Flutter animations"
  - "Create Hero transitions or page route transitions"
  - "Optimize Impeller animation rendering at 60/120 FPS"
negative_triggers:
  - "Static UI widget building"
  - "State management setup"
---

# Flutter Animations

## Purpose

Implement purposeful, performant animations that enhance UX without degrading performance. With Impeller as default, shader compilation jank is eliminated — focus on smooth 60/120fps animations.

## Technology Context

- Impeller rendering engine (default) — no shader jank
- 120fps support on high-refresh displays
- `RepaintBoundary` for isolated animation repainting

## Rules

### Prefer Implicit Animations

```dart
// Simple — framework handles the animation
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: isExpanded ? 200 : 100,
  color: isActive ? Colors.blue : Colors.grey,
)

AnimatedOpacity(duration: duration, opacity: isVisible ? 1.0 : 0.0, child: child)
AnimatedSwitcher(duration: duration, child: currentWidget)
AnimatedPositioned(duration: duration, left: offset, child: child)
```

### Explicit Animations (When Needed)

```dart
class PulseWidget extends StatefulWidget { /* ... */ }
class _PulseWidgetState extends State<PulseWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => ScaleTransition(scale: _animation, child: widget.child);
}
```

### Hero Transitions

```dart
// Source screen
Hero(tag: 'product-${product.id}', child: ProductImage(product: product))

// Destination screen
Hero(tag: 'product-${product.id}', child: ProductDetailImage(product: product))
```

### Premium Vector Animations (Lottie & Rive)

For complex illustrations (e.g., success checkmarks, empty state illustrations, onboarding graphics), do not build them from scratch with `CustomPainter`.
- Use **Lottie** for JSON-based AfterEffects animations.
- Use **Rive** for interactive state-machine driven animations.

### Performance Rules

- Wrap animated widgets in `RepaintBoundary` to prevent full-screen repaints.
- Avoid animating `Opacity` widget — use `FadeTransition` or manipulate the color's alpha channel.
- Use `vsync: this` with `TickerProviderStateMixin`.
- Always dispose `AnimationController`.
- Respect user's motion reduction preference (`MediaQuery.of(context).disableAnimations`).

## Related Skills

- `flutter-ui-engineering` — Widget composition
- `flutter-performance` — Animation performance profiling
