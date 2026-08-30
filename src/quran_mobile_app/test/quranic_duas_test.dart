import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/duas/data/quranic_duas_data.dart';
import 'package:quran_mobile_app/src/features/duas/models/quranic_dua_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranicDuasData & Model Tests', () {
    test('Curated dataset contains non-empty valid supplications', () {
      final list = QuranicDuasData.allDuas;
      expect(list.isNotEmpty, isTrue);

      for (final dua in list) {
        expect(dua.id, greaterThan(0));
        expect(dua.arabicText.isNotEmpty, isTrue);
        expect(dua.translationFa.isNotEmpty, isTrue);
        expect(dua.translationEn.isNotEmpty, isTrue);
        expect(dua.surahNumber, inInclusiveRange(1, 114));
        expect(dua.verseNumber, greaterThan(0));
      }
    });

    test('All categories have represented supplications', () {
      for (final category in DuaCategory.values) {
        final matching =
            QuranicDuasData.allDuas.where((d) => d.category == category).toList();
        expect(matching.isNotEmpty, isTrue,
            reason: 'Category ${category.name} should have at least 1 dua');
      }
    });

    test('QuranicDua serialization round-trip', () {
      final sample = QuranicDuasData.allDuas.first;
      final map = sample.toMap();
      final restored = QuranicDua.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.arabicText, sample.arabicText);
      expect(restored.category, sample.category);
      expect(restored.ayahKey, '7:23');
    });
  });
}
