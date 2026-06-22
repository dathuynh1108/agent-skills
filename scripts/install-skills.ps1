$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$target = if ($env:TARGET_SKILLS_DIR) { $env:TARGET_SKILLS_DIR } else { Join-Path $codexHome "skills" }

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
Write-Output "Override with `$env:TARGET_SKILLS_DIR='C:\path\to\skills'; .\scripts\install-skills.ps1"
