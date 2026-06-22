---
name: api-contract-design
description: Use when designing or changing REST, gRPC, GraphQL, webhook, event, DTO, SDK, OpenAPI, protobuf, or public interface contracts. Focus on compatibility, validation, error semantics, pagination, versioning, and generated artifacts.
---

# API Contract Design

## Workflow

1. Identify the contract boundary and consumers: internal service, external client, mobile app, SDK, partner, worker, or event consumer.
2. Inspect current specs, generated code, DTOs, handlers, tests, examples, docs, and clients before editing.
3. Preserve backward compatibility unless the user explicitly requested a breaking change.
4. Separate wire contract from internal domain/ORM/SDK models.
5. Define validation, authorization, error mapping, idempotency, pagination, and compatibility behavior.
6. Update generated artifacts and examples when the source contract changes.
7. Add or update contract tests when behavior can break consumers.

## Contract Checks

- Request fields: required/optional, defaults, nullability, enum values, limits, validation, and unknown-field behavior.
- Response fields: stable names, types, optionality, ordering, pagination metadata, and partial-data semantics.
- Errors: status/code mapping, retryability, user-safe messages, machine-readable details, and correlation IDs.
- Versioning: additive change, deprecation path, compatibility window, and migration docs.
- Idempotency: create/update/retry semantics, idempotency keys, duplicate handling, and side-effect safety.
- Pagination/filtering/sorting: bounded limits, stable cursors, deterministic ordering, and index support.
- Events/webhooks: schema version, ordering, duplicate delivery, replay, dead letters, and consumer compatibility.
- SDK/generated artifacts: source spec, generated files, fixtures, docs, and changelog stay synchronized.

## Anti-Patterns

- Do not expose ORM models, SDK objects, or internal exceptions as public contracts.
- Do not rename or remove public fields without a migration plan.
- Do not rely on clients ignoring new required fields.
- Do not introduce unbounded list endpoints.
- Do not make error responses inconsistent across similar endpoints.

## Validation Menu

- Contract tests for request/response/error cases.
- Snapshot tests only when they protect the real public shape and are easy to review.
- OpenAPI/protobuf/GraphQL generation command from repo docs.
- SDK generation and compile/typecheck when clients are committed.
- Consumer tests or compatibility fixtures when available.

## Output

Report:

- Contract changed and compatibility level.
- Consumers affected.
- Generated files/docs updated.
- Tests/checks run.
- Migration, deprecation, or rollout notes.

Use `references/contract-change-matrix.md` when a change may affect compatibility.
