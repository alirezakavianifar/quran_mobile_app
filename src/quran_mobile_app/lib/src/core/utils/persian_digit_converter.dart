class PersianDigitConverter {
  static const Map<String, String> _englishToPersian = {
    '0': '۰',
    '1': '۱',
    '2': '۲',
    '3': '۳',
    '4': '۴',
    '5': '۵',
    '6': '۶',
    '7': '۷',
    '8': '۸',
    '9': '۹',
  };

  static const Map<String, String> _persianToEnglish = {
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  /// Converts English digits in a string to Persian digits.
  static String toPersian(String input) {
    if (input.isEmpty) return input;
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_englishToPersian[char] ?? char);
    }
    return buffer.toString();
  }

  /// Converts Persian digits in a string to English digits.
  static String toEnglish(String input) {
    if (input.isEmpty) return input;
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_persianToEnglish[char] ?? char);
    }
    return buffer.toString();
  }

  /// Formats Surah and Verse numbers e.g., (2, 255) -> "۲:۲۵۵" or "2:255" depending on locale
  static String formatAyahKey(int surahId, int verseNumber, {bool isPersian = true}) {
    final key = '$surahId:$verseNumber';
    return isPersian ? toPersian(key) : key;
  }
}
