$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$skillsRoot = Join-Path $root "skills"
$failed = $false

Get-ChildItem -Path $skillsRoot -Directory | Sort-Object Name | ForEach-Object {
    $name = $_.Name
    $skill = Join-Path $_.FullName "SKILL.md"
    $openai = Join-Path $_.FullName "agents\openai.yaml"

    if (-not (Test-Path $skill)) {
        Write-Output "[FAIL] $name missing SKILL.md"
        $script:failed = $true
        return
    }

    if (-not (Test-Path $openai)) {
        Write-Output "[FAIL] $name missing agents/openai.yaml"
        $script:failed = $true
    }

    $raw = Get-Content -Raw -LiteralPath $skill
    $firstLine = (($raw -split "`r?`n", 2)[0]).TrimStart([char]0xFEFF)
    if ($firstLine -ne "---") {
        Write-Output "[FAIL] $name SKILL.md missing YAML frontmatter opener"
        $script:failed = $true
    }

    if ($raw -notmatch "(?m)^name:\s+$([regex]::Escape($name))\s*$") {
        Write-Output "[FAIL] $name SKILL.md name does not match folder"
        $script:failed = $true
    }

    if ($raw -notmatch "(?m)^description:\s+") {
        Write-Output "[FAIL] $name SKILL.md missing description"
        $script:failed = $true
    }

    if (Test-Path $openai) {
        $openaiRaw = Get-Content -Raw -LiteralPath $openai
        foreach ($field in @("interface:", "display_name:", "short_description:", "default_prompt:")) {
            if ($openaiRaw -notmatch "(?m)^\s*$([regex]::Escape($field))") {
                Write-Output "[FAIL] $name openai.yaml missing $field"
                $script:failed = $true
            }
        }

        if (-not $openaiRaw.Contains("`$$name")) {
            Write-Output "[FAIL] $name openai.yaml default_prompt should mention `$$name"
            $script:failed = $true
        }
    }

    Write-Output "[OK] $name"
}

$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
}

$codexHome = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $HOME ".codex" }
$quickValidate = Join-Path $codexHome "skills\.system\skill-creator\scripts\quick_validate.py"
if ((Test-Path $quickValidate) -and $python) {
    Write-Output ""
    Write-Output "Running Codex quick_validate.py..."
    Get-ChildItem -Path $skillsRoot -Directory | Sort-Object Name | ForEach-Object {
        $skill = Join-Path $_.FullName "SKILL.md"
        if (Test-Path $skill) {
            & $python.Source $quickValidate $_.FullName
            if ($LASTEXITCODE -ne 0) {
                $script:failed = $true
            }
        }
    }
} elseif (-not (Test-Path $quickValidate)) {
    Write-Output ""
    Write-Output "Codex quick_validate.py not found at $quickValidate; skipped optional Codex validator."
} else {
    Write-Output ""
    Write-Output "Python not found; skipped optional Codex quick_validate.py."
}

if ($failed) {
    Write-Output "Validation failed."
    exit 1
}

Write-Output "Validation passed."
