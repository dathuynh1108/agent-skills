# Model Inference Performance Review

- Load model/tokenizer once per process unless isolation requires otherwise.
- Bound input length and batch size.
- Use explicit device placement.
- Consider mixed precision, quantization, distillation, or smaller models only after correctness and quality checks.
- Measure p50/p95/p99 latency and throughput under expected concurrency.
- Track memory and cold-start cost.
- Preserve output semantics and evaluation quality when changing inference behavior.
- Provide fallback or degradation path for serving failures when product requirements need it.
