# Implementation Plan: Native Android Local Notifications & Scheduled Alarms

This document outlines the architecture, dependencies, native Android configuration, service design, and UI integration for **Native Android Push & Local Notifications**.

---

## 🎯 Current Status Analysis

| Feature | Current Status | Notes |
| :--- | :---: | :--- |
| **Notification Dependency** | ❌ Not Added | `pubspec.yaml` currently lacks `flutter_local_notifications` & `timezone`. |
| **Android Manifest Permissions** | ❌ Missing | Missing `POST_NOTIFICATIONS` (Android 13+), `SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`. |
| **Notification Channels & Service** | ❌ Not Implemented | No background scheduling service wired to Android NotificationManager. |
| **Reminders & Adhan Alarms** | ⚠️ UI Only | Time pickers exist in `RemindersScreen`, but notifications are not scheduled with the OS. |

---

## 🏗 Proposed Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            UI Layer (Screens & Notifiers)                   │
│   (RemindersScreen, DailyAyahCurator, PrayerTimesScreen, KhatmahNotifier)   │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│               NotificationService (lib/src/core/notifications/)              │
│  • Android 13+ Runtime Permission Handler (POST_NOTIFICATIONS)              │
│  • Notification Channel Initializer (Adhan, Daily Ayah, Khatmah)            │
│  • Exact Alarm Scheduler using TimeZone & flutter_local_notifications       │
│  • Payload Tap Handler & Navigation Dispatcher                              │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       │
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                 Native Android System (OS Notification Tray)                │
│  • Android NotificationManager (High/Max Importance, Islamic Icon, Badges)  │
│  • Exact AlarmManager (Survives device sleep via WAKE_LOCK / Doze Mode)     │
│  • BootReceiver (Reschedules on phone reboot via RECEIVE_BOOT_COMPLETED)    │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 📦 Required Dependencies & Native Configuration

### 1. `pubspec.yaml`
```yaml
dependencies:
  flutter_local_notifications: ^17.2.2
  timezone: ^0.9.4
```

### 2. `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Required for Android 13+ (API 33+) push notifications -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<!-- Required for exact scheduled daily reminders and Adhan alarms -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>

<!-- Required to reschedule alarms after device reboot -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>

<application ...>
    <!-- Receiver to restore alarms on reboot -->
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
            <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
            <action android:name="android.intent.action.QUICKBOOT_POWERON" />
            <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
        </intent-filter>
    </receiver>
    <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
</application>
```

---

## 🚀 Step-by-Step Implementation Steps

### Phase 1: Core Notification Infrastructure (`src/core/notifications/`)
1. **`NotificationService` singleton class**:
   - `Future<void> initialize()`: Initializes Android settings, default icon (`@mipmap/ic_launcher`), and timezone database (`tz.initializeTimeZones()`).
   - `Future<bool> requestPermissions()`: Handles runtime permission dialog for Android 13+ and iOS.
2. **Notification Channels Setup**:
   - 🕌 **Channel 1**: `adhan_prayer_channel` — *اذان و اوقات شرعی (Adhan & Prayer Times)*: Max importance, custom sound, vibration.
   - 📖 **Channel 2**: `daily_ayah_channel` — *آیه روز و تدبر در قرآن (Daily Ayah & Tadabbur)*: High importance, heads-up banner.
   - 📿 **Channel 3**: `khatmah_reminder_channel` — *یادآور ختم قرآن و ادعیه (Khatmah & Devotionals)*: Default importance.

### Phase 2: Scheduling Engine
1. **Daily Ayah Reminder**:
   - `scheduleDailyAyah(TimeOfDay time, DailyAyah ayah)`: Calculates next instance of time in user's local timezone with daily repetition (`DateTimeComponents.time`).
   - Title: `آیه روز: سوره [نام سوره]`
   - Body: `[متن آیه یا ترجمه]`
2. **Khatmah Reading Target Reminder**:
   - `scheduleKhatmahReminder(TimeOfDay time, int targetPages)`: Daily prompt alerting remaining pages for today's reading goal.
3. **Friday Surah Al-Kahf Reminder**:
   - `scheduleFridayKahfReminder(TimeOfDay time)`: Weekly repeat (`DateTimeComponents.dayOfWeekAndTime`) on Friday mornings.
4. **Adhan & Prayer Times Alarms**:
   - `schedulePrayerNotifications(Map<String, DateTime> prayerTimes)`: Calculates daily Fajr, Dhuhr, Asr, Maghrib, Isha alarms.

### Phase 3: UI & Preferences Wiring
1. Update `lib/src/features/reminders/presentation/reminders_screen.dart`:
   - Toggle switches and time pickers trigger `NotificationService` immediately upon selection and persist state to `SharedPreferences`.
2. Update `lib/src/features/prayer_times/presentation/prayer_times_screen.dart`:
   - Prayer notification switches trigger `NotificationService.schedulePrayerNotifications()`.
3. Background Tap Navigation:
   - Tapping Daily Ayah notification launches app and navigates straight to `VerseDetailView`.

---

## 🧪 Verification & Automated Testing Strategy

1. **Unit Tests**:
   - `test/notification_service_test.dart`: Test notification payload generation, channel configurations, and time calculations.
   - `test/reminder_persistence_test.dart`: Test that toggling reminders in UI persists exact alarm times to SharedPreferences.
2. **Integration Verification**:
   - Run `flutter test` across all 116+ test cases to guarantee zero regressions.
