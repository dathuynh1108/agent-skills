$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$target = if ($env:TARGET_SKILLS_DIR) { $env:TARGET_SKILLS_DIR } else { Join-Path $codexHome "skills" }
$agentsSkillsDir = if ($env:AGENTS_SKILLS_DIR) { $env:AGENTS_SKILLS_DIR } else { Join-Path $HOME ".agents\skills" }

$requiredCodexPlugins = @(
    "codex-security"
)

$requiredCodexPluginSkills = @(
    "codex-security:attack-path-analysis",
    "codex-security:deep-security-scan",
    "codex-security:finding-discovery",
    "codex-security:fix-finding",
    "codex-security:security-diff-scan",
    "codex-security:security-scan",
    "codex-security:threat-model",
    "codex-security:track-findings",
    "codex-security:triage-finding",
    "codex-security:validation"
)

$publicSkillSources = @(
    "abhigyanpatwari/gitnexus",
    "vercel-labs/skills@find-skills",
    "vercel-labs/agent-skills@vercel-composition-patterns",
    "jeffallan/claude-skills@kubernetes-specialist",
    "jeffallan/claude-skills@websocket-engineer",
    "redis/agent-skills@redis-core",
    "redis/agent-skills@redis-connections",
    "redis/agent-skills@redis-observability",
    "redis/agent-skills@redis-clustering",
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
    "https://github.com/addyosmani/web-quality-skills",
    "https://github.com/samber/cc-skills-golang"
)

# Output skill names installed by the public sources above. Bundle sources such as
# GitNexus, Go, and Taste Skill install many folders from one npx skills add call.
$publicSkillNames = @(
    "accessibility",
    "api-design-principles",
    "best-practices",
    "core-web-vitals",
    "fastapi",
    "fastapi-templates",
    "find-skills",
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
    "kubernetes-specialist",
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
    "golang-gopls",
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
    "golang-refactoring",
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
    "performance",
    "redis-clustering",
    "redis-connections",
    "redis-core",
    "redis-observability",
    "seo",
    "supabase-postgres-best-practices",
    "database-migration",
    "sqlalchemy-alembic-expert-best-practices-code-review",
    "vercel-composition-patterns",
    "web-quality-audit",
    "websocket-engineer",
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

function Test-CodexPluginEnabled {
    param([string]$Name)

    $config = Join-Path $codexHome "config.toml"
    if (-not (Test-Path $config)) {
        return $false
    }

    $section = "[plugins.`"$Name@openai-curated`"]"
    $inSection = $false
    foreach ($line in Get-Content -LiteralPath $config) {
        if ($line -eq $section) {
            $inSection = $true
            continue
        }

        if ($line -match '^\[') {
            $inSection = $false
        }

        if ($inSection -and $line -match '^\s*enabled\s*=\s*true\s*$') {
            return $true
        }
    }

    return $false
}

function Test-CodexPluginSkill {
    param(
        [string]$Name,
        [string]$Skill
    )

    $roots = @(
        (Join-Path $codexHome "plugins\cache\openai-curated-remote\$Name"),
        (Join-Path $codexHome "plugins\cache\openai-curated\$Name")
    )

    foreach ($root in $roots) {
        if (Test-Path (Join-Path $root "skills\$Skill\SKILL.md")) {
            return $true
        }

        if (Test-Path $root) {
            foreach ($versionDir in Get-ChildItem -Path $root -Directory) {
                if (Test-Path (Join-Path $versionDir.FullName "skills\$Skill\SKILL.md")) {
                    return $true
                }
            }
        }
    }

    return $false
}

New-Item -ItemType Directory -Path $target -Force | Out-Null

if ($env:SKIP_PLUGIN_CHECKS -eq "1") {
    Write-Output "Skipped Codex plugin checks because SKIP_PLUGIN_CHECKS=1"
} else {
    $missingPlugin = $false
    foreach ($plugin in $requiredCodexPlugins) {
        $remoteCache = Join-Path $codexHome "plugins\cache\openai-curated-remote\$plugin"
        $curatedCache = Join-Path $codexHome "plugins\cache\openai-curated\$plugin"
        if (-not ((Test-Path $remoteCache) -or (Test-Path $curatedCache))) {
            Write-Warning "Missing Codex plugin cache: $plugin"
            $missingPlugin = $true
        }

        if (Test-CodexPluginEnabled -Name $plugin) {
            Write-Output "Verified Codex plugin enabled: $plugin@openai-curated"
        } else {
            Write-Warning "Missing or disabled Codex plugin config: $plugin@openai-curated"
            $missingPlugin = $true
        }
    }

    foreach ($entry in $requiredCodexPluginSkills) {
        $parts = $entry -split ":", 2
        $plugin = $parts[0]
        $skill = $parts[1]
        if (Test-CodexPluginSkill -Name $plugin -Skill $skill) {
            Write-Output "Verified Codex plugin skill: ${plugin}:${skill}"
        } else {
            Write-Warning "Missing Codex plugin skill: ${plugin}:${skill}"
            $missingPlugin = $true
        }
    }

    if ($missingPlugin) {
        throw "Install or enable required Codex plugins in Codex, then rerun. These are plugin-managed, not npx skills."
    }
}

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
    }

    Write-Output "Verified public npx skills in $agentsSkillsDir"
    Write-Output "Codex discovers the universal agents skill root directly; public skills were not copied to $target"
}

Write-Output "Override with `$env:TARGET_SKILLS_DIR='C:\path\to\skills'; .\scripts\install-skills.ps1"
Write-Output "Set `$env:SKIP_PUBLIC_SKILLS='1' to install only repo-managed custom skills."
