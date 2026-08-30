import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/tajweed/data/tajweed_rules_data.dart';
import 'package:quran_mobile_app/src/features/tajweed/models/tajweed_rule_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TajweedRule Model & Data Tests', () {
    test('Contains all 6 core Tajweed rule families with valid colors and descriptions', () {
      final rules = TajweedRulesData.allRules;
      expect(rules.length, 6);

      final types = rules.map((r) => r.type).toSet();
      expect(types.length, 6);
      expect(types.contains(TajweedRuleType.ghunnah), isTrue);
      expect(types.contains(TajweedRuleType.qalqalah), isTrue);
      expect(types.contains(TajweedRuleType.ikhfa), isTrue);
      expect(types.contains(TajweedRuleType.idgham), isTrue);
      expect(types.contains(TajweedRuleType.madd), isTrue);
      expect(types.contains(TajweedRuleType.iqlab), isTrue);

      for (final r in rules) {
        expect(r.nameAr.isNotEmpty, isTrue);
        expect(r.nameFa.isNotEmpty, isTrue);
        expect(r.nameEn.isNotEmpty, isTrue);
        expect(r.colorHex.startsWith('#'), isTrue);
        expect(r.descriptionFa.isNotEmpty, isTrue);
        expect(r.descriptionEn.isNotEmpty, isTrue);
        expect(r.letters.isNotEmpty, isTrue);
        expect(r.examples.isNotEmpty, isTrue);
      }
    });

    test('All examples have valid Quranic verse citations and explanations', () {
      for (final rule in TajweedRulesData.allRules) {
        for (final ex in rule.examples) {
          expect(ex.arabicText.isNotEmpty, isTrue);
          expect(ex.highlightSnippet.isNotEmpty, isTrue);
          expect(ex.surahNumber, inInclusiveRange(1, 114));
          expect(ex.verseNumber, greaterThan(0));
          expect(ex.explanation.isNotEmpty, isTrue);
        }
      }
    });

    test('TajweedRule serialization round-trip', () {
      final sample = TajweedRulesData.allRules.first;
      final map = sample.toMap();
      final restored = TajweedRule.fromMap(map);

      expect(restored.type, sample.type);
      expect(restored.nameAr, sample.nameAr);
      expect(restored.colorHex, sample.colorHex);
      expect(restored.examples.length, sample.examples.length);
    });
  });
}
