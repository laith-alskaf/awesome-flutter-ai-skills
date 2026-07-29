---
name: flutter-design-system-theming
description: >
  Use this skill when defining application themes, design tokens, color palettes,
  typography scales, and shape tokens. Enforces a strict Material 3 design system
  approach where no raw colors, sizes, or text styles are used in UI code.
triggers:
  - "Create a design system"
  - "Define app colors and typography"
  - "Implement Material 3 theming and dark mode"
negative_triggers:
  - "Widget composition and layout"
  - "State management"
---

# Flutter Design System & Theming

## Purpose

Establish a robust, scalable Semantic Design System. A Senior UI/UX Architect never uses raw values (`Colors.blue`, `16.0`, `TextStyle()`) in UI code. Everything must be driven by semantic tokens via `ThemeData` and `ThemeExtension`.

## Technology Context

- Material 3 (`useMaterial3: true`)
- `ColorScheme.fromSeed()` / `ColorScheme.fromImageProvider()`
- Google Fonts / Custom Typography Scales
- `ThemeExtension` for custom tokens (Spacing, Radii, Shadows, Custom Colors)

## Rules

### 1. Semantic Color Tokens
Colors must have meaning, not just visual names.
- **Wrong:** `lightBlue`, `darkGrey`
- **Right:** `primary`, `surface`, `errorContainer`, `onPrimary`

Always use `ColorScheme.fromSeed` to generate a mathematically harmonious palette:
```dart
final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF6200EE),
    brightness: Brightness.light,
  ),
);
```

### 2. Typography Scale (Type System)
Never hardcode `fontSize` or `fontWeight` in widgets. Define them in `TextTheme`.

```dart
textTheme: const TextTheme(
  displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, letterSpacing: -0.25),
  displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
  headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
  titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
  bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
),
```
*In UI Code:* `Theme.of(context).textTheme.titleLarge`

### 3. ThemeExtensions for Custom Tokens
Material 3 doesn't cover spacing, border radii, or bespoke brand colors. Use `ThemeExtension`.

```dart
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  // ... constructor, copyWith, lerp
}
```
*In UI Code:* `Theme.of(context).extension<AppSpacing>()!.md`

### 4. Shape & Component Themes
Instead of styling every button manually, style the components at the theme level.

```dart
ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  ),
)
```

## Checklist

- [ ] Material 3 enabled.
- [ ] Colors derived from a Seed Color or strictly semantic palette.
- [ ] Light and Dark mode defined and tested.
- [ ] `TextTheme` defined across Display, Headline, Title, Body, and Label roles.
- [ ] `ThemeExtension` used for Spacing, Shadows, and Radii.
- [ ] Component Themes defined (Buttons, Inputs, Cards).
- [ ] Zero magic numbers or raw colors in UI widgets.

## Related Skills

- `flutter-ui-engineering` — Uses this design system for widgets.
- `flutter-micro-interactions-ux` — Relies on semantic tokens for states.
