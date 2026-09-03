import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../data/quran_page_data.dart';
import 'audio_player_notifier.dart';

enum RepeatMode { verses, page }

class VerseRangeDialog extends ConsumerStatefulWidget {
  final int surahId;
  final int totalVerses;
  final int? currentVerse;
  final int? initialPageNumber;
  final bool initialIsPageMode;

  const VerseRangeDialog({
    super.key,
    required this.surahId,
    required this.totalVerses,
    this.currentVerse,
    this.initialPageNumber,
    this.initialIsPageMode = false,
  });

  @override
  ConsumerState<VerseRangeDialog> createState() => _VerseRangeDialogState();
}

class _VerseRangeDialogState extends ConsumerState<VerseRangeDialog> {
  late RepeatMode _mode;
  late int _startVerse;
  late int _endVerse;
  late int _selectedLoopCount;
  late int _selectedPageNumber;
  late final int _currentPageNumber;

  @override
  void initState() {
    super.initState();
    final playerState = ref.read(audioPlayerProvider);

    _currentPageNumber = widget.initialPageNumber ??
        QuranPageData.getPageForVerse(widget.surahId, widget.currentVerse ?? 1);

    if (widget.initialIsPageMode || playerState.isPageRepeatActive) {
      _mode = RepeatMode.page;
    } else {
      _mode = RepeatMode.verses;
    }

    _startVerse = playerState.rangeStartVerse ?? widget.currentVerse ?? 1;
    _endVerse = playerState.rangeEndVerse ??
        ((_startVerse + 4 <= widget.totalVerses) ? _startVerse + 4 : widget.totalVerses);

    _selectedPageNumber = playerState.repeatPageNumber ?? _currentPageNumber;
    _selectedLoopCount = _mode == RepeatMode.page
        ? playerState.pageLoopCount
        : playerState.rangeLoopCount;
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
    final isPageActive = playerState.isPageRepeatActive;

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
              _mode == RepeatMode.page
                  ? loc.translate('pageRepeat')
                  : loc.translate('verseRangeRepeat'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Switcher: Verse Range vs Entire Page
            SegmentedButton<RepeatMode>(
              segments: [
                ButtonSegment<RepeatMode>(
                  value: RepeatMode.verses,
                  label: Text(
                    loc.translate('repeatModeVerses'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  icon: const Icon(Icons.format_list_numbered_rounded, size: 16),
                ),
                ButtonSegment<RepeatMode>(
                  value: RepeatMode.page,
                  label: Text(
                    loc.translate('repeatModePage'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (newSet) {
                setState(() {
                  _mode = newSet.first;
                });
              },
            ),
            const SizedBox(height: 12),

            Text(
              _mode == RepeatMode.page
                  ? loc.translate('pageRepeatSubtitle')
                  : loc.translate('verseRangeRepeatSubtitle'),
              style: TextStyle(
                fontSize: 11.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),

            if (_mode == RepeatMode.verses) ...[
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

              // Quick Presets for Verses
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
            ] else ...[
              // Page Selector Row & Summary Card
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: loc.translate('previousPage'),
                    onPressed: _selectedPageNumber > 1
                        ? () => setState(() => _selectedPageNumber--)
                        : null,
                    icon: Icon(
                      isPersian ? Icons.chevron_right : Icons.chevron_left,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _selectedPageNumber,
                      decoration: InputDecoration(
                        labelText: loc.translate('selectPage'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: List.generate(QuranPageData.totalPages, (i) => i + 1).map((p) {
                        final pStr = isPersian ? PersianDigitConverter.toPersian('$p') : '$p';
                        return DropdownMenuItem<int>(
                          value: p,
                          child: Text('${loc.translate("page")} $pStr'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedPageNumber = val;
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    tooltip: loc.translate('nextPage'),
                    onPressed: _selectedPageNumber < QuranPageData.totalPages
                        ? () => setState(() => _selectedPageNumber++)
                        : null,
                    icon: Icon(
                      isPersian ? Icons.chevron_left : Icons.chevron_right,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Page Content Preview Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        QuranPageData.getPageSummary(_selectedPageNumber, isPersian: isPersian),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Quick Page Presets
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: Text(
                      '${loc.translate("currentPage")} (${isPersian ? PersianDigitConverter.toPersian("$_currentPageNumber") : "$_currentPageNumber"})',
                      style: const TextStyle(fontSize: 11),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedPageNumber = _currentPageNumber;
                      });
                    },
                  ),
                  if (_selectedPageNumber > 1)
                    ActionChip(
                      label: Text(loc.translate('previousPage'), style: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        setState(() {
                          _selectedPageNumber = (_selectedPageNumber - 1).clamp(1, QuranPageData.totalPages);
                        });
                      },
                    ),
                  if (_selectedPageNumber < QuranPageData.totalPages)
                    ActionChip(
                      label: Text(loc.translate('nextPage'), style: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        setState(() {
                          _selectedPageNumber = (_selectedPageNumber + 1).clamp(1, QuranPageData.totalPages);
                        });
                      },
                    ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Loop Count Multiplier
            Text(
              _mode == RepeatMode.page
                  ? loc.translate('pageCycles')
                  : loc.translate('rangeCycles'),
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
        // Stop Button if Active
        if (_mode == RepeatMode.verses && isRangeActive)
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
        if (_mode == RepeatMode.page && isPageActive)
          TextButton.icon(
            onPressed: () {
              ref.read(audioPlayerProvider.notifier).clearPageRepeat();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.clear, color: Colors.red, size: 18),
            label: Text(
              loc.translate('stopPageLoop'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.translate('cancelDownload')),
        ),
        FilledButton.icon(
          onPressed: () {
            final notifier = ref.read(audioPlayerProvider.notifier);
            if (_mode == RepeatMode.verses) {
              notifier.setVerseRange(
                surahId: widget.surahId,
                startVerse: _startVerse,
                endVerse: _endVerse,
                totalVerses: widget.totalVerses,
                loopCount: _selectedLoopCount,
                startPlaying: true,
              );
            } else {
              notifier.setPageRepeat(
                pageNumber: _selectedPageNumber,
                loopCount: _selectedLoopCount,
                startPlaying: true,
              );
            }
            Navigator.pop(context);
          },
          icon: const Icon(Icons.play_arrow_rounded, size: 18),
          label: Text(
            _mode == RepeatMode.verses
                ? loc.translate('startRangeLoop')
                : loc.translate('startPageLoop'),
          ),
        ),
      ],
    );
  }
}
