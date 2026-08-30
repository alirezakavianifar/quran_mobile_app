import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/card_generator/models/card_theme_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Ayah Card Generator Model & Theme Tests', () {
    test('Contains 4 unique visual theme presets with defined styling', () {
      expect(AyahCardTheme.presets.length, 4);

      for (final theme in AyahCardTheme.presets) {
        expect(theme.nameFa.isNotEmpty, isTrue);
        expect(theme.nameEn.isNotEmpty, isTrue);
        expect(theme.arabicTextColor, isA<Color>());
        expect(theme.translationTextColor, isA<Color>());
        expect(theme.citationColor, isA<Color>());
      }
    });

    test('getTheme retrieves correct theme by enum style', () {
      final emerald = AyahCardTheme.getTheme(CardThemeStyle.emeraldGold);
      expect(emerald.style, CardThemeStyle.emeraldGold);
      expect(emerald.nameFa, 'زمرد و طلا');

      final parchment = AyahCardTheme.getTheme(CardThemeStyle.parchmentSepia);
      expect(parchment.style, CardThemeStyle.parchmentSepia);
      expect(parchment.nameFa, 'کاغذ سنتی کهن');

      final glass = AyahCardTheme.getTheme(CardThemeStyle.modernGlass);
      expect(glass.style, CardThemeStyle.modernGlass);
      expect(glass.nameFa, 'شیشه‌ای مدرن');
    });

    test('CardAspectRatio has square and story variations', () {
      expect(CardAspectRatio.values, contains(CardAspectRatio.square));
      expect(CardAspectRatio.values, contains(CardAspectRatio.story));
    });
  });
}
