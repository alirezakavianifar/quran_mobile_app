import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/network/dio_http_client.dart';
import '../reader/reader_provider.dart';

class SearchResultItem {
  final int surahId;
  final int verseNumber;
  final String textUthmani;
  final String translationText;
  final double score;

  SearchResultItem({
    required this.surahId,
    required this.verseNumber,
    required this.textUthmani,
    required this.translationText,
    this.score = 1.0,
  });
}

class SearchNotifier extends StateNotifier<AsyncValue<List<SearchResultItem>>> {
  final AppDatabase db;
  final DioHttpClient client;

  SearchNotifier(this.db, this.client) : super(const AsyncValue.data([]));

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      // 1. Try local SQLite search first
      final allTranslations = await db.select(db.translations).get();
      final matchingTrans = allTranslations.where(
        (t) => t.translationText.toLowerCase().contains(query.toLowerCase()),
      );

      final List<SearchResultItem> results = [];
      for (final t in matchingTrans) {
        final verse = await (db.select(db.verses)
              ..where((tbl) => tbl.id.equals(t.verseId)))
            .getSingleOrNull();

        if (verse != null) {
          results.add(
            SearchResultItem(
              surahId: verse.surahId,
              verseNumber: verse.verseNumber,
              textUthmani: verse.textUthmani,
              translationText: t.translationText,
            ),
          );
        }
      }

      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchResultItem>>>(
        (ref) {
  final db = ref.watch(databaseProvider);
  final client = ref.watch(httpClientProvider);
  return SearchNotifier(db, client);
});
