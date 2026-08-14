---
name: flutter-build-screen
description: >
  Use this skill when designing and building a new Flutter UI screen from a design
  mockup, wireframe, or requirements doc. Guides widget decomposition, state
  connection via state management (Riverpod / Bloc / Cubit / GetX), Material 3
  theming, responsive layout adjustments, and comprehensive error/loading state
  handling.
triggers:
  - "Build new Flutter screen from UI mockup or design requirement"
  - "Decompose wireframe into clean widget hierarchy"
  - "Connect UI page to state management holder"
negative_triggers:
  - "Core backend API implementation"
  - "DevOps pipeline setup"
---

# Flutter Build Screen Workflow

## Purpose

Transform visual designs into clean, performant, and responsive Flutter presentation layers without polluting the UI with business logic or rigid layouts.

## Workflow Steps

### Step 1: Deconstruct Design into Widget Hierarchy
Break down the complex screen into a tree of single-responsibility widgets:
```
Scaffold
  ├─ CustomAppBar (stateless)
  └─ SafeArea
       └─ CustomScrollView / RefreshIndicator
            ├─ SliverToBoxAdapter (HeaderSection)
            ├─ SliverGrid / SliverList (ContentSection)
            └─ SliverToBoxAdapter (FooterActions)
```

### Step 2: Define Presentation State Holder
Identify data required by the screen and bind it to the project's state management:
- **Riverpod:** `@riverpod` AsyncNotifier (`flutter-riverpod`)
- **Bloc / Cubit:** `Bloc` or `Cubit` emitting `freezed` states (`flutter-bloc` / `flutter-cubit`)
- **GetX:** `GetxController` with reactive `.obs` state (`flutter-getx`)

### Step 3: Scaffold the Main Screen Page
Build the page widget handling all possible states (loading, error, empty, data) using the project's UI consumer pattern:

```dart
// Example 1: Riverpod ConsumerWidget
class ProductDetailPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailNotifierProvider(productId));
    return Scaffold(
      body: state.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, _) => ErrorView(onRetry: () => ref.invalidate(...)),
        data: (product) => _ProductContent(product: product),
      ),
    );
  }
}

// Example 2: Bloc / Cubit BlocConsumer
class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) => state.when(
          loading: () => const CircularProgressIndicator(),
          error: (msg) => ErrorView(message: msg),
          loaded: (product) => _ProductContent(product: product),
        ),
      ),
    );
  }
}
```

### Step 4: Implement Reusable Sub-Widgets
Build extracted stateless components using design system tokens:
```dart
class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        CachedNetworkImage(imageUrl: product.imageUrl, height: 250),
        const SizedBox(height: AppSpacing.md),
        Text(product.name, style: theme.textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.sm),
        Text('\$${product.price}', style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.primary,
        )),
      ],
    );
  }
}
```

### Step 5: Add Responsive Adjustments
Use `LayoutBuilder` or `ResponsiveBuilder` if the layout must shift between mobile and tablet:
```dart
if (constraints.maxWidth >= Breakpoints.tablet) {
  // Use Row with two Expanded columns for wide screens
} else {
  // Use standard Column for mobile
}
```

### Step 6: Verify Accessibility & Localization
- [ ] Add `Semantics` to custom interactive icons or images
- [ ] Ensure all text strings use `AppLocalizations.of(context)!`
- [ ] Verify touch targets are at least 48x48 logical pixels

## Related Skills

- `flutter-ui-engineering` — Core UI guidelines
- `flutter-responsive-design` — Multi-device layout patterns
- `flutter-accessibility` — A11y rules
- `flutter-riverpod` / `flutter-bloc` / `flutter-cubit` / `flutter-getx` — State consumer patterns

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
