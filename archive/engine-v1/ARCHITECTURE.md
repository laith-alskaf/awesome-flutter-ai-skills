# AI Engineering OS — Architecture Specification

## 1. Vision
The **AI Engineering OS** is a language-agnostic runtime for coordinating specialized AI Software Engineering Agents. It moves away from the "chat with an LLM" paradigm into a strict, event-driven, contract-based execution environment capable of planning, scheduling, validating, and rolling back complex software tasks.

## 2. Core Principles
1. **Contract-First**: Every Agent and System Component has a strict, immutable Input/Output interface.
2. **Event-Driven**: Components do not call each other directly; they emit and consume events on the Event Bus.
3. **Evidence Over Assumption**: Recommendations must follow the strict chain: `Evidence → Observation → Hypothesis → Validation → Conclusion → Recommendation`.
4. **Fail Fast**: The Validator (Review Board) blocks conflicting or low-quality code from reaching the main branch.
5. **Human-in-the-Loop (HITL)**: Execution pauses automatically at Destructive Gates and Pre-Execution Gates for human approval.

## 3. The Runtime Flow (Event-Driven)
The OS coordinates via the **Event Bus**.

```text
User Request
  ↓
[Planner] → Emits `PlanCreated`
  ↓
[Scheduler] → Consumes `PlanCreated` → Emits `ExecutionGraphGenerated`
  ↓
[Orchestrator] → Consumes `ExecutionGraphGenerated` → Dispatches `TaskStarted` to Agents
  ↓
[Domain Agents] → Consume `TaskStarted` → Emit `TaskCompleted` (with JSON state)
  ↓
[Orchestrator] → Aggregates results → Emits `ValidationRequested`
  ↓
[Validator Review Board] → Consumes `ValidationRequested`
  ├── If PASS: Emits `ExecutionCompleted`
  └── If FAIL: Emits `ValidationFailed`
  ↓
[Orchestrator] → Consumes `ValidationFailed`
  ├── Attempts self-correction via Agents.
  └── If fails 3x: Emits `RollbackTriggered` and escalates to Human.
```

## 4. Components
- **Planner**: Determines "What" needs to be done. Outputs Tasks and Objectives.
- **Scheduler**: Determines "When" and "How" tasks are executed. Adds Resource Awareness and builds the DAG.
- **Orchestrator**: The Event Listener and State Machine. Routes tasks and manages state passing.
- **Validator**: The Review Board (Architecture, Security, Performance). Audits all outputs.
- **Event Bus**: The central message broker tying the system together.
- **Agents**: Specialized entities (e.g., `flutter-ui-agent`) that execute discrete tasks.

## 5. Extension Model
New Agents are registered in the `capability-graph.yaml`. The graph defines what an Agent `consumes`, `produces`, `depends_on`, and `conflicts_with`. This allows the OS to support Flutter today, and React, Node.js, or Go tomorrow without modifying the core Engine.
