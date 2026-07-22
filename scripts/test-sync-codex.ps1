$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("agent-skills-sync-test-" + [guid]::NewGuid())
$codexHome = Join-Path $tempRoot ".codex"
$environmentNames = @(
    "CODEX_HOME",
    "TARGET_SKILLS_DIR",
    "AGENTS_SKILLS_DIR",
    "SKIP_PLUGIN_CHECKS",
    "SKIP_PUBLIC_SKILLS"
)
$originalEnvironment = @{}
foreach ($name in $environmentNames) {
    $originalEnvironment[$name] = [Environment]::GetEnvironmentVariable($name, "Process")
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

function Get-PluginEnabled {
    param(
        [string]$Config,
        [string]$Plugin
    )
    $inSection = $false
    foreach ($line in $Config -split "`r?`n") {
        if ($line -eq "[plugins.`"$Plugin`"]") {
            $inSection = $true
            continue
        }
        if ($line -match '^\[') {
            $inSection = $false
        }
        if ($inSection -and $line -match '^enabled\s*=\s*(true|false)$') {
            return $Matches[1]
        }
    }
    return $null
}

try {
    New-Item -ItemType Directory -Path $codexHome -Force | Out-Null
    $configFile = Join-Path $codexHome "config.toml"
    @'
# BEGIN agent-skills context defaults
model_reasoning_effort = "high"
tool_output_token_limit = 6000
model_auto_compact_token_limit_scope = "body_after_prefix"
# END agent-skills context defaults

model = "test-model"
model_context_window = 128000

[profiles.deep]
model_reasoning_effort = "xhigh"

[plugins."example@openai-curated"]
enabled = false

[plugins."browser@openai-bundled"]
enabled = false

# BEGIN agent-skills lean skill catalog
[[skills.config]]
name = "golang-cli"
enabled = false
# END agent-skills lean skill catalog
'@ | Set-Content -LiteralPath $configFile -Encoding utf8

    $env:CODEX_HOME = $codexHome
    $env:TARGET_SKILLS_DIR = Join-Path $codexHome "skills"
    $env:AGENTS_SKILLS_DIR = Join-Path $tempRoot ".agents\skills"
    $env:SKIP_PLUGIN_CHECKS = "1"
    $env:SKIP_PUBLIC_SKILLS = "1"

    & (Join-Path $PSScriptRoot "sync-codex.ps1") | Out-Null

    Assert-Test -Condition ((Get-FileHash (Join-Path $root "AGENTS.md")).Hash -eq (Get-FileHash (Join-Path $codexHome "AGENTS.md")).Hash) `
        -Message "Expected AGENTS.md to be synced"
    Assert-Test -Condition ((Get-FileHash (Join-Path $root "hooks\hooks.json")).Hash -eq (Get-FileHash (Join-Path $codexHome "hooks.json")).Hash) `
        -Message "Expected hooks.json to be synced"
    Assert-Test -Condition (Test-Path (Join-Path $codexHome "skills\context-budget\SKILL.md")) `
        -Message "Expected context-budget skill to be synced"

    $firstConfig = Get-Content -Raw -LiteralPath $configFile
    Assert-Test -Condition $firstConfig.Contains('model = "test-model"') -Message "Expected existing model config to survive"
    Assert-Test -Condition $firstConfig.Contains('model_context_window = 272000') -Message "Expected maximum context window"
    Assert-Test -Condition $firstConfig.Contains('model_reasoning_effort = "xhigh"') -Message "Expected profile config to survive"
    Assert-Test -Condition (-not $firstConfig.Contains('tool_output_token_limit')) -Message "Expected retired tool limit to be removed"
    Assert-Test -Condition (-not $firstConfig.Contains('model_auto_compact_token_limit_scope')) -Message "Expected retired compaction override to be removed"
    Assert-Test -Condition (-not $firstConfig.Contains('# BEGIN agent-skills lean skill catalog')) -Message "Expected lean catalog removal"
    Assert-Test -Condition ((Get-PluginEnabled -Config $firstConfig -Plugin "browser@openai-bundled") -eq "true") `
        -Message "Expected legacy lean plugin to be re-enabled"
    Assert-Test -Condition ((Get-PluginEnabled -Config $firstConfig -Plugin "example@openai-curated") -eq "false") `
        -Message "Expected unrelated plugin state to survive"

    & (Join-Path $PSScriptRoot "sync-codex.ps1") | Out-Null
    $secondConfig = Get-Content -Raw -LiteralPath $configFile
    Assert-Test -Condition ($firstConfig -eq $secondConfig) -Message "Expected PowerShell sync to be idempotent"

    Write-Output "PowerShell Codex sync tests passed"
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
