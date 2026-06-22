---
name: backend-service-design
description: Use when designing or changing backend APIs, services, repositories, workers, jobs, external clients, auth flows, configs, or service boundaries. Focus on contracts, ownership, data access, reliability, tests, and operations.
---

# Backend Service Design

## Workflow

1. Read local `AGENTS.md`, README/docs, API specs, schemas, migrations, configs, CI/build files, and nearby tests.
2. Identify the behavior owner: API/presentation, application service/use case, domain, repository/data access, worker/job, external client, config, or deployment.
3. Preserve public contracts unless the task explicitly changes them.
4. Keep request parsing, auth extraction, status codes, and response/error mapping at API boundaries.
5. Keep orchestration, policy sequencing, transactions, idempotency, and DTO assembly in the owning service/use case.
6. Keep DB/ORM/cache/queue/SDK details in infrastructure/adapters.
7. Validate with the smallest meaningful tests and generated artifacts; broaden validation when contracts or shared flows changed.

## Backend Checks

- Input validation happens at trust boundaries.
- Auth/authz checks are preserved and tested on denied paths.
- Error mapping is intentional and does not leak secrets, internal IDs, or sensitive data.
- Transactions protect invariants and do not wrap slow external network calls.
- External clients use timeouts, cancellation, useful error context, and bounded retries where appropriate.
- Workers/jobs are idempotent when duplicate delivery or retries are possible.
- DB access avoids N+1 queries, unbounded scans, unbounded result sets, and unnecessary round trips.
- Pagination, batching, rate limits, and backpressure are explicit for list/fan-out paths.
- API specs, event schemas, migrations, docs, fixtures, and generated artifacts stay in sync with behavior.
- Config and deployment expectations match runtime behavior.

## Implementation Rules

- Prefer existing local patterns over introducing new frameworks or architecture layers.
- Keep changes narrow and behavior-driven. Do not perform drive-by cleanup.
- Make side effects explicit and safe to repeat where feasible.
- Keep logs useful, structured when the repo uses structured logging, and non-sensitive.
- Do not add speculative extensibility, compatibility paths, or dependencies unless required by the task.
- When changing shared behavior, trace upstream callers and downstream effects before editing.

## Validation Menu

Choose the smallest command that proves the changed behavior, then broaden only when blast radius warrants it:

- Focused unit tests for the owning service/domain behavior.
- Integration tests for DB/repository, API, queue, or external-client boundaries.
- Contract or generated-spec checks for API/event/schema changes.
- Migration dry-run or schema validation when available and safe.
- Lint/typecheck/build commands from repo docs or CI.

Do not run destructive DB operations, deploys, rollbacks, external writes, or production-impacting commands unless explicitly requested.

## Output

Report:

- Behavior owner and affected contracts.
- Files/modules changed or proposed.
- Tests/checks run or skipped with exact commands.
- Operational and rollout risks.
- Remaining assumptions or open questions.

Use `references/backend-change-checklist.md` for a compact before/during/handoff checklist.
