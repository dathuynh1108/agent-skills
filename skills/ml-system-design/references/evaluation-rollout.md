# Evaluation And Rollout Notes

## Offline Metrics
- Choose metrics that match the decision: precision/recall, ROC-AUC, PR-AUC, NDCG, MAP, calibration, MAE/RMSE, or task-specific quality.
- Include failure slices by segment, time, geography, traffic source, item category, or user group when relevant.
- Keep a clean holdout that mirrors production decision timing.

## Online Rollout
- Shadow first when incorrect predictions could harm users or revenue.
- Canary with guardrails before wide rollout.
- A/B only when exposure, sample size, and measurement window are meaningful.
- Keep fallback and rollback simple enough for operators to execute.
