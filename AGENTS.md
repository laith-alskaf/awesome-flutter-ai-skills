# AGENTS.md

## Technology Stack

- Flutter 3.44.x Stable
- Dart 3.12.x
- Material 3 (useMaterial3: true)
- Impeller rendering engine (default, no opt-out)
- SwiftPM for iOS/macOS dependencies
- Null Safety (sound)

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

## Performance

- Profile before optimizing. Never optimize based on assumption.
- Use const constructors. Extract widgets to minimize rebuilds.
- Use ListView.builder for lists. Never ListView(children:) for large data.
- Cache network images with CachedNetworkImage.
- Paginate API responses. Debounce search inputs.
- Dispose controllers and subscriptions in dispose().

## AI Agent Behavior & Context Protocol

- Follow the **8-Step Context Recovery Priority Protocol**:
  1. `.ai/PROJECT_PROFILE.md` (Static Project Identity & Stack)
  2. `AGENTS.md` (Governance Laws, Behavioral Constraints & Quality Standards)
  3. `.ai/CURRENT_STATE.md` (Active Goal, Context, Assumptions & Confidence Matrix)
  4. `.ai/KNOWLEDGE_INDEX.md` (Fast Map to ADRs, Skills & Source Folders)
  5. `.ai/AGENTS_MEMORY.md` (Working Ledger, Milestones, Health Meter & Lessons Learned)
  6. Relevant ADRs (`decisions/` or `.ai/decisions/`)
  7. Relevant Skills (`skills/`)
  8. `.ai/SESSION_LOG.md` (Chronological History Ledger)
- Enforce the **Why-What-Ready Product Pipeline** on all project initialization or feature development:
  - **WHY:** Evaluate business strategy, 7 Discovery Questions, and PRD (`.ai/PRODUCT_REQUIREMENTS.md` via `flutter-product-discovery-and-architecture`).
  - **WHAT:** Design domain entities, value objects, and DI graphs (`.ai/DOMAIN_MAP.md` via `flutter-domain-modeling`).
  - **READY:** Verify 6 production pillars and A11y gating before release (`.ai/PRODUCTION_CHECKLIST.md` via `flutter-production-readiness`).
- **Enforce the Anti-Hallucination Interrogation Gate (`grill-me`):** If project requirements, architectural boundaries, or state management rules are ambiguous, incomplete, or if the agent's calculated reasoning confidence in `.ai/CURRENT_STATE.md` is below `0.80`, the AI Agent MUST NOT generate code. Instead, immediately trigger `flutter-grill-me` to interrogate the user across 5 engineering dimensions.
- Think before coding. Follow: Understand → Analyze → Plan → Implement → Review.
- Never generate code immediately. Always understand the problem first.
- Never skip error handling, loading states, or empty states.
- Never sacrifice architecture for speed.
- If evidence is missing, ask before proceeding.
- Every recommendation must be justified with reasoning.
