# [ADR-001] Adoption of Feature-First Clean Architecture

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

As Flutter projects grow beyond 20-30 screens, standard layer-first organization (`lib/screens/`, `lib/models/`, `lib/services/`) leads to massive, chaotic directories where features are tightly entangled. Changes to one screen often break unrelated features, and multiple developers working simultaneously face constant Git merge conflicts. We need an architectural separation that scales seamlessly from mid-sized apps to enterprise teams while enforcing strict dependency boundaries.

---

## Decision Drivers

- Need modular, independent business features that can be developed and tested in isolation.
- Must prevent UI widgets from directly coupling to REST APIs, databases, or third-party SDKs.
- Need high unit testability for core business logic without spinning up Flutter UI environments.
- Must support clear ownership boundaries for multi-team collaboration.

---

## Considered Options

1. **Feature-First Clean Architecture (Chosen):** Organize by business capability (`lib/features/<name>/`), subdividing each into 3 strict layers (`presentation`, `domain`, `data`).
2. **Layer-First Organization:** Traditional MVC/MVVM structuring code by technical type (`controllers`, `views`, `models`).
3. **Flat Feature Structure:** Placing all screens, state, and API calls for a feature in a single flat directory without internal layer boundaries.

---

## Decision Outcome

Chosen option: **Feature-First Clean Architecture**, because it provides the highest degree of modularity, testability, and long-term maintainability. The domain layer acts as an immutable core with zero framework dependencies, ensuring business rules outlive UI trends or library migrations.

### Positive Consequences

- **High Cohesion:** All files related to a specific business feature live in one place.
- **Strict Decoupling:** Domain entities and use cases compile independently of Flutter, Dio, or Firebase.
- **Parallel Development:** Developers can work on separate features without touching shared files.
- **Testability:** Core domain logic achieves 90%+ unit test coverage with simple mock repositories.

### Negative Consequences / Trade-offs

- **Boilerplate Overhead:** Requires creating explicit Entities, DTOs, and Mapper functions even for simple CRUD operations.
- **Learning Curve:** Requires discipline to avoid taking shortcuts (e.g., calling repositories directly from UI).

---

## Validation & Compliance

- **How to verify compliance:** Enforced via code reviews and automated import boundary lint rules preventing `package:flutter` inside domain layers.
- **Relevant Skills:** `flutter-clean-architecture`, `flutter-feature-first`, `flutter-repository-pattern`
