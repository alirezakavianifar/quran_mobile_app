import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'audio_player_notifier.dart';
import 'reciter_selector_dialog.dart';
import 'sleep_timer_dialog.dart';
import 'verse_range_dialog.dart';

class AudioPlayerBottomBar extends ConsumerWidget {
  const AudioPlayerBottomBar({super.key});

  String _formatDuration(Duration d, {bool isPersian = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    final formatted = '$minutes:$seconds';
    return isPersian ? PersianDigitConverter.toPersian(formatted) : formatted;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    // Do not show if not active and not playing
    if (state.currentSurahId == null || state.currentVerseNumber == null) {
      return const SizedBox.shrink();
    }

    final reciterName = state.currentReciter != null
        ? (isPersian
            ? (state.currentReciter!.namePersian.isNotEmpty
                ? state.currentReciter!.namePersian
                : state.currentReciter!.nameArabic)
            : (state.currentReciter!.nameEnglish.isNotEmpty
                ? state.currentReciter!.nameEnglish
                : state.currentReciter!.nameArabic))
        : '';

    final surahVerseText = isPersian
        ? 'سوره ${PersianDigitConverter.toPersian(state.currentSurahId.toString())} - آیه ${PersianDigitConverter.toPersian(state.currentVerseNumber.toString())}'
        : 'Surah ${state.currentSurahId} - Ayah ${state.currentVerseNumber}';

    final double progressRatio = (state.duration.inMilliseconds > 0)
        ? (state.position.inMilliseconds / state.duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    final isAnyLoopActive = state.isRangeRepeatActive || state.isPageRepeatActive;
    final loopButtonText = state.isPageRepeatActive
        ? (isPersian
            ? 'تکرار ص ${PersianDigitConverter.toPersian("${state.repeatPageNumber}")}'
            : 'Page ${state.repeatPageNumber} Loop')
        : state.isRangeRepeatActive
            ? (isPersian ? 'تکرار بازه‌ای' : 'Range Loop')
            : (isPersian ? 'تکرار (حفظ)' : 'Hifz Loop');
    final loopIcon = state.isPageRepeatActive
        ? Icons.menu_book_rounded
        : Icons.repeat_rounded;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Active Whole-Page Repeat Header (if active)
              if (state.isPageRepeatActive)
                Container(
                  margin: const EdgeInsets.only(bottom: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isPersian
                              ? 'صفحه فعال: صفحه ${PersianDigitConverter.toPersian("${state.repeatPageNumber}")} • دور ${PersianDigitConverter.toPersian("${state.currentPageCycle}")}${state.pageLoopCount > 0 ? " از ${PersianDigitConverter.toPersian('${state.pageLoopCount}')}" : " (بی‌نهایت)"}'
                              : 'Active Page: Page ${state.repeatPageNumber} • Cycle ${state.currentPageCycle}${state.pageLoopCount > 0 ? "/${state.pageLoopCount}" : " (∞)"}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => notifier.clearPageRepeat(),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                )
              // Active Verse-Range Repeat Header (if active)
              else if (state.isRangeRepeatActive)
                Container(
                  margin: const EdgeInsets.only(bottom: 6.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.repeat_rounded,
                        size: 14,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          isPersian
                              ? 'بازه فعال: آیه ${PersianDigitConverter.toPersian("${state.rangeStartVerse}")} تا ${PersianDigitConverter.toPersian("${state.rangeEndVerse}")} • دور ${PersianDigitConverter.toPersian("${state.currentRangeCycle}")}${state.rangeLoopCount > 0 ? " از ${PersianDigitConverter.toPersian('${state.rangeLoopCount}')}" : " (بی‌نهایت)"}'
                              : 'Range: Ayah ${state.rangeStartVerse} - ${state.rangeEndVerse} • Cycle ${state.currentRangeCycle}${state.rangeLoopCount > 0 ? "/${state.rangeLoopCount}" : " (∞)"}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => notifier.clearVerseRange(),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),

              // Row 1: Surah/Ayah Info + Reciter + Primary Playback Controls
              Row(
                children: [
                  // Reciter Avatar / Mic Icon
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ReciterSelectorDialog(),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mic_rounded,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Surah, Ayah & Reciter Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          surahVerseText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            if (reciterName.isNotEmpty) ...[
                              Flexible(
                                child: Text(
                                  reciterName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              '• ${_formatDuration(state.position, isPersian: isPersian)} / ${_formatDuration(state.duration, isPersian: isPersian)}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Play/Pause Button
                  state.isLoading
                      ? const SizedBox(
                          width: 36,
                          height: 36,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          iconSize: 34,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.play_circle_filled_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            if (state.isPlaying) {
                              notifier.pause();
                            } else {
                              notifier.resume();
                            }
                          },
                        ),
                  const SizedBox(width: 4),

                  // Close/Stop Button
                  IconButton(
                    iconSize: 22,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close_rounded),
                    tooltip: isPersian ? 'بستن' : 'Stop',
                    onPressed: () => notifier.stop(),
                  ),
                ],
              ),

              // Row 2: Progress Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                ),
                child: Slider(
                  value: progressRatio,
                  onChanged: (value) {
                    if (state.duration.inMilliseconds > 0) {
                      final newMs = (value * state.duration.inMilliseconds).round();
                      notifier.seek(Duration(milliseconds: newMs));
                    }
                  },
                ),
              ),

              // Row 3: Quick Action Chips Toolbar (Speed, Verse Repeat, Range Repeat, Continuous)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // 1. Playback Speed Selector
                    PopupMenuButton<double>(
                      tooltip: isPersian ? 'سرعت پخش' : 'Playback Speed',
                      initialValue: state.playbackSpeed,
                      onSelected: (double speed) {
                        notifier.setPlaybackSpeed(speed);
                        ref.read(settingsProvider.notifier).updatePlaybackSpeed(speed);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.speed_rounded, size: 13, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              isPersian
                                  ? '${PersianDigitConverter.toPersian((state.playbackSpeed % 1 == 0 ? state.playbackSpeed.toInt() : state.playbackSpeed).toString())}x'
                                  : '${state.playbackSpeed % 1 == 0 ? state.playbackSpeed.toInt() : state.playbackSpeed}x',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => [
                        0.5,
                        0.75,
                        1.0,
                        1.25,
                        1.5,
                        2.0,
                      ].map((speed) {
                        final speedStr = speed % 1 == 0 ? speed.toInt().toString() : speed.toString();
                        final label = isPersian
                            ? '${PersianDigitConverter.toPersian(speedStr)} برابر'
                            : '${speedStr}x';
                        return PopupMenuItem<double>(
                          value: speed,
                          child: Row(
                            children: [
                              if (state.playbackSpeed == speed)
                                Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.primary)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 6),

                    // 2. Verse Repeat Selector
                    PopupMenuButton<int>(
                      tooltip: isPersian ? 'تکرار هر آیه' : 'Verse Repeat',
                      initialValue: state.verseRepeatCount,
                      onSelected: (int count) {
                        notifier.setVerseRepeatCount(count);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: state.verseRepeatCount != 1
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.verseRepeatCount == -1 ? Icons.all_inclusive : Icons.repeat_one_rounded,
                              size: 13,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.verseRepeatCount == -1
                                  ? (isPersian ? 'بی‌نهایت' : '∞')
                                  : (isPersian
                                      ? '${PersianDigitConverter.toPersian(state.verseRepeatCount.toString())} بار'
                                      : '${state.verseRepeatCount}x'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => [
                        1,
                        2,
                        3,
                        5,
                        10,
                        -1,
                      ].map((count) {
                        final label = count == -1
                            ? (isPersian ? 'تکرار بی‌نهایت (∞)' : 'Infinite Loop (∞)')
                            : count == 1
                                ? (isPersian ? 'یک‌بار (بدون تکرار)' : '1x (Play Once)')
                                : (isPersian
                                    ? '${PersianDigitConverter.toPersian(count.toString())} بار تکرار'
                                    : '${count}x Repeat');
                        return PopupMenuItem<int>(
                          value: count,
                          child: Row(
                            children: [
                              if (state.verseRepeatCount == count)
                                Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.primary)
                              else
                                const SizedBox(width: 16),
                              const SizedBox(width: 8),
                              Text(label),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 6),

                    // 3. Verse-Range & Whole-Page Repeat (Hifz) Dialog Button
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => VerseRangeDialog(
                            surahId: state.currentSurahId ?? 1,
                            totalVerses: state.totalVersesInSurah ?? state.currentVerseNumber ?? 7,
                            currentVerse: state.currentVerseNumber,
                            initialPageNumber: state.repeatPageNumber,
                            initialIsPageMode: state.isPageRepeatActive,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: isAnyLoopActive
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              loopIcon,
                              size: 13,
                              color: isAnyLoopActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              loopButtonText,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isAnyLoopActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // 4. Auto-Play Next (Continuous) Toggle
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => notifier.toggleAutoPlayNext(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: state.autoPlayNext
                              ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6)
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              state.autoPlayNext ? Icons.playlist_play_rounded : Icons.pause_circle_outline,
                              size: 14,
                              color: state.autoPlayNext
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isPersian ? 'تلاوت پیوسته' : 'Continuous',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: state.autoPlayNext
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),

                    // 5. Sleep Timer Button & Live Countdown
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => const SleepTimerDialog(),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: state.isSleepTimerActive
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bedtime_rounded,
                              size: 13,
                              color: state.isSleepTimerActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.isSleepTimerActive
                                  ? (state.isEndOfSurahSleepTimer
                                      ? (isPersian ? 'پایان سوره' : 'End of Surah')
                                      : _formatDuration(state.sleepTimerRemaining ?? Duration.zero, isPersian: isPersian))
                                  : (isPersian ? 'تایمر خواب' : 'Sleep Timer'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: state.isSleepTimerActive
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
