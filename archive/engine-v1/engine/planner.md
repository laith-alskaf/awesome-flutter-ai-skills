# AI Engineering OS — Planner

The Planner is the entry point for complex engineering requests. It does not execute code; its sole responsibility is to break down a high-level user request into a structured Execution Plan consisting of discrete Tasks.

## Contract

**Input:**
- `User Request` (e.g., "Build an offline-first shopping cart feature")
- `Project Context`
- `Session Context`

**Output (`PlanCreated` Event):**
- `Execution Plan` (A list of Tasks with required inputs and expected outputs)
- `Objectives` (Clear business/technical goals like "Fast startup", "Offline")

## Workflow

1. **Understand Goal**: Parse the user request to determine the primary business objective.
2. **Set Objectives**: Define explicitly what success looks like.
3. **Contextualize**: Check the `Project Context` to determine the language, framework, and architectural constraints.
3. **Decompose**: Break the request down into logical engineering steps (e.g., Architecture Design → Database Schema → API Integration → State Management → UI Implementation).
4. **Assess Risks**: Identify potential technical, security, or performance risks associated with the requested feature.
5. **Draft Tasks**: For each step, create a Task that maps to a capability in the `capability-graph.yaml`.
6. **Output Plan**: Return the structured `Execution Plan` to the Scheduler.

## Execution Policy Mapping
The Planner must specify if a task is:
- `Mandatory`: Must be completed for the feature to work.
- `Optional`: Enhancements (e.g., Adding subtle animations).
- `Blocking`: Cannot proceed to the next phase until complete.

## Output Format
```json
{
  "plan_id": "cart_feature_01",
  "goal": "Implement offline shopping cart",
  "objectives": [
    "Ensure zero UI jank",
    "Support offline mode"
  ],
  "identified_risks": [
    "Data sync conflicts when reconnecting to network",
    "Local database schema migration needed"
  ],
  "tasks": [
    {
      "id": "t1",
      "capability_required": "DatabaseDesign",
      "description": "Design local SQLite schema for cart items",
      "type": "Blocking"
    },
    {
      "id": "t2",
      "capability_required": "StateManagement",
      "description": "Create Riverpod providers for cart state",
      "type": "Mandatory"
    }
  ]
}
```
