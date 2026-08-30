import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyActivity {
  final String dateKey; // YYYY-MM-DD
  final int versesRead;
  final int pagesCompleted;
  final int listeningMinutes;

  const DailyActivity({
    required this.dateKey,
    this.versesRead = 0,
    this.pagesCompleted = 0,
    this.listeningMinutes = 0,
  });

  int get totalActivityPoints =>
      versesRead + (pagesCompleted * 15) + (listeningMinutes * 2);

  int get intensityLevel {
    final points = totalActivityPoints;
    if (points == 0) return 0;
    if (points < 10) return 1;
    if (points < 30) return 2;
    if (points < 60) return 3;
    return 4;
  }

  Map<String, dynamic> toMap() => {
        'dateKey': dateKey,
        'versesRead': versesRead,
        'pagesCompleted': pagesCompleted,
        'listeningMinutes': listeningMinutes,
      };

  factory DailyActivity.fromMap(Map<String, dynamic> map) => DailyActivity(
        dateKey: map['dateKey'] as String,
        versesRead: (map['versesRead'] as int?) ?? 0,
        pagesCompleted: (map['pagesCompleted'] as int?) ?? 0,
        listeningMinutes: (map['listeningMinutes'] as int?) ?? 0,
      );

  DailyActivity copyWith({
    int? versesRead,
    int? pagesCompleted,
    int? listeningMinutes,
  }) {
    return DailyActivity(
      dateKey: dateKey,
      versesRead: versesRead ?? this.versesRead,
      pagesCompleted: pagesCompleted ?? this.pagesCompleted,
      listeningMinutes: listeningMinutes ?? this.listeningMinutes,
    );
  }
}

class ReadingActivityRepository {
  static const String _storageKey = 'quran_reading_activity_history';

  String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<Map<String, DailyActivity>> getAllActivities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null || jsonStr.isEmpty) return {};

    try {
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      return decoded.map(
        (key, value) => MapEntry(
          key,
          DailyActivity.fromMap(value as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  Future<void> _saveAllActivities(Map<String, DailyActivity> activities) async {
    final prefs = await SharedPreferences.getInstance();
    final map = activities.map((k, v) => MapEntry(k, v.toMap()));
    await prefs.setString(_storageKey, jsonEncode(map));
  }

  Future<void> logVerseRead({int count = 1}) async {
    final activities = await getAllActivities();
    final today = _todayKey();
    final current = activities[today] ?? DailyActivity(dateKey: today);
    activities[today] = current.copyWith(versesRead: current.versesRead + count);
    await _saveAllActivities(activities);
  }

  Future<void> logPageCompleted() async {
    final activities = await getAllActivities();
    final today = _todayKey();
    final current = activities[today] ?? DailyActivity(dateKey: today);
    activities[today] =
        current.copyWith(pagesCompleted: current.pagesCompleted + 1);
    await _saveAllActivities(activities);
  }

  Future<void> logListeningMinutes(int minutes) async {
    final activities = await getAllActivities();
    final today = _todayKey();
    final current = activities[today] ?? DailyActivity(dateKey: today);
    activities[today] =
        current.copyWith(listeningMinutes: current.listeningMinutes + minutes);
    await _saveAllActivities(activities);
  }

  Future<int> calculateCurrentStreak(Map<String, DailyActivity> activities) async {
    if (activities.isEmpty) return 0;

    int streak = 0;
    DateTime date = DateTime.now();

    final todayKey = DateFormat('yyyy-MM-dd').format(date);
    final hasActivityToday = (activities[todayKey]?.totalActivityPoints ?? 0) > 0;

    if (hasActivityToday) {
      streak++;
      date = date.subtract(const Duration(days: 1));
    } else {
      // Check if yesterday had activity
      final yesterday = date.subtract(const Duration(days: 1));
      final yesterdayKey = DateFormat('yyyy-MM-dd').format(yesterday);
      if ((activities[yesterdayKey]?.totalActivityPoints ?? 0) > 0) {
        date = yesterday;
      } else {
        return 0;
      }
    }

    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      final act = activities[key];
      if (act != null && act.totalActivityPoints > 0) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }
}

final readingActivityRepositoryProvider =
    Provider<ReadingActivityRepository>((ref) => ReadingActivityRepository());
