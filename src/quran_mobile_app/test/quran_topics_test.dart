import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/topics/data/quran_topics_data.dart';
import 'package:quran_mobile_app/src/features/topics/models/quran_topic_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranTopic Model & Data Tests', () {
    test('Curated topics catalog has valid categories, descriptions and verses', () {
      final topics = QuranTopicsData.allTopics;
      expect(topics.length, greaterThanOrEqualTo(6));

      for (final t in topics) {
        expect(t.id.isNotEmpty, isTrue);
        expect(t.titleFa.isNotEmpty, isTrue);
        expect(t.titleEn.isNotEmpty, isTrue);
        expect(t.categoryFa.isNotEmpty, isTrue);
        expect(t.categoryEn.isNotEmpty, isTrue);
        expect(t.descriptionFa.isNotEmpty, isTrue);
        expect(t.descriptionEn.isNotEmpty, isTrue);
        expect(t.iconName.isNotEmpty, isTrue);
        expect(t.verses.isNotEmpty, isTrue);

        for (final v in t.verses) {
          expect(v.surahNumber, inInclusiveRange(1, 114));
          expect(v.verseNumber, greaterThan(0));
          expect(v.surahNameFa.isNotEmpty, isTrue);
          expect(v.surahNameEn.isNotEmpty, isTrue);
          expect(v.arabicText.isNotEmpty, isTrue);
          expect(v.translationFa.isNotEmpty, isTrue);
          expect(v.translationEn.isNotEmpty, isTrue);
        }
      }
    });

    test('QuranTopic model serialization round-trip', () {
      final sample = QuranTopicsData.allTopics.first;
      final map = sample.toMap();
      final restored = QuranTopic.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.titleFa, sample.titleFa);
      expect(restored.categoryFa, sample.categoryFa);
      expect(restored.verses.length, sample.verses.length);
    });
  });
}
