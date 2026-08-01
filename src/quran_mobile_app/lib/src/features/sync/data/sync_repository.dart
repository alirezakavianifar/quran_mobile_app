import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_http_client.dart';

class SyncRepository {
  final DioHttpClient _client;

  SyncRepository(this._client);

  Future<bool> syncUserData({
    required String userId,
    List<Map<String, dynamic>>? bookmarks,
    List<Map<String, dynamic>>? highlights,
    List<Map<String, dynamic>>? notes,
    List<Map<String, dynamic>>? readingHistory,
  }) async {
    try {
      final payload = {
        'userId': userId,
        'bookmarks': bookmarks ?? [],
        'highlights': highlights ?? [],
        'notes': notes ?? [],
        'readingHistory': readingHistory ?? [],
        'lastSyncedAt': DateTime.now().toUtc().toIso8601String(),
      };

      final response = await _client.dio.post('/api/v1/sync', data: payload);
      return response.statusCode == 200 && (response.data['success'] ?? false);
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(String userId) async {
    try {
      final response = await _client.dio.get('/api/v1/sync/$userId');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

final syncRepositoryProvider = Provider<SyncRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  return SyncRepository(client);
});
