---
name: flutter-websockets
description: >
  Use this skill when implementing real-time data communication in Flutter applications including WebSockets, Server-Sent Events (SSE), WebRTC, and MQTT. Covers persistent connection management, auto-reconnection algorithms, ping/pong heartbeat monitoring, stream transformation to Clean Architecture domain streams, and seamless integration with state management (Riverpod StreamProvider / Bloc stream subscriptions / GetX reactive streams). Do not use for standard REST HTTP requests (use flutter-api-integration) or GraphQL subscriptions (use flutter-graphql).
triggers:
  - "Implement real-time WebSockets, SSE, WebRTC, or MQTT"
  - "Configure auto-reconnect backoff and heartbeat ping/pong"
  - "Bind real-time stream to domain and state providers"
negative_triggers:
  - "Standard REST HTTP calls"
  - "GraphQL queries"
---

# Flutter Real-Time Communication & WebSockets

## Purpose

Provide a resilient, production-grade real-time networking architecture in Flutter that handles connection drops, background transitions, heartbeat monitoring, and clean layer separation without polluting presentation widgets with stream sockets.

## Real-Time Architecture Matrix

| Protocol | Primary Use Case | Recommended Package | Connection Type |
|---|---|---|---|
| **WebSockets** | Bi-directional messaging, live chat, order tracking | `web_socket_channel` | Full-duplex persistent TCP |
| **SSE** | Server-to-client streaming (AI tokens, live score feeds) | `http` / `flutter_client_sse` | Half-duplex HTTP stream |
| **MQTT** | IoT sensor telemetry, low-bandwidth telemetry | `mqtt_client` | Pub/Sub broker protocol |
| **WebRTC** | Peer-to-peer audio/video calling, live media broadcast | `flutter_webrtc` | UDP/TCP P2P media stream |

## Clean Architecture Rules for Streams

1. **Never import socket packages in Domain or Presentation layers.**
2. **Data Layer (`RemoteDataSource`):** Manages raw socket connection, JSON serialization/deserialization, and heartbeat ping/pong.
3. **Domain Layer (`Repository Interface`):** Exposes a clean `Stream<Either<Failure, DomainEntity>>` (or `Stream<Result<DomainEntity>>`).
4. **Presentation Layer (`State Holder`):** Consumes the domain stream via `@riverpod` StreamProvider, `Bloc` event subscription (`emit.forEach`), `Cubit` stream subscription, or `GetxController` `.bindStream()`.

## Resilient Connection Lifecycle & Auto-Reconnect Pattern

```dart
// Data Layer: Resilient WebSocket Data Source with Exponential Backoff
import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ResilientWebSocketDataSource {
  final String url;
  WebSocketChannel? _channel;
  final _streamController = StreamController<Map<String, dynamic>>.broadcast();
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  bool _isDisposed = false;

  ResilientWebSocketDataSource(this.url);

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void connect() {
    if (_isDisposed) return;
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0; // Reset backoff on success
          _streamController.add(jsonDecode(data as String));
        },
        onError: (error) => _scheduleReconnect(),
        onDone: () => _scheduleReconnect(),
      );
      _startHeartbeat();
    } catch (e) {
      _scheduleReconnect();
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (_channel != null) {
        _channel!.sink.add(jsonEncode({'type': 'ping'}));
      }
    });
  }

  void _scheduleReconnect() {
    _heartbeatTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
    if (_isDisposed) return;

    // Exponential backoff capped at 30 seconds
    final delay = Duration(seconds: (1 << _reconnectAttempts).clamp(1, 30));
    _reconnectAttempts++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, connect);
  }

  void send(Map<String, dynamic> payload) {
    _channel?.sink.add(jsonEncode(payload));
  }

  void dispose() {
    _isDisposed = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close(status.normalClosure);
    _streamController.close();
  }
}
```

## State Management Integration Patterns

### 1. Riverpod StreamProvider Pattern
```dart
@riverpod
Stream<OrderEntity> liveOrderStream(LiveOrderStreamRef ref, String orderId) {
  final repository = ref.watch(orderRepositoryProvider);
  return repository.watchOrderStatus(orderId);
}
```

### 2. Bloc `emit.forEach` Pattern
```dart
class LiveOrderBloc extends Bloc<LiveOrderEvent, LiveOrderState> {
  final OrderRepository _repository;

  LiveOrderBloc(this._repository) : super(const LiveOrderState.initial()) {
    on<StartWatchingOrder>((event, emit) async {
      emit(const LiveOrderState.loading());
      await emit.forEach<OrderEntity>(
        _repository.watchOrderStatus(event.orderId),
        onData: (order) => LiveOrderState.updated(order),
        onError: (error, _) => LiveOrderState.error(error.toString()),
      );
    });
  }
}
```

## Master Checklist

- [ ] Socket packages isolated in Data Layer
- [ ] Repository returns domain entity stream without raw socket types
- [ ] Auto-reconnection with exponential backoff implemented
- [ ] Periodic heartbeat ping/pong configured to prevent silent drop outs
- [ ] Stream controllers and channels explicitly closed on disposal
- [ ] App lifecycle (`didChangeAppLifecycleState`) pauses/resumes connections when app goes to background

## Related Skills
- `flutter-api-integration` — Standard REST HTTP networking
- `flutter-clean-architecture` — Stream boundary isolation
- `flutter-error-handling` — Mapping socket errors to domain failures

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
