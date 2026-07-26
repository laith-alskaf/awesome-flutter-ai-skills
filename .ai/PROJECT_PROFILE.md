# PROJECT_PROFILE.md — Static Project Identity & Technical Stack Specification

```yaml
# Core Project Metadata
ProjectName: "awesome-flutter-ai-skills"
Purpose: "Enterprise Flutter AI Agent Operating Framework"
TargetPlatforms: ["iOS", "Android", "Web", "macOS", "Windows", "Linux"]
LastUpdated: "2026-07-26"

# Technology Stack Specifications
FlutterVersion: "3.44.x Stable"
DartVersion: "3.12.x"
RenderingEngine: "Impeller"
DesignSystem: "Material 3 (useMaterial3: true)"
ArchitecturePattern: "Clean Architecture + Feature-First Layer Separation"

# Domain & Infrastructure Choices
StateManagement: "Riverpod 3.x / Bloc 9.x / Cubit / GetX 5.x"
Routing: "go_router with go_router_builder"
Networking: "Dio with custom interceptor chain"
LocalDatabase: "Drift (Type-safe SQL) / Hive / SharedPreferences"
SecureStorage: "flutter_secure_storage"
Serialization: "freezed + json_serializable"
DependencyInjection: "Riverpod Providers / get_it + injectable"
Localization: "flutter_localizations (ARB files, RTL/LTR sound support)"

# Quality & Verification Baseline
TestingFrameworks: ["flutter_test", "integration_test", "alchemist", "mocktail"]
CICDPipeline: "GitHub Actions / Codemagic / Fastlane"
SigningStrategy: "Android App Bundle (AAB) & iOS IPA with SwiftPM"
```

## 📐 Architecture Layer Boundaries

```text
lib/
├── awesome_flutter_ai_skills.dart → Library Entry Point
└── src/
    ├── commands/   → CLI Command Handlers (init, doctor, sync)
    ├── generators/ → Rules Generators (Cursor, Windsurf, Copilot)
    └── utils/      → Environment Paths & Terminal Logger
```
