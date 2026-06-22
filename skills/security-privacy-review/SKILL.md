---
name: security-privacy-review
description: Use for defensive security and privacy review of backend, API, data, ML, logging, secrets, auth/authz, tenant isolation, input validation, dependency, and deployment changes. Focus on finding and fixing risks, not offensive exploitation.
---

# Security Privacy Review

## Workflow

1. Identify trust boundaries: user input, external services, files, URLs, webhooks, queues, databases, logs, model inputs, and admin paths.
2. Inspect current auth/authz, validation, sanitization, error handling, logging, secret handling, dependency use, and data access patterns.
3. Prioritize real risk with source evidence over speculative checklist noise.
4. Preserve existing security controls unless the task explicitly changes them.
5. Add tests or checks for denied paths, invalid input, tenant boundaries, and sensitive-data handling when relevant.
6. Report findings with severity, trigger condition, impact, and smallest safe fix.

## Review Checks

- Auth/authz: access control, role checks, tenant isolation, object ownership, admin bypass, and confused-deputy paths.
- Input validation: SQL/shell/path/template/HTML/markdown/URL/serialization sinks, file uploads, unsafe redirects, and deserialization.
- Secrets: tokens, credentials, private keys, env vars, config files, CI logs, and error messages.
- Privacy: PII collection, minimization, retention, logging, analytics, model prompts, training data, and user deletion paths.
- Data access: row-level filters, multi-tenant queries, bulk exports, pagination leaks, and cache key isolation.
- External calls: SSRF-like URL handling, allowlists, timeouts, retries, TLS assumptions, and webhook verification.
- Dependencies: new packages, risky transitive behavior, supply-chain scripts, and lockfile changes.
- ML systems: sensitive features, training data leakage, prompt/log retention, model output privacy, and evaluation slices.

## Severity

- `P0`: likely exploit, auth bypass, secret exposure, data loss, cross-tenant leak, or production-wide outage risk.
- `P1`: must fix before merge; plausible vulnerability or privacy breach with realistic trigger.
- `P2`: should fix; hardening gap, missing denied-path test, unsafe default, or plausible leakage path.
- `P3`: optional improvement with low immediate risk.

## Anti-Patterns

- Do not provide exploit instructions or harmful payloads beyond what is needed to explain a defensive fix.
- Do not bury security findings after style comments.
- Do not claim a path is safe without verifying current code and config.
- Do not log or expose sensitive sample values in the final report.

## Output

Report:

- Findings first, severity ordered.
- File/line evidence when available.
- Trigger condition and impact.
- Smallest safe fix direction.
- Tests/checks run or recommended.
- Residual risk.

Use `references/trust-boundary-checklist.md` when enumerating inputs, sinks, and sensitive boundaries.
