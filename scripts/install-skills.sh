#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET="${TARGET_SKILLS_DIR:-$CODEX_HOME_DIR/skills}"
AGENTS_SKILLS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"

REQUIRED_CODEX_PLUGINS=(
  "codex-security"
)

REQUIRED_CODEX_PLUGIN_SKILLS=(
  "codex-security:attack-path-analysis"
  "codex-security:deep-security-scan"
  "codex-security:finding-discovery"
  "codex-security:fix-finding"
  "codex-security:security-diff-scan"
  "codex-security:security-scan"
  "codex-security:threat-model"
  "codex-security:track-findings"
  "codex-security:triage-finding"
  "codex-security:validation"
)

PUBLIC_SKILL_SOURCES=(
  "abhigyanpatwari/gitnexus"
  "supabase/agent-skills@supabase-postgres-best-practices"
  "wshobson/agents@database-migration"
  "wshobson/agents@api-design-principles"
  "wshobson/agents@python-code-style"
  "wshobson/agents@python-design-patterns"
  "wshobson/agents@python-project-structure"
  "wshobson/agents@python-testing-patterns"
  "wshobson/agents@python-performance-optimization"
  "wshobson/agents@fastapi-templates"
  "fastapi/fastapi@fastapi"
  "wispbit-ai/skills@sqlalchemy-alembic-expert-best-practices-code-review"
  "https://github.com/Leonxlnx/taste-skill"
)

PUBLIC_SKILL_ALL_SOURCES=(
  "https://github.com/samber/cc-skills-golang"
)

# Output skill names copied by the public sources above. Bundle sources such as
# GitNexus, Go, and Taste Skill install many folders from one `npx skills add` call.
PUBLIC_SKILL_NAMES=(
  "api-design-principles"
  "fastapi"
  "fastapi-templates"
  "gitnexus-cli"
  "gitnexus-debugging"
  "gitnexus-exploring"
  "gitnexus-guide"
  "gitnexus-impact-analysis"
  "gitnexus-pdg-query"
  "gitnexus-pr-review"
  "gitnexus-pr-swarm-review"
  "gitnexus-refactoring"
  "gitnexus-taint-analysis"
  "golang-benchmark"
  "golang-cli"
  "golang-code-style"
  "golang-concurrency"
  "golang-context"
  "golang-continuous-integration"
  "golang-data-structures"
  "golang-database"
  "golang-dependency-injection"
  "golang-dependency-management"
  "golang-design-patterns"
  "golang-documentation"
  "golang-error-handling"
  "golang-google-wire"
  "golang-graphql"
  "golang-grpc"
  "golang-how-to"
  "golang-lint"
  "golang-modernize"
  "golang-naming"
  "golang-observability"
  "golang-performance"
  "golang-pkg-go-dev"
  "golang-popular-libraries"
  "golang-project-layout"
  "golang-safety"
  "golang-samber-do"
  "golang-samber-hot"
  "golang-samber-lo"
  "golang-samber-mo"
  "golang-samber-oops"
  "golang-samber-ro"
  "golang-samber-slog"
  "golang-security"
  "golang-spf13-cobra"
  "golang-spf13-viper"
  "golang-stay-updated"
  "golang-stretchr-testify"
  "golang-structs-interfaces"
  "golang-swagger"
  "golang-testing"
  "golang-troubleshooting"
  "golang-uber-dig"
  "golang-uber-fx"
  "python-code-style"
  "python-design-patterns"
  "python-performance-optimization"
  "python-project-structure"
  "python-testing-patterns"
  "supabase-postgres-best-practices"
  "database-migration"
  "sqlalchemy-alembic-expert-best-practices-code-review"
  "brandkit"
  "design-taste-frontend"
  "design-taste-frontend-v1"
  "full-output-enforcement"
  "gpt-taste"
  "high-end-visual-design"
  "image-to-code"
  "imagegen-frontend-mobile"
  "imagegen-frontend-web"
  "industrial-brutalist-ui"
  "minimalist-ui"
  "redesign-existing-projects"
  "stitch-design-taste"
)

mkdir -p "$TARGET"

is_plugin_enabled() {
  local plugin="$1"
  local config="$CODEX_HOME_DIR/config.toml"
  local section="[plugins.\"$plugin@openai-curated\"]"

  [ -f "$config" ] || return 1
  awk -v section="$section" '
    $0 == section { in_section = 1; next }
    /^\[/ { in_section = 0 }
    in_section && $1 == "enabled" && $3 == "true" { found = 1 }
    END { exit(found ? 0 : 1) }
  ' "$config"
}

has_plugin_skill() {
  local plugin="$1"
  local skill="$2"
  local root

  for root in \
    "$CODEX_HOME_DIR/plugins/cache/openai-curated-remote/$plugin"/* \
    "$CODEX_HOME_DIR/plugins/cache/openai-curated/$plugin"/* \
    "$CODEX_HOME_DIR/plugins/cache/openai-curated-remote/$plugin" \
    "$CODEX_HOME_DIR/plugins/cache/openai-curated/$plugin"; do
    if [ -f "$root/skills/$skill/SKILL.md" ]; then
      return 0
    fi
  done

  return 1
}

if [ "${SKIP_PLUGIN_CHECKS:-0}" = "1" ]; then
  echo "Skipped Codex plugin checks because SKIP_PLUGIN_CHECKS=1"
else
  missing_plugin=0
  for plugin in "${REQUIRED_CODEX_PLUGINS[@]}"; do
    if [ -d "$CODEX_HOME_DIR/plugins/cache/openai-curated-remote/$plugin" ] || [ -d "$CODEX_HOME_DIR/plugins/cache/openai-curated/$plugin" ]; then
      :
    else
      echo "Missing Codex plugin cache: $plugin" >&2
      missing_plugin=1
    fi

    if is_plugin_enabled "$plugin"; then
      echo "Verified Codex plugin enabled: $plugin@openai-curated"
    else
      echo "Missing or disabled Codex plugin config: $plugin@openai-curated" >&2
      missing_plugin=1
    fi
  done

  for entry in "${REQUIRED_CODEX_PLUGIN_SKILLS[@]}"; do
    plugin="${entry%%:*}"
    skill="${entry#*:}"
    if has_plugin_skill "$plugin" "$skill"; then
      echo "Verified Codex plugin skill: $plugin:$skill"
    else
      echo "Missing Codex plugin skill: $plugin:$skill" >&2
      missing_plugin=1
    fi
  done

  if [ "$missing_plugin" -ne 0 ]; then
    echo "Install or enable required Codex plugins in Codex, then rerun. These are plugin-managed, not npx skills." >&2
    exit 1
  fi
fi

if command -v rsync >/dev/null 2>&1; then
  rsync -a "$ROOT/skills/" "$TARGET/"
else
  cp -R "$ROOT/skills/." "$TARGET/"
fi

echo "Installed skills from $ROOT/skills to $TARGET"

if [ "${SKIP_PUBLIC_SKILLS:-0}" = "1" ]; then
  echo "Skipped public npx skills because SKIP_PUBLIC_SKILLS=1"
else
  if ! command -v npx >/dev/null 2>&1; then
    echo "npx not found; install Node.js/npm or rerun with SKIP_PUBLIC_SKILLS=1" >&2
    exit 1
  fi

  for source in "${PUBLIC_SKILL_SOURCES[@]}"; do
    echo "Installing public skills from $source"
    npx --yes skills add "$source" -g -y
  done

  for source in "${PUBLIC_SKILL_ALL_SOURCES[@]}"; do
    echo "Installing all public skills from $source"
    npx --yes skills add "$source" --all -g -y
  done

  missing=0
  for name in "${PUBLIC_SKILL_NAMES[@]}"; do
    source_dir="$AGENTS_SKILLS_DIR/$name"
    destination="$TARGET/$name"

    if [ ! -f "$source_dir/SKILL.md" ]; then
      echo "Missing public skill after install: $source_dir/SKILL.md" >&2
      missing=1
      continue
    fi

    if command -v rsync >/dev/null 2>&1; then
      rsync -a --delete "$source_dir/" "$destination/"
    else
      rm -rf "$destination"
      cp -R "$source_dir" "$destination"
    fi
  done

  if [ "$missing" -ne 0 ]; then
    exit 1
  fi

  echo "Installed public npx skills from $AGENTS_SKILLS_DIR to $TARGET"
fi

echo "Override with TARGET_SKILLS_DIR=/path/to/skills bash scripts/install-skills.sh"
echo "Set SKIP_PUBLIC_SKILLS=1 to install only repo-managed custom skills."
