import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_mobile_app/src/features/notes/data/ayah_notes_repository.dart';
import 'package:quran_mobile_app/src/features/notes/models/ayah_note_model.dart';
import 'package:quran_mobile_app/src/features/notes/presentation/ayah_notes_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AyahNote Model Tests', () {
    test('AyahNote serialization and getters work as expected', () {
      final note = AyahNote(
        surahId: 2,
        verseNumber: 255,
        colorHex: '#4CAF50',
        noteText: 'Ayat al-Kursi reflection',
      );

      expect(note.key, '2_255');
      expect(note.hasHighlight, isTrue);
      expect(note.hasNote, isTrue);
      expect(note.isEmpty, isFalse);

      final map = note.toMap();
      final restored = AyahNote.fromMap(map);

      expect(restored.surahId, 2);
      expect(restored.verseNumber, 255);
      expect(restored.colorHex, '#4CAF50');
      expect(restored.noteText, 'Ayat al-Kursi reflection');
    });

    test('Palette parser extracts valid Color', () {
      final color = AyahHighlightPalette.getColorFromHex('#4CAF50');
      expect(color, isNotNull);
      expect(color!.value, 0xFF4CAF50);
    });
  });

  group('AyahNotesNotifier Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Saves highlight, edits reflection, and deletes note', () async {
      final repo = AyahNotesRepository();
      final notifier = AyahNotesNotifier(repo);
      await Future<void>.delayed(Duration.zero);

      expect(notifier.state.isEmpty, isTrue);

      // 1. Set highlight color
      await notifier.setHighlightColor(1, 1, '#4CAF50');
      expect(notifier.state.length, 1);
      expect(notifier.getNote(1, 1)?.colorHex, '#4CAF50');

      // 2. Add personal reflection note
      await notifier.saveAyahNote(
        surahId: 1,
        verseNumber: 1,
        noteText: 'Bismillah reflection',
      );
      expect(notifier.getNote(1, 1)?.noteText, 'Bismillah reflection');
      expect(notifier.getNote(1, 1)?.colorHex, '#4CAF50');

      // 3. Delete note
      await notifier.deleteNote(1, 1);
      expect(notifier.state.isEmpty, isTrue);
    });
  });
}
