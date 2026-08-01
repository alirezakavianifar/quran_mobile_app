import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../../core/network/dio_http_client.dart';
import '../reader/reader_provider.dart';

import '../../core/database/verse_seed_data.dart';

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

  Future<void> performSearch(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      await db.seedInitialData();
      final normalizedQuery = _normalizeText(query);
      final cleanQuery = normalizedQuery
          .replaceAll('سوره', '')
          .replaceAll('سورة', '')
          .replaceAll('surah', '')
          .replaceAll('sura', '')
          .trim();

      final List<SearchResultItem> results = [];
      final Set<String> addedKeys = {};

      // 1. Surah Name / Number Match (e.g. 'سوره یس', 'سورة يس', 'یاسین', 'Ya-Sin', '36')
      final allSurahs = await db.select(db.surahs).get();
      final targetQuery = cleanQuery.isEmpty ? normalizedQuery : cleanQuery;

      final matchedSurahs = allSurahs.where((s) {
        final sNum = s.number.toString();
        final nameAr = _normalizeText(s.nameArabic);
        final nameFa = _normalizeText(s.namePersian);
        final nameEn = s.nameEnglish.toLowerCase();

        return sNum == targetQuery ||
            nameAr == targetQuery ||
            nameFa == targetQuery ||
            nameAr.contains(targetQuery) ||
            nameFa.contains(targetQuery) ||
            nameEn.contains(targetQuery);
      }).toList();

      for (final s in matchedSurahs) {
        final verses = allQuranVersesMap[s.number] ?? [];
        for (final v in verses) {
          final key = '${v.surahId}:${v.verseNumber}';
          if (!addedKeys.contains(key)) {
            addedKeys.add(key);
            results.add(
              SearchResultItem(
                surahId: v.surahId,
                verseNumber: v.verseNumber,
                textUthmani: v.textUthmani,
                translationText: v.translationFa.isNotEmpty ? v.translationFa : v.translationEn,
                score: 10.0,
              ),
            );
          }
        }
      }

      // 2. Arabic Text Match across all 6,236 verses
      allQuranVersesMap.forEach((surahId, verseList) {
        for (final v in verseList) {
          final normUthmani = _normalizeText(v.textUthmani);
          final normSimple = _normalizeText(v.textSimple);

          if (normUthmani.contains(targetQuery) || normSimple.contains(targetQuery)) {
            final key = '${v.surahId}:${v.verseNumber}';
            if (!addedKeys.contains(key)) {
              addedKeys.add(key);
              results.add(
                SearchResultItem(
                  surahId: v.surahId,
                  verseNumber: v.verseNumber,
                  textUthmani: v.textUthmani,
                  translationText: v.translationFa,
                  score: 8.0,
                ),
              );
            }
          }
        }
      });

      // 3. Translation Match across Persian and English
      allQuranVersesMap.forEach((surahId, verseList) {
        for (final v in verseList) {
          final normFa = _normalizeText(v.translationFa);
          final normEn = _normalizeText(v.translationEn);

          if (normFa.contains(targetQuery) || normEn.contains(targetQuery)) {
            final key = '${v.surahId}:${v.verseNumber}';
            if (!addedKeys.contains(key)) {
              addedKeys.add(key);
              results.add(
                SearchResultItem(
                  surahId: v.surahId,
                  verseNumber: v.verseNumber,
                  textUthmani: v.textUthmani,
                  translationText: normFa.contains(targetQuery) ? v.translationFa : v.translationEn,
                  score: 5.0,
                ),
              );
            }
          }
        }
      });

      // Sort results by relevance score descending
      results.sort((a, b) => b.score.compareTo(a.score));

      state = AsyncValue.data(results);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  String _normalizeText(String text) {
    return text
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('إ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '') // Strip tashkeel/erab
        .toLowerCase()
        .trim();
  }
}

final searchProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<List<SearchResultItem>>>(
        (ref) {
  final db = ref.watch(databaseProvider);
  final client = ref.watch(httpClientProvider);
  return SearchNotifier(db, client);
});
