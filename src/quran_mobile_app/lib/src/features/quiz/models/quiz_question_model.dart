enum QuizType {
  nextVerse, // What is the next Ayah?
  missingWord, // Fill in the blank
  surahIdentification, // Which Surah does this Ayah belong to?
}

class QuizQuestion {
  final int id;
  final QuizType type;
  final String promptTextFa;
  final String promptTextEn;
  final String arabicSnippet;
  final List<String> options;
  final int correctAnswerIndex;
  final int surahNumber;
  final int verseNumber;
  final String explanationFa;
  final String explanationEn;

  const QuizQuestion({
    required this.id,
    required this.type,
    required this.promptTextFa,
    required this.promptTextEn,
    required this.arabicSnippet,
    required this.options,
    required this.correctAnswerIndex,
    required this.surahNumber,
    required this.verseNumber,
    required this.explanationFa,
    required this.explanationEn,
  });

  String get correctAnswer => options[correctAnswerIndex];

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type.name,
        'promptTextFa': promptTextFa,
        'promptTextEn': promptTextEn,
        'arabicSnippet': arabicSnippet,
        'options': options,
        'correctAnswerIndex': correctAnswerIndex,
        'surahNumber': surahNumber,
        'verseNumber': verseNumber,
        'explanationFa': explanationFa,
        'explanationEn': explanationEn,
      };

  factory QuizQuestion.fromMap(Map<String, dynamic> map) => QuizQuestion(
        id: map['id'] as int,
        type: QuizType.values.firstWhere(
          (e) => e.name == map['type'],
          orElse: () => QuizType.nextVerse,
        ),
        promptTextFa: map['promptTextFa'] as String,
        promptTextEn: map['promptTextEn'] as String,
        arabicSnippet: map['arabicSnippet'] as String,
        options: List<String>.from(map['options'] as List),
        correctAnswerIndex: map['correctAnswerIndex'] as int,
        surahNumber: map['surahNumber'] as int,
        verseNumber: map['verseNumber'] as int,
        explanationFa: map['explanationFa'] as String,
        explanationEn: map['explanationEn'] as String,
      );
}
