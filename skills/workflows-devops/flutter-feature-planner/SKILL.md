---
name: flutter-feature-planner
description: >
  Use this skill when planning a new feature, starting a Flutter project,
  estimating development effort, creating user stories, organizing backlogs, or
  building sprint plans. Transforms business requirements into structured
  engineering execution plans with task breakdowns, dependency graphs, and
  milestones. Do not use for architectural design decisions (use
  flutter-project-architect) or implementation specifics.
triggers:
  - "Plan a new feature or sprint backlog"
  - "Break down business requirements into technical tasks"
  - "Create dependency graphs and milestone estimates"
negative_triggers:
  - "Architectural design decisions"
  - "Code implementation"
---

# Flutter Feature Planner

## Purpose

Convert any application idea or feature request into a complete, prioritized engineering execution plan. Every feature must be independent, testable, deliverable, and well-documented.

## Scope

**Covers:** Requirements analysis, MVP identification, feature decomposition, user stories, task breakdown, dependency mapping, complexity estimation, sprint planning, risk analysis.

**Does not cover:** Architecture design, package selection, implementation code.

## Technology Context

- Flutter 3.44.x / Dart 3.12.x
- Feature-First + Clean Architecture
- Agile methodology with sprint-based delivery

## Rules

### Thinking Process

1. Understand business goals → 2. Identify target users → 3. Define MVP → 4. Split into Features → 5. Split Features into User Stories → 6. Split Stories into Tasks → 7. Estimate complexity → 8. Detect dependencies → 9. Prioritize → 10. Build roadmap.

### Feature Definition

Each Feature represents one business capability (Authentication, Profile, Orders, Cart, Search — never API, Widgets, Models, Screens).

### Feature Template

Every Feature must include: Purpose, Business Value, Dependencies, Priority (MoSCoW), Complexity (XS/S/M/L/XL), Estimated Screens, Required APIs, Database Tables, Permissions, Offline Support, Caching Strategy, Testing Strategy, Future Improvements.

### User Story Format

```
As a [user type]
I want to [action]
So that [business value]

Acceptance Criteria:
- [ ] Given [context], when [action], then [result]
```

### Task Breakdown per Story

```
Feature (Authentication)
  └─ User Story (Login)
       ├─ Create Entity (User)
       ├─ Define Repository Interface
       ├─ Implement Remote Datasource
       ├─ Implement Repository
       ├─ Create Use Case (LoginUseCase)
       ├─ Create Notifier (LoginNotifier)
       ├─ Build Login Screen
       ├─ Add Validation
       ├─ Write Unit Tests
       ├─ Write Widget Tests
       └─ Integration Test
```

### Prioritization — MoSCoW

| Priority | Definition |
|---|---|
| **Must Have** | Core functionality. App doesn't work without it. |
| **Should Have** | Important but not critical for launch. |
| **Could Have** | Nice to have. Implement if time allows. |
| **Won't Have** | Explicitly out of scope for this release. |

### Sprint Planning

Sprint 1: Project setup, architecture, authentication.
Sprint 2: Navigation, profile, home screen.
Sprint 3: Core CRUD, search, caching.
Sprint 4: Notifications, settings, analytics.
Each sprint must be independently releasable.

### Risk Analysis

Identify: Technical, Business, Security, Performance, UX, Platform, API, Third-party, Migration risks. Suggest mitigation for every risk.

## Output Format

Always provide: Executive Summary, Application Classification, MVP Scope, Feature List (with MoSCoW), Dependency Graph, User Stories, Task Breakdown, Folder Structure, Sprint Plan, Milestones, Risk Assessment, Testing Plan, Definition of Done.

## Checklist

- [ ] Business goals understood
- [ ] MVP vs future features separated
- [ ] Features are business capabilities (not technical layers)
- [ ] User stories follow As/I want/So that format
- [ ] Tasks are independently deliverable
- [ ] Dependencies mapped (no dependent feature built first)
- [ ] Complexity estimated for each feature
- [ ] Risks identified with mitigations
- [ ] Sprint plan with releasable increments
- [ ] Testing strategy per feature

## Related Skills

- `flutter-project-architect` — Architecture and package decisions
- `flutter-clean-architecture` — Feature folder structure
- `flutter-create-feature` — End-to-end feature implementation workflow
