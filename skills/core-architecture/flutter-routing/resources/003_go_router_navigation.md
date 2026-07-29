# [ADR-003] Declarative Navigation & Typed Routes with go_router

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Imperative navigation (`Navigator.push`, `Navigator.pop`) using hardcoded string literals across UI widgets leads to spaghetti navigation, broken back-button behaviors, and fragile deep linking. Modern apps require web-like URL addressability, nested bottom-navigation shells (`ShellRoute`), and centralized authentication redirect guards.

---

## Decision Drivers

- Must support out-of-the-box web URLs and mobile deep linking (Android App Links / iOS Universal Links).
- Must eliminate string-based routing errors through compile-safe route parameters.
- Need persistent bottom navigation bars that preserve tab state across screen transitions (`ShellRoute`).
- Must support centralized authentication guards that intercept and redirect unauthenticated requests without scattering checks across UI pages.

---

## Considered Options

1. **go_router with `go_router_builder` Typed Routes (Chosen):** Official declarative routing package maintained by the Flutter team with code-generated route objects.
2. **auto_route:** Third-party code-generation routing library.
3. **Imperative Navigator 2.0 (Raw RouterDelegate):** Manual implementation of Flutter's low-level declarative routing API.
4. **GetX Navigation:** Global singleton imperative routing (`Get.toNamed`).

---

## Decision Outcome

Chosen option: **go_router with Typed Routes**, because it is the official Flutter standard, provides robust deep linking, simplifies nested `ShellRoute` navigation, and eliminates string-based navigation bugs via `@TypedGoRoute` code generation.

### Positive Consequences

- **Type-Safe Navigation:** Parameters are passed as strongly-typed Dart constructor arguments (`const ProductRoute(id: '123').go(context)`).
- **Centralized Auth Guard:** A single `redirect` callback secures the entire application against unauthorized route access.
- **Persistent Shells:** Seamless tab switching while preserving navigation stacks per tab.

### Negative Consequences / Trade-offs

- **Code Gen Step:** Requires `build_runner` for typed route code generation.
- **Imperative Limitations:** Requires structured planning for complex modal or multi-step wizard dialog overlays.

---

## Validation & Compliance

- **How to verify compliance:** Code reviews prohibit direct calls to `Navigator.of(context).push()` or string literals in `context.go()`.
- **Relevant Skills:** `flutter-routing`
