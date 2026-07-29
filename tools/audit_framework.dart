import 'dart:io';

void main() async {
  print('--- AI Framework Quality Audit ---');
  final skillsDir = Directory('skills');
  if (!skillsDir.existsSync()) {
    print('❌ skills directory not found.');
    exit(1);
  }

  int totalErrors = 0;
  int skillCount = 0;

  for (final entity in skillsDir.listSync(recursive: true)) {
    if (entity is Directory) {
      final skillMd = File('${entity.path}/SKILL.md');
      if (skillMd.existsSync()) {
        skillCount++;
        final skillName = entity.path.split(Platform.pathSeparator).last;
        final metadataFile = File('${entity.path}/metadata.yaml');

        if (!metadataFile.existsSync()) {
          print('❌ [$skillName]: Missing metadata.yaml');
          totalErrors++;
          continue;
        }

        final skillContent = skillMd.readAsStringSync();
        // Rough token estimate: 1 token = 4 characters
        final tokenEstimate = skillContent.length / 4;
        
        if (tokenEstimate > 1000) {
          print('⚠️ [$skillName]: Token size warning ($tokenEstimate tokens). Max is 1000.');
        }

        final metadataContent = metadataFile.readAsStringSync();
        if (!metadataContent.contains('name:') || !metadataContent.contains('version:')) {
          print('❌ [$skillName]: Invalid metadata.yaml (missing name or version)');
          totalErrors++;
        }
        if (!metadataContent.contains('active_persona:')) {
          print('❌ [$skillName]: Missing active_persona in metadata.yaml');
          totalErrors++;
        }
      }
    }
  }

  print('----------------------------------');
  print('Total Skills Audited: $skillCount');
  
  if (totalErrors > 0) {
    print('❌ Audit Failed with $totalErrors errors.');
    exit(1);
  } else {
    print('✅ Audit Passed. Knowledge Graph & Personas are intact.');
  }
}

