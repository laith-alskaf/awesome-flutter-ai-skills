# [ADR-008] Envied for Compile-Time Secrets Obfuscation

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Hardcoding API keys, backend client secrets, or OAuth identifiers in plain Dart files exposes credentials to reverse engineering (extracting strings from compiled APK/IPA binaries). Storing secrets in runtime `.env` asset files parsed at startup leaves strings readable in plaintext within the application asset bundle.

---

## Decision Drivers

- Must prevent plaintext exposure of sensitive API keys in version control (Git).
- Must obfuscate API keys inside compiled release binaries to deter reverse engineering.
- Need type-safe, compile-time verification that required environment variables exist before building.

---

## Considered Options

1. **envied with Obfuscation (Chosen):** Code-generation package generating XOR-obfuscated Dart variable accessors from `.env` files.
2. **flutter_dotenv:** Runtime `.env` asset parser.
3. **dart-define / `--dart-define-from-file`:** Built-in compiler flags injecting variables into `String.fromEnvironment`.

---

## Decision Outcome

Chosen option: **envied with Obfuscation**, because it combines the local convenience of `.env` files with compile-time XOR byte obfuscation, preventing automated string extraction tools from harvesting keys from release APKs.

### Positive Consequences

- **Enhanced Security:** Secrets are stored as obfuscated integer arrays and decoded in memory only when accessed.
- **Compile-Safe:** Missing environment variables fail the code generation build step immediately.
- **Git Hygiene:** `.env` files are gitignored; developers share `.env.example` templates.

### Negative Consequences / Trade-offs

- **Obfuscation != Encryption:** Determined attackers with debuggers can eventually trace memory execution; sensitive secrets should still be secured server-side whenever possible.

---

## Validation & Compliance

- **How to verify compliance:** Code reviews prohibit committing `.env` files or using plaintext strings for API keys; all secret access must use `@EnviedField(obfuscate: true)`.
- **Relevant Skills:** `flutter-security`, `flutter-api-integration`
