---
name: deep-learning-production
description: Use when implementing or reviewing deep learning training, fine-tuning, evaluation, inference, GPU performance, batching, quantization, checkpointing, distributed training, model packaging, or deployment behavior.
---

# Deep Learning Production

## Workflow

1. Identify whether the task affects data preprocessing, training, evaluation, inference, packaging, or deployment.
2. Inspect configs, dataset splits, preprocessing, labels, model code, checkpoints, artifacts, tests, and serving code.
3. Preserve reproducibility: config, seeds, versions, checkpoints, tokenizer/preprocessor, and artifact metadata.
4. Validate metrics on the intended split and protect against data leakage.
5. For training, verify resume behavior, optimizer/scheduler/scaler state, distributed setup, and checkpoint compatibility.
6. For inference, optimize measured bottlenecks: batching, input size, device placement, precision, caching, and model loading.
7. Report hardware/runtime assumptions and before/after metrics when performance changes.

## Training Checks

- Dataset split prevents user/item/time/group leakage.
- Preprocessing is identical or intentionally different between train/eval/serve.
- Config captures model, data, optimizer, scheduler, precision, seed, and runtime assumptions.
- Checkpoints include model state and needed optimizer/scheduler/scaler state for resume.
- Mixed precision is safe and tested for numerical stability when enabled.
- Gradient accumulation preserves intended effective batch size.
- Distributed training handles rank, device, seed, sampler, checkpointing, and logging correctly.
- Metrics are computed consistently and not on training data by mistake.

## Inference Checks

- Model/tokenizer/preprocessor load once per process unless isolation requires otherwise.
- Input shape, dtype, device, length, and batch size are validated and bounded.
- Device placement is explicit.
- Concurrency is bounded to avoid GPU/CPU memory exhaustion.
- Precision, quantization, distillation, or compilation changes preserve acceptable output quality.
- Cold start, p95/p99 latency, throughput, and memory are measured when relevant.
- Model artifact versions are compatible with serving code and clients.

## Anti-Patterns

- Do not tune hyperparameters without a controlled evaluation setup.
- Do not change preprocessing without checking train/serve parity.
- Do not report benchmark wins without hardware, batch size, input shape, and measurement method.
- Do not silently drop checkpoint resume compatibility.
- Do not optimize inference in a way that changes output quality without evaluation.

## Validation Menu

- Unit tests for preprocessing, collators, model wrappers, and output shapes.
- Smoke training run on a tiny dataset.
- Checkpoint save/load/resume test.
- Evaluation command on a documented split.
- Inference smoke test with representative inputs.
- Before/after latency, throughput, memory, and quality metrics when optimizing.

## Output

Report:

- Training/inference behavior changed.
- Dataset/config/artifact assumptions.
- Metrics and hardware/runtime context.
- Validation commands and results.
- Artifact compatibility and remaining risks.

Use `references/training-loop-checklist.md` for training changes and `references/inference-optimization.md` for inference performance changes.
