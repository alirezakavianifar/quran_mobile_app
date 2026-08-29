import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('fa', 'IR'));
  }

  bool get isPersian => locale.languageCode == 'fa';
  TextDirection get textDirection => isPersian ? TextDirection.rtl : TextDirection.ltr;

  static final Map<String, Map<String, String>> _localizedValues = {
    'fa': {
      'appTitle': 'پلتفرم جامع علوم و معارف قرآن',
      'surahs': 'سوره‌ها',
      'search': 'جستجو',
      'aiAssistant': 'دستیار هوشمند قرآن',
      'bookmarks': 'نشان‌شده‌ها',
      'settings': 'تنظیمات',
      'searchPlaceholder': 'جستجو در آیات، ترجمه‌ها و تفاسیر...',
      'askAiPlaceholder': 'سوال خود را درباره مفاهیم قرآن بپرسید...',
      'defaultTranslation': 'ترجمه آیت‌الله مکارم شیرازی',
      'defaultTafsir': 'تفسیر نمونه',
      'makki': 'مکی',
      'madani': 'مدنی',
      'versesCount': 'آیه',
      'relatedVerses': 'آیات مرتبط',
      'sourcesAndCitations': 'منابع و تفاسیر مستند',
      'language': 'زبان برنامه',
      'persian': 'فارسی',
      'english': 'English',
      'noBookmarks': 'هیچ آیه‌ای نشان نشده است.',
      'addBookmark': 'نشان کردن آیه',
      'removeBookmark': 'حذف نشان',
      'tafsir': 'تفسیر آیه',
      'tafsirNoor': 'تفسیر نور (استاد قرائتی)',
      'tafsirNemoneh': 'تفسیر نمونه (آیت‌الله مکارم شیرازی)',
      'tafsirAlmizan': 'تفسیر المیزان (علامه طباطبائی)',
      'tafsirIbnKathir': 'تفسیر ابن کثیر (انگلیسی)',
      'selectTafsir': 'انتخاب تفسیر',
      'copyTafsir': 'کپی متن تفسیر',
      'copiedToClipboard': 'متن تفسیر در حافظه کپی شد',
      'ayahTafsirHeader': 'تفسیر آیه',
      'page': 'صفحه',
      'juz': 'جزء',
      'verseSelectionAction': 'عملیات پیش‌فرض لمس آیه',
      'verseSelectionActionSubtitle': 'عملیاتی که با لمس آیه در متن سوره انجام می‌شود',
      'actionShowTafsir': 'مشاهده تفسیر',
      'actionPlayAudio': 'پخش تلاوت صوتی',
      'actionShowMenu': 'منوی سریع عملیات',
      'defaultTafsirEdition': 'تفسیر پیش‌فرض',
      'defaultTafsirEditionSubtitle': 'تفسیر برگزیده برای مطالعه و باز شدن سریع',
      'quickActions': 'عملیات آیه',
      'listenAyah': 'شنیدن تلاوت',
      'copyAyah': 'کپی متن آیه',
      'shareAyah': 'اشتراک‌گذاری آیه',
      'ayahCopied': 'متن آیه در حافظه کپی شد',
      'keepScreenOn': 'روشن ماندن صفحه هنگام قرائت',
      'keepScreenOnSubtitle': 'جلوگیری از خاموش شدن خودکار صفحه هنگام مطالعه و تلاوت',
      'verseRepeat': 'تکرار آیه',
      'verseRepeatSubtitle': 'تعداد دفعات تکرار هر آیه پیش از رفتن به آیه بعد',
      'repeatOnce': 'یک‌بار (بدون تکرار)',
      'repeatTwice': '۲ بار تکرار',
      'repeatThreeTimes': '۳ بار تکرار (تجوید و تمرین)',
      'repeatFiveTimes': '۵ بار تکرار (حفظ قرآن)',
      'repeatTenTimes': '۱۰ بار تکرار (حفظ فشرده)',
      'repeatInfinite': 'تکرار مداوم (بی‌نهایت)',
    },
    'en': {
      'appTitle': 'Quran Exploration & RAG Platform',
      'surahs': 'Surahs',
      'search': 'Search',
      'aiAssistant': 'AI Assistant',
      'bookmarks': 'Bookmarks',
      'settings': 'Settings',
      'searchPlaceholder': 'Search verses, translations, and tafsir...',
      'askAiPlaceholder': 'Ask any conceptual question about the Quran...',
      'defaultTranslation': 'Dr. Mustafa Khattab (The Clear Quran)',
      'defaultTafsir': 'Tafsir Ibn Kathir',
      'makki': 'Makki',
      'madani': 'Madani',
      'versesCount': 'Verses',
      'relatedVerses': 'Related Verses',
      'sourcesAndCitations': 'Grounded Citations',
      'language': 'App Language',
      'persian': 'فارسی',
      'english': 'English',
      'noBookmarks': 'No bookmarked verses.',
      'addBookmark': 'Bookmark Verse',
      'removeBookmark': 'Remove Bookmark',
      'tafsir': 'Ayah Tafsir',
      'tafsirNoor': 'Tafsir Noor (Dr. Qara\'ati)',
      'tafsirNemoneh': 'Tafsir Nemoneh (Makarem Shirazi)',
      'tafsirAlmizan': 'Tafsir Al-Mizan (Allameh Tabataba\'i)',
      'tafsirIbnKathir': 'Tafsir Ibn Kathir (English)',
      'selectTafsir': 'Select Tafsir Edition',
      'copyTafsir': 'Copy Tafsir Text',
      'copiedToClipboard': 'Tafsir text copied to clipboard',
      'ayahTafsirHeader': 'Ayah Tafsir',
      'page': 'Page',
      'juz': 'Juz',
      'verseSelectionAction': 'Default Verse Tap Action',
      'verseSelectionActionSubtitle': 'Action executed when tapping on an ayah card',
      'actionShowTafsir': 'View Tafsir',
      'actionPlayAudio': 'Play Recitation',
      'actionShowMenu': 'Quick Actions Menu',
      'defaultTafsirEdition': 'Default Tafsir Edition',
      'defaultTafsirEditionSubtitle': 'Preferred commentary edition for Quran study',
      'quickActions': 'Ayah Actions',
      'listenAyah': 'Listen Recitation',
      'copyAyah': 'Copy Ayah',
      'shareAyah': 'Share Ayah',
      'ayahCopied': 'Ayah text copied to clipboard',
      'keepScreenOn': 'Keep Screen On While Reading',
      'keepScreenOnSubtitle': 'Prevent screen from sleeping during Quran study and recitation',
      'verseRepeat': 'Verse Repeat',
      'verseRepeatSubtitle': 'Number of times to repeat each verse before advancing',
      'repeatOnce': '1x (Play Once)',
      'repeatTwice': '2x (Repeat Twice)',
      'repeatThreeTimes': '3x (Tajweed Practice)',
      'repeatFiveTimes': '5x (Hifz / Memorization)',
      'repeatTenTimes': '10x (Intensive Memorization)',
      'repeatInfinite': 'Infinite Loop (∞)',
    },
  };

  String translate(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['fa']?[key] ?? key;
  }
}

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('fa', 'IR'));

  void setPersian() {
    state = const Locale('fa', 'IR');
  }

  void setEnglish() {
    state = const Locale('en', 'US');
  }

  void toggleLanguage() {
    if (state.languageCode == 'fa') {
      setEnglish();
    } else {
      setPersian();
    }
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final textDirectionProvider = Provider<TextDirection>((ref) {
  final locale = ref.watch(localeProvider);
  return locale.languageCode == 'fa' ? TextDirection.rtl : TextDirection.ltr;
});
