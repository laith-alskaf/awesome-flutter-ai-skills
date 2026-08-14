# New Feature Readiness Checklist

Use this checklist during Sprint Planning or before starting development on a new feature to ensure clear requirements and scope.

## 1. Requirements & Scope
- [ ] User stories are written in standard format (`As a... I want to... So that...`) with explicit acceptance criteria.
- [ ] Edge cases, offline behavior, error states, and empty states are identified and documented.
- [ ] Feature priority is classified using MoSCoW (Must, Should, Could, Won't Have) and estimated for complexity.

## 2. Architecture Planning
- [ ] Required Domain Entities and sealed `Failure` classes are outlined.
- [ ] Backend API endpoints, request/response JSON schemas, and DTO requirements are verified.
- [ ] Local persistence or caching requirements (Drift, Hive, secure storage) are identified.
- [ ] Navigation routing paths (`go_router`) and required URL parameters are mapped.

## 3. UI & Design Design
- [ ] Design wireframes or mockups inspected for spacing tokens, color scheme usage, and responsive breakpoints.
- [ ] Reusable components identified (avoiding duplicate widget creation).
- [ ] Accessibility requirements (semantics labels, touch targets) explicitly noted for custom UI widgets.

## 4. Decision Readiness (AI Agent Step)

- [ ] Material assumptions, open questions, and confirmed decisions are recorded in project state or the relevant design artifact.
- [ ] `flutter-grill-me` was used when unresolved information could change architecture, data, security, dependencies, API contracts, or user-visible behavior.
- [ ] The active state-management approach is confirmed from the affected feature and `pubspec.yaml`, or a deliberate selection is documented for a new feature.
- [ ] Backend API contracts are defined before DTO creation when the feature depends on an external API.
- [ ] Relevant edge cases, such as network failure, empty data, and unauthorized access, are documented in user stories or acceptance criteria.

---

**Related Skills:** `flutter-grill-me` (anti-hallucination gate) · `flutter-feature-planner` (sprint planning) · `flutter-create-feature` (implementation workflow) · `flutter-domain-modeling` (entity design)
