import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/persian_digit_converter.dart';
import '../models/dhikr_model.dart';
import 'tasbih_provider.dart';

class TasbihScreen extends ConsumerWidget {
  const TasbihScreen({super.key});

  void _showPresetSelector(BuildContext context, WidgetRef ref, bool isPersian) {
    final state = ref.watch(tasbihProvider);
    final notifier = ref.read(tasbihProvider.notifier);
    final presets = DhikrItem.getAllPresets();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPersian ? 'انتخاب اذکار و ادعیه' : 'Select Dhikr / Prayer',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                FilledButton.tonalIcon(
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(isPersian ? 'ذکر دلخواه' : 'Custom'),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showAddCustomDhikrDialog(context, ref, isPersian);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  ...presets.map((item) {
                    final isSelected = state.activeDhikr.id == item.id;
                    return Card(
                      elevation: isSelected ? 3 : 0,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: isSelected ? 1.5 : 0,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          isPersian ? item.titleFa : item.titleEn,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            item.stages.first.arabicText,
                            style: const TextStyle(fontFamily: 'Amiri', fontSize: 14),
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isPersian
                                ? '${PersianDigitConverter.toPersian("${item.stages.fold<int>(0, (sum, s) => sum + s.targetCount)}")} مرتبه'
                                : '${item.stages.fold<int>(0, (sum, s) => sum + s.targetCount)}x',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onTap: () {
                          notifier.selectDhikr(item);
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  }),
                  if (state.customDhikrs.isNotEmpty) ...[
                    const Divider(height: 24),
                    Text(
                      isPersian ? 'اذکار شخصی شما' : 'Your Custom Dhikrs',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ...state.customDhikrs.map((item) {
                      final isSelected = state.activeDhikr.id == item.id;
                      return Card(
                        elevation: isSelected ? 3 : 0,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.4)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.transparent,
                            width: isSelected ? 1.5 : 0,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(isPersian ? item.titleFa : item.titleEn),
                          subtitle: Text(
                            item.stages.first.arabicText,
                            style: const TextStyle(fontFamily: 'Amiri', fontSize: 14),
                          ),
                          onTap: () {
                            notifier.selectDhikr(item);
                            Navigator.pop(ctx);
                          },
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCustomDhikrDialog(BuildContext context, WidgetRef ref, bool isPersian) {
    final titleController = TextEditingController();
    final arabicController = TextEditingController();
    final targetController = TextEditingController(text: '100');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isPersian ? 'افزودن ذکر دلخواه' : 'Add Custom Dhikr'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: isPersian ? 'عنوان ذکر (مثال: ناد علی)' : 'Dhikr Title',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arabicController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  labelText: isPersian ? 'متن عربی ذکر' : 'Arabic Text',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isPersian ? 'تعداد هدف (مثال: ۱۰۰)' : 'Target Count',
                  border: const OutlineInputBorder(),
                ),
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
              final title = titleController.text.trim();
              final arabic = arabicController.text.trim();
              final target = int.tryParse(targetController.text.trim()) ?? 100;
              if (title.isNotEmpty && arabic.isNotEmpty) {
                ref.read(tasbihProvider.notifier).createCustomDhikr(
                      titleFa: title,
                      titleEn: title,
                      arabicText: arabic,
                      targetCount: target,
                    );
                Navigator.pop(ctx);
              }
            },
            child: Text(isPersian ? 'ذخیره' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasbihProvider);
    final notifier = ref.read(tasbihProvider.notifier);
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final dhikr = state.activeDhikr;
    final currentStage = dhikr.currentStage;
    final countStr = isPersian
        ? PersianDigitConverter.toPersian('${dhikr.currentCount}')
        : '${dhikr.currentCount}';
    final targetStr = dhikr.currentStageTarget > 0
        ? (isPersian
            ? PersianDigitConverter.toPersian('${dhikr.currentStageTarget}')
            : '${dhikr.currentStageTarget}')
        : '∞';
    final lifetimeStr = isPersian
        ? PersianDigitConverter.toPersian('${state.lifetimeTotal}')
        : '${state.lifetimeTotal}';

    return Scaffold(
      appBar: AppBar(
        title: Text(isPersian ? 'تسبیح‌شمار هوشمند' : 'Smart Digital Tasbih'),
        actions: [
          IconButton(
            icon: Icon(dhikr.isVibrationEnabled ? Icons.vibration : Icons.smartphone),
            tooltip: isPersian ? 'لرزش' : 'Vibration',
            onPressed: () => notifier.toggleVibration(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: isPersian ? 'صفر کردن شمارنده' : 'Reset Counter',
            onPressed: () => notifier.reset(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Active Dhikr Title & Lifetime Counter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.menu_book_rounded, size: 16),
                    label: Text(
                      isPersian ? dhikr.titleFa : dhikr.titleEn,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    onPressed: () => _showPresetSelector(context, ref, isPersian),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.all_inclusive_rounded,
                          size: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isPersian ? 'مجموع: $lifetimeStr' : 'Total: $lifetimeStr',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Multi-Stage Pills (if dhikr has > 1 stage, like Fatima Zahra)
            if (dhikr.stages.length > 1) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: List.generate(dhikr.stages.length, (idx) {
                    final stage = dhikr.stages[idx];
                    final isCurrent = dhikr.currentStageIndex == idx;
                    final isPassed = dhikr.currentStageIndex > idx;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Theme.of(context).colorScheme.primary
                              : (isPassed
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.surfaceContainerHighest),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            isPersian
                                ? '${stage.arabicText} (${PersianDigitConverter.toPersian("${stage.targetCount}")})'
                                : '${stage.arabicText} (${stage.targetCount})',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                  ? Colors.white
                                  : (isPassed
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],

            const Spacer(),

            // Arabic Text Display Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    currentStage.arabicText,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: AppTheme.getArabicQuranTextStyle(
                      fontSize: 28,
                      fontFamily: 'Amiri',
                      color: Theme.of(context).colorScheme.primary,
                    ).copyWith(fontWeight: FontWeight.bold, height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isPersian ? currentStage.titleFa : currentStage.titleEn,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Big Interactive Circular Tap Counter
            GestureDetector(
              onTap: () => notifier.increment(),
              child: Center(
                child: SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress Ring
                      SizedBox(
                        width: 230,
                        height: 230,
                        child: CircularProgressIndicator(
                          value: dhikr.progressRatio,
                          strokeWidth: 10,
                          backgroundColor:
                              Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
                          color: Theme.of(context).colorScheme.primary,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Inner Tap Circle
                      Container(
                        width: 195,
                        height: 195,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              countStr,
                              style: TextStyle(
                                fontSize: 54,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              '/ $targetStr',
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Bottom Full Tap Helper Note
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                isPersian
                    ? 'برای شمارش، روی دایره تسبیح ضربه بزنید'
                    : 'Tap the circular dial to increment count',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
