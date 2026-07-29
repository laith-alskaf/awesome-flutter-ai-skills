# Awesome Flutter AI Agent Skills 2026

![Flutter Version](https://img.shields.io/badge/Flutter-3.44.x%20Stable-02569B?logo=flutter&logoColor=white)
![Dart Version](https://img.shields.io/badge/Dart-3.12.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20SOLID-4CAF50)
![Skills](https://img.shields.io/badge/AI%20Skills-49%20Orthogonal-ff69b4)
![Knowledge Architecture](https://img.shields.io/badge/Knowledge%20OS-5--Tier-purple)
![Audit Status](https://img.shields.io/badge/Audit-100%2F100%20Gold%20Certified-gold)
![License](https://img.shields.io/badge/License-MIT-green)

An enterprise-grade **Flutter AI Agent Engineering Operating Framework & Multi-IDE Rules Generator** designed to orchestrate autonomous AI Agents (**Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, **Roo Code**, **GitHub Copilot**) for production Flutter application engineering.

It turns AI Coding Assistants into disciplined Senior Staff Software Engineers adhering to sound Clean Architecture, SOLID principles, zero-hallucination routing, and 2026 production standards.

---

## 📑 Table of Contents

- [Why Awesome Flutter AI Skills?](#-why-awesome-flutter-ai-skills)
- [Universal One-Line Quick Start](#-universal-one-line-quick-start-for-all-ai-agents--ides)
- [Supported AI Agents & IDE Matrix](#-supported-ai-agents--ide-matrix)
- [Target Technology Stack](#-target-technology-stack)
- [Framework Architecture & 7 Sectors](#-framework-architecture--7-sectors)
- [The 51 skills Directory Summary](#-the-51-skills-directory-summary)
- [How to Integrate in Any Project](#-how-to-integrate-in-any-project)
- [Contributing](#-contributing)
- [License](#-license)

---

## 💡 Why Awesome Flutter AI Skills?

Standard AI coding assistants often generate fragmented code, mix UI logic with business logic, use outdated Flutter/Dart packages, or hallucinate non-existent state management APIs.

**Awesome Flutter AI Skills** solves this by providing:
1. **Deterministic Skill Routing & Anti-Hallucination Gate:** Prevents AI hallucinations using structured YAML triggers and rigorous project interrogation (`flutter-grill-me`) when requirements or confidence (< 0.80) are ambiguous.
2. **Zero-Deprecation Guarantee:** Strictly targets **Flutter 3.44.x Stable** and **Dart 3.12.x** with sound null safety, Impeller engine, and Material 3.
3. **Pluggable State Management & Architecture Firewall:** Dynamic support for Riverpod 3.x, Bloc 9.x, Cubit, and GetX 5.x while enforcing absolute Clean Architecture domain isolation via automated linting (`verify_architecture.dart`).
4. **Universal Atomic Deployment Engine:** One script (`deploy.ps1`) deploys and staging-verifies rules globally across Antigravity, Gemini CLI, Claude, OpenAI Codex Cloud, Cursor, Windsurf, and VS Code Copilot.

---

## ⚡ Universal One-Line Quick Start (For ALL AI Agents & IDEs)

Install and activate all 51 skills and IDE rules globally across **Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, and **GitHub Copilot** with a single command:

### PowerShell (Windows)
```powershell
irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/tools/deploy.ps1 | iex
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
| **Antigravity AI Agent** | `~/.gemini/antigravity/knowledge/` | **Knowledge Items (KI)** + Native Skills |
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

## 🏗️ Framework Architecture & 7 Sectors (V2 AI Engineering OS)

```text
awesome-flutter-ai-skills/
├── .agent/                         → Project-level active working memory (PRD, domain maps)
├── core/                        → The OS Kernel
│   ├── AGENTS.md                → Master Policy, Tech Stack, and Context Protocols
│   ├── ROUTER_MANIFESTO.md      → Global Capability Matrix & Zero-Hallucination Gatekeeper
│   ├── PERSONAS.md              → Definition of 5 strict AI Roles (CPO, Architect, QA, etc.)
│   ├── GOVERNANCE.md            → Versioning, Ownership, and Deprecation Lifecycle
│   └── PERFORMANCE_METRICS.md   → Token Budgets and Framework KPIs
├── tools/                       → Executable OS Utilities
│   ├── verify_architecture.dart → Linter for Clean Architecture isolation
│   ├── audit_framework.dart     → CI/CD validator for token limits and Knowledge Graph
│   ├── deploy.ps1               → Global multi-agent deployment engine
│   └── init-project.ps1         → Project-level workspace initializer
└── skills/                      → 51 Self-Contained Modular Skills in 7 Sectors
    ├── core-architecture/       → Clean Architecture, DI, Domain Modeling (8 skills)
    ├── state-management/        → Riverpod 3.x, Bloc 9.x, Cubit, GetX 5.x (4 skills)
    ├── ui-styling/              → UI Engineering, Responsive, Animations (9 skills)
    ├── data-networking/         → REST API, WebSockets, Firebase, Supabase (6 skills)
    ├── quality-testing-security/→ Unit, Widget, Integration, Security (7 skills)
    ├── performance-maintenance/ → Performance, App Size, Debugging, Refactoring (8 skills)
    └── workflows-devops/        → Feature Planner, Code Review, Grill-Me, DevOps (9 skills)
```

> **Note on Modularity:** Every skill in `skills/` is a self-contained module containing its own `metadata.yaml` (Knowledge Graph), `templates/`, and `resources/`. This guarantees O(1) context loading and prevents LLM token bloat.

---

## 📦 The 51 skills Directory Summary

1. **Core Architecture (8 Skills):** `flutter-clean-architecture`, `flutter-dependency-injection`, `flutter-domain-modeling`, `flutter-feature-first`, `flutter-product-discovery-and-architecture`, `flutter-project-architect`, `flutter-repository-pattern`, `flutter-routing`.
2. **State Management (4 Skills):** `flutter-riverpod`, `flutter-bloc`, `flutter-cubit`, `flutter-getx`.
3. **UI & Styling (9 Skills):** `flutter-design-system-theming`, `flutter-micro-interactions-ux`, `flutter-ui-engineering`, `flutter-responsive-design`, `flutter-animations`, `flutter-accessibility`, `flutter-localization`, `flutter-build-screen`, `flutter-web-desktop`.
4. **Data & Networking (6 Skills):** `flutter-api-integration`, `flutter-websockets`, `flutter-graphql`, `flutter-firebase`, `flutter-supabase`, `flutter-local-database`.
5. **Quality, Testing & Security (7 Skills):** `flutter-unit-testing`, `flutter-widget-testing`, `flutter-integration-testing`, `flutter-golden-testing`, `flutter-generate-tests`, `flutter-security`, `flutter-error-handling`.
6. **Performance & Maintenance (8 Skills):** `flutter-performance`, `flutter-app-size`, `flutter-debugging`, `flutter-bug-fixing`, `flutter-logging`, `flutter-refactoring`, `flutter-background-processing`, `flutter-media-hardware`.
7. **Workflows & DevOps (9 Skills):** `flutter-agent-memory`, `flutter-ci-cd`, `flutter-code-review`, `flutter-create-feature`, `flutter-feature-planner`, `flutter-git`, `flutter-grill-me`, `flutter-production-readiness`, `flutter-release`.

---

## 🚀 Deployment & Usage Modes (Local vs. Global)

The framework supports two distinct deployment architectures. **We strongly recommend the Local (`.agent/`) Mode** for enterprise teams, version-controlled repositories, and isolated project governance.

### 📊 Comparison & Selection Guide

| Feature / Aspect | 🏠 Local Mode (`.agent/` Mode) — ⭐ RECOMMENDED | 🌐 Global Mode (Multi-IDE Global Sync) |
|---|---|---|
| **Installation Path** | Inside your target project root: `<project>/.agent/` | User OS profile: `~/.gemini/skills`, `~/.cursor/skills`, etc. |
| **Project Isolation** | **100% Isolated.** Each project maintains its own stack, skills, and memory. | **Shared across OS.** All projects share the exact same global skill versions. |
| **Team Collaboration** | **Team-Ready.** Easily shared via Git or excluded cleanly via `.gitignore`. | **Individual-Only.** Requires every developer to run global deploy script. |
| **Root Clutter** | **Zero Clutter.** Everything lives inside `.agent/`. | **Zero Clutter.** Lives in user profile directory. |
| **IDE Auto-Wiring** | Automatically creates `.cursorrules`, `.windsurfrules`, `.clinerules`, and **Antigravity Knowledge Items (KI)** pointing to `.agent/`. | Requires manual IDE configuration or global storage lookup. |
| **Best Used For** | Production apps, team repositories, CI/CD pipelines, offline workflows. | Quick scripts, prototyping, or cross-language workspace experimentation. |

---

### 🏠 1. Local Mode (`.agent/` Mode) — ⭐ RECOMMENDED

In Local Mode, the entire 51-skill framework, code templates, ADRs, checklists, and session memory are unified inside a single `.agent/` directory within your Flutter project.

#### Fast One-Line Cloud Execution
Run this single command from inside your target Flutter project directory in PowerShell (no repo clone required):
```powershell
irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/tools/init-project.ps1 | iex
```

#### Local Script Execution (Offline / Downloaded Repo)
If you have cloned this repository locally, run the script from inside your target Flutter project:
```powershell
# From inside your target project root:
& "path\to\awesome-flutter-ai-skills\init-project.ps1"

# Or specify the project path explicitly:
& "path\to\awesome-flutter-ai-skills\init-project.ps1" -ProjectPath "D:\Projects\my_flutter_app"
```

#### 🧭 Post-Initialization Workflow (3 Magic Steps)
Once initialized, your project will contain a clean `.agent/` folder and IDE rule files pointing to it. Follow these 3 steps:
1. **Define Project Identity:** Open `.agent/PROJECT_PROFILE.md` and define your stack choices (`StateManagement` choice: Riverpod/Bloc/Cubit/GetX, `Database`, `Networking`, and `Key Business Domain`).
2. **Unlock the Gate (Grill-Me):** Open `.agent/CURRENT_STATE.md` and raise the confidence score from `0.50` to `>= 0.80` once your requirements are clarified. *Note: AI Agents are programmed to refuse code generation if the confidence score is below 0.80!*
3. **Start Building & Auditing:** Ask your AI Assistant to build features (e.g., *"Create the auth feature using feature-first clean architecture"*). At any time, audit your codebase for architectural purity by running:
   ```powershell
   dart run .agent/scripts/verify_architecture.dart
   ```

---

### 🌐 2. Global Mode (Multi-IDE Global Sync)

In Global Mode, the 51 skills are deployed simultaneously to 6 user-level IDE global directories (Cursor, Windsurf, Gemini, Antigravity, Codex, Roo/Cline).

#### Deploy Globally
```powershell
.\deploy.ps1
# Or one-line cloud command:
irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/tools/deploy.ps1 | iex
```

#### Clean & Uninstall Global Skills
If you decide to switch exclusively to per-project Local Mode, you can purge all global framework folders cleanly:
```powershell
.\uninstall-global.ps1
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an issue to propose new skills, update Dart 3.x patterns, or improve agent routing mechanics.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
