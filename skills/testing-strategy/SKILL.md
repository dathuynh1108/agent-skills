---
name: testing-strategy
description: Use when planning, adding, reviewing, or selecting tests for backend, clean-code refactors, API contracts, database changes, distributed systems, performance-sensitive paths, data pipelines, ML models, or deep-learning training/inference.
---

# Testing Strategy

## Workflow

1. Identify the behavior under test and the failure that would matter to users or operators.
2. Inspect existing tests, fixtures, factories, mocks, snapshots, and CI commands before adding new patterns.
3. Choose the cheapest test level that proves the behavior. Add broader tests only for boundaries or integration risk.
4. Write tests that fail for the old bug or unsupported behavior when possible.
5. Prefer observable behavior over implementation details.
6. Keep tests deterministic, isolated, and readable.
7. Report exact commands run and skipped checks with residual risk.

## Test Selection

- Unit tests: pure business rules, validators, mapping, policy, state transitions, retry decisions, and edge cases.
- Integration tests: repository/DB, API handlers, queue consumers, external-client adapters, migrations, and generated contracts.
- Contract tests: public APIs, events, webhooks, SDKs, protobuf/OpenAPI/GraphQL shapes, and compatibility fixtures.
- E2E tests: critical user journeys where lower-level tests cannot prove the system behavior.
- Performance tests: hot-path regression, query count, latency/throughput, memory, and inference cost.
- ML tests: data validation, feature correctness, leakage guards, evaluation metrics, model version compatibility, and serving shape.
- Refactor tests: characterization tests before changing unclear behavior.

## Quality Bar

- Tests should have clear arrange/act/assert sections or equivalent readability.
- Use realistic boundary values: null/empty, max/min, timezone, locale, permission denied, duplicate request, retry, and partial failure.
- Avoid over-mocking the code under test. Mock external systems, not the behavior being verified.
- Snapshots must be small, intentional, and easy to review.
- Flaky tests must be fixed or quarantined with explicit reason; do not normalize flakiness.
- Test data should avoid secrets, real private data, and production identifiers.

## Validation Menu

- Focused test file or test name.
- Nearby regression tests for touched behavior.
- Contract/generated checks for API/schema changes.
- Full test suite only when blast radius is high and feasible.
- Lint/typecheck/build when tests depend on generated or typed artifacts.

## Output

Report:

- Test intent and behavior covered.
- Commands run with pass/fail result.
- Coverage gaps and why they remain.
- Recommended next test when useful.

Use `references/test-strategy-matrix.md` when selecting the minimum useful tests for a change type.
