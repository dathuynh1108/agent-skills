$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$configFile = Join-Path $codexHome "config.toml"

New-Item -ItemType Directory -Path $codexHome -Force | Out-Null
& (Join-Path $PSScriptRoot "install-skills.ps1")

Copy-Item (Join-Path $root "AGENTS.md") (Join-Path $codexHome "AGENTS.md") -Force
Copy-Item (Join-Path $root "hooks\hooks.json") (Join-Path $codexHome "hooks.json") -Force

$raw = if (Test-Path $configFile) { Get-Content -Raw -LiteralPath $configFile } else { "" }
$hadLegacyLean = $raw -match '(?m)^# BEGIN agent-skills lean skill catalog$'
$raw = [regex]::Replace(
    $raw,
    '(?ms)^# BEGIN agent-skills context defaults\r?\n.*?^# END agent-skills context defaults\r?\n?',
    ''
)
$raw = [regex]::Replace(
    $raw,
    '(?ms)^# BEGIN agent-skills lean skill catalog\r?\n.*?^# END agent-skills lean skill catalog\r?\n?',
    ''
)

$lines = @($raw -split "`r?`n")
$body = New-Object System.Collections.Generic.List[string]
$inRoot = $true
foreach ($line in $lines) {
    if ($inRoot -and $line -match '^\[') {
        $inRoot = $false
    }
    if ($inRoot -and $line -match '^model_context_window\s*=') {
        continue
    }
    $body.Add($line)
}

$rootFragment = (Get-Content -Raw -LiteralPath (Join-Path $root "config\codex-context-root.toml")).TrimEnd()
$bodyText = ($body -join "`n").TrimStart("`r", "`n")
$output = "$rootFragment`n`n$bodyText".TrimEnd()

if ($hadLegacyLean) {
    $legacyPlugins = [System.Collections.Generic.HashSet[string]]::new()
    Get-Content -LiteralPath (Join-Path $root "config\codex-legacy-lean-plugins.txt") | ForEach-Object {
        $value = $_.Trim()
        if ($value -and -not $value.StartsWith("#")) {
            [void]$legacyPlugins.Add($value)
        }
    }

    $migrated = New-Object System.Collections.Generic.List[string]
    $inLegacyPlugin = $false
    $sawEnabled = $false
    foreach ($line in @($output -split "`r?`n")) {
        if ($line -match '^\[') {
            if ($inLegacyPlugin -and -not $sawEnabled) {
                $migrated.Add("enabled = true")
            }
            $inLegacyPlugin = $false
            $sawEnabled = $false
            if ($line -match '^\[plugins\."([^"]+)"\]$') {
                $inLegacyPlugin = $legacyPlugins.Contains($Matches[1])
            }
            $migrated.Add($line)
            continue
        }
        if ($inLegacyPlugin -and $line -match '^\s*enabled\s*=') {
            $migrated.Add("enabled = true")
            $sawEnabled = $true
            continue
        }
        $migrated.Add($line)
    }
    if ($inLegacyPlugin -and -not $sawEnabled) {
        $migrated.Add("enabled = true")
    }
    $output = ($migrated -join "`n").TrimEnd()
}

[System.IO.File]::WriteAllText($configFile, "$output`n", [System.Text.UTF8Encoding]::new($false))

Write-Output "Synced AGENTS.md, hooks, custom skills, and full-context config to $codexHome"
if ($hadLegacyLean) {
    Write-Output "Removed the legacy lean catalog and re-enabled its managed plugins"
}
