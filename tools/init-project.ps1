# ============================================================
# Flutter AI Agent Framework -- Per-Project Initializer
# Version: 2.1.0 | Date: 2026-07-27
#
# PURPOSE:
#   Injects the full Flutter AI Agent Skill Framework into any
#   Flutter project directory so that ALL AI agents (Antigravity,
#   Gemini, Claude, Cursor, Windsurf, Copilot, Codex, Roo) work
#   with the complete framework locally -- per project.
#   Project state and governance live in .agent/; native workspace skills
#   live in .agents/skills/ for Antigravity discovery.
#
# USAGE (from inside your Flutter project root):
#   & "path\to\flutter-skills\tools\init-project.ps1"
#
# USAGE (specify project path explicitly):
#   & "path\to\flutter-skills\tools\init-project.ps1" -ProjectPath "D:\Projects\my_flutter_app"
#
# WHAT IT CREATES:
#   .agent/core/AGENTS.md            -> Framework governance rules
#   .agent/core/ROUTER_MANIFESTO.md  -> Agent routing & skill matrix
#   .agent/core/PERSONAS.md          -> The 5 AI Personas definitions
#   .agent/PROJECT_PROFILE.md        -> Project identity (edit this!)
#   .agent/KNOWLEDGE_INDEX.md        -> Navigation map to all skills
#   .agent/CURRENT_STATE.md          -> Evidence, assumptions, and open questions
#   .agent/AGENTS_MEMORY.md          -> Project health and reusable lessons
#   .agent/SESSION_LOG.md            -> Chronological session handoffs
#   .agent/tools/                    -> Executable framework utilities
#   .agents/skills/                  -> All native Agent Skills
#   .cursorrules                     -> Cursor IDE rules (pointing to .agent/)
#   .windsurfrules                   -> Windsurf IDE rules (pointing to .agent/)
#   .clinerules                      -> Roo Code / Cline rules (pointing to .agent/)
#   .codex/instructions.md           -> OpenAI Codex rules (pointing to .agent/)
#   .github/copilot-instructions.md  -> GitHub Copilot rules (pointing to .agent/)
# ============================================================

param(
    [string]$ProjectPath = "",
    [string]$SkillsSource = ""
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ---------------------------------------------
# 1. RESOLVE PATHS
# ---------------------------------------------

# Resolve the repository root when invoked from tools/, while retaining
# current-directory behavior for one-line streamed execution.
$scriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($scriptDir)) {
    $frameworkRoot = (Get-Location).Path
} else {
    $frameworkRoot = Split-Path -Parent $scriptDir
}
if (-not [string]::IsNullOrEmpty($SkillsSource)) { $frameworkRoot = $SkillsSource }

# If run via IEX stream (no local files), clone from GitHub temporarily
$tempCloned = $false
if (-not (Test-Path (Join-Path $frameworkRoot "skills"))) {
    Write-Host "[*] Framework not found locally. Fetching from GitHub..." -ForegroundColor Cyan
    $tempDir = Join-Path $env:TEMP "flutter-skills-init-temp"
    if (Test-Path $tempDir) { Remove-Item -Path $tempDir -Recurse -Force }
    git clone --depth 1 https://github.com/laith-alskaf/awesome-flutter-ai-skills.git $tempDir | Out-Null
    $frameworkRoot = $tempDir
    $tempCloned = $true
}

# Determine the target Flutter project directory
if ([string]::IsNullOrEmpty($ProjectPath)) {
    $ProjectPath = (Get-Location).Path
}

# Validate it looks like a Flutter project
$pubspecPath = Join-Path $ProjectPath "pubspec.yaml"
if (-not (Test-Path $pubspecPath)) {
    Write-Host ""
    Write-Host "[ERROR] No pubspec.yaml found in: $ProjectPath" -ForegroundColor Red
    Write-Host "        Run this script from inside a Flutter project root directory." -ForegroundColor Red
    Write-Host "        Or specify: -ProjectPath 'D:\Projects\my_flutter_app'" -ForegroundColor Yellow
    exit 1
}

# Read project name from pubspec.yaml
$pubspecContent = Get-Content $pubspecPath -Raw
$projectName = "my_flutter_app"
if ($pubspecContent -match "^name:\s*(.+)$") { $projectName = $Matches[1].Trim() }

# ---------------------------------------------
# 2. PRINT BANNER
# ---------------------------------------------
Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Flutter AI Agent Framework -- Per-Project Initializer" -ForegroundColor Cyan
Write-Host "  Flutter AI Agent Skill Framework 2026 v2.1 (.agent/ Mode)" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Project : $projectName" -ForegroundColor Yellow
Write-Host "  Path    : $ProjectPath" -ForegroundColor Yellow
Write-Host "  Source  : $frameworkRoot" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

$agentDir = Join-Path $ProjectPath ".agent"
if (-not (Test-Path $agentDir)) { New-Item -ItemType Directory -Path $agentDir -Force | Out-Null }

# ---------------------------------------------
# 3. COPY CORE GOVERNANCE FILES INTO .agent/
# ---------------------------------------------
Write-Host "[1/6] Copying core governance files into .agent/..." -ForegroundColor Yellow

foreach ($folder in @("core", "tools")) {
    $src = Join-Path $frameworkRoot $folder
    $dst = Join-Path $agentDir $folder
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dst -Recurse -Force
        Write-Host "      [+] .agent/$folder/" -ForegroundColor Green
    }
}

# ---------------------------------------------
# 4. CREATE .agent/ MEMORY FILES (Templates)
# ---------------------------------------------
Write-Host "[2/6] Creating .agent/ memory architecture..." -ForegroundColor Yellow

# Copy the maintained project knowledge-index template.
$srcKI = Join-Path $frameworkRoot "core\templates\knowledge_index.md.template"
if (Test-Path $srcKI) {
    Copy-Item -Path $srcKI -Destination (Join-Path $agentDir "KNOWLEDGE_INDEX.md") -Force
    Write-Host "      [+] .agent/KNOWLEDGE_INDEX.md" -ForegroundColor Green
}

# PROJECT_PROFILE.md -- generate as a fresh template for this project
$today = (Get-Date).ToString("yyyy-MM-dd")
$projectProfile = @"
# PROJECT_PROFILE.md -- Static Project Identity

> Edit this file to match your project. This is the FIRST file any AI Agent reads.

---

## Project Identity

```yaml
ProjectName: "$projectName"
ProjectType: "Flutter Mobile App"  # [Mobile App | SaaS | Desktop | Web | SDK]
InitializedDate: "$today"
FlutterVersion: "3.44.x"
DartVersion: "3.12.x"
```

---

## Technology Stack

```yaml
StateManagement: ""          # REQUIRED: Choose one -- Riverpod | Bloc | Cubit | GetX
Routing: "go_router"
Database: ""                 # Drift | Hive | sqflite | None
Networking: "Dio"            # Dio | None | Supabase | Firebase
Authentication: ""           # Firebase Auth | Supabase Auth | Custom JWT | None
Analytics: ""                # Firebase Analytics | None
CrashReporting: ""           # Firebase Crashlytics | None
UITheme: "Material 3"
```

---

## Architecture

```yaml
Pattern: "Feature-First Clean Architecture"
Layers: "Presentation -> Domain -> Data"
DomainPurity: "ZERO Flutter imports in Domain layer"
ErrorHandling: "Sealed Failure classes + Result pattern"
```

---

## Key Business Domain

*Describe what this app does in 1-2 sentences for AI Agent context:*

> [FILL IN: e.g., "A B2B SaaS platform for inventory management with offline-first sync."]

---

## Active Features

| Feature | Status | State Manager |
|---|---|---|
| Authentication | [ ] Planned | |
| Home | [ ] Planned | |

---

## Notes & Special Rules for AI Agent

- *Add any project-specific rules here*
"@
Set-Content -Path (Join-Path $agentDir "PROJECT_PROFILE.md") -Value $projectProfile -Force
Write-Host "      [+] .agent/PROJECT_PROFILE.md (template ready -- fill in stack details)" -ForegroundColor Green

# CURRENT_STATE.md
$currentState = @"
# CURRENT_STATE.md -- Active Work State

---

## Current Objective

```yaml
ActiveGoal: "[Describe the current task or leave blank until work begins]"
LastUpdated: "$today"
TaskRisk: "[Low / Medium / High based on change impact]"
```

---

## Decision Record

| Type | Record |
|---|---|
| Evidence | Project initialized. Inspect the relevant repository files before recording technical claims. |
| Decisions | No architecture, state-management, database, authentication, or platform choice is assumed. |
| Assumptions | Record only assumptions required for the current task and label them for validation. |
| Open questions | Ask only when an answer could change architecture, security, data, API, dependency, or user-visible behavior. |
| Validation status | No task validation recorded yet. |
| Next action | Inspect the affected project context and choose the smallest relevant workflow. |

> For a reversible low-risk task, state any assumption, make the smallest safe change, and validate it. Use `flutter-grill-me` when unresolved information could change a material decision; do not use a numerical confidence score.

---

## Active Files & Context

- [ ] Record only files and decisions relevant to the active task
- [ ] Update `.agent/PROJECT_PROFILE.md` when project-level facts are confirmed
- [ ] Link a related ADR, issue, test, or release artifact when persistent tracking is useful

---

## Next Actions

1. Inspect the affected feature, `pubspec.yaml`, tests, CI, and relevant `.agent/` records.
2. Select the smallest skill set that covers the task and document material decisions or assumptions.
3. Use product discovery, a PRD, or domain modeling only when the request is a new product, materially ambiguous feature, or non-trivial business change.
4. Record validation evidence and the next handoff action when the work spans sessions or phases.
"@
Set-Content -Path (Join-Path $agentDir "CURRENT_STATE.md") -Value $currentState -Force
Write-Host "      [+] .agent/CURRENT_STATE.md" -ForegroundColor Green

# AGENTS_MEMORY.md
$agentsMemory = @"
# AGENTS_MEMORY.md -- Project Health Ledger

---

## Project Health Meter

```yaml
Health:
  Architecture: "Not started"
  Tests: "Not started"
  Documentation: "Initializing"
  TechnicalDebt: "None"
  Security: "Not started"
  LastVerifiedDate: "$today"
```

---

## Milestones

- [ ] **Milestone 1:** Framework setup & .agent/PROJECT_PROFILE.md complete
- [ ] **Milestone 2:** First feature domain layer complete
- [ ] **Milestone 3:** First feature UI complete with all states
- [ ] **Milestone 4:** First feature tests passing

---

## Lessons Learned

*(Add lessons here as the project evolves)*

---

## Backlog

*(Feature backlog will be added here during sprint planning)*
"@
Set-Content -Path (Join-Path $agentDir "AGENTS_MEMORY.md") -Value $agentsMemory -Force
Write-Host "      [+] .agent/AGENTS_MEMORY.md" -ForegroundColor Green

# SESSION_LOG.md
$sessionLog = @"
# SESSION_LOG.md -- Chronological Session Log

---

## Session: $today

- **Action:** Project initialized with Flutter AI Agent Skill Framework 2026.
- **Source Framework:** awesome-flutter-ai-skills.
- **State location:** `.agent/` stores project context; `.agents/skills/` stores native workspace skills.
- **Status:** Confirm the project profile and first feature before architecture-changing work.
"@
Set-Content -Path (Join-Path $agentDir "SESSION_LOG.md") -Value $sessionLog -Force
Write-Host "      [+] .agent/SESSION_LOG.md" -ForegroundColor Green

# ---------------------------------------------
# 5. COPY ALL RESOURCES INTO .agent/
# ---------------------------------------------
# Resources are now localized in each skill.
# The core/ and tools/ directories were copied in Step 3.

# ---------------------------------------------
# 6. COPY ALL SKILLS INTO .agents/skills/ (official Antigravity path)
# ---------------------------------------------
Write-Host "[4/6] Copying all skills into .agents/skills/..." -ForegroundColor Yellow

$srcSkills = Join-Path $frameworkRoot "skills"
$agentsDir = Join-Path $ProjectPath ".agents"
$dstSkills = Join-Path $agentsDir "skills"

if (Test-Path $srcSkills) {
    if (-not (Test-Path $agentsDir)) { New-Item -ItemType Directory -Path $agentsDir -Force | Out-Null }
    if (Test-Path $dstSkills) { Remove-Item -Path $dstSkills -Recurse -Force }
    New-Item -ItemType Directory -Path $dstSkills -Force | Out-Null

    # Install each discovered skill directly below .agents/skills/. Antigravity
    # discovers skill folders at this level; repository sector folders are source-only.
    $skillDirs = Get-ChildItem -Path $srcSkills -Filter "SKILL.md" -Recurse |
        ForEach-Object { Get-Item $_.DirectoryName } |
        Sort-Object FullName -Unique
    $installedNames = @{}
    foreach ($skillDir in $skillDirs) {
        if ($installedNames.ContainsKey($skillDir.Name)) {
            throw "Duplicate skill directory name '$($skillDir.Name)' cannot be installed directly under .agents/skills/."
        }
        $destination = Join-Path $dstSkills $skillDir.Name
        Copy-Item -Path $skillDir.FullName -Destination $destination -Recurse -Force
        $installedNames[$skillDir.Name] = $true
    }

    $skillCount = $installedNames.Count
    if ($skillCount -eq 0) { throw "No SKILL.md directories were found under $srcSkills." }
    Write-Host "      [+] .agents/skills/ ($skillCount skills; Antigravity default path)" -ForegroundColor Green
}

# ---------------------------------------------
# 7. CREATE IDE & AGENT RULES FILES
# ---------------------------------------------
Write-Host "[5/6] Creating IDE and agent rules..." -ForegroundColor Yellow

$agentRulesCore = @"
# Flutter AI Agent Skill Framework 2026 -- Project Rules
# Project: $projectName | Initialized: $today
#
# CONTEXT:
# For a non-trivial Flutter change, inspect pubspec.yaml, the affected feature,
# and relevant .agent/ state files. Missing optional state files do not block a
# small reversible change; state the assumption and validate the result.
#
# SKILLS:
# Native workspace skills live in .agents/skills/. Select the smallest relevant
# skill set. Inspect both pubspec.yaml and the affected feature before choosing
# Riverpod, Bloc, Cubit, or GetX; flutter_bloc alone does not distinguish Bloc
# from Cubit. Do not introduce a second state approach in one feature without an
# explicit migration plan.
#
# ARCHITECTURE:
# Preserve the target project's architecture. When Clean Architecture is used,
# keep Flutter UI and state-management imports out of Domain and keep UI imports
# out of Data. Cover loading, error, and empty states when the changed flow can
# exhibit them.
#
# DEPENDENCIES:
# Prefer flutter pub commands for ordinary changes. Preserve intentional project
# constraints and read .agent/core/resources/011_dependency_policy.md before a
# material dependency decision.
#
# GOVERNANCE: .agent/core/AGENTS.md
# ROUTING:    .agent/core/ROUTER_MANIFESTO.md
# VERIFY:     dart run .agent/tools/verify_architecture.dart
"@

# .cursorrules
Set-Content -Path (Join-Path $ProjectPath ".cursorrules") -Value $agentRulesCore -Force
Write-Host "      [+] .cursorrules (Cursor IDE)" -ForegroundColor Green

# .windsurfrules
Set-Content -Path (Join-Path $ProjectPath ".windsurfrules") -Value $agentRulesCore -Force
Write-Host "      [+] .windsurfrules (Windsurf IDE)" -ForegroundColor Green

# .clinerules (Roo Code / Cline)
Set-Content -Path (Join-Path $ProjectPath ".clinerules") -Value $agentRulesCore -Force
Write-Host "      [+] .clinerules (Roo Code / Cline)" -ForegroundColor Green

# .codex/instructions.md (OpenAI Codex)
$codexDir = Join-Path $ProjectPath ".codex"
if (-not (Test-Path $codexDir)) { New-Item -ItemType Directory -Path $codexDir -Force | Out-Null }
Set-Content -Path (Join-Path $codexDir "instructions.md") -Value $agentRulesCore -Force
Write-Host "      [+] .codex/instructions.md (OpenAI Codex)" -ForegroundColor Green

# .github/copilot-instructions.md (GitHub Copilot)
$githubDir = Join-Path $ProjectPath ".github"
if (-not (Test-Path $githubDir)) { New-Item -ItemType Directory -Path $githubDir -Force | Out-Null }
Set-Content -Path (Join-Path $githubDir "copilot-instructions.md") -Value $agentRulesCore -Force
Write-Host "      [+] .github/copilot-instructions.md (GitHub Copilot)" -ForegroundColor Green

# Antigravity discovers this project's skills from .agents/skills/.
# Do not inject project context into a global Knowledge Item location: doing so
# can leak stale project context across workspaces and is not required for skill discovery.

# ---------------------------------------------
# 8. VERIFY INSTALLATION
# ---------------------------------------------
Write-Host "[6/6] Verifying project state and native skills..." -ForegroundColor Yellow

$checks = @(
    @{ Path = (Join-Path $agentDir "core/AGENTS.md");              Label = ".agent/core/AGENTS.md" },
    @{ Path = (Join-Path $agentDir "core/ROUTER_MANIFESTO.md");    Label = ".agent/core/ROUTER_MANIFESTO.md" },
    @{ Path = (Join-Path $agentDir "PROJECT_PROFILE.md");          Label = ".agent/PROJECT_PROFILE.md" },
    @{ Path = (Join-Path $agentDir "KNOWLEDGE_INDEX.md");          Label = ".agent/KNOWLEDGE_INDEX.md" },
    @{ Path = (Join-Path $agentDir "CURRENT_STATE.md");            Label = ".agent/CURRENT_STATE.md" },
    @{ Path = (Join-Path $agentsDir "skills");                     Label = ".agents/skills/" },
    @{ Path = (Join-Path $dstSkills "flutter-agent-evaluation/SKILL.md"); Label = ".agents/skills/flutter-agent-evaluation/SKILL.md" },
    @{ Path = (Join-Path $agentDir "tools");                       Label = ".agent/tools/" },
    @{ Path = (Join-Path $ProjectPath ".cursorrules");             Label = ".cursorrules" },
    @{ Path = (Join-Path $githubDir "copilot-instructions.md");       Label = ".github/copilot-instructions.md" }
)

$allPassed = $true
foreach ($check in $checks) {
    if (Test-Path $check.Path) {
        Write-Host "      [OK] $($check.Label)" -ForegroundColor Green
    } else {
        Write-Host "      [FAIL] $($check.Label)" -ForegroundColor Red
        $allPassed = $false
    }
}

# Cleanup temp clone if used
if ($tempCloned -and (Test-Path $frameworkRoot)) {
    Remove-Item -Path $frameworkRoot -Recurse -Force
}

# ---------------------------------------------
# 9. NEXT STEPS
# ---------------------------------------------
Write-Host ""
if ($allPassed) {
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "  [SUCCESS] Flutter AI Agent Framework initialized successfully!" -ForegroundColor Green
    Write-Host "  Project: $projectName | State: .agent/ | Skills: .agents/skills/" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
} else {
    Write-Host "============================================================" -ForegroundColor Yellow
    Write-Host "  [WARN] Some files failed to create. Check errors above." -ForegroundColor Yellow
    Write-Host "============================================================" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  [NEXT STEPS]:" -ForegroundColor Cyan
Write-Host "  1. Open .agent/PROJECT_PROFILE.md and fill in:" -ForegroundColor White
Write-Host "     - StateManagement (Riverpod | Bloc | Cubit | GetX)" -ForegroundColor Gray
Write-Host "     - Database, Networking, Authentication choices" -ForegroundColor Gray
Write-Host "     - Project description for AI Agent context" -ForegroundColor Gray
Write-Host "  2. Record evidence, assumptions, and open questions in .agent/CURRENT_STATE.md" -ForegroundColor White
Write-Host "  3. Use 'flutter-grill-me' when uncertainty can change a material decision" -ForegroundColor White
Write-Host "  4. Start building with: 'create the [feature] feature'" -ForegroundColor White
Write-Host ""
Write-Host "  [SKILLS]:   .agents/skills/ (native Antigravity workspace skills)" -ForegroundColor Cyan
Write-Host "  [VERIFY]:   dart run .agent/tools/verify_architecture.dart" -ForegroundColor Cyan
Write-Host "  [PACKAGES]: Prefer Flutter pub commands; review ADR-011 for material changes" -ForegroundColor Cyan
Write-Host ""
