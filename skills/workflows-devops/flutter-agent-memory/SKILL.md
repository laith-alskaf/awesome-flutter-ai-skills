---
name: flutter-agent-memory
description: Use this skill when initializing an AI session, resuming previous work, saving a project checkpoint, logging lessons learned, or updating project health metrics. Enforces the 8-Step Context Recovery Priority Protocol, Confidence Matrix, and zero git noise rules.
triggers:
  - resume work
  - checkpoint state
  - save progress
  - project memory
  - project state
  - agent memory
  - context recovery
  - lessons learned
negative_triggers:
  - flutter run
  - git commit
  - pub get
---

# 🧠 Flutter AI Agent Memory & Knowledge Protocol (`flutter-agent-memory`)

This skill governs state persistence, context recovery, and project health tracking across autonomous AI Agent sessions (**Antigravity**, **Gemini**, **Claude**, **OpenAI Codex**, **Cursor**, **Windsurf**, **Roo Code**, **GitHub Copilot**).

---

## 🏛️ The 8-Step Context Recovery Priority Protocol

For a resumed, multi-file, or high-risk task in an initialized project, recover only the relevant context in the following order. All project-state files live in `.agent/`; native Antigravity skills live in `.agents/skills/`. If a state file does not exist, inspect the repository and create it only when persistent tracking is requested.

```text
1. .agent/PROJECT_PROFILE.md  → Static Project Identity & Tech Stack (Flutter/Dart version, DB, Routing)
2. AGENTS.md               → Core Governance Laws, Quality Rules & Behavioral Constraints
3. .agent/CURRENT_STATE.md    → Active Work Goal, Context, Assumptions & Confidence Matrix
4. .agent/KNOWLEDGE_INDEX.md  → Fast Context Map to ADRs, Skills, and Source Folders
5. .agent/AGENTS_MEMORY.md    → Working Ledger, Milestones, Health Meter & Lessons Learned
6. Relevant ADRs           → Architectural Decision Records in decisions/ or .agent/decisions/
7. Relevant Skills         → Orthogonal Domain Skills in skills/
8. .agent/SESSION_LOG.md      → Chronological Session History
```

---

## 🔬 Reasoning & Confidence Matrix Rules

When updating `CURRENT_STATE.md`, record the evidence, assumptions, and unresolved questions that affect the next action. A confidence score is optional; it must never be presented as an objective calculation.

```yaml
Confidence:
  level: High           # [High, Medium, Low]
  score: 0.95           # [0.00 to 1.00 score]
  reason: "Clean Architecture layer boundaries verified; repository unit tests pass zero warning policy."
```

> **Decision rule:** If uncertainty could change the architecture, security, data, external API contract, dependency choice, or user-visible behavior, use `flutter-grill-me` or ask focused questions before proceeding. For a reversible and low-risk change, state the assumption, make the smallest safe change, and validate it; do not block solely because a numerical score is absent or low.

---

## 🩺 Project Health Meter Rules

The AI Agent maintains project health metrics inside `AGENTS_MEMORY.md`:

```yaml
Health:
  Architecture: "Excellent"   # [Excellent, Good, Fair, Poor]
  Tests: "Good"               # [Excellent, Good, Fair, Poor]
  Documentation: "Excellent"  # [Excellent, Good, Fair, Poor]
  TechnicalDebt: "None"       # [None, Low, Moderate, High]
  Security: "Excellent"       # [Excellent, Good, Fair, Poor]
  Performance: "Excellent"    # [Excellent, Good, Fair, Poor]
```

---

## 🛡️ Controlled Checkpoint Rules (Zero Git Noise)

To prevent git history pollution and commit noise, `.agent/AGENTS_MEMORY.md` and `.agent/CURRENT_STATE.md` are updated **ONLY** under the following triggers:
1. **Feature Completion:** A full feature or milestone is completed and verified.
2. **Architecture Change:** A major architectural pattern, dependency, or DB schema changes.
3. **Explicit User Request:** The user types `checkpoint state` or `save progress`.
4. **Session Handoff:** At session completion before returning the final report to the user.

---

## 🧹 Memory Compaction Without Data Loss

Keep active state concise, but do not silently delete or rewrite history. When a session log becomes difficult to navigate, create a dated archive under `.agent/archive/`, retain a short index and the current open decisions in `SESSION_LOG.md`, and link the archive from `KNOWLEDGE_INDEX.md`. Compact completed milestones only after confirming that the summary preserves the original decision, evidence, date, owner, and reference. Never compact a record that contains unresolved risk, a pending user decision, or a requirement that has not been captured elsewhere.

---

## 💡 Lessons Learned Protocol

When an unexpected bug, memory leak, or architectural anti-pattern is resolved, append a concise anti-regression entry to `.agent/AGENTS_MEMORY.md` only if the lesson is reusable. Include the trigger, root cause, corrective action, validation evidence, and a link to the affected code, test, or issue when available.

---

## Related Skills

- `flutter-grill-me` — Focused requirement-interrogation workflow for material uncertainty
- `flutter-product-discovery-and-architecture` — PRD scaffolding (PRODUCT_REQUIREMENTS.md)
- `flutter-domain-modeling` — Domain Map scaffolding (DOMAIN_MAP.md)
- `flutter-production-readiness` — Production checklist verification (PRODUCTION_CHECKLIST.md)
- `flutter-create-feature` — Triggers this skill for session initialization in Step 0
- `flutter-code-review` — References CURRENT_STATE.md confidence matrix before review

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
