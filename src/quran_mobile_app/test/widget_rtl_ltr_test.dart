import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/main.dart';
import 'package:quran_mobile_app/src/core/localization/app_localizations.dart';

void main() {
  group('Flutter Widget & Directionality Tests', () {
    testWidgets('App renders in Persian RTL layout by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: QuranMobileApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      final directionalityFinder = find.byType(Directionality);
      expect(directionalityFinder, findsWidgets);

      final Directionality firstDirectionality = tester.widget(directionalityFinder.first);
      expect(firstDirectionality.textDirection, equals(TextDirection.rtl));
    });

    testWidgets('Language toggle changes layout to English LTR', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const QuranMobileApp(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Toggle language to English
      container.read(localeProvider.notifier).setEnglish();
      await tester.pump(const Duration(milliseconds: 500));

      final directionalityFinder = find.byType(Directionality);
      final Directionality firstDirectionality = tester.widget(directionalityFinder.first);
      expect(firstDirectionality.textDirection, equals(TextDirection.ltr));
    });
  });
}
