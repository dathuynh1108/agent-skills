# Training Loop Checklist

- Data loader shuffles only when appropriate.
- Validation/test splits are never used for gradient updates.
- Loss scaling and mixed precision handle overflow.
- Optimizer steps align with gradient accumulation.
- Scheduler steps at the intended frequency.
- Metrics reset between epochs.
- Checkpoints include enough state to resume.
- Distributed samplers set epoch when needed.
- Logging does not leak sensitive samples.
