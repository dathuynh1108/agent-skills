#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

mkdir -p "$TMP_ROOT/.codex"
cat >"$TMP_ROOT/.codex/config.toml" <<'EOF'
# BEGIN agent-skills context defaults
model_reasoning_effort = "high"
tool_output_token_limit = 6000
model_auto_compact_token_limit_scope = "body_after_prefix"
# END agent-skills context defaults

model = "test-model"
model_context_window = 128000

[profiles.deep]
model_reasoning_effort = "xhigh"

[plugins."example@openai-curated"]
enabled = false

[plugins."browser@openai-bundled"]
enabled = false

# BEGIN agent-skills lean skill catalog
[[skills.config]]
name = "golang-cli"
enabled = false
# END agent-skills lean skill catalog
EOF

run_sync() {
  HOME="$TMP_ROOT" \
  CODEX_HOME="$TMP_ROOT/.codex" \
  TARGET_SKILLS_DIR="$TMP_ROOT/.codex/skills" \
  AGENTS_SKILLS_DIR="$TMP_ROOT/.agents/skills" \
  SKIP_PLUGIN_CHECKS=1 \
  SKIP_PUBLIC_SKILLS=1 \
    "$ROOT/scripts/sync-codex.sh" >/dev/null
}

run_sync

cmp "$ROOT/AGENTS.md" "$TMP_ROOT/.codex/AGENTS.md"
cmp "$ROOT/hooks/hooks.json" "$TMP_ROOT/.codex/hooks.json"
test -f "$TMP_ROOT/.codex/skills/context-budget/SKILL.md"
grep -q '^model = "test-model"$' "$TMP_ROOT/.codex/config.toml"
test "$(grep -c '^model_context_window = 272000$' "$TMP_ROOT/.codex/config.toml")" -eq 1
grep -q '^\[profiles.deep\]$' "$TMP_ROOT/.codex/config.toml"
grep -q '^model_reasoning_effort = "xhigh"$' "$TMP_ROOT/.codex/config.toml"

if grep -qE '^(tool_output_token_limit|model_auto_compact_token_limit_scope)[[:space:]]*=' "$TMP_ROOT/.codex/config.toml"; then
  echo "Expected retired context limits to be removed" >&2
  exit 1
fi
if grep -qE '^(# BEGIN agent-skills lean skill catalog|name = "golang-cli")$' "$TMP_ROOT/.codex/config.toml"; then
  echo "Expected the retired lean skill catalog to be removed" >&2
  exit 1
fi

awk '
  $0 == "[plugins.\"browser@openai-bundled\"]" { in_browser = 1; next }
  /^\[/ { in_browser = 0 }
  in_browser && $0 == "enabled = true" { found = 1 }
  END { exit(found ? 0 : 1) }
' "$TMP_ROOT/.codex/config.toml"
awk '
  $0 == "[plugins.\"example@openai-curated\"]" { in_example = 1; next }
  /^\[/ { in_example = 0 }
  in_example && $0 == "enabled = false" { found = 1 }
  END { exit(found ? 0 : 1) }
' "$TMP_ROOT/.codex/config.toml"

cp "$TMP_ROOT/.codex/config.toml" "$TMP_ROOT/first.toml"
run_sync
cmp "$TMP_ROOT/first.toml" "$TMP_ROOT/.codex/config.toml"

echo "Codex sync tests passed"
