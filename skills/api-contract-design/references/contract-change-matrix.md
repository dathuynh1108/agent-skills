# Contract Change Matrix

| Change | Usually safe? | Notes |
| --- | --- | --- |
| Add optional response field | Yes | Preserve existing fields and types. |
| Add required request field | No | Requires versioning or migration. |
| Rename field | No | Add new field first; deprecate old field later. |
| Remove enum value | No | Check persisted data and clients. |
| Add enum value | Maybe | Consumers with exhaustive matching may break. |
| Change error code/status | Maybe | Check retry and UX behavior. |
| Change pagination order | Maybe | Can break cursor stability and tests. |
| Add webhook/event field | Usually | Keep schema compatibility. |
| Remove webhook/event field | No | Requires versioned event schema or migration. |
