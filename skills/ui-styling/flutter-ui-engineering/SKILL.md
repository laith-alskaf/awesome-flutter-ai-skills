---
name: flutter-ui-engineering
description: >
  Use this skill when designing, building, reviewing, or refactoring Flutter user
  interfaces. Covers widget composition, Material 3 theming, responsive layouts,
  design systems, screen structure, form design, list optimization, loading/error/
  empty states, accessibility, and dark mode. Do not use for state management logic
  (use flutter-riverpod), animations (use flutter-animations), or navigation
  routing (use flutter-routing).
triggers:
  - "Design and build Flutter UI widgets"
  - "Configure Material 3 theme and design tokens"
  - "Extract reusable widgets and optimize build methods"
negative_triggers:
  - "State management logic"
  - "Animations controller setup"
  - "Navigation routing"
---

# Flutter UI Engineering

## Purpose

Build Flutter interfaces that are beautiful, reusable, responsive, accessible, and performant. Every widget must have a single responsibility. UI describes state — it never contains business logic.

## Scope

**Covers:** Widget composition, Material 3, theming, responsive design, design system tokens, screen structure, forms, lists, images, loading/error/empty states, accessibility.

**Does not cover:** Animation implementation, navigation routing, state management logic, networking.

## Technology Context

- Flutter 3.44.x with Material 3 (`useMaterial3: true`)
- Impeller rendering engine (default, optimized for smooth animations)
- `ColorScheme.fromSeed()` for dynamic theming
- Dart 3.12+ features for cleaner widget code

## Rules

### Widget Composition

- Prefer `StatelessWidget`. Use `StatefulWidget` only for local UI state (animations, controllers).
- Use `ConsumerWidget` only when watching providers.
- Maximum widget responsibility: **one concern**.
- Extract widgets when a build method exceeds ~100 lines.
- Composition over inheritance. Never create deep widget inheritance trees.

### Screen Structure

```
Scaffold
  └─ SafeArea
       └─ Page Layout (Column, CustomScrollView)
            └─ Sections
                 └─ Reusable Components
                      └─ Small Widgets
```

### Design System — No Magic Numbers

Centralize all design tokens. Never hardcode values.

```dart
// Spacing constants
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// Usage
Padding(
  padding: const EdgeInsets.all(AppSpacing.md), // Not EdgeInsets.all(16)
)
```

### Material 3 Theming

```dart
// Theme setup — always use seed color
MaterialApp(
  theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
  ),
  darkTheme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.indigo,
      brightness: Brightness.dark,
    ),
  ),
);

// Never hardcode colors — always use Theme
Text(
  'Title',
  style: Theme.of(context).textTheme.headlineMedium, // Not TextStyle(fontSize: 28)
)
Container(
  color: Theme.of(context).colorScheme.primaryContainer, // Not Colors.blue
)
```

### Responsive Design

Support all screen sizes. Never assume one screen size.

```dart
// Use LayoutBuilder for responsive decisions
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth >= 1200) return const DesktopLayout();
    if (constraints.maxWidth >= 600) return const TabletLayout();
    return const PhoneLayout();
  },
)

// Prefer flexible widgets
Expanded, Flexible, FractionallySizedBox, LayoutBuilder
// Avoid fixed sizes
SizedBox(width: 375) // Wrong — hardcoded phone width
```

### Every Screen Must Handle All States

```dart
// Always handle: Loading, Data, Error, Empty
switch (state) {
  AsyncData(value: final users) when users.isEmpty =>
    const EmptyView(message: 'No users found'),
  AsyncData(value: final users) =>
    UserListView(users: users),
  AsyncError(:final error) =>
    ErrorView(message: error.toString(), onRetry: onRetry),
  _ => const LoadingIndicator(),
}
```

### Reusable Components

Always create reusable widgets for: Buttons, Cards, Inputs, Dialogs, Bottom Sheets, App Bars, Loading Indicators, Error Views, Empty Views, List Items.

### List Optimization

```dart
// Correct — lazy building
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemCard(item: items[index]),
)

// Wrong — builds all children at once
ListView(
  children: items.map((item) => ItemCard(item: item)).toList(),
)
```

### Form Design

```dart
// Forms must support: validation, autofill, keyboard actions,
// focus management, error messages, loading state, disabled submit
TextFormField(
  autofillHints: const [AutofillHints.email],
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  validator: (value) => value?.isEmpty ?? true ? 'Email required' : null,
)
```

### Image Handling

```dart
CachedNetworkImage(
  imageUrl: url,
  placeholder: (_, __) => const ShimmerPlaceholder(),
  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
  fadeInDuration: const Duration(milliseconds: 300),
)
```

### Accessibility

- Add Semantics labels for screen readers
- Minimum touch target: 48×48
- Support dynamic font sizes (never fixed font sizes)
- Ensure sufficient color contrast (4.5:1 minimum)
- Support RTL layouts for localization

### Performance

- Use `const` constructors everywhere possible
- Extract Consumer widgets to minimize rebuild scope
- Avoid `Opacity` widget (use color alpha instead)
- Avoid `IntrinsicHeight`/`IntrinsicWidth` (expensive)
- Use `RepaintBoundary` for complex, isolated animations
- Profile with Flutter DevTools before optimizing

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| Business logic in Widget | Move to Notifier/UseCase |
| Magic numbers (`padding: 17`) | Design system tokens |
| Hardcoded colors | `Theme.of(context).colorScheme` |
| `ListView(children:)` for large data | `ListView.builder` |
| Nested FutureBuilder/StreamBuilder | Riverpod providers |
| Huge build methods (500+ lines) | Extract sub-widgets |
| Fixed width/height for layouts | Flexible/Expanded/LayoutBuilder |
| Missing error/loading/empty states | Handle all AsyncValue states |

## Checklist

- [ ] All widgets have single responsibility
- [ ] Design system tokens (no magic numbers)
- [ ] Material 3 with `ColorScheme.fromSeed()`
- [ ] Dark mode supported
- [ ] Responsive (phone, tablet, landscape)
- [ ] All screens handle loading, error, empty, data
- [ ] Lists use `.builder` constructors
- [ ] Forms have validation, autofill, keyboard actions
- [ ] Images cached with placeholder/error widgets
- [ ] Accessibility: semantics, touch targets, contrast
- [ ] `const` constructors used everywhere possible
- [ ] No business logic in widgets

## Related Skills

- `flutter-riverpod` — State management for UI
- `flutter-responsive-design` — Advanced responsive patterns
- `flutter-animations` — Animation implementation
- `flutter-accessibility` — Detailed a11y guidelines
- `flutter-localization` — i18n and RTL support
