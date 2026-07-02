#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
TARGET="${TARGET_SKILLS_DIR:-$CODEX_HOME_DIR/skills}"
AGENTS_SKILLS_DIR="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"

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
