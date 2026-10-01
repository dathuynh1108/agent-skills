---
name: subagent-coordination
description: Use when coordinating coding, inspection, or review tasks with subagents, choosing model and reasoning tiers, or handling expensive inheritance, duplicated work, and quota failures.
---

# Subagent Coordination

Keep planning, critical decisions, and integration with the coordinator. Delegate
bounded work to the least costly available route capable of completing it reliably.
Optimize total work, including context, retries, and review, rather than spawn count.

## Choose the work and tier

Use the actual spawn tool's current model allowlist and supported effort values.
Select both explicitly for every child; never infer availability from a model name
in a skill, chat, or provider catalog. Prefer the user's economy model (for example
Luna) when supported. Lower reasoning on a flagship is not proof of a cheaper model;
do not claim price savings without usage or pricing evidence.

The effort choices below apply to new children. For local work, report the current
coordinator model/effort unchanged; selecting local work does not switch its model.

| Work | Starting route |
| --- | --- |
| One command, typo, or already-known answer | Coordinator directly; no child |
| Bounded inspection, mechanical edit, low-risk diff review | Economy model, low effort |
| Isolated coding with some judgment, focused debugging or integration review | Economy/standard model, medium effort |
| Architecture, subtle concurrency, authorization, data integrity | Coordinator unchanged, or capable child at high effort |
| Unresolved critical reasoning after a focused high-effort attempt | Consider xhigh or higher with a concrete reason |

Review tier follows risk and uncertainty, not the word "review" or "final".
Keep required verification; cheap review is suitable for a small mechanical diff,
not a substitute for an authorization or concurrency analysis.

## Dispatch contract

Delegate only when a concrete task can run independently alongside useful work.
Batch similar small inspections or edits into one child. Start with one or two
useful workers; expand only for independent scope and demonstrable benefit.
Parallel writers own disjoint files; serialize overlapping edits.

For each dispatch, specify:

- Task, owning files, read-only/write authority, and acceptance checks.
- Exact supported `model`, `reasoning_effort`, and `fork_turns: "none"`.
- Necessary context and source pointers, dependencies, and escalation condition.
- Return contract: result, file/line evidence, checks/results, and unresolved risk.
- No further subagents; the coordinator owns fan-out and integration.

Provide a self-contained brief. If essential recent context cannot be expressed
adequately, use a bounded positive `fork_turns` allowed by the live schema and
explain why. Full-history inheritance is not the default. Keep root effort and
context settings unchanged; this policy concerns delegated work.

Example, only when this exact route is currently supported and available:

```json
{
  "task_name": "inspect_sync",
  "model": "chatgpt-web/medium",
  "reasoning_effort": "medium",
  "fork_turns": "none",
  "message": "Read-only: inspect scripts/sync-codex.sh and its adjacent test. Identify whether sync preserves the main model setting. Return file/line evidence and any ambiguity. Do not edit, spawn agents, or run sync against the real home directory."
}
```

This example selects a supported effort; it does not assert that this route is
Luna or that its billing is cheaper. Re-resolve models when the runtime changes.

## Failure and completion

- A successful spawn acknowledges creation, not completion. Track each child
  through its final result or error; never silently drop a failed assignment.
- Quota/auth/model rejection: stop that route for this attempt. Do not repeat the
  same call unchanged, rotate through siblings of an exhausted provider without
  evidence of separate quota, or auto-upgrade to a flagship. Use a verified working
  alternate within the user's constraints; otherwise do the bounded work locally
  and report the limitation. Quota failure is not a reasoning-quality failure.
- Missing context: clarify with the existing child using the supported resume
  tool. If one focused correction leaves a capability gap, narrow or escalate
  that task with a reason instead of repeating identical attempts.
- Continue complementary work while children run. When idle, use the available
  bounded wait/notification mechanism; avoid rapid polling and silent abandonment.
- Verify returned evidence and relevant tests, then integrate. Do not redo every
  delegated investigation. Report unresolved failures and distinguish behavioral
  smoke tests from measured token or cost savings.

Use installed `superpowers:dispatching-parallel-agents` for independent work and
`superpowers:subagent-driven-development` for a multi-step implementation when
their workflows are needed. This user's tier policy guides optional model defaults;
current system instructions, tool contracts, and task constraints remain authoritative.
This skill is prompt guidance, not a runtime-enforced spending cap.
