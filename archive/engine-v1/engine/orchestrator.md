# AI Engineering OS — Orchestrator (The Coordinator)

The Orchestrator is the central nervous system of the OS. Unlike legacy systems, it does not "think" or write code. Its sole purpose is to execute the `Execution Graph` provided by the Scheduler by routing tasks to the appropriate Specialists, passing state, and managing Human-in-the-Loop interventions.

## Contract

**Input:**
- `Execution Graph` (From Scheduler)
- `Project Context` & `Session Context`

**Output:**
- `Aggregated Execution Results` (Passed to the Validator)

## State Passing Mechanism (JSON Contracts)
The Orchestrator manages the flow of data between sequential skills using strict JSON contracts.
When Skill A (e.g., `api-expert`) finishes, it outputs a structured JSON result (e.g., endpoint definitions). The Orchestrator extracts this payload and injects it into the prompt for Skill B (e.g., `ui-engineer`) as `Consumed State`.

## The Execution State Machine
The Orchestrator operates strictly within these states:
1. `Idle`: Waiting for user request.
2. `Planning`: Invoking Planner and Scheduler.
3. **`Waiting Human Approval (Plan)`**: *[HITL Intervention]* Halts execution to let the human review the Execution Graph before any code is generated.
4. `Executing`: Routing tasks to Specialists based on the Graph (handling parallel/sequential execution).
5. `Reviewing`: Passing results to the Validator.
6. **`Waiting Human Approval (Release)`**: *[HITL Intervention]* Halts execution to let the human approve the final verified output.
7. `Completed`: Archiving the Session Context.
8. `Rollback`: Reverting to previous state if unresolvable failures occur.

## Human-in-the-Loop (HITL) Policies
The Orchestrator mandates human intervention at three critical points:
1. **Pre-Execution Gate**: The user must approve the `Execution Plan` and chosen Architecture.
2. **Destructive Action Gate**: Any task requiring capability `execute_write` (e.g., deleting files, pushing to production) halts for approval.
3. **Validation Failure Gate**: If the Validator detects an unresolvable conflict, the Orchestrator pauses and asks the user for a manual decision.

## Failure Recovery & Infinite Loop Prevention
If the Validator rejects a specialist's output more than 3 consecutive times:
1. The Orchestrator halts execution immediately.
2. The Orchestrator enters the `Rollback` state, reverting the codebase to the state before the task began.
3. A `Failure Escalation Report` is generated and presented to the human developer.
