# ============================================================
# Flutter AI Agent Framework -- Per-Project Initializer
# Version: 2.1.0 | Date: 2026-07-27
#
# PURPOSE:
#   Injects the full Flutter AI Agent Skill Framework into any
#   Flutter project directory so that ALL AI agents (Antigravity,
#   Gemini, Claude, Cursor, Windsurf, Copilot, Codex, Roo) work
#   with the complete framework locally -- per project.
#   ALL resources and governance files are cleanly placed inside
#   the .agent/ folder without cluttering the project root!
#
# USAGE (from inside your Flutter project root):
#   .\path\to\flutter-skills\init-project.ps1
#
# USAGE (specify project path explicitly):
#   .\init-project.ps1 -ProjectPath "D:\Projects\my_flutter_app"
#
# USAGE (one-line from GitHub, run inside project dir):
#   irm https://raw.githubusercontent.com/laith-alskaf/awesome-flutter-ai-skills/main/tools/init-project.ps1 | iex
#
# WHAT IT CREATES (Unified inside .agent/ directory):
#   .agent/core/AGENTS.md            -> Framework governance rules
#   .agent/core/ROUTER_MANIFESTO.md  -> Agent routing & skill matrix
#   .agent/core/PERSONAS.md          -> The 5 AI Personas definitions
#   .agent/PROJECT_PROFILE.md        -> Project identity (edit this!)
#   .agent/KNOWLEDGE_INDEX.md        -> Navigation map to all skills
#   .agent/CURRENT_STATE.md          -> Session confidence tracker
#   .agent/AGENTS_MEMORY.md          -> Project health ledger
#   .agent/SESSION_LOG.md            -> Chronological session log
#   .agent/skills/                   -> All 51 modular skills (local copy)
#   .agent/tools/                    -> Executable OS Utilities
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

# ---------------------------------------------
# 1. RESOLVE PATHS
# ---------------------------------------------

# Determine the flutter-skills framework source directory
$scriptDir = $PSScriptRoot
if ([string]::IsNullOrEmpty($scriptDir)) { $scriptDir = Get-Location }

$frameworkRoot = $scriptDir
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

# Copy KNOWLEDGE_INDEX from template or generated source
$srcKI = Join-Path $frameworkRoot "core\templates\knowledge_index.md.template"
if (-not (Test-Path $srcKI)) { $srcKI = Join-Path $frameworkRoot ".ai\KNOWLEDGE_INDEX.md" }
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
# CURRENT_STATE.md -- Active Session State

---

## Current Objective

```yaml
ActiveGoal: "Project initialization and first feature planning"
LastUpdated: "$today"
CurrentMilestone: "Milestone 0: Framework Setup"
```

---

## Confidence Matrix

```yaml
Confidence:
  level: Low       # [High, Medium, Low] -- Update as requirements are locked
  score: 0.50      # Start low; raise as requirements are clarified via flutter-grill-me
  reason: "Project just initialized. PROJECT_PROFILE.md needs to be filled in."
```

> [!WARNING]
> Confidence score is 0.50 -- below 0.80 threshold.
> The AI Agent MUST invoke **flutter-grill-me** before generating any code.
> Fill in PROJECT_PROFILE.md first, then update this score.

---

## Active Files & Context

- [ ] Fill in `.agent/PROJECT_PROFILE.md` with project details
- [ ] Define state management library choice
- [ ] Define first feature to build

---

## Next Actions

1. Complete `.agent/PROJECT_PROFILE.md` (StateManagement, Database, Auth, etc.)
2. Run `flutter-grill-me` to lock requirements for first feature
3. Run `flutter-product-discovery-and-architecture` for PRD scaffolding
4. Run `flutter-domain-modeling` to define domain entities
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

- **Action:** Project initialized with Flutter AI Agent Skill Framework 2026 (.agent/ mode)
- **Source Framework:** awesome-flutter-ai-skills
- **Status:** .agent/PROJECT_PROFILE.md needs to be filled in before first feature work.
"@
Set-Content -Path (Join-Path $agentDir "SESSION_LOG.md") -Value $sessionLog -Force
Write-Host "      [+] .agent/SESSION_LOG.md" -ForegroundColor Green

# ---------------------------------------------
# 5. COPY ALL RESOURCES INTO .agent/
# ---------------------------------------------
# Resources are now localized in each skill.
# The core/ and tools/ directories were copied in Step 3.

# ---------------------------------------------
# 6. COPY ALL 51 skills INTO .agent/skills/
# ---------------------------------------------
Write-Host "[4/6] Copying all 51 skills directly into .agent/skills/..." -ForegroundColor Yellow

$srcSkills = Join-Path $frameworkRoot "skills"
$dstSkills = Join-Path $agentDir "skills"

if (Test-Path $srcSkills) {
    if (Test-Path $dstSkills) { Remove-Item -Path $dstSkills -Recurse -Force }
    Copy-Item -Path $srcSkills -Destination $dstSkills -Recurse -Force
    $skillCount = (Get-ChildItem -Path $dstSkills -Filter "SKILL.md" -Recurse).Count
    Write-Host "      [+] .agent/skills/ ($skillCount skills)" -ForegroundColor Green
}

# ---------------------------------------------
# 7. CREATE IDE & AGENT RULES FILES
# ---------------------------------------------
Write-Host "[5/6] Creating IDE & agent rules files (pointing to .agent/)..." -ForegroundColor Yellow

$agentRulesCore = @"
# Flutter AI Agent Skill Framework 2026 -- Project Rules (.agent/ Mode)
# Project: $projectName | Initialized: $today
#
# MANDATORY AGENT PROTOCOL:
# 1. Read .agent/PROJECT_PROFILE.md FIRST (project identity & stack)
# 2. Read .agent/core/AGENTS.md (governance laws & quality standards)
# 3. Read .agent/core/PERSONAS.md (determine active persona)
# 4. Read .agent/CURRENT_STATE.md (confidence matrix -- if < 0.80, trigger flutter-grill-me)
# 5. Check .agent/KNOWLEDGE_INDEX.md (skill navigation map)
# 6. Check pubspec.yaml (active state management library detection)
#
# ZERO HALLUCINATION GATE:
# Output a Context Parity Header before ANY code generation:
#   [OK] .agent/PROJECT_PROFILE.md: Read | Stack: Flutter 3.44 / [StateLib]
#   [OK] .agent/core/AGENTS.md: Read | Architecture: Feature-First Clean Architecture
#   [OK] .agent/CURRENT_STATE.md: Read | Confidence: [score]
#   [OK] Active Persona: [Tech Lead | CPO | Principal Architect | Staff Engineer | QA/SecOps]
#   [OK] State Management: Detected [Riverpod|Bloc|Cubit|GetX] from pubspec.yaml
#   [OK] Skill(s) Activated: [skill-name]
#   [OK] Grill-Me Gate: [PASSED (>=0.80) | TRIGGERED]
# If Confidence < 0.80 -> STOP. Invoke flutter-grill-me first.
#
# STATE MATRIX FIREWALL:
# Riverpod detected -> LOCK OUT Bloc, Cubit, GetX skills
# Bloc detected -> LOCK OUT Riverpod, GetX skills
# GetX detected -> LOCK OUT Riverpod, Bloc, Cubit skills
#
# ARCHITECTURE RULES:
# - Clean Architecture: Presentation -> Domain -> Data (strict)
# - Domain layer: ZERO Flutter/Riverpod/Bloc/Dio/Drift imports
# - Data layer: ZERO Flutter UI widget imports
# - Repository interfaces: always return Result<T, Failure>, never throw
# - State: immutable (freezed or Dart 3 sealed classes)
# - All screens: handle loading, error, empty, and data states
#
# DEPENDENCY POLICY (ADR-011):
# ALWAYS use: flutter pub add <package>  (never edit pubspec.yaml manually)
# Check 7 criteria before ANY new package: Score>=120, Verified publisher,
# Active<12mo, Null-safe, Platform-compatible, MIT/BSD/Apache license, No CVEs
#
# OS KERNEL:       .agent/core/ (AGENTS.md, PERSONAS.md, ROUTER_MANIFESTO.md)
# SKILLS LOCATION: .agent/skills/ (Modular skills containing templates and resources)
# VERIFY ARCH:     dart run .agent/tools/verify_architecture.dart
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

# Antigravity Knowledge Item (KI) Auto-Injection
$antigravityDir = Join-Path $env:USERPROFILE ".gemini\antigravity\knowledge"
if (Test-Path $antigravityDir) {
    # Replace invalid characters in project name for folder name
    $safeProjectName = $projectName -replace '[^a-zA-Z0-9_\-]', '_'
    $kiProjectDir = Join-Path $antigravityDir "project_context_$safeProjectName"
    if (-not (Test-Path $kiProjectDir)) { New-Item -ItemType Directory -Path $kiProjectDir -Force | Out-Null }
    
    # Standardized Knowledge Item format for Antigravity OS
    $kiMetadata = @"
{
  "title": "Flutter Framework Context: $projectName",
  "summary": "Whenever working in this project, you MUST strictly follow the '8-Step Context Recovery Priority Protocol' defined in `.agent/core/AGENTS.md`. Furthermore, as mandated by `.agent/core/ROUTER_MANIFESTO.md`, before generating or modifying ANY Dart/Flutter code, you MUST output the 'Context Parity Header' (verifying you read `.agent/PROJECT_PROFILE.md`, `AGENTS.md`, and `CURRENT_STATE.md`). If Confidence < 0.80, you must trigger `flutter-grill-me`.",
  "references": [
    "$($ProjectPath.Replace('\', '/'))/.agent/core/AGENTS.md",
    "$($ProjectPath.Replace('\', '/'))/.agent/core/ROUTER_MANIFESTO.md",
    "$($ProjectPath.Replace('\', '/'))/.agent/PROJECT_PROFILE.md"
  ]
}
"@
    Set-Content -Path (Join-Path $kiProjectDir "metadata.json") -Value $kiMetadata -Force
    Write-Host "      [+] ~/.gemini/antigravity/knowledge/... (Antigravity KI Injected)" -ForegroundColor Green
}

# ---------------------------------------------
# 8. VERIFY INSTALLATION
# ---------------------------------------------
Write-Host "[6/6] Verifying installation in .agent/..." -ForegroundColor Yellow

$checks = @(
    @{ Path = (Join-Path $agentDir "core/AGENTS.md");              Label = ".agent/core/AGENTS.md" },
    @{ Path = (Join-Path $agentDir "core/ROUTER_MANIFESTO.md");    Label = ".agent/core/ROUTER_MANIFESTO.md" },
    @{ Path = (Join-Path $agentDir "PROJECT_PROFILE.md");          Label = ".agent/PROJECT_PROFILE.md" },
    @{ Path = (Join-Path $agentDir "KNOWLEDGE_INDEX.md");          Label = ".agent/KNOWLEDGE_INDEX.md" },
    @{ Path = (Join-Path $agentDir "CURRENT_STATE.md");            Label = ".agent/CURRENT_STATE.md" },
    @{ Path = (Join-Path $agentDir "skills");                      Label = ".agent/skills/" },
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
    Write-Host "  Project: $projectName | All resources unified in .agent/" -ForegroundColor Green
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
Write-Host "  2. Raise confidence score in .agent/CURRENT_STATE.md to >= 0.80" -ForegroundColor White
Write-Host "  3. Ask your AI Agent to 'run flutter-grill-me' to lock requirements" -ForegroundColor White
Write-Host "  4. Start building with: 'create the [feature] feature'" -ForegroundColor White
Write-Host ""
Write-Host "  [SKILLS]:   .agent/skills/ (51 modular skills available offline)" -ForegroundColor Cyan
Write-Host "  [VERIFY]:   dart run .agent/tools/verify_architecture.dart" -ForegroundColor Cyan
Write-Host "  [PACKAGES]: Always use 'flutter pub add <package>' (ADR-011)" -ForegroundColor Cyan
Write-Host ""
