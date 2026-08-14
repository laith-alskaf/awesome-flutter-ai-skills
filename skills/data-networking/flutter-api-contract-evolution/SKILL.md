---
name: flutter-api-contract-evolution
description: Evolve REST or GraphQL API contracts and Flutter DTO mappings safely. Use for versioned endpoints, schema changes, compatibility windows, deprecations, rollout plans, contract tests, and data migrations; do not use for ordinary single-endpoint client implementation.
---

# Flutter API Contract Evolution

Use this skill when a change can affect more than one released client, server, schema, DTO, cache, or persisted record. Treat the server and client contract as a versioned product boundary.

## Map the Existing Contract

Identify the contract owner, consumers, endpoint or operation, request and response schema, DTO and mapper locations, failure mapping, cache or local database implications, authentication behavior, analytics events, and release sequence. Do not infer server behavior from a client DTO alone.

Write the before-and-after contract in `templates/contract-change-record.md.template`. Read `references/compatibility-matrix.md` when deciding whether a change is additive, compatible with a transition, or breaking.

## Select a Compatibility Strategy

| Change type | Preferred strategy |
|---|---|
| Add an optional field or enum value | Make client parsing forward-compatible and preserve unknown values where safe. |
| Rename, remove, or change meaning | Add a compatibility window, versioned field or endpoint, and deprecation date. |
| Change identifier, pagination, or ordering semantics | Version the contract and test migration, caching, and UI assumptions explicitly. |
| Change persisted local data | Plan a local migration, recovery behavior, and rollback containment before rollout. |
| GraphQL schema change | Coordinate generated types, persisted operations, cache normalization, and server deprecation. |

Do not silently default a missing security, money, consent, or authorization field. Escalate material ambiguity with `flutter-grill-me`.

## Implement in Contract Order

1. Define the new server contract and compatibility guarantees before changing Flutter code.
2. Update DTOs, serializers, mappers, failures, and repository interfaces without leaking transport types into Domain.
3. Make old and new client paths coexist only for the stated compatibility window.
4. Add contract-level tests, mapping tests, and user-flow tests for the changed behavior.
5. Deploy in an order that ensures every released client has a supported server path.
6. Remove deprecated paths only after telemetry or owner evidence shows that the compatibility window is complete.

Use `flutter-api-integration` for transport/client implementation, `flutter-graphql` for GraphQL client setup, `flutter-local-database` for storage mechanics, and `flutter-dependency-upgrade` when generated client or package versions change.

## Validation

- [ ] Contract ownership, consumers, compatibility window, and deprecation owner are recorded.
- [ ] DTOs and mappers preserve layer boundaries and explicitly handle changed fields.
- [ ] Error and authorization semantics are defined for old and new clients.
- [ ] Cache, local migration, and offline behavior are tested when affected.
- [ ] Rollout order supports released clients and includes a containment plan.
- [ ] Contract, mapping, and relevant user-flow tests provide completion evidence.
