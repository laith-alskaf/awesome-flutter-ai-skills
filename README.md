# Awesome Flutter AI Agent Skills 2026

![Flutter Version](https://img.shields.io/badge/Flutter-3.44.x%20Stable-02569B?logo=flutter&logoColor=white)
![Dart Version](https://img.shields.io/badge/Dart-3.12.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20SOLID-4CAF50)
![Skills](https://img.shields.io/badge/AI%20Skills-44%20Orthogonal-ff69b4)
![Audit Status](https://img.shields.io/badge/Audit-100%2F100%20Gold%20Certified-gold)
![License](https://img.shields.io/badge/License-MIT-green)

An enterprise-grade, contract-first **AI Engineering Skill Framework & Multi-IDE Rules Generator** designed to orchestrate autonomous AI Agents (**Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, **Roo Code**, **GitHub Copilot**) for production Flutter application engineering.

It turns AI Coding Assistants into disciplined Senior Staff Software Engineers adhering to sound Clean Architecture, SOLID principles, zero-hallucination routing, and 2026 production standards.

---

## ⚡ Universal One-Line Quick Start (For ALL AI Agents & IDEs)

Install and activate all 44 skills and IDE rules globally across **Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, and **GitHub Copilot** with a single command:

### PowerShell (Windows)
```powershell
irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/deploy.ps1 | iex
```

### Local Repository Deployment
```powershell
.\deploy.ps1
```

---

## 🌐 Supported AI Agents & IDE Matrix

`deploy.ps1` automatically synchronizes skills and global supporting resources (`_resources/`) to **6 Global AI Agent Paths** and injects project-level rules:

| Agent / IDE Platform | Target Path / Rule File | Supported Format |
|---|---|---|
| **Antigravity AI Agent** | `~/.gemini/antigravity/skills/` | Native `SKILL.md` + `_resources/` |
| **Gemini CLI Agent** | `~/.gemini/config/skills/` | Native `SKILL.md` + `_resources/` |
| **Claude & Universal Agents** | `~/.agents/skills/` | Native `SKILL.md` + `_resources/` |
| **OpenAI Codex Cloud Agent** | `~/.codex/skills/` & `.codex/instructions.md` | Codex Cloud Agent Rules |
| **Cursor IDE** | `~/.cursor/skills/` & `.cursorrules` | Project Rules & MDC |
| **Windsurf IDE** | `~/.windsurf/skills/` & `.windsurfrules` | Cascade System Rules |
| **Roo Code / Cline / VS Code**| `.clinerules` & `.github/copilot-instructions.md` | Copilot & Custom Modes |

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
awesome-flutter-ai-skills/
├── AGENTS.md                    → Root policy instructions for Flutter workspace
├── ROUTER_MANIFESTO.md          → Capability matrix & zero-ambiguity AI skill routing
├── HOW_TO_USE.md                → Integration guide & deployment workflows
├── deploy.ps1                   → Universal multi-agent & multi-IDE deployment script
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

## 📦 The 44 Skills Directory Summary

1. **Core Architecture (6 Skills):** `flutter-clean-architecture`, `flutter-dependency-injection`, `flutter-feature-first`, `flutter-repository-pattern`, `flutter-project-architect`, `flutter-routing`.
2. **State Management (4 Skills):** `flutter-riverpod`, `flutter-bloc`, `flutter-cubit`, `flutter-getx`.
3. **UI & Styling (7 Skills):** `flutter-ui-engineering`, `flutter-responsive-design`, `flutter-animations`, `flutter-accessibility`, `flutter-localization`, `flutter-build-screen`, `flutter-web-desktop`.
4. **Data & Networking (6 Skills):** `flutter-api-integration`, `flutter-websockets`, `flutter-graphql`, `flutter-firebase`, `flutter-supabase`, `flutter-local-database`.
5. **Quality, Testing & Security (7 Skills):** `flutter-unit-testing`, `flutter-widget-testing`, `flutter-integration-testing`, `flutter-golden-testing`, `flutter-generate-tests`, `flutter-security`, `flutter-error-handling`.
6. **Performance & Maintenance (8 Skills):** `flutter-performance`, `flutter-app-size`, `flutter-debugging`, `flutter-bug-fixing`, `flutter-logging`, `flutter-refactoring`, `flutter-background-processing`, `flutter-media-hardware`.
7. **Workflows & DevOps (6 Skills):** `flutter-feature-planner`, `flutter-create-feature`, `flutter-code-review`, `flutter-git`, `flutter-ci-cd`, `flutter-release`.

---

## 🚀 How to Integrate in Any Project

Copy `AGENTS.md` and `ROUTER_MANIFESTO.md` into your Flutter application repository:

```powershell
Copy-Item .\AGENTS.md <your-flutter-project>\AGENTS.md
Copy-Item .\ROUTER_MANIFESTO.md <your-flutter-project>\ROUTER_MANIFESTO.md
```

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
