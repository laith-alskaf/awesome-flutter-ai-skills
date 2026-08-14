# Flutter AI Agent Skills -- Global Deployment
# Deploy from a checked-out repository: .\tools\deploy.ps1
# Preview all writes: .\tools\deploy.ps1 -WhatIf
# Remove only stale directories previously marked by this script: .\tools\deploy.ps1 -Prune

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [switch]$Prune
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-UserHome {
    if (-not [string]::IsNullOrEmpty($env:HOME)) { return $env:HOME }
    if (-not [string]::IsNullOrEmpty($env:USERPROFILE)) { return $env:USERPROFILE }
    return [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
}

function Restore-SkillBackup {
    param(
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][string]$Backup
    )

    if (Test-Path $Destination) { Remove-Item -Path $Destination -Recurse -Force }
    if (Test-Path $Backup) { Move-Item -Path $Backup -Destination $Destination -Force }
}

if ([string]::IsNullOrEmpty($PSScriptRoot)) {
    throw 'Run this script from a checked-out repository. Remote pipe execution is intentionally not supported.'
}

$frameworkRoot = Split-Path -Parent $PSScriptRoot
$sourceBase = Join-Path $frameworkRoot 'skills'
if (-not (Test-Path $sourceBase)) {
    throw "Cannot find skills source at $sourceBase. Run this script from the repository's tools directory."
}

$skillDirs = Get-ChildItem -Path $sourceBase -Filter 'SKILL.md' -Recurse |
    ForEach-Object { Get-Item $_.DirectoryName } |
    Sort-Object FullName -Unique
if ($skillDirs.Count -eq 0) {
    throw 'No SKILL.md directories were found; refusing to deploy an empty framework.'
}

$userHome = Get-UserHome
$targetBases = @(
    (Join-Path $userHome '.gemini/config/skills'),
    (Join-Path $userHome '.agents/skills'),
    (Join-Path $userHome '.codex/skills'),
    (Join-Path $userHome '.cursor/skills'),
    (Join-Path $userHome '.windsurf/skills')
)
$managedMarker = '.awesome-flutter-ai-skills-managed'
$validSkillNames = @($skillDirs | ForEach-Object { $_.Name })

Write-Host "Deploying $($skillDirs.Count) Agent Skills to $($targetBases.Count) global locations." -ForegroundColor Cyan
Write-Host 'Use init-project.ps1 for project-local .agent/ state and .agents/skills/ installation.' -ForegroundColor Cyan

$totalDeployed = 0
$totalPruned = 0
foreach ($destinationBase in $targetBases) {
    if (-not (Test-Path $destinationBase) -and $PSCmdlet.ShouldProcess($destinationBase, 'Create skill directory')) {
        New-Item -ItemType Directory -Path $destinationBase -Force | Out-Null
    }
    if (-not (Test-Path $destinationBase)) { continue }

    Write-Host "[*] $destinationBase" -ForegroundColor Yellow
    foreach ($skillDir in $skillDirs) {
        $destination = Join-Path $destinationBase $skillDir.Name
        $backup = "$destination.backup.$([Guid]::NewGuid().ToString('N'))"
        if (-not $PSCmdlet.ShouldProcess($destination, "Synchronize skill $($skillDir.Name)")) { continue }

        try {
            if (Test-Path $destination) { Move-Item -Path $destination -Destination $backup -Force }
            Copy-Item -Path $skillDir.FullName -Destination $destination -Recurse -Force
            Set-Content -Path (Join-Path $destination $managedMarker) -Value "source=awesome-flutter-ai-skills`n" -NoNewline
            if (Test-Path $backup) { Remove-Item -Path $backup -Recurse -Force }
            $totalDeployed++
            Write-Host "    [OK] $($skillDir.Name)" -ForegroundColor Green
        } catch {
            Restore-SkillBackup -Destination $destination -Backup $backup
            throw "Failed to synchronize $($skillDir.Name) to $destinationBase. Original directory was restored. $_"
        }
    }

    if ($Prune) {
        Get-ChildItem -Path $destinationBase -Directory | ForEach-Object {
            $marker = Join-Path $_.FullName $managedMarker
            if ((Test-Path $marker) -and $_.Name -notin $validSkillNames -and $PSCmdlet.ShouldProcess($_.FullName, 'Remove stale framework-managed skill')) {
                Remove-Item -Path $_.FullName -Recurse -Force
                $totalPruned++
                Write-Host "    [PRUNED] $($_.Name)" -ForegroundColor DarkYellow
            }
        }
    }
}

Write-Host "[SUCCESS] Deployed $totalDeployed skill copies." -ForegroundColor Green
if ($Prune) { Write-Host "[SUCCESS] Pruned $totalPruned stale framework-managed skill directories." -ForegroundColor Green }
