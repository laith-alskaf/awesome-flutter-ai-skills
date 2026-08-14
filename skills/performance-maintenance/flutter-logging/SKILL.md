---
name: flutter-logging
description: >
  Use this skill when implementing or reviewing logging in Flutter applications. Covers structured logging with the logger package, log levels, production vs debug logging, crash reporting integration, and security-safe logging practices. Do not use for performance profiling (use flutter-debugging).
triggers:
  - "Configure structured logging with logger package"
  - "Mask sensitive PII data in logs"
  - "Set up Crashlytics and Sentry log reporting"
negative_triggers:
  - "Performance profiling"
  - "UI styling"
---

# Flutter Structured Logging & Crash Analytics

## Purpose

Implement structured, security-safe logging and real-time crash reporting across all application layers without polluting console output or leaking sensitive PII (Personally Identifiable Information).

## Log Level Standards Matrix

| Level | Method | Production Target | Example Use Case |
|---|---|---|---|
| **Verbose / Debug** | `logger.v()` / `logger.d()` | Stripped in Release builds | State transitions, local DB queries |
| **Info** | `logger.i()` | Local file log / Analytics | Screen navigation, user actions |
| **Warning** | `logger.w()` | Non-fatal crash reporting | Network retry fallback, cache miss |
| **Error** | `logger.e()` | Firebase Crashlytics / Sentry | Caught exceptions, repository failure mapping |
| **WTF / Fatal** | `logger.wtf()` | Immediate Crashlytics alert | Unrecoverable app state corruption |

## Security PII Masking & Interceptor Pattern

```dart
import 'package:logger/logger.dart';

class SecureAppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
    ),
  );

  // Mask sensitive user information (PII) before logging
  static String maskSensitiveData(String input) {
    return input
        .replaceAll(RegExp(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'), '***@EMAIL***')
        .replaceAll(RegExp(r'\b\d{4}[- ]?\d{4}[- ]?\d{4}[- ]?\d{4}\b'), '****-****-****-CARD');
  }

  static void info(String message) {
    _logger.i(maskSensitiveData(message));
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(maskSensitiveData(message), error: error, stackTrace: stackTrace);
  }
}
```

## Crashlytics & Sentry Integration Setup

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void setupCrashReporting() {
  // Pass all uncaught Flutter framework errors to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass uncaught asynchronous errors to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}
```

## Structured Logging Checklist

- [ ] Debug/Verbose logs stripped or disabled in release builds (`if (kDebugMode)`)
- [ ] No passwords, authentication tokens, API keys, or credit card PII logged
- [ ] Network request/response loggers use masking interceptors
- [ ] Uncaught async exceptions hooked to Firebase Crashlytics or Sentry
- [ ] Log outputs formatted consistently with timestamps and tag markers

## Related Skills
- `flutter-debugging` — DevTools memory profiler and widget inspector
- `flutter-error-handling` — Sealed failure classes mapping
- `flutter-security` — PII protection and security defaults

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
