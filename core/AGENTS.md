# AGENTS.md

## Technology Stack

- Treat the target project's `pubspec.yaml`, lockfiles, platform folders, and CI configuration as the source of truth for Flutter, Dart, and package versions.
- Use Flutter 3.44.x / Dart 3.12.x only as this framework's example baseline; do not upgrade a target project without an explicit compatibility decision.
- Prefer Material 3 for new UI when it matches the product design system.
- Profile and verify renderer, platform, and iOS/macOS dependency-manager choices before changing them.
- Preserve sound null safety and the target project's existing platform support.

## Build Commands

- Install dependencies: `flutter pub get`
- Code generation: `dart run build_runner build --delete-conflicting-outputs`
- Watch code generation: `dart run build_runner watch --delete-conflicting-outputs`
- Run debug: `flutter run`
- Build release Android: `flutter build appbundle --release`
- Build release iOS: `flutter build ipa --release`
- Clean project: `flutter clean && flutter pub get`
- Analyze code: `dart analyze`
- Format code: `dart format .`

## Testing

- Run all tests: `flutter test`
- Run with coverage: `flutter test --coverage`
- Run specific test: `flutter test test/path/to/test.dart`
- Run integration tests: `flutter test integration_test/`
- Golden tests update: `flutter test --update-goldens`
- Rule: All tests must pass before finalizing any code change.
- Rule: New features must include unit tests for domain logic.
- Rule: Critical UI must include widget tests.

## Code Style

- Follow official Dart style guide.
- Run `dart format .` before every commit.
- Use `dart analyze` with zero warnings policy.
- Use Dart 3.12+ features: sealed classes, pattern matching, private named parameters.
- No `dynamic` types unless strictly necessary for interoperability.
- All state models must be immutable (use freezed or sealed classes).
- Prefer `const` constructors wherever possible.
- Use `final` for all local variables that are not reassigned.
- Explicit types for public APIs, inferred types for local variables.

## Architecture

- Pattern: Feature-First + Clean Architecture.
- Each feature: `lib/features/<name>/{data, domain, presentation}/`.
- Shared code: `lib/core/` (network, errors, theme, utils) and `lib/shared/` (widgets, extensions).
- State Management (Pluggable Matrix — detect from `pubspec.yaml` or user choice):
  - `Riverpod 3.x`: Code generation with `@riverpod` annotations and `riverpod_generator`.
  - `Bloc 9.x`: Unidirectional event-driven state with `flutter_bloc` and `freezed`.
  - `Cubit`: Method-driven state emission with `flutter_bloc`.
  - `GetX 5.x`: Reactive controllers (`GetxController`) for legacy or rapid development.
- Routing: go_router with `go_router_builder` for typed routes.
- Networking: Dio with interceptor chain.
- Local Database: Drift (when required).
- Models: freezed for immutable data classes.
- Serialization: json_serializable with build_runner.
- Logging: logger package.
- Secure Storage: flutter_secure_storage.

## Dependency Flow

- Presentation → Domain → Data. Never reverse.
- Domain layer has zero Flutter imports and zero state management library imports.
- Presentation communicates only with Use Cases or State Holders (Notifiers / Blocs / Cubits / Controllers).
- Data layer implements Repository interfaces defined in Domain.
- DTOs exist only in Data layer. Entities exist only in Domain layer.
- Mapper functions convert DTOs ↔ Entities at the Repository boundary.

## Naming Conventions

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_CASE)
- Private members: `_prefixed`
- Entities: bare name (`User`, not `UserEntity`)
- DTOs: `<Name>Dto` (`UserDto`)
- Repository interfaces: `abstract class UserRepository` (in domain/)
- Repository implementations: `class UserRepositoryImpl` (in data/)
- Use Cases: `class GetUserUseCase`
- State Holders:
  - Riverpod: `class UserNotifier extends _$UserNotifier`
  - Bloc: `class UserBloc extends Bloc<UserEvent, UserState>`
  - Cubit: `class UserCubit extends Cubit<UserState>`
  - GetX: `class UserController extends GetxController`
- Failures: `sealed class UserFailure`
- Widgets: descriptive name (`UserProfileCard`, not `Card1`)

## Error Handling

- Never expose raw exceptions to the UI.
- Map all exceptions to typed Failures using sealed classes.
- Standard failures: NetworkFailure, ServerFailure, UnauthorizedFailure, ValidationFailure, CacheFailure, UnknownFailure.
- Use AsyncValue.when() or switch expressions for state handling in UI.

## Security

- Never store tokens in SharedPreferences. Use flutter_secure_storage.
- Never hardcode API keys or secrets. Use environment variables.
- Never log passwords, tokens, PII, or secrets.
- Always use HTTPS. Support certificate pinning for sensitive apps.
- Validate all user input on client and server.

## Dependency Policy (ADR-011)

- Prefer `flutter pub add`, `flutter pub remove`, `flutter pub upgrade`, and `flutter pub outdated` for ordinary dependency changes; never hand-edit generated lockfiles.
- Preserve intentional SDK constraints, dependency overrides, and workspace configuration. Edit `pubspec.yaml` directly only when the change cannot be expressed safely through the package command, and explain the reason in the change record or pull request.
- Before adding a production dependency, verify that it solves a real requirement, supports the target Flutter/Dart versions and platforms, has an acceptable license for the project, and has a credible maintenance and security posture. Record evidence proportionate to the risk; do not use a universal score or freshness threshold as a substitute for review.
- Read `core/resources/011_dependency_policy.md` for the full evaluation checklist.


## Performance

- Profile before optimizing. Never optimize based on assumption.
- Use const constructors. Extract widgets to minimize rebuilds.
- Use ListView.builder for lists. Never ListView(children:) for large data.
- Cache network images with CachedNetworkImage.
- Paginate API responses. Debounce search inputs.
- Dispose controllers and subscriptions in dispose().

## AI Agent Behavior, Personas & Context Protocol

- **Default state:** Start as the Technical Lead / Project Manager, select only the persona necessary for the task, and read the corresponding section of `core/PERSONAS.md` on demand.
- **Handoffs:** For a multi-phase or interrupted task, write a concise handoff note containing the objective, evidence, decisions, validation status, and next action. Do not create a handoff artifact for a trivial one-step change.
- **Recover context conditionally:** If the target project contains `.agent/`, read `PROJECT_PROFILE.md`, `CURRENT_STATE.md`, the relevant state record, and only the ADRs and skills needed for the task. If it does not, inspect the project README, `pubspec.yaml`, source tree, and CI configuration; create project-state files only when the user requests initialization or persistent tracking.
- **Use the Why–What–Ready pipeline proportionately:** apply discovery and a PRD to new products or materially ambiguous features, domain design to non-trivial business logic, and release-readiness checks before a release. Do not force the full pipeline on a typo fix or narrowly scoped maintenance task.
- **Resolve uncertainty safely:** If missing information changes architecture, security, data, external APIs, dependencies, or user-visible behavior, ask focused questions or document an explicit assumption before proceeding. For a reversible low-risk change, state the assumption and continue rather than inventing a numerical confidence score.
- Follow: Understand → Analyze → Plan when warranted → Implement → Validate → Report. Match the amount of process to the task risk.
- Cover error, loading, and empty states when the changed user flow can exhibit them. Preserve architecture and justify material recommendations with evidence.
