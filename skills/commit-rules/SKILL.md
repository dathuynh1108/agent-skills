---
name: commit-rules
description: Git staging, commit preparation, Conventional Commit messages, and requested commit or PR publication.
---

# Commit Rules

## Scope And Evidence

Commit when requested or required by the authorized workflow. Existing approval
for the same scope remains valid; a commit request alone does not authorize push,
merge, deployment, or a force push.

Inspect `git status --short` and the relevant unstaged diff. Stage explicit task
paths (`git add -- path/to/file`), preserving unrelated user changes. Separate
independently reviewable changes; keep generated artifacts with their owning source.
Review the cached diff and stat before committing. Run appropriate authorized checks
and record failures or skipped checks with their reason and residual risk.

## Message

Use Conventional Commits:

```text
<type>[optional scope][optional !]: <description>

[optional body]

[optional footer(s)]
```

The header is English, imperative, naturally lower-case, under 72 characters, and
has no trailing period. Use a meaningful scope noun or omit the scope. Separate
body and footers with blank lines; explain non-obvious rationale, validation, or
rollout risk when useful. Mark breaking changes with `!` and/or `BREAKING CHANGE:`.
Use Git trailers for references or attribution, preserving their actual authors.

Types: `feat` behavior, `fix` defect, `docs` documentation, `style` formatting,
`refactor` behavior-preserving restructuring, `perf` performance, `test` tests,
`build` dependencies/packaging, `ci` automation, `chore` maintenance, `revert` undo.
Include the reverted subject/SHA when relevant. For multiline messages or PR bodies,
use a file or structured argument that preserves literal text and newlines.

## Publication And Handoff

Verify the created commit hash, subject, and scope. When push or merge is authorized,
use the intended remote/branch and repo workflow, then verify the remote result;
a local commit is not publication. Preserve unrelated files and avoid force pushes
unless separately authorized and permitted.

In an indexed repo, use `gitnexus-cli` to refresh after committing and report any
freshness failure. Unindexed repos do not need a new index for commit reporting.

Report commit/PR identifiers, relevant checks/results, publication state, and
material remaining risks. Include unrelated dirty work only when it affects the
handoff; omit empty status sections.
