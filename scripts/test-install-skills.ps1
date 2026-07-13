$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("agent-skills-install-test-" + [guid]::NewGuid())
$agentsSkillsDir = Join-Path $tempRoot ".agents\skills"
$targetSkillsDir = Join-Path $tempRoot ".codex\skills"
$binDir = Join-Path $tempRoot "bin"
$environmentNames = @(
    "PATH",
    "CODEX_HOME",
    "TARGET_SKILLS_DIR",
    "AGENTS_SKILLS_DIR",
    "SKIP_PLUGIN_CHECKS",
    "SKIP_PUBLIC_SKILLS",
    "PUBLIC_SKILLS_AGENT",
    "NPX_CALL_LOG"
)
$originalEnvironment = @{}
foreach ($name in $environmentNames) {
    $originalEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, "Process")
}

function Write-TestSkill {
    param(
        [string]$SkillsRoot,
        [string]$Name,
        [string]$Marker
    )

    $skillDir = Join-Path $SkillsRoot $Name
    $referencesDir = Join-Path $skillDir "references"
    New-Item -ItemType Directory -Path $referencesDir -Force | Out-Null
    @("---", "name: $Name", "description: test fixture", "---", "", $Marker) |
        Set-Content -LiteralPath (Join-Path $skillDir "SKILL.md") -Encoding utf8
    "$Marker reference" |
        Set-Content -LiteralPath (Join-Path $referencesDir "details.md") -Encoding utf8
}

function Assert-Test {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }
}

try {
    New-Item -ItemType Directory -Path $agentsSkillsDir, $targetSkillsDir, $binDir -Force | Out-Null

    $inPublicSkillNames = $false
    foreach ($line in Get-Content -LiteralPath (Join-Path $PSScriptRoot "install-skills.ps1")) {
        if ($line -match '^\$publicSkillNames\s*=\s*@\($') {
            $inPublicSkillNames = $true
            continue
        }
        if ($inPublicSkillNames -and $line -eq ')') {
            break
        }
        if ($inPublicSkillNames -and $line -match '^\s+"([^"]+)",?$') {
            Write-TestSkill -SkillsRoot $agentsSkillsDir -Name $Matches[1] -Marker "public copy"
        }
    }

    Write-TestSkill -SkillsRoot $targetSkillsDir -Name "redis-core" -Marker "custom override"
    Write-TestSkill -SkillsRoot $targetSkillsDir -Name "local-only" -Marker "local only"

    if ($PSVersionTable.Platform -eq "Unix") {
        $npxPath = Join-Path $binDir "npx"
        @(
            '#!/usr/bin/env sh',
            'if [ -n "$NPX_CALL_LOG" ]; then printf "%s\n" "$*" >>"$NPX_CALL_LOG"; fi',
            'exit 0'
        ) | Set-Content -LiteralPath $npxPath -Encoding ascii
        & chmod +x $npxPath
    } else {
        $npxPath = Join-Path $binDir "npx.cmd"
        @(
            '@echo off',
            'if not "%NPX_CALL_LOG%"=="" echo %*>>"%NPX_CALL_LOG%"',
            'exit /b 0'
        ) | Set-Content -LiteralPath $npxPath -Encoding ascii
    }

    $env:PATH = "$binDir$([System.IO.Path]::PathSeparator)$($originalEnvironment['PATH'])"
    $env:CODEX_HOME = Join-Path $tempRoot ".codex"
    $env:TARGET_SKILLS_DIR = $targetSkillsDir
    $env:AGENTS_SKILLS_DIR = $agentsSkillsDir
    $env:SKIP_PLUGIN_CHECKS = "1"
    $env:SKIP_PUBLIC_SKILLS = $null
    $env:NPX_CALL_LOG = Join-Path $tempRoot "npx.log"

    & (Join-Path $PSScriptRoot "install-skills.ps1") | Out-Null

    Assert-Test -Condition (-not (Test-Path (Join-Path $targetSkillsDir "find-skills"))) `
        -Message "Expected public skill to remain outside the Codex custom target: find-skills"
    Assert-Test -Condition (Test-Path (Join-Path $agentsSkillsDir "find-skills\SKILL.md")) `
        -Message "Expected canonical public skill to remain in the universal agents root"
    Assert-Test -Condition ((Get-Content -Raw -LiteralPath (Join-Path $targetSkillsDir "redis-core\SKILL.md")).Contains("custom override")) `
        -Message "Expected divergent local override to be preserved: redis-core"
    Assert-Test -Condition (Test-Path (Join-Path $targetSkillsDir "local-only\SKILL.md")) `
        -Message "Expected unrelated local skill to be preserved: local-only"
    Assert-Test -Condition (Test-Path (Join-Path $targetSkillsDir "commit-rules\SKILL.md")) `
        -Message "Expected repo-managed custom skills to be installed"
    Assert-Test -Condition ((Test-Path $env:NPX_CALL_LOG) -and ((Get-Item $env:NPX_CALL_LOG).Length -gt 0)) `
        -Message "Expected normal mode to invoke npx"
    $npxCalls = @(Get-Content -LiteralPath $env:NPX_CALL_LOG)
    Assert-Test -Condition (-not (($npxCalls | Where-Object { $_ -match '(^| )--all( |$)' }))) `
        -Message "Expected installer not to use --all because it targets every agent"
    Assert-Test -Condition (($npxCalls | Where-Object { $_ -notmatch '(^| )--agent codex( |$)' }).Count -eq 0) `
        -Message "Expected every npx install call to target the Codex agent"

    $skipTarget = Join-Path $tempRoot ".codex-skip\skills"
    New-Item -ItemType Directory -Path $skipTarget -Force | Out-Null
    Write-TestSkill -SkillsRoot $skipTarget -Name "find-skills" -Marker "legacy mirror"

    $env:CODEX_HOME = Join-Path $tempRoot ".codex-skip"
    $env:TARGET_SKILLS_DIR = $skipTarget
    $env:SKIP_PUBLIC_SKILLS = "1"
    $env:PUBLIC_SKILLS_AGENT = $null
    $env:NPX_CALL_LOG = Join-Path $tempRoot "npx-skip.log"

    & (Join-Path $PSScriptRoot "install-skills.ps1") | Out-Null

    Assert-Test -Condition (-not (Test-Path $env:NPX_CALL_LOG)) `
        -Message "Expected skip mode not to invoke npx"
    Assert-Test -Condition ((Get-Content -Raw -LiteralPath (Join-Path $skipTarget "find-skills\SKILL.md")).Contains("legacy mirror")) `
        -Message "Expected skip mode not to mutate existing public mirrors"

    Write-Output "PowerShell installer public-skill isolation tests passed"
} finally {
    foreach ($name in $environmentNames) {
        $value = $originalEnvironment[$name]
        if ($null -eq $value) {
            Remove-Item -Path "Env:$name" -ErrorAction SilentlyContinue
        } else {
            Set-Item -Path "Env:$name" -Value $value
        }
    }
    Remove-Item -LiteralPath $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
}
