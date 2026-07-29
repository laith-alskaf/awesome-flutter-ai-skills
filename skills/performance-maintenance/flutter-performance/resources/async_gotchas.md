# Async Gotchas & Concurrency Anti-Patterns Library

This document catalogs common asynchronous programming mistakes in Dart/Flutter that cause race conditions, unhandled exceptions, and UI freezes.

---

## 1. Calling `setState()` After Widget Disposal

### ❌ The Anti-Pattern
Executing an asynchronous operation inside a `StatefulWidget` and calling `setState()` without checking if the widget is still mounted in the widget tree.
```dart
// WRONG: Will throw "setState() called after dispose()" if user navigates away during fetch
Future<void> _loadData() async {
  final data = await api.fetchData();
  setState(() => _data = data);
}
```

### ⚠️ Why It's Harmful
- Causes red-screen exceptions and memory leak warnings in production logs.
- Can corrupt local widget state if re-mounted later.

### ✅ The Refactored Solution
Always check the `mounted` property before interacting with `setState` or `BuildContext` across async gaps (or better yet, use Riverpod which handles lifecycle automatically):
```dart
Future<void> _loadData() async {
  final data = await api.fetchData();
  if (!mounted) return;
  setState(() => _data = data);
}
```

---

## 2. Synchronous JSON Parsing on the Main Isolate

### ❌ The Anti-Pattern
Parsing huge JSON payloads (e.g., 5MB product catalogs or offline databases) directly on the UI main isolate using `jsonDecode()`.
```dart
// WRONG: Freezes the UI thread for 100-300ms during parsing!
final Map<String, dynamic> rawJson = jsonDecode(hugeResponseString);
final products = (rawJson['items'] as List).map((i) => ProductDto.fromJson(i)).toList();
```

### ⚠️ Why It's Harmful
- Dart runs on a single main thread for UI event handling and layout calculation.
- Synchronous CPU-heavy parsing blocks the event loop, causing dropped frames, stuttering animations, and unresponsive touch gestures.

### ✅ The Refactored Solution
Offload heavy computational or parsing tasks to a background isolate using `Isolate.run()`:
```dart
final products = await Isolate.run(() {
  final Map<String, dynamic> rawJson = jsonDecode(hugeResponseString);
  return (rawJson['items'] as List).map((i) => ProductDto.fromJson(i)).toList();
});
```

---

## 3. Forgetting to Dispose Controllers and Stream Subscriptions

### ❌ The Anti-Pattern
Creating `StreamSubscription`, `ScrollController`, `TextEditingController`, or `AnimationController` instances without canceling or disposing them when the widget unmounts.
```dart
// WRONG: Stream keeps listening and controller retains memory forever
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    authStream.listen((user) { /* ... */ });
  }
}
```

### ⚠️ Why It's Harmful
- Causes severe memory leaks that accumulate over time until the OS terminates the app.
- Background stream listeners continue triggering callbacks on unmounted widgets.

### ✅ The Refactored Solution
Always store subscriptions and explicitly dispose all resources in `dispose()`:
```dart
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();
  late final StreamSubscription _subscription;
  
  @override
  void initState() {
    super.initState();
    _subscription = authStream.listen((user) { /* ... */ });
  }
  
  @override
  void dispose() {
    _subscription.cancel();
    _controller.dispose();
    super.dispose();
  }
}
```
