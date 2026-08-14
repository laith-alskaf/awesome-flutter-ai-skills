---
name: flutter-graphql
description: >
  Use this skill when integrating GraphQL APIs into Flutter applications using
  graphql_flutter or ferry. Covers client configuration, queries, mutations,
  subscriptions, caching (normalized cache), code generation, and error mapping to
  Clean Architecture failures. Do not use for REST APIs (use
  flutter-api-integration) or Firebase (use flutter-firebase).
triggers:
  - "Integrate GraphQL APIs using ferry or graphql_flutter"
  - "Write GraphQL queries, mutations, and subscriptions"
  - "Configure normalized cache for GraphQL"
negative_triggers:
  - "REST API networking"
  - "Firebase Firestore"
---

# Flutter GraphQL Integration

## Purpose

Integrate GraphQL APIs efficiently with type-safe operations, normalized caching, and clean layer separation.

## Rules

### Architecture Placement

GraphQL is an infrastructure detail. All queries, mutations, and client configurations belong exclusively in the **Data layer** (`data/datasources/remote/`).

### Package Selection

| Package | Best For | Why |
|---|---|---|
| **ferry** | Enterprise, complex caching | Type-safe code gen, built-in normalized cache, stream-based |
| **graphql_flutter** | Simple to medium projects | Widely adopted, widget integration, Hive cache |

### Code Generation Pattern

Always use code generation (`build_runner` with `ferry_generator` or `graphql_codegen`) to generate Dart types from GraphQL schemas (`.graphql` files). Never write manual map parsing for GraphQL responses.

### Datasource Implementation

```dart
class UserGraphqlDatasource {
  UserGraphqlDatasource(this._client);
  final GraphQLClient _client;

  Future<UserDto> getUser(String id) async {
    final options = QueryOptions(
      document: gql(r'''
        query GetUser($id: ID!) {
          user(id: $id) { id name email avatarUrl }
        }
      '''),
      variables: {'id': id},
      fetchPolicy: FetchPolicy.cacheFirst,
    );

    final result = await _client.query(options);
    if (result.hasException) {
      throw _mapGraphqlException(result.exception!);
    }
    return UserDto.fromJson(result.data!['user']);
  }
}
```

### Caching Strategy

- Use `GraphQLCache(store: HiveStore())` for persistent normalized caching
- Configure custom `dataIdFromObject` to ensure proper entity normalization across queries
- Use appropriate `FetchPolicy` (`cacheFirst`, `networkOnly`, `cacheAndNetwork`) based on feature freshness requirements

### Error Handling

Map `OperationException` (link exceptions and GraphQL errors) to typed domain failures at the repository boundary.

## Related Skills

- `flutter-clean-architecture` — Data layer rules
- `flutter-api-integration` — REST alternative
- `flutter-error-handling` — Mapping exceptions to failures

## Validation

Before completing, verify the output against the target project's applicable analysis, test, and platform checks. Confirm that the result satisfies this skill's scope, preserves existing project conventions, and records any material assumption or limitation.
