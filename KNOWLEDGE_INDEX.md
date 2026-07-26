# KNOWLEDGE_INDEX.md — Context Navigation Map

This index allows AI Agents to rapidly jump to specific architectural decisions (ADRs), orthogonal skills, and framework components without searching every file in the workspace.

---

## 🏛️ Architectural Decision Records (ADRs)

| ADR File | Decision Domain | Key Outcome |
|---|---|---|
| [`decisions/ADR-0001-clean-architecture.md`](decisions/ADR-0001-clean-architecture.md) | Layer Isolation | Presentation ➔ Domain ➔ Data flow; zero Flutter in Domain |
| [`decisions/ADR-0002-state-management-matrix.md`](decisions/ADR-0002-state-management-matrix.md) | Pluggable State | Support Riverpod 3.x, Bloc 9.x, Cubit, and GetX 5.x |
| [`decisions/ADR-0003-impeller-rendering.md`](decisions/ADR-0003-impeller-rendering.md) | Rendering Engine | Default to Impeller engine for 60/120 FPS frame budget |
| [`decisions/ADR-0004-declarative-routing.md`](decisions/ADR-0004-declarative-routing.md) | Routing | Declarative typed routing using `go_router` |
| [`decisions/ADR-0005-dio-networking.md`](decisions/ADR-0005-dio-networking.md) | REST Networking | Dio interceptor chain for auth tokens and exception mapping |

---

## 🛠️ Framework Modules & Skill Mapping

| Sector Domain | Skill Directory | Primary Purpose |
|---|---|---|
| **Workflows & DevOps** | [`skills/workflows-devops/flutter-agent-memory/`](skills/workflows-devops/flutter-agent-memory/) | 45th Skill: Enforces 8-Step Context Protocol & Knowledge Ledger |
| **Core Architecture** | [`skills/core-architecture/flutter-clean-architecture/`](skills/core-architecture/flutter-clean-architecture/) | Enforces Presentation ➔ Domain ➔ Data boundaries |
| **State Management** | [`skills/state-management/flutter-riverpod/`](skills/state-management/flutter-riverpod/) | Code generation, AsyncValue, provider management |
| **Data & Networking** | [`skills/data-networking/flutter-api-integration/`](skills/data-networking/flutter-api-integration/) | Dio network client, DTOs, mapper extensions |

---

## 🧭 Fast Recovery Shortcuts

- **To add a new skill:** Jump to `skills/workflows-devops/flutter-create-feature/SKILL.md`.
- **To audit code quality:** Jump to `skills/workflows-devops/flutter-code-review/SKILL.md`.
- **To deploy framework globally:** Run `.\deploy.ps1`.
