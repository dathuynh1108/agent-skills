# agent-skills

This repository owns shared Codex guidance, custom skills, and restore scripts.
Global behavior comes from `config/AGENTS.global.md`; keep this file repo-specific.

## Ownership

- `config/AGENTS.global.md` is the source for `$CODEX_HOME/AGENTS.md`
  (normally `~/.codex/AGENTS.md`). Do not copy this repo's `AGENTS.md` there.
- `skills/<name>/SKILL.md` and `agents/openai.yaml` are custom-maintained skills.
  Keep folder/name metadata consistent and descriptions specific to their triggers.
- Public packages stay in `~/.agents/skills`; plugin-managed skills stay in their
  plugin cache. Keep approved public sources aligned in both install scripts.
  Do not vendor, rewrite, or remove upstream skills as part of prompt cleanup.
- Bash and PowerShell install/sync scripts must have equivalent behavior. Preserve
  existing model/profile/plugin settings outside the explicit context migration.
- `hooks/hooks.json` is the shared hook source; private runtime config and local
  backups do not belong in Git.

## Checks

Run from the repo root when changing install/sync behavior or publishing skills:

```bash
bash scripts/test-install-skills.sh
bash scripts/test-sync-codex.sh
bash scripts/validate-skills.sh
git diff --check
```

For changed Bash scripts, run `bash -n`, `shellcheck`, and `shfmt -d -i 2`.
PowerShell equivalents use the same script names with `.ps1`; report when `pwsh`
is unavailable. Review prompt routing against concrete task scenarios; structural
validation does not measure token costs or hallucination rates.

## Sync And Publication

- Update the template, affected custom skills, both sync scripts/tests, and README
  together when changing source ownership or restore behavior.
- Before an authorized local sync, compare managed runtime files to their source
  and preserve divergent local work. For prompt/custom-skill updates, run
  `SKIP_PUBLIC_SKILLS=1 SKIP_CONFIG_SYNC=1 bash scripts/sync-codex.sh` to preserve
  runtime config, then verify installed contents. Full restores can apply the
  documented context defaults by omitting `SKIP_CONFIG_SYNC`.
- Reverse-sync global guidance into `config/AGENTS.global.md`. Copy back only
  deliberately changed custom skills; preserve public/plugin source separation.
- For an authorized publication, stage explicit task files, commit, push a
  `codex/` branch, and use a PR to `main`. Squash-merge when requested and verify
  remote `main` plus local sync state before reporting completion.
