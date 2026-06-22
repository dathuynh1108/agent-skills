# Codex Agent Skills Backup

Backup repo for personal Codex bootstrap files and custom skills.

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
- `skills/gitnexus-guide`: official GitNexus workflow and tool selection reference.
- `skills/gitnexus-cli`: official GitNexus index/status/clean/wiki/list command workflow.
- `skills/gitnexus-exploring`: official GitNexus architecture, ownership, caller/callee, and execution-flow exploration workflow.
- `skills/gitnexus-impact-analysis`: official GitNexus blast-radius and diff-impact workflow.
- `skills/gitnexus-debugging`: official GitNexus bug and regression tracing workflow.
- `skills/gitnexus-refactoring`: official GitNexus graph-aware refactoring workflow.
- `skills/gitnexus-pr-review`: official GitNexus PR/branch/diff review workflow.
- `skills/gitnexus-pdg-query`: official GitNexus PDG control/data-dependence query workflow.
- `skills/gitnexus-taint-analysis`: official GitNexus CFG/taint/PDG analysis workflow.
- `scripts/install-skills.ps1`: install repo skills into Windows `%USERPROFILE%\.codex\skills` or `TARGET_SKILLS_DIR`.
- `scripts/install-skills.sh`: install repo skills into macOS/Linux `~/.codex/skills` or `TARGET_SKILLS_DIR`.
- `scripts/validate-skills.ps1`: validate skill structure on Windows and run Codex `quick_validate.py` when available.
- `scripts/validate-skills.sh`: validate skill structure on macOS/Linux and run Codex `quick_validate.py` when available.
- `hooks/hooks.json`: optional Codex hook config for final scope checks.

Installed or bundled skills are intentionally excluded. Do not add `.system`,
`codex-primary-runtime`, plugin-cache skills, or skills installed from curated
bundles unless they become real custom-maintained skills.

## Restore

From a fresh Windows machine, run in PowerShell from the repo root:

```powershell
Copy-Item .\AGENTS.md "$HOME\.codex\AGENTS.md" -Force
.\scripts\install-skills.ps1
Copy-Item .\hooks\hooks.json "$HOME\.codex\hooks.json" -Force
```

From a fresh macOS/Linux machine, run from the repo root:

```bash
mkdir -p ~/.codex/skills
cp AGENTS.md ~/.codex/AGENTS.md
./scripts/install-skills.sh
cp hooks/hooks.json ~/.codex/hooks.json
```

## GitNexus CLI And MCP

GitNexus skills in this repo are only the agent workflows. Install the actual
CLI and Codex MCP integration separately on each machine:

```powershell
npm install -g gitnexus@latest
gitnexus setup -c codex
gitnexus --version
```

Run `gitnexus analyze` from each repository root that should be indexed.

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
rsync -a --delete ~/.codex/skills/gitnexus-guide/ ./skills/gitnexus-guide/
rsync -a --delete ~/.codex/skills/gitnexus-cli/ ./skills/gitnexus-cli/
rsync -a --delete ~/.codex/skills/gitnexus-exploring/ ./skills/gitnexus-exploring/
rsync -a --delete ~/.codex/skills/gitnexus-impact-analysis/ ./skills/gitnexus-impact-analysis/
rsync -a --delete ~/.codex/skills/gitnexus-debugging/ ./skills/gitnexus-debugging/
rsync -a --delete ~/.codex/skills/gitnexus-refactoring/ ./skills/gitnexus-refactoring/
rsync -a --delete ~/.codex/skills/gitnexus-pr-review/ ./skills/gitnexus-pr-review/
rsync -a --delete ~/.codex/skills/gitnexus-pdg-query/ ./skills/gitnexus-pdg-query/
rsync -a --delete ~/.codex/skills/gitnexus-taint-analysis/ ./skills/gitnexus-taint-analysis/
cp ~/.codex/hooks.json ./hooks/hooks.json
```

Then validate before committing on Windows:

```powershell
.\scripts\validate-skills.ps1
```

Or on macOS/Linux:

```bash
./scripts/validate-skills.sh
```
