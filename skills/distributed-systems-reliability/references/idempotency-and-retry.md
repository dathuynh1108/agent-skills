# Idempotency And Retry Notes

## Idempotency Options
- Client-provided idempotency key with request hash.
- Natural unique key for the business operation.
- Deduplication table or inbox table for messages.
- Upsert with conflict handling.
- State-machine transition that rejects invalid repeats.

## Retry Rules
Retry only when:
- The failure is transient.
- The operation is safe to repeat or protected by idempotency.
- Attempts are bounded.
- Backoff avoids synchronized retry storms.
- The caller can observe final failure.

Do not retry validation errors, permission errors, deterministic conflicts, or non-idempotent operations without protection.
