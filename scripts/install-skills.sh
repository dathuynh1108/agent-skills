#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET="${TARGET_SKILLS_DIR:-$CODEX_HOME_DIR/skills}"

mkdir -p "$TARGET"

if command -v rsync >/dev/null 2>&1; then
  rsync -a "$ROOT/skills/" "$TARGET/"
else
  cp -R "$ROOT/skills/." "$TARGET/"
fi

echo "Installed skills from $ROOT/skills to $TARGET"
echo "Override with TARGET_SKILLS_DIR=/path/to/skills ./scripts/install-skills.sh"
