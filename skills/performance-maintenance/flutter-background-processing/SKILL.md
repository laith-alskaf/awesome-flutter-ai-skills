---
name: flutter-background-processing
description: >
  Use this skill when implementing background processing, scheduled jobs, background data synchronization, and local notifications in Flutter applications. Covers WorkManager configuration, scheduled local notifications (flutter_local_notifications), headless Dart execution, surviving OS battery optimization (Doze mode), and app lifecycle transitions. Do not use for real-time WebSocket communication (use flutter-websockets) or push notifications via FCM (use flutter-firebase).
triggers:
  - "Implement background tasks with WorkManager"
  - "Schedule local notifications and alarms"
  - "Execute headless Dart code surviving OS Doze mode"
negative_triggers:
  - "Real-time WebSockets stream"
  - "FCM push notification handling"
---

# Flutter Background Processing & Services

## Purpose

Provide a reliable, battery-efficient background execution architecture in Flutter that runs tasks cleanly when the app is suspended, minimized, or terminated, without triggering OS kill signals or memory leaks.

## Background Execution Technology Matrix

| Requirement | Recommended Package | Platform Mechanics | Maximum Duration |
|---|---|---|---|
| **Periodic Sync / Cleanup** | `workmanager` | Android WorkManager / iOS BackgroundTasks (BGTaskScheduler) | ~15 minutes periodic (OS scheduled) |
| **Scheduled Alerts / Alarms** | `flutter_local_notifications` | Android AlarmManager / iOS UNUserNotificationCenter | Exact timestamp trigger |
| **Long-Running Location / Audio** | `flutter_foreground_task` / `audio_service` | Android Foreground Service (with sticky notification) | Continues until user/app stops |
| **Instant Push Trigger** | `firebase_messaging` | APNs / FCM silent data message | ~30 seconds background wake |

## Clean Architecture for Background Tasks

1. **Headless Execution Rule:** Background callbacks run in an isolated Dart Isolate (headless engine). You **cannot** access UI widgets, context, or existing memory state from the foreground isolate.
2. **Dependency Injection in Isolates:** You must re-initialize essential services (caching, database, DI container) inside the background callback dispatcher before executing business logic.
3. **Repository Reuse:** The callback dispatcher should instantiate or resolve the Domain Repository and invoke the corresponding UseCase.

## WorkManager Production Pattern

```dart
// 1. Top-Level or Static Callback Dispatcher (MUST NOT be an anonymous closure)
import 'package:workmanager/workmanager.dart';
import 'package:logger/logger.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final logger = Logger();
    logger.i('Starting background task: $taskName');

    try {
      // Re-initialize standalone dependencies for headless isolate
      await initializeBackgroundDependencies();
      
      switch (taskName) {
        case 'periodic_data_sync':
          final syncUseCase = getIt<SyncOfflineDataUseCase>();
          final result = await syncUseCase();
          return result.isSuccess;
        default:
          return Future.value(true);
      }
    } catch (e, stack) {
      logger.e('Background task failed', error: e, stackTrace: stack);
      return Future.value(false); // Triggers OS retry policy
    }
  });
}

// 2. Registration in App Startup
void setupBackgroundTasks() {
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  Workmanager().registerPeriodicTask(
    '1',
    'periodic_data_sync',
    frequency: const Duration(hours: 1),
    constraints: Constraints(
      networkType: NetworkType.connected,
      requiresBatteryNotLow: true,
    ),
  );
}
```

## Scheduled Local Notifications Pattern

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    await _notificationsPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders_channel',
          'Reminders',
          channelDescription: 'Scheduled user reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
```

## Surviving OS Battery Optimization (Doze Mode & OEM Killers)

- **Hybrid Resilient Blueprint:** Do not rely solely on `WorkManager` for guaranteed or time-critical execution. For continuous tasks (e.g., live location, audio, VoIP), combine `workmanager` (for opportunistic periodic sync) with **Foreground Services** (`flutter_foreground_task`) and sticky notifications.
- **OEM Battery Killers (Xiaomi MIUI/HyperOS, Samsung OneUI, Huawei):** OEM skins often kill background tasks aggressively despite standard WorkManager constraints. Provide an explicit in-app UI prompting users to disable battery optimizations (`disableBatteryOptimizations` / `requestIgnoreBatteryOptimizations` via `permission_handler`) when critical background reliability is needed.
- **Fallback Foreground Sync:** Always attach an `AppLifecycleListener` in the presentation root to trigger an immediate fallback sync when the app transitions back from background (`AppLifecycleState.resumed`).
- **Android:** Rely on explicit WorkManager `Constraints` (`requiresBatteryNotLow`, `NetworkType.connected`) for non-critical jobs.
- **iOS:** Must configure `BGTaskSchedulerPermittedIdentifiers` in `Info.plist` and enable `Background fetch` and `Background processing` in Xcode Capabilities.

## Master Checklist

- [ ] Background callback is annotated with `@pragma('vm:entry-point')` and is a static/top-level function
- [ ] Headless isolate re-initializes necessary local DB / network DI bindings
- [ ] Periodic tasks configure battery and network constraints (`requiresBatteryNotLow`, `NetworkType.connected`)
- [ ] Timezone DB initialized before scheduling local notifications
- [ ] iOS `Info.plist` contains required `BGTaskSchedulerPermittedIdentifiers`
- [ ] No UI or `BuildContext` access attempted inside background tasks

## Related Skills
- `flutter-local-database` — Persisting synced data in background
- `flutter-api-integration` — Background API syncing
- `flutter-firebase` — FCM push notification background handlers

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
