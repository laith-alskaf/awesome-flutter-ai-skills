#!/usr/bin/env dart
// ============================================================================
// Grill-Me Architectural Verification Script
// Flutter AI Agent Skill Framework 2026
//
// Authoritative Linter & CI Gatekeeper for Clean Architecture Layer Boundaries
// Usage: dart run .agent/tools/verify_architecture.dart [path_to_project_root]
// ============================================================================

import 'dart:io';

const String _reset = '\x1B[0m';
const String _red = '\x1B[31m';
const String _green = '\x1B[32m';
const String _yellow = '\x1B[33m';
const String _cyan = '\x1B[36m';
const String _bold = '\x1B[1m';

// Illegal imports inside Domain layer (Pure Dart & Business Logic ONLY)
const List<String> _illegalDomainImports = [
  'package:flutter/',
  'dart:ui',
  'package:flutter_riverpod/',
  'package:riverpod/',
  'package:riverpod_annotation/',
  'package:flutter_bloc/',
  'package:bloc/',
  'package:get/',
  'package:get_it/',
  'package:injectable/',
  'package:dio/',
  'package:http/',
  'package:drift/',
  'package:hive/',
  'package:sqflite/',
  'package:shared_preferences/',
  'package:flutter_secure_storage/',
];

// Illegal imports inside Data layer (Data sources, DTOs, Repositories ONLY)
const List<String> _illegalDataImports = [
  'package:flutter/material.dart',
  'package:flutter/cupertino.dart',
  'package:flutter/widgets.dart',
];

void main(List<String> args) {
  final String rootPath = args.isNotEmpty ? args.first : Directory.current.path;
  final Directory rootDir = Directory(rootPath);

  if (!rootDir.existsSync()) {
    print('$_red[$_bold ERROR $_reset$_red] Directory not found: $rootPath$_reset');
    exit(1);
  }

  print('$_cyan$_bold==========================================================$_reset');
  print('$_cyan 🏛️  Clean Architecture Boundary Verification 2026$_reset');
  print('$_cyan    Target Root: ${rootDir.absolute.path}$_reset');
  print('$_cyan==========================================================$_reset\n');

  int totalFilesChecked = 0;
  int totalViolations = 0;
  final List<String> violationReports = [];

  // Find lib/ directory or search root if lib/ doesn't exist
  final Directory libDir = Directory('${rootDir.path}/lib');
  final Directory searchDir = libDir.existsSync() ? libDir : rootDir;

  final List<FileSystemEntity> files = searchDir
      .listSync(recursive: true)
      .where((file) => file is File && file.path.endsWith('.dart'))
      .toList();

  for (final file in files) {
    final String normalizedPath = file.path.replaceAll('\\', '/');
    final List<String> pathSegments = normalizedPath.split('/');

    final bool isDomainLayer = pathSegments.contains('domain');
    final bool isDataLayer = pathSegments.contains('data');

    if (!isDomainLayer && !isDataLayer) continue;

    totalFilesChecked++;
    final List<String> lines = (file as File).readAsLinesSync();

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i].trim();
      if (!line.startsWith('import ') && !line.startsWith('export ')) continue;

      if (isDomainLayer) {
        for (final illegal in _illegalDomainImports) {
          if (line.contains(illegal)) {
            totalViolations++;
            violationReports.add(
              '$_red[DOMAIN LEAK]$_reset ${file.path}:${i + 1}\n'
              '  $_yellow-> Found illegal import in Domain layer: $_bold$illegal$_reset\n'
              '  $_yellow-> Code: $line$_reset\n'
              '  $_yellow-> Rule: Domain layer must be 100% pure Dart without UI, State Management, or Networking/Storage imports.$_reset',
            );
          }
        }
      } else if (isDataLayer) {
        for (final illegal in _illegalDataImports) {
          if (line.contains(illegal)) {
            totalViolations++;
            violationReports.add(
              '$_red[DATA LEAK]$_reset ${file.path}:${i + 1}\n'
              '  $_yellow-> Found illegal UI import in Data layer: $_bold$illegal$_reset\n'
              '  $_yellow-> Code: $line$_reset\n'
              '  $_yellow-> Rule: Data layer must not import Flutter UI widgets or screens.$_reset',
            );
          }
        }
      }
    }
  }

  if (totalViolations > 0) {
    print('$_red$_bold❌ Architectural Violations Detected: $totalViolations$_reset\n');
    for (final report in violationReports) {
      print(report);
      print('----------------------------------------------------------');
    }
    print('\n$_red$_bold[BUILD FAILED] Clean Architecture boundary check failed. Fix the leaks above.$_reset');
    exit(1);
  } else {
    print('$_green$_bold✅ Architectural Boundaries Verified!$_reset');
    print('   Checked $totalFilesChecked domain/data layer dart files.');
    print('   Zero Domain Leaks & 100% Clean Architecture Compliance.\n');
    print('$_cyan==========================================================$_reset');
    exit(0);
  }
}
