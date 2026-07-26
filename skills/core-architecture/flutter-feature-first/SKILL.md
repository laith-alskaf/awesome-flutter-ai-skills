---
name: flutter-feature-first
description: >
  Use this skill when organizing Flutter project code into feature-based modules.
  Covers feature identification, boundary definition, shared code rules, and
  scaling from small to large projects. Do not use for overall architecture design
  (use flutter-project-architect) or Clean Architecture layer details (use
  flutter-clean-architecture).
triggers:
  - "Organize Flutter project into feature modules"
  - "Define feature folder structure"
  - "Set up shared core vs feature code boundaries"
negative_triggers:
  - "General project architecture design"
  - "Clean Architecture layer details"
---

# Flutter Feature-First Organization

## Purpose

Organize code by business capability (features) rather than technical type (screens, models, controllers). This approach scales from small to enterprise projects.

## Rules

### Feature = Business Capability

```
# Correct — organized by what the app DOES
features/
  authentication/
  profile/
  product_catalog/
  shopping_cart/
  checkout/
  order_history/

# Wrong — organized by what the code IS
screens/
models/
controllers/
services/
widgets/
```

### Feature Independence

- Features should be as independent as possible
- Feature A should not import from Feature B's internal code
- Cross-feature communication happens through shared domain interfaces or events
- If two features share a concept, it moves to `core/` or `shared/`

### Scaling Strategy

| Project Size | Organization |
|---|---|
| Small (<15 screens) | `lib/features/` with flat structure |
| Medium (15-60 screens) | `lib/features/` with Clean Architecture layers |
| Large (60+ screens) | Feature packages with pub workspaces |

### When to Extract to Shared

Move code to `shared/` only when:
1. Used by 2+ features
2. It's genuinely reusable
3. It doesn't contain business logic specific to one feature

```
# Shared examples
shared/widgets/app_button.dart        ✅ Used everywhere
shared/extensions/string_ext.dart     ✅ Generic utility

# NOT shared
shared/auth_service.dart              ❌ Feature-specific
shared/order_calculator.dart          ❌ Feature-specific
```

## Related Skills

- `flutter-clean-architecture` — Layer structure within features
- `flutter-project-architect` — Overall project design
- `flutter-dependency-injection` — Cross-feature DI
