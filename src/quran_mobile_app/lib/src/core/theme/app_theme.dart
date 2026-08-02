import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryGreen = Color(0xFF0F5132);
  static const Color secondaryGold = Color(0xFFC59B27);
  static const Color darkBackground = Color(0xFF12181B);
  static const Color lightBackground = Color(0xFFF8F9FA);

  static ThemeData getLightTheme(Locale locale) {
    final isPersian = locale.languageCode == 'fa';
    final baseFont = isPersian
        ? GoogleFonts.vazirmatnTextTheme()
        : GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGold,
        surface: lightBackground,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: isPersian
            ? GoogleFonts.vazirmatn(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            : GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
      ),
      textTheme: baseFont.apply(
        bodyColor: Colors.black87,
        displayColor: primaryGreen,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static ThemeData getDarkTheme(Locale locale) {
    final isPersian = locale.languageCode == 'fa';
    final baseFont = isPersian
        ? GoogleFonts.vazirmatnTextTheme(ThemeData.dark().textTheme)
        : GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryGold,
        surface: darkBackground,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF092C1B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: isPersian
            ? GoogleFonts.vazirmatn(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )
            : GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
      ),
      textTheme: baseFont.apply(
        bodyColor: Colors.white70,
        displayColor: secondaryGold,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E262A),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static const Color sepiaBackground = Color(0xFFF4ECD8);
  static const Color sepiaCard = Color(0xFFEAE0C8);
  static const Color sepiaPrimary = Color(0xFF5B3E2B);

  static ThemeData getSepiaTheme(Locale locale) {
    final isPersian = locale.languageCode == 'fa';
    final baseFont = isPersian
        ? GoogleFonts.vazirmatnTextTheme()
        : GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: sepiaPrimary,
        primary: sepiaPrimary,
        secondary: secondaryGold,
        surface: sepiaBackground,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: sepiaBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: sepiaPrimary,
        foregroundColor: const Color(0xFFF4ECD8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: isPersian
            ? GoogleFonts.vazirmatn(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF4ECD8),
              )
            : GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF4ECD8),
              ),
      ),
      textTheme: baseFont.apply(
        bodyColor: const Color(0xFF3E2723),
        displayColor: sepiaPrimary,
      ),
      cardTheme: CardThemeData(
        color: sepiaCard,
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  static TextStyle getArabicQuranTextStyle({
    double fontSize = 24,
    String fontFamily = 'Amiri',
    Color? color,
  }) {
    final textColor = color ?? primaryGreen;
    try {
      if (fontFamily == 'Scheherazade New') {
        return GoogleFonts.scheherazadeNew(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1.8,
          color: textColor,
        );
      } else if (fontFamily == 'Lateef') {
        return GoogleFonts.lateef(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          height: 1.8,
          color: textColor,
        );
      }
      return GoogleFonts.amiri(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.8,
        color: textColor,
      );
    } catch (_) {
      return TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: const ['Amiri', 'Scheherazade New', 'Traditional Arabic', 'Naskh', 'serif'],
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        height: 1.8,
        color: textColor,
      );
    }
  }
}
