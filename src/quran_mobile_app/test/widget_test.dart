import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/main.dart';

void main() {
  testWidgets('QuranMobileApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: QuranMobileApp()));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(QuranMobileApp), findsOneWidget);
  });
}
