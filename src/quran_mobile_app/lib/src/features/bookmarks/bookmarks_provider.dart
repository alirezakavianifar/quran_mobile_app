import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/app_database.dart';
import '../reader/reader_provider.dart';

class BookmarksNotifier extends StateNotifier<AsyncValue<List<Bookmark>>> {
  final AppDatabase db;

  BookmarksNotifier(this.db) : super(const AsyncValue.loading()) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      state = const AsyncValue.loading();
      final list = await db.select(db.bookmarks).get();
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addBookmark(int surahId, int verseNumber, {String? note}) async {
    await db.into(db.bookmarks).insert(
          BookmarksCompanion.insert(
            surahId: surahId,
            verseNumber: verseNumber,
            note: Value(note),
          ),
        );
    await loadBookmarks();
  }

  Future<void> removeBookmark(int id) async {
    await (db.delete(db.bookmarks)..where((tbl) => tbl.id.equals(id))).go();
    await loadBookmarks();
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, AsyncValue<List<Bookmark>>>((ref) {
  final db = ref.watch(databaseProvider);
  return BookmarksNotifier(db);
});
