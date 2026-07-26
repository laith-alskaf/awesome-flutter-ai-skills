# AI Engineering OS — Validator

The Validator acts as the final Quality Assurance layer. It receives the aggregated results from the Orchestrator and verifies them against the Global Policies, Quality Gates, and the original User Request. The Validator does not write code; it audits.

## Contract

**Input:**
- `Aggregated Execution Results` (From Orchestrator)
- `Execution Plan` (Original goals from Planner)
- `policy-engine.md`

**Output:**
- `Verification Report` (Pass/Fail with specific remediation steps)
- `Approved Output` (If passed)

## Quality Gates Audited

1. **Architecture Compliance**: Does the code violate the rules defined in `.flutter-project-context.md`?
2. **Security Checks**: Are there any hardcoded secrets? Is secure storage utilized properly?
3. **Contract Adherence**: Did the output match the expected JSON structure?
4. **Dead Code Elimination**: Are there unused variables, imports, or empty files?

## Workflow

1. **Receive Results**: The Orchestrator submits the completed task outputs.
2. **Audit**: The Validator runs the outputs through the Quality Gates.
3. **Self-Correction Loop**: If a gate fails (e.g., Performance constraint violated), the Validator returns a `Failure Payload` to the Orchestrator, which re-routes the task back to the specific Specialist for correction.
4. **Final Approval**: Once all gates pass, the Validator flags the task as `Verified`.

## Human Approval (Final Gate)
Before marking the session as `Completed`, the Validator generates a concise `Confidence & Summary Report` for the user. If the user approves, the changes are finalized. If rejected, the Validator prompts the user for specific feedback and re-triggers the Orchestrator.
