---
name: performance-engineering
description: Use when investigating or improving latency, throughput, CPU, memory, database queries, N+1 issues, caching, pagination, batching, concurrency, cold starts, benchmark regressions, or model inference speed. Requires measurement-first optimization.
---

# Performance Engineering

## Workflow

1. Define the performance target: p50/p95/p99 latency, throughput, CPU, memory, GPU, query count, cold start, cost, or error budget.
2. Identify the hot path from source, traces, logs, profiles, query plans, benchmarks, or tests.
3. Measure before changing when tooling exists. Do not optimize from guesses.
4. Prefer algorithmic, data-access, batching, pagination, caching, or concurrency fixes before micro-optimizations.
5. Preserve behavior and public contracts unless the user explicitly requests a behavior change.
6. Validate with before/after numbers or explain why measurement was unavailable.

## Performance Checks

- Database: N+1 queries, missing indexes, bad join/filter order, unbounded scans, transaction scope, lock contention, and pagination.
- Network: unnecessary calls, serial fan-out, missing batching, missing timeout/cancellation, payload size, and retry amplification.
- CPU: repeated work, expensive serialization, inefficient algorithms, compression overhead, regex hotspots, and avoidable transformations.
- Memory: unbounded collections, loading whole files/results, buffering streams, cache growth, object churn, and retained references.
- Concurrency: goroutine/task leaks, blocked event loops, lock contention, oversubscription, head-of-line blocking, and backpressure.
- Cache: key correctness, invalidation, TTL, stampede protection, stale-read contract, negative caching, and tenant isolation.
- Startup/cold path: dependency initialization, model load, connection setup, reflection/import cost, and lazy vs eager trade-offs.
- Inference: batching, input length, device placement, precision, quantization, model loading, token limits, and concurrency limits.

## Anti-Patterns

- Do not claim an improvement without evidence.
- Do not add caches without invalidation and correctness semantics.
- Do not move work async if users still depend on synchronous completion.
- Do not hide expensive work behind helpers that make call sites look cheap.
- Do not optimize a non-hot path at the cost of readability or correctness.

## Validation Menu

- Existing benchmark, profiling, or load-test command from repo docs/CI.
- Focused regression test proving behavior is unchanged.
- Query count or query plan for data-access changes.
- Before/after latency, throughput, memory, CPU, or query count when measurable.
- For inference, before/after latency, throughput, memory, device utilization, and output equivalence checks.

## Output

Report:

- Target metric and baseline.
- Bottleneck hypothesis and evidence.
- Change made or proposed.
- Before/after validation.
- Behavior/contract risks.
- Next benchmark or profiling command.

Use `references/backend-performance-checklist.md` for backend hot paths, `references/database-performance.md` for queries, and `references/inference-performance.md` for model serving.
