# UI & Responsive Anti-Patterns Library

This document catalogs common presentation and layout mistakes in Flutter that cause visual overflow, hardcoded scaling issues, and accessibility failures.

---

## 1. Hardcoded Dimensions and Magic Spacing Numbers

### ❌ The Anti-Pattern
Using raw numerical literals throughout layouts for padding, margins, font sizes, and container widths.
```dart
// WRONG: Hardcoded magic numbers break visual consistency and responsive scaling
Padding(
  padding: const EdgeInsets.only(left: 17, top: 23, right: 14),
  child: Container(
    width: 375, // Hardcoded iPhone width!
    height: 60,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
  ),
)
```

### ⚠️ Why It's Harmful
- Setting fixed widths like `375` causes horizontal clipping on smaller phone viewports and ugly stretching on tablets.
- Inconsistent spacing values (`17`, `23`, `13`) destroy visual harmony and make design system updates impossible.

### ✅ The Refactored Solution
Use centralized design tokens (`AppSpacing`, `AppRadius`) and flexible layout primitives (`Expanded`, `Flexible`, `LayoutBuilder`):
```dart
Padding(
  padding: const EdgeInsets.all(AppSpacing.md),
  child: Container(
    width: double.infinity, // Adapts flexibly to parent width
    height: 60,
    decoration: BoxDecoration(borderRadius: AppRadius.card),
  ),
)
```

---

## 2. Unconstrained Text Causing RenderFlex Overflows

### ❌ The Anti-Pattern
Placing dynamic user text inside a horizontal `Row` without wrapping it in an expanding or flexible constraint.
```dart
// WRONG: Long text will throw "A RenderFlex overflowed by X pixels on the right"
Row(
  children: [
    const Icon(Icons.person),
    Text(user.veryLongEmailAddress), // Will overflow screen!
  ],
)
```

### ⚠️ Why It's Harmful
- Generates ugly yellow-and-black striped hazard boxes in debug builds and clips text ungracefully in production.

### ✅ The Refactored Solution
Wrap text in an `Expanded` or `Flexible` widget and specify overflow handling:
```dart
Row(
  children: [
    const Icon(Icons.person),
    const SizedBox(width: AppSpacing.sm),
    Expanded(
      child: Text(
        user.veryLongEmailAddress,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

---

## 3. Ignoring OS Dynamic Type and Accessibility Minimums

### ❌ The Anti-Pattern
Forcing fixed text heights or designing tiny 24x24 interactive touch icons without accessibility padding.
```dart
// WRONG: Tiny touch area fails accessibility guidelines
GestureDetector(
  onTap: () => deleteItem(),
  child: const Icon(Icons.close, size: 16),
)
```

### ⚠️ Why It's Harmful
- Users with motor impairments cannot tap tiny 16px targets without accidental misses.
- Users with visual impairments who increase OS font sizes experience broken, overlapping text boxes.

### ✅ The Refactored Solution
Ensure minimum 48x48 logical pixel touch targets using `IconButton` or explicit padding, and let text scale naturally:
```dart
IconButton(
  icon: const Icon(Icons.close),
  iconSize: 24, // IconButton automatically enforces 48x48 minimum touch target
  onPressed: () => deleteItem(),
  tooltip: 'Close',
)
```

---

## 4. UX Anti-Pattern: The Infinite Spinner

### ❌ The Anti-Pattern
Using a single `CircularProgressIndicator` centered on a white screen while loading an entire page of data.
```dart
if (isLoading) {
  return const Scaffold(body: Center(child: CircularProgressIndicator()));
}
```

### ⚠️ Why It's Harmful
- Causes high cognitive load because the user doesn't know what layout to expect.
- Makes the app feel significantly slower than it actually is (Zeigarnik Effect disruption).

### ✅ The Refactored Solution
Use a Shimmer or Skeleton layout that mirrors the final expected UI structure (refer to `flutter-micro-interactions-ux`).

---

## 5. UX Anti-Pattern: Ambiguous Error States

### ❌ The Anti-Pattern
Displaying raw exception text or a tiny snackbar when a page fails to load.
```dart
if (hasError) {
  return Text(error.toString()); // E.g., "Exception: SocketException: Failed host lookup"
}
```

### ⚠️ Why It's Harmful
- Violates Nielsen's Heuristics: "Help Users Recognize, Diagnose, and Recover from Errors".
- Users don't understand developer error codes.

### ✅ The Refactored Solution
Provide a friendly illustration, a human-readable title, and a retry CTA.
```dart
if (hasError) {
  return EmptyStateView(
    icon: Icons.wifi_off,
    title: 'Connection Lost',
    subtitle: 'We couldn\'t reach the servers. Please check your internet.',
    onRetry: () => ref.invalidate(dataProvider),
  );
}
```
