import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'audio_player_notifier.dart';

class SleepTimerDialog extends ConsumerWidget {
  const SleepTimerDialog({super.key});

  String _formatDuration(Duration d, bool isPersian) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final formatted = '$minutes:$seconds';
    return isPersian ? PersianDigitConverter.toPersian(formatted) : formatted;
  }

  void _showCustomMinutesDialog(BuildContext context, WidgetRef ref, bool isPersian) {
    final controller = TextEditingController(text: '20');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPersian ? 'تنظیم دقیقه دلخواه' : 'Custom Minutes'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: isPersian ? 'دقیقه' : 'Minutes',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isPersian ? 'انصراف' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final mins = int.tryParse(controller.text.trim());
              if (mins != null && mins > 0) {
                ref.read(audioPlayerProvider.notifier).startSleepTimer(Duration(minutes: mins));
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: Text(isPersian ? 'شروع تایمر' : 'Start Timer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final isTimerActive = state.isSleepTimerActive;

    final presets = [
      (15, isPersian ? '۱۵ دقیقه' : '15 Minutes'),
      (30, isPersian ? '۳۰ دقیقه' : '30 Minutes'),
      (45, isPersian ? '۴۵ دقیقه' : '45 Minutes'),
      (60, isPersian ? '۱ ساعت (۶۰ دقیقه)' : '1 Hour (60 Minutes)'),
    ];

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(Icons.bedtime_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            isPersian ? 'تایمر خواب پخش صوت' : 'Audio Sleep Timer',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isTimerActive) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.isEndOfSurahSleepTimer
                            ? (isPersian ? 'تایمر فعال: تا پایان سوره' : 'Active: Until End of Surah')
                            : (isPersian
                                ? 'تایمر فعال: ${_formatDuration(state.sleepTimerRemaining ?? Duration.zero, true)} باقی‌مانده'
                                : 'Active: ${_formatDuration(state.sleepTimerRemaining ?? Duration.zero, false)} left'),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => notifier.cancelSleepTimer(),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              isPersian
                  ? 'پس از اتمام زمان، صوت به آرامی محو و متوقف می‌شود:'
                  : 'Audio will gently fade out and pause after timeout:',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...presets.map((preset) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    notifier.startSleepTimer(Duration(minutes: preset.$1));
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(preset.$2, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Icon(Icons.chevron_right, size: 18),
                    ],
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  notifier.startEndOfSurahSleepTimer();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPersian ? 'تا پایان سوره فعلی' : 'End of Current Surah',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.stop_circle_outlined, size: 18),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _showCustomMinutesDialog(context, ref, isPersian),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isPersian ? 'دقیقه دلخواه...' : 'Custom Minutes...',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.edit_calendar_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (isTimerActive)
          TextButton(
            onPressed: () {
              notifier.cancelSleepTimer();
              Navigator.pop(context);
            },
            child: Text(
              isPersian ? 'لغو تایمر خواب' : 'Cancel Timer',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(isPersian ? 'بستن' : 'Close'),
        ),
      ],
    );
  }
}
