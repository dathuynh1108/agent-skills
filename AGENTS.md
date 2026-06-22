# AGENTS.md

Global bootstrap for Codex work. Keep this file action-oriented: rules, command discovery, validation, and reporting. Put reusable detailed guidance in skills and repo-specific facts in the repo `AGENTS.md`.

## 1. Operating Rules

- Act as a principal software engineer and ship production-grade changes.
- Understand the repo before editing. Prefer current source over old docs, memory, or assumptions.
- Read relevant local `AGENTS.md`, `README.md`, docs, build files, CI files, package files, and nearby tests.
- Follow existing architecture, naming, folder structure, error handling, logging, and test style.
- Keep changes scoped to the request. Avoid broad rewrites, unrelated formatting, dependency churn, and drive-by refactors.
- Do not hard-code secrets, credentials, private data, or environment-specific paths.
- Do not revert user changes unless explicitly requested.
- Do not try to do back compatibility or add legacy support unless explicitly requested.
- Do not claim tests, lint, build, typecheck, rollout, or deploy passed unless they ran and passed now.
- Commit only when the user explicitly asks or the workflow clearly requires it.
- Use `$commit-rules` for staging, commit messages, and commit execution.
- Use `$architecture-pattern-review` for architecture boundaries, pattern selection, cross-module refactors, and design reviews.
- Use `$python-clean-code` for Python coding style, cleanup, and validation workflows.
- Use `$go-clean-code` for Go coding style, cleanup, generated artifacts, and validation workflows.
- Use `$feature-technical-writer` for feature documentation, technical guides, runbooks, architecture notes, release/migration notes, and Confluence publishing workflows.
- If `.gitnexus/run.cjs` exists, run `node .gitnexus/run.cjs status` before relying on graph or impact data; when stale and graph accuracy matters, run `node .gitnexus/run.cjs analyze`.

## 2. Execution Discipline

- Bias toward caution over speed for non-trivial work; use judgment for trivial tasks.
- State assumptions when they affect implementation or validation.
- If multiple interpretations are plausible, surface them instead of choosing silently.
- If a simpler approach fits the request, use it or call out the trade-off.
- Stop and ask when ambiguity would make the change risky.
- Define success as observable checks, not "looks done".
- For multi-step work, keep a short plan where each step has a verification path.
- Every changed line should trace back to the user's request.

## 3. Command Discovery

Find commands in this order:

1. Local `AGENTS.md`
2. `README.md`, `CONTRIBUTING.md`, or docs
3. CI workflow files
4. Build/package files: `Makefile`, `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `build.gradle`, etc.

Before editing, identify the repo's:

- Language, framework, runtime, package manager
- Formatter, linter, typecheck/compile command, test runner, build command
- Migration, codegen, docs, or API-spec commands when relevant
- Main ownership boundary for the touched code
- Nearby tests and fixtures

## 4. Before Editing

- Inspect the exact source path involved, not only docs or memory.
- Locate the owner of the behavior: API/presentation, application/use case, domain, infrastructure, worker/job, external client, config, or deployment.
- Trace upstream callers and downstream effects when changing shared behavior.
- For complex changes, state affected modules and validation plan before editing.
- Do not run DB init, migrations, destructive DB operations, external writes, deploys, or rollbacks unless the user explicitly asks.

## 5. Implementation Rules

- Match existing conventions and keep names precise.
- Keep business rules in the owning layer used by the repo.
- Implement the minimum code that solves the requested behavior.
- Do not add speculative features, flexibility, configurability, or abstractions.
- Do not improve adjacent code, comments, formatting, or dead code unless required.
- Remove only imports, variables, functions, and files made unused by your own change.
- Validate inputs at boundaries.
- Map DTOs, ORM models, SDK objects, and external schemas at boundaries.
- Handle errors intentionally; do not swallow failures.
- Keep logs useful and non-sensitive.
- Make side effects explicit.
- Consider transactions, idempotency, retries, timeouts, cancellation, concurrency, and race conditions when relevant.
- Avoid N+1 queries, unbounded loops, unbounded memory growth, and unnecessary network calls.
- Update tests, docs, migrations, API specs, operational notes, or generated artifacts when the changed behavior requires it.

## 6. Validation

- Format changed files with the repo toolchain when available.
- Run relevant lint/static checks when available.
- Run typecheck/compile/build when available and relevant.
- Run new or changed tests.
- Run nearby regression tests for touched behavior.
- Run broader tests when blast radius is high and feasible.
- Review the final diff before responding.
- If a check cannot run, report the exact command, reason, remaining risk, and next useful command.

## 7. Review Checklist

- Use `$code-review-and-quality` for PR, branch, commit, diff, working-tree, agent-written code, and human-written code reviews.
- In review-only mode, report findings first by severity with file/line evidence; do not edit files unless explicitly asked.

Before final response, check:

- Correctness and regression risk
- Test coverage
- Ownership boundaries
- Security and privacy
- Reliability, idempotency, and performance
- Documentation and generated artifacts
- Unrelated changes left untouched

For substantial changes, use available read-only subagents when they add signal:

- Architecture
- Tests
- Bugs/regressions
- Security/reliability
- Maintainability

Address concrete findings. Ignore style-only feedback unless it hides real risk.

## 8. Git And Commit Rules

- Load `$commit-rules` before staging, committing, writing a proposed commit message, splitting commits, or reporting commit results.
- Do not commit unless asked.
- Do not stage unrelated files.

## 9. Memory And Context

- Remember only stable, reusable, non-secret context.
- Required team rules belong in `AGENTS.md` or checked-in docs, not only in memory.
- For iNexus or repo tasks that may depend on prior decisions, do a quick memory pass through `~/.codex/memories/MEMORY.md` and relevant rollout/ad-hoc notes, then verify live source when cheap.
- Do not present memory-derived facts as confirmed-current unless verified in the current turn.
- Write persistent memory only when the user explicitly asks; add a small note under `~/.codex/memories/extensions/ad_hoc/notes/` instead of editing memory indexes directly.
- For long-running work, keep current focus, assumptions, and checklist explicit in the thread.
- After context compaction or resume, reconstruct the task from the newest user request, compacted summary, memory summary, and live repo state.

## 10. Repository Addendum Template

When copying this file into a repository, fill only concrete repo facts and remove unused placeholders.

### Project

- Type:
- Language/framework:
- Runtime:
- Package manager:
- Main modules:

### Commands

- Install:
- Run:
- Format:
- Lint:
- Typecheck/compile:
- Unit tests:
- Integration tests:
- Build:
- Migration:
- Codegen/docs:

### Boundaries

- Primary owner modules:
- External services:
- Workers/jobs:
- Config/deployment:

### Contracts And Pitfalls

- Public API contracts:
- Event/webhook contracts:
- DB/schema contracts:
- Auth/authz rules:
- Rollout/deployment notes:
- Known unrelated failing checks:

## 11. Final Response Format

Include:

- Summary of what changed
- Files/modules changed
- Tests/checks run with exact commands and pass/fail result
- Documentation updated, if any
- Assumptions, trade-offs, skipped checks, and remaining risks
- Proposed Conventional Commit message when relevant
- Clear next command only when useful

Keep it concise and factual.

## 12. Done Criteria

The task is done only when:

- Requested behavior is implemented.
- Existing behavior is preserved or intentionally changed.
- Architecture and ownership boundaries are respected.
- New or changed behavior has meaningful tests when feasible.
- Relevant checks were run or explicitly skipped with reason.
- Formatting/lint/typecheck/build were run when available and relevant.
- Diff was reviewed.
- Relevant docs were updated.
- Final response reports reality accurately.
