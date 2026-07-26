# [ADR-006] Drift for Structured Type-Safe Local Persistence

- **Status:** Accepted
- **Date:** 2026-07-26
- **Decision-Makers:** Flutter Architecture Board

---

## Context and Problem Statement

Medium-to-large mobile apps often require offline-first data persistence, complex relational joins, full-text search, and schema migration capabilities. Basic key-value stores (`SharedPreferences`, `Hive`) become unwieldy and unmaintainable when managing relational data or querying large datasets. We need a robust, type-safe SQL relational database solution for structured offline caching.

---

## Decision Drivers

- Must provide compile-time verification of SQL queries to prevent runtime syntax errors.
- Need automated Dart class generation matching database tables.
- Must support reactive queries (emitting streams on database table updates).
- Need robust, testable database schema migration tooling.

---

## Considered Options

1. **Drift (Chosen):** Type-safe, reactive SQL persistence library written in pure Dart (formerly Moor).
2. **sqflite:** Low-level SQLite wrapper without compile-time query verification or reactive streams.
3. **Hive:** Fast, NoSQL key-value box database.
4. **Realm / Isar:** Object-oriented NoSQL mobile databases.

---

## Decision Outcome

Chosen option: **Drift**, because it provides full relational SQL power with compile-time type safety, automated migrations, reactive streams that integrate perfectly with Riverpod, and multi-platform support (including Web via WebAssembly).

### Positive Consequences

- **Type-Safe SQL:** Queries written in SQL or Dart builder syntax are verified at compile time.
- **Reactive Cache:** Riverpod providers can listen directly to Drift query streams for instant UI updates when offline cache modifies.
- **Reliable Migrations:** Built-in testable migration steps ensure zero data loss across app upgrades.

### Negative Consequences / Trade-offs

- **Code Gen Overhead:** Requires `build_runner` for table class generation.
- **Overkill for Simple Key-Value:** Not recommended for simple flags or theme settings (use `SharedPreferences` or `Hive` instead).

---

## Validation & Compliance

- **How to verify compliance:** Database tables must be defined in the `data/datasources/` layer; domain layer never imports Drift classes.
- **Relevant Skills:** `flutter-local-database`
