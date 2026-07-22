#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
CONFIG_FILE="$CODEX_HOME_DIR/config.toml"

mkdir -p "$CODEX_HOME_DIR"
touch "$CONFIG_FILE"

"$ROOT/scripts/install-skills.sh"
cp "$ROOT/AGENTS.md" "$CODEX_HOME_DIR/AGENTS.md"
cp "$ROOT/hooks/hooks.json" "$CODEX_HOME_DIR/hooks.json"

legacy_lean=0
if grep -q '^# BEGIN agent-skills lean skill catalog$' "$CONFIG_FILE"; then
  legacy_lean=1
fi

stripped="$(mktemp)"
cleaned="$(mktemp)"
updated="$(mktemp)"
migrated="$(mktemp)"
trap 'rm -f "$stripped" "$cleaned" "$updated" "$migrated"' EXIT

awk '
  /^# BEGIN agent-skills context defaults$/ { skip = 1; next }
  /^# END agent-skills context defaults$/ { skip = 0; next }
  /^# BEGIN agent-skills lean skill catalog$/ { skip = 1; next }
  /^# END agent-skills lean skill catalog$/ { skip = 0; next }
  !skip { print }
' "$CONFIG_FILE" >"$stripped"

awk '
  BEGIN { in_root = 1; started = 0; pending_blanks = 0 }
  in_root && /^\[/ { in_root = 0 }
  in_root && /^model_context_window[[:space:]]*=/ { next }
  /^[[:space:]]*$/ {
    if (started) pending_blanks++
    next
  }
  {
    while (pending_blanks > 0) {
      print ""
      pending_blanks--
    }
    print
    started = 1
  }
' "$stripped" >"$cleaned"

sed -n '1,$p' "$ROOT/config/codex-context-root.toml" >"$updated"
if [ -s "$cleaned" ]; then
  printf '\n' >>"$updated"
  sed -n '1,$p' "$cleaned" >>"$updated"
fi

if [ "$legacy_lean" -eq 1 ]; then
  awk -v list="$ROOT/config/codex-legacy-lean-plugins.txt" '
    BEGIN {
      while ((getline line < list) > 0) {
        if (line !~ /^[[:space:]]*(#|$)/) legacy[line] = 1
      }
      close(list)
    }
    function finish_section() {
      if (in_legacy && !saw_enabled) print "enabled = true"
    }
    /^\[/ {
      finish_section()
      in_legacy = 0
      saw_enabled = 0
      section = $0
      sub(/^\[plugins\."/, "", section)
      sub(/"\]$/, "", section)
      if (section != $0) in_legacy = legacy[section]
      print
      next
    }
    in_legacy && /^[[:space:]]*enabled[[:space:]]*=/ {
      print "enabled = true"
      saw_enabled = 1
      next
    }
    { print }
    END { finish_section() }
  ' "$updated" >"$migrated"
  mv "$migrated" "$CONFIG_FILE"
else
  mv "$updated" "$CONFIG_FILE"
fi

echo "Synced AGENTS.md, hooks, custom skills, and full-context config to $CODEX_HOME_DIR"
if [ "$legacy_lean" -eq 1 ]; then
  echo "Removed the legacy lean catalog and re-enabled its managed plugins"
fi
