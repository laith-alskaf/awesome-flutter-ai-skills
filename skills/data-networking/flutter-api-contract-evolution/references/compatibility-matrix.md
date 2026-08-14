# Contract Compatibility Matrix

Read this guide for a breaking or multi-client contract change.

## Compatibility Questions

| Question | Why it matters |
|---|---|
| Which released clients consume this operation? | Determines whether a server-first or client-first rollout is safe. |
| Is the change additive, semantic, or destructive? | Determines whether optional fields, versioning, or a migration are required. |
| Does a local cache persist the changed shape? | Determines whether a schema migration or invalidation path is needed. |
| Is the field security, consent, money, or authorization sensitive? | Prevents unsafe defaults and silent fallback. |
| Who owns removal and by what date? | Prevents permanent compatibility debt. |

## Safe Rollout Shapes

Use server-first rollout when a server can add a backwards-compatible field or endpoint before any client consumes it. Use dual-read or dual-write only for a documented transition, with clear telemetry and removal ownership. Use explicit endpoint or schema versioning when semantic meaning, required fields, pagination, or identifiers cannot remain compatible.

## Contract Test Evidence

Contract tests should exercise serialized request and response examples at the client boundary. Mapping tests should cover missing, null, unknown, deprecated, and malformed values. User-flow tests should prove the affected loading, error, empty, authorization, and success behavior. Keep fixtures free of real credentials or production PII.
