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

## 4. Anti-Hallucination Gate (AI Agent Mandatory Step)

- [ ] Agent confidence score in `.ai/CURRENT_STATE.md` is **≥ 0.80** before any code generation begins.
- [ ] If confidence < 0.80, `flutter-grill-me` has been invoked and all 5 Engineering Dimensions answered.
- [ ] Active state management library confirmed from `pubspec.yaml` (Riverpod / Bloc / Cubit / GetX).
- [ ] Backend API contract (URL, method, request/response JSON) fully defined before DTO creation.
- [ ] All edge cases (network failure, empty data, unauthorized access) documented in user stories.

---

**Related Skills:** `flutter-grill-me` (anti-hallucination gate) · `flutter-feature-planner` (sprint planning) · `flutter-create-feature` (implementation workflow) · `flutter-domain-modeling` (entity design)
