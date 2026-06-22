# Backend Performance Checklist

## Request Path
- Is expensive work repeated per request?
- Are external calls serial when safe batching or parallelism exists?
- Is request cancellation propagated?
- Are payloads bounded and compressed only when useful?
- Are logs/metrics too expensive on hot paths?

## List Endpoints
- Is pagination required and bounded?
- Is ordering stable?
- Are filters indexed?
- Is count query expensive?
- Is fan-out bounded?

## Workers
- Is concurrency bounded?
- Is backpressure explicit?
- Are retries causing duplicate work?
- Is batch size configurable and safe?
