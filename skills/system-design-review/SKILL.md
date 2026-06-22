---
name: system-design-review
description: Use for system design, architecture proposals, ADRs, service decomposition, scale planning, storage/queue/cache choices, reliability trade-offs, rollout plans, and design reviews. Do not use for small local code edits.
---

# System Design Review

## Workflow

1. Identify the design target: new system, new feature, migration, scale-up, reliability improvement, or architecture review.
2. Separate confirmed requirements from assumptions. State assumptions that affect capacity, latency, consistency, cost, or rollout risk.
3. Define the system boundary: users, clients, APIs, services, databases, queues, caches, workers, external dependencies, and deployment surfaces.
4. Design the simplest architecture that satisfies the known requirements. Prefer existing platform patterns before introducing new infrastructure.
5. Evaluate trade-offs explicitly: consistency, availability, latency, throughput, complexity, operability, security/privacy, and cost.
6. Identify failure modes and operational controls before finalizing the design.
7. Produce an implementation or migration plan only after the design boundary and risks are clear.

## Design Checks

- Functional requirements: main workflows, edge cases, user-visible contracts, and out-of-scope behavior.
- Non-functional requirements: p95/p99 latency, throughput, data volume, availability, recovery, retention, and cost targets.
- API surface: request/response contracts, idempotency keys, pagination, status/error mapping, and compatibility.
- Data model: ownership, schema, indexes, lifecycle, consistency, backfill, retention, and privacy constraints.
- Storage choice: read/write pattern, transactions, query shape, scale path, backup/restore, and operational maturity.
- Queue/event design: producer/consumer ownership, ordering, duplicate delivery, retries, dead letters, replay, and schema evolution.
- Cache design: keying, invalidation, TTL, stampede protection, stale reads, and fallback behavior.
- Reliability: timeouts, retries, circuit breakers, backpressure, rate limits, bulkheads, graceful degradation, and recovery.
- Observability: logs, metrics, traces, dashboards, alerts, runbooks, SLOs, and correlation IDs.
- Security/privacy: auth/authz, tenant boundaries, PII, secrets, auditability, data minimization, and compliance constraints.
- Rollout: feature flags, shadow/canary, dual writes, migrations, rollback/mitigation, and compatibility window.

## Anti-Patterns

- Do not invent scale requirements when none are stated; provide assumption ranges instead.
- Do not choose new infrastructure only because it is fashionable.
- Do not hide hard constraints behind vague phrases such as "eventually scalable" or "highly available".
- Do not ignore operational ownership, migration order, or rollback path.
- Do not optimize for theoretical peak scale before the common path is correct and observable.

## Output

For design work, report:

- Requirements and assumptions.
- Proposed architecture and key components.
- Data/API/event contracts.
- Trade-offs and rejected alternatives.
- Failure modes and operational controls.
- Migration or rollout plan.
- Validation plan and open questions.

Use `references/design-brief-template.md` for design proposals, `references/adr-template.md` for architecture decision records, and `references/capacity-planning.md` when capacity assumptions matter.
