# Awesome Flutter AI Agent Skills 2026

![Flutter Version](https://img.shields.io/badge/Flutter-3.44.x%20Stable-02569B?logo=flutter&logoColor=white)
![Dart Version](https://img.shields.io/badge/Dart-3.12.x-0175C2?logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture%20%2B%20SOLID-4CAF50)
![Skills](https://img.shields.io/badge/AI%20Skills-55%20Orthogonal-ff69b4)
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
- [The 55 skills Directory Summary](#-the-55-skills-directory-summary)
- [How to Integrate in Any Project](#-how-to-integrate-in-any-project)
- [Contributing](#-contributing)
- [License](#-license)

---

## 💡 Why Awesome Flutter AI Skills?

Standard AI coding assistants often generate fragmented code, mix UI logic with business logic, use outdated Flutter/Dart packages, or hallucinate non-existent state management APIs.

**Awesome Flutter AI Skills** solves this by providing:
1. **Deterministic Skill Routing & Decision-Readiness Gate:** Reduces unsupported assumptions through structured YAML triggers and focused project interrogation (`flutter-grill-me`) when missing information could change a material decision.
2. **Version-Aware Guidance:** Uses Flutter 3.44.x and Dart 3.12.x as examples while requiring the target project's declared SDK constraints to drive real changes.
3. **Pluggable State Management and Architecture Boundaries:** Supports Riverpod, Bloc, Cubit, and GetX through feature-level evidence, while providing an optional verifier for Clean Architecture boundary checks.
4. **Safe Multi-Agent Deployment:** `deploy.ps1` synchronizes native skills to documented global locations with backup-and-restore behavior and supports `-WhatIf`; `init-project.ps1` installs project state and native workspace skills locally.

---

## ⚡ Universal One-Line Quick Start (For ALL AI Agents & IDEs)

Install the framework from a checked-out copy so that PowerShell executes a reviewed local file rather than remote text.

### PowerShell (Windows)
```powershell
git clone https://github.com/laith-alskaf/awesome-flutter-ai-skills.git
cd awesome-flutter-ai-skills
.\tools\deploy.ps1
```

For project-local installation—the recommended mode—run `tools\init-project.ps1` from the Flutter project root. This writes project state to `.agent/` and native workspace skills to `.agents/skills/`.

---

## 🌐 Supported AI Agents & IDE Matrix

`deploy.ps1` synchronizes skills to documented global paths. For Antigravity projects, use the project-local `.agents/skills/` path; `.agent/` is retained for project state and legacy compatibility.

| Agent / IDE Platform | Target Path / Rule File | Supported Format |
|---|---|---|
| **Antigravity AI Agent** | Workspace: `.agents/skills/`; global: `~/.gemini/config/skills/` | Native `SKILL.md` skills |
| **Gemini CLI Agent** | `~/.gemini/config/skills/` | Native `SKILL.md` skills |
| **Claude & Universal Agents** | `~/.agents/skills/` | Native `SKILL.md` skills |
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
├── .agents/skills/                  → Native Antigravity workspace skills
├── core/                        → The OS Kernel
│   ├── AGENTS.md                → Master Policy, Tech Stack, and Context Protocols
│   ├── ROUTER_MANIFESTO.md      → Global Capability Matrix & Zero-Hallucination Gatekeeper
│   ├── ROUTING_EVALUATION.md    → Routing scenarios and evaluation protocol
│   ├── PERSONAS.md              → Definition of 5 strict AI Roles (CPO, Architect, QA, etc.)
│   ├── GOVERNANCE.md            → Versioning, Ownership, and Deprecation Lifecycle
│   └── PERFORMANCE_METRICS.md   → Token Budgets and Framework KPIs
├── tools/                       → Executable OS Utilities
│   ├── verify_architecture.dart → Linter for Clean Architecture isolation
│   ├── audit_framework.dart     → CI/CD validator for token limits and Knowledge Graph
│   ├── deploy.ps1               → Global multi-agent deployment engine
│   └── init-project.ps1         → Project-level workspace initializer
└── skills/                      → 55 Self-Contained Modular Skills in 7 Sectors
    ├── core-architecture/       → Clean Architecture, DI, Domain Modeling, Workspaces (9 skills)
    ├── state-management/        → Riverpod 3.x, Bloc 9.x, Cubit, GetX 5.x (4 skills)
    ├── ui-styling/              → UI Engineering, Responsive, Animations (9 skills)
    ├── data-networking/         → REST API, Contract Evolution, WebSockets, Firebase, Supabase (7 skills)
    ├── quality-testing-security/→ Unit, Widget, Integration, Security (7 skills)
    ├── performance-maintenance/ → Performance, App Size, Debugging, Refactoring (8 skills)
    └── workflows-devops/        → Planning, Code Review, Upgrades, Evaluation, DevOps (11 skills)
```

> **Note on Modularity:** Every skill in `skills/` is a self-contained module containing a standard `SKILL.md` and supplemental `metadata.yaml`; optional `templates/` and `resources/` are loaded only when needed. This supports progressive disclosure without duplicating project state in every skill.

---

## 📦 The 55 skills Directory Summary

1. **Core Architecture (9 Skills):** `flutter-clean-architecture`, `flutter-dependency-injection`, `flutter-domain-modeling`, `flutter-feature-first`, `flutter-product-discovery-and-architecture`, `flutter-project-architect`, `flutter-repository-pattern`, `flutter-routing`, `flutter-workspace-architecture`.
2. **State Management (4 Skills):** `flutter-riverpod`, `flutter-bloc`, `flutter-cubit`, `flutter-getx`.
3. **UI & Styling (9 Skills):** `flutter-design-system-theming`, `flutter-micro-interactions-ux`, `flutter-ui-engineering`, `flutter-responsive-design`, `flutter-animations`, `flutter-accessibility`, `flutter-localization`, `flutter-build-screen`, `flutter-web-desktop`.
4. **Data & Networking (7 Skills):** `flutter-api-integration`, `flutter-api-contract-evolution`, `flutter-websockets`, `flutter-graphql`, `flutter-firebase`, `flutter-supabase`, `flutter-local-database`.
5. **Quality, Testing & Security (7 Skills):** `flutter-unit-testing`, `flutter-widget-testing`, `flutter-integration-testing`, `flutter-golden-testing`, `flutter-generate-tests`, `flutter-security`, `flutter-error-handling`.
6. **Performance & Maintenance (8 Skills):** `flutter-performance`, `flutter-app-size`, `flutter-debugging`, `flutter-bug-fixing`, `flutter-logging`, `flutter-refactoring`, `flutter-background-processing`, `flutter-media-hardware`.
7. **Workflows & DevOps (11 Skills):** `flutter-agent-memory`, `flutter-agent-evaluation`, `flutter-ci-cd`, `flutter-code-review`, `flutter-create-feature`, `flutter-dependency-upgrade`, `flutter-feature-planner`, `flutter-git`, `flutter-grill-me`, `flutter-production-readiness`, `flutter-release`.

---

## 🧪 Strategy, Routing, and Evaluation

The framework uses a proportionate strategy: recover project state only for work that spans sessions or carries material risk; inspect the repository directly for a small local change; ask focused questions only when a missing answer could change architecture, security, data, external contracts, dependencies, or user-visible behavior. The agent should select the smallest skill set that covers the request, preserve the state-management approach used by the affected feature, and record evidence, decisions, assumptions, validation status, and the next action for durable handoffs.

Routing expectations are versioned in [`evaluation/routing-scenarios.yaml`](evaluation/routing-scenarios.yaml), with the maintenance protocol in [`core/ROUTING_EVALUATION.md`](core/ROUTING_EVALUATION.md). These scenarios verify the framework contract for primary, supporting, and forbidden skills; they do not claim that every model will choose a skill identically. The validation workflow runs structural checks on Linux and a non-destructive project-initialization smoke test on Windows PowerShell.

| Situation | Primary workflow |
|---|---|
| Multi-package workspace, pub workspace, or Melos decision | `flutter-workspace-architecture` |
| Flutter, Dart, plugin, or package upgrade | `flutter-dependency-upgrade` |
| REST or GraphQL compatibility, schema, or DTO evolution | `flutter-api-contract-evolution` |
| Skill, rule, installer, or routing-contract change | `flutter-agent-evaluation` |

---

## 🚀 Deployment & Usage Modes (Local vs. Global)

The framework supports two deployment models. **We recommend local mode** for team repositories and isolated governance: project state is stored in `.agent/` while native workspace skills are stored in `.agents/skills/`.

### 📊 Comparison & Selection Guide

| Feature / Aspect | Local mode — recommended | Global mode |
|---|---|---|
| **Installation path** | `<project>/.agent/` for state and `<project>/.agents/skills/` for native skills. | Documented user-profile skill directories, including `~/.gemini/config/skills/`. |
| **Project isolation** | The project can version its own state and skill revision. | Skill revisions are shared across workspaces on the same machine. |
| **Team collaboration** | Commit the desired files or exclude project state deliberately in `.gitignore`. | Each developer must install and update the framework separately. |
| **Agent wiring** | Creates compatible project rule files and native workspace skills. | Installs skills only; project-specific rules remain an explicit choice. |
| **Best use** | Production applications, teams, CI, and offline work. | Personal utilities, experiments, and cross-workspace defaults. |

---

### 🏠 1. Local Mode (`.agent/` state + `.agents/skills/`) — ⭐ RECOMMENDED

In Local Mode, project memory, governance, tools, and generated workspace artifacts live in `.agent/`; the 55 native Agent Skills live in `.agents/skills/`, the default Antigravity workspace-skill location. Antigravity also retains backward compatibility with `.agent/skills/`, but the initializer uses `.agents/skills/` for new projects.

#### Safe Setup
Clone the framework, then run the reviewed initializer from inside your target Flutter project directory:
```powershell
git clone https://github.com/laith-alskaf/awesome-flutter-ai-skills.git
& "path\to\awesome-flutter-ai-skills\tools\init-project.ps1"
```

#### Local Script Execution (Offline / Downloaded Repo)
If you have cloned this repository locally, run the script from inside your target Flutter project:
```powershell
# From inside your target project root:
& "path\to\awesome-flutter-ai-skills\tools\init-project.ps1"

# Or specify the project path explicitly:
& "path\to\awesome-flutter-ai-skills\tools\init-project.ps1" -ProjectPath "D:\Projects\my_flutter_app"
```

#### 🧭 Post-Initialization Workflow
Once initialized, your project contains `.agent/` state, `.agents/skills/` native skills, and compatible IDE rule files. Follow these steps:
1. **Define project identity:** Open `.agent/PROJECT_PROFILE.md` and record only confirmed stack choices and business context.
2. **Resolve material uncertainty:** Use `flutter-grill-me` when missing information could change architecture, security, dependencies, data, API contracts, or user-visible behavior. Record assumptions for low-risk reversible work in `.agent/CURRENT_STATE.md`.
3. **Build and validate:** Ask the agent to select the smallest relevant skill set. Audit architectural boundaries when appropriate with:
   ```powershell
   dart run .agent/tools/verify_architecture.dart
   ```

---

### 🌐 2. Global Mode (Multi-IDE Global Sync)

In Global Mode, the 55 skills are deployed to the configured user-level skill directories. Antigravity and Gemini use the documented `~/.gemini/config/skills/` global location.

#### Deploy Globally
```powershell
.\tools\deploy.ps1
```

#### Clean & Uninstall Global Skills
If you decide to switch to project-local mode, remove only the managed global skill directories:
```powershell
.\tools\uninstall-global.ps1 -Force
```

---

## 🤝 Contributing

Contributions are welcome. Before opening a pull request, run the repository contract check from the repository root:

```bash
python3 tools/validate_framework.py
```

The check validates all 55 skills, frontmatter and supplemental metadata, metadata dependency references, local Markdown links, routing scenarios, documented Antigravity paths, CI smoke-test contracts, and deployment safety contracts. Add a focused `SKILL.md`, match its directory name in both metadata files, keep rare detail in local resources, add or update a realistic routing scenario for a material boundary change, and update installer and documentation contracts together whenever a supported path changes.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
