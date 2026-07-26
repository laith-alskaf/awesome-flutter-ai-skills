---
name: flutter-unit-testing
description: >
  Use this skill when writing, reviewing, or designing unit tests for Flutter
  applications. Covers testing UseCases, Repositories, Notifiers, Blocs, services,
  and utilities using mockito/mocktail, test organization, assertion patterns, and
  coverage targets. Do not use for widget tests (use flutter-widget-testing) or
  integration tests (use flutter-integration-testing).
triggers:
  - "Write unit tests for UseCases, Repositories, or State Holders"
  - "Mock dependencies using mocktail or mockito"
  - "Test domain logic and data mapping in isolation"
negative_triggers:
  - "UI Widget testing"
  - "Integration E2E testing"
---

# Flutter Unit Testing

## Purpose

Ensure business logic correctness through isolated, fast, deterministic unit tests. Every UseCase and Repository must be unit tested.

## Technology Context

- `test` package for assertions
- `mocktail` (preferred) or `mockito` for mocking
- `bloc_test` for Bloc/Cubit testing
- Riverpod `ProviderContainer` for provider testing
- Coverage target: 80%+ for domain layer, 90%+ for critical business logic

## Rules

### Test Organization

```
test/
  features/
    authentication/
      domain/
        usecases/
          login_usecase_test.dart
      data/
        repositories/
          auth_repository_impl_test.dart
    home/
      ...
  core/
    network/
      api_client_test.dart
```

### Naming Convention

```dart
test('should return User when login succeeds with valid credentials', () {});
test('should return InvalidCredentials failure when password is wrong', () {});

// Group by method
group('LoginUseCase', () {
  group('call', () {
    test('returns success with valid credentials', () {});
    test('returns failure when network is unavailable', () {});
  });
});
```

### UseCase Testing

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  test('delegates to repository and returns user', () async {
    const user = User(id: '1', name: 'Test', email: 'test@test.com');
    when(() => mockRepository.login(email: any(named: 'email'), password: any(named: 'password')))
        .thenAnswer((_) async => const Success(user));

    final result = await useCase(email: 'test@test.com', password: 'pass123');

    expect(result, isA<Success<User, AuthFailure>>());
    verify(() => mockRepository.login(email: 'test@test.com', password: 'pass123')).called(1);
  });
}
```

### Riverpod Provider Testing

```dart
test('UserNotifier loads users on build', () async {
  final container = ProviderContainer(overrides: [
    userRepositoryProvider.overrideWithValue(MockUserRepository()),
  ]);
  addTearDown(container.dispose);

  // Wait for async build
  await container.read(userListProvider.future);
  final state = container.read(userListProvider);

  expect(state.value, hasLength(3));
});
```

### Arrange-Act-Assert Pattern

```dart
test('description', () async {
  // Arrange — setup mocks and data
  when(() => mockRepo.getUsers()).thenAnswer((_) async => Success(users));

  // Act — execute the unit under test
  final result = await useCase();

  // Assert — verify the outcome
  expect(result, isA<Success>());
  verify(() => mockRepo.getUsers()).called(1);
  verifyNoMoreInteractions(mockRepo);
});
```

## Checklist

- [ ] All UseCases have unit tests
- [ ] All Repository implementations tested with mocked datasources
- [ ] Success, failure, and edge cases covered
- [ ] Mocks use mocktail (registerFallbackValue for complex types)
- [ ] Tests follow Arrange-Act-Assert pattern
- [ ] Tests are independent (no shared mutable state)
- [ ] Coverage ≥ 80% for domain layer

## Related Skills

- `flutter-widget-testing` — UI testing
- `flutter-integration-testing` — End-to-end testing
- `flutter-riverpod` — Provider testing patterns
- `flutter-bloc` — bloc_test patterns
