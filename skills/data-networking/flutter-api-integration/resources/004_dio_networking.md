# [ADR-004] Dio for HTTP Networking & Interceptor Orchestration

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Standard `dart:io` `HttpClient` and the basic `http` package lack advanced enterprise networking features required for production mobile apps, such as global interceptor chains, automated token refresh, request cancellation, request/response logging, and configurable timeouts.

---

## Decision Drivers

- Must support modular interceptor pipelines for authentication token injection and logging.
- Need automated 401 Unauthorized interception with transparent OAuth token renewal and retry.
- Must support global request cancellation when users navigate away from loading screens.
- Must handle multipart file uploads/downloads with real-time progress tracking.

---

## Considered Options

1. **Dio (Chosen):** Comprehensive HTTP client for Dart with rich interceptor, cancellation, and configuration support.
2. **http (Official Dart package):** Lightweight, basic composable HTTP client.
3. **chopper / retrofit:** Code-generation REST client wrappers (built on top of `http` or `dio`).
4. **GraphQL Client (ferry):** Dedicated GraphQL E2E client (reserved exclusively for GraphQL backends).

---

## Decision Outcome

Chosen option: **Dio**, because it provides the most mature, feature-rich networking foundation in the Dart ecosystem, enabling clean separation of networking concerns via specialized interceptors (`AuthInterceptor`, `RetryInterceptor`, `LoggingInterceptor`).

### Positive Consequences

- **Transparent Token Refresh:** Interceptors intercept 401 errors, pause requests, refresh JWT tokens via secure storage, and replay failed requests seamlessly.
- **Robust Error Mapping:** `DioException` types map cleanly to domain `NetworkFailure` sealed classes at repository boundaries.
- **Progress Tracking:** Built-in upload and download progress callbacks simplify file transfer UI states.

### Negative Consequences / Trade-offs

- **Larger Package Surface:** Slightly heavier footprint compared to the barebones `http` package.

---

## Validation & Compliance

- **How to verify compliance:** Architectural linting prohibits instantiating raw `Dio()` instances in UI widgets; all networking must pass through a centrally injected `ApiClient` provider.
- **Relevant Skills:** `flutter-api-integration`, `flutter-security`
