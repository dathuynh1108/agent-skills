# Backend Change Checklist

## Before Editing
- Which layer owns the behavior?
- Which API/event/schema/DB contracts can be affected?
- Which tests currently describe the behavior?
- Are there generated files or docs that must be updated?

## During Implementation
- Keep boundary mapping explicit.
- Avoid hidden side effects.
- Keep transaction boundaries small.
- Add timeouts and cancellation around network work.
- Preserve idempotency for jobs and retries.

## Before Handoff
- Review diff for unrelated changes.
- Run focused tests.
- Run lint/typecheck/build when available and relevant.
- Report skipped checks and residual risk.
