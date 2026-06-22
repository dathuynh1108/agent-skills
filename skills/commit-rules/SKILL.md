---
name: commit-rules
description: Use when Codex needs to create, validate, propose, or perform git commits; stage files; split changes; write Conventional Commit messages; prepare commit/PR summaries; or decide commit type and scope. Covers staging hygiene, commit boundaries, message format, and final reporting.
---

# Commit Rules

## Workflow

- Commit only when the user explicitly asks or the workflow clearly requires it.
- Inspect `git status --short` before staging or committing.
- Inspect the relevant unstaged diff before deciding what belongs in the commit.
- Separate your intended changes from unrelated dirty work. Do not revert or stage unrelated user changes.
- Stage with explicit pathspecs, for example `git add -- path/to/file`.
- Review staged content with `git diff --cached --stat` and, when risk warrants, `git diff --cached`.
- Run relevant format/lint/typecheck/test commands before committing when feasible.
- If checks are skipped or fail, state the exact command, reason/result, and remaining risk.
- Commit only after the staged diff matches the intended scope.

## Message Format

- Use Conventional Commits: `<type>(<scope>): <description>`.
- Keep the header English, imperative, lowercase description, no trailing period, under 72 characters.
- Use a body for non-obvious why, approach, trade-offs, rollout risk, or validation notes.
- Mark breaking changes with `!` and a `BREAKING CHANGE:` footer.

## Type Selection

- `feat`: new behavior.
- `fix`: broken behavior.
- `refactor`: behavior-preserving code restructuring.
- `perf`: performance improvement.
- `test`: tests are the primary change.
- `docs`: docs are the primary change.
- `style`: formatting-only or non-behavioral style change.
- `chore`: maintenance/tooling that is not app behavior.
- `ci`: CI or workflow automation.

## Scope And Splitting

- Use the smallest meaningful scope from the touched module, package, feature, or app.
- Do not mix unrelated behavior, docs, tests, or cleanup in one commit.
- Prefer multiple commits when changes are independently reviewable or revertable.
- Keep generated files with their source change only when the repo expects generated artifacts to be committed.

## Final Reporting

After a commit, report:

- Commit hash and subject.
- Files or modules committed.
- Checks run with pass/fail result.
- Skipped checks and remaining risk.
- Unrelated dirty files left untouched.
