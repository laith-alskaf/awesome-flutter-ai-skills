# Universal Flutter AI Agent Skills — Multi-Agent & IDE Deployment Script
# Deploys 44 skills + _resources across ALL AI Agents & IDEs (Antigravity, Gemini, Claude, OpenAI Codex, Cursor, Windsurf, Roo Code, Copilot)
# Usage: .\deploy.ps1
# One-Line Remote Usage: irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/deploy.ps1 | iex

$ErrorActionPreference = "Stop"

# Determine execution path (works locally or via remote IEX stream)
$scriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($scriptDir)) {
    $scriptDir = Get-Location
}

$sourceBase = Join-Path $scriptDir "skills"
$rootDir = $scriptDir

# If skills directory is missing locally (e.g. one-line IEX execution), clone temporary repo
$tempCloned = $false
if (-not (Test-Path $sourceBase)) {
    Write-Host "[*] Fetching latest awesome-flutter-ai-skills framework from GitHub..." -ForegroundColor Cyan
    $tempDir = Join-Path $env:TEMP "awesome-flutter-ai-skills-temp"
    if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }
    git clone --depth 1 https://github.com/laith-alskaf/awesome-flutter-ai-skills.git $tempDir | Out-Null
    $rootDir = $tempDir
    $sourceBase = Join-Path $tempDir "skills"
    $tempCloned = $true
}

# 1. Target Global AI Agent Paths across Windows, macOS, Linux (Gemini, Antigravity, Claude, Codex, Cursor, Windsurf)
$targetBases = @(
    (Join-Path $env:USERPROFILE ".gemini\antigravity\skills"),
    (Join-Path $env:USERPROFILE ".gemini\config\skills"),
    (Join-Path $env:USERPROFILE ".agents\skills"),
    (Join-Path $env:USERPROFILE ".codex\skills"),
    (Join-Path $env:USERPROFILE ".cursor\skills"),
    (Join-Path $env:USERPROFILE ".windsurf\skills")
)

# Find all SKILL.md files and deploy their parent directories
$skillDirs = Get-ChildItem -Path $sourceBase -Filter "SKILL.md" -Recurse |
    Select-Object -ExpandProperty DirectoryName |
    Sort-Object -Unique

# Official set of valid skill names for self-cleaning purge
$validSkillNames = @("_resources")
foreach ($dir in $skillDirs) {
    $validSkillNames += (Split-Path $dir -Leaf)
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Universal AI Agent & IDE Skill Deployment 2026" -ForegroundColor Cyan
Write-Host " Total Valid Skills Found: $($skillDirs.Count)" -ForegroundColor Cyan
Write-Host " Target AI Agent Environments: $($targetBases.Count)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$totalDeployed = 0
$totalPurged = 0
$resourceFolders = @("templates", "checklists", "anti-patterns", "decisions")

# Step 1: Deploy Global Skills & _resources to All AI Agent Paths
foreach ($destBase in $targetBases) {
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "[*] Target Path: $destBase" -ForegroundColor Yellow

    if (-not (Test-Path $destBase)) {
        New-Item -ItemType Directory -Path $destBase -Force | Out-Null
        Write-Host "    [+] Created directory: $destBase" -ForegroundColor Green
    }

    # Purge deprecated or ghost skill directories
    Get-ChildItem -Path $destBase -Directory | ForEach-Object {
        if ($_.Name -notin $validSkillNames) {
            Remove-Item -Path $_.FullName -Recurse -Force
            Write-Host "    [PURGE] Removed deprecated ghost skill: $($_.Name)" -ForegroundColor Magenta
            $totalPurged++
        }
    }

    # Copy clean valid skills
    $deployedForPath = 0
    foreach ($skillDir in $skillDirs) {
        $skillName = Split-Path $skillDir -Leaf
        $destDir = Join-Path $destBase $skillName

        if (Test-Path $destDir) { Remove-Item -Path $destDir -Recurse -Force }
        Copy-Item -Path $skillDir -Destination $destDir -Recurse -Force
        $deployedForPath++
    }

    # Bundle supporting framework resources (_resources/)
    $destResources = Join-Path $destBase "_resources"
    if (Test-Path $destResources) { Remove-Item -Path $destResources -Recurse -Force }
    New-Item -ItemType Directory -Path $destResources -Force | Out-Null

    foreach ($resFolder in $resourceFolders) {
        $srcRes = Join-Path $rootDir $resFolder
        if (Test-Path $srcRes) {
            $destResFolder = Join-Path $destResources $resFolder
            Copy-Item -Path $srcRes -Destination $destResFolder -Recurse -Force
        }
    }
    Write-Host "    [+] Synced _resources (templates, checklists, anti-patterns, decisions)" -ForegroundColor Cyan
    Write-Host "    [OK] Successfully deployed $deployedForPath skills to $destBase" -ForegroundColor Green
    $totalDeployed += $deployedForPath
}

# Step 2: Inject Local IDE & Cloud Agent Rules in Current Directory
Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "[*] Injecting Local IDE & Cloud Agent Rules (Cursor, Windsurf, Roo, Codex, Copilot)..." -ForegroundColor Yellow

$currentDir = Get-Location

# Cursor Rules (.cursorrules)
$cursorRules = @"
# Cursor Rules — Flutter AI Agent Skill Framework 2026
- Flutter 3.44.x Stable & Dart 3.12.x Sound Null Safety
- Clean Architecture with Feature-First structure
- Impeller rendering engine & Material 3 (useMaterial3: true)
- Pluggable State Management: Riverpod 3.x (@riverpod), Bloc 9.x, Cubit, GetX 5.x
- Zero dynamic types & zero raw unhandled exceptions
- Mandatory const constructors & immutable domain entities
"@
Set-Content -Path (Join-Path $currentDir ".cursorrules") -Value $cursorRules -Force
Write-Host "    [+] Created .cursorrules in current path" -ForegroundColor Green

# Windsurf Rules (.windsurfrules)
$windsurfRules = @"
# Windsurf Cascade Rules — Flutter AI Agent Skill Framework 2026
- Enforce Clean Architecture: Presentation -> Domain -> Data
- Target: Flutter 3.44.x Stable, Dart 3.12.x, Material 3, Impeller Engine
- Sealed classes & pattern matching for async states (AsyncValue / BlocState)
- Never mix business logic in UI widgets
"@
Set-Content -Path (Join-Path $currentDir ".windsurfrules") -Value $windsurfRules -Force
Write-Host "    [+] Created .windsurfrules in current path" -ForegroundColor Green

# Roo Code / Cline Rules (.clinerules)
$clineRules = @"
# Roo Code & Cline Rules — Flutter AI Agent Skill Framework 2026
- Flutter 3.44.x Stable + Dart 3.12.x Sound Null Safety
- Clean Architecture (Feature-First)
- Use const constructors everywhere possible
- State Management: Riverpod 3.x / Bloc 9.x / Cubit / GetX 5.x
"@
Set-Content -Path (Join-Path $currentDir ".clinerules") -Value $clineRules -Force
Write-Host "    [+] Created .clinerules in current path" -ForegroundColor Green

# OpenAI Codex Cloud Agent Instructions (.codex/instructions.md)
$codexPath = Join-Path $currentDir ".codex"
if (-not (Test-Path $codexPath)) { New-Item -ItemType Directory -Path $codexPath -Force | Out-Null }
Set-Content -Path (Join-Path $codexPath "instructions.md") -Value $cursorRules -Force
Write-Host "    [+] Created .codex/instructions.md for Cloud Codex Agents" -ForegroundColor Green

# GitHub Copilot Instructions (.github/copilot-instructions.md)
$githubPath = Join-Path $currentDir ".github"
if (-not (Test-Path $githubPath)) { New-Item -ItemType Directory -Path $githubPath -Force | Out-Null }
Set-Content -Path (Join-Path $githubPath "copilot-instructions.md") -Value $cursorRules -Force
Write-Host "    [+] Created .github/copilot-instructions.md for Copilot & Codex" -ForegroundColor Green

# Cleanup temporary clone if used
if ($tempCloned -and (Test-Path $rootDir)) {
    Remove-Item -Path $rootDir -Recurse -Force
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " Universal Multi-Agent & IDE Deployment Complete!" -ForegroundColor Green
Write-Host " Total Skill Copies Deployed: $totalDeployed" -ForegroundColor Green
Write-Host " Active Agents & IDEs Synced: Antigravity, Gemini, Claude, Codex, Cursor, Windsurf, Roo Code, Copilot" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
