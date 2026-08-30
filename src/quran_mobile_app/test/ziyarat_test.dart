import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/ziyarat/data/ziyarat_data.dart';
import 'package:quran_mobile_app/src/features/ziyarat/models/ziyarat_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ZiyaratData & Model Tests', () {
    test('Contains major authentic Ziyarats and Duas', () {
      final list = ZiyaratData.allZiyarat;
      expect(list.length, greaterThanOrEqualTo(6));

      final ashura = list.firstWhere((z) => z.id == 'ashura');
      expect(ashura.titleFa, 'زیارت عاشورا');
      expect(ashura.sections.any((s) => s.isInteractive100x && s.targetRepeat == 100), isTrue);

      final warith = list.firstWhere((z) => z.id == 'warith');
      expect(warith.titleFa, 'زیارت وارث');

      final kumayl = list.firstWhere((z) => z.id == 'kumayl');
      expect(kumayl.titleFa, 'دعای کمیل');

      final tawassul = list.firstWhere((z) => z.id == 'tawassul');
      expect(tawassul.titleFa, 'دعای توسل');

      final aleYasin = list.firstWhere((z) => z.id == 'ale_yasin');
      expect(aleYasin.titleFa, 'زیارت آل یاسین');

      final ahd = list.firstWhere((z) => z.id == 'ahd');
      expect(ahd.titleFa, 'دعای عهد');
    });

    test('All Ziyarat sections have valid non-empty Arabic and translations', () {
      for (final item in ZiyaratData.allZiyarat) {
        expect(item.id.isNotEmpty, isTrue);
        expect(item.titleFa.isNotEmpty, isTrue);
        expect(item.titleEn.isNotEmpty, isTrue);
        expect(item.titleAr.isNotEmpty, isTrue);
        expect(item.virtueFa.isNotEmpty, isTrue);
        expect(item.sections.isNotEmpty, isTrue);

        for (final sec in item.sections) {
          expect(sec.arabicText.isNotEmpty, isTrue);
          expect(sec.translationFa.isNotEmpty, isTrue);
          expect(sec.translationEn.isNotEmpty, isTrue);
          expect(sec.targetRepeat, greaterThan(0));
        }
      }
    });

    test('ZiyaratItem & ZiyaratSection serialization round-trip', () {
      final sample = ZiyaratData.allZiyarat.first;
      final map = sample.toMap();
      final restored = ZiyaratItem.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.titleFa, sample.titleFa);
      expect(restored.sections.length, sample.sections.length);
      expect(restored.sections[1].isInteractive100x, sample.sections[1].isInteractive100x);
      expect(restored.sections[1].targetRepeat, 100);
    });
  });
}
