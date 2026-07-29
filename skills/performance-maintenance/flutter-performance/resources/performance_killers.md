# Performance Killers Anti-Patterns Library

This document catalogs common performance pitfalls in Flutter applications that cause frame jank, memory leaks, and CPU overhead.

---

## 1. Using `ListView(children: ...)` for Large Dynamic Lists

### ❌ The Anti-Pattern
Passing an unconstrained list of mapped widgets directly into a `ListView`, `GridView`, or `Column` wrapped in a `SingleChildScrollView`.
```dart
// WRONG: Instantiates all 1,000 widgets immediately on build!
ListView(
  children: products.map((p) => ProductCard(product: p)).toList(),
)
```

### ⚠️ Why It's Harmful
- Destroys frame rate and exhausts device memory by instantiating, laying out, and rendering hundreds of off-screen widgets simultaneously.
- Causes massive jank during initial screen load.

### ✅ The Refactored Solution
Always use `.builder` constructors for dynamic or large lists to enable lazy viewport rendering:
```dart
ListView.builder(
  itemCount: products.length,
  itemBuilder: (context, index) => ProductCard(product: products[index]),
)
```

---

## 2. Using `Opacity` Widget for Visual Fading or Hiding

### ❌ The Anti-Pattern
Wrapping widgets in an `Opacity` widget to change alpha transparency or temporarily hide elements in static layouts.
```dart
// WRONG: Opacity forces an expensive off-screen buffer save layer
Opacity(
  opacity: 0.5,
  child: Container(color: Colors.blue, child: const Text('Hello')),
)
```

### ⚠️ Why It's Harmful
- `Opacity` instructs the rendering engine to allocate an off-screen buffer, render the entire subtree into it, and then draw the buffer back with alpha modification.
- In lists or animations, this causes severe GPU raster jank.

### ✅ The Refactored Solution
Modify the color alpha directly or use lightweight animation alternatives:
```dart
// Static color alpha
Container(color: Colors.blue.withAlpha(128), child: const Text('Hello'));

// For animations, use FadeTransition (which modifies opacity without buffer allocation)
FadeTransition(opacity: _animation, child: const Text('Hello'));

// To hide an element without layout shift, use Visibility
Visibility(visible: isShown, maintainSize: true, maintainAnimation: true, maintainState: true, child: child);
```

---

## 3. Massive Build Methods and Missing `const` Constructors

### ❌ The Anti-Pattern
Writing 500-line `build()` methods in a single widget without extracting sub-components or utilizing `const`.
```dart
// WRONG: Any state change re-executes the entire massive tree
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
      body: Column(
        children: [
          Container(/* 100 lines of static banner code */),
          Text(user.name),
          Container(/* 200 lines of static footer code */),
        ],
      ),
    );
  }
}
```

### ⚠️ Why It's Harmful
- Whenever `userProvider` updates, Flutter must rebuild, re-evaluate, and re-layout the entire 500-line widget tree, wasting CPU cycles.

### ✅ The Refactored Solution
Extract static or independent sections into `const` stateless widgets or isolated `ConsumerWidget`s:
```dart
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: Column(
      children: [
        _StaticBanner(), // Const! Never rebuilds when user changes!
        _UserDisplayName(), // Small isolated consumer
        _StaticFooter(), // Const! Never rebuilds!
      ],
    ),
  );
}
```
