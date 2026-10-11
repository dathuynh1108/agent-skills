---
name: subagent-coordination
description: Delegating independent coding, inspection, or review tasks with explicit scope, model/effort selection, and quota recovery.
---

# Subagent Coordination

The coordinator owns critical decisions, integration, and final evidence. Delegate
bounded independent work to a capable route within the user's cost preferences.
Account for context, retries, and review rather than optimizing spawn count alone.

## Select Work And Route

Use the live spawn tool's schema, model allowlist, and supported effort values.
Prefer the user's economy model when available. Set model and effort explicitly
using the supported fields. If the tool cannot select them and would silently
inherit an unknown or costly route, complete the task locally and explain the
limitation. Local execution leaves the coordinator's model and effort unchanged.

| Work | Starting choice |
| --- | --- |
| One command, typo, or already-known answer | Coordinator directly |
| Bounded inspection, mechanical edit, low-risk review | Economy route, low effort |
| Isolated coding, focused debugging, ordinary integration review | Economy/standard route, medium effort |
| Architecture, subtle concurrency, authorization, data integrity | Coordinator or capable child, high effort |
| Unresolved critical reasoning after a focused high-effort attempt | Higher effort only with a task-specific justification |

Review tier follows risk and uncertainty. Lower reasoning on a flagship is not
proof of lower price; cost-saving claims require usage or pricing evidence.

## Dispatch Contract

Delegate alongside useful independent coordinator work. Batch tiny related tasks;
give parallel writers disjoint files and serialize overlapping changes. Reuse the
current orchestration workflow rather than adding a second planning/approval loop.

A brief contains:

- Goal, owning files, read-only/write authority, and acceptance checks.
- Essential context and source pointers, dependencies, and escalation condition.
- Return format: result, file/line evidence, checks/results, unresolved risk.
- No further subagents; the coordinator owns fan-out and integration.

Start with fresh child context and a self-contained brief. Map that intent to the
actual schema: for example, `fork_context: false` when a boolean is supported, or
`fork_turns: "none"` only when that field/value exists. Do not send unsupported
keys or copy model names from old examples. Inherit context only when necessary,
using the narrowest supported option and a concrete reason.

## Failure And Completion

- Spawn success confirms creation, not completion. Track each child to a final
  result or error and collect it before claiming its assignment is complete.
- On quota/auth/model rejection, stop the failed route. Do not repeat unchanged
  calls, rotate through an exhausted provider without evidence of separate quota,
  or automatically upgrade to a flagship. Use a verified permitted alternative
  within user constraints or complete locally; report the limitation.
- For missing context, send a focused correction through the existing child's
  supported message/resume tool. A demonstrated capability gap can justify a
  narrower assignment or a reasoned escalation; quota failure does not.
- Continue complementary work while children run. Use bounded waits or completion
  notifications when needed; a timeout is not completion.
- Verify returned evidence and relevant checks, integrate, and report remaining
  failures. Reuse valid findings rather than repeating the entire investigation.

Installed `superpowers:dispatching-parallel-agents` or
`superpowers:subagent-driven-development` can own orchestration when their workflow
fits. This skill supplies delegation constraints and live-schema selection; it is
prompt guidance, not a runtime spending cap or a main-model configuration change.
