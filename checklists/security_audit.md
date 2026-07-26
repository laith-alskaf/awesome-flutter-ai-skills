# Security Audit Checklist

Use this checklist to audit app security against OWASP Mobile Top 10 and industry best practices.

## 1. Storage & Credential Protection
- [ ] No JWT access tokens, refresh tokens, passwords, or PII are stored in plaintext `SharedPreferences` or local files.
- [ ] `flutter_secure_storage` is used for all credential storage with encrypted hardware backing (Keychain / Keystore).
- [ ] No API keys or backend secrets are hardcoded in source files (uses `.env` + `envied` obfuscation).

## 2. Network & Communication
- [ ] All remote endpoints enforce HTTPS (no HTTP plaintext exceptions in release build configurations).
- [ ] Certificate pinning is evaluated or configured for sensitive financial, health, or identity endpoints.
- [ ] Interceptor chains automatically handle token expiration and refresh without logging sensitive authorization headers.

## 3. Hardening & Privacy
- [ ] ProGuard / R8 shrinking and code obfuscation are enabled for Android release builds (`--obfuscate --split-debug-info`).
- [ ] Debug symbols and logging statements (`print`, `logger.d`) are stripped from release binaries.
- [ ] Device permissions (camera, location, contacts) are requested only at the exact moment of use with clear rationale dialogs.
- [ ] Biometric authentication (`local_auth`) protects sensitive user settings or transaction screens.
