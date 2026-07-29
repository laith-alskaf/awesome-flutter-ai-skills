# ============================================================
# Flutter AI Agent Framework -- Global Uninstaller
# Version: 2.0.0 | Date: 2026-07-27
#
# PURPOSE:
#   Removes all 49 Flutter AI Agent skills and _resources from
#   the global AI Agent and IDE directories on your system.
#   Use this when you want to switch to per-project local mode
#   (using init-project.ps1) and keep your global workspace clean.
#
# USAGE:
#   .\uninstall-global.ps1
#
# TARGET GLOBAL DIRECTORIES CLEANED:
#   ~/.gemini/antigravity/skills
#   ~/.gemini/config/skills
#   ~/.agents/skills
#   ~/.codex/skills
#   ~/.cursor/skills
#   ~/.windsurf/skills
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Flutter AI Agent Framework -- Global Uninstaller" -ForegroundColor Cyan
Write-Host "  Removing global framework skills to switch to Local Mode" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$targetBases = @(
    (Join-Path $env:USERPROFILE ".gemini\antigravity\skills"),
    (Join-Path $env:USERPROFILE ".gemini\config\skills"),
    (Join-Path $env:USERPROFILE ".agents\skills"),
    (Join-Path $env:USERPROFILE ".codex\skills"),
    (Join-Path $env:USERPROFILE ".cursor\skills"),
    (Join-Path $env:USERPROFILE ".windsurf\skills")
)

$totalRemoved = 0
$pathsCleaned = 0

foreach ($destBase in $targetBases) {
    if (Test-Path $destBase) {
        Write-Host "[*] Checking: $destBase" -ForegroundColor Yellow
        $removedInPath = 0
        
        # Get all directories starting with flutter- or named _resources
        Get-ChildItem -Path $destBase -Directory | ForEach-Object {
            if ($_.Name.StartsWith("flutter-") -or $_.Name -eq "_resources") {
                Remove-Item -Path $_.FullName -Recurse -Force
                $removedInPath++
                $totalRemoved++
            }
        }

        if ($removedInPath -gt 0) {
            Write-Host "    [OK] Removed $removedInPath framework folders from $destBase" -ForegroundColor Green
            $pathsCleaned++
        } else {
            Write-Host "    [INFO] No global framework skills found in this directory." -ForegroundColor DarkGray
        }

        # If the directory is now completely empty, remove the skills folder itself
        $remaining = (Get-ChildItem -Path $destBase).Count
        if ($remaining -eq 0) {
            Remove-Item -Path $destBase -Force
            Write-Host "    [CLEAN] Removed empty directory: $destBase" -ForegroundColor DarkGray
        }
    } else {
        Write-Host "[SKIP] Directory does not exist: $destBase" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "  [SUCCESS] Global uninstallation complete!" -ForegroundColor Green
Write-Host "  Total framework folders removed: $totalRemoved across $pathsCleaned environments." -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "  [NEXT STEPS]:" -ForegroundColor Cyan
Write-Host "  To use the framework locally in your Flutter projects," -ForegroundColor White
Write-Host "  run the per-project initializer inside any Flutter project dir:" -ForegroundColor White
Write-Host "  .\path\to\flutter-skills\init-project.ps1" -ForegroundColor Yellow
Write-Host ""
