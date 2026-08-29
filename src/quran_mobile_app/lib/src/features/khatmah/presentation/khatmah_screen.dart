import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/persian_digit_converter.dart';
import 'khatmah_notifier.dart';

class KhatmahScreen extends ConsumerWidget {
  const KhatmahScreen({super.key});

  void _showCreatePlanDialog(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;
    final titleController = TextEditingController(
      text: isPersian ? 'ختم قرآن کریم' : 'Holy Quran Khatmah',
    );
    int selectedDays = 30;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(loc.translate('startKhatmah')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: isPersian ? 'عنوان برنامه' : 'Plan Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isPersian ? 'مدت زمان ختم:' : 'Khatmah Duration:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RadioListTile<int>(
                  title: Text(loc.translate('preset30Days')),
                  subtitle: Text(isPersian ? '~۲۰ صفحه در روز (۱ جزء)' : '~20 pages/day (1 Juz)'),
                  value: 30,
                  groupValue: selectedDays,
                  onChanged: (val) => setDialogState(() => selectedDays = val ?? 30),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<int>(
                  title: Text(loc.translate('preset60Days')),
                  subtitle: Text(isPersian ? '~۱۰ صفحه در روز' : '~10 pages/day'),
                  value: 60,
                  groupValue: selectedDays,
                  onChanged: (val) => setDialogState(() => selectedDays = val ?? 60),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<int>(
                  title: Text(loc.translate('preset90Days')),
                  subtitle: Text(isPersian ? '~۶.۷ صفحه در روز' : '~6.7 pages/day'),
                  value: 90,
                  groupValue: selectedDays,
                  onChanged: (val) => setDialogState(() => selectedDays = val ?? 90),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<int>(
                  title: Text(loc.translate('preset365Days')),
                  subtitle: Text(isPersian ? '~۱.۷ صفحه در روز' : '~1.7 pages/day'),
                  value: 365,
                  groupValue: selectedDays,
                  onChanged: (val) => setDialogState(() => selectedDays = val ?? 365),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isPersian ? 'انصراف' : 'Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim().isNotEmpty
                    ? titleController.text.trim()
                    : (isPersian ? 'ختم قرآن کریم' : 'Holy Quran Khatmah');
                ref.read(khatmahProvider.notifier).createPlan(
                      title: title,
                      targetDays: selectedDays,
                    );
                Navigator.pop(ctx);
              },
              child: Text(isPersian ? 'شروع برنامه' : 'Start Plan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final khatmah = ref.watch(khatmahProvider);
    final notifier = ref.read(khatmahProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('khatmah')),
        actions: [
          if (khatmah != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: loc.translate('deleteKhatmah'),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(loc.translate('deleteKhatmah')),
                    content: Text(
                      isPersian
                          ? 'آیا مطمئن هستید که می‌خواهید برنامه ختم فعلی را حذف کنید؟'
                          : 'Are you sure you want to delete this Khatmah plan?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(isPersian ? 'انصراف' : 'Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(isPersian ? 'حذف' : 'Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await notifier.deleteActivePlan();
                }
              },
            ),
        ],
      ),
      body: khatmah == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      loc.translate('khatmah'),
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.translate('khatmahSubtitle'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => _showCreatePlanDialog(context, ref),
                      icon: const Icon(Icons.add_task_rounded),
                      label: Text(loc.translate('startKhatmah')),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Circular Progress Card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 140,
                                height: 140,
                                child: CircularProgressIndicator(
                                  value: khatmah.progressRatio,
                                  strokeWidth: 12,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.surfaceContainerHighest,
                                  valueColor:
                                      AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isPersian
                                        ? '${PersianDigitConverter.toPersian((khatmah.progressRatio * 100).toStringAsFixed(1))}%'
                                        : '${(khatmah.progressRatio * 100).toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    loc.translate('khatmahProgress'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            khatmah.title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMetric(
                                context,
                                label: isPersian ? 'صفحات خوانده‌شده' : 'Pages Read',
                                value: isPersian
                                    ? PersianDigitConverter.toPersian('${khatmah.completedPages}')
                                    : '${khatmah.completedPages}',
                                icon: Icons.menu_book_rounded,
                              ),
                              _buildMetric(
                                context,
                                label: loc.translate('pagesRemaining'),
                                value: isPersian
                                    ? PersianDigitConverter.toPersian('${khatmah.remainingPages}')
                                    : '${khatmah.remainingPages}',
                                icon: Icons.hourglass_top_rounded,
                              ),
                              _buildMetric(
                                context,
                                label: loc.translate('daysRemaining'),
                                value: isPersian
                                    ? PersianDigitConverter.toPersian('${khatmah.daysRemaining}')
                                    : '${khatmah.daysRemaining}',
                                icon: Icons.calendar_today_rounded,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Today's Goal Card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                loc.translate('todayTarget'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              if (khatmah.streakDays > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                                  ),
                                  child: Text(
                                    '🔥 ${isPersian ? PersianDigitConverter.toPersian('${khatmah.streakDays}') : khatmah.streakDays} ${loc.translate("dayStreak")}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isPersian
                                ? 'برای حفظ زمان‌بندی، پیشنهاد می‌شود امروز حداقل ${PersianDigitConverter.toPersian('${khatmah.dailyTargetPages}')} صفحه مطالعه فرمایید.'
                                : 'To stay on schedule, recommended target is at least ${khatmah.dailyTargetPages} pages today.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => notifier.addPagesCompleted(1),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text(isPersian ? '+۱ صفحه' : '+1 Page'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => notifier.addPagesCompleted(5),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: Text(isPersian ? '+۵ صفحه' : '+5 Pages'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => notifier.addPagesCompleted(20),
                                  icon: const Icon(Icons.check_circle_outline, size: 18),
                                  label: Text(isPersian ? '+۱ جزء' : '+1 Juz'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetric(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
