import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/features/quiz/data/quiz_data_generator.dart';
import 'package:quran_mobile_app/src/features/quiz/models/quiz_question_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizQuestion Model & Data Tests', () {
    test('Curated question catalog contains valid multiple choice items', () {
      final questions = QuizDataGenerator.curatedQuestions;
      expect(questions.length, greaterThanOrEqualTo(10));

      for (final q in questions) {
        expect(q.id, greaterThan(0));
        expect(q.promptTextFa.isNotEmpty, isTrue);
        expect(q.promptTextEn.isNotEmpty, isTrue);
        expect(q.arabicSnippet.isNotEmpty, isTrue);
        expect(q.options.length, 4);
        expect(q.correctAnswerIndex, inInclusiveRange(0, 3));
        expect(q.correctAnswer.isNotEmpty, isTrue);
        expect(q.surahNumber, inInclusiveRange(1, 114));
        expect(q.verseNumber, greaterThan(0));
      }
    });

    test('All quiz types are represented in catalog', () {
      for (final type in QuizType.values) {
        final matching =
            QuizDataGenerator.curatedQuestions.where((q) => q.type == type).toList();
        expect(matching.isNotEmpty, isTrue,
            reason: 'QuizType ${type.name} should have at least 1 question');
      }
    });

    test('QuizQuestion serialization round-trip', () {
      final sample = QuizDataGenerator.curatedQuestions.first;
      final map = sample.toMap();
      final restored = QuizQuestion.fromMap(map);

      expect(restored.id, sample.id);
      expect(restored.type, sample.type);
      expect(restored.correctAnswerIndex, sample.correctAnswerIndex);
      expect(restored.correctAnswer, sample.correctAnswer);
    });
  });
}
