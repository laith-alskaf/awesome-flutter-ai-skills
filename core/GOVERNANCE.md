# Framework Governance & AI Compliance

This document dictates the rules for modifying, maintaining, and deprecating components of the **Flutter AI Agent Skill Framework**. It serves as the primary governance layer to ensure enterprise-grade stability and prevent architectural entropy.

## 1. Ownership & Responsibility
Every file, module, and skill within this framework must have a clear owner.
- **Global Kernel (`core/` & `tools/`)**: Owned by the Principal Framework Architect. Modifications require strict regression testing across deployment scripts.
- **Skill Modules (`skills/`)**: Owned by the respective Domain Leads (e.g., State Management, UI/UX). 

## 2. Versioning Strategy
We enforce a strict 4-dimensional versioning matrix:
1. **Framework Version**: The holistic version of the OS (e.g., `v2.0.0`).
2. **Skill Version**: Semantic versioning defined inside each skill's `metadata.yaml` (e.g., `1.2.0`). Updates to templates trigger a MINOR bump. Logic changes trigger a MAJOR bump.
3. **Flutter Target**: The minimum supported Flutter SDK (currently `3.44.x`).
4. **Dart Target**: The minimum supported Dart SDK (currently `3.12.x`).

## 3. The Deprecation Policy
No skill, template, or architecture decision may be deleted immediately.
1. **Phase 1: Soft Deprecation**: Mark `deprecated: true` in `metadata.yaml`. The agent will warn the user but still execute the skill if explicitly requested.
2. **Phase 2: Hard Deprecation**: Replace the `SKILL.md` rules with a single migration prompt: *"This skill is obsolete. Please use [New Skill] instead."*
3. **Phase 3: Archival**: After 6 months of Hard Deprecation, the folder is removed from the active `skills/` directory and moved to `.archive/`.

## 4. Documentation Edit Policy (Diátaxis)
When updating documentation, you MUST adhere to the Diátaxis framework:
- **Tutorials**: Step-by-step learning (does not belong in `SKILL.md`).
- **How-To Guides**: Goal-oriented execution (Belongs in `HOW_TO_USE.md`).
- **Reference**: Factual API contracts and code (Belongs in `templates/` and `metadata.yaml`).
- **Explanation**: Context and 'Why' (Belongs in `AGENTS.md` and `decisions/`).
Do not mix these intents.

## 5. Security & Review Frequency
- The `core/` OS rules must be audited every 3 months.
- Dependency libraries referenced in templates (e.g., `dio`, `flutter_riverpod`) must be verified against pub.dev for CVEs monthly.
