import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/utils/persian_digit_converter.dart';
import '../audio/data/quran_page_data.dart';

class QuickPageJumpDialog extends StatefulWidget {
  final int? initialPage;
  final ValueChanged<int> onPageSelected;

  const QuickPageJumpDialog({
    super.key,
    this.initialPage,
    required this.onPageSelected,
  });

  static Future<int?> show(
    BuildContext context, {
    int? initialPage,
    ValueChanged<int>? onPageSelected,
  }) {
    return showDialog<int>(
      context: context,
      builder: (ctx) => QuickPageJumpDialog(
        initialPage: initialPage,
        onPageSelected: onPageSelected ??
            (pageNum) {
              Navigator.pop(ctx, pageNum);
            },
      ),
    );
  }

  @override
  State<QuickPageJumpDialog> createState() => _QuickPageJumpDialogState();
}

class _QuickPageJumpDialogState extends State<QuickPageJumpDialog> {
  late TextEditingController _controller;
  late int _selectedPage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedPage = (widget.initialPage ?? 1).clamp(1, QuranPageData.totalPages);
    _controller = TextEditingController(text: '$_selectedPage');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updatePageFromInput(String raw) {
    if (raw.trim().isEmpty) {
      setState(() {
        _errorMessage = null;
      });
      return;
    }

    final normalized = PersianDigitConverter.toEnglish(raw.trim());
    final parsed = int.tryParse(normalized);

    if (parsed == null || parsed < 1 || parsed > QuranPageData.totalPages) {
      setState(() {
        _errorMessage = AppLocalizations.of(context).translate('pageRangeHint');
      });
    } else {
      setState(() {
        _selectedPage = parsed;
        _errorMessage = null;
      });
    }
  }

  void _setPage(int newPage) {
    final clamped = newPage.clamp(1, QuranPageData.totalPages);
    setState(() {
      _selectedPage = clamped;
      _controller.text = '$clamped';
      _errorMessage = null;
    });
  }

  void _pickRandomPage() {
    final randomPage = Random().nextInt(QuranPageData.totalPages) + 1;
    _setPage(randomPage);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final pageSummary = QuranPageData.getPageSummary(_selectedPage, isPersian: isPersian);

    final pageStr = isPersian
        ? PersianDigitConverter.toPersian('$_selectedPage')
        : '$_selectedPage';

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.find_in_page_rounded, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              loc.translate('quickPageJump'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              loc.translate('enterPageNumber'),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Page Number Input Field with Steppers
            Row(
              children: [
                IconButton.outlined(
                  tooltip: '-10',
                  icon: const Text('-10', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  onPressed: _selectedPage > 10 ? () => _setPage(_selectedPage - 10) : null,
                ),
                const SizedBox(width: 4),
                IconButton.outlined(
                  tooltip: '-1',
                  icon: const Icon(Icons.remove, size: 16),
                  onPressed: _selectedPage > 1 ? () => _setPage(_selectedPage - 1) : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      errorText: _errorMessage,
                      hintText: '456',
                    ),
                    onChanged: _updatePageFromInput,
                    onSubmitted: (_) {
                      if (_errorMessage == null) {
                        widget.onPageSelected(_selectedPage);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: '+1',
                  icon: const Icon(Icons.add, size: 16),
                  onPressed: _selectedPage < QuranPageData.totalPages
                      ? () => _setPage(_selectedPage + 1)
                      : null,
                ),
                const SizedBox(width: 4),
                IconButton.outlined(
                  tooltip: '+10',
                  icon: const Text('+10', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  onPressed: _selectedPage <= QuranPageData.totalPages - 10
                      ? () => _setPage(_selectedPage + 10)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Live Page Preview Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_stories_rounded,
                    size: 24,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${loc.translate("page")} $pageStr',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          pageSummary,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Quick Preset Navigation Chips
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۱' : 'p 1',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(1),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۱۰۰' : 'p 100',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(100),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۲۰۰' : 'p 200',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(200),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۳۰۰' : 'p 300',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(300),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۴۰۰' : 'p 400',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(400),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۵۰۰' : 'p 500',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(500),
                ),
                ActionChip(
                  label: Text(
                    isPersian ? 'ص ۶۰۴' : 'p 604',
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: () => _setPage(604),
                ),
                ActionChip(
                  avatar: const Icon(Icons.casino_outlined, size: 14),
                  label: Text(
                    loc.translate('randomPage'),
                    style: const TextStyle(fontSize: 11),
                  ),
                  onPressed: _pickRandomPage,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.translate('cancelDownload')),
        ),
        FilledButton.icon(
          onPressed: _errorMessage == null
              ? () {
                  widget.onPageSelected(_selectedPage);
                }
              : null,
          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
          label: Text('${loc.translate("goToPage")} $pageStr'),
        ),
      ],
    );
  }
}
