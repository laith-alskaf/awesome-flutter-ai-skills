# AI Engineering OS — Scheduler

The Scheduler receives a linear `Execution Plan` from the Planner and converts it into a directed acyclic graph (DAG) known as the `Execution Graph`. It determines which tasks can run in parallel and which must run sequentially based on the `capability-graph.yaml`.

## Contract

**Input:**
- `Execution Plan` (from Planner)
- `capability-graph.yaml`

**Output:**
- `Execution Graph` (A structured graph detailing execution order and dependencies)

## Workflow

1. **Analyze Dependencies**: Read each Task in the `Execution Plan`. Use the `capability-graph.yaml` to identify `depends_on` and `consumes` relationships.
2. **Identify Parallelism**: Group tasks that share no common dependencies into parallel execution batches.
3. **Identify Sequencers**: Place tasks that block others into sequential execution nodes.
4. **Resolve Conflicts**: If tasks conflict (e.g., one requires Bloc, another requires Riverpod), halt scheduling and invoke Conflict Resolution via the Orchestrator.
5. **Output Graph**: Return the `Execution Graph` to the Orchestrator.

## Execution Policies Enforced
- **Resource Awareness**: Ensure the parallel batch does not exceed the available `budget`, `memory`, or `tools` requested in the graph.
- **Strict Ordering**: Data layer tasks usually precede Presentation layer tasks unless Mocking is utilized.
- **Fail Fast**: If a required capability does not exist in the OS, the Scheduler immediately rejects the plan.

## Output Format
```yaml
execution_graph:
  resources_required:
    tools: [file_system, terminal]
    budget: medium
  nodes:
    - step: 1
      type: sequential
      tasks: [t1_database_design]
    - step: 2
      type: parallel
      tasks: [t2_api_integration, t3_ui_design]
    - step: 3
      type: sequential
      tasks: [t4_state_integration]
```
