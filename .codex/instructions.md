# OpenAI Codex Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Flutter 3.44.x Stable & Dart 3.12.x Sound Null Safety, Material 3, Impeller Engine.
- Zero dynamic types & zero raw unhandled exceptions.
- Mandatory const constructors & immutable domain entities.
