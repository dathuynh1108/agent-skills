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
- Draft and validate the Conventional Commit message with the XML structure below before executing `git commit`.
- Commit only after the staged diff matches the intended scope.
- After a successful commit in a GitNexus-indexed repo, use `$gitnexus-cli` to reindex before final reporting. If reindexing is unavailable or fails, report the exact command/result and remaining freshness risk.

## Commit Message Structure

Use this XML as an internal checklist or user-facing proposal when helpful:

```xml
<commit-message>
  <type>feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert</type>
  <scope optional="true">module-or-area</scope>
  <breaking optional="true">true|false</breaking>
  <description>imperative short summary</description>
  <body optional="true">why, approach, trade-offs, validation, rollout risk</body>
  <footer optional="true">BREAKING CHANGE: details | Refs: #123 | Co-authored-by: Name &lt;email&gt;</footer>
</commit-message>
```

Render the final commit message as:

```text
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

Rules:

- Keep the header English, imperative, lower-case where natural, no trailing period, and under 72 characters.
- Omit scope when it is not useful; do not emit empty parentheses.
- Use one scope noun that describes the touched module, package, feature, or workflow.
- Put a blank line between header, body, and footer when body or footer exists.
- Use a body for non-obvious why, approach, trade-offs, rollout risk, or validation notes.
- Mark breaking changes with `!` before the colon, a `BREAKING CHANGE:` footer, or both when extra detail is useful.
- Treat footer tokens like git trailers: `Refs: #123`, `Reviewed-by: Name`, `Co-authored-by: Name <email>`.
- Use repeated `-m` arguments for multi-paragraph commits, or a temporary commit message file when the body/footer would be easier to review.

## Type Selection

- `feat`: new behavior.
- `fix`: broken behavior.
- `docs`: documentation-only changes.
- `style`: formatting-only or non-behavioral style change.
- `refactor`: behavior-preserving code restructuring.
- `perf`: performance improvement.
- `test`: tests are the primary change.
- `build`: build system, packaging, dependency, or generated lockfile changes.
- `ci`: CI or workflow automation.
- `chore`: maintenance/tooling that is not app behavior.
- `revert`: revert a previous commit; include the reverted commit subject or SHA in the body/footer when useful.

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
- GitNexus reindex result for GitNexus-indexed repos.
- Skipped checks and remaining risk.
- Unrelated dirty files left untouched.
