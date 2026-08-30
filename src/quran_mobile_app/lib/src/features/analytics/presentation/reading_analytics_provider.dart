import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../data/reading_activity_repository.dart';

class ReadingAnalyticsState {
  final Map<String, DailyActivity> activities;
  final int currentStreak;
  final int totalVersesRead;
  final int totalPagesCompleted;
  final int totalListeningMinutes;
  final DailyActivity todayActivity;
  final List<DailyActivity> last7Days;

  const ReadingAnalyticsState({
    this.activities = const {},
    this.currentStreak = 0,
    this.totalVersesRead = 0,
    this.totalPagesCompleted = 0,
    this.totalListeningMinutes = 0,
    required this.todayActivity,
    this.last7Days = const [],
  });

  factory ReadingAnalyticsState.initial() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return ReadingAnalyticsState(
      todayActivity: DailyActivity(dateKey: today),
    );
  }

  ReadingAnalyticsState copyWith({
    Map<String, DailyActivity>? activities,
    int? currentStreak,
    int? totalVersesRead,
    int? totalPagesCompleted,
    int? totalListeningMinutes,
    DailyActivity? todayActivity,
    List<DailyActivity>? last7Days,
  }) {
    return ReadingAnalyticsState(
      activities: activities ?? this.activities,
      currentStreak: currentStreak ?? this.currentStreak,
      totalVersesRead: totalVersesRead ?? this.totalVersesRead,
      totalPagesCompleted: totalPagesCompleted ?? this.totalPagesCompleted,
      totalListeningMinutes:
          totalListeningMinutes ?? this.totalListeningMinutes,
      todayActivity: todayActivity ?? this.todayActivity,
      last7Days: last7Days ?? this.last7Days,
    );
  }
}

class ReadingAnalyticsNotifier extends StateNotifier<ReadingAnalyticsState> {
  final ReadingActivityRepository _repository;

  ReadingAnalyticsNotifier(this._repository)
      : super(ReadingAnalyticsState.initial()) {
    loadAnalytics();
  }

  Future<void> loadAnalytics() async {
    final activities = await _repository.getAllActivities();
    final streak = await _repository.calculateCurrentStreak(activities);

    int totalV = 0;
    int totalP = 0;
    int totalM = 0;

    for (final act in activities.values) {
      totalV += act.versesRead;
      totalP += act.pagesCompleted;
      totalM += act.listeningMinutes;
    }

    final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayAct = activities[todayKey] ?? DailyActivity(dateKey: todayKey);

    // Calculate last 7 days
    final last7 = <DailyActivity>[];
    for (int i = 6; i >= 0; i--) {
      final d = DateTime.now().subtract(Duration(days: i));
      final k = DateFormat('yyyy-MM-dd').format(d);
      last7.add(activities[k] ?? DailyActivity(dateKey: k));
    }

    state = state.copyWith(
      activities: activities,
      currentStreak: streak,
      totalVersesRead: totalV,
      totalPagesCompleted: totalP,
      totalListeningMinutes: totalM,
      todayActivity: todayAct,
      last7Days: last7,
    );
  }

  Future<void> logVerseRead({int count = 1}) async {
    await _repository.logVerseRead(count: count);
    await loadAnalytics();
  }

  Future<void> logPageCompleted() async {
    await _repository.logPageCompleted();
    await loadAnalytics();
  }

  Future<void> logListeningMinutes(int minutes) async {
    await _repository.logListeningMinutes(minutes);
    await loadAnalytics();
  }
}

final readingAnalyticsProvider =
    StateNotifierProvider<ReadingAnalyticsNotifier, ReadingAnalyticsState>(
        (ref) {
  final repo = ref.watch(readingActivityRepositoryProvider);
  return ReadingAnalyticsNotifier(repo);
});
