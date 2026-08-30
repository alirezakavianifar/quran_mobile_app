import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const String channelAdhan = 'adhan_prayer_channel';
  static const String channelDailyAyah = 'daily_ayah_channel';
  static const String channelKhatmah = 'khatmah_reminder_channel';

  // Notification IDs
  static const int idDailyAyah = 1001;
  static const int idKhatmah = 1002;
  static const int idFridayKahf = 1003;
  static const int idFajr = 2001;
  static const int idDhuhr = 2002;
  static const int idAsr = 2003;
  static const int idMaghrib = 2004;
  static const int idIsha = 2005;

  Future<void> initialize({Function(String?)? onSelectNotification}) async {
    if (_isInitialized) return;

    // 1. Initialize Timezone database
    tz.initializeTimeZones();

    // 2. Android Initialization Settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    // 3. Initialize plugin
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (onSelectNotification != null) {
          onSelectNotification(details.payload);
        }
      },
    );

    // 4. Create Android Notification Channels
    if (!kIsWeb && Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelAdhan,
            'اذان و اوقات شرعی (Adhan & Prayer Times)',
            description: 'اعلان هنگام فرارسیدن اوقات شرعی و نمازها',
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelDailyAyah,
            'آیه روز و تدبر در قرآن (Daily Ayah & Quran)',
            description: 'ارسال روزانه یک آیه همراه با ترجمه و مفهوم',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            channelKhatmah,
            'یادآور ختم قرآن و ادعیه (Khatmah & Devotionals)',
            description: 'یادآور مطالعه هدف روزانه و سوره‌های مستحب',
            importance: Importance.defaultImportance,
            playSound: true,
            enableVibration: true,
          ),
        );
      }
    }

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;

    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted = await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
        return granted ?? false;
      }
    } else if (Platform.isIOS) {
      final iosImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }
    return true;
  }

  NotificationDetails _buildDetails({
    required String channelId,
    required String channelName,
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: importance,
        priority: priority,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = channelDailyAyah,
  }) async {
    final details = _buildDetails(
      channelId: channelId,
      channelName: 'قرآن و یادآورها',
    );
    await _notificationsPlugin.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String channelId = channelDailyAyah,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final details = _buildDetails(
      channelId: channelId,
      channelName: 'یادآورهای روزانه',
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek, // 1 = Monday ... 5 = Friday
    required int hour,
    required int minute,
    String channelId = channelKhatmah,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    while (scheduledDate.weekday != dayOfWeek || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final details = _buildDetails(
      channelId: channelId,
      channelName: 'یادآورهای هفتگی',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
