# Migration Rollout Patterns

## Expand And Contract
1. Add nullable column/table/index or additive schema.
2. Deploy code that writes both old and new shapes if required.
3. Backfill in bounded, resumable batches.
4. Deploy readers that use the new shape.
5. Stop writing old shape.
6. Remove old schema after compatibility window.

## Backfill Safety
- Use stable ordering and checkpoints.
- Limit batch size and transaction time.
- Make reruns idempotent.
- Emit progress metrics/logs.
- Avoid production-impacting locks.
- Provide pause/resume instructions.

## Rollback Note
Some data migrations cannot be truly rolled back. Prefer mitigation plans: disable feature, revert reader path, stop writers, or restore from backup when appropriate.
