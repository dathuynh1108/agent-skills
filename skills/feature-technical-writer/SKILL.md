---
name: feature-technical-writer
description: Use when Codex needs to document a software feature, API, service behavior, architecture decision, user workflow, release note, migration guide, or troubleshooting guide from source evidence, and when asked to draft, update, or publish technical documentation to Confluence. Applies to repo-grounded feature docs, developer docs, internal runbooks, and stakeholder-facing technical summaries.
---

# Feature Technical Writer

## Workflow

1. Identify the requested doc type, audience, and publish target. If the user asks to publish to Confluence but the space, parent page, or title is missing and cannot be discovered safely, ask for that target before publishing.
2. Gather source evidence before drafting: user prompt, relevant repo files, local `AGENTS.md`, README/docs, tests, API specs, tickets/PRs when available, and existing Confluence pages when updating or avoiding duplicates.
3. If `.gitnexus/run.cjs` exists, run `node .gitnexus/run.cjs status`. When the index is stale and flow/impact accuracy matters for the document, run `node .gitnexus/run.cjs analyze`.
4. Draft from facts only. Mark unknowns as open questions instead of inventing behavior, metrics, owners, dates, or rollout state.
5. Review technical accuracy: contracts, edge cases, permissions, configs, data flows, dependencies, rollout notes, and examples.
6. Publish only when requested or clearly implied. Prefer creating/updating the intended Confluence page through available Atlassian/Confluence tools; otherwise provide the final Markdown and explain that publishing was unavailable.
7. After publishing, read back or verify the page when tooling permits, then report the page title, URL or page ID, and any skipped verification.

## Document Selection

- Feature documentation: explain behavior, workflows, contracts, configs, ownership, rollout, and support notes.
- Developer documentation: explain setup, API usage, extension points, examples, and troubleshooting.
- Architecture documentation: capture context, decision, alternatives, consequences, and operational impact.
- User guide: write task-oriented steps with prerequisites, expected results, and common mistakes.
- Migration or release note: describe what changed, who is affected, compatibility, rollout steps, and rollback or mitigation.
- Runbook or troubleshooting guide: document symptoms, checks, commands, likely causes, fixes, escalation, and safety limits.

## Feature Doc Template

Use this as the default structure unless the user requests another format:

```markdown
# <Feature Name>

## Summary
<What this feature does, who uses it, and why it exists.>

## Current Behavior
<User-visible and system behavior, grounded in source evidence.>

## Scope
- In scope:
- Out of scope:

## User Workflows
1. <Primary workflow with expected result>
2. <Secondary workflow with expected result>

## Technical Design
- Entry points:
- Main modules:
- Data model or payloads:
- External dependencies:
- Permissions and access rules:
- Failure modes:

## Configuration And Operations
- Required config:
- Deployment or rollout notes:
- Observability:
- Runbook links:

## API Or Contract Reference
<Endpoints, events, schemas, request/response examples, or compatibility notes.>

## Testing And Validation
<Tests, commands, fixtures, manual checks, and known gaps.>

## Troubleshooting
| Symptom | Likely cause | Checks | Fix |
| --- | --- | --- | --- |

## References
- <Source files, PRs, tickets, existing docs, dashboards, or official docs.>

## Open Questions
- <Unknowns that require owner confirmation.>
```

## Writing Rules

- Start with the practical reason the doc exists, then move into behavior and implementation.
- Write for the selected audience. Use direct implementation detail for engineers, outcome and risk language for stakeholders, and task steps for operators or users.
- Keep terminology consistent with the codebase and existing docs.
- Use short sections, clear headings, simple tables, and fenced code blocks with language identifiers.
- Include examples only when they are verified or clearly marked as illustrative.
- Do not include secrets, private identifiers, production credentials, or sensitive customer data.
- Do not present outdated docs, memory, or assumptions as current truth without live verification.
- Prefer diagrams only when they clarify ownership, sequence, or data flow. Use Mermaid if the target renderer supports it; otherwise use a simple text outline.

## Confluence Publishing

- Before publishing, search Confluence for existing pages with the same feature name, acronym, service, or API to avoid duplicate docs.
- Update an existing canonical page when the request is an update; create a new page only when no suitable page exists or the user asks for a new page.
- Use the requested space and parent page. If not provided, infer only from strong local context or existing page hierarchy; otherwise ask.
- Keep Confluence content renderer-friendly: simple headings, lists, tables, code blocks, and links. Avoid raw HTML unless the Confluence tool requires it.
- Preserve existing valuable page sections when updating. Replace stale sections only when the new source evidence contradicts them.
- Do not publish drafts containing unresolved TODOs unless the user explicitly asks for a draft page.
- When publishing succeeds, return the page URL or ID and a concise summary of created or changed sections.

## Quality Checklist

- The doc answers what changed, why it matters, how it works, and how to validate or operate it.
- Every technical claim is backed by source, existing docs, tickets, PRs, or an explicitly named assumption.
- Public contracts, permission boundaries, failure modes, and rollout concerns are covered when relevant.
- Links point to durable sources instead of transient local paths when publishing to Confluence.
- Open questions are separated from confirmed facts.
- The final response states whether the doc was drafted only, written to local files, or published to Confluence.
