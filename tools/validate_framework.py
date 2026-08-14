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


def validate_metadata(skill_file: Path) -> None:
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


def validate_repository_contracts(skill_count: int) -> None:
    readme = (ROOT / "README.md").read_text(encoding="utf-8-sig")
    if f"AI%20Skills-{skill_count}%20Orthogonal" not in readme:
        fail("README.md: skill-count badge does not match the discovered skill count.")
    if f"The {skill_count} skills Directory Summary" not in readme:
        fail("README.md: skill-directory summary count does not match the discovered skill count.")
    forbidden = {
        ".ai/": "obsolete .ai project-state path",
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
    if not (ROOT / ".agents" / "rules" / "flutter-agent-framework.md").exists():
        fail("Missing .agents/rules/flutter-agent-framework.md workspace rule.")
    gitignore = (ROOT / ".gitignore").read_text(encoding="utf-8-sig")
    if "!.agents/rules/flutter-agent-framework.md" not in gitignore:
        fail(".gitignore must allow the shipped .agents/rules/flutter-agent-framework.md rule.")
    initializer = (ROOT / "tools" / "init-project.ps1").read_text(encoding="utf-8-sig")
    if ".agents/skills/" not in initializer:
        fail("tools/init-project.ps1 does not install native .agents/skills/." )
    if "SKILLS LOCATION: .agent/skills/" in initializer:
        fail("tools/init-project.ps1 still advertises the legacy .agent/skills/ location.")
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


def main() -> int:
    if not SKILLS_ROOT.exists():
        fail("skills directory not found.")
    skill_files = sorted(SKILLS_ROOT.glob("*/*/SKILL.md"))
    if not skill_files:
        fail("No skills found at skills/<sector>/<skill>/SKILL.md.")
    names = [validate_skill(skill_file) for skill_file in skill_files]
    for skill_file in skill_files:
        validate_metadata(skill_file)
    for name, count in Counter(names).items():
        if count > 1:
            fail(f"Duplicate skill name: {name!r} appears {count} times.")
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
