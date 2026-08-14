---
name: flutter-localization
description: >
  Use this skill when implementing or reviewing internationalization (i18n) and
  localization (l10n) in Flutter applications. Covers flutter_localizations,
  ARB files, RTL support, locale switching, date/number formatting, and
  pluralization. Do not use for accessibility features (use flutter-accessibility).
triggers:
  - "Implement internationalization (i18n) and localization (l10n)"
  - "Configure ARB files and locale switching"
  - "Support RTL/LTR dynamic layout switching"
negative_triggers:
  - "Accessibility semantics labels"
  - "Static text formatting"
---

# Flutter Localization

## Purpose

Support multiple languages and locales with proper text direction (LTR/RTL), date/number formatting, and pluralization.

## Rules

### Setup with flutter_localizations

```dart
// pubspec.yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any

flutter:
  generate: true

// l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

### ARB Files

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "My App",
  "welcomeMessage": "Welcome, {name}!",
  "@welcomeMessage": {
    "placeholders": { "name": { "type": "String" } }
  },
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "placeholders": { "count": { "type": "int" } }
  }
}
```

### MaterialApp Configuration

```dart
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  locale: selectedLocale, // From user preference
)

// Usage in widgets
Text(AppLocalizations.of(context)!.welcomeMessage('Laith'))
```

### RTL Support

- Use `Directionality` or set locale with RTL language
- Replace `left`/`right` with `start`/`end` in padding/margin
- Use `TextDirection.rtl` for Arabic, Hebrew, etc.
- Test every screen in both LTR and RTL

### Rules

- Never hardcode user-visible strings
- Always use ARB placeholders for dynamic values
- Support pluralization for countable items
- Format dates and numbers using `intl` package
- Store locale preference for persistence

## Related Skills

- `flutter-accessibility` — RTL and a11y interaction
- `flutter-ui-engineering` — Theme and text integration

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
