import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../data/quiz_data_generator.dart';
import '../models/quiz_question_model.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  late List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int? _selectedAnswer;
  bool _hasAnswered = false;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _questions = List<QuizQuestion>.from(QuizDataGenerator.curatedQuestions)..shuffle();
      _currentIndex = 0;
      _score = 0;
      _streak = 0;
      _selectedAnswer = null;
      _hasAnswered = false;
      _isFinished = false;
    });
  }

  void _selectAnswer(int optionIndex) {
    if (_hasAnswered) return;

    final question = _questions[_currentIndex];
    final isCorrect = optionIndex == question.correctAnswerIndex;

    HapticFeedback.mediumImpact();

    setState(() {
      _selectedAnswer = optionIndex;
      _hasAnswered = true;
      if (isCorrect) {
        _streak++;
        _score += 10 + (_streak * 2);
      } else {
        _streak = 0;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex + 1 < _questions.length) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _hasAnswered = false;
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    if (_isFinished) {
      return Scaffold(
        appBar: AppBar(title: Text(isPersian ? 'نتیجه آزمون قرآنی' : 'Quiz Summary')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  isPersian ? 'آزمون به پایان رسید! 🎉' : 'Quiz Completed! 🎉',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  isPersian
                      ? 'امتیاز کسب‌شده شما: ${PersianDigitConverter.toPersian("$_score")}'
                      : 'Your Final Score: $_score points',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  icon: const Icon(Icons.replay_rounded),
                  label: Text(isPersian ? 'شروع آزمون مجدد' : 'Play Again'),
                  onPressed: _startNewGame,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(isPersian ? 'بازگشت' : 'Back to Home'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final progress = (_currentIndex + 1) / _questions.length;

    String typeLabel;
    switch (question.type) {
      case QuizType.missingWord:
        typeLabel = isPersian ? 'کلمه جاافتاده' : 'Missing Word';
        break;
      case QuizType.nextVerse:
        typeLabel = isPersian ? 'آیه بعدی' : 'Next Ayah';
        break;
      case QuizType.surahIdentification:
        typeLabel = isPersian ? 'شناسایی سوره' : 'Surah ID';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'مسابقه و آزمون قرآنی' : 'Quranic Knowledge Quiz'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Stats: Progress, Score & Streak
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPersian
                      ? 'سوال ${PersianDigitConverter.toPersian("${_currentIndex + 1}")} از ${PersianDigitConverter.toPersian("${_questions.length}")}'
                      : 'Question ${_currentIndex + 1} of ${_questions.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Row(
                  children: [
                    if (_streak > 1) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, size: 14, color: Colors.orange),
                            const SizedBox(width: 2),
                            Text(
                              isPersian
                                  ? '${PersianDigitConverter.toPersian("$_streak")} متوالی'
                                  : '$_streak streak',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isPersian
                            ? 'امتیاز: ${PersianDigitConverter.toPersian("$_score")}'
                            : 'Score: $_score',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: progress, minHeight: 6),
            ),
            const SizedBox(height: 20),

            // Question Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: isPersian ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPersian ? question.promptTextFa : question.promptTextEn,
                      textAlign: isPersian ? TextAlign.right : TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        question.arabicSnippet,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppTheme.getArabicQuranTextStyle(
                          fontSize: 20,
                          fontFamily: 'Amiri',
                          color: Theme.of(context).colorScheme.primary,
                        ).copyWith(fontWeight: FontWeight.bold, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Multiple Choice Options
            ...List.generate(question.options.length, (idx) {
              final opt = question.options[idx];
              final isCorrectOpt = idx == question.correctAnswerIndex;
              final isSelectedOpt = idx == _selectedAnswer;

              Color? btnBg;
              Color? borderColor;
              Color? textColor;

              if (_hasAnswered) {
                if (isCorrectOpt) {
                  btnBg = Colors.green.withValues(alpha: 0.15);
                  borderColor = Colors.green;
                  textColor = Colors.green.shade800;
                } else if (isSelectedOpt) {
                  btnBg = Colors.red.withValues(alpha: 0.15);
                  borderColor = Colors.red;
                  textColor = Colors.red.shade800;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _hasAnswered ? null : () => _selectAnswer(idx),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: btnBg ?? Theme.of(context).cardColor,
                      border: Border.all(
                        color: borderColor ?? Theme.of(context).colorScheme.outlineVariant,
                        width: isSelectedOpt || isCorrectOpt ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isPersian
                                ? PersianDigitConverter.toPersian('${idx + 1}')
                                : '${idx + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            opt,
                            textAlign: isPersian ? TextAlign.right : TextAlign.left,
                            textDirection: TextDirection.rtl,
                            style: AppTheme.getArabicQuranTextStyle(
                              fontSize: 16,
                              fontFamily: 'Amiri',
                              color: textColor,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (_hasAnswered && isCorrectOpt)
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20)
                        else if (_hasAnswered && isSelectedOpt)
                          const Icon(Icons.cancel_rounded, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Explanation Box & Next Button
            if (_hasAnswered) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isPersian ? question.explanationFa : question.explanationEn,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _nextQuestion,
                child: Text(
                  _currentIndex + 1 < _questions.length
                      ? (isPersian ? 'سوال بعدی' : 'Next Question')
                      : (isPersian ? 'مشاهده نتیجه' : 'View Results'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
