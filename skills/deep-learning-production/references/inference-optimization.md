# Inference Optimization Checklist

- Establish baseline latency, throughput, memory, and quality.
- Bound input length and batch size.
- Load model/tokenizer once.
- Use explicit device and dtype.
- Compare dynamic vs static batching when serving traffic is bursty.
- Validate output equivalence or acceptable quality delta.
- Track cold-start separately from warm-path latency.
- Document hardware, runtime, batch size, and input shape.
