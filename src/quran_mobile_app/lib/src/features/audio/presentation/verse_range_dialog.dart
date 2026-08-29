import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'audio_player_notifier.dart';

class VerseRangeDialog extends ConsumerStatefulWidget {
  final int surahId;
  final int totalVerses;
  final int? currentVerse;

  const VerseRangeDialog({
    super.key,
    required this.surahId,
    required this.totalVerses,
    this.currentVerse,
  });

  @override
  ConsumerState<VerseRangeDialog> createState() => _VerseRangeDialogState();
}

class _VerseRangeDialogState extends ConsumerState<VerseRangeDialog> {
  late int _startVerse;
  late int _endVerse;
  late int _selectedLoopCount;

  @override
  void initState() {
    super.initState();
    final playerState = ref.read(audioPlayerProvider);
    _startVerse = playerState.rangeStartVerse ?? widget.currentVerse ?? 1;
    _endVerse = playerState.rangeEndVerse ??
        ((_startVerse + 4 <= widget.totalVerses) ? _startVerse + 4 : widget.totalVerses);
    _selectedLoopCount = playerState.rangeLoopCount;
  }

  void _applyPreset(int count) {
    setState(() {
      _endVerse = (_startVerse + count - 1).clamp(1, widget.totalVerses);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final playerState = ref.watch(audioPlayerProvider);
    final isRangeActive = playerState.isRangeRepeatActive;

    final loopOptions = [
      {'value': 1, 'label': loc.translate('repeatOnce')},
      {'value': 2, 'label': loc.translate('repeatTwice')},
      {'value': 3, 'label': loc.translate('repeatThreeTimes')},
      {'value': 5, 'label': loc.translate('repeatFiveTimes')},
      {'value': 10, 'label': loc.translate('repeatTenTimes')},
      {'value': -1, 'label': loc.translate('repeatInfinite')},
    ];

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.repeat_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              loc.translate('verseRangeRepeat'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.translate('verseRangeRepeatSubtitle'),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Start Verse and End Verse Selectors
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate('fromVerse'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        value: _startVerse,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: List.generate(widget.totalVerses, (i) => i + 1).map((v) {
                          return DropdownMenuItem<int>(
                            value: v,
                            child: Text(
                              isPersian ? PersianDigitConverter.toPersian('$v') : '$v',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _startVerse = val;
                              if (_endVerse < _startVerse) {
                                _endVerse = _startVerse;
                              }
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate('toVerse'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<int>(
                        value: _endVerse,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: List.generate(
                          widget.totalVerses - _startVerse + 1,
                          (i) => _startVerse + i,
                        ).map((v) {
                          return DropdownMenuItem<int>(
                            value: v,
                            child: Text(
                              isPersian ? PersianDigitConverter.toPersian('$v') : '$v',
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _endVerse = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quick Presets
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                  label: Text(loc.translate('presetNext5'), style: const TextStyle(fontSize: 11)),
                  onPressed: () => _applyPreset(5),
                ),
                ActionChip(
                  label: Text(loc.translate('presetNext10'), style: const TextStyle(fontSize: 11)),
                  onPressed: () => _applyPreset(10),
                ),
                ActionChip(
                  label: Text(loc.translate('wholeSurah'), style: const TextStyle(fontSize: 11)),
                  onPressed: () {
                    setState(() {
                      _startVerse = 1;
                      _endVerse = widget.totalVerses;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loop Count Multiplier
            Text(
              loc.translate('rangeCycles'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: _selectedLoopCount,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: loopOptions.map((opt) {
                return DropdownMenuItem<int>(
                  value: opt['value'] as int,
                  child: Text(opt['label'] as String),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedLoopCount = val;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        if (isRangeActive)
          TextButton.icon(
            onPressed: () {
              ref.read(audioPlayerProvider.notifier).clearVerseRange();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear, color: Colors.red, size: 18),
            label: Text(
              loc.translate('stopRangeLoop'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.translate('cancelDownload')),
        ),
        FilledButton.icon(
          onPressed: () {
            ref.read(audioPlayerProvider.notifier).setVerseRange(
                  surahId: widget.surahId,
                  startVerse: _startVerse,
                  endVerse: _endVerse,
                  totalVerses: widget.totalVerses,
                  loopCount: _selectedLoopCount,
                  startPlaying: true,
                );
            Navigator.pop(context);
          },
          icon: const Icon(Icons.play_arrow_rounded, size: 18),
          label: Text(loc.translate('startRangeLoop')),
        ),
      ],
    );
  }
}
