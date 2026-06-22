---
name: observability-and-debugging
description: Use when investigating bugs, production issues, flaky tests, regressions, logs, metrics, traces, dashboards, alerts, runbooks, or when adding instrumentation to make backend, performance, or ML behavior diagnosable.
---

# Observability And Debugging

## Workflow

1. State the observed symptom, affected scope, expected behavior, and last known good state if available.
2. Gather evidence before editing: source, tests, logs, traces, metrics, configs, recent diffs, incidents, and docs.
3. Form one or more falsifiable hypotheses. Prefer the smallest check that can disprove each hypothesis.
4. Trace the execution path through boundaries: API, service, data access, worker, queue, external client, config, and deployment.
5. Fix the root cause, not just the symptom, when evidence supports it.
6. Add regression tests or instrumentation that would catch the issue earlier next time.

## Debugging Checks

- Reproduce or identify why reproduction is unavailable.
- Check inputs, permissions, config, environment, time, concurrency, and data state.
- Check recent changes and deployment order without assuming correlation is causation.
- Check boundary mappings: DTOs, ORM models, event payloads, external SDK responses, and error conversion.
- Check retries, timeouts, cancellation, race conditions, stale caches, and partial failures.
- For ML issues, check data freshness, model version, feature skew, evaluation slice, and serving path.

## Instrumentation Rules

- Logs should explain what happened, where, and with which safe correlation identifiers.
- Do not log secrets, tokens, private user content, raw PII, or sensitive customer data.
- Metrics should be low-cardinality and tied to action: latency, errors, counts, queue depth, freshness, and saturation.
- Traces should capture meaningful boundaries and downstream calls without excessive payloads.
- Alerts should map to user impact or actionable operational conditions.
- Runbooks should include symptoms, checks, likely causes, safe mitigations, and escalation.

## Anti-Patterns

- Do not patch around unknown root cause when the evidence is still missing.
- Do not add noisy logs that make the hot path slower or leak data.
- Do not treat flaky tests as harmless without identifying the race, timing, data, or isolation problem.
- Do not claim production state unless verified from current evidence.

## Output

Report:

- Symptom and confirmed evidence.
- Hypotheses checked.
- Root cause or most likely cause with uncertainty.
- Fix or proposed fix.
- Regression test/instrumentation added or recommended.
- Commands/checks run and remaining risk.

Use `references/debugging-playbook.md` for incident/debug loops and `references/instrumentation-checklist.md` when adding signals.
