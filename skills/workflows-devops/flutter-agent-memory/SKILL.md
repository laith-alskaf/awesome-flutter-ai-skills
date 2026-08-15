---
name: flutter-agent-memory
description: Use this skill when resuming multi-step work, saving a project checkpoint, recording reusable lessons, or preparing a handoff. Recovers relevant project context and records evidence, decisions, assumptions, open questions, validation status, and next action without inventing a confidence score.
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

For a resumed, multi-file, or high-risk task in an initialized project, recover only the relevant context in the following order. All project-state files live in `.agents/context/`; native Antigravity skills live in `.agents/skills/`. If a state file does not exist, inspect the repository and create it only when persistent tracking is requested.

```text
1. .agents/context/PROJECT_PROFILE.md  → Static Project Identity & Tech Stack (Flutter/Dart version, DB, Routing)
2. AGENTS.md               → Core Governance Laws, Quality Rules & Behavioral Constraints
3. .agents/context/CURRENT_STATE.md    → Active work goal, evidence, decisions, assumptions, and open questions
4. .agents/context/KNOWLEDGE_INDEX.md  → Fast Context Map to ADRs, Skills, and Source Folders
5. .agents/context/AGENTS_MEMORY.md    → Working Ledger, Milestones, Health Meter & Lessons Learned
6. Relevant ADRs           → Architectural Decision Records in decisions/ or .agents/context/decisions/
7. Relevant Skills         → Orthogonal Domain Skills in skills/
8. .agents/context/SESSION_LOG.md      → Chronological Session History
```

---

## 🔬 Decision Record Rules

When updating `CURRENT_STATE.md`, record the evidence, decisions, assumptions, unresolved questions, validation status, and next action that affect the work. Do not use a numerical confidence score as a gate or substitute for evidence.

```yaml
DecisionReadiness:
  evidence: "Affected feature and existing state approach inspected."
  decisions: "Reuse the feature's Cubit implementation."
  assumptions: "The reported failure is reproducible in the existing widget test."
  open_questions: "None that change the selected fix."
  next_validation: "Run the focused widget test, then the relevant test suite."
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

To prevent git history pollution and commit noise, `.agents/context/AGENTS_MEMORY.md` and `.agents/context/CURRENT_STATE.md` are updated **ONLY** under the following triggers:
1. **Feature Completion:** A full feature or milestone is completed and verified.
2. **Architecture Change:** A major architectural pattern, dependency, or DB schema changes.
3. **Explicit User Request:** The user types `checkpoint state` or `save progress`.
4. **Session Handoff:** At session completion before returning the final report to the user.

---

## 🧹 Memory Compaction Without Data Loss

Keep active state concise, but do not silently delete or rewrite history. When a session log becomes difficult to navigate, create a dated archive under `.agents/context/archive/`, retain a short index and the current open decisions in `SESSION_LOG.md`, and link the archive from `KNOWLEDGE_INDEX.md`. Compact completed milestones only after confirming that the summary preserves the original decision, evidence, date, owner, and reference. Never compact a record that contains unresolved risk, a pending user decision, or a requirement that has not been captured elsewhere.

---

## 💡 Lessons Learned Protocol

When an unexpected bug, memory leak, or architectural anti-pattern is resolved, append a concise anti-regression entry to `.agents/context/AGENTS_MEMORY.md` only if the lesson is reusable. Include the trigger, root cause, corrective action, validation evidence, and a link to the affected code, test, or issue when available.

---

## Related Skills

- `flutter-grill-me` — Focused requirement-interrogation workflow for material uncertainty
- `flutter-product-discovery-and-architecture` — PRD scaffolding (PRODUCT_REQUIREMENTS.md)
- `flutter-domain-modeling` — Domain Map scaffolding (DOMAIN_MAP.md)
- `flutter-production-readiness` — Production checklist verification (PRODUCTION_CHECKLIST.md)
- `flutter-create-feature` — Triggers this skill for session initialization in Step 0
- `flutter-code-review` — Reviews project context and validation evidence when they are relevant

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
