#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

failed=0

for d in skills/*; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  skill="$d/SKILL.md"
  openai="$d/agents/openai.yaml"

  if [ ! -f "$skill" ]; then
    echo "[FAIL] $name missing SKILL.md"
    failed=1
    continue
  fi

  if [ ! -f "$openai" ]; then
    echo "[FAIL] $name missing agents/openai.yaml"
    failed=1
  fi

  first_line="$(head -n 1 "$skill" | tr -d '\r' | sed 's/^\xEF\xBB\xBF//')"
  if [ "$first_line" != "---" ]; then
    echo "[FAIL] $name SKILL.md missing YAML frontmatter opener"
    failed=1
  fi

  if ! grep -Eq "^name: $name"$'\r?'"$" "$skill"; then
    echo "[FAIL] $name SKILL.md name does not match folder"
    failed=1
  fi

  if ! grep -q '^description: ' "$skill"; then
    echo "[FAIL] $name SKILL.md missing description"
    failed=1
  fi

  if [ -f "$openai" ]; then
    if ! grep -q '^interface:' "$openai"; then
      echo "[FAIL] $name openai.yaml missing interface"
      failed=1
    fi
    if ! grep -q 'display_name:' "$openai"; then
      echo "[FAIL] $name openai.yaml missing display_name"
      failed=1
    fi
    if ! grep -q 'short_description:' "$openai"; then
      echo "[FAIL] $name openai.yaml missing short_description"
      failed=1
    fi
    if ! grep -q 'default_prompt:' "$openai"; then
      echo "[FAIL] $name openai.yaml missing default_prompt"
      failed=1
    fi
    if ! grep -Fq "\$$name" "$openai"; then
      echo "[FAIL] $name openai.yaml default_prompt should mention \$$name"
      failed=1
    fi
  fi

  echo "[OK] $name"
done

codex_home="${CODEX_HOME:-$HOME/.codex}"
quick_validate="$codex_home/skills/.system/skill-creator/scripts/quick_validate.py"
if [ -f "$quick_validate" ]; then
  if command -v uv >/dev/null 2>&1; then
    echo ""
    echo "Running Codex quick_validate.py with uv + pyyaml..."
    for d in skills/*; do
      [ -f "$d/SKILL.md" ] || continue
      uv run --with pyyaml python "$quick_validate" "$PWD/$d"
    done
  else
    python_cmd=""
    if command -v python3 >/dev/null 2>&1; then
      python_cmd="python3"
    elif command -v python >/dev/null 2>&1; then
      python_cmd="python"
    fi

    if [ -n "$python_cmd" ] && "$python_cmd" -c "import yaml" >/dev/null 2>&1; then
      echo ""
      echo "Running Codex quick_validate.py..."
      for d in skills/*; do
        [ -f "$d/SKILL.md" ] || continue
        "$python_cmd" "$quick_validate" "$PWD/$d"
      done
    elif [ -n "$python_cmd" ]; then
      echo ""
      echo "Python found but PyYAML is missing; install PyYAML or uv to run optional Codex quick_validate.py."
    else
      echo ""
      echo "Python not found; skipped optional Codex quick_validate.py."
    fi
  fi
else
  echo ""
  echo "Codex quick_validate.py not found at $quick_validate; skipped optional Codex validator."
fi

if [ "$failed" -ne 0 ]; then
  echo "Validation failed."
  exit 1
fi

echo "Validation passed."
