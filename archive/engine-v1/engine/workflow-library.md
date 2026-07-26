# AI Engineering OS — Workflow Library

The Workflow Library contains pre-defined execution templates for common engineering scenarios. When the Planner receives a recognized scenario, it applies these templates to ensure a standardized, predictable sequence of tasks.

## 1. New App Creation Workflow
Used when initiating a project from scratch.

1. **Requirements Gathering**: Establish `Project Context`.
2. **Architecture Definition**: Define layers and choose core packages. Create ADRs.
3. **Design System**: Establish colors, typography, and spacing tokens.
4. **Data Layer Setup**: Configure networking clients and local databases.
5. **Domain Layer Setup**: Define core entities and use cases.
6. **Presentation Setup**: Configure routing and state management boilerplate.
7. **Feature Iteration**: Build features sequentially (Data → Domain → Presentation).

## 2. Bug Fix Workflow
Used when resolving an existing issue.

1. **Analyze**: Read bug description and gather evidence (logs, stack traces).
2. **Reproduce**: Identify the exact conditions triggering the bug.
3. **Root Cause Analysis**: Apply the Reasoning Engine to isolate the flaw.
4. **Fix**: Generate code to resolve the issue.
5. **Verify**: Add or update unit/widget tests to prevent regressions.
6. **Output**: Return the patch and confidence score.

## 3. Migration Workflow
Used when upgrading major packages (e.g., GetX to Riverpod, Flutter 2 to 3).

1. **Audit**: Map all current usages of the legacy dependency.
2. **Architecture Mapping**: Define the 1:1 equivalent in the new architecture.
3. **Incremental Patching**: Replace dependencies module by module, not all at once.
4. **Compilation Verification**: Ensure the app builds after each module migration.
5. **Cleanup**: Remove legacy boilerplate and dead code.

## 4. Performance Optimization Workflow
Used strictly when measurable performance degradation is reported.

1. **Profile**: Analyze DevTools timeline or performance logs.
2. **Identify Bottleneck**: Locate the exact frame drop, memory leak, or CPU spike.
3. **Optimize**: Apply specific fixes (e.g., adding `const`, caching images, using isolates).
4. **Benchmark**: Measure performance after the fix.
5. **Compare**: Compare before/after metrics. Reject if no improvement is measurable.

## 5. Security Incident Workflow
Used when a vulnerability is detected (e.g., leaked API key, insecure storage).

1. **Isolate**: Identify the compromised module.
2. **Remediate**: Apply immediate patch (e.g., move token to SecureStorage).
3. **Audit**: Review the entire codebase for similar vulnerabilities.
4. **Document**: Generate an urgent ADR detailing the fix and future prevention.
