import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../models/sajdah_model.dart';

class SajdahDialog extends StatelessWidget {
  final SajdahInfo sajdahInfo;

  const SajdahDialog({super.key, required this.sajdahInfo});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isPersian = loc.isPersian;

    final isWajib = sajdahInfo.isWajib;
    final badgeTitle = isWajib
        ? (isPersian ? 'آیه دارای سجده واجب ۩' : 'Obligatory Sajdah Ayah ۩')
        : (isPersian ? 'آیه دارای سجده مستحب ۩' : 'Recommended Sajdah Ayah ۩');

    final headerColor = isWajib ? Colors.red.shade700 : Colors.amber.shade800;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: headerColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '۩',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              badgeTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: headerColor,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fiqh note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: headerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: headerColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                isPersian ? sajdahInfo.fiqhNoteFa : sajdahInfo.fiqhNoteEn,
                style: const TextStyle(fontSize: 13, height: 1.4),
              ),
            ),
            const SizedBox(height: 16),

            // Prescribed Sajdah Dua Header
            Text(
              isPersian ? 'ذکر مستحب هنگام سجده تلاوت:' : 'Recommended Sajdah Recitation:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),

            // Dua Text in Arabic
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                sajdahInfo.prescribedDuaArabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: AppTheme.getArabicQuranTextStyle(
                  fontSize: 16,
                  fontFamily: 'Amiri',
                  color: Theme.of(context).colorScheme.primary,
                ).copyWith(fontWeight: FontWeight.bold, height: 1.5),
              ),
            ),
            const SizedBox(height: 8),

            // Translation
            Text(
              isPersian
                  ? sajdahInfo.prescribedDuaTranslationFa
                  : sajdahInfo.prescribedDuaTranslationEn,
              textAlign: isPersian ? TextAlign.right : TextAlign.left,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.copy_outlined, size: 16),
          label: Text(isPersian ? 'کپی ذکر سجده' : 'Copy Sajdah Dua'),
          onPressed: () {
            Clipboard.setData(ClipboardData(
              text:
                  '${sajdahInfo.prescribedDuaArabic}\n\n${isPersian ? sajdahInfo.prescribedDuaTranslationFa : sajdahInfo.prescribedDuaTranslationEn}',
            ));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isPersian ? 'ذکر سجده کپی شد' : 'Sajdah dua copied'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(isPersian ? 'متوجه شدم' : 'Understood'),
        ),
      ],
    );
  }
}
