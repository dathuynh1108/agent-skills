---
name: python-clean-code
description: Python service implementation or review involving FastAPI, Pydantic, SQLAlchemy, workers, clients, or cohesive object ownership.
---

# Python Clean Code

## Workflow

1. Read the relevant `AGENTS.md`; discover commands from the first authoritative README, build/package, or CI source. Inspect the owner and nearby tests, expanding only for an unresolved question.
2. When a current GitNexus index exists, reuse the active graph workflow for owner/impact lookup. Verify exact literals and dirty source with `rg` and Git; unindexed repos use source tools directly.
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

## Object Ownership

- Model closed domain vocabularies as explicitly typed `Enum`/`StrEnum` classes.
  Pass the enum type through internal APIs and serialize its value only at a
  boundary; do not scatter related statuses, kinds, or modes across string
  constants.
- Put behavior on its natural owner. Use instance methods when behavior depends
  on object state or injected collaborators, and `@classmethod` for named
  constructors, type-owned factories, or cohesive policies. Prefer an existing
  service, executor, repository, policy, factory, resolver, mapper, or value
  object over growing a module of loosely related top-level helpers.
- Keep free functions for thin framework entrypoints and small pure transforms
  that genuinely have no state, invariant, lifecycle, or domain owner. A helper
  used mainly by one object should normally be a private method on that object.
- Do not create generic `utils.py`, `helpers.py`, or `constants.py` dumping
  grounds. Keep deployment settings in configuration objects, domain vocabulary
  in enums/value objects, and stable shared invariants narrowly scoped beside
  their owner. Do not promote a one-use literal to a module constant.
- Do not manufacture classes merely to hold unrelated `@staticmethod`s. An
  object boundary must represent cohesive behavior, state, invariants,
  dependency lifetime, or a meaningful test seam; otherwise a small function is
  clearer.

## Validation Menu

- Format/imports: apply the configured formatter to changed files. Use a repo-wide target only when its scope is appropriate; inspect incidental changes.
- Full tests: `uv run pytest` or the repo's documented pytest command.
- Focused tests: `uv run pytest path/to/test_file.py -q`
- Compile changed packages when useful: `uv run python -m compileall <package-or-dir>`
- Diff hygiene: `git diff --check`

When a check cannot run, report the exact command, why it was skipped or failed, and the remaining risk.
