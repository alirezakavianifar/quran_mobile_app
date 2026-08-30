import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/asmaul_husna/data/asmaul_husna_data.dart';
import 'package:quran_mobile_app/src/features/asmaul_husna/models/asmaul_husna_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AsmaulHusna Data & Model Tests', () {
    test('Contains curated Divine Names with valid unique sequential numbers', () {
      final names = AsmaulHusnaData.allNames;
      expect(names.length, greaterThanOrEqualTo(40));

      final numbers = <int>{};
      for (final n in names) {
        expect(n.number, greaterThan(0));
        numbers.add(n.number);
        expect(n.nameAr.isNotEmpty, isTrue);
        expect(n.transliteration.isNotEmpty, isTrue);
        expect(n.meaningFa.isNotEmpty, isTrue);
        expect(n.meaningEn.isNotEmpty, isTrue);
        expect(n.quranCitation.isNotEmpty, isTrue);
        expect(n.spiritualBenefitFa.isNotEmpty, isTrue);
        expect(n.spiritualBenefitEn.isNotEmpty, isTrue);
      }
      expect(numbers.length, names.length);
    });

    test('First Divine Name is Ar-Rahman and Second is Ar-Raheem', () {
      final first = AsmaulHusnaData.allNames.first;
      final second = AsmaulHusnaData.allNames[1];

      expect(first.number, 1);
      expect(first.nameAr, 'الرَّحْمَنُ');
      expect(first.transliteration, 'Ar-Rahman');

      expect(second.number, 2);
      expect(second.nameAr, 'الرَّحِيمُ');
      expect(second.transliteration, 'Ar-Raheem');
    });

    test('DivineName serialization round-trip', () {
      final sample = AsmaulHusnaData.allNames.first;
      final map = sample.toMap();
      final restored = DivineName.fromMap(map);

      expect(restored.number, sample.number);
      expect(restored.nameAr, sample.nameAr);
      expect(restored.transliteration, sample.transliteration);
      expect(restored.meaningFa, sample.meaningFa);
      expect(restored.quranCitation, sample.quranCitation);
    });
  });
}
