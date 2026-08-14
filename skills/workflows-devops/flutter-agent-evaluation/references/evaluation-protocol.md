# Evaluation Protocol

Use this protocol when evaluating a skill or rule change.

## Evidence Classes

| Evidence class | What it proves | What it cannot prove |
|---|---|---|
| Structural validation | Names, metadata, paths, references, scenario schema, and installer contracts are consistent. | A specific model will select or follow a skill. |
| Script or installer dry run | A command path and its declared non-destructive behavior can execute. | Runtime behavior on every operating system or project. |
| Fixture-based routing review | A scenario has a declared authoritative skill boundary. | The exact probabilistic routing behavior of every model. |
| Sampled live-agent run | A named model and version produced an observed result for a prompt. | General behavior across prompts, models, or future versions. |

## Scenario Quality

A useful scenario is realistic, focused on a decision boundary, and has observable expected behavior. Avoid prompts that repeat the skill description verbatim. Include a negative or ambiguity case when it prevents incorrect activation, unnecessary questions, or an unsafe change.

## Failure Triage

If a scenario fails structurally, repair the fixture, metadata, references, or validator. If a human or live-agent review finds a routing mismatch, first clarify the skill description and scope, then improve the route matrix or negative triggers. Do not add an always-on rule unless the behavior is truly universal and low-cost.
