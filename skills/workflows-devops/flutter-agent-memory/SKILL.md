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

When starting ANY new development session or resuming work, AI Agents MUST execute the following 8-step reading order before modifying any code (all project memory files live in `.ai/`):

```text
1. .ai/PROJECT_PROFILE.md  → Static Project Identity & Tech Stack (Flutter/Dart version, DB, Routing)
2. AGENTS.md               → Core Governance Laws, Quality Rules & Behavioral Constraints
3. .ai/CURRENT_STATE.md    → Active Work Goal, Context, Assumptions & Confidence Matrix
4. .ai/KNOWLEDGE_INDEX.md  → Fast Context Map to ADRs, Skills, and Source Folders
5. .ai/AGENTS_MEMORY.md    → Working Ledger, Milestones, Health Meter & Lessons Learned
6. Relevant ADRs           → Architectural Decision Records in decisions/ or .ai/decisions/
7. Relevant Skills         → Orthogonal Domain Skills in skills/
8. .ai/SESSION_LOG.md      → Chronological Session History
```

---

## 🔬 Reasoning & Confidence Matrix Rules

Whenever updating `CURRENT_STATE.md`, the AI Agent MUST calculate and log its reasoning confidence:

```yaml
Confidence:
  level: High           # [High, Medium, Low]
  score: 0.95           # [0.00 to 1.00 score]
  reason: "Clean Architecture layer boundaries verified; repository unit tests pass zero warning policy."
```

> [!WARNING]
> **ANTI-HALLUCINATION CONFIDENCE THRESHOLD (< 0.80):** If the calculated reasoning confidence score is below **`0.80`** (`score < 0.80`), or if any architectural layer boundaries/state management rules are ambiguous, the AI Agent is strictly **forbidden from modifying any code**. The agent MUST immediately invoke **`flutter-grill-me`** (Grill-Me Mode) to interrogate the user across the 5 engineering dimensions until confidence reaches `score >= 0.80`.

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

To prevent git history pollution and commit noise, `.ai/AGENTS_MEMORY.md` and `.ai/CURRENT_STATE.md` are updated **ONLY** under the following triggers:
1. **Feature Completion:** A full feature or milestone is completed and verified.
2. **Architecture Change:** A major architectural pattern, dependency, or DB schema changes.
3. **Explicit User Request:** The user types `checkpoint state` or `save progress`.
4. **Session Handoff:** At session completion before returning the final report to the user.

---

## 🧹 Memory Compaction & Auto-Pruning Protocol (Zero Context Bloat)

To prevent context window exhaustion and prompt bloat as projects scale past 100,000 lines of code, AI Agents MUST enforce automated memory pruning:
1. **Session Log Threshold (`SESSION_LOG.md`):** Whenever `.ai/SESSION_LOG.md` exceeds **100 lines**, the agent MUST execute an auto-pruning sprint:
   - Archive the chronological log details into `.ai/archive/session_log_archived_<date>.md`.
   - Keep only the last 15 active lines in `.ai/SESSION_LOG.md`.
2. **Working Ledger Threshold (`AGENTS_MEMORY.md`):** Whenever `.ai/AGENTS_MEMORY.md` exceeds **3,000 words**, the agent MUST compress completed milestones:
   - Extract completed milestone details into a reference entry inside `.ai/KNOWLEDGE_INDEX.md` or a new ADR.
   - Replace the verbose milestone description in `AGENTS_MEMORY.md` with a clean 1-line link: `[Milestone X Completed -> See KNOWLEDGE_INDEX.md#milestone-x]`.
   - Reset active working memory tokens to maintain a lean (<1,000 word) operational footprint.

---

## 💡 Lessons Learned Protocol

Whenever an unexpected bug, memory leak, or architectural anti-pattern is resolved, the AI Agent MUST append a short entry to the `Lessons Learned & Anti-Regression Log` in `.ai/AGENTS_MEMORY.md` to prevent repeating past mistakes in future sessions.
