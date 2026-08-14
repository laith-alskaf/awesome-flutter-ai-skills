# OpenAI Codex Rules — Flutter AI Agent Skill Framework 2026

- **Context gate:** Before modifying Flutter application code, read `.agent/PROJECT_PROFILE.md` and `.agent/CURRENT_STATE.md` when those initialized-project files exist. If a required detail is missing or requirements remain ambiguous, ask focused questions or activate `flutter-grill-me`; do not block framework maintenance because application-state files are absent.
- **State matrix:** Inspect `pubspec.yaml`, existing feature code, and the request before selecting Riverpod, Bloc, Cubit, or GetX. Do not introduce a second state-management approach in the same feature unless the user explicitly requests a documented migration.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Keep Flutter UI and state-management imports out of Domain.
- Use the Flutter and Dart versions declared by the target project. Do not upgrade framework versions unless the task requires it and compatibility is verified.
- Prefer explicit error handling, immutable domain entities, and `const` constructors where appropriate; do not impose them where they harm correctness or readability.
