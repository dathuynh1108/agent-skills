# Codex Agent Skills Backup

Shared iNexus Codex bootstrap, custom skills, full-context defaults, and sync scripts.

## Contents

- `AGENTS.md`: repository ownership, checks, and publication conventions.
- `config/AGENTS.global.md`: global Codex guidance, synced to `~/.codex/AGENTS.md`.
- `skills/architecture-pattern-review`: custom architecture review workflow.
- `skills/code-review-and-quality`: custom code review workflow.
- `skills/commit-rules`: custom commit/staging workflow.
- `skills/subagent-coordination`: model/effort routing, bounded parallel work,
  review tiers, and quota recovery; complements installed Superpowers workflows.
- `skills/python-clean-code`: reusable Python coding style and validation workflow.
- `skills/go-clean-code`: reusable Go coding style and validation workflow.
- `skills/feature-technical-writer`: feature docs and Confluence publishing workflow.
- `skills/system-design-review`: system design proposals, ADRs, scale/reliability trade-offs, and rollout plans.
- `skills/backend-service-design`: backend APIs, services, repositories, workers/jobs, external clients, and service boundaries.
- `skills/api-contract-design`: REST/gRPC/GraphQL/webhook/event/SDK/OpenAPI/protobuf contract design and compatibility.
- `skills/data-modeling-and-storage`: schemas, migrations, indexes, transactions, backfills, query patterns, and storage choices.
- `skills/distributed-systems-reliability`: retries, idempotency, queues, events, timeouts, cancellation, backpressure, and partial failure.
- `skills/performance-engineering`: measurement-first latency, throughput, CPU, memory, database, cache, concurrency, and inference optimization.
- `skills/observability-and-debugging`: evidence-first debugging, instrumentation, logs, metrics, traces, dashboards, alerts, and runbooks.
- `skills/testing-strategy`: test selection and quality gates for backend, distributed, performance, data, ML, DL, and refactor work.
- `skills/refactoring-and-clean-code`: language-agnostic clean code and behavior-preserving refactoring.
- `skills/ml-system-design`: ML system architecture, data/features, training/serving, evaluation, monitoring, drift, and rollout.
- `skills/deep-learning-production`: production DL training/evaluation/inference, GPU performance, checkpointing, and deployment.
- `skills/mlops-data-pipeline-quality`: data/feature pipelines, data quality, train/serve skew, labels, backfills, lineage, and monitoring.
- `skills/security-privacy-review`: defensive security/privacy review for backend, API, data, ML, logging, auth, secrets, and dependencies.
- `scripts/install-skills.ps1`: install repo-managed skills into Windows `%USERPROFILE%\.codex\skills` or `TARGET_SKILLS_DIR`, and approved public skills into `%USERPROFILE%\.agents\skills`.
- `scripts/install-skills.sh`: install repo-managed skills into macOS/Linux `~/.codex/skills` or `TARGET_SKILLS_DIR`, and approved public skills into `~/.agents/skills`.
- `scripts/test-install-skills.ps1`: verify the same public/custom skill isolation behavior on Windows.
- `scripts/test-install-skills.sh`: verify public skills remain in the universal agents root and do not overwrite Codex-local custom skills.
- `scripts/test-sync-codex.ps1` / `scripts/test-sync-codex.sh`: verify complete sync, config preservation, legacy-profile migration, and idempotency.
- `scripts/validate-skills.ps1`: validate skill structure on Windows and run Codex `quick_validate.py` when available.
- `scripts/validate-skills.sh`: validate skill structure on macOS/Linux and run Codex `quick_validate.py` when available.
- `hooks/hooks.json`: optional Codex hook config for final scope checks.
- `config/codex-context-root.toml`: shared non-secret context-window setting.
- `config/codex-legacy-lean-plugins.txt`: one-time migration list used to undo the retired lean profile without changing unrelated plugin state.
- `scripts/sync-codex.sh` / `scripts/sync-codex.ps1`: complete source-to-runtime sync for AGENTS, hooks, custom skills, and context config.

Installed or bundled skills are intentionally excluded. Do not add `.system`,
`codex-primary-runtime`, plugin-cache skills, or skills installed from curated
bundles unless they become real custom-maintained skills.

Public skills are intentionally not vendored into this repo. The install scripts
reinstall approved public packages with `npx skills add` into the universal
`~/.agents/skills` root, which current Codex versions discover directly. Public
skills are not mirrored into the Codex-local custom skills directory:

- `supabase/agent-skills@supabase-postgres-best-practices`
- `wshobson/agents@database-migration`
- `wshobson/agents@api-design-principles`
- `wshobson/agents@architecture-patterns`
- `wshobson/agents@airflow-dag-patterns`
- `wshobson/agents@cqrs-implementation`
- `wshobson/agents@data-quality-frameworks`
- `wshobson/agents@dbt-transformation-patterns`
- `wshobson/agents@design-system-patterns`
- `wshobson/agents@event-store-design`
- `wshobson/agents@error-handling-patterns`
- `wshobson/agents@interaction-design`
- `wshobson/agents@microservices-patterns`
- `wshobson/agents@nodejs-backend-patterns`
- `wshobson/agents@openapi-spec-generation`
- `wshobson/agents@projection-patterns`
- `wshobson/agents@responsive-design`
- `wshobson/agents@saga-orchestration`
- `wshobson/agents@spark-optimization`
- `wshobson/agents@sql-optimization-patterns`
- `wshobson/agents@temporal-python-testing`
- `wshobson/agents@workflow-orchestration-patterns`
- `wshobson/agents@python-code-style`
- `wshobson/agents@python-design-patterns`
- `wshobson/agents@python-project-structure`
- `wshobson/agents@python-testing-patterns`
- `wshobson/agents@python-performance-optimization`
- `wshobson/agents@fastapi-templates`
- `fastapi/fastapi@fastapi`
- `wispbit-ai/skills@sqlalchemy-alembic-expert-best-practices-code-review`
- `abhigyanpatwari/gitnexus` full bundle
- `vercel-labs/skills@find-skills`
- `vercel-labs/agent-skills@vercel-composition-patterns`
- `jeffallan/claude-skills@kubernetes-specialist`
- `jeffallan/claude-skills@websocket-engineer`
- `redis/agent-skills@redis-core`
- `redis/agent-skills@redis-connections`
- `redis/agent-skills@redis-observability`
- `redis/agent-skills@redis-clustering`
- `https://github.com/addyosmani/web-quality-skills` full bundle with `--all`
- `https://github.com/samber/cc-skills-golang` full bundle with `--all`
- `https://github.com/Leonxlnx/taste-skill` full bundle

The current GitNexus bundle includes the focused graph skills plus
`gitnexus-plan`, `gitnexus-work`, `gitnexus-review`, and the gated
`gitnexus-lfg` end-to-end workflow. The installer verifies these current names
and no longer retains the retired `gitnexus-pr-review` alias.

Vercel retired the global `next-best-practices` skill in favor of
version-matched Next.js bundled docs and generated project agent guidance, so
the bootstrap intentionally does not pin the stale skill.

Required Codex plugins are plugin-managed by Codex, not `npx skills`. The
install scripts verify they are present, enabled, and expose required skills
before restoring skills:

- `codex-security@openai-curated`

Codex Security required workflows include security scans, diff scans, deep scans,
threat modeling, finding discovery, validation, attack-path analysis, finding
triage, finding fixes, and issue/advisory tracking.

## Instruction Ownership And Routing

`config/AGENTS.global.md` owns shared rules; root `AGENTS.md` only describes this
repository. Both sync implementations install the global template and leave the
project file untouched. Reverse-sync also targets the template, avoiding duplicate
global instructions when working in this repo.

The router chooses one main workflow for the current phase and adds domain skills
for concrete decisions. Small FastAPI edits do not need project templates; UI bug
fixes preserve the existing design; API and architecture skills apply when those
boundaries change. Existing user approval carries through the same scope, with
actual tool permissions still enforced.

ai-memory supplements the conversation and Codex memory when more relevant
project context is needed. Recall is selective: query `memory_query` for history questions,
unfamiliar resumed work, or consequential boundary changes whose prior project
rules are missing from context. Task size alone does not trigger recall. Skip
self-contained/mechanical work and continuations with sufficient relevant context.
Use focused snippets first, read only full pages needed for a decision, and reuse
results rather than querying every turn. A preloaded Codex summary can guide a
lookup; `memory_status` is only a health check. Validate historical claims against
source and report failures without blocking safe work from current evidence.

For this setup's static HTTP ai-memory client, resolve the nearest project marker
and pass explicit workspace/project scope. Generic auto-scoping applies only to
clients that establish session identity. Detailed TTL, ranking, and refresh behavior
stays in the installed ai-memory skills; do not copy a second generic managed block
into the global template. Upstream/plugin files remain managed by their installers.

Skill descriptions put task/domain discriminators first. Public capabilities remain
installed and available; local routing chooses focused entrypoints without rewriting
upstream skills. File-size comparisons measure text size, not model tokens, latency,
or hallucination rates.

## Context Policy

Codex keeps every installed skill and plugin available. Context efficiency comes
from the compact global prompt and its layered retrieval policy, not from hiding
capabilities or truncating tool results.

The shared config pins `model_context_window = 272000` as this repository's
configured default; it does not select a model or reasoning effort. Confirm the
window is supported when changing models. It deliberately does not set
`tool_output_token_limit`, `model_auto_compact_token_limit`, or
`project_doc_max_bytes`.

The sync scripts automatically remove the retired lean skill catalog. Only when
that legacy marker is present, they re-enable plugins previously managed by the
lean profile; later syncs preserve all plugin settings unchanged.

## Restore Or Sync

Restore requires Node.js/npm for the public `npx skills` installs. Set
`SKIP_PUBLIC_SKILLS=1` if you only want the repo-managed custom skills.
Set `SKIP_PLUGIN_CHECKS=1` only when restoring into an environment where Codex
plugins are intentionally unavailable.

Older restores may contain identical public skill copies under both
`~/.agents/skills` and `~/.codex/skills`. Remove a Codex-local copy only after
confirming its complete directory tree matches the canonical public copy;
preserve any divergent local override.

From a fresh Windows machine, run in PowerShell from the repo root:

```powershell
.\scripts\sync-codex.ps1
```

From a fresh macOS/Linux machine, run from the repo root:

```bash
./scripts/sync-codex.sh
```

Fast sync without refreshing public packages:

```bash
SKIP_PUBLIC_SKILLS=1 ./scripts/sync-codex.sh
```

To update global guidance, hooks, and custom skills while preserving every byte of
the current `config.toml`, also set `SKIP_CONFIG_SYNC=1`. This skips context-default
and legacy-plugin migrations and leaves an absent config absent:

```bash
SKIP_PUBLIC_SKILLS=1 SKIP_CONFIG_SYNC=1 ./scripts/sync-codex.sh
```

PowerShell supports the same environment switches:

```powershell
$env:SKIP_PUBLIC_SKILLS = "1"
$env:SKIP_CONFIG_SYNC = "1"
.\scripts\sync-codex.ps1
Remove-Item Env:SKIP_PUBLIC_SKILLS, Env:SKIP_CONFIG_SYNC
```

## Subagent Model Routing

`config/AGENTS.global.md` routes delegation through `$subagent-coordination`.
The coordinator keeps planning and critical decisions, batches small jobs for lighter agents,
and selects each child's model, reasoning effort, and fresh context using the live
tool schema. When explicit route selection is unavailable, work stays local.
Critical reviews use a stronger tier; routine reviews do not automatically do so.
Quota failures trigger a supported alternate or local completion, not an automatic
flagship upgrade. Model names and effort values come from the live spawn allowlist.
The user's economy model is preferred when available; no model name is hard-coded.

The existing Bash and PowerShell installers discover the custom skill automatically.
Run the normal sync command above to install it and refresh global `AGENTS.md`.
This is instruction-based routing, not a spending cap or a change to the main model.
It reuses the installed Superpowers plugin instead of adding a duplicate public copy.

## Sync From Local Codex

Review local changes before copying them back. Run from this repo only when the
local managed copies are the intended source; the loop includes all repo-owned
skills, including `subagent-coordination`:

```bash
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
cp "$CODEX_HOME_DIR/AGENTS.md" ./config/AGENTS.global.md
for source in ./skills/*; do
  [ -d "$source" ] || continue
  name="${source##*/}"
  rsync -a --delete "$CODEX_HOME_DIR/skills/$name/" "$source/"
done
cp "$CODEX_HOME_DIR/hooks.json" ./hooks/hooks.json
```

Public `npx` skills should stay out of `skills/`. Update the public source list
inside `scripts/install-skills.sh` and `scripts/install-skills.ps1` when adding
or removing approved external skill packages.

Then validate before committing on Windows:

```powershell
.\scripts\test-install-skills.ps1
.\scripts\test-sync-codex.ps1
.\scripts\validate-skills.ps1
```

Or on macOS/Linux:

```bash
./scripts/test-install-skills.sh
./scripts/test-sync-codex.sh
./scripts/validate-skills.sh
```
