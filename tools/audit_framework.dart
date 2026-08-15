import 'dart:io';

/// Lightweight, dependency-free framework audit.
///
/// Run from the framework repository or an initialized Flutter project:
///   dart run .agents/tools/audit_framework.dart [project-or-framework-root]
/// For the full repository contract, run `python3 tools/validate_framework.py`
/// in the framework repository.
void main(List<String> args) {
  final root = Directory(args.isNotEmpty ? args.first : Directory.current.path);
  if (!root.existsSync()) {
    stderr.writeln('ERROR: Directory not found: ${root.path}');
    exitCode = 1;
    return;
  }

  final skillsDir = _findSkillsDirectory(root);
  if (skillsDir == null) {
    stderr.writeln(
      'ERROR: No skills directory found. Expected skills/, .agents/skills/, or .agents/skills/.',
    );
    exitCode = 1;
    return;
  }

  var errors = 0;
  var warnings = 0;
  var skillCount = 0;
  final names = <String>{};

  for (final entity in skillsDir.listSync(recursive: true)) {
    if (entity is! File || entity.uri.pathSegments.last != 'SKILL.md') {
      continue;
    }

    skillCount++;
    final skillDir = entity.parent;
    final skillName = skillDir.uri.pathSegments[skillDir.uri.pathSegments.length - 2];
    final content = entity.readAsStringSync();
    final metadata = File('${skillDir.path}${Platform.pathSeparator}metadata.yaml');

    if (!metadata.existsSync()) {
      stderr.writeln('ERROR [$skillName]: Missing metadata.yaml.');
      errors++;
    } else {
      final metadataText = metadata.readAsStringSync().replaceFirst('\uFEFF', '');
      for (final field in const [
        'name:',
        'version:',
        'owner:',
        'flutter_version_min:',
        'dependencies:',
        'active_persona:',
      ]) {
        if (!metadataText.contains(field)) {
          stderr.writeln('ERROR [$skillName]: metadata.yaml is missing $field');
          errors++;
        }
      }
      if (!metadataText.contains('name: $skillName')) {
        stderr.writeln('ERROR [$skillName]: metadata name must match the directory.');
        errors++;
      }
    }

    final frontmatter = RegExp(r'^---\r?\n([\s\S]*?)\r?\n---', multiLine: false)
        .firstMatch(content.replaceFirst('\uFEFF', ''));
    if (frontmatter == null) {
      stderr.writeln('ERROR [$skillName]: SKILL.md must start with YAML frontmatter.');
      errors++;
      continue;
    }
    final header = frontmatter.group(1)!;
    if (!header.contains('name: $skillName')) {
      stderr.writeln('ERROR [$skillName]: frontmatter name must match the directory.');
      errors++;
    }
    if (!RegExp(r'(?m)^description:\s*\S').hasMatch(header)) {
      stderr.writeln('ERROR [$skillName]: frontmatter requires description.');
      errors++;
    }
    if (content.split(RegExp(r'\r?\n')).length > 500) {
      stderr.writeln('ERROR [$skillName]: SKILL.md exceeds 500 lines.');
      errors++;
    }
    if (!names.add(skillName)) {
      stderr.writeln('ERROR [$skillName]: duplicate skill directory name.');
      errors++;
    }
    if (!content.contains('## Checklist') &&
        !content.contains('## Validation') &&
        !content.contains('## Acceptance')) {
      stdout.writeln('WARNING [$skillName]: no validation or checklist section.');
      warnings++;
    }
  }

  stdout.writeln('Audited $skillCount skills in ${skillsDir.path}.');
  if (errors > 0) {
    stderr.writeln('Audit failed with $errors error(s) and $warnings warning(s).');
    exitCode = 1;
    return;
  }
  stdout.writeln('Audit passed with $warnings warning(s).');
}

Directory? _findSkillsDirectory(Directory root) {
  final candidates = [
    Directory('${root.path}${Platform.pathSeparator}skills'),
    Directory('${root.path}${Platform.pathSeparator}.agents${Platform.pathSeparator}skills'),
    Directory('${root.path}${Platform.pathSeparator}.agent${Platform.pathSeparator}skills'),
  ];
  for (final candidate in candidates) {
    if (candidate.existsSync()) {
      return candidate;
    }
  }
  return null;
}
