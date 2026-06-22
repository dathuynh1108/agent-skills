# Capacity Planning Prompts

Ask for or estimate ranges when exact numbers are unavailable:

- Requests per second, peak multiplier, and burst duration.
- Payload size and response size.
- Reads/writes per request.
- Data growth per day/month.
- Hot partitions, tenant distribution, and fan-out.
- Batch size, queue depth, and worker concurrency.
- p50/p95/p99 latency targets.
- Cost limits or infrastructure constraints.

Never present rough estimates as confirmed production facts. Mark them as assumptions and recommend validation sources.
