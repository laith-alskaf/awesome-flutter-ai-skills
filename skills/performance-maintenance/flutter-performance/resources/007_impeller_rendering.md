# [ADR-007] Impeller Rendering Engine as Mandatory Standard

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Historically, Flutter's default Skia rendering engine suffered from early-run shader compilation jank on iOS and Android devices, causing stuttering animations during a user's first interaction with an app. In Flutter 3.44+, the modern **Impeller** rendering engine is mature and optimized, precompiling shaders at build time and leveraging modern graphics APIs (Metal on iOS, Vulkan on Android).

---

## Decision Drivers

- Must eliminate shader compilation jank entirely across all supported OS platforms.
- Need stable 60fps and 120fps (ProMotion / high-refresh) rendering performance.
- Must align with Flutter's official roadmap (Skia deprecation).

---

## Considered Options

1. **Impeller Rendering Engine (Chosen):** Flutter's modern graphics runtime precompiling shaders offline.
2. **Skia Rendering Engine (Legacy):** Traditional OpenGL/Vulkan runtime with runtime shader compilation.

---

## Decision Outcome

Chosen option: **Impeller Rendering Engine**, because it permanently resolves early-run animation stuttering and provides superior hardware-accelerated rendering performance without requiring manual shader warmup scripts.

### Positive Consequences

- **Zero Shader Jank:** Shaders are compiled during the app build process, guaranteeing buttery-smooth first-run animations.
- **120fps Stability:** Better utilization of Metal and Vulkan APIs on high-refresh device screens.
- **Reduced Code Complexity:** Eliminates legacy `ShaderWarmUp` scripts and Skia trace caching workarounds.

### Negative Consequences / Trade-offs

- **Strict Rendering Verification:** Custom Fragment Shaders (GLSL) require testing under Impeller's compiler pipeline.

---

## Validation & Compliance

- **How to verify compliance:** Build configurations must never opt-out of Impeller (`--no-enable-impeller` is prohibited in CI/CD pipelines).
- **Relevant Skills:** `flutter-performance`, `flutter-animations`, `flutter-ui-engineering`
