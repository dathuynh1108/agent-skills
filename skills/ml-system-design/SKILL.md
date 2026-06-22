---
name: ml-system-design
description: Use when designing, reviewing, or changing machine learning systems, recommendation/ranking/search models, prediction services, feature pipelines, training pipelines, model serving, evaluation, monitoring, drift handling, or ML rollout strategy.
---

# ML System Design

## Workflow

1. Clarify the ML problem: task type, users, prediction target, decision point, online/offline path, and success metric.
2. Identify data sources, labels, feature freshness, privacy constraints, and leakage risks.
3. Separate system stages: ingestion, validation, feature generation, training, evaluation, registry, deployment, serving, monitoring, and feedback.
4. Define evaluation before implementation: offline metrics, online metrics, guardrail metrics, failure slices, and acceptance thresholds.
5. Design serving and fallback behavior around latency, cost, availability, safety, and product impact.
6. Design rollout: shadow, canary, A/B, holdout, rollback, and model/version compatibility.
7. Treat data, features, model artifacts, and predictions as production contracts.

## ML System Checks

- Problem framing: classification, regression, ranking, recommendation, retrieval, generation, anomaly detection, or forecasting.
- Labels: definition, source of truth, delay, noise, sampling bias, leakage, and feedback loops.
- Features: freshness, schema, offline/online parity, ownership, transformations, and missing values.
- Training: dataset version, split strategy, reproducibility, configs, experiment tracking, and checkpointing.
- Evaluation: metric choice, business alignment, guardrails, calibration, slices, drift, and fairness/privacy concerns.
- Serving: batch/online path, latency budget, throughput, input validation, model loading, concurrency, fallback, and cost.
- Monitoring: data quality, feature freshness, prediction distribution, model quality, drift, errors, latency, and saturation.
- Rollout: shadow mode, canary, A/B, kill switch, rollback, compatibility with old clients, and incident response.

## Anti-Patterns

- Do not optimize model metrics without tying them to product or operational metrics.
- Do not use random train/test splits when time, user, item, or group leakage matters.
- Do not assume training features match serving features without an explicit parity check.
- Do not deploy a model without monitoring data quality and serving failures.
- Do not hide fallback behavior or manual override paths.

## Output

Report:

- ML problem and decision point.
- Data/feature/training/serving architecture.
- Evaluation and rollout plan.
- Monitoring and fallback plan.
- Privacy/safety risks.
- Open assumptions and validation steps.

Use `references/ml-design-template.md` when producing a full design document and `references/evaluation-rollout.md` when defining metrics or release strategy.
