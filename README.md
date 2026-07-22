# Codex Agent Skills Backup

Shared iNexus Codex bootstrap, custom skills, full-context defaults, and sync scripts.

## Contents

- `AGENTS.md`: global Codex operating rules, copied from `~/.codex/AGENTS.md`.
- `skills/architecture-pattern-review`: custom architecture review workflow.
- `skills/code-review-and-quality`: custom code review workflow.
- `skills/commit-rules`: custom commit/staging workflow.
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
- `skills/context-budget`: focused, layered retrieval and checkpoint discipline without reducing model capability.
- `scripts/install-skills.ps1`: install repo-managed skills into Windows `%USERPROFILE%\.codex\skills` or `TARGET_SKILLS_DIR`, and approved public skills into `%USERPROFILE%\.agents\skills`.
- `scripts/install-skills.sh`: install repo-managed skills into macOS/Linux `~/.codex/skills` or `TARGET_SKILLS_DIR`, and approved public skills into `~/.agents/skills`.
- `scripts/test-install-skills.ps1`: verify the same public/custom skill isolation behavior on Windows.
- `scripts/test-install-skills.sh`: verify public skills remain in the universal agents root and do not overwrite Codex-local custom skills.
- `scripts/test-sync-codex.ps1` / `scripts/test-sync-codex.sh`: verify complete sync, config preservation, legacy-profile migration, and idempotency.
- `scripts/validate-skills.ps1`: validate skill structure on Windows and run Codex `quick_validate.py` when available.
- `scripts/validate-skills.sh`: validate skill structure on macOS/Linux and run Codex `quick_validate.py` when available.
- `hooks/hooks.json`: optional Codex hook config for final scope checks.
- `config/codex-context-root.toml`: shared non-secret maximum context-window setting.
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

## Context Policy

Codex keeps every installed skill and plugin available. Context efficiency comes
from the compact global prompt and the `context-budget` retrieval workflow, not
from hiding capabilities or truncating tool results.

The shared config pins `model_context_window = 272000`, the maximum advertised by
the shared GPT-5.6-Sol Codex model catalog. It deliberately does not set
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

## Sync From Local Codex

Run from this repo when local custom skills change:

```bash
cp ~/.codex/AGENTS.md ./AGENTS.md
rsync -a --delete ~/.codex/skills/architecture-pattern-review/ ./skills/architecture-pattern-review/
rsync -a --delete ~/.codex/skills/code-review-and-quality/ ./skills/code-review-and-quality/
rsync -a --delete ~/.codex/skills/commit-rules/ ./skills/commit-rules/
rsync -a --delete ~/.codex/skills/python-clean-code/ ./skills/python-clean-code/
rsync -a --delete ~/.codex/skills/go-clean-code/ ./skills/go-clean-code/
rsync -a --delete ~/.codex/skills/feature-technical-writer/ ./skills/feature-technical-writer/
rsync -a --delete ~/.codex/skills/system-design-review/ ./skills/system-design-review/
rsync -a --delete ~/.codex/skills/backend-service-design/ ./skills/backend-service-design/
rsync -a --delete ~/.codex/skills/api-contract-design/ ./skills/api-contract-design/
rsync -a --delete ~/.codex/skills/data-modeling-and-storage/ ./skills/data-modeling-and-storage/
rsync -a --delete ~/.codex/skills/distributed-systems-reliability/ ./skills/distributed-systems-reliability/
rsync -a --delete ~/.codex/skills/performance-engineering/ ./skills/performance-engineering/
rsync -a --delete ~/.codex/skills/observability-and-debugging/ ./skills/observability-and-debugging/
rsync -a --delete ~/.codex/skills/testing-strategy/ ./skills/testing-strategy/
rsync -a --delete ~/.codex/skills/refactoring-and-clean-code/ ./skills/refactoring-and-clean-code/
rsync -a --delete ~/.codex/skills/ml-system-design/ ./skills/ml-system-design/
rsync -a --delete ~/.codex/skills/deep-learning-production/ ./skills/deep-learning-production/
rsync -a --delete ~/.codex/skills/mlops-data-pipeline-quality/ ./skills/mlops-data-pipeline-quality/
rsync -a --delete ~/.codex/skills/security-privacy-review/ ./skills/security-privacy-review/
rsync -a --delete ~/.codex/skills/context-budget/ ./skills/context-budget/
cp ~/.codex/hooks.json ./hooks/hooks.json
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
