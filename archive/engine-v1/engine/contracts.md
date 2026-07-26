# AI Engineering OS — Contracts

This document defines the strict JSON/YAML contracts that govern communication between the OS components over the Event Bus. Breaking a contract results in an immediate `ValidationFailed` event.

## 1. Planner Contract

**Input:**
- `User Request`
- `Project Context`

**Output (`PlanCreated` Event Payload):**
```yaml
plan_id: "plan_001"
objectives:
  - "Implement offline storage"
  - "Ensure zero UI jank"
risk_analysis:
  technical: "Migration of existing SQLite schema"
  security: "Encryption of local tokens"
tasks:
  - id: "t1"
    capability: "DatabaseDesign"
```

## 2. Scheduler Contract

**Input:**
- `PlanCreated` Payload
- `capability-graph.yaml`

**Output (`ExecutionGraphGenerated` Event Payload):**
```yaml
graph_id: "graph_001"
resources_required:
  tools: ["file_system"]
  budget: "medium"
execution_nodes:
  - step: 1
    type: "parallel"
    agents: ["api-agent", "database-agent"]
```

## 3. Agent Execution Contract

**Input (`TaskStarted` Event Payload):**
- `Task Details`
- `Consumed State` (Output from previous agents)

**Output (`TaskCompleted` Event Payload):**
```yaml
agent_id: "flutter-api-agent"
status: "success"
state_delta:
  endpoints_created: ["/login", "/checkout"]
reasoning_chain:
  evidence: "..."
  observation: "..."
  hypothesis: "..."
  validation: "..."
  conclusion: "..."
  recommendation: "..."
```

## 4. Validator Contract

**Input (`ValidationRequested` Event Payload):**
- `Aggregated State Deltas`
- `policy-engine.md` overrides

**Output (`ValidationCompleted` or `ValidationFailed`):**
```yaml
status: "failed"
review_board:
  architecture_review: "pass"
  security_review: "fail"
details: "Hardcoded token found in auth_repository.dart"
```
