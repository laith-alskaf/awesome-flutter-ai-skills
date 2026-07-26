---
name: flutter-media-hardware
description: >
  Use this skill when implementing media playback, recording, camera streaming, and hardware sensor integration in Flutter applications. Covers audio/video playback (just_audio, video_player), audio recording (record), live camera stream processing (camera), Bluetooth Low Energy (flutter_blue_plus), GPS geolocation (geolocator), native platform channels (MethodChannel, EventChannel), and Dart FFI. Enforces resource disposal and clean domain abstraction over native sensors.
triggers:
  - "Implement audio/video playback and recording"
  - "Process live camera streams and BLE sensor data"
  - "Use MethodChannels, EventChannels, and Dart FFI"
negative_triggers:
  - "Standard REST API calls"
  - "UI styling"
---

# Flutter Media Pipelines, Hardware Sensors & Native Interop

## Purpose

Provide a leak-free, high-performance architecture for interacting with device hardware sensors, cameras, native iOS/Android code via Platform Channels (`MethodChannel`, `EventChannel`), and C/Rust native binaries via Dart FFI (`dart:ffi`).

## Hardware & Native Interop Technology Matrix

| Capability | Recommended Tool / Package | Platform Mechanics |
|---|---|---|
| **Native Method Invocation** | `MethodChannel` | Asynchronous JSON/StandardMessageCodec IPC |
| **Native Continuous Event Stream** | `EventChannel` | Asynchronous Native Stream to Dart Stream |
| **High-Performance C/C++/Rust Interop** | `dart:ffi` / `ffi` | Synchronous / Direct memory pointer interop (Zero IPC overhead) |
| **Camera Frame Processing** | `camera` | ImageFormatGroup YUV420 frame buffer |
| **Bluetooth LE** | `flutter_blue_plus` | Native BLE GATT scan/connection stream |
| **Geolocation** | `geolocator` | OS GPS/CoreLocation native listeners |

## 1. Native Platform Channels (`MethodChannel` & `EventChannel`)

```dart
// Data Layer: Native Platform Channel Data Source
import 'package:flutter/services.dart';
import 'dart:async';

class NativeSensorDataSource {
  static const _methodChannel = MethodChannel('com.example.app/native_sensor');
  static const _eventChannel = EventChannel('com.example.app/battery_stream');

  Future<int> getNativeBatteryLevel() async {
    try {
      final int result = await _methodChannel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      throw NativeSensorException(e.message ?? 'Failed to get battery level');
    }
  }

  Stream<double> watchBatteryTemperatureStream() {
    return _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => (event as num).toDouble());
  }
}
```

## 2. High-Performance C/Rust Interop (`dart:ffi`)

```dart
// Native C Library Binding via Dart FFI
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:io';

// C Function Signature: int32_t calculate_hash(const char* input);
typedef NativeCalculateHash = ffi.Int32 Function(ffi.Pointer<Utf8> input);
typedef DartCalculateHash = int Function(ffi.Pointer<Utf8> input);

class NativeCryptoEngine {
  late final DartCalculateHash _calculateHash;

  NativeCryptoEngine() {
    final ffi.DynamicLibrary nativeLib = Platform.isAndroid
        ? ffi.DynamicLibrary.open('libnative_crypto.so')
        : ffi.DynamicLibrary.process();

    _calculateHash = nativeLib
        .lookup<ffi.NativeFunction<NativeCalculateHash>>('calculate_hash')
        .asFunction();
  }

  int computeFastHash(String input) {
    final nativeString = input.toNativeUtf8();
    try {
      return _calculateHash(nativeString);
    } finally {
      calloc.free(nativeString); // Always release native memory pointers
    }
  }
}
```

## Master Checklist

- [ ] Hardware and Native Channels isolated strictly inside Data layer DataSources
- [ ] PlatformChannel calls handle `PlatformException` and map to domain Failures
- [ ] `MethodChannel` and `EventChannel` naming uses unique reverse domain notation (`com.company.app/feature`)
- [ ] Memory pointers created via `dart:ffi` (`toNativeUtf8()`, `malloc`, `calloc`) explicitly freed in `finally` blocks
- [ ] Camera and sensor streams implement backpressure frame dropping to avoid Out-Of-Memory crashes

## Related Skills
- `flutter-error-handling` — Mapping native platform exceptions
- `flutter-clean-architecture` — Domain abstraction over hardware
