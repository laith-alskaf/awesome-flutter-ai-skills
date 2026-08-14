---
name: flutter-routing
description: >
  Use this skill when implementing, reviewing, or designing navigation and routing in Flutter using go_router. Covers declarative routing, typed routes with go_router_builder, ShellRoute for persistent navigation, deep linking, authentication guards, route transitions, and nested navigation. Do not use for general UI layout (use flutter-ui-engineering).
triggers:
  - "Implement go_router navigation and typed routes"
  - "Configure deep linking / App Links / Universal Links"
  - "Set up authentication navigation guards"
negative_triggers:
  - "General UI layout"
  - "State management logic"
---

# Flutter Declarative Routing & Deep Linking (`go_router`)

## Purpose

Implement type-safe declarative navigation, deep linking (Android App Links, iOS Universal Links, custom URL schemes), authentication guards, and nested tab navigation using `go_router`.

## Declarative Router Configuration Pattern

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authNotifier.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuthenticated && !isLoggingIn) return '/login';
      if (isAuthenticated && isLoggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Deep Linked Route with Path Parameter
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(id: id);
        },
      ),
    ],
  );
});
```

## Deep Linking Configuration Matrix

| Platform | Protocol / Tech | Configuration File Location | Required Validation |
|---|---|---|---|
| **Android** | App Links (HTTP/HTTPS) | `android/app/src/main/AndroidManifest.xml` | Digital Asset Links (`/.well-known/assetlinks.json`) |
| **Android** | Custom Scheme (`myapp://`) | `android/app/src/main/AndroidManifest.xml` | Local Intent Filter |
| **iOS** | Universal Links (HTTP/HTTPS) | `ios/Runner/Runner.entitlements` | Apple App Site Association (`/.well-known/apple-app-site-association`) |
| **iOS** | Custom Scheme (`myapp://`) | `ios/Runner/Info.plist` | `CFBundleURLTypes` |

### Android Deep Linking Manifest Configuration (`AndroidManifest.xml`)
```xml
<activity ...>
    <!-- Custom Scheme: myapp://profile -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="myapp" android:host="profile" />
    </intent-filter>

    <!-- Verified Android App Links: https://myapp.com/product/* -->
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="https" android:host="myapp.com" />
    </intent-filter>
</activity>
```

### iOS Universal Links Configuration (`Runner.entitlements`)
```xml
<key>com.apple.developer.associated-domains</key>
<array>
    <string>applinks:myapp.com</string>
</array>
```

## Master Checklist

- [ ] All routes declared using `go_router` declarative API
- [ ] Authentication redirects handled inside `GoRouter.redirect` callback
- [ ] Tabbed navigation configured via `ShellRoute` / `StatefulShellRoute`
- [ ] Path parameters and query parameters parsed safely without null assertions
- [ ] Android App Links (`autoVerify="true"`) configured in `AndroidManifest.xml`
- [ ] iOS Associated Domains (`applinks:domain.com`) configured in Xcode entitlements

## Related Skills
- `flutter-clean-architecture` — Navigation boundaries
- `flutter-web-desktop` — URL strategy configuration

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
