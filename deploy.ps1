# Flutter AI Agent Skills — Global Multi-Target Self-Cleaning Deployment Script
# Deploys all 44 skills + _resources (templates, checklists, anti-patterns, decisions) across all 3 AI Agent global paths
# Usage: .\deploy.ps1

$ErrorActionPreference = "Stop"

$sourceBase = Join-Path $PSScriptRoot "skills"
$rootDir = $PSScriptRoot

# 3 Standard Target Paths for Google Gemini, Antigravity, and Universal AI Agents
$targetBases = @(
    (Join-Path $env:USERPROFILE ".gemini\config\skills"),
    (Join-Path $env:USERPROFILE ".agents\skills"),
    (Join-Path $env:USERPROFILE ".gemini\antigravity\skills")
)

if (-not (Test-Path $sourceBase)) {
    Write-Error "Source skills directory not found: $sourceBase"
    exit 1
}

# Find all SKILL.md files and deploy their parent directories
$skillDirs = Get-ChildItem -Path $sourceBase -Filter "SKILL.md" -Recurse |
    Select-Object -ExpandProperty DirectoryName |
    Sort-Object -Unique

# Build official set of valid skill names for self-cleaning purge
$validSkillNames = @("_resources")
foreach ($dir in $skillDirs) {
    $validSkillNames += (Split-Path $dir -Leaf)
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Starting Multi-Target Global Skill & Resource Deployment" -ForegroundColor Cyan
Write-Host " Total Valid Skills Found: $($skillDirs.Count)" -ForegroundColor Cyan
Write-Host " Target Global Paths: $($targetBases.Count)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$totalDeployed = 0
$totalPurged = 0

# Supporting resource directories to bundle globally
$resourceFolders = @("templates", "checklists", "anti-patterns", "decisions")

foreach ($destBase in $targetBases) {
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "[*] Target Path: $destBase" -ForegroundColor Yellow

    # Create destination if it doesn't exist
    if (-not (Test-Path $destBase)) {
        New-Item -ItemType Directory -Path $destBase -Force | Out-Null
        Write-Host "    [+] Created directory: $destBase" -ForegroundColor Green
    }

    # Step A: Purge deprecated or ghost skill directories in target
    Get-ChildItem -Path $destBase -Directory | ForEach-Object {
        if ($_.Name -notin $validSkillNames) {
            Remove-Item -Path $_.FullName -Recurse -Force
            Write-Host "    [PURGE] Removed deprecated ghost skill: $($_.Name)" -ForegroundColor Magenta
            $totalPurged++
        }
    }

    # Step B: Copy clean valid skills
    $deployedForPath = 0

    foreach ($skillDir in $skillDirs) {
        $skillName = Split-Path $skillDir -Leaf
        $destDir = Join-Path $destBase $skillName

        # Remove existing skill directory to ensure clean overwrite
        if (Test-Path $destDir) {
            Remove-Item -Path $destDir -Recurse -Force
        }

        # Copy skill directory
        Copy-Item -Path $skillDir -Destination $destDir -Recurse -Force
        $deployedForPath++
    }

    # Step C: Bundle supporting framework resources (_resources/)
    $destResources = Join-Path $destBase "_resources"
    if (Test-Path $destResources) {
        Remove-Item -Path $destResources -Recurse -Force
    }
    New-Item -ItemType Directory -Path $destResources -Force | Out-Null

    foreach ($resFolder in $resourceFolders) {
        $srcRes = Join-Path $rootDir $resFolder
        if (Test-Path $srcRes) {
            $destResFolder = Join-Path $destResources $resFolder
            Copy-Item -Path $srcRes -Destination $destResFolder -Recurse -Force
        }
    }
    Write-Host "    [+] Bundled _resources (templates, checklists, anti-patterns, decisions)" -ForegroundColor Cyan

    Write-Host "    [OK] Successfully synced $deployedForPath clean skills + _resources to this target!" -ForegroundColor Green
    $totalDeployed += $deployedForPath
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " Multi-Target Global Deployment Complete!" -ForegroundColor Green
Write-Host " Total Skill Copies Deployed: $totalDeployed" -ForegroundColor Green
if ($totalPurged -gt 0) {
    Write-Host " Total Deprecated Ghost Skills Purged: $totalPurged" -ForegroundColor Magenta
}
Write-Host " All AI Agents (Gemini, Antigravity, Claude, etc.) synced with global _resources!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
