---
name: flutter-supabase
description: >
  Use this skill when integrating Supabase services into Flutter applications. Covers Supabase Auth, Database (PostgREST), Storage, Edge Functions, Realtime subscriptions, and Row Level Security with Clean Architecture integration. Do not use for Firebase (use flutter-firebase).
triggers:
  - "Integrate Supabase Auth, PostgREST database, or Storage"
  - "Configure Row Level Security (RLS) policies"
  - "Listen to Supabase Realtime data streams"
negative_triggers:
  - "Firebase services"
  - "Local Drift database"
---

# Flutter Supabase Backend Integration

## Purpose

Implement production-grade Supabase integration in Flutter covering authentication, PostgREST queries, file storage, Realtime WebSocket subscriptions, and Row Level Security (RLS) within Clean Architecture.

## Supabase Core Architecture Matrix

| Service | Client API Method | Clean Architecture Layer |
|---|---|---|
| **Authentication** | `supabase.auth.signInWithPassword()` | `AuthRemoteDataSource` |
| **PostgREST Database** | `supabase.from('table').select()` | `FeatureRemoteDataSource` |
| **Realtime Streams** | `supabase.from('table').stream()` | `FeatureRemoteDataSource` → `StreamProvider` |
| **Storage** | `supabase.storage.from('bucket').upload()` | `MediaRemoteDataSource` |
| **Edge Functions** | `supabase.functions.invoke('function')` | `CloudFunctionDataSource` |

## Supabase Clean Data Source Implementation Pattern

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseTaskRemoteDataSource {
  final SupabaseClient _client;

  SupabaseTaskRemoteDataSource(this._client);

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final response = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Stream<List<Map<String, dynamic>>> watchTasksStream() {
    return _client
        .from('tasks')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  Future<void> createTask(Map<String, dynamic> taskDto) async {
    await _client.from('tasks').insert(taskDto);
  }
}
```

## Supabase Auth Listener Pattern

```dart
class SupabaseAuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepositoryImpl(this._client);

  @override
  Stream<AuthStateEntity> watchAuthState() {
    return _client.auth.onAuthStateChange.map((data) {
      final session = data.session;
      if (session == null) {
        return const AuthStateEntity.unauthenticated();
      }
      return AuthStateEntity.authenticated(
        userId: session.user.id,
        email: session.user.email ?? '',
      );
    });
  }
}
```

## Row Level Security (RLS) SQL Best Practice Reference

```sql
-- Enable RLS on table
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- Allow users to read only their own tasks
CREATE POLICY "Users can read own tasks"
ON public.tasks FOR SELECT
USING (auth.uid() = user_id);

-- Allow users to insert tasks assigned to themselves
CREATE POLICY "Users can create own tasks"
ON public.tasks FOR INSERT
WITH CHECK (auth.uid() = user_id);
```

## Supabase Integration Checklist

- [ ] Supabase initialized in `main.dart` using environment URL and anonKey
- [ ] Direct `SupabaseClient` calls contained strictly within `RemoteDataSource` classes
- [ ] Data DTOs explicitly mapped to Domain Entities before returning to UseCases
- [ ] Realtime streams converted to Domain Entity streams (`StreamController` or `.map()`)
- [ ] Database tables configured with strict Row Level Security (RLS) policies
- [ ] Supabase Auth tokens managed securely by `supabase_flutter` engine

## Related Skills
- `flutter-api-integration` — REST networking alternative
- `flutter-clean-architecture` — Layer boundary separation
- `flutter-websockets` — Realtime stream handling
