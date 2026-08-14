# Flutter AI Agent Framework -- Global Uninstaller
# Removes only skill names supplied by this checked-out framework source.
# Usage: .\tools\uninstall-global.ps1 -Force

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

function Get-UserHome {
    if (-not [string]::IsNullOrEmpty($env:HOME)) { return $env:HOME }
    if (-not [string]::IsNullOrEmpty($env:USERPROFILE)) { return $env:USERPROFILE }
    return [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
}

if ([string]::IsNullOrEmpty($PSScriptRoot)) {
    throw 'Run this uninstaller from a checked-out repository so it can determine the managed skill names safely.'
}

$frameworkRoot = Split-Path -Parent $PSScriptRoot
$sourceSkills = Join-Path $frameworkRoot 'skills'
if (-not (Test-Path $sourceSkills)) {
    throw "Cannot find skills source at $sourceSkills. Run this script from the repository's tools directory."
}

$managedSkillNames = Get-ChildItem -Path $sourceSkills -Filter 'SKILL.md' -Recurse |
    ForEach-Object { Split-Path $_.DirectoryName -Leaf } |
    Sort-Object -Unique

if ($managedSkillNames.Count -eq 0) {
    throw 'No managed SKILL.md directories were found; refusing to remove anything.'
}

if (-not $Force) {
    throw 'Refusing to remove globally installed skills without -Force. Review the target paths, then rerun with -Force or use -WhatIf.'
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
$totalRemoved = 0
foreach ($destBase in $targetBases) {
    if (-not (Test-Path $destBase)) {
        Write-Host "[SKIP] Directory does not exist: $destBase" -ForegroundColor DarkGray
        continue
    }

    foreach ($skillName in $managedSkillNames) {
        $target = Join-Path $destBase $skillName
        $marker = Join-Path $target $managedMarker
        if ((Test-Path $target -PathType Container) -and (Test-Path $marker -PathType Leaf) -and $PSCmdlet.ShouldProcess($target, 'Remove framework-managed skill')) {
            Remove-Item -Path $target -Recurse -Force
            $totalRemoved++
            Write-Host "[REMOVED] $target" -ForegroundColor Green
        }
    }
}

Write-Host "[SUCCESS] Removed $totalRemoved managed skill directory/directories." -ForegroundColor Green
Write-Host 'The uninstaller deliberately leaves unknown directories untouched.' -ForegroundColor Cyan
