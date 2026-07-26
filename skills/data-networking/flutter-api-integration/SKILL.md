---
name: flutter-api-integration
description: >
  Use this skill when designing, implementing, or reviewing REST API networking
  layers in Flutter. Covers Dio configuration, interceptor chains, authentication
  token management, error mapping to typed failures, DTO design, retry policies,
  pagination, file upload/download, offline strategy, and caching. Do not use for
  GraphQL (use flutter-graphql), Firebase (use flutter-firebase), or WebSocket
  real-time communication specifics.
triggers:
  - "Implement Dio REST API networking layer"
  - "Configure API interceptors and auth token renewal"
  - "Map network exceptions to sealed domain failures"
negative_triggers:
  - "WebSockets / SSE real-time streaming"
  - "GraphQL queries"
  - "Firebase integration"
---

# Flutter API Integration

## Purpose

Design production-grade networking layers that are scalable, secure, testable, and maintainable. The networking layer is architecture, not a collection of HTTP requests.

## Scope

**Covers:** Dio setup, interceptors, authentication, token refresh, error mapping, DTOs, retry, pagination, uploads, downloads, offline, caching, mocking.

**Does not cover:** GraphQL, Firebase, Supabase, WebSocket protocol details.

## Technology Context

- Dio for HTTP networking
- flutter_secure_storage for token storage
- Dart 3.12+ sealed classes for failure modeling
- Clean Architecture data layer patterns

## Rules

### Architecture Flow

```
Widget → Notifier → UseCase → Repository → Datasource → ApiClient → Server
                                                                  ↓
Server → Response → DTO → Mapper → Entity → State → UI
```

Never bypass this flow. UI never communicates directly with APIs.

### API Client Configuration

Create a single configurable ApiClient. Never duplicate networking code.

```dart
class ApiClient {
  ApiClient({required String baseUrl, required TokenStorage tokenStorage}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ));

    _dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: tokenStorage, dio: _dio),
      LoggingInterceptor(),
      RetryInterceptor(dio: _dio),
      ErrorInterceptor(),
    ]);
  }

  late final Dio _dio;
  Dio get dio => _dio;
}
```

### Interceptor Chain

Implement dedicated, single-responsibility interceptors.

```dart
// Auth interceptor — adds token, handles refresh
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.tokenStorage, required this.dio});
  final TokenStorage tokenStorage;
  final Dio dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        final retryResponse = await _retry(err.requestOptions);
        return handler.resolve(retryResponse);
      }
    }
    handler.next(err);
  }
}
```

### Error Mapping

Never expose DioException to domain or UI. Map to typed failures.

```dart
sealed class NetworkFailure {
  const NetworkFailure();
}
final class ConnectionFailure extends NetworkFailure {
  const ConnectionFailure();
}
final class TimeoutFailure extends NetworkFailure {
  const TimeoutFailure();
}
final class ServerFailure extends NetworkFailure {
  const ServerFailure(this.statusCode, this.message);
  final int statusCode;
  final String message;
}
final class UnauthorizedFailure extends NetworkFailure {
  const UnauthorizedFailure();
}
final class RateLimitFailure extends NetworkFailure {
  const RateLimitFailure(this.retryAfter);
  final Duration retryAfter;
}

// Mapper function
NetworkFailure mapDioException(DioException e) => switch (e.type) {
  DioExceptionType.connectionTimeout => const TimeoutFailure(),
  DioExceptionType.receiveTimeout => const TimeoutFailure(),
  DioExceptionType.connectionError => const ConnectionFailure(),
  _ => switch (e.response?.statusCode) {
    401 => const UnauthorizedFailure(),
    429 => RateLimitFailure(Duration(seconds: int.tryParse(
      e.response?.headers.value('retry-after') ?? '60') ?? 60)),
    final code? => ServerFailure(code, e.response?.statusMessage ?? 'Unknown'),
    _ => const ConnectionFailure(),
  },
};
```

### Token Management

- Store tokens only in flutter_secure_storage. Never SharedPreferences.
- Support access token + refresh token + expiration tracking
- Auto-refresh on 401 with single retry
- Logout on refresh failure

### Retry Policy

Retry only recoverable failures. Use exponential backoff.

```dart
// Retry: Timeout, network interruption, 5xx server errors
// Do NOT retry: 401, 403, 404, 422 validation errors
```

### Pagination

```dart
class PaginatedResponse<T> {
  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
}
```

### Security

- Always HTTPS. Certificate pinning for sensitive apps.
- Never expose API keys in source code. Use environment config.
- Sanitize inputs. Mask sensitive data in logs.

### Logging

Log: request URL, method, status code, duration, failures, retry attempts.

Never log: passwords, tokens, PII, secrets, payment data.

## Anti-Patterns

| Anti-Pattern | Better Alternative |
|---|---|
| API call inside Widget | Use Repository → UseCase → Notifier chain |
| Creating Dio() instances everywhere | Single ApiClient with DI |
| Returning DioException to UI | Map to sealed NetworkFailure |
| Hardcoded base URL | Environment configuration |
| Tokens in SharedPreferences | flutter_secure_storage |
| Ignoring retry strategy | RetryInterceptor with backoff |
| Returning DTO to Domain | Map DTO → Entity at repository boundary |

## Checklist

- [ ] Single ApiClient with configurable base URL
- [ ] Interceptor chain: Auth → Logging → Retry → Error
- [ ] Token storage in flutter_secure_storage
- [ ] Auto token refresh on 401
- [ ] All DioExceptions mapped to typed failures
- [ ] DTOs never leave data layer
- [ ] Retry with exponential backoff for recoverable errors
- [ ] Pagination support with hasMore/totalPages
- [ ] HTTPS only, no secrets in source
- [ ] Sensitive data masked in logs
- [ ] Repository returns `Result<T, Failure>`, not throws

## Related Skills

- `flutter-clean-architecture` — Data layer structure
- `flutter-error-handling` — Failure propagation patterns
- `flutter-security` — Token storage, certificate pinning
- `flutter-riverpod` — Provider-based DI for networking

## Implementation Workflow Steps

### Step 1: Verify API Contract & JSON Schema
Analyze the backend REST endpoint:
- What is the exact HTTP method and URL path?
- What query parameters or request body JSON are required?
- What is the expected success response JSON structure?
- What error status codes (400, 401, 404, 422, 500) can be returned?

### Step 2: Create DTO with Code Generation
Build the Data Transfer Object inside `lib/features/<name>/data/models/`:
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'order_dto.g.dart';

@JsonSerializable()
class OrderDto {
  const OrderDto({
    required this.id,
    required this.totalAmount,
    required this.status,
    @JsonKey(name: 'created_at') required this.createdAt,
  });

  final String id;
  final double totalAmount;
  final String status;
  final String createdAt;

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}
```
Run code generation: `dart run build_runner build --delete-conflicting-outputs`

### Step 3: Create Domain Entity & Mapper
Define the pure business entity in `domain/entities/` and a mapper extension in `data/mappers/`:
```dart
// domain/entities/order.dart
class Order {
  const Order({required this.id, required this.totalAmount, required this.status, required this.date});
  final String id;
  final double totalAmount;
  final OrderStatus status;
  final DateTime date;
}

// data/mappers/order_mapper.dart
extension OrderDtoMapper on OrderDto {
  Order toEntity() => Order(
    id: id,
    totalAmount: totalAmount,
    status: _mapStatus(status),
    date: DateTime.parse(createdAt),
  );
}
```

### Step 4: Implement Remote Datasource
Add the endpoint call to the datasource class using Dio:
```dart
class OrderRemoteDatasource {
  OrderRemoteDatasource(this._dio);
  final Dio _dio;

  Future<OrderDto> getOrder(String orderId) async {
    final response = await _dio.get('/api/v1/orders/$orderId');
    return OrderDto.fromJson(response.data);
  }
}
```

### Step 5: Wire Repository & Map Exceptions
Implement the domain repository interface, catching exceptions and returning a `Result`:
```dart
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._remoteDatasource);
  final OrderRemoteDatasource _remoteDatasource;

  @override
  Future<Result<Order, OrderFailure>> getOrder(String id) async {
    try {
      final dto = await _remoteDatasource.getOrder(id);
      return Success(dto.toEntity());
    } on DioException catch (e) {
      return Failure(_mapDioException(e));
    } catch (_) {
      return const Failure(OrderFailure.unknown());
    }
  }
}
```

### Step 6: Create or Update UseCase
Expose the repository method via a focused UseCase:
```dart
class GetOrderUseCase {
  const GetOrderUseCase(this._repository);
  final OrderRepository _repository;

  Future<Result<Order, OrderFailure>> call(String id) => _repository.getOrder(id);
}
```

## Related Skills

- `flutter-api-integration` — Dio client setup and interceptor rules
- `flutter-error-handling` — Exception-to-failure mapping patterns
- `flutter-clean-architecture` — Data/Domain layer boundaries

