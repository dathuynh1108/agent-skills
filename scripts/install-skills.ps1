$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$target = if ($env:TARGET_SKILLS_DIR) { $env:TARGET_SKILLS_DIR } else { Join-Path $codexHome "skills" }
$agentsSkillsDir = if ($env:AGENTS_SKILLS_DIR) { $env:AGENTS_SKILLS_DIR } else { Join-Path $HOME ".agents\skills" }

$publicSkillSources = @(
    "supabase/agent-skills@supabase-postgres-best-practices",
    "wshobson/agents@database-migration",
    "wispbit-ai/skills@sqlalchemy-alembic-expert-best-practices-code-review",
    "https://github.com/Leonxlnx/taste-skill"
)

$publicSkillNames = @(
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
