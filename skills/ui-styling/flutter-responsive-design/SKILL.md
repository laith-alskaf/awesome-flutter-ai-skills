---
name: flutter-responsive-design
description: >
  Use this skill when implementing responsive and adaptive layouts for Flutter
  applications across phones, tablets, foldables, landscape, and desktop. Covers
  breakpoints, LayoutBuilder, adaptive widgets, responsive spacing, and
  platform-adaptive UI. Do not use for general widget design (use
  flutter-ui-engineering) or accessibility features (use flutter-accessibility).
triggers:
  - "Implement responsive layouts for mobile/tablet/desktop"
  - "Use LayoutBuilder and adaptive breakpoints"
  - "Design multi-column responsive grids"
negative_triggers:
  - "Single mobile screen layout"
  - "Accessibility semantic labels"
---

# Flutter Responsive Design

## Purpose

Build interfaces that adapt gracefully to all screen sizes and orientations without hardcoded dimensions.

## Rules

### Breakpoint System

```dart
abstract final class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

// Responsive builder
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.mobile,
    this.tablet,
    this.desktop,
    super.key,
  });
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth >= Breakpoints.desktop) return desktop ?? tablet ?? mobile;
      if (constraints.maxWidth >= Breakpoints.tablet) return tablet ?? mobile;
      return mobile;
    },
  );
}
```

### Responsive Patterns

```dart
// Adaptive grid columns
GridView.builder(
  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 300,  // Auto-adjusts columns to screen width
    mainAxisSpacing: AppSpacing.md,
    crossAxisSpacing: AppSpacing.md,
  ),
)

// Adaptive padding
EdgeInsets.symmetric(
  horizontal: constraints.maxWidth > Breakpoints.tablet ? 48 : 16,
)
```

### Rules

- Never use fixed widths for page-level layout
- Prefer `Expanded`, `Flexible`, `FractionallySizedBox`
- Use `LayoutBuilder` for responsive decisions (not `MediaQuery` for layout)
- Use `MediaQuery` only for: status bar height, text scale factor, platform brightness
- Test on: small phone (360px), large phone (414px), tablet (768px), landscape

### Preventing RenderFlex Overflow

One of the most common UI bugs is `RenderFlex overflowed by X pixels`. To prevent this:
1. **Wrap Text in Flexible/Expanded:** When a `Text` widget is inside a `Row`, wrap it in `Expanded` so it wraps to the next line instead of overflowing.
2. **Handle Text Scaling:** Users may increase OS font sizes up to 300%. Never hardcode Heights for containers holding Text.
3. **Use Wrap instead of Row:** When items might overflow horizontally (e.g., chips, tags), use `Wrap` instead of `Row`.
4. **Scrollable Layouts:** Wrap your main Column in a `SingleChildScrollView` to ensure it can scroll on smaller screens.

## Related Skills

- `flutter-ui-engineering` — Widget composition
- `flutter-accessibility` — Adaptive accessibility

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
