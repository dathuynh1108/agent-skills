---
name: code-review-and-quality
description: Code review of a PR, branch, commit range, or local diff for actionable bugs, regressions, contract violations, and production risk.
---

# Code Review And Quality

Report demonstrable failures and meaningful risks. Review-only mode does not
include edits. Keep judgment grounded in the requested behavior and current source.

## Review Loop

1. Establish the target: PR, branch/range, staged or unstaged diff, or named files.
   Use Git status and task context to resolve ambiguity before asking.
2. Read relevant local guidance and the exact diff. Identify the changed contract,
   its owner, affected callers, and nearby tests. Expand to docs, config, generated
   files, or runtime evidence when a specific uncertainty requires them.
3. Inspect implementation and tests together. Trace changed behavior across the
   affected boundaries; check that regressions would fail the relevant tests.
4. Apply the relevant review axes below. Follow the current primary workflow;
   reuse its scope and evidence rather than starting a second audit.
5. Run authorized, focused checks when they improve confidence. Record their exact
   result; code inspection is not a passing test or proof of deployed behavior.
6. Verify each candidate finding against current source, merge duplicates, and
   report confirmed findings in severity order. State unresolved assumptions and
   verification limits without inventing problems to fill the report.

## Review Axes

Use the axes implicated by the change; they are not separate mandatory workflows.

| Axis | Questions that can reveal a concrete defect |
| --- | --- |
| Correctness | Does behavior match the request, including null/empty/boundary, timezone/locale, permission, error, and asynchronous state cases? Are generated artifacts and schemas consistent? |
| Tests | Do assertions cover changed behavior and realistic failure paths? Would they catch the old bug? Could mocks or snapshots hide a contract failure? |
| Ownership | Do business rules stay in their owning layer? Are dependency direction, naming, error/logging patterns, and generated-source ownership preserved? Is new abstraction or compatibility behavior justified? |
| Security/privacy | Are authentication, authorization, tenant boundaries, and sensitive data protected? Inspect relevant SQL, shell, path, template, HTML/Markdown, URL, and deserialization sinks for untrusted input. |
| Reliability | Are transactions, retries, cancellation, idempotency, timeouts, concurrency, partial failures, and backpressure correct? Check config, rollout order, cache freshness, and repeatable side effects. |
| Performance | Could the changed path add N+1 requests, unbounded scans/memory/retries, blocking I/O, hot allocations, avoidable renders, or unjustified dependencies? |
| UX/contracts | Are API/DTO/event/SDK/schema semantics preserved or intentionally changed? Check relevant loading, empty, denied, error, partial-data, and responsive UI states. |

## Independent Review

Delegate when independent ownership boundaries, material risk, or an explicit
request justify another pass and useful work can run in parallel. Diff size or
AI authorship alone does not require multiple reviewers. Use
`subagent-coordination` for current model/effort/schema selection.

Give each reviewer a bounded read-only scope, raw task/diff/source evidence, and
one focused concern. Keep suspected findings and other reviewers' conclusions out
of the brief. Require trigger, impact, file/line evidence, and a fix direction.
Do not grant edits, external writes, or recursive delegation for a review.

Check returned findings yourself; resolve disagreement against source rather than
by vote. Collect every result/error and report material gaps. For a broad diff,
partition by contract, data, trust boundary, worker, UI, and artifact ownership;
state any unreviewed scope honestly.

## Findings And Severity

Every actionable finding needs a trigger condition, user/system impact, current
file/line evidence, and a concrete fix direction. Missing tests count only when
an identified behavior or failure mode needs coverage. Drop unsupported, stale,
duplicate, and personal-style findings; keep fixes proportional to the defect.

- `P0`: immediate blocker with demonstrated severe impact, such as an auth bypass,
  data corruption, outage, or irreversible destructive behavior.
- `P1`: fix before merge; likely regression, broken contract, or unsafe operation.
- `P2`: fix-worthy reliability, maintainability, coverage, or performance issue
  with a concrete trigger and plausible impact.
- `P3`: optional readability or follow-up suggestion; do not present it as blocking.

Lead with findings (`[P1] Title — file:line`) and explain trigger, impact, and remedy.
Then include material open questions, exact checks/results, and a short conclusion.
Omit empty headings. With no confirmed issues, say so for the reviewed scope and
state residual verification gaps. A clean review is not proof that no bugs exist.

## Source Note

Adapted from Addy Osmani's MIT-licensed `code-review-and-quality` skill:
https://github.com/addyosmani/agent-skills/tree/main/skills/code-review-and-quality
