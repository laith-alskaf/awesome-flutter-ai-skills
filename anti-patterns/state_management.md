# State Management Anti-Patterns Library

This document catalogs common state management mistakes in Flutter applications, explaining why they are harmful and demonstrating how to refactor them into clean, maintainable patterns.

---

## 1. Using `StateProvider` for Complex Business State

### ❌ The Anti-Pattern
Using simple `StateProvider` instances to hold complex domain data, form states, or objects that require asynchronous mutation and validation.
```dart
// WRONG: StateProvider cannot handle async logic or error states cleanly
final userProvider = StateProvider<User?>((ref) => null);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final errorProvider = StateProvider<String?>((ref) => null);
```

### ⚠️ Why It's Harmful
- Spreads state mutations across multiple UI widgets.
- Creates race conditions when updating multiple related providers independently.
- Impossible to encapsulate business rules, validation, or side effects.

### ✅ The Refactored Solution
Use `@riverpod` annotations with an `AsyncNotifier` or `Notifier` class that encapsulates state and business actions in one place:
```dart
@riverpod
class CurrentUser extends _$CurrentUser {
  @override
  Future<User?> build() async {
    return ref.watch(userRepositoryProvider).getCurrentUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => 
      ref.read(userRepositoryProvider).login(email, password)
    );
  }
}
```

---

## 2. Business Logic Inside UI Build Methods

### ❌ The Anti-Pattern
Executing API calls, parsing JSON, or manipulating database records directly inside a widget's `build()`, `onPressed`, or `initState` callbacks.
```dart
// WRONG: Widget directly calls Dio and manipulates state
ElevatedButton(
  onPressed: () async {
    setState(() => isLoading = true);
    try {
      final res = await Dio().post('/login', data: {'email': email});
      final user = User.fromJson(res.data);
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  },
  child: const Text('Login'),
)
```

### ⚠️ Why It's Harmful
- Violates Single Responsibility Principle (SRP); makes UI widgets impossible to unit test.
- Couples presentation directly to specific HTTP clients and JSON schemas.
- Cannot reuse the login logic elsewhere without duplicating code.

### ✅ The Refactored Solution
Delegate the action to a Notifier or UseCase, leaving the widget responsible only for triggering the event and listening for navigation side effects:
```dart
ElevatedButton(
  onPressed: () => ref.read(authNotifierProvider.notifier).login(email, password),
  child: const Text('Login'),
)
```

---

## 3. Ignoring `AsyncValue` Error and Loading States

### ❌ The Anti-Pattern
Forcing unwrapping or defaulting async providers without handling loading indicators or error feedback.
```dart
// WRONG: Silently fails or throws if state isn't loaded yet
final users = ref.watch(userListProvider).value!;
return ListView.builder(itemCount: users.length, /* ... */);
```

### ⚠️ Why It's Harmful
- Causes red-screen runtime crashes when state is loading or encounters a network failure.
- Leaves users staring at blank screens without feedback or retry options.

### ✅ The Refactored Solution
Always exhaustively pattern match using `.when()` or Dart 3 switch expressions:
```dart
ref.watch(userListProvider).when(
  data: (users) => UserListView(users: users),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, _) => ErrorView(message: err.toString(), onRetry: () => ref.invalidate(userListProvider)),
);
```
