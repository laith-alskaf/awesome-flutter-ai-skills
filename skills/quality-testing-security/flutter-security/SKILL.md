---
name: flutter-security
description: >
  Use this skill when implementing, reviewing, or auditing security in Flutter
  applications. Covers OWASP Mobile Top 10, secure storage, authentication
  tokens, API security, certificate pinning, secrets management, biometric auth,
  permissions, WebView security, and release hardening. Do not use for general
  error handling (use flutter-error-handling) or networking setup (use
  flutter-api-integration).
triggers:
  - "Audit or implement Flutter security defaults"
  - "Secure tokens in flutter_secure_storage and obfuscate env secrets"
  - "Enforce SSL certificate pinning and OWASP Mobile Top 10"
negative_triggers:
  - "General error handling"
  - "UI styling"
---

# Flutter Security Expert

## Purpose

Protect Flutter applications against common security vulnerabilities following OWASP Mobile Top 10, MASVS, Google Android Security, and Apple Security Guidelines. Security is mandatory — never trade it for convenience.

## Scope

**Covers:** Secure storage, authentication, API security, secrets, encryption, certificate pinning, biometric auth, permissions, WebView, logging, release hardening.

**Does not cover:** General error handling, networking architecture, UI patterns.

## Technology Context

- flutter_secure_storage for encrypted key-value storage
- envied for compile-time environment variables
- local_auth for biometric authentication
- Dart 3.12+ for type-safe security patterns

## Rules

### Secure Storage

```dart
// Correct — encrypted storage
final secureStorage = FlutterSecureStorage();
await secureStorage.write(key: 'access_token', value: token);

// Wrong — plaintext storage
final prefs = await SharedPreferences.getInstance();
prefs.setString('access_token', token); // NEVER do this
```

Never store in SharedPreferences: tokens, passwords, API keys, PII, session data.

### Authentication

| Concern | Implementation |
|---|---|
| Token Storage | flutter_secure_storage |
| Access Token | Short-lived, attached via interceptor |
| Refresh Token | Stored securely, used for renewal |
| Token Expiration | Track expiry, auto-refresh before expiry |
| Logout | Clear all tokens + local sensitive data |
| Session Timeout | Auto-logout after inactivity period |
| Biometric | local_auth for fingerprint/face unlock |

### API Security

- Always HTTPS. Never allow HTTP in production.
- Certificate pinning for financial, health, or government apps.
- Add request signing for sensitive endpoints.
- Validate all inputs on both client and server.
- Never trust client-side validation alone.
- Be aware of rate limiting. Handle 429 responses gracefully.

### Secrets Management

```dart
// Correct — compile-time environment variables with envied
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;
}

// Wrong — hardcoded secrets
const apiKey = 'sk-1234567890abcdef'; // NEVER commit this
```

- Never commit API keys, secrets, or certificates to git.
- Use `.env` files (gitignored) + envied for obfuscation.
- CI/CD secrets stored in GitHub Secrets or equivalent.

### Certificate Pinning

```dart
// For sensitive apps — pin the server certificate
(dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    return cert.pem == trustedCertificatePem;
  };
  return client;
};
```

### Logging Security

Never log: passwords, tokens, PII (names, emails, phone numbers), payment data, secrets, session IDs.

```dart
// Mask sensitive data in logs
log('Login attempt for user: ${email.substring(0, 3)}***');
```

### Permissions

- Request only the minimum permissions required.
- Explain each permission to the user before requesting.
- Handle permission denial gracefully.
- Never request background location without strong justification.

### WebView Security

- Disable JavaScript unless explicitly required.
- Validate all URLs before loading.
- Block navigation to unknown domains.
- Prevent XSS by sanitizing content.

### Release Hardening

- Remove all debug logs and print statements.
- Disable debug mode flags.
- Enable ProGuard/R8 for Android.
- Enable App Transport Security for iOS.
- Strip debug symbols from release builds.
- Enable code obfuscation: `flutter build apk --obfuscate --split-debug-info=./debug-info/`

### Biometric Authentication

```dart
final localAuth = LocalAuthentication();
final canAuth = await localAuth.canCheckBiometrics;
if (canAuth) {
  final authenticated = await localAuth.authenticate(
    localizedReason: 'Authenticate to access your account',
    options: const AuthenticationOptions(biometricOnly: true),
  );
}
```

## Anti-Patterns

| Anti-Pattern | Risk |
|---|---|
| Tokens in SharedPreferences | Readable from device backup |
| Hardcoded API keys | Extractable from APK/IPA |
| HTTP in production | Man-in-the-middle attacks |
| Logging tokens/passwords | Leaked through crash reports |
| Trusting all certificates | SSL stripping attacks |
| Debug mode in release | Exposes internal state |
| Excessive permissions | User distrust, store rejection |

## Checklist

- [ ] Tokens stored in flutter_secure_storage
- [ ] Secrets managed with envied (not hardcoded)
- [ ] HTTPS only (no HTTP exceptions in release)
- [ ] No passwords/tokens/PII in logs
- [ ] Minimum permissions requested
- [ ] Input validation on client and server
- [ ] Certificate pinning for sensitive apps
- [ ] Release build obfuscated with debug info stripped
- [ ] ProGuard/R8 enabled for Android
- [ ] Biometric auth for sensitive operations
- [ ] WebView restricted to known domains

## Related Skills

- `flutter-api-integration` — Networking security (interceptors, tokens)
- `flutter-logging` — Safe logging practices
- `flutter-release` — Release hardening steps
