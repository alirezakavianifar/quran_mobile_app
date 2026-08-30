import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../models/ziyarat_model.dart';

class ZiyaratDetailScreen extends StatefulWidget {
  final ZiyaratItem item;

  const ZiyaratDetailScreen({super.key, required this.item});

  @override
  State<ZiyaratDetailScreen> createState() => _ZiyaratDetailScreenState();
}

class _ZiyaratDetailScreenState extends State<ZiyaratDetailScreen> {
  final Map<int, int> _counts = {};

  void _increment(int index, int target) {
    HapticFeedback.lightImpact();
    setState(() {
      final current = _counts[index] ?? 0;
      if (current < target) {
        _counts[index] = current + 1;
        if (_counts[index] == target) {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  void _reset(int index) {
    setState(() {
      _counts[index] = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? widget.item.titleFa : widget.item.titleEn),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Subtitle & Virtue Card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isPersian ? widget.item.virtueFa : widget.item.virtueEn,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Sections
          ...widget.item.sections.asMap().entries.map((entry) {
            final idx = entry.key;
            final sec = entry.value;
            final current = _counts[idx] ?? 0;
            final isDone = current >= sec.targetRepeat;
            final curStr = isPersian ? PersianDigitConverter.toPersian('$current') : '$current';
            final tarStr = isPersian ? PersianDigitConverter.toPersian('${sec.targetRepeat}') : '${sec.targetRepeat}';

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: sec.isInteractive100x && isDone
                    ? const BorderSide(color: Colors.green, width: 1.5)
                    : BorderSide.none,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      sec.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: AppTheme.getArabicQuranTextStyle(
                        fontSize: 18,
                        fontFamily: 'Amiri',
                        color: Theme.of(context).colorScheme.primary,
                      ).copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isPersian ? sec.translationFa : sec.translationEn,
                      textAlign: isPersian ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (sec.isInteractive100x) ...[
                      const SizedBox(height: 14),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            tooltip: isPersian ? 'شروع مجدد' : 'Reset',
                            onPressed: () => _reset(idx),
                          ),
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: isDone ? Colors.green : null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            icon: Icon(isDone ? Icons.check : Icons.touch_app_rounded, size: 18),
                            label: Text(
                              isDone
                                  ? (isPersian ? 'تکمیل شد (۱۰۰ بار)' : 'Completed (100x)')
                                  : '$curStr / $tarStr',
                            ),
                            onPressed: () => _increment(idx, sec.targetRepeat),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
