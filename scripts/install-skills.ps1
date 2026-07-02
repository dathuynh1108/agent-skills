$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$target = if ($env:TARGET_SKILLS_DIR) { $env:TARGET_SKILLS_DIR } else { Join-Path $codexHome "skills" }
$agentsSkillsDir = if ($env:AGENTS_SKILLS_DIR) { $env:AGENTS_SKILLS_DIR } else { Join-Path $HOME ".agents\skills" }

$publicSkillSources = @(
    "abhigyanpatwari/gitnexus",
    "supabase/agent-skills@supabase-postgres-best-practices",
    "wshobson/agents@database-migration",
    "wshobson/agents@api-design-principles",
    "wshobson/agents@python-code-style",
    "wshobson/agents@python-design-patterns",
    "wshobson/agents@python-project-structure",
    "wshobson/agents@python-testing-patterns",
    "wshobson/agents@python-performance-optimization",
    "wshobson/agents@fastapi-templates",
    "fastapi/fastapi@fastapi",
    "wispbit-ai/skills@sqlalchemy-alembic-expert-best-practices-code-review",
    "https://github.com/Leonxlnx/taste-skill"
)

$publicSkillAllSources = @(
    "https://github.com/samber/cc-skills-golang"
)

# Output skill names copied by the public sources above. Bundle sources such as
# GitNexus, Go, and Taste Skill install many folders from one npx skills add call.
$publicSkillNames = @(
    "api-design-principles",
    "fastapi",
    "fastapi-templates",
    "gitnexus-cli",
    "gitnexus-debugging",
    "gitnexus-exploring",
    "gitnexus-guide",
    "gitnexus-impact-analysis",
    "gitnexus-pdg-query",
    "gitnexus-pr-review",
    "gitnexus-pr-swarm-review",
    "gitnexus-refactoring",
    "gitnexus-taint-analysis",
    "golang-benchmark",
    "golang-cli",
    "golang-code-style",
    "golang-concurrency",
    "golang-context",
    "golang-continuous-integration",
    "golang-data-structures",
    "golang-database",
    "golang-dependency-injection",
    "golang-dependency-management",
    "golang-design-patterns",
    "golang-documentation",
    "golang-error-handling",
    "golang-google-wire",
    "golang-graphql",
    "golang-grpc",
    "golang-how-to",
    "golang-lint",
    "golang-modernize",
    "golang-naming",
    "golang-observability",
    "golang-performance",
    "golang-pkg-go-dev",
    "golang-popular-libraries",
    "golang-project-layout",
    "golang-safety",
    "golang-samber-do",
    "golang-samber-hot",
    "golang-samber-lo",
    "golang-samber-mo",
    "golang-samber-oops",
    "golang-samber-ro",
    "golang-samber-slog",
    "golang-security",
    "golang-spf13-cobra",
    "golang-spf13-viper",
    "golang-stay-updated",
    "golang-stretchr-testify",
    "golang-structs-interfaces",
    "golang-swagger",
    "golang-testing",
    "golang-troubleshooting",
    "golang-uber-dig",
    "golang-uber-fx",
    "python-code-style",
    "python-design-patterns",
    "python-performance-optimization",
    "python-project-structure",
    "python-testing-patterns",
    "supabase-postgres-best-practices",
    "database-migration",
    "sqlalchemy-alembic-expert-best-practices-code-review",
    "brandkit",
    "design-taste-frontend",
    "design-taste-frontend-v1",
    "full-output-enforcement",
    "gpt-taste",
    "high-end-visual-design",
    "image-to-code",
    "imagegen-frontend-mobile",
    "imagegen-frontend-web",
    "industrial-brutalist-ui",
    "minimalist-ui",
    "redesign-existing-projects",
    "stitch-design-taste"
)

New-Item -ItemType Directory -Path $target -Force | Out-Null

$source = Join-Path $root "skills"
Get-ChildItem -Path $source -Directory | ForEach-Object {
    $destination = Join-Path $target $_.Name
    if (Test-Path $destination) {
        Remove-Item -LiteralPath $destination -Recurse -Force
    }
    Copy-Item -LiteralPath $_.FullName -Destination $destination -Recurse
}

Write-Output "Installed skills from $source to $target"

if ($env:SKIP_PUBLIC_SKILLS -eq "1") {
    Write-Output "Skipped public npx skills because SKIP_PUBLIC_SKILLS=1"
} else {
    if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
        throw "npx not found; install Node.js/npm or rerun with `$env:SKIP_PUBLIC_SKILLS='1'"
    }

    foreach ($publicSource in $publicSkillSources) {
        Write-Output "Installing public skills from $publicSource"
        & npx --yes skills add $publicSource -g -y
        if ($LASTEXITCODE -ne 0) {
            throw "npx skills add failed for $publicSource"
        }
    }

    foreach ($publicSource in $publicSkillAllSources) {
        Write-Output "Installing all public skills from $publicSource"
        & npx --yes skills add $publicSource --all -g -y
        if ($LASTEXITCODE -ne 0) {
            throw "npx skills add --all failed for $publicSource"
        }
    }

    foreach ($name in $publicSkillNames) {
        $installedSkill = Join-Path $agentsSkillsDir $name
        $skillMd = Join-Path $installedSkill "SKILL.md"
        if (-not (Test-Path $skillMd)) {
            throw "Missing public skill after install: $skillMd"
        }

        $destination = Join-Path $target $name
        if (Test-Path $destination) {
            Remove-Item -LiteralPath $destination -Recurse -Force
        }
        Copy-Item -LiteralPath $installedSkill -Destination $destination -Recurse
    }

    Write-Output "Installed public npx skills from $agentsSkillsDir to $target"
}

Write-Output "Override with `$env:TARGET_SKILLS_DIR='C:\path\to\skills'; .\scripts\install-skills.ps1"
Write-Output "Set `$env:SKIP_PUBLIC_SKILLS='1' to install only repo-managed custom skills."
