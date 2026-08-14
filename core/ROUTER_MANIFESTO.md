# 🧭 Flutter AI Agent Router Manifesto & Capability Matrix

This document is the authoritative routing matrix for the Flutter AI Agent Skill Framework. Use it to select the smallest set of skills that covers the task; do not load unrelated skills merely because a task mentions Flutter.

> **Context before action.** For a non-trivial Dart or Flutter change, first inspect the target project's declared versions, active architecture, existing state-management usage, and relevant project-state files when they exist. A visible context header is optional and should be produced only when the user, project rule, or review workflow asks for it. Missing optional memory files are a signal to recover context from the codebase, not a reason to refuse safe work.

---

## ⚡ 1. The Pluggable State Management Router & State Matrix Firewall

Before generating presentation layer code or wiring dependency injection, check `pubspec.yaml` or user instructions to determine the active state library.

Use this decision sequence before selecting a state-management skill:

1. Inspect `pubspec.yaml` and the relevant feature directory. A dependency alone is not enough to distinguish Bloc from Cubit because both use `flutter_bloc`.
2. Reuse the approach already used by the affected feature unless the user requests a documented migration. If the feature is new and the project has no established approach, ask for a choice or recommend one with stated trade-offs.
3. Avoid introducing a second approach into the same feature. A workspace-wide migration may temporarily contain more than one approach only with an explicit boundary, migration plan, and removal target.

| Evidence in target project | Select | Key rule |
|---|---|---|
| `flutter_riverpod` and providers/notifiers in the affected feature | `flutter-riverpod` | Preserve provider scope and lifecycle. |
| `flutter_bloc` and event classes / `Bloc<...>` in the affected feature | `flutter-bloc` | Preserve event-driven boundaries. |
| `flutter_bloc` and `Cubit<...>` in the affected feature | `flutter-cubit` | Preserve method-driven state emission. |
| `get` and controllers / bindings in the affected feature | `flutter-getx` | Preserve controller lifecycle and bindings. |
| No established evidence | Ask or state a recommendation | Do not infer a library from a generic template. |

---

## 🏛️ 2. The 7 Engineering Sectors Capability Matrix

### 🏗️ Sector 1: Core Architecture & Foundations (`core-architecture/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Evaluating product ideas, user journeys, PRD, or strategy | `flutter-product-discovery-and-architecture` | 7 Discovery Questions, PRD scaffolding, Why-What-Ready pipeline |
| Designing domain entities, aggregates, or value objects | `flutter-domain-modeling` | Domain Mapping Pipeline, Rich Entities vs Simple DTO rules, DI graphs |
| Setting up a new project or selecting packages | `flutter-project-architect` | Folder structure, package selection, project complexity tiers |
| Organizing feature folders and boundaries | `flutter-feature-first` | Feature-based modularity, shared vs local code rules |
| Designing a pub workspace, Melos setup, or package boundaries | `flutter-workspace-architecture` | Multi-package ownership, public APIs, tooling choice, and CI orchestration |
| Designing architecture or layer boundaries | `flutter-clean-architecture` | Presentation → Domain → Data separation; zero Flutter in Domain |
| Wiring dependency injection | `flutter-dependency-injection` | Multi-state DI patterns (Riverpod graphs, get_it, GetX Bindings) |
| Abstracting data sources or caching | `flutter-repository-pattern` | Domain repository interfaces vs Data concrete implementations |
| Designing navigation, deep links, or auth guards | `flutter-routing` | Declarative routing using `go_router` and typed route builders |

### 🧠 Sector 2: State Management (`state-management/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Implementing or debugging Riverpod state | `flutter-riverpod` | Code generation, AsyncValue, provider disposal, family/autoDispose |
| Implementing or debugging Bloc event-driven state | `flutter-bloc` | BlocObserver, event transformers, HydratedBloc, concurrency |
| Implementing or debugging Cubit method-driven state | `flutter-cubit` | Method-driven emission, async error trapping, clean usecase wiring |
| Implementing or debugging GetX reactive state | `flutter-getx` | Obx/GetBuilder tradeoffs, controller lifecycle, migration path |

### 🎨 Sector 3: UI & Styling (`ui-styling/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Building a new screen from UI mockup or wireframe | `flutter-build-screen` | Widget decomposition, state connection, error/loading states |
| Designing widgets, design systems, or theming | `flutter-ui-engineering` | Material 3 theming, const constructors, widget extraction |
| Making UI responsive across phone/tablet/desktop | `flutter-responsive-design` | Breakpoints, LayoutBuilder, adaptive spacing and grids |
| Implementing animations or hero transitions | `flutter-animations` | Implicit/explicit animations, Impeller 60/120 FPS optimization |
| Implementing accessibility (a11y) or screen readers | `flutter-accessibility` | Semantics, 48x48 touch targets, dynamic fonts, contrast, RTL |
| Adding multilingual localization (i18n / l10n) | `flutter-localization` | ARB files, RTL/LTR layout switching, pluralization |
| Optimizing for Flutter Web or Desktop platforms | `flutter-web-desktop` | Wasm vs CanvasKit, CORS, PWA, desktop window/menus/shortcuts |

### 🌐 Sector 4: Data & Networking (`data-networking/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Implementing REST API calls or networking layer | `flutter-api-integration` | Dio interceptors, DTO creation, mapper extension, token handling |
| Evolving REST or GraphQL contracts, schemas, or compatibility windows | `flutter-api-contract-evolution` | Versioning, rollout, DTO compatibility, contract tests, and retirement evidence |
| Implementing live WebSockets, SSE, WebRTC, or MQTT | `flutter-websockets` | Auto-reconnect backoff, heartbeat ping/pong, domain stream isolation |
| Integrating GraphQL APIs | `flutter-graphql` | Normalized cache, queries/mutations, ferry/graphql_flutter |
| Integrating Firebase services | `flutter-firebase` | Auth, Firestore, FCM, Crashlytics clean architecture wiring |
| Integrating Supabase services | `flutter-supabase` | PostgREST, Auth, Storage, Edge functions, Row Level Security |
| Implementing local persistence or offline database | `flutter-local-database` | Drift type-safe SQL, Hive, SharedPreferences, encryption |

### 🛡️ Sector 5: Quality, Testing & Security (`quality-testing-security/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Writing unit tests for business logic or repositories | `flutter-unit-testing` | Mocktail/mockito, UseCase & Notifier/Bloc verification, AAA pattern |
| Writing widget tests for UI components | `flutter-widget-testing` | WidgetTester, pumping widgets, matching user interactions |
| Writing integration tests for user flows | `flutter-integration-testing` | Patrol / integration_test, staging APIs, native dialog automation |
| Implementing visual regression / golden tests | `flutter-golden-testing` | Alchemist / golden_toolkit, multi-theme matrix, font loading |
| Generating automated test suites for a feature | `flutter-generate-tests` | Structured generation of domain unit tests and UI widget tests |
| Securing app, tokens, SSL pinning, or obfuscation | `flutter-security` | OWASP Mobile Top 10, flutter_secure_storage, HTTPS enforcement |
| Designing error handling or failure hierarchies | `flutter-error-handling` | Sealed failure classes, Result/Either patterns, global handlers |

### ⚡ Sector 6: Performance & Maintenance (`performance-maintenance/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Diagnosing and optimizing UI jank, memory, or FPS | `flutter-performance` | Impeller verification, DevTools profiling, memory leak resolution |
| Reducing APK, AAB, or IPA app binary size | `flutter-app-size` | Asset compression, font subsetting, dependency trimming |
| Debugging issues using DevTools or inspectors | `flutter-debugging` | Network inspector, widget tree inspector, memory profiler |
| Systematic bug diagnosis and root-cause resolution | `flutter-bug-fixing` | Reproduction, minimal-diff fix, regression testing, regression prevention |
| Setting up structured logging and crash analytics | `flutter-logging` | Logger package, production vs debug log levels, PII masking |
| Refactoring legacy code without changing behavior | `flutter-refactoring` | Safe incremental refactoring, anti-pattern removal, migration |
| Implementing background tasks, alarms, or notifications | `flutter-background-processing` | WorkManager, local notifications, headless isolates, Doze mode |
| Implementing audio/video, camera, BLE, or GPS sensors | `flutter-media-hardware` | Native sensor disposal, permission handler, camera backpressure |

### 🚀 Sector 7: Workflows & DevOps (`workflows-devops/`)
| User Intent / Problem Domain | Authoritative Skill | What It Enforces |
|---|---|---|
| Planning a new feature, sprint backlog, or milestones | `flutter-feature-planner` | Engineering task breakdown, dependency graphs, estimation |
| Evaluating skill, rule, routing, installer, or validator changes in this framework | `flutter-agent-evaluation` | Scenario fixtures, contract checks, and evidence-bound interpretation |
| Interrogating users or resolving missing information that could change a material decision | `flutter-grill-me` | Focused requirement interrogation across the relevant engineering dimensions |
| Creating a new feature end-to-end across all layers | `flutter-create-feature` | Vertical-slice workflow from domain analysis to UI and testing |
| Reviewing code or auditing a pull request | `flutter-code-review` | 6-step PR audit (analysis, architecture, state, UI, security, tests) |
| Managing git branching, commits, or versioning | `flutter-git` | Semantic versioning, conventional commits, PR workflows |
| Upgrading Flutter, Dart, or package constraints and resolving dependency conflicts | `flutter-dependency-upgrade` | Compatibility analysis, staged migration, rollback, and validation evidence |
| Setting up CI/CD pipelines (GitHub Actions, Fastlane) | `flutter-ci-cd` | Automated analysis, formatting, testing, and build artifacts |
| Preparing store release (Play Store / App Store) | `flutter-release` | App signing, metadata, bundle generation, post-release monitoring |
| Managing project memory, state, handoffs, and reusable lessons | `flutter-agent-memory` | Evidence, decisions, assumptions, open questions, and next action |
| Auditing SaaS/Mobile production readiness & release gates | `flutter-production-readiness` | 6 Readiness Pillars (Security, Testing, Analytics, Monetization, Release, Observability) & A11y gate |

---

## 🎯 3. How to Combine Skills (Compound Routing Examples)

* **Scenario A: "Build a chat screen with real-time WebSocket updates using Bloc."**
  👉 **Route:** `flutter-build-screen` + `flutter-websockets` + `flutter-bloc` + `flutter-clean-architecture`.
* **Scenario B: "Our app is janky when scrolling large lists of images on desktop."**
  👉 **Route:** `flutter-performance` + `flutter-ui-engineering` + `flutter-web-desktop`.
* **Scenario C: "Review this pull request that adds background location tracking."**
  👉 **Route:** `flutter-code-review` + `flutter-background-processing` + `flutter-media-hardware` + `flutter-security`.
* **Scenario D: "Start a new project or build an app from scratch." (Why-What-Ready Pipeline)**
  👉 **Route:** `flutter-product-discovery-and-architecture` (WHY) ➔ `flutter-domain-modeling` (WHAT) ➔ `flutter-project-architect` (DESIGN) ➔ `flutter-feature-planner` (PLAN) ➔ Implementation Skills (CODE) ➔ `flutter-production-readiness` (READY) ➔ `flutter-code-review` (REVIEW).
* **Scenario E: "We want to add an offline data sync feature, but specifications and state rules are unclear." (Decision readiness)**
  👉 **Route:** `flutter-grill-me` (RESOLVE MATERIAL QUESTIONS) ➔ `flutter-agent-memory` (RECORD DECISIONS AND ASSUMPTIONS) ➔ `flutter-background-processing` + `flutter-local-database` + `flutter-clean-architecture` (IMPLEMENT AND VALIDATE).
* **Scenario F: "Split two Flutter apps and shared authentication into a workspace."**
  👉 **Route:** `flutter-workspace-architecture` (MAP BOUNDARIES AND TOOLING) ➔ `flutter-ci-cd` (VERIFY PACKAGE MATRIX) ➔ `flutter-dependency-upgrade` (ONLY IF CONSTRAINTS CHANGE).
* **Scenario G: "Change a versioned API identifier without breaking released clients."**
  👉 **Route:** `flutter-api-contract-evolution` (DEFINE COMPATIBILITY AND ROLLOUT) ➔ `flutter-api-integration` (IMPLEMENT CLIENT ADAPTERS) ➔ `flutter-repository-pattern` (PRESERVE BOUNDARIES).
