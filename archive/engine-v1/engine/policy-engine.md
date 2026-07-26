# AI Engineering OS — Policy Engine

The Policy Engine serves as the centralized source of truth for all global engineering policies. Specialists query this engine to resolve conflicts or determine the correct constraints before generating code.

## 1. Conflict Resolution Priorities
When two policies or requirements conflict, the agent must resolve them according to this strictly weighted priority hierarchy:

1. **Correctness (100)**: Does it solve the fundamental problem?
2. **Architecture & Consistency (95)**: Does it violate the chosen architecture (e.g., Clean Architecture)?
3. **Security (90)**: Does it introduce vulnerabilities or expose secrets?
4. **Maintainability (85)**: Is the code readable, decoupled, and testable?
5. **Performance (80)**: Does it degrade frame rates, battery, or memory?
6. **Accessibility (75)**: Can all users interact with it?
7. **Developer Experience (60)**: Is it easy to write and compile?

*Example: If a performance optimization (80) breaks Clean Architecture (95), the optimization is rejected.*

## 2. Global Architecture Policies
- **Separation of Concerns**: Business logic must never reside in the Presentation Layer.
- **Dependency Inversion**: High-level modules should not depend on low-level modules; both should depend on abstractions.
- **Immutability**: State models and entities must be immutable by default.

## 3. Global Security Policies
- **Zero Trust**: Validate all inputs at every boundary.
- **Secure Storage**: Never store sensitive data (tokens, PII, passwords) in plain text or SharedPreferences.
- **Least Privilege**: Request only the absolute minimum permissions required to perform a task.

## 4. Global Performance Policies
- **No Premature Optimization**: Optimizations require explicit proof via the Reasoning Engine's Evidence-First Protocol.
- **Asynchronous Non-blocking**: UI threads must never be blocked by I/O, database, or heavy computation tasks.

## 5. Global Code & Review Policies
- **No Dead Code**: Remove all unused variables, imports, and functions before committing.
- **Explicit Typings**: Avoid dynamic typing unless strictly necessary for interoperability.
- **Failure Handling**: Do not swallow exceptions. Map all raw exceptions to domain-specific failures.
