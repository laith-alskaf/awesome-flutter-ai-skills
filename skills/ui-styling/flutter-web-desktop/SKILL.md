---
name: flutter-web-desktop
description: >
  Use this skill when developing, optimizing, or building Flutter Web and Flutter Desktop (macOS, Windows, Linux) applications. Covers Web rendering engines (CanvasKit vs Wasm vs HTML), Web SEO & social meta tags, CORS handling, Progressive Web App (PWA) configuration, URL routing strategy, Desktop window management (window_manager), native top menu bars (menubar), keyboard accelerators/shortcuts, mouse hover states, and platform-adaptive layouts. Do not use for standard mobile UI layouts (use flutter-responsive-design or flutter-ui-engineering).
triggers:
  - "Optimize Flutter Web with Wasm / CanvasKit / CORS / PWA"
  - "Configure Flutter Desktop window manager / top menus / shortcuts"
  - "Build multi-platform desktop/web applications"
negative_triggers:
  - "Standard mobile layout engineering"
  - "Backend API design"
---

# Flutter Web & Desktop Specifics

## Purpose

Provide specialized engineering patterns and optimizations for building Flutter Web and desktop applications, overcoming platform-specific limitations such as CORS, web SEO, CanvasKit bundle size, desktop window controls, native menus, and keyboard-driven navigation.

## Web vs Desktop Capabilities Matrix

| Feature / Challenge | Flutter Web | Flutter Desktop (macOS/Win/Linux) |
|---|---|---|
| **Rendering Engine** | Wasm (WebAssembly) / CanvasKit / HTML | Impeller / Skia (Native GPU) |
| **SEO & Meta Tags** | Requires `index.html` meta injection or SSR shell | N/A (Native Binary) |
| **Networking & CORS** | Subject to browser same-origin security (CORS) | Full native socket/HTTP access (No CORS) |
| **Window Management** | Browser tab controls (`url_strategy`) | Native window resize/min/max (`window_manager`) |
| **Menu & Shortcuts** | Standard web shortcuts | Native system menu bar (`menubar`) & Shortcuts |
| **Offline Support** | PWA Service Worker (`flutter_service_worker.js`) | Native local filesystem / database persistence |

## 1. Flutter Web Optimizations

### A. Rendering Engine Selection
- **Wasm (WebAssembly / Garbage Collected):** Default recommendation for Flutter 3.44+ on modern browsers (highest performance, closest to native speed).
- **CanvasKit:** Use when Wasm is unsupported and visual fidelity (complex shaders, custom fonts) is prioritized over initial load time.
- **HTML:** Use only for static forms or low-bandwidth environments where download size must be < 2 MB.

```bash
# Production Build Command for Web with Wasm
flutter build web --wasm --release
```

### B. CORS (Cross-Origin Resource Sharing)
- Browser applications cannot bypass CORS on the client side.
- **Rule:** Never attempt to add headers or disable web security in Flutter code to fix CORS.
- **Solution:** Configure your API server (Backend / Supabase / Firebase / Cloudflare Worker) to return `Access-Control-Allow-Origin: *` or your specific web domain.

### C. Clean URL Strategy (Removing `#` Hash)
```dart
// In main.dart before runApp()
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy(); // Transforms http://app.com/#/profile to http://app.com/profile
  runApp(const MyApp());
}
```

## 2. Flutter Desktop Optimizations

### A. Window Management (`window_manager`)
```dart
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

Future<void> setupDesktopWindow() async {
  await window_manager.ensureInitialized();
  
  const windowOptions = WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
```

### B. Keyboard Shortcuts & Accelerators Pattern
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DesktopShortcutContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onSearch;

  const DesktopShortcutContainer({
    super.key,
    required this.child,
    required this.onSave,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS): const SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): const SaveIntent(),
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyF): const SearchIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          SaveIntent: CallbackAction<SaveIntent>(onInvoke: (_) => onSave()),
          SearchIntent: CallbackAction<SearchIntent>(onInvoke: (_) => onSearch()),
        },
        child: Focus(
          autofocus: true,
          child: child,
        ),
      ),
    );
  }
}

class SaveIntent extends Intent { const SaveIntent(); }
class SearchIntent extends Intent { const SearchIntent(); }
```

### C. Mouse Hover & Cursor Styling
- Every clickable item on Desktop/Web must use `MouseRegion` with `SystemMouseCursors.click` or implement interactive `Hover` styling via `MaterialStateProperty` / `WidgetStateProperty`.

## Master Checklist

- [ ] `usePathUrlStrategy()` called before `runApp` for web applications
- [ ] Production web builds compile to Wasm (`--wasm`) when target browsers support it
- [ ] Desktop builds configure minimum window sizes and title bar styles via `window_manager`
- [ ] Common desktop keyboard shortcuts (Cmd/Ctrl+S, Cmd/Ctrl+F, Esc) bound via `Shortcuts` & `Actions`
- [ ] Hover cursor states (`SystemMouseCursors.click`) applied to all interactive cards and buttons
- [ ] API backend CORS headers verified for web deployments

## Related Skills
- `flutter-responsive-design` — Multi-column desktop/tablet breakpoints
- `flutter-ui-engineering` — Adaptive layouts and design tokens
- `flutter-release` — Building web PWA and desktop installers
