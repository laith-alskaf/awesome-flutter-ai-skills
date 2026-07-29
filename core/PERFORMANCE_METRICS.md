# AI Performance Metrics & Token Budgets

This document outlines the strict Key Performance Indicators (KPIs) and Token Budgets that govern the AI Engineering Operating System. 

## 1. Token Budget Constraints
To prevent LLM context dilution and token exhaustion, every skill module must strictly adhere to the following budgets.
*Note: Token estimates assume 1 token ≈ 4 characters of English text/code.*

- **Global Boot Context (The OS Kernel)**: Max `1,500` tokens combined.
  - `AGENTS.md` + `ROUTER_MANIFESTO.md` must remain concise.
- **Skill Core (`SKILL.md`)**: Max `1,000` tokens per skill.
- **Skill Knowledge Graph (`metadata.yaml`)**: Max `100` tokens.
- **Skill Templates (`templates/*.template`)**: Max `1,500` tokens per template.
- **Total Task Execution Context**: When an agent executes a single task, the total framework knowledge loaded into memory must NEVER exceed **4,500 tokens**.

## 2. Target Performance KPIs
The framework is measured against the following success criteria during real-world AI coding sessions:

| Metric | Target KPI | Definition |
| :--- | :--- | :--- |
| **Routing Accuracy** | > 99% | The AI Agent selects the exact correct `SKILL.md` based on the user's intent without hallucinating a different path. |
| **Ambiguity Trigger Rate**| < 5% | The percentage of sessions where the Agent halts and triggers the `flutter-grill-me` protocol due to low confidence (< 0.80). |
| **Hallucination Rate** | 0% | The Agent invents zero non-existent APIs, Flutter packages, or invalid state management combinations. |
| **Skills Loaded** | Max 3 | The Agent loads no more than 3 distinct skills into working memory for any single atomic task. |
| **Orphaned Context** | 0% | The Agent successfully unloads skills from memory when switching to an unrelated task. |

## 3. Auditing the Metrics
The `tools/audit_framework.dart` utility automatically measures the physical token size of the repository. It will fail the CI/CD pipeline if any `SKILL.md` file exceeds the 1,000-token limit or if a template becomes bloated.

**Human Auditing:**
The "Routing Accuracy" and "Hallucination Rate" must be manually audited by reviewing `.ai/SESSION_LOG.md` files generated during development cycles.
