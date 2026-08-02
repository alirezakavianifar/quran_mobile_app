import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'audio_player_notifier.dart';
import 'reciter_selector_dialog.dart';

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
                  const SizedBox(width: 8),
                  // Auto play next toggle
                  IconButton(
                    icon: Icon(
                      state.autoPlayNext ? Icons.repeat : Icons.repeat_one,
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
