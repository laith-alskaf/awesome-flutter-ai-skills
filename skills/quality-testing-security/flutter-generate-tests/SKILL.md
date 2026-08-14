---
name: flutter-generate-tests
description: >
  Use this skill when generating automated test suites for existing Flutter code
  or new features. Guides the structured creation of unit tests for domain logic
  and repositories, widget tests for UI components, and integration tests for
  user flows following the Arrange-Act-Assert (AAA) pattern.
triggers:
  - "Generate automated test suites for a feature"
  - "Create unit and widget tests for new or existing code"
  - "Follow AAA (Arrange-Act-Assert) pattern"
negative_triggers:
  - "Manual QA testing"
  - "DevOps release pipeline"
---

# Flutter Generate Tests Workflow

## Purpose

Execute a systematic test generation workflow to achieve high confidence and code coverage without writing fragile or brittle tests. Focuses on testing behavior and contracts, not implementation details.

## Workflow Steps

### Step 1: Analyze Target Code
Identify what needs testing based on its architectural layer:
- **UseCase / Domain Logic:** Requires isolated unit tests verifying business rules and error mapping.
- **Repository Implementation:** Requires unit tests mocking remote/local data sources.
- **State Holder (Notifier / Bloc / Cubit / Controller):** Requires unit tests using `ProviderContainer` (Riverpod), `blocTest` (Bloc/Cubit), or reactive verification (GetX).
- **UI Screen / Widget:** Requires widget tests checking visual states (loading, error, empty, data) and user interaction.

### Step 2: Set Up Test Environment & Mocks
Create mocks for external dependencies using `mocktail`:
```dart
// test/helpers/test_mocks.dart
import 'package:mocktail/mocktail.dart';

class MockUserRemoteDatasource extends Mock implements UserRemoteDatasource {}
class MockUserLocalDatasource extends Mock implements UserLocalDatasource {}
class MockUserRepository extends Mock implements UserRepository {}

void registerFallbackValues() {
  registerFallbackValue(const UserDto.empty());
}
```

### Step 3: Generate Unit Tests (Domain & Data)
Follow the Arrange-Act-Assert (AAA) structure:
```dart
test('should return User when remote datasource fetch succeeds', () async {
  // Arrange
  when(() => mockRemoteDatasource.getUser('123'))
      .thenAnswer((_) async => mockUserDto);
  when(() => mockLocalDatasource.cacheUser(any()))
      .thenAnswer((_) async => {});

  // Act
  final result = await repository.getUser('123');

  // Assert
  expect(result, isA<Success<User, UserFailure>>());
  verify(() => mockRemoteDatasource.getUser('123')).called(1);
  verify(() => mockLocalDatasource.cacheUser(mockUserDto)).called(1);
});
```

### Step 4: Generate State Management Tests (Check Project Matrix)
Depending on the project's adopted state management:

**1. Riverpod Notifiers:** Test transitions inside a `ProviderContainer`:
```dart
test('should emit loading then loaded state', () async {
  final container = ProviderContainer(overrides: [...]);
  addTearDown(container.dispose);
  expect(container.read(userListProvider), const AsyncLoading());
  await container.read(userListProvider.future);
  expect(container.read(userListProvider).value, hasLength(2));
});
```

**2. Bloc / Cubit:** Test state transitions using `blocTest` from `bloc_test`:
```dart
blocTest<UserCubit, UserState>(
  'should emit [loading, loaded] when loadUsers succeeds',
  build: () {
    when(() => mockUseCase()).thenAnswer((_) async => Result.success(mockUsers));
    return UserCubit(mockUseCase);
  },
  act: (cubit) => cubit.loadUsers(),
  expect: () => [const UserState.loading(), UserState.loaded(mockUsers)],
);
```

**3. GetX Controllers:** Test reactive variables and controller lifecycle:
```dart
test('should update users rx list when loadUsers succeeds', () async {
  final controller = UserController(mockUseCase);
  await controller.loadUsers();
  expect(controller.users.length, 2);
  expect(controller.isLoading.value, false);
});
```

### Step 5: Generate Widget Tests
Test component rendering across all async states:
```dart
testWidgets('renders ErrorView and triggers retry on tap', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userListProvider.overrideWith((_) => throw const UserFailure.network())
      ],
      child: const MaterialApp(home: UserListPage()),
    ),
  );

  await tester.pumpAndSettle();
  expect(find.text('No internet connection. Check your network.'), findsOneWidget);

  await tester.tap(find.byKey(const Key('retry_button')));
  await tester.pump();
  // Verify retry action triggered
});
```

### Step 6: Verify Test Suite
Run the generated tests to ensure speed and reliability:
```bash
flutter test --coverage
```
Verify zero flaky tests and check coverage reports for domain/data layers.

## Related Skills

- `flutter-unit-testing` — Unit test assertion guidelines
- `flutter-widget-testing` — WidgetTester and UI mocking
- `flutter-integration-testing` — E2E flow testing
- `flutter-riverpod` / `flutter-bloc` / `flutter-cubit` / `flutter-getx` — State testing patterns

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
