import 'package:flutter_test/flutter_test.dart';
import 'package:quran_mobile_app/src/core/notifications/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Constants & Channel Tests', () {
    test('Notification channels and IDs are properly configured', () {
      expect(NotificationService.channelAdhan, 'adhan_prayer_channel');
      expect(NotificationService.channelDailyAyah, 'daily_ayah_channel');
      expect(NotificationService.channelKhatmah, 'khatmah_reminder_channel');

      expect(NotificationService.idDailyAyah, 1001);
      expect(NotificationService.idKhatmah, 1002);
      expect(NotificationService.idFridayKahf, 1003);
      expect(NotificationService.idFajr, 2001);
      expect(NotificationService.idDhuhr, 2002);
      expect(NotificationService.idAsr, 2003);
      expect(NotificationService.idMaghrib, 2004);
      expect(NotificationService.idIsha, 2005);
    });

    test('NotificationService singleton instance is not null', () {
      final s1 = NotificationService.instance;
      final s2 = NotificationService();
      expect(s1, equals(s2));
    });
  });
}
