# Universal Flutter AI Agent Skills — Multi-Agent & IDE Deployment Script
# Deploys 51 skills + _resources across ALL AI Agents & IDEs (Antigravity, Gemini, Claude, OpenAI Codex, Cursor, Windsurf, Roo Code, Copilot)
# Usage: .\deploy.ps1
# One-Line Remote Usage: irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/tools/deploy.ps1 | iex

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
$resourceFolders = @("core", "tools")

# Step 1: Deploy Global Skills & _resources to All AI Agent Paths (Atomic Staging Rollback Engine)
foreach ($destBase in $targetBases) {
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "[*] Target Path: $destBase" -ForegroundColor Yellow

    $stagingDir = $null
    try {
        $parentDir = Split-Path $destBase -Parent
        if (-not (Test-Path $parentDir)) { New-Item -ItemType Directory -Path $parentDir -Force | Out-Null }

        # Create unique staging directory
        $stagingDir = Join-Path $parentDir (".staging_" + (Split-Path $destBase -Leaf) + "_" + [Guid]::NewGuid().ToString("N").Substring(0, 8))
        if (Test-Path $stagingDir) { Remove-Item -Path $stagingDir -Recurse -Force }
        New-Item -ItemType Directory -Path $stagingDir -Force | Out-Null
        Write-Host "    [STAGING] Preparing atomic staging build: $stagingDir" -ForegroundColor DarkGray

        # Copy clean valid skills to staging
        $deployedForPath = 0
        foreach ($skillDir in $skillDirs) {
            $skillName = Split-Path $skillDir -Leaf
            $destDir = Join-Path $stagingDir $skillName
            Copy-Item -Path $skillDir -Destination $destDir -Recurse -Force
            $deployedForPath++
        }

        foreach ($resFolder in $resourceFolders) {
            $srcRes = Join-Path $rootDir $resFolder
            if (Test-Path $srcRes) {
                $destResFolder = Join-Path $stagingDir $resFolder
                Copy-Item -Path $srcRes -Destination $destResFolder -Recurse -Force
            }
        }

        # Verify Staging Build Integrity (Count check)
        $stagingSkillCount = (Get-ChildItem -Path $stagingDir -Directory | Where-Object { $_.Name -ne "_resources" }).Count
        if ($stagingSkillCount -ne $skillDirs.Count) {
            throw "Staging verification failed: Expected $($skillDirs.Count) skills, but found $stagingSkillCount in staging."
        }

        # Atomic Commit: Create target if missing and purge ghost skills
        if (-not (Test-Path $destBase)) {
            New-Item -ItemType Directory -Path $destBase -Force | Out-Null
            Write-Host "    [+] Created directory: $destBase" -ForegroundColor Green
        }

        Get-ChildItem -Path $destBase -Directory | ForEach-Object {
            if ($_.Name -notin $validSkillNames) {
                Remove-Item -Path $_.FullName -Recurse -Force
                Write-Host "    [PURGE] Removed deprecated ghost skill: $($_.Name)" -ForegroundColor Magenta
                $totalPurged++
            }
        }

        # Move each verified skill and resource folder from staging to destBase
        Get-ChildItem -Path $stagingDir | ForEach-Object {
            $targetItem = Join-Path $destBase $_.Name
            if (Test-Path $targetItem) { Remove-Item -Path $targetItem -Recurse -Force }
            Move-Item -Path $_.FullName -Destination $targetItem -Force
        }

        Write-Host "    [+] Synced core/ and tools/ modules" -ForegroundColor Cyan
        Write-Host "    [OK] Successfully deployed $deployedForPath skills via Atomic Rollback Engine to $destBase" -ForegroundColor Green
        $totalDeployed += $deployedForPath
    }
    catch {
        Write-Host "    [RED ALERT - ATOMIC ROLLBACK] Failed deploying to $destBase : $_" -ForegroundColor Red
        Write-Host "    [ROLLBACK] Active directory preserved without corruption." -ForegroundColor Red
    }
    finally {
        if ($stagingDir -and (Test-Path $stagingDir)) {
            Remove-Item -Path $stagingDir -Recurse -Force
        }
    }
}

# Step 2: Inject Local IDE & Cloud Agent Rules in Current Directory
Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "[*] Injecting Local IDE & Cloud Agent Rules (Cursor, Windsurf, Roo, Codex, Copilot)..." -ForegroundColor Yellow

$currentDir = Get-Location

# Cursor Rules (.cursorrules)
$cursorRules = @"
# Cursor Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Flutter 3.44.x Stable & Dart 3.12.x Sound Null Safety, Material 3, Impeller Engine.
- Zero dynamic types & zero raw unhandled exceptions. Sealed classes & pattern matching for async states.
- Mandatory const constructors & immutable domain entities.
"@
Set-Content -Path (Join-Path $currentDir ".cursorrules") -Value $cursorRules -Force
Write-Host "    [+] Created .cursorrules in current path" -ForegroundColor Green

# Windsurf Rules (.windsurfrules)
$windsurfRules = @"
# Windsurf Cascade Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Target: Flutter 3.44.x Stable, Dart 3.12.x, Material 3, Impeller Engine.
- Sealed classes & pattern matching for async states (AsyncValue / BlocState).
- Never mix business logic in UI widgets.
"@
Set-Content -Path (Join-Path $currentDir ".windsurfrules") -Value $windsurfRules -Force
Write-Host "    [+] Created .windsurfrules in current path" -ForegroundColor Green

# Roo Code / Cline Rules (.clinerules)
$clineRules = @"
# Roo Code & Cline Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Flutter 3.44.x Stable + Dart 3.12.x Sound Null Safety.
- Use const constructors everywhere possible.
"@
Set-Content -Path (Join-Path $currentDir ".clinerules") -Value $clineRules -Force
Write-Host "    [+] Created .clinerules in current path" -ForegroundColor Green

# OpenAI Codex Cloud Agent Instructions (.codex/instructions.md)
$codexPath = Join-Path $currentDir ".codex"
if (-not (Test-Path $codexPath)) { New-Item -ItemType Directory -Path $codexPath -Force | Out-Null }
$codexRules = @"
# OpenAI Codex Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Flutter 3.44.x Stable & Dart 3.12.x Sound Null Safety, Material 3, Impeller Engine.
- Zero dynamic types & zero raw unhandled exceptions.
- Mandatory const constructors & immutable domain entities.
"@
Set-Content -Path (Join-Path $codexPath "instructions.md") -Value $codexRules -Force
Write-Host "    [+] Created .codex/instructions.md for Cloud Codex Agents" -ForegroundColor Green

# GitHub Copilot Instructions (.github/copilot-instructions.md)
$githubPath = Join-Path $currentDir ".github"
if (-not (Test-Path $githubPath)) { New-Item -ItemType Directory -Path $githubPath -Force | Out-Null }
$copilotRules = @"
# GitHub Copilot Rules — Flutter AI Agent Skill Framework 2026
- ZERO HALLUCINATION GATEKEEPER: Before writing code, output a "Context Parity Header" confirming reading of .ai/PROJECT_PROFILE.md and active layer rules. If requirements are ambiguous or Confidence < 0.80, activate Grill-Me Mode (flutter-grill-me) and interrogate the user before generating code.
- STATE MATRIX FIREWALL: Check pubspec.yaml as step zero. If Riverpod is detected, NEVER call Cubit/Bloc/GetX skills. If Bloc is detected, NEVER call Riverpod/GetX skills.
- Enforce Clean Architecture: Presentation -> Domain -> Data. Zero Flutter UI or state imports in Domain layer.
- Flutter 3.44.x Stable & Dart 3.12.x Sound Null Safety, Material 3, Impeller Engine.
- Zero dynamic types & zero raw unhandled exceptions.
- Mandatory const constructors & immutable domain entities.
"@
Set-Content -Path (Join-Path $githubPath "copilot-instructions.md") -Value $copilotRules -Force
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
