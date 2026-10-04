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
      expect(NotificationService.idAudioPlayback, 3001);

      expect(NotificationService.channelAudioPlayback, 'quran_audio_playback_channel_v2');
      expect(NotificationService.obsoleteChannelAudioPlayback, 'quran_audio_playback_channel');
      expect(NotificationService.actionPortName, 'quran_audio_playback_action_port');

      expect(NotificationService.actionPrev, 'ACTION_PREV');
      expect(NotificationService.actionPlayPause, 'ACTION_PLAY_PAUSE');
      expect(NotificationService.actionNext, 'ACTION_NEXT');
      expect(NotificationService.actionExit, 'ACTION_EXIT');
    });

    test('NotificationService singleton instance is not null', () {
      final s1 = NotificationService.instance;
      final s2 = NotificationService();
      expect(s1, equals(s2));
    });

    test('registerAudioActionCallbacks and handleActionId trigger corresponding callbacks', () {
      final service = NotificationService.instance;

      bool prevCalled = false;
      bool playPauseCalled = false;
      bool nextCalled = false;
      bool exitCalled = false;

      service.registerAudioActionCallbacks(
        onPreviousVerse: () => prevCalled = true,
        onPlayPause: () => playPauseCalled = true,
        onNextVerse: () => nextCalled = true,
        onExit: () => exitCalled = true,
      );

      service.handleActionId(NotificationService.actionPrev);
      expect(prevCalled, isTrue);

      service.handleActionId(NotificationService.actionPlayPause);
      expect(playPauseCalled, isTrue);

      service.handleActionId(NotificationService.actionNext);
      expect(nextCalled, isTrue);

      service.handleActionId(NotificationService.actionExit);
      expect(exitCalled, isTrue);
    });
  });
}
