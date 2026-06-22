---
name: python-clean-code
description: Use when working in Python services to make scoped code changes, clean imports/formatting, review FastAPI/Pydantic/SQLAlchemy/worker/client boundaries, preserve API contracts, and choose focused uv/pytest validation.
---

# Python Clean Code

## Workflow

1. Read local guidance first: `AGENTS.md`, `README.md`, `pyproject.toml`, `requirements*.txt`, `Makefile`, CI files, and nearby tests.
2. If `.gitnexus/run.cjs` exists, run `node .gitnexus/run.cjs status`. When the index is stale and graph impact matters, run `node .gitnexus/run.cjs analyze` before relying on impact/flow answers.
3. Classify the owner before changing behavior: route/API, application service, domain model, repository/data access, external client, worker/job, config, or deployment.
4. Keep changes narrow. Preserve public contracts, explicit `None` semantics, raw upstream values, async job boundaries, and error behavior unless the task explicitly changes them.
5. Prefer repo commands through `uv run` when the repo uses `uv`. Do not run DB init, migrations, destructive SQL, external writes, deploys, or rollbacks without explicit user request.
6. Validate with the smallest command that proves the behavior, then broaden when shared contracts or cross-module flows changed.

## Coding Rules

- Keep FastAPI routes thin; put business rules in services/repositories already owning that behavior.
- Keep SQLAlchemy access in repository modules; avoid route-level ad hoc queries unless that route already owns the pattern.
- Keep Pydantic models at API/client boundaries and avoid leaking raw ORM objects.
- Use `httpx` or other external clients with explicit timeouts and useful non-sensitive error context.
- Preserve async semantics; do not block event loops with sync I/O in request paths.
- Prefer clear names, early returns, typed structures, and direct control flow over clever abstractions.
- Avoid broad dependency churn; do not add a production dependency only to simplify a small local change.
- Remove only imports, variables, helpers, and files made unused by the current change.

## Validation Menu

- Format/imports: `make format-all` when present, otherwise use the repo's configured `black`, `isort`, or `ruff` commands.
- Full tests: `uv run pytest` or the repo's documented pytest command.
- Focused tests: `uv run pytest path/to/test_file.py -q`
- Compile changed packages when useful: `uv run python -m compileall <package-or-dir>`
- Diff hygiene: `git diff --check`

When a check cannot run, report the exact command, why it was skipped or failed, and the remaining risk.
