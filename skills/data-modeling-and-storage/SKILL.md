---
name: data-modeling-and-storage
description: Use when designing or changing database schemas, migrations, indexes, ORM models, query patterns, transactions, consistency, data retention, partitioning, backfills, or storage choices for backend or ML systems.
---

# Data Modeling And Storage

## Workflow

1. Identify the data contract: owner, readers, writers, lifecycle, retention, privacy, and migration path.
2. Inspect current migrations, ORM models, schemas, constraints, indexes, query call sites, fixtures, and tests.
3. Preserve compatibility unless the task explicitly requires a breaking schema or storage change.
4. Design migrations for safe rollout: expand, backfill, dual-read/write if needed, cutover, then contract.
5. Validate query behavior, constraints, and performance-sensitive paths.
6. Document rollback or mitigation when true rollback is unsafe.

## Data Modeling Checks

- Primary keys, foreign keys, uniqueness, nullability, defaults, and check constraints match invariants.
- Indexes match query filters, joins, sort order, cardinality, and pagination paths.
- Transactions protect multi-row or cross-table invariants.
- Migrations are safe for production size: locks, rewrite risk, timeouts, batching, and online DDL support.
- Backfills are idempotent, resumable, observable, bounded, and safe to retry.
- Reads avoid N+1 queries, unbounded scans, unbounded result sets, and accidental cross-tenant leakage.
- Writes handle duplicate requests, retries, partial failure, and conflict behavior intentionally.
- Retention, deletion, anonymization, and access rules match privacy requirements.
- For ML/data pipelines, feature tables and labels preserve time correctness and avoid leakage.

## Storage Choice Checks

- Use relational storage when transactions, constraints, joins, and strong consistency are primary.
- Use document/key-value storage only when access patterns and consistency needs fit.
- Use search/vector stores as indexes, not as the only source of truth unless explicitly designed that way.
- Use caches for performance, not correctness, unless stale-read semantics are part of the contract.
- Use object storage for large immutable or append-heavy artifacts with metadata indexed elsewhere.

## Validation Menu

- Migration dry-run or local test DB migration when safe.
- Focused repository/query tests.
- Query plans for hot or changed queries when tools are available.
- Data backfill unit/integration test for idempotency and resume behavior.
- Lint/typecheck/build and generated model/schema checks from repo docs.

## Output

Report:

- Schema/storage change summary.
- Compatibility and rollout order.
- Index/query impact.
- Backfill or data migration plan.
- Tests/checks run or skipped.
- Remaining production risks.

Use `references/migration-rollout-patterns.md` for schema/data migrations and `references/index-review.md` for query/index changes.
