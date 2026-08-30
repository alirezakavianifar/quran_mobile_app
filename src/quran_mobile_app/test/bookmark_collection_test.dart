import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/bookmarks/data/enhanced_bookmarks_repository.dart';
import 'package:quran_mobile_app/src/features/bookmarks/models/bookmark_collection_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookmarkFolder & TaggedBookmark Model Tests', () {
    test('Default presets contain expected standard folders', () {
      final presets = BookmarkFolder.defaultPresets;
      expect(presets.length, greaterThanOrEqualTo(4));
      expect(presets.any((f) => f.id == 'default'), isTrue);
      expect(presets.any((f) => f.id == 'tadabbur'), isTrue);
      expect(presets.any((f) => f.id == 'hifz'), isTrue);
    });

    test('TaggedBookmark model serialization round-trip', () {
      final bm = TaggedBookmark(
        surahNumber: 2,
        verseNumber: 255,
        folderId: 'tadabbur',
        tags: ['AyatAlKursi', 'Protection'],
        note: 'The greatest verse in the Quran',
        createdAt: DateTime(2026, 8, 30, 10, 0),
      );

      final map = bm.toMap();
      final restored = TaggedBookmark.fromMap(map);

      expect(restored.surahNumber, 2);
      expect(restored.verseNumber, 255);
      expect(restored.folderId, 'tadabbur');
      expect(restored.tags, ['AyatAlKursi', 'Protection']);
      expect(restored.note, 'The greatest verse in the Quran');
    });
  });

  group('EnhancedBookmarksRepository Operations Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Saving, retrieving, and removing bookmarks', () async {
      final repo = EnhancedBookmarksRepository();
      final initial = await repo.getBookmarks();
      expect(initial, isEmpty);

      final bm = TaggedBookmark(
        surahNumber: 36,
        verseNumber: 1,
        folderId: 'friday',
        tags: ['YaSin'],
        createdAt: DateTime.now(),
      );

      await repo.saveBookmark(bm);
      final retrieved = await repo.getBookmarks();
      expect(retrieved.length, 1);
      expect(retrieved['36_1']?.folderId, 'friday');

      await repo.removeBookmark(36, 1);
      final afterRemove = await repo.getBookmarks();
      expect(afterRemove, isEmpty);
    });

    test('Export and import backup JSON', () async {
      final repo = EnhancedBookmarksRepository();
      await repo.saveBookmark(
        TaggedBookmark(
          surahNumber: 1,
          verseNumber: 1,
          folderId: 'default',
          tags: ['Fatihah'],
          createdAt: DateTime.now(),
        ),
      );

      final exportedJson = await repo.exportToJson();
      expect(exportedJson.contains('Fatihah'), isTrue);

      // Clear repo
      SharedPreferences.setMockInitialValues({});
      final emptyRepo = EnhancedBookmarksRepository();
      expect((await emptyRepo.getBookmarks()), isEmpty);

      // Import backup
      final success = await emptyRepo.importFromJson(exportedJson);
      expect(success, isTrue);

      final restoredBookmarks = await emptyRepo.getBookmarks();
      expect(restoredBookmarks.length, 1);
      expect(restoredBookmarks['1_1']?.tags.first, 'Fatihah');
    });
  });
}
