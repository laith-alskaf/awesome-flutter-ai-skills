# Flutter AI Agent Skill Framework 2026

![Flutter Version](https://img.shields.io/badge/Flutter-3.44.x%20Stable-02569B?logo=flutter&logoColor=white)
![Dart Version](https://img.shields.io/badge/Dart-3.12.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20SOLID-4CAF50)
![Skills](https://img.shields.io/badge/AI%20Skills-44%20Orthogonal-ff69b4)
![Audit Status](https://img.shields.io/badge/Audit-100%2F100%20Gold%20Certified-gold)
![License](https://img.shields.io/badge/License-MIT-green)

An enterprise-grade, contract-first **AI Engineering Operating System (OS)** designed to orchestrate autonomous AI Agents (**Antigravity**, **Claude Opus 4.6**, **Gemini CLI**, **Cursor**) for production Flutter application engineering.

It turns AI Coding Assistants into disciplined Senior Staff Software Engineers adhering to sound Clean Architecture, SOLID principles, zero-hallucination routing, and 2026 production standards.

---

## 📑 Table of Contents

- [Key Features](#-key-features)
- [Target Technology Stack](#-target-technology-stack)
- [Framework Architecture & 7 Sectors](#-framework-architecture--7-sectors)
- [The 44 Skills Directory](#-the-44-skills-directory)
- [Pluggable State Management Matrix](#-pluggable-state-management-matrix)
- [Global Installation & Deployment](#-global-installation--deployment)
- [How to Integrate in a Flutter Project](#-how-to-integrate-in-a-flutter-project)
- [Authoritative Router Manifesto](#-authoritative-router-manifesto)
- [License](#-license)

---

## 🌟 Key Features

* **Zero-Hallucination Routing:** Powered by `ROUTER_MANIFESTO.md` for instant, deterministic skill matching.
* **7 Orthogonal Engineering Sectors:** 44 core skills categorized across clean architecture, state management, UI, networking, quality, performance, and DevOps.
* **Pluggable State Matrix:** State-holder agnostic architecture supporting **Riverpod 3.x**, **Bloc 9.x**, **Cubit**, and **GetX 5.x**.
* **Global Self-Cleaning Deployment:** Multi-target PowerShell script (`deploy.ps1`) synchronizes skills and global supporting resources (`_resources/`) across all AI environments.
* **Modern Flutter 3.44 & Dart 3.12 Rules:** Native support for sound null safety, Impeller rendering, Material 3, sealed classes, pattern matching, records, and private named parameters.

---

## ⚡ Target Technology Stack

| Technology Component | Enterprise Standard |
|---|---|
| **Flutter Framework** | `3.44.x Stable` |
| **Dart SDK** | `3.12.x` (Sound Null Safety + Sealed Classes + Records) |
| **Rendering Engine** | Impeller (60/120 FPS frame budgeting default) |
| **Design System** | Material 3 (`useMaterial3: true`) |
| **iOS / macOS Dependencies** | Swift Package Manager (SwiftPM) |
| **State Management** | Riverpod 3.x / Bloc 9.x / Cubit / GetX 5.x |
| **Declarative Routing** | `go_router` + `go_router_builder` + Deep Links |
| **Networking & API** | Dio with interceptor chain + WebSockets / SSE |

---

## 🏗️ Framework Architecture & 7 Sectors

```text
flutter-skills/
├── AGENTS.md                    → Root policy instructions for Flutter workspace
├── ROUTER_MANIFESTO.md          → Capability matrix & zero-ambiguity AI skill routing
├── HOW_TO_USE.md                → Integration guide & 3 deployment workflows
├── deploy.ps1                   → Multi-target self-cleaning deployment script
├── skills/                      → 44 orthogonal SKILL.md files grouped into 7 sectors
│   ├── core-architecture/       → Clean Architecture, DI, Feature-First, Repositories, Routing (6 skills)
│   ├── state-management/        → Riverpod 3.x, Bloc 9.x, Cubit, GetX 5.x (4 skills)
│   ├── ui-styling/              → UI Engineering, Responsive, Animations, a11y, l10n, Build Screen, Web/Desktop (7 skills)
│   ├── data-networking/         → REST API, WebSockets/SSE/WebRTC, GraphQL, Firebase, Supabase, Local DB (6 skills)
│   ├── quality-testing-security/→ Unit, Widget, Integration, Golden, Generate Tests, Security, Error Handling (7 skills)
│   ├── performance-maintenance/ → Performance, App Size, Debugging, Bug Fixing, Logging, Refactoring, Background, Hardware (8 skills)
│   └── workflows-devops/        → Feature Planner, Create Feature, Code Review, Git, CI/CD, Release (6 skills)
├── templates/                   → 16 production Dart code templates (.dart.template)
├── checklists/                  → 7 operational verification checklists
├── anti-patterns/               → 5 reference anti-pattern catalogs
└── decisions/                   → 11 Architecture Decision Records (ADRs)
```

---

## 📦 The 44 Skills Directory

### 1. Core Architecture (6 Skills)
- `flutter-clean-architecture` — Production-grade layer separation (Presentation → Domain → Data).
- `flutter-dependency-injection` — Container & provider injection patterns.
- `flutter-feature-first` — Feature-based module organization.
- `flutter-repository-pattern` — Abstract domain repositories & data source orchestration.
- `flutter-project-architect` — Foundational project decision making.
- `flutter-routing` — Declarative navigation (`go_router`) & Deep Links / App Links.

### 2. State Management (4 Skills)
- `flutter-riverpod` — Riverpod 3.x with `@riverpod` code generation & `AsyncValue`.
- `flutter-bloc` — Event-driven state management with `flutter_bloc` & `freezed`.
- `flutter-cubit` — Method-driven state emission.
- `flutter-getx` — Controlled GetX reactive usage.

### 3. UI & Styling (7 Skills)
- `flutter-ui-engineering` — Widget composition & Material 3 design system.
- `flutter-responsive-design` — LayoutBuilder & adaptive multi-device breakpoints.
- `flutter-animations` — Impeller-optimized implicit/explicit animations.
- `flutter-accessibility` — Semantics, screen readers & touch targets.
- `flutter-localization` — ARB files & dynamic RTL/LTR switching.
- `flutter-build-screen` — UI mockups decomposition into widget trees.
- `flutter-web-desktop` — CanvasKit/Wasm, CORS, PWA & Desktop window management.

### 4. Data & Networking (6 Skills)
- `flutter-api-integration` — Dio networking & exception-to-failure mapping.
- `flutter-websockets` — Real-time WebSockets, SSE, WebRTC & MQTT.
- `flutter-graphql` — Ferry & graphql_flutter normalized caching.
- `flutter-firebase` — Auth, Firestore, Storage, FCM & Crashlytics.
- `flutter-supabase` — Auth, PostgREST, Storage & Realtime streams.
- `flutter-local-database` — Drift type-safe SQL persistence.

### 5. Quality, Testing & Security (7 Skills)
- `flutter-unit-testing` — Mocktail AAA unit tests for UseCases & Notifiers.
- `flutter-widget-testing` — WidgetTester interaction & state testing.
- `flutter-integration-testing` — End-to-end device testing with Patrol.
- `flutter-golden-testing` — Visual regression testing with Alchemist.
- `flutter-generate-tests` — Automated test suite generation.
- `flutter-security` — Secure storage, env obfuscation & OWASP hardening.
- `flutter-error-handling` — Sealed failure class hierarchy.

### 6. Performance & Maintenance (8 Skills)
- `flutter-performance` — DevTools memory profiler & frame jank elimination.
- `flutter-app-size` — APK/AAB/IPA size reduction & asset optimization.
- `flutter-debugging` — DevTools inspection & runtime state fixes.
- `flutter-bug-fixing` — Minimal-diff root cause bug resolution.
- `flutter-logging` — Structured logger, PII masking & Crashlytics.
- `flutter-refactoring` — Safe code modernization & widget extraction.
- `flutter-background-processing` — WorkManager background tasks & notifications.
- `flutter-media-hardware` — Camera streams, BLE, MethodChannels & Dart FFI.

### 7. Workflows & DevOps (6 Skills)
- `flutter-feature-planner` — Requirements breakdown into engineering backlogs.
- `flutter-create-feature` — End-to-end vertical-slice feature workflow.
- `flutter-code-review` — 6-step PR quality audit.
- `flutter-git` — Conventional commits & branching strategy.
- `flutter-ci-cd` — GitHub Actions & Codemagic automation.
- `flutter-release` — Fastlane Google Play & App Store automated publishing.

---

## ⚡ Global Installation & Deployment

Deploy all 44 skills and supporting framework resources (`_resources/`) globally across all AI agents on your machine in one command:

```powershell
.\deploy.ps1
```

The script automatically synchronizes skills and resources to **3 global AI target paths**:
1. `~/.gemini/config/skills/` (Gemini CLI)
2. `~/.agents/skills/` (Universal AI Agents & Claude)
3. `~/.gemini/antigravity/skills/` (Antigravity Core)

---

## 🚀 How to Integrate in a Flutter Project

Copy `AGENTS.md` and `ROUTER_MANIFESTO.md` into the root of your target Flutter application repository:

```powershell
Copy-Item .\AGENTS.md <your-flutter-project>\AGENTS.md
Copy-Item .\ROUTER_MANIFESTO.md <your-flutter-project>\ROUTER_MANIFESTO.md
```

Your AI Agent will automatically detect the project policies and capability matrix, pair-programming with Staff Engineer discipline!

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
