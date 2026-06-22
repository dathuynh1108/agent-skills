# Codex Agent Skills Backup

Backup repo for personal Codex bootstrap files and custom skills.

## Contents

- `AGENTS.md`: global Codex operating rules, copied from `~/.codex/AGENTS.md`.
- `skills/architecture-pattern-review`: custom architecture review workflow.
- `skills/code-review-and-quality`: custom code review workflow.
- `skills/commit-rules`: custom commit/staging workflow.

Installed or bundled skills are intentionally excluded. Do not add `.system`,
`codex-primary-runtime`, plugin-cache skills, or skills installed from curated
bundles unless they become real custom-maintained skills.

## Restore

From a fresh machine:

```bash
git clone git@github.com:dathuynh1108/agent-skills.git
mkdir -p ~/.codex/skills
cp agent-skills/AGENTS.md ~/.codex/AGENTS.md
rsync -a agent-skills/skills/ ~/.codex/skills/
```

## Sync From Local Codex

Run from this repo when local custom skills change:

```bash
cp ~/.codex/AGENTS.md ./AGENTS.md
rsync -a --delete ~/.codex/skills/architecture-pattern-review/ ./skills/architecture-pattern-review/
rsync -a --delete ~/.codex/skills/code-review-and-quality/ ./skills/code-review-and-quality/
rsync -a --delete ~/.codex/skills/commit-rules/ ./skills/commit-rules/
```

Then validate before committing:

```bash
for d in skills/*; do
  [ -f "$d/SKILL.md" ] || continue
  python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py "$PWD/$d"
done
```
