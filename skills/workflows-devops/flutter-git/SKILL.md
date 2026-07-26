---
name: flutter-git
description: >
  Use this skill when managing version control for Flutter projects. Covers
  branching strategy, commit message conventions, PR workflow, semantic versioning,
  gitignore, and CI/CD integration. Do not use for deployment specifics (use
  flutter-ci-cd or flutter-release).
triggers:
  - "Manage Git branching strategy and conventional commits"
  - "Configure semantic versioning and gitignore"
  - "Set up pull request review workflows"
negative_triggers:
  - "CI/CD pipeline execution"
  - "Store release publishing"
---

# Flutter Git Workflow

## Purpose

Maintain clean, professional version control with meaningful history, proper branching, and reviewable pull requests.

## Rules

### Branching Strategy

```
main              → Production-ready code
  └─ develop      → Integration branch
       ├─ feature/auth-login     → New feature
       ├─ bugfix/cart-crash      → Bug fix
       ├─ hotfix/security-patch  → Urgent production fix
       └─ refactor/clean-repos   → Code improvement
```

### Commit Message Convention

```
type(scope): description

feat(auth): add biometric login support
fix(cart): prevent duplicate item addition
refactor(profile): extract address widget
docs(readme): update setup instructions
test(auth): add login usecase unit tests
chore(deps): update riverpod to 3.2.0
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`

### Flutter .gitignore Essentials

```
# Generated files
*.g.dart
*.freezed.dart
*.gr.dart
*.mocks.dart

# Build
build/
.dart_tool/

# IDE
.idea/
*.iml
.vscode/

# Environment
.env
.env.*

# Platform
ios/Pods/
android/.gradle/
```

### PR Guidelines

- One feature per PR
- Include: description, screenshots (if UI), test results
- Ensure `dart analyze` passes with zero warnings
- Ensure `flutter test` passes
- Request review from at least one team member

## Related Skills

- `flutter-ci-cd` — Automated build and test
- `flutter-release` — Versioning and release process
- `flutter-code-review` — Review standards
