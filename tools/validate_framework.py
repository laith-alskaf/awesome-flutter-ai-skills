#!/usr/bin/env python3
"""Validate the repository's Agent Skills and installation contracts.

Run from any directory with: python3 tools/validate_framework.py
The validator intentionally uses only the Python standard library so contributors
can run it before publishing a skill change.
"""
from __future__ import annotations

import re
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS_ROOT = ROOT / "skills"
ROUTING_SCENARIOS = ROOT / "evaluation" / "routing-scenarios.yaml"
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
FRONTMATTER_PATTERN = re.compile(r"\A---\r?\n(.*?)\r?\n---(?:\r?\n|\Z)", re.DOTALL)
MARKDOWN_LINK_PATTERN = re.compile(r"(?<!!)(?<!\\!)\[[^\]]*\]\(([^)\s]+)(?:\s+[^)]*)?\)")

errors: list[str] = []
warnings: list[str] = []


def fail(message: str) -> None:
    errors.append(message)


def warn(message: str) -> None:
    warnings.append(message)


def scalar(frontmatter: str, key: str) -> str | None:
    """Extract a simple or folded YAML scalar without requiring a YAML package."""
    lines = frontmatter.splitlines()
    prefix = f"{key}:"
    for index, line in enumerate(lines):
        if not line.startswith(prefix):
            continue
        value = line[len(prefix):].strip()
        if value in {">", "|", ">-", "|-", ">+", "|+"}:
            continuation: list[str] = []
            for next_line in lines[index + 1:]:
                if next_line and not next_line.startswith((" ", "\t")):
                    break
                if next_line.strip():
                    continuation.append(next_line.strip())
            return " ".join(continuation).strip()
        return value.strip("'\"")
    return None


def path_from_markdown_link(document: Path, raw_link: str) -> Path | None:
    link = raw_link.split("#", 1)[0].split("?", 1)[0].strip("<>")
    if not link or link.startswith(("#", "http://", "https://", "mailto:")):
        return None
    if link.startswith(("~", "/")) or "${" in link:
        return None
    return (document.parent / link).resolve()


def validate_skill(skill_file: Path) -> str:
    skill_dir = skill_file.parent
    text = skill_file.read_text(encoding="utf-8-sig")
    relative = skill_file.relative_to(ROOT).as_posix()
    match = FRONTMATTER_PATTERN.match(text)
    if not match:
        fail(f"{relative}: SKILL.md must start with YAML frontmatter.")
        return skill_dir.name
    frontmatter = match.group(1)
    name = scalar(frontmatter, "name")
    description = scalar(frontmatter, "description")
    if not name:
        fail(f"{relative}: frontmatter requires a non-empty name.")
    elif name != skill_dir.name:
        fail(f"{relative}: frontmatter name {name!r} must match directory {skill_dir.name!r}.")
    elif len(name) > 64 or not NAME_PATTERN.fullmatch(name):
        fail(f"{relative}: name must be lowercase hyphenated and no longer than 64 characters.")
    if not description:
        fail(f"{relative}: frontmatter requires a non-empty description.")
    elif len(description) > 1024:
        fail(f"{relative}: description exceeds the 1024-character Agent Skills limit.")
    elif not re.search(r"\b(use|when|for)\b", description, flags=re.IGNORECASE):
        warn(f"{relative}: description should state when the skill is used.")
    if len(text.splitlines()) > 500:
        fail(f"{relative}: SKILL.md exceeds 500 lines; move rare detail into local resources.")
    if "## Checklist" not in text and "## Validation" not in text and "## Acceptance" not in text:
        warn(f"{relative}: consider adding a checklist or validation section.")
    return name or skill_dir.name


def metadata_dependency_names(text: str) -> list[str]:
    """Extract simple YAML dependency lists without adding a runtime dependency."""
    values: list[str] = []
    active: str | None = None
    for line in text.splitlines():
        header = re.match(r"^  (requires|conflicts_with|optional):\s*(.*)$", line)
        if header:
            active, inline = header.groups()
            inline = inline.strip()
            if inline.startswith("[") and inline.endswith("]"):
                values.extend(item.strip().strip("'\\\"") for item in inline[1:-1].split(",") if item.strip())
            elif inline:
                values.append(inline.strip("'\\\""))
            continue
        child = re.match(r"^    -\s+(.+)$", line)
        if child and active is not None:
            values.append(child.group(1).strip().strip("'\\\""))
        elif line and not line.startswith(" "):
            active = None
    return values


def validate_metadata(skill_file: Path, known_skills: set[str]) -> None:
    metadata = skill_file.parent / "metadata.yaml"
    relative = skill_file.parent.relative_to(ROOT).as_posix()
    if not metadata.exists():
        fail(f"{relative}: missing metadata.yaml.")
        return
    text = metadata.read_text(encoding="utf-8-sig")
    required = ("name", "version", "owner", "flutter_version_min", "active_persona")
    for key in required:
        if scalar(text, key) is None:
            fail(f"{metadata.relative_to(ROOT)}: missing required metadata field {key!r}.")
    if scalar(text, "name") != skill_file.parent.name:
        fail(f"{metadata.relative_to(ROOT)}: metadata name must match the skill directory.")
    if not re.search(r"(?m)^dependencies:\s*$", text):
        fail(f"{metadata.relative_to(ROOT)}: missing dependencies mapping.")
        return
    for key in ("requires", "conflicts_with", "optional"):
        if not re.search(rf"(?m)^  {re.escape(key)}:\s*(?:\[.*\])?$", text):
            fail(f"{metadata.relative_to(ROOT)}: dependencies.{key} must be present.")
    for dependency in metadata_dependency_names(text):
        if dependency not in known_skills:
            fail(f"{metadata.relative_to(ROOT)}: dependency references unknown skill {dependency!r}.")


def validate_markdown_links() -> None:
    for document in ROOT.rglob("*.md"):
        if ".git" in document.parts:
            continue
        text = document.read_text(encoding="utf-8-sig")
        for raw_link in MARKDOWN_LINK_PATTERN.findall(text):
            target = path_from_markdown_link(document, raw_link)
            if target is None:
                continue
            try:
                target.relative_to(ROOT)
            except ValueError:
                continue
            if not target.exists():
                fail(f"{document.relative_to(ROOT)}: linked local file is absent: {raw_link}")


def validate_routing_scenarios(known_skills: set[str]) -> None:
    """Validate the intentionally small YAML subset used by routing fixtures."""
    if not ROUTING_SCENARIOS.exists():
        fail("Missing evaluation/routing-scenarios.yaml.")
        return
    lines = ROUTING_SCENARIOS.read_text(encoding="utf-8-sig").splitlines()
    if not any(line.strip() == "schema_version: 1" for line in lines):
        fail("evaluation/routing-scenarios.yaml: schema_version must be 1.")

    scenarios: list[dict[str, object]] = []
    current: dict[str, object] | None = None
    folded_field: str | None = None
    list_field: str | None = None
    scalar_fields = {"primary_skill"}
    folded_fields = {"request", "expected_strategy"}
    list_fields = {"supporting_skills", "forbidden_skills"}

    for raw in lines:
        if raw.startswith("  - id:"):
            if current is not None:
                scenarios.append(current)
            current = {"id": raw.split(":", 1)[1].strip(), "supporting_skills": [], "forbidden_skills": []}
            folded_field = None
            list_field = None
            continue
        if current is None:
            continue
        match = re.match(r"^    ([a-z_]+):\s*(.*)$", raw)
        if match:
            field, value = match.groups()
            folded_field = None
            list_field = None
            if field in scalar_fields:
                current[field] = value.strip("'\\\"")
            elif field in folded_fields:
                current[field] = ""
                folded_field = field if value in {">", "|", ">-", "|-"} else None
                if folded_field is None:
                    current[field] = value.strip("'\\\"")
            elif field in list_fields:
                current[field] = [] if value == "[]" else []
                list_field = field if value != "[]" else None
            continue
        list_match = re.match(r"^      -\s+(.+)$", raw)
        if list_match and list_field is not None:
            cast_list = current[list_field]
            if isinstance(cast_list, list):
                cast_list.append(list_match.group(1).strip("'\\\""))
            continue
        if folded_field is not None and raw.startswith("      "):
            current[folded_field] = f"{current[folded_field]} {raw.strip()}".strip()
            continue
        if raw.strip():
            folded_field = None
            list_field = None

    if current is not None:
        scenarios.append(current)
    if len(scenarios) < 10:
        fail("evaluation/routing-scenarios.yaml: at least 10 representative scenarios are required.")

    ids: set[str] = set()
    primary_skills: set[str] = set()
    for index, scenario in enumerate(scenarios, start=1):
        identifier = str(scenario.get("id", ""))
        if not identifier or not NAME_PATTERN.fullmatch(identifier):
            fail(f"evaluation/routing-scenarios.yaml: scenario {index} has invalid id {identifier!r}.")
        elif identifier in ids:
            fail(f"evaluation/routing-scenarios.yaml: duplicate scenario id {identifier!r}.")
        ids.add(identifier)
        for field in ("request", "primary_skill", "expected_strategy"):
            if not str(scenario.get(field, "")).strip():
                fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} requires {field!r}.")
        primary = str(scenario.get("primary_skill", ""))
        primary_skills.add(primary)
        if primary not in known_skills:
            fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} references unknown primary skill {primary!r}.")
        support = scenario.get("supporting_skills", [])
        forbidden = scenario.get("forbidden_skills", [])
        if not isinstance(support, list) or not isinstance(forbidden, list):
            fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} has invalid skill lists.")
            continue
        if len(support) != len(set(support)) or len(forbidden) != len(set(forbidden)):
            fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} repeats a listed skill.")
        for skill in [*support, *forbidden]:
            if skill not in known_skills:
                fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} references unknown skill {skill!r}.")
        if primary in support or primary in forbidden:
            fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} repeats its primary skill in another role.")
        if set(support) & set(forbidden):
            fail(f"evaluation/routing-scenarios.yaml: scenario {identifier!r} has a skill that is both supporting and forbidden.")

    for required_primary in {"flutter-workspace-architecture", "flutter-dependency-upgrade", "flutter-api-contract-evolution", "flutter-agent-evaluation"}:
        if required_primary not in primary_skills:
            fail(f"evaluation/routing-scenarios.yaml: no scenario has {required_primary!r} as its primary skill.")


def validate_repository_contracts(skill_count: int) -> None:
    readme = (ROOT / "README.md").read_text(encoding="utf-8-sig")
    if f"AI%20Skills-{skill_count}%20Orthogonal" not in readme:
        fail("README.md: skill-count badge does not match the discovered skill count.")
    if f"The {skill_count} skills Directory Summary" not in readme:
        fail("README.md: skill-directory summary count does not match the discovered skill count.")
    forbidden = {
        ".ai/": "obsolete .ai project-state path",
        ".ai\\\\": "obsolete Windows-style .ai project-state path",
        ".gemini/antigravity/skills": "undocumented Antigravity global skill path",
    }
    tracked_text = "\n".join(
        path.read_text(encoding="utf-8-sig")
        for path in ROOT.rglob("*")
        if path.is_file() and path.resolve() != Path(__file__).resolve() and ".git" not in path.parts and path.suffix.lower() in {".md", ".ps1", ".py", ".yaml", ".yml"}
    )
    for token, label in forbidden.items():
        if token in tracked_text:
            fail(f"Repository contains {label}: {token}")
    required_rules = ("flutter-agent-framework.md", "flutter-agent-evaluation.md")
    gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8-sig")
    for rule in required_rules:
        if not (ROOT / ".agents" / "rules" / rule).exists():
            fail(f"Missing .agents/rules/{rule} workspace rule.")
        if f"!.agents/rules/{rule}" not in gitignore:
            fail(f".gitignore must allow the shipped .agents/rules/{rule} rule.")
    initializer = (ROOT / "tools" / "init-project.ps1").read_text(encoding="utf-8-sig")
    if ".agents/skills/" not in initializer:
        fail("tools/init-project.ps1 does not install native .agents/skills/." )
    if "SKILLS LOCATION: .agent/skills/" in initializer:
        fail("tools/init-project.ps1 still advertises the legacy .agent/skills/ location.")
    required_initializer_tokens = (
        '$skillDirs = Get-ChildItem -Path $srcSkills -Filter "SKILL.md" -Recurse',
        "$installedNames = @{}",
        "Join-Path $dstSkills $skillDir.Name",
        "flutter-agent-evaluation/SKILL.md",
    )
    for token in required_initializer_tokens:
        if token not in initializer:
            fail(f"tools/init-project.ps1: missing direct-skill installation contract {token!r}.")
    if "Copy-Item -Path $srcSkills -Destination $dstSkills -Recurse -Force" in initializer:
        fail("tools/init-project.ps1: skills source must not be copied as a nested directory.")
    for script in (ROOT / "tools").glob("*.ps1"):
        script_text = script.read_text(encoding="utf-8-sig")
        if "Set-StrictMode -Version Latest" not in script_text:
            fail(f"{script.relative_to(ROOT)}: Set-StrictMode is required.")
        if "$ErrorActionPreference" not in script_text:
            fail(f"{script.relative_to(ROOT)}: explicit error handling is required.")

    deploy = (ROOT / "tools" / "deploy.ps1").read_text(encoding="utf-8-sig")
    required_deploy_tokens = (
        "[CmdletBinding(SupportsShouldProcess = $true",
        "function Get-UserHome",
        "Split-Path -Parent $PSScriptRoot",
        ".gemini/config/skills",
        ".agents/skills",
        ".awesome-flutter-ai-skills-managed",
        "Restore-SkillBackup",
    )
    for token in required_deploy_tokens:
        if token not in deploy:
            fail(f"tools/deploy.ps1: missing deployment safety contract {token!r}.")
    if "| iex" in deploy.lower() or "Invoke-Expression" in deploy:
        fail("tools/deploy.ps1: remote dynamic evaluation is not permitted.")

    uninstall = (ROOT / "tools" / "uninstall-global.ps1").read_text(encoding="utf-8-sig")
    for token in ("[CmdletBinding(SupportsShouldProcess = $true", "[switch]$Force", ".awesome-flutter-ai-skills-managed"):
        if token not in uninstall:
            fail(f"tools/uninstall-global.ps1: missing uninstall safety contract {token!r}.")

    workflow = ROOT / ".github" / "workflows" / "validate-framework.yml"
    if not workflow.exists():
        fail("Missing .github/workflows/validate-framework.yml continuous-validation workflow.")
    else:
        workflow_text = workflow.read_text(encoding="utf-8-sig")
        required_workflow_tokens = (
            "python3 tools/validate_framework.py",
            "windows-latest",
            "init-project.ps1",
            "deploy.ps1\" -WhatIf",
            "uninstall-global.ps1\" -Force -WhatIf",
            ".agents\\skills\\flutter-agent-evaluation\\SKILL.md",
            "Skills were nested under an unsupported source directory",
            "Expected 55 directly installed skills",
        )
        for token in required_workflow_tokens:
            if token not in workflow_text:
                fail(f".github/workflows/validate-framework.yml: missing CI smoke-test contract {token!r}.")


def main() -> int:
    if not SKILLS_ROOT.exists():
        fail("skills directory not found.")
    skill_files = sorted(SKILLS_ROOT.glob("*/*/SKILL.md"))
    if not skill_files:
        fail("No skills found at skills/<sector>/<skill>/SKILL.md.")
    names = [validate_skill(skill_file) for skill_file in skill_files]
    known_skills = set(names)
    for skill_file in skill_files:
        validate_metadata(skill_file, known_skills)
    for name, count in Counter(names).items():
        if count > 1:
            fail(f"Duplicate skill name: {name!r} appears {count} times.")
    validate_routing_scenarios(set(names))
    validate_markdown_links()
    validate_repository_contracts(len(skill_files))

    print(f"Validated {len(skill_files)} skills.")
    for message in warnings:
        print(f"WARNING: {message}")
    for message in errors:
        print(f"ERROR: {message}")
    if errors:
        print(f"Validation failed with {len(errors)} error(s) and {len(warnings)} warning(s).")
        return 1
    print(f"Validation passed with {len(warnings)} warning(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
