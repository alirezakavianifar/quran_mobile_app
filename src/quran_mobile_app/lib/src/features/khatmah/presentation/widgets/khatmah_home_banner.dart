import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/persian_digit_converter.dart';
import '../khatmah_notifier.dart';
import '../khatmah_screen.dart';

class KhatmahHomeBanner extends ConsumerWidget {
  const KhatmahHomeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final khatmah = ref.watch(khatmahProvider);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    if (khatmah == null) {
      return Card(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
          ),
        ),
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KhatmahScreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.translate('khatmah'),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        loc.translate('khatmahSubtitle'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final percent = (khatmah.progressRatio * 100).toInt();
    final percentStr = isPersian ? PersianDigitConverter.toPersian('$percent') : '$percent';
    final completedStr = isPersian
        ? PersianDigitConverter.toPersian('${khatmah.completedPages}')
        : '${khatmah.completedPages}';
    final totalStr = isPersian
        ? PersianDigitConverter.toPersian('${khatmah.totalPages}')
        : '${khatmah.totalPages}';
    final lastPageStr = isPersian
        ? PersianDigitConverter.toPersian('${khatmah.lastReadPage}')
        : '${khatmah.lastReadPage}';
    final dailyTargetStr = isPersian
        ? PersianDigitConverter.toPersian('${khatmah.dailyTargetPages}')
        : '${khatmah.dailyTargetPages}';
    final streakStr = isPersian
        ? PersianDigitConverter.toPersian('${khatmah.streakDays}')
        : '${khatmah.streakDays}';

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const KhatmahScreen()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        khatmah.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  if (khatmah.streakDays > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 4),
                          Text(
                            '$streakStr ${loc.translate("dayStreak")}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: khatmah.progressRatio,
                  minHeight: 8,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completedStr / $totalStr ${loc.translate("page")} ($percentStr%)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${loc.translate("todayTarget")}: $dailyTargetStr ${loc.translate("page")}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const KhatmahScreen()),
                    );
                  },
                  icon: const Icon(Icons.menu_book_rounded, size: 18),
                  label: Text('${loc.translate("continueFromPage")} $lastPageStr'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
