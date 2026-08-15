# ============================================================
# Flutter AI Agent Framework -- Unified Per-Project Initializer
#
# Installs all project-local agent assets under .agents/:
#   rules/       Antigravity workspace rules
#   skills/      Native Agent Skills
#   governance/  Shared policies, router, personas, resources
#   context/     Project facts, active work, and handoffs
#   tools/       Framework verification utilities
#
# Safe defaults: existing context files are never overwritten. Use -Force to
# intentionally regenerate context, framework-managed directories, and editor adapters.
# Use -MigrateLegacy to move an existing .agent/ directory into .agents/ without
# deleting data; the original becomes a dated backup after a successful migration.
# ============================================================

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [string]$ProjectPath = "",
    [string]$SkillsSource = "",
    [switch]$MigrateLegacy,
    [switch]$Force,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Write-Plan {
    param([string]$Message)
    Write-Host "      [PLAN] $Message" -ForegroundColor DarkYellow
}

function Ensure-Directory {
    param([Parameter(Mandatory = $true)][string]$Path, [Parameter(Mandatory = $true)][string]$Label)
    if (Test-Path $Path) { return }
    if ($DryRun) { Write-Plan "Create $Label"; return }
    if ($PSCmdlet.ShouldProcess($Path, "Create $Label")) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Host "      [+] $Label" -ForegroundColor Green
    }
}

function Copy-FrameworkDirectory {
    param(
        [Parameter(Mandatory = $true)][string]$Source,
        [Parameter(Mandatory = $true)][string]$Destination,
        [Parameter(Mandatory = $true)][string]$Label
    )
    if (-not (Test-Path $Source)) { throw "Required framework source is absent: $Source" }
    if (Test-Path $Destination) {
        if (-not $Force) {
            Write-Host "      [=] $Label already exists; preserved (use -Force to refresh framework-managed files)." -ForegroundColor DarkYellow
            return
        }
        if ($DryRun) { Write-Plan "Replace $Label"; return }
        if ($PSCmdlet.ShouldProcess($Destination, "Replace $Label with framework-managed files")) {
            Remove-Item -Path $Destination -Recurse -Force
        } else { return }
    }
    if ($DryRun) { Write-Plan "Copy $Label"; return }
    if ($PSCmdlet.ShouldProcess($Destination, "Install $Label")) {
        Copy-Item -Path $Source -Destination $Destination -Recurse -Force
        Write-Host "      [+] $Label" -ForegroundColor Green
    }
}

function Write-ContextFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Label
    )
    if (Test-Path $Path -and -not $Force) {
        Write-Host "      [=] $Label already exists; preserved as project-owned context (use -Force to regenerate it)." -ForegroundColor DarkYellow
        return
    }
    if ($DryRun) { Write-Plan "Write $Label"; return }
    if ($PSCmdlet.ShouldProcess($Path, "Write $Label")) {
        Set-Content -Path $Path -Value $Content -Encoding utf8 -Force
        Write-Host "      [+] $Label" -ForegroundColor Green
    }
}

function Write-AdapterFile {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Content,
        [Parameter(Mandatory = $true)][string]$Label
    )
    if (Test-Path $Path -and -not $Force) {
        Write-Host "      [=] $Label already exists; preserved (use -Force to refresh the adapter)." -ForegroundColor DarkYellow
        return
    }
    if ($DryRun) { Write-Plan "Write $Label"; return }
    if ($PSCmdlet.ShouldProcess($Path, "Write $Label")) {
        $parent = Split-Path -Parent $Path
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Set-Content -Path $Path -Value $Content -Encoding utf8 -Force
        Write-Host "      [+] $Label" -ForegroundColor Green
    }
}

function Copy-LegacyContext {
    param(
        [Parameter(Mandatory = $true)][string]$LegacyRoot,
        [Parameter(Mandatory = $true)][string]$ContextRoot
    )
    $names = @("PROJECT_PROFILE.md", "CURRENT_STATE.md", "KNOWLEDGE_INDEX.md", "AGENTS_MEMORY.md", "SESSION_LOG.md")
    $conflicts = @()
    foreach ($name in $names) {
        $source = Join-Path $LegacyRoot $name
        $destination = Join-Path $ContextRoot $name
        if (-not (Test-Path $source)) { continue }
        if (Test-Path $destination) {
            $conflicts += $name
            continue
        }
        if ($DryRun) { Write-Plan "Migrate legacy context $name"; continue }
        if ($PSCmdlet.ShouldProcess($destination, "Migrate legacy context $name")) {
            Copy-Item -Path $source -Destination $destination -Force
            Write-Host "      [+] migrated legacy context/$name" -ForegroundColor Green
        }
    }
    if ($conflicts.Count -gt 0) {
        throw "Legacy migration found project-owned context conflicts: $($conflicts -join ', '). Resolve them before running -MigrateLegacy."
    }
}

# 1. Resolve framework source.
$scriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($scriptDir)) { $frameworkRoot = (Get-Location).Path }
else { $frameworkRoot = Split-Path -Parent $scriptDir }
if (-not [string]::IsNullOrEmpty($SkillsSource)) { $frameworkRoot = $SkillsSource }

$tempCloned = $false
if (-not (Test-Path (Join-Path $frameworkRoot "skills"))) {
    if ($DryRun) { throw "-DryRun requires -SkillsSource when the framework is not checked out locally." }
    Write-Host "[*] Framework source not found locally. Fetching a temporary checkout from GitHub..." -ForegroundColor Cyan
    $tempDir = Join-Path $env:TEMP "flutter-skills-init-temp"
    if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }
    git clone --depth 1 https://github.com/laith-alskaf/awesome-flutter-ai-skills.git $tempDir | Out-Null
    $frameworkRoot = $tempDir
    $tempCloned = $true
}

if ([string]::IsNullOrEmpty($ProjectPath)) { $ProjectPath = (Get-Location).Path }
$pubspecPath = Join-Path $ProjectPath "pubspec.yaml"
if (-not (Test-Path $pubspecPath)) { throw "No pubspec.yaml found in: $ProjectPath. Run from a Flutter project root or use -ProjectPath." }

$projectName = "my_flutter_app"
$pubspecContent = Get-Content $pubspecPath -Raw
if ($pubspecContent -match "^name:\s*(.+)$") { $projectName = $Matches[1].Trim() }
$today = (Get-Date).ToString("yyyy-MM-dd")
$frameworkRevision = "unknown"
try { $frameworkRevision = (git -C $frameworkRoot rev-parse --short HEAD 2>$null).Trim() } catch { }

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Flutter AI Agent Framework -- Unified .agents/ Mode" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Project : $projectName" -ForegroundColor Yellow
Write-Host "  Path    : $ProjectPath" -ForegroundColor Yellow
Write-Host "  Source  : $frameworkRoot ($frameworkRevision)" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 2. Define the unified project layout.
$agentsRoot = Join-Path $ProjectPath ".agents"
$rulesDir = Join-Path $agentsRoot "rules"
$skillsDir = Join-Path $agentsRoot "skills"
$governanceDir = Join-Path $agentsRoot "governance"
$contextDir = Join-Path $agentsRoot "context"
$toolsDir = Join-Path $agentsRoot "tools"
$manifestPath = Join-Path $agentsRoot "framework-manifest.json"
$legacyRoot = Join-Path $ProjectPath ".agent"

foreach ($entry in @(
    @{ Path = $agentsRoot; Label = ".agents/" },
    @{ Path = $rulesDir; Label = ".agents/rules/" },
    @{ Path = $skillsDir; Label = ".agents/skills/" },
    @{ Path = $contextDir; Label = ".agents/context/" }
)) { Ensure-Directory -Path $entry.Path -Label $entry.Label }
# governance/ and tools/ are created by Copy-FrameworkDirectory so an empty
# pre-created directory cannot be mistaken for an existing managed installation.

# 3. Migrate only durable user context before creating defaults.
$legacyDetected = Test-Path $legacyRoot
if ($MigrateLegacy) {
    if (-not $legacyDetected) { Write-Host "      [=] No .agent/ directory found; no legacy migration is required." -ForegroundColor DarkYellow }
    else { Copy-LegacyContext -LegacyRoot $legacyRoot -ContextRoot $contextDir }
} elseif ($legacyDetected) {
    Write-Host "      [!] Existing .agent/ detected. It is preserved. Re-run with -MigrateLegacy to copy durable context into .agents/context/." -ForegroundColor Yellow
}

# 4. Install framework-managed governance and tools.
Write-Host "[1/6] Installing governance and verification tools..." -ForegroundColor Yellow
Copy-FrameworkDirectory -Source (Join-Path $frameworkRoot "core") -Destination $governanceDir -Label ".agents/governance/"
Copy-FrameworkDirectory -Source (Join-Path $frameworkRoot "tools") -Destination $toolsDir -Label ".agents/tools/"

# 5. Create project-owned context only when absent, unless -Force is explicit.
Write-Host "[2/6] Creating project context while preserving existing records by default..." -ForegroundColor Yellow
$projectProfile = @"
# PROJECT_PROFILE.md -- Static Project Identity

> Record confirmed project facts. `pubspec.yaml`, source code, tests, platform folders, and CI remain the technical source of truth.

## Project Identity

```yaml
ProjectName: "$projectName"
ProjectType: "[Mobile App | SaaS | Desktop | Web | SDK]"
InitializedDate: "$today"
```

## Confirmed Technology Stack

```yaml
StateManagement: ""
Routing: ""
Database: ""
Networking: ""
Authentication: ""
Platforms: ""
```

## Business Context

> [Describe the product and its primary users in one or two sentences.]

## Project-Specific Agent Constraints

> [Record only stable rules that are not already represented by code, CI, or governance.]
"@

$currentState = @"
# CURRENT_STATE.md -- Active Work State

## Current Objective

```yaml
ActiveGoal: "[Describe the active task]"
LastUpdated: "$today"
TaskRisk: "[Low | Medium | High]"
```

## Decision Record

| Type | Record |
|---|---|
| Evidence | Inspect affected code, tests, CI, and project facts before recording claims. |
| Decisions | Record choices that affect future work. |
| Assumptions | Record only assumptions needed for the active task and how to validate them. |
| Open questions | Ask only when an answer could change a material decision. |
| Validation status | Record completed, pending, and unavailable checks. |
| Next action | State the smallest safe next action or handoff. |

> Do not use numerical confidence scores as a decision gate. For reversible low-risk work, state the assumption, make the smallest safe change, and validate it.
"@

$agentsMemory = @"
# AGENTS_MEMORY.md -- Reusable Lessons and Project Health

## Health Snapshot

| Area | Status | Evidence / next check |
|---|---|---|
| Architecture | Not assessed | |
| Tests | Not assessed | |
| Security | Not assessed | |
| Documentation | Initializing | |

## Reusable Lessons

> Add only durable lessons that prevent repeated mistakes. Link supporting files or decisions where useful.
"@

$sessionLog = @"
# SESSION_LOG.md -- Meaningful Handoffs

## Session: $today

- **Action:** Unified `.agents/` framework initialized.
- **Framework source:** awesome-flutter-ai-skills at `$frameworkRevision`.
- **Next step:** Confirm the project profile and inspect the affected code before material work.

> Add a handoff only when work spans sessions or phases. Keep it concise: objective, evidence, decisions, validation, and next action.
"@

$knowledgeTemplate = Join-Path $frameworkRoot "core/templates/knowledge_index.md.template"
if (Test-Path $knowledgeTemplate) {
    $knowledgeContent = (Get-Content $knowledgeTemplate -Raw).Replace(".agent/", ".agents/").Replace(".agent\\", ".agents\\")
    $knowledgeContent = $knowledgeContent.Replace(".agents/core/", ".agents/governance/")
    Write-ContextFile -Path (Join-Path $contextDir "KNOWLEDGE_INDEX.md") -Content $knowledgeContent -Label ".agents/context/KNOWLEDGE_INDEX.md"
}
Write-ContextFile -Path (Join-Path $contextDir "PROJECT_PROFILE.md") -Content $projectProfile -Label ".agents/context/PROJECT_PROFILE.md"
Write-ContextFile -Path (Join-Path $contextDir "CURRENT_STATE.md") -Content $currentState -Label ".agents/context/CURRENT_STATE.md"
Write-ContextFile -Path (Join-Path $contextDir "AGENTS_MEMORY.md") -Content $agentsMemory -Label ".agents/context/AGENTS_MEMORY.md"
Write-ContextFile -Path (Join-Path $contextDir "SESSION_LOG.md") -Content $sessionLog -Label ".agents/context/SESSION_LOG.md"

# 6. Install skills directly under the Antigravity discovery path.
Write-Host "[3/6] Installing native Agent Skills..." -ForegroundColor Yellow
$sourceSkills = Join-Path $frameworkRoot "skills"
$skillDirs = Get-ChildItem -Path $sourceSkills -Filter "SKILL.md" -Recurse |
    ForEach-Object { Get-Item $_.DirectoryName } |
    Sort-Object FullName -Unique
if ($skillDirs.Count -eq 0) { throw "No SKILL.md directories were found under $sourceSkills." }
$installedNames = @{}
foreach ($skillDir in $skillDirs) {
    if ($installedNames.ContainsKey($skillDir.Name)) { throw "Duplicate skill directory name '$($skillDir.Name)' cannot be installed directly under .agents/skills/." }
    $destination = Join-Path $skillsDir $skillDir.Name
    if (Test-Path $destination -and -not $Force) {
        Write-Host "      [=] skill/$($skillDir.Name) already exists; preserved (use -Force to refresh)." -ForegroundColor DarkYellow
    } elseif ($DryRun) {
        Write-Plan "Install skill/$($skillDir.Name)"
    } elseif ($PSCmdlet.ShouldProcess($destination, "Install framework skill $($skillDir.Name)")) {
        if (Test-Path $destination) { Remove-Item -Path $destination -Recurse -Force }
        Copy-Item -Path $skillDir.FullName -Destination $destination -Recurse -Force
        Write-Host "      [+] skill/$($skillDir.Name)" -ForegroundColor Green
    }
    $installedNames[$skillDir.Name] = $true
}

# 7. Create a focused Antigravity workspace rule and editor adapters.
Write-Host "[4/6] Creating Antigravity rule and editor adapters..." -ForegroundColor Yellow
$operatingRule = @"
# Flutter project operating contract

For non-trivial work, inspect `pubspec.yaml`, the affected feature, relevant tests, and CI configuration. When the following files exist and are relevant, read them before making material decisions:

- @/.agents/context/PROJECT_PROFILE.md
- @/.agents/context/CURRENT_STATE.md
- @/.agents/governance/AGENTS.md
- @/.agents/governance/ROUTER_MANIFESTO.md

Use the smallest relevant skill set from `.agents/skills/`. Preserve the architecture and state-management approach already used by the affected feature. Ask focused questions only when an answer could change architecture, security, data, external contracts, dependencies, or user-visible behavior. For a reversible low-risk change, state the assumption, make the smallest safe change, and validate it.

Record evidence, decisions, validation status, and the next action in `.agents/context/CURRENT_STATE.md` only for material or multi-phase work. Do not replace codebase evidence with stale context files.
"@

$projectFilesRule = @"
# Flutter source and test files

When changing `lib/**`, inspect the affected feature and its tests before selecting a state-management or architecture skill. Keep tests, analysis, and formatter commands proportionate to the change. Treat `pubspec.yaml`, source, tests, platform folders, and CI as technical sources of truth.
"@

$releaseRule = @"
# CI and release files

When changing CI, release, signing, dependency, or platform configuration, inspect the existing pipeline and relevant project constraints. Use the smallest relevant skill set, record material decisions in `.agents/context/`, and do not claim platform validation that was not executed.
"@

Write-AdapterFile -Path (Join-Path $rulesDir "flutter-project-operating-contract.md") -Content $operatingRule -Label ".agents/rules/flutter-project-operating-contract.md"
Write-AdapterFile -Path (Join-Path $rulesDir "flutter-project-files.md") -Content $projectFilesRule -Label ".agents/rules/flutter-project-files.md"
Write-AdapterFile -Path (Join-Path $rulesDir "flutter-ci-and-release.md") -Content $releaseRule -Label ".agents/rules/flutter-ci-and-release.md"

$adapter = @"
# Flutter AI Agent Project Adapter

Project-local agent assets are unified under `.agents/`.

1. Inspect `pubspec.yaml`, the affected feature, tests, and CI first.
2. When relevant, read `.agents/context/PROJECT_PROFILE.md`, `.agents/context/CURRENT_STATE.md`, `.agents/governance/AGENTS.md`, and `.agents/governance/ROUTER_MANIFESTO.md`.
3. Select the smallest relevant workflow from `.agents/skills/` and preserve the existing state-management and architecture conventions.
4. Ask only material questions. Validate each change proportionately and record a handoff only for material or multi-phase work.
5. Run `dart run .agents/tools/verify_architecture.dart` when architectural verification is applicable.
"@
Write-AdapterFile -Path (Join-Path $ProjectPath ".cursorrules") -Content $adapter -Label ".cursorrules"
Write-AdapterFile -Path (Join-Path $ProjectPath ".windsurfrules") -Content $adapter -Label ".windsurfrules"
Write-AdapterFile -Path (Join-Path $ProjectPath ".clinerules") -Content $adapter -Label ".clinerules"
Write-AdapterFile -Path (Join-Path $ProjectPath ".codex/instructions.md") -Content $adapter -Label ".codex/instructions.md"
Write-AdapterFile -Path (Join-Path $ProjectPath ".github/copilot-instructions.md") -Content $adapter -Label ".github/copilot-instructions.md"

# 8. Record a reproducible installation manifest after paths are present.
Write-Host "[5/6] Writing installation manifest..." -ForegroundColor Yellow
$manifest = @{
    schema_version = 1
    framework = "awesome-flutter-ai-skills"
    framework_revision = $frameworkRevision
    initialized_at = $today
    project_name = $projectName
    layout = ".agents"
    skill_count = $installedNames.Count
    paths = @{
        rules = ".agents/rules"
        skills = ".agents/skills"
        governance = ".agents/governance"
        context = ".agents/context"
        tools = ".agents/tools"
    }
} | ConvertTo-Json -Depth 4
Write-AdapterFile -Path $manifestPath -Content $manifest -Label ".agents/framework-manifest.json"

# 9. Verify the unified layout before optionally backing up legacy state.
Write-Host "[6/6] Verifying unified agent workspace..." -ForegroundColor Yellow
$checks = @(
    @{ Path = (Join-Path $governanceDir "AGENTS.md"); Label = ".agents/governance/AGENTS.md" },
    @{ Path = (Join-Path $governanceDir "ROUTER_MANIFESTO.md"); Label = ".agents/governance/ROUTER_MANIFESTO.md" },
    @{ Path = (Join-Path $contextDir "PROJECT_PROFILE.md"); Label = ".agents/context/PROJECT_PROFILE.md" },
    @{ Path = (Join-Path $contextDir "CURRENT_STATE.md"); Label = ".agents/context/CURRENT_STATE.md" },
    @{ Path = (Join-Path $rulesDir "flutter-project-operating-contract.md"); Label = ".agents/rules/flutter-project-operating-contract.md" },
    @{ Path = (Join-Path $skillsDir "flutter-agent-evaluation/SKILL.md"); Label = ".agents/skills/flutter-agent-evaluation/SKILL.md" },
    @{ Path = (Join-Path $toolsDir "verify_architecture.dart"); Label = ".agents/tools/verify_architecture.dart" },
    @{ Path = $manifestPath; Label = ".agents/framework-manifest.json" }
)
$allPassed = $true
foreach ($check in $checks) {
    if (Test-Path $check.Path) { Write-Host "      [OK] $($check.Label)" -ForegroundColor Green }
    else { Write-Host "      [FAIL] $($check.Label)" -ForegroundColor Red; $allPassed = $false }
}

if ($MigrateLegacy -and $legacyDetected -and $allPassed -and -not $DryRun) {
    $backup = Join-Path $ProjectPath (".agent.backup-" + (Get-Date).ToString("yyyyMMdd-HHmmss"))
    if ($PSCmdlet.ShouldProcess($legacyRoot, "Rename legacy .agent directory to $([IO.Path]::GetFileName($backup)) after migration")) {
        Move-Item -Path $legacyRoot -Destination $backup
        Write-Host "      [+] legacy .agent/ preserved as $([IO.Path]::GetFileName($backup))/" -ForegroundColor Green
    }
}

if ($tempCloned -and (Test-Path $frameworkRoot)) { Remove-Item -Path $frameworkRoot -Recurse -Force }

Write-Host ""
if ($allPassed) {
    Write-Host "[SUCCESS] Unified .agents/ framework initialized for $projectName." -ForegroundColor Green
    Write-Host "         Configure the project operating contract in Antigravity as Always On or Model Decision as appropriate for your team." -ForegroundColor Green
} else {
    Write-Host "[WARN] Unified initialization did not pass all checks; inspect output before using the framework." -ForegroundColor Yellow
}
Write-Host "  Skills:     .agents/skills/" -ForegroundColor Cyan
Write-Host "  Rules:      .agents/rules/" -ForegroundColor Cyan
Write-Host "  Governance: .agents/governance/" -ForegroundColor Cyan
Write-Host "  Context:    .agents/context/" -ForegroundColor Cyan
Write-Host "  Verify:     dart run .agents/tools/verify_architecture.dart" -ForegroundColor Cyan
