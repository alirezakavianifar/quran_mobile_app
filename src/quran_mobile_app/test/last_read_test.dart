import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/reader/last_read_provider.dart';
import 'package:quran_mobile_app/src/features/reader/models/last_read_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Last Read & Resume Study Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('LastReadEntry toMap and fromMap serialization integrity', () {
      final now = DateTime(2026, 8, 31, 14, 30);
      final entry = LastReadEntry(
        surahId: 36,
        verseNumber: 12,
        pageNumber: 440,
        juzNumber: 22,
        surahNameArabic: 'يس',
        surahNamePersian: 'یس',
        surahNameEnglish: 'Yaseen',
        verseTextPreview: 'إِنَّا نَحْنُ نُحْىِ ٱلْمَوْتَىٰ',
        timestamp: now,
      );

      final map = entry.toMap();
      final reconstructed = LastReadEntry.fromMap(map);

      expect(reconstructed.surahId, 36);
      expect(reconstructed.verseNumber, 12);
      expect(reconstructed.pageNumber, 440);
      expect(reconstructed.juzNumber, 22);
      expect(reconstructed.surahNameArabic, 'يس');
      expect(reconstructed.surahNamePersian, 'یس');
      expect(reconstructed.surahNameEnglish, 'Yaseen');
      expect(reconstructed.verseTextPreview, 'إِنَّا نَحْنُ نُحْىِ ٱلْمَوْتَىٰ');
      expect(reconstructed.timestamp, now);
    });

    test('LastReadEntry copyWith modifies selected fields', () {
      final entry = LastReadEntry(
        surahId: 1,
        verseNumber: 1,
        pageNumber: 1,
        juzNumber: 1,
        surahNameArabic: 'الفاتحة',
        surahNamePersian: 'فاتحه',
        surahNameEnglish: 'Al-Fatihah',
        timestamp: DateTime.now(),
      );

      final updated = entry.copyWith(verseNumber: 5, pageNumber: 2);
      expect(updated.surahId, 1);
      expect(updated.verseNumber, 5);
      expect(updated.pageNumber, 2);
      expect(updated.surahNameArabic, 'الفاتحة');
    });

    test('LastReadRepository persists and retrieves entry from SharedPreferences', () async {
      final repo = LastReadRepository();

      // Initially null
      final initial = await repo.getLastRead();
      expect(initial, isNull);

      final entry = LastReadEntry(
        surahId: 2,
        verseNumber: 255,
        pageNumber: 42,
        juzNumber: 3,
        surahNameArabic: 'البقرة',
        surahNamePersian: 'بقره',
        surahNameEnglish: 'Al-Baqarah',
        verseTextPreview: 'ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلْحَىُّ ٱلْقَيُّومُ',
        timestamp: DateTime.now(),
      );

      await repo.saveLastRead(entry);

      final loaded = await repo.getLastRead();
      expect(loaded, isNotNull);
      expect(loaded!.surahId, 2);
      expect(loaded.verseNumber, 255);
      expect(loaded.pageNumber, 42);
      expect(loaded.juzNumber, 3);
      expect(loaded.surahNameArabic, 'البقرة');

      await repo.clearLastRead();
      final cleared = await repo.getLastRead();
      expect(cleared, isNull);
    });

    test('LastReadNotifier updates state and saves to repository', () async {
      final repo = LastReadRepository();
      final notifier = LastReadNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state, isNull);

      await notifier.recordLastRead(
        surahId: 18,
        verseNumber: 1,
        pageNumber: 293,
        juzNumber: 15,
        surahNameArabic: 'الكهف',
        surahNamePersian: 'کهف',
        surahNameEnglish: 'Al-Kahf',
        verseTextPreview: 'ٱلْحَمْدُ لِلَّهِ ٱلَّذِىٓ أَنزَلَ عَلَىٰ عَبْدِهِ ٱلْكِتَٰبَ',
      );

      expect(notifier.state, isNotNull);
      expect(notifier.state!.surahId, 18);
      expect(notifier.state!.verseNumber, 1);
      expect(notifier.state!.surahNameEnglish, 'Al-Kahf');

      // Verify persistence in repo
      final fromRepo = await repo.getLastRead();
      expect(fromRepo, isNotNull);
      expect(fromRepo!.surahId, 18);
      expect(fromRepo.verseNumber, 1);

      // Clearing
      await notifier.clearLastRead();
      expect(notifier.state, isNull);
      expect(await repo.getLastRead(), isNull);
    });
  });
}
