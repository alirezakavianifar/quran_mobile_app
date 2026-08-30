import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../../reader/reader_provider.dart';
import '../../reader/verse_detail_view.dart';
import '../data/daily_ayah_curator.dart';
import '../models/reminder_settings_model.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  static const String _prefsKey = 'quran_reminder_settings';
  ReminderSettings _settings = const ReminderSettings();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr != null) {
      try {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        setState(() {
          _settings = ReminderSettings.fromMap(map);
        });
      } catch (_) {}
    }
  }

  Future<void> _updateSettings(ReminderSettings newSettings) async {
    setState(() {
      _settings = newSettings;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(newSettings.toMap()));

    // Schedule / cancel notifications with NotificationService
    try {
      await NotificationService.instance.requestPermissions();
      final todayAyah = DailyAyahCurator.getTodayAyah();

      // 1. Daily Ayah
      if (newSettings.dailyAyahEnabled) {
        final parts = newSettings.dailyAyahTime.split(':');
        final h = int.tryParse(parts[0]) ?? 8;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        await NotificationService.instance.scheduleDaily(
          id: NotificationService.idDailyAyah,
          title: 'آیه روز: ${todayAyah.surahNameFa}',
          body: '${todayAyah.arabicText}\n${todayAyah.translationFa}',
          hour: h,
          minute: m,
          channelId: NotificationService.channelDailyAyah,
        );
      } else {
        await NotificationService.instance.cancelNotification(NotificationService.idDailyAyah);
      }

      // 2. Khatmah Reminder
      if (newSettings.khatmahReminderEnabled) {
        final parts = newSettings.khatmahTime.split(':');
        final h = int.tryParse(parts[0]) ?? 20;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        await NotificationService.instance.scheduleDaily(
          id: NotificationService.idKhatmah,
          title: 'یادآور برنامه ختم قرآن',
          body: 'زمان مطالعه و تلاوت صفحات تعیین‌شده امروز فرا رسیده است.',
          hour: h,
          minute: m,
          channelId: NotificationService.channelKhatmah,
        );
      } else {
        await NotificationService.instance.cancelNotification(NotificationService.idKhatmah);
      }

      // 3. Friday Surah Kahf
      if (newSettings.fridayKahfReminderEnabled) {
        final parts = newSettings.fridayKahfTime.split(':');
        final h = int.tryParse(parts[0]) ?? 9;
        final m = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
        await NotificationService.instance.scheduleWeekly(
          id: NotificationService.idFridayKahf,
          title: 'سنت روز جمعه: سوره مبارکه کهف',
          body: 'تلاوت سوره مبارکه کهف در روز جمعه دارای پاداش و نورانیت فراوان است.',
          dayOfWeek: DateTime.friday,
          hour: h,
          minute: m,
          channelId: NotificationService.channelKhatmah,
        );
      } else {
        await NotificationService.instance.cancelNotification(NotificationService.idFridayKahf);
      }
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
  }

  Future<void> _pickTime(String currentVal, Function(String) onSelected) async {
    final parts = currentVal.split(':');
    final initialHour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 8 : 8;
    final initialMinute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initialHour, minute: initialMinute),
    );

    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minStr = picked.minute.toString().padLeft(2, '0');
      onSelected('$hourStr:$minStr');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final todayAyah = DailyAyahCurator.getTodayAyah();
    final surahsAsync = ref.watch(surahListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'یادآورها و آیه روز' : 'Reminders & Daily Ayah'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Ayah of the Day Highlight Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      Theme.of(context).cardColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_rounded, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isPersian ? 'آیه روز' : 'Ayah of the Day',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            todayAyah.theme,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      todayAyah.arabicText,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.getArabicQuranTextStyle(
                        fontSize: 18,
                        fontFamily: 'Amiri',
                        color: Theme.of(context).colorScheme.primary,
                      ).copyWith(fontWeight: FontWeight.bold, height: 1.6),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isPersian ? todayAyah.translationFa : todayAyah.translationEn,
                      textAlign: isPersian ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${isPersian ? "سوره" : "Surah"} ${isPersian ? todayAyah.surahNameFa : todayAyah.surahNameEn} [${todayAyah.surahNumber}:${todayAyah.verseNumber}]',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.menu_book_rounded, size: 16),
                          label: Text(isPersian ? 'مشاهده در قرآن' : 'Read in Surah'),
                          onPressed: () {
                            surahsAsync.whenData((surahs) {
                              final target = surahs.firstWhere(
                                (s) => s.number == todayAyah.surahNumber,
                                orElse: () => surahs.first,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => VerseDetailView(surah: target),
                                ),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Devotional Reminders Settings List
            Text(
              isPersian ? 'یادآورهای روزانه و هفتگی' : 'Daily & Weekly Reminders',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Column(
                children: [
                  _ReminderTile(
                    icon: Icons.wb_twilight_rounded,
                    iconColor: Colors.amber.shade700,
                    title: isPersian ? 'یادآور آیه روز' : 'Daily Ayah Reminder',
                    subtitle: isPersian ? 'ارسال آیه نورانی هر روز صبح' : 'Daily inspirational verse notification',
                    timeVal: _settings.dailyAyahTime,
                    isEnabled: _settings.dailyAyahEnabled,
                    isPersian: isPersian,
                    onToggle: (val) =>
                        _updateSettings(_settings.copyWith(dailyAyahEnabled: val)),
                    onPickTime: () => _pickTime(
                      _settings.dailyAyahTime,
                      (t) => _updateSettings(_settings.copyWith(dailyAyahTime: t)),
                    ),
                  ),
                  const Divider(height: 1),
                  _ReminderTile(
                    icon: Icons.auto_stories_rounded,
                    iconColor: Colors.teal.shade600,
                    title: isPersian ? 'یادآور برنامه ختم قرآن' : 'Khatmah Reading Target',
                    subtitle: isPersian ? 'یادآوری مطالعه صفحات روزانه ختم' : 'Daily reminder to complete page target',
                    timeVal: _settings.khatmahTime,
                    isEnabled: _settings.khatmahReminderEnabled,
                    isPersian: isPersian,
                    onToggle: (val) =>
                        _updateSettings(_settings.copyWith(khatmahReminderEnabled: val)),
                    onPickTime: () => _pickTime(
                      _settings.khatmahTime,
                      (t) => _updateSettings(_settings.copyWith(khatmahTime: t)),
                    ),
                  ),
                  const Divider(height: 1),
                  _ReminderTile(
                    icon: Icons.mosque_rounded,
                    iconColor: Colors.indigo.shade600,
                    title: isPersian ? 'یادآور سوره مبارکه کهف در جمعه' : 'Friday Surah Al-Kahf',
                    subtitle: isPersian ? 'سنت مؤکد تلاوت سوره کهف در روز جمعه' : 'Sunnah recitation reminder on Fridays',
                    timeVal: _settings.fridayKahfTime,
                    isEnabled: _settings.fridayKahfReminderEnabled,
                    isPersian: isPersian,
                    onToggle: (val) =>
                        _updateSettings(_settings.copyWith(fridayKahfReminderEnabled: val)),
                    onPickTime: () => _pickTime(
                      _settings.fridayKahfTime,
                      (t) => _updateSettings(_settings.copyWith(fridayKahfTime: t)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String timeVal;
  final bool isEnabled;
  final bool isPersian;
  final ValueChanged<bool> onToggle;
  final VoidCallback onPickTime;

  const _ReminderTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.timeVal,
    required this.isEnabled,
    required this.isPersian,
    required this.onToggle,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final displayTime = isPersian ? PersianDigitConverter.toPersian(timeVal) : timeVal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: isEnabled ? onPickTime : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isEnabled
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                displayTime,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isEnabled ? Theme.of(context).colorScheme.primary : Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
