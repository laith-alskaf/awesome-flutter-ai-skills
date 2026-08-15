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

For project-local installation—the recommended mode—run `tools\init-project.ps1` from the Flutter project root. This writes project state to `.agents/context/` and native workspace skills to `.agents/skills/`.

---

## 🌐 Supported AI Agents & IDE Matrix

`deploy.ps1` synchronizes skills to documented global paths. For Antigravity projects, use the project-local `.agents/skills/` path; the same project-local `.agents/` root also holds governance, context, rules, utilities, and the framework manifest.

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
awesome-flutter-ai-skills/                 → Framework source repository
├── .agents/rules/                          → Rules for maintaining this repository
├── core/                                   → Source governance, personas, and templates
├── tools/                                  → Initializer, validator, and deployment utilities
├── evaluation/                             → Versioned routing-contract scenarios
└── skills/                                 → 55 source Agent Skills in seven sectors

<initialized-flutter-project>/
└── .agents/                               → Single project-local agent root
    ├── rules/                              → Native Antigravity rules and operating contract
    ├── skills/                             → 55 native Antigravity workspace skills
    ├── governance/                         → AGENTS.md, personas, routing, and governance
    ├── context/                            → Project profile, state, knowledge index, and logs
    ├── tools/                              → Architecture and framework verification utilities
    └── framework-manifest.json             → Installed version, source, and skill-count record
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

The framework supports two deployment models. **We recommend local mode** for team repositories and isolated governance: all project-local agent assets live under the single `.agents/` root, with native workspace skills in `.agents/skills/`.

### 📊 Comparison & Selection Guide

| Feature / Aspect | Local mode — recommended | Global mode |
|---|---|---|
| **Installation path** | `<project>/.agents/context/` for state and `<project>/.agents/skills/` for native skills. | Documented user-profile skill directories, including `~/.gemini/config/skills/`. |
| **Project isolation** | The project can version its own state and skill revision. | Skill revisions are shared across workspaces on the same machine. |
| **Team collaboration** | Commit the desired files or exclude project state deliberately in `.gitignore`. | Each developer must install and update the framework separately. |
| **Agent wiring** | Creates compatible project rule files and native workspace skills. | Installs skills only; project-specific rules remain an explicit choice. |
| **Best use** | Production applications, teams, CI, and offline work. | Personal utilities, experiments, and cross-workspace defaults. |

---

### 🏠 1. Local Mode (single `.agents/` root) — ⭐ RECOMMENDED

In Local Mode, every project-local agent asset is organized under `.agents/`. Antigravity discovers workspace rules in `.agents/rules/` and the 55 native Agent Skills in `.agents/skills/`. The initializer keeps governance in `.agents/governance/`, durable project state in `.agents/context/`, verification utilities in `.agents/tools/`, and the installation record in `.agents/framework-manifest.json`.

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
Once initialized, review `.agents/governance/AGENTS.md` for the operating contract, `.agents/context/PROJECT_PROFILE.md` for confirmed project facts, and `.agents/context/CURRENT_STATE.md` for current evidence and assumptions. Antigravity can discover the native skills and rules without an adapter. Use `flutter-grill-me` only when missing information could materially affect architecture, security, dependencies, data, API contracts, or user-visible behavior. For architectural verification, run:

```powershell
dart run .agents/tools/verify_architecture.dart
```

Re-running the initializer preserves context files by default. Use `-Force` only when intentionally regenerating framework-managed context, and use `-MigrateLegacy` to copy legacy project agent state into the unified structure before storing the prior root as a dated backup.

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
