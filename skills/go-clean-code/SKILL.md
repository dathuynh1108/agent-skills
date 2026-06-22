---
name: go-clean-code
description: Use when working in Go services to make idiomatic scoped code changes, preserve API/worker contracts, manage generated artifacts, and choose focused gofmt/go test/build/proto/swagger validation.
---

# Go Clean Code

## Workflow

1. Read local guidance first: `AGENTS.md` when present, `README.md`, `go.mod`, `Makefile`, CI files, and nearby tests.
2. If `.gitnexus/run.cjs` exists, run `node .gitnexus/run.cjs status`. When the index is stale and graph impact matters, run `node .gitnexus/run.cjs analyze` before relying on impact/flow answers.
3. Classify the owner before changing behavior: HTTP delivery, usecase/service, entity/model, repository, worker/consumer, external client, config, migration, or generated artifact.
4. Keep changes small and idiomatic. Prefer clear names, early returns, useful zero values, and explicit errors with context.
5. Preserve contexts, timeouts, cancellation, retry bounds, idempotency, and ownership claims in API/worker flows.
6. Run `gofmt` on changed Go files before validation. Do not hand-edit generated files unless the generator is unavailable and the user accepts the trade-off.

## Coding Rules

- Use `context.Context` on request, worker, repository, and external-client boundaries that already accept it.
- Return errors with enough context for operations, but keep messages non-sensitive.
- Keep long-lived clients stateless; build request-specific state per call.
- Avoid unbounded goroutines, channels, retries, loops, and memory buffering.
- Protect shared state with the existing concurrency pattern; do not mix mutex/channel designs without a reason.
- Keep interfaces close to consumers and avoid broad exported abstractions for one implementation.
- Use table-driven tests for business rules and narrow package tests for retries, cancellation, and idempotency.
- Keep generated artifacts in sync with their source files: proto, Wire, Swagger/OpenAPI, mocks, or docs.

## Validation Menu

- Format changed Go files: `gofmt -w <files>`
- Focused tests: `go test ./path/to/package -run 'TestName' -count=1`
- Full tests: `go test ./...`
- Build: `make build`
- Coverage: `make coverage`
- Swagger/docs generation: use the repo's documented target, often `make swagger`.
- Proto generation: use the repo's documented proto targets.
- Diff hygiene: `git diff --check`

When a check cannot run, report the exact command, why it was skipped or failed, and the remaining risk.
