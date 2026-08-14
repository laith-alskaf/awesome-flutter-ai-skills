# Flutter Agent Framework Repository Maintenance

Use this rule when editing this repository itself. This repository packages agent skills; it is **not** a Flutter application, so do not require `pubspec.yaml`, `.agent/PROJECT_PROFILE.md`, or an application context header before maintaining the framework.

Read the affected `SKILL.md`, its `metadata.yaml`, and any referenced resource before changing a skill. Preserve the Agent Skills contract: a lowercase hyphenated directory name, a matching frontmatter `name`, and a precise `description` that states both capability and trigger context. Keep each `SKILL.md` focused and move uncommon detail to the skill’s local `resources/` or `templates/` directory.

When changing installation or compatibility behavior, keep `.agents/skills` as the default Antigravity workspace skill location. Treat `.agent/` only as the project-state and legacy-compatibility location. Update the initializer, deployment script, documentation, and validation checks together; never modify one contract in isolation.

Before finalizing a repository change, run `python3 tools/validate_framework.py` from the repository root. Report assumptions, validation results, and any unverified platform-specific behavior. Do not claim that a skill was discovered by a particular IDE unless the documented path and installation checks support that claim.
