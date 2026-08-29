import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'audio_player_notifier.dart';
import 'reciter_selector_dialog.dart';
import 'verse_range_dialog.dart';

class AudioPlayerBottomBar extends ConsumerWidget {
  const AudioPlayerBottomBar({super.key});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlayerProvider);
    final notifier = ref.read(audioPlayerProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    if (state.currentSurahId == null || state.currentVerseNumber == null) {
      return const SizedBox.shrink();
    }

    final reciter = state.currentReciter;
    final reciterName = reciter != null
        ? (isPersian
            ? (reciter.namePersian.isNotEmpty ? reciter.namePersian : reciter.nameArabic)
            : (reciter.nameEnglish.isNotEmpty ? reciter.nameEnglish : reciter.nameArabic))
        : '';

    final surahVerseText = isPersian
        ? 'سوره ${PersianDigitConverter.toPersian(state.currentSurahId.toString())} - آیه ${PersianDigitConverter.toPersian(state.currentVerseNumber.toString())}'
        : 'Surah ${state.currentSurahId} - Ayah ${state.currentVerseNumber}';

    final double progressRatio = (state.duration.inMilliseconds > 0)
        ? (state.position.inMilliseconds / state.duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active Verse-Range Repeat Badge
            if (state.isRangeRepeatActive)
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
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
                            : 'Range Loop: Ayah ${state.rangeStartVerse} - ${state.rangeEndVerse} • Cycle ${state.currentRangeCycle}${state.rangeLoopCount > 0 ? "/${state.rangeLoopCount}" : " (∞)"}',
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

            // Progress Bar Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  // Reciter & Ayah Info
                  IconButton(
                    icon: const Icon(Icons.mic),
                    tooltip: isPersian ? 'تغییر قاری' : 'Change Reciter',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ReciterSelectorDialog(),
                      );
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          isPersian ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          surahVerseText,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        if (reciterName.isNotEmpty)
                          Text(
                            reciterName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Time indicator
                  Text(
                    '${_formatDuration(state.position)} / ${_formatDuration(state.duration)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(width: 6),
                  // Playback Speed Selector Button
                  PopupMenuButton<double>(
                    tooltip: isPersian ? 'سرعت پخش' : 'Playback Speed',
                    initialValue: state.playbackSpeed,
                    onSelected: (double speed) {
                      notifier.setPlaybackSpeed(speed);
                      ref.read(settingsProvider.notifier).updatePlaybackSpeed(speed);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPersian
                            ? '${PersianDigitConverter.toPersian((state.playbackSpeed % 1 == 0 ? state.playbackSpeed.toInt() : state.playbackSpeed).toString())}x'
                            : '${state.playbackSpeed % 1 == 0 ? state.playbackSpeed.toInt() : state.playbackSpeed}x',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
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
                  const SizedBox(width: 4),
                  // Verse Repeat Selector Button
                  PopupMenuButton<int>(
                    tooltip: isPersian ? 'تکرار آیه' : 'Verse Repeat',
                    initialValue: state.verseRepeatCount,
                    onSelected: (int count) {
                      notifier.setVerseRepeatCount(count);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: state.verseRepeatCount != 1
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            state.verseRepeatCount == -1 ? Icons.all_inclusive : Icons.repeat,
                            size: 13,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            state.verseRepeatCount == -1
                                ? '∞'
                                : (isPersian
                                    ? '${PersianDigitConverter.toPersian(state.verseRepeatCount.toString())}x'
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
                  const SizedBox(width: 4),
                  // Verse Range Repeat Dialog Button
                  IconButton(
                    icon: Icon(
                      Icons.repeat_on_rounded,
                      color: state.isRangeRepeatActive
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                      size: 20,
                    ),
                    tooltip: loc.translate('verseRangeRepeat'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => VerseRangeDialog(
                          surahId: state.currentSurahId!,
                          totalVerses: state.totalVersesInSurah ?? state.currentVerseNumber!,
                          currentVerse: state.currentVerseNumber,
                        ),
                      );
                    },
                  ),
                  // Auto play next toggle
                  IconButton(
                    icon: Icon(
                      state.autoPlayNext ? Icons.playlist_play : Icons.stop_circle_outlined,
                      color: state.autoPlayNext
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey,
                    ),
                    tooltip: isPersian ? 'تلاوت پیوسته' : 'Auto Play Next',
                    onPressed: () => notifier.toggleAutoPlayNext(),
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
                          iconSize: 32,
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
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
                  // Stop Button
                  IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: isPersian ? 'بستن پخش‌کننده' : 'Stop',
                    onPressed: () => notifier.stop(),
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


