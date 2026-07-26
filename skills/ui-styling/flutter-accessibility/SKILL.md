---
name: flutter-accessibility
description: >
  Use this skill when implementing or reviewing accessibility (a11y) in Flutter
  applications. Covers Semantics, screen readers, dynamic font sizes, color
  contrast, touch targets, RTL support, focus management, and motion reduction.
  Do not use for localization string management (use flutter-localization).
triggers:
  - "Implement accessibility (a11y) and screen reader semantics"
  - "Ensure 48x48 touch targets and high color contrast"
  - "Support dynamic font sizing and screen readers"
negative_triggers:
  - "Localization string management"
  - "UI layout engineering"
---

# Flutter Accessibility

## Purpose

Ensure Flutter applications are usable by everyone, including users with visual, motor, hearing, or cognitive disabilities. Accessibility is mandatory, not optional.

## Rules

### Semantics

```dart
// Add semantic labels for screen readers
Semantics(
  label: 'Delete item',
  hint: 'Double tap to remove this item from your cart',
  child: IconButton(
    icon: const Icon(Icons.delete),
    onPressed: onDelete,
  ),
)

// Exclude decorative elements
Semantics(
  excludeSemantics: true,
  child: const DecorativeBackground(),
)
```

### Touch Targets — Minimum 48×48

```dart
// Material widgets handle this by default
// For custom widgets, ensure minimum size:
SizedBox(
  width: 48,
  height: 48,
  child: GestureDetector(onTap: onTap, child: icon),
)
```

### Dynamic Font Sizes

```dart
// Respect user's text scale preference
// Use Theme.of(context).textTheme — it scales automatically
// Never set a fixed fontSize without considering textScaler

// Test with large font sizes
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(2.0)),
  child: child,
)
```

### Color Contrast

- Minimum 4.5:1 ratio for normal text
- Minimum 3:1 ratio for large text (18sp+ or 14sp+ bold)
- Never convey information through color alone
- Use `ColorScheme.fromSeed()` which generates accessible palettes

### Focus Management

```dart
// Ensure logical focus order for keyboard/TalkBack navigation
FocusTraversalGroup(
  policy: OrderedTraversalPolicy(),
  child: Column(children: [
    FocusTraversalOrder(order: const NumericFocusOrder(1), child: emailField),
    FocusTraversalOrder(order: const NumericFocusOrder(2), child: passwordField),
    FocusTraversalOrder(order: const NumericFocusOrder(3), child: loginButton),
  ]),
)
```

### Motion Reduction

```dart
// Respect user's motion preferences
final reduceMotion = MediaQuery.of(context).disableAnimations;
if (reduceMotion) {
  // Skip or simplify animations
}
```

## Checklist

- [ ] All interactive elements have Semantics labels
- [ ] Touch targets ≥ 48×48
- [ ] Dynamic font sizes respected
- [ ] Color contrast ≥ 4.5:1
- [ ] Information not conveyed by color alone
- [ ] RTL layout supported
- [ ] Focus order is logical
- [ ] Motion reduction respected
- [ ] Tested with TalkBack (Android) and VoiceOver (iOS)

## Related Skills

- `flutter-ui-engineering` — Widget design with a11y
- `flutter-localization` — RTL and string localization
