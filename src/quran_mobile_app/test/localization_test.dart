import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/localization/app_localizations.dart';

void main() {
  group('AppLocalizations & LocaleNotifier Unit Tests', () {
    test('AppLocalizations returns Persian translations by default', () {
      final loc = AppLocalizations(const Locale('fa', 'IR'));
      expect(loc.isPersian, isTrue);
      expect(loc.textDirection, TextDirection.rtl);
      expect(loc.translate('surahs'), 'سوره‌ها');
      expect(loc.translate('aiAssistant'), 'دستیار هوشمند قرآن');
    });

    test('AppLocalizations returns English translations for en_US', () {
      final loc = AppLocalizations(const Locale('en', 'US'));
      expect(loc.isPersian, isFalse);
      expect(loc.textDirection, TextDirection.ltr);
      expect(loc.translate('surahs'), 'Surahs');
      expect(loc.translate('aiAssistant'), 'AI Assistant');
    });

    test('LocaleNotifier toggles language between Persian and English', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(localeProvider.notifier);
      expect(container.read(localeProvider), const Locale('fa', 'IR'));
      expect(container.read(textDirectionProvider), TextDirection.rtl);

      notifier.setEnglish();
      expect(container.read(localeProvider), const Locale('en', 'US'));
      expect(container.read(textDirectionProvider), TextDirection.ltr);

      notifier.toggleLanguage();
      expect(container.read(localeProvider), const Locale('fa', 'IR'));
      expect(container.read(textDirectionProvider), TextDirection.rtl);
    });
  });
}
