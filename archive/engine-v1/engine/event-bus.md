# AI Engineering OS — Event Bus

The Event Bus decouples the OS components. Instead of the Orchestrator calling the Validator directly, components emit events to the Bus, and the Bus triggers the appropriate listeners.

## Standard Events

1. **`PlanRequested`**
   - **Emitter**: User Interface / CLI
   - **Consumer**: Planner

2. **`PlanCreated`**
   - **Emitter**: Planner
   - **Consumer**: Scheduler

3. **`ExecutionGraphGenerated`**
   - **Emitter**: Scheduler
   - **Consumer**: Orchestrator

4. **`TaskStarted`**
   - **Emitter**: Orchestrator
   - **Consumer**: Specific Agent (e.g., flutter-api-agent)

5. **`TaskCompleted`**
   - **Emitter**: Agent
   - **Consumer**: Orchestrator

6. **`ValidationRequested`**
   - **Emitter**: Orchestrator
   - **Consumer**: Validator (Review Board)

7. **`ValidationPassed` / `ValidationFailed`**
   - **Emitter**: Validator
   - **Consumer**: Orchestrator

8. **`RollbackTriggered`**
   - **Emitter**: Orchestrator
   - **Consumer**: File System / State Manager (escalates to User)

## Event Payload Structure
All events must wrap their payloads in a standard envelope:
```json
{
  "event_id": "evt_12345",
  "timestamp": "2026-07-01T10:00:00Z",
  "type": "ValidationFailed",
  "source": "validator",
  "payload": { ... }
}
```
