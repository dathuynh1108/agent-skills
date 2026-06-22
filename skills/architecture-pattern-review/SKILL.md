---
name: architecture-pattern-review
description: Use when Codex is asked to design or review architecture, choose or apply design patterns, assess module/service boundaries, plan refactors, inspect coupling, evaluate ownership, or make changes that may cross domain, application, infrastructure, API, worker, database, external-client, or deployment boundaries. Covers pragmatic pattern selection, boundary checks, and over-engineering safeguards.
---

# Architecture Pattern Review

## Workflow

- Read the repo `AGENTS.md`, relevant docs, build files, and nearby implementations before proposing or editing architecture.
- Identify the current owner of the behavior before changing it.
- Trace upstream callers, downstream dependencies, persisted data, external contracts, and deployment/runtime surfaces when relevant.
- Use repo-provided code intelligence, call graph, impact, or search tools when available and current.
- Prefer the repo's existing architecture over new abstractions.
- State affected modules and validation plan before substantial edits.

## Boundary Checks

- Keep request parsing, auth extraction, response formatting, and status codes at API/presentation boundaries.
- Keep orchestration, policy sequencing, transactions, and DTO assembly in application/use-case code when the repo has that layer.
- Keep entities, value objects, domain errors, and business invariants out of framework, DB, queue, cache, and HTTP glue when the repo separates those layers.
- Keep DB, ORM, queue, cache, storage, HTTP clients, and SDK objects in infrastructure/adapters.
- Keep workers/jobs idempotent where retries or duplicate delivery are possible.
- Keep service ownership explicit across APIs, events, schemas, auth, config, and deployment.
- Map DTOs, ORM models, SDK objects, and external schemas at boundaries.

## Pattern Selection

- Use a pattern only when it removes real complexity, protects a real boundary, or improves testability.
- Prefer a direct conditional or small function over a pattern with one fake implementation.
- Avoid patterns that hide control flow, scatter domain language, or make debugging harder.
- Use existing local patterns before introducing new ones.

Common fits:

- State: status-dependent behavior.
- Command: explicit user/system action with validation and execution.
- Strategy: provider, algorithm, or policy variation.
- Factory/Builder: complex or conditional creation.
- Port + Adapter: external systems, SDKs, legacy models, unstable boundaries.
- Repository: aggregate persistence.
- Unit of Work: atomic multi-repository work.
- Policy/Specification: reusable named business decisions or predicates.
- Domain Events/Outbox/Inbox: reliable reactions, event publishing, and duplicate-message safety.
- Decorator/Middleware/Interceptor: cross-cutting behavior.
- Facade: intentionally narrow subsystem surface.
- Saga/Process Manager: long-running distributed workflow.
- Timeout + Retry + Circuit Breaker: unstable dependency protection.
- Mapper/Assembler: conversion across layers.

## Distributed-System Checks

- Preserve public API, event, DB, config, auth, and deployment contracts.
- Make retries bounded and idempotent where possible.
- Use explicit timeouts for network calls.
- Avoid transactions around external network calls.
- Define retry and dead-letter behavior when relevant.
- Keep observability useful: request IDs, trace IDs, structured non-sensitive errors.
- Distinguish local code, pushed code, built image, deployed manifest, and live runtime state.

## Review Output

For architecture review or planning, report:

- Current owner and source-chain evidence.
- Proposed boundary or pattern decision.
- Why simpler code is or is not enough.
- Blast radius and regression risks.
- Required tests, migrations, docs, or rollout steps.
