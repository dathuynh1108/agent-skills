---
name: mlops-data-pipeline-quality
description: Use when designing or reviewing ML/data pipelines, feature pipelines, data validation, schema drift, train/serve skew, labels, backfills, lineage, monitoring, model registry flows, or data-quality incidents.
---

# MLOps Data Pipeline Quality

## Workflow

1. Identify the pipeline stage: ingestion, validation, transformation, feature generation, labeling, training dataset build, serving feature path, backfill, registry, or monitoring.
2. Inspect schemas, sample data, pipeline jobs, schedules, dependencies, configs, tests, lineage docs, and downstream consumers.
3. Define the data contract: schema, freshness, completeness, uniqueness, allowed ranges, ownership, retention, and privacy.
4. Check time correctness: event time vs processing time, delayed labels, backfill windows, and leakage risk.
5. Make jobs idempotent, resumable, observable, and bounded.
6. Add validation and monitoring at the earliest useful boundary.

## Data Quality Checks

- Schema: field names, types, nullability, enum/domain values, nested shape, and versioning.
- Completeness: missing values, empty partitions, late-arriving data, and expected volume ranges.
- Correctness: ranges, referential integrity, duplicates, uniqueness, and business invariants.
- Freshness: SLA, lag, watermark, schedule, and dependency readiness.
- Distribution: drift, outliers, class imbalance, feature distribution changes, and segment shifts.
- Leakage: future information, target leakage, user/item leakage, and random split misuse.
- Train/serve skew: transformation parity, online/offline feature generation, default values, and feature availability.
- Privacy: PII minimization, masking, access control, retention, and safe logging.

## Pipeline Operations

- Backfills are chunked, checkpointed, idempotent, and safe to resume.
- Jobs expose progress, failures, retry counts, and data-quality metrics.
- Dependencies are explicit and do not rely on fragile timing.
- Failed validations stop unsafe downstream use or route to quarantine.
- Model training and serving know which data/model/feature versions they use.
- Registry updates are atomic enough to prevent serving the wrong artifact.

## Anti-Patterns

- Do not silently coerce invalid data into defaults that hide quality issues.
- Do not train on data that would be unavailable at serving time.
- Do not backfill without checkpointing and a safe resume plan.
- Do not log raw sensitive samples.
- Do not treat high aggregate metric quality as proof that important slices are safe.

## Output

Report:

- Pipeline stage and data contract.
- Quality checks added or missing.
- Time/leakage/skew risks.
- Backfill and operations plan.
- Validation commands and monitoring gaps.

Use `references/data-quality-checklist.md` for validation coverage and `references/pipeline-operations.md` for job/backfill operations.
