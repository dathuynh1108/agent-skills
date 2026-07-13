#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

AGENTS_SKILLS_DIR="$TMP_ROOT/.agents/skills"
TARGET_SKILLS_DIR="$TMP_ROOT/.codex/skills"
mkdir -p "$AGENTS_SKILLS_DIR" "$TARGET_SKILLS_DIR"

write_skill() {
  local root="$1"
  local name="$2"
  local marker="$3"

  mkdir -p "$root/$name/references"
  printf '%s\n' "---" "name: $name" "description: test fixture" "---" "" "$marker" >"$root/$name/SKILL.md"
  printf '%s\n' "$marker reference" >"$root/$name/references/details.md"
}

while IFS= read -r name; do
  write_skill "$AGENTS_SKILLS_DIR" "$name" "public copy"
done < <(
  sed -n '/^PUBLIC_SKILL_NAMES=(/,/^)/p' "$ROOT/scripts/install-skills.sh" |
    sed -n 's/^  "\([^"]*\)"$/\1/p'
)

write_skill "$TARGET_SKILLS_DIR" "redis-core" "custom override"
write_skill "$TARGET_SKILLS_DIR" "local-only" "local only"

BIN_DIR="$TMP_ROOT/bin"
mkdir -p "$BIN_DIR"
printf '%s\n' '#!/usr/bin/env bash' 'if [ -n "${NPX_CALL_LOG:-}" ]; then printf "%s\n" "$*" >>"$NPX_CALL_LOG"; fi' 'exit 0' >"$BIN_DIR/npx"
chmod +x "$BIN_DIR/npx"

NPX_CALL_LOG="$TMP_ROOT/npx.log" \
PATH="$BIN_DIR:$PATH" \
HOME="$TMP_ROOT" \
CODEX_HOME="$TMP_ROOT/.codex" \
TARGET_SKILLS_DIR="$TARGET_SKILLS_DIR" \
AGENTS_SKILLS_DIR="$AGENTS_SKILLS_DIR" \
SKIP_PLUGIN_CHECKS=1 \
  "$ROOT/scripts/install-skills.sh" >"$TMP_ROOT/install.log"

if [ -e "$TARGET_SKILLS_DIR/find-skills" ]; then
  echo "Expected public skill to remain outside the Codex custom target: find-skills" >&2
  exit 1
fi

if [ ! -f "$AGENTS_SKILLS_DIR/find-skills/SKILL.md" ]; then
  echo "Expected canonical public skill to remain in the universal agents root" >&2
  exit 1
fi

if ! grep -q '^custom override$' "$TARGET_SKILLS_DIR/redis-core/SKILL.md"; then
  echo "Expected divergent local override to be preserved: redis-core" >&2
  exit 1
fi

if [ ! -f "$TARGET_SKILLS_DIR/local-only/SKILL.md" ]; then
  echo "Expected unrelated local skill to be preserved: local-only" >&2
  exit 1
fi

if [ ! -f "$TARGET_SKILLS_DIR/commit-rules/SKILL.md" ]; then
  echo "Expected repo-managed custom skills to be installed" >&2
  exit 1
fi

if [ ! -s "$TMP_ROOT/npx.log" ]; then
  echo "Expected normal mode to invoke npx" >&2
  exit 1
fi

if grep -Eq '(^| )--all( |$)' "$TMP_ROOT/npx.log"; then
  echo "Expected installer not to use --all because it targets every agent" >&2
  exit 1
fi

if grep -Evq '(^| )--agent codex( |$)' "$TMP_ROOT/npx.log"; then
  echo "Expected every npx install call to target the Codex agent" >&2
  exit 1
fi

SKIP_TARGET="$TMP_ROOT/.codex-skip/skills"
mkdir -p "$SKIP_TARGET"
write_skill "$SKIP_TARGET" "find-skills" "legacy mirror"

NPX_CALL_LOG="$TMP_ROOT/npx-skip.log" \
PATH="$BIN_DIR:$PATH" \
HOME="$TMP_ROOT" \
CODEX_HOME="$TMP_ROOT/.codex-skip" \
TARGET_SKILLS_DIR="$SKIP_TARGET" \
AGENTS_SKILLS_DIR="$AGENTS_SKILLS_DIR" \
SKIP_PLUGIN_CHECKS=1 \
SKIP_PUBLIC_SKILLS=1 \
  "$ROOT/scripts/install-skills.sh" >"$TMP_ROOT/skip.log"

if [ -e "$TMP_ROOT/npx-skip.log" ]; then
  echo "Expected skip mode not to invoke npx" >&2
  exit 1
fi

if ! grep -q '^legacy mirror$' "$SKIP_TARGET/find-skills/SKILL.md"; then
  echo "Expected skip mode not to mutate existing public mirrors" >&2
  exit 1
fi

if grep -Eq 'rsync -a --delete "\$source_dir/" "\$destination/"|cp -R "\$source_dir" "\$destination"' "$ROOT/scripts/install-skills.sh"; then
  echo "Bash installer still mirrors public skills into the Codex target" >&2
  exit 1
fi

if grep -Fq 'Copy-Item -LiteralPath $installedSkill -Destination $destination' "$ROOT/scripts/install-skills.ps1"; then
  echo "PowerShell installer still mirrors public skills into the Codex target" >&2
  exit 1
fi

echo "Installer public-skill isolation tests passed"
