---
name: flutter-micro-interactions-ux
description: >
  Use this skill to elevate UI from "functional" to "premium" using Senior UX 
  design patterns. Covers Haptic Feedback, Shimmers (over Spinners), 
  Progressive Disclosure, Hero Animations, Empty/Error State Illustrations, 
  and Cognitive Load reduction.
triggers:
  - "Add loading states and error states"
  - "Improve the UX of this screen"
  - "Make the UI feel premium or native"
negative_triggers:
  - "Implement state management logic"
  - "Write unit tests"
---

# Flutter Micro-Interactions & UX Psychology

## Purpose

Elevate the user experience by implementing subtle micro-interactions, providing tactile feedback, and reducing user cognitive load. A Senior UX Designer focuses on *how the app feels*, not just how it looks.

## Rules

### 1. Tactile & Haptic Feedback
Never rely on visual feedback alone for primary actions. Use device haptics.
```dart
import 'package:flutter/services.dart';

// On primary button tap, successful save, or swipe action:
HapticFeedback.lightImpact();

// On error, deletion, or failure:
HapticFeedback.heavyImpact();
```

### 2. Loading States: Skeleton/Shimmer > Spinner
Do not use `CircularProgressIndicator` for full-page data loading. It makes the app feel slow and increases cognitive load. Use a Shimmer skeleton that mirrors the final layout.

```dart
// WRONG: User has no idea what is loading or how it will look.
if (isLoading) return const Center(child: CircularProgressIndicator());

// RIGHT: Skeleton loader sets expectations.
if (isLoading) return const ListViewSkeleton();
```

### 3. Empty & Error States: Illustrate, Don't Just State
Never show a blank white screen or a tiny text saying "No data". 
An empty state must contain:
1. An Illustration or Icon.
2. A friendly title.
3. A description of what to do next.
4. A Call to Action (CTA) button.

### 4. Progressive Disclosure (Cognitive Load Reduction)
Do not overwhelm the user with 50 settings on one page. 
Hide secondary actions behind "Advanced" accordions or separate menus. 
Break long forms into paginated `Stepper` widgets.

### 5. Seamless Transitions (SharedAxis / Hero)
Do not use harsh cuts between related screens. Use `Hero` for image transitions, and the `animations` package (`SharedAxisTransition` or `FadeThroughTransition`) for screen transitions.

```dart
// Use Hero for images shared between list and detail view
Hero(
  tag: 'product-${product.id}',
  child: Image.network(product.imageUrl),
)
```

## Checklist

- [ ] Haptic feedback (`HapticFeedback.lightImpact()`) added to all primary buttons.
- [ ] List views and detail pages use Shimmer skeletons while loading.
- [ ] Empty and Error states have a clear Call to Action (CTA).
- [ ] Complex screens use progressive disclosure to hide secondary information.
- [ ] Screen transitions are smooth and logical (not abrupt cuts).

## Related Skills

- `flutter-animations` — For implementing the actual animations (Lottie/Rive).
- `flutter-design-system-theming` — For pulling correct semantic colors for shimmers.
