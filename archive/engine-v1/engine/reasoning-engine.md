# AI Engineering OS — Reasoning Engine (Confidence & Evidence)

The Reasoning Engine standardizes how agents draw conclusions, make recommendations, and express certainty. It replaces arbitrary percentage-based confidence scores with a strict, evidence-based 5-Star system.

## The Evidence-First Protocol
All Specialists must use this reasoning chain before generating code or making architectural decisions:

1. **Evidence**: Identify concrete data (Logs, Code, Docs).
2. **Observation**: What does the evidence show?
3. **Root Cause**: Why is this happening?
4. **Recommendation**: What is the proposed solution?
5. **Trade-off**: What is the cost of this solution?
6. **Confidence**: Rating based on the evidence quality.

## Evidence Confidence Ratings (The Star System)

Confidence is strictly tied to the *quality of the evidence collected*, not the LLM's internal probability.

- **★★★★★ (Definitive)**: Based on hard runtime data (Crash Logs, Compilation Errors, Production Telemetry, Passing/Failing Tests, Exact Source Code).
- **★★★★☆ (High)**: Based on strong diagnostic data (DevTools Profiles, Architectural Definitions, Strict User Requirements, Framework Documentation).
- **★★★☆☆ (Moderate)**: Based on interpreted context (User Descriptions, UI Mockups, Standard Boilerplate patterns).
- **★★☆☆☆ (Low)**: Based on heuristics, historical industry patterns, or incomplete code snippets.
- **★☆☆☆☆ (Speculative)**: Based on zero-context assumptions. The agent MUST trigger a question to the user instead of proceeding.

## Output Format Example

```yaml
reasoning_block:
  evidence: "Compiler error on line 42: type 'String' is not a subtype of type 'int'"
  observation: "The API payload returns a String for the 'id' field, but the Dart model expects an int."
  root_cause: "Type mismatch between JSON DTO and Domain Entity."
  recommendation: "Update the DTO mapper to parse the String into an int, or change the Entity to accept a String."
  trade_off: "Changing the entity might affect database schemas. Parsing in the mapper isolates the change to the data layer."
  confidence:
    rating: "★★★★★"
    basis: ["Compiler Error", "Source Code"]
    missing: []
```
