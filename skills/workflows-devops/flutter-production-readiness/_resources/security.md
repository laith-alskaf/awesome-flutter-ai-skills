# 🛡️ Pillar 1: Enterprise Security Architecture

## 1. Secrets Management & Environment Separation
- Never hardcode API keys, Firebase credentials, or backend endpoints in Dart code.
- Use environment-specific configuration files (`.env.dev`, `.env.staging`, `.env.prod`) injected via `--dart-define-from-file` during build.
- Enforce `.env*` rules in `.gitignore` to prevent secret leakage.

## 2. Secure Storage & Credential Handling
- Store all sensitive data (JWT auth tokens, refresh tokens, PII, biometric keys) in `flutter_secure_storage` (backed by Keychain on iOS and EncryptedSharedPreferences on Android).
- Never store authentication credentials or secrets in `SharedPreferences` or plain text SQLite/Drift databases.

## 3. Network Security & Certificate Pinning
- Enforce strict HTTPS/TLS 1.3 across all REST API and WebSocket communication.
- Implement certificate pinning (via Dio interceptor or `http_certificate_pinning`) for high-security banking, medical, or SaaS applications to prevent Man-in-the-Middle (MitM) attacks.

## 4. WebView & Deeplink Hardening
- Validate all incoming deep links (`go_router` redirects) against an allowlist of trusted schemes and hosts.
- Disable JavaScript execution in embedded WebViews unless strictly required and authenticated.
