---
name: distributed-systems-reliability
description: Use when work involves retries, idempotency, queues, events, workflows, consistency, timeouts, cancellation, circuit breakers, backpressure, rate limits, duplicate delivery, partial failure, or cross-service reliability.
---

# Distributed Systems Reliability

## Workflow

1. Identify the distributed boundary: HTTP/gRPC call, queue/event, worker, workflow, database transaction, cache, external API, or deployment step.
2. Trace the request or message lifecycle from producer to consumer and all side effects.
3. Define failure modes before changing code: timeout, retry storm, duplicate delivery, partial write, stale cache, lost event, split brain, or dependency outage.
4. Make retries bounded, observable, and safe through idempotency or conflict handling.
5. Prefer simple reliable mechanisms over complex coordination when the business invariant allows it.
6. Validate behavior with focused tests or documented reasoning when integration failure tests are not practical.

## Reliability Checks

- Timeouts exist for network calls, external clients, and long waits.
- Cancellation propagates through request, worker, and repository boundaries where supported.
- Retries use bounded attempts, jittered backoff when appropriate, and retry only retryable failures.
- Idempotency keys or natural uniqueness protect repeated create/update operations.
- Workers handle duplicate messages, poison messages, dead letters, and safe reprocessing.
- Queue consumers define ordering assumptions and partitioning/fan-out behavior.
- Outbox/inbox patterns are considered when DB writes and event publishing must be consistent.
- Backpressure and rate limits prevent unbounded concurrency, memory growth, and dependency overload.
- Cache invalidation and stale reads are acceptable for the contract.
- Rollout order protects old/new producers and consumers during schema or event changes.

## Anti-Patterns

- Infinite retries or retrying all errors blindly.
- Transactions around slow external network calls.
- Assuming exactly-once delivery from queues without proof.
- Fire-and-forget side effects without observability or recovery.
- Hidden global state that breaks concurrency or multi-instance deployment.
- Relying on sleep-based timing in tests when deterministic synchronization is possible.

## Validation Menu

- Unit tests for idempotency, retryable vs non-retryable errors, and duplicate messages.
- Integration tests for queue/repository/external-client boundaries when available.
- Fault-injection or mock failure tests for timeouts, partial failure, and retry exhaustion.
- Load or soak tests only when explicitly requested and safe.
- Logs/metrics/traces review for observability of failure paths.

## Output

Report:

- Distributed boundary and lifecycle.
- Failure modes considered.
- Reliability mechanism chosen.
- Tests/checks run.
- Remaining risks and operational follow-up.

Use `references/idempotency-and-retry.md` when retries, duplicate delivery, or replay are in scope.
