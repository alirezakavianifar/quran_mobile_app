import 'dart:convert';
import 'package:flutter/material.dart';

class HighlightColorOption {
  final String hex;
  final String labelFa;
  final String labelEn;
  final Color color;

  const HighlightColorOption({
    required this.hex,
    required this.labelFa,
    required this.labelEn,
    required this.color,
  });
}

class AyahHighlightPalette {
  static const List<HighlightColorOption> options = [
    HighlightColorOption(
      hex: '#4CAF50',
      labelFa: 'سبز (تدبر و دعا)',
      labelEn: 'Green (Tadabbur & Dua)',
      color: Color(0xFF4CAF50),
    ),
    HighlightColorOption(
      hex: '#FFC107',
      labelFa: 'طلایی (هدایت و مبانی)',
      labelEn: 'Gold (Guidance & Core)',
      color: Color(0xFFFFC107),
    ),
    HighlightColorOption(
      hex: '#2196F3',
      labelFa: 'آبی (احکام و فقه)',
      labelEn: 'Blue (Rulings & Fiqh)',
      color: Color(0xFF2196F3),
    ),
    HighlightColorOption(
      hex: '#9C27B0',
      labelFa: 'بنفش (قصص و تاریخ)',
      labelEn: 'Purple (Stories & History)',
      color: Color(0xFF9C27B0),
    ),
    HighlightColorOption(
      hex: '#FF9800',
      labelFa: 'نارنجی (تذکر و موعظه)',
      labelEn: 'Orange (Reminders)',
      color: Color(0xFFFF9800),
    ),
  ];

  static Color? getColorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final cleanHex = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}

class AyahNote {
  final int surahId;
  final int verseNumber;
  final String? colorHex;
  final String? noteText;
  final DateTime updatedAt;

  AyahNote({
    required this.surahId,
    required this.verseNumber,
    this.colorHex,
    this.noteText,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  String get key => '${surahId}_$verseNumber';

  bool get hasHighlight => colorHex != null && colorHex!.isNotEmpty;
  bool get hasNote => noteText != null && noteText!.trim().isNotEmpty;
  bool get isEmpty => !hasHighlight && !hasNote;

  AyahNote copyWith({
    int? surahId,
    int? verseNumber,
    String? colorHex,
    bool clearColor = false,
    String? noteText,
    bool clearNote = false,
    DateTime? updatedAt,
  }) {
    return AyahNote(
      surahId: surahId ?? this.surahId,
      verseNumber: verseNumber ?? this.verseNumber,
      colorHex: clearColor ? null : (colorHex ?? this.colorHex),
      noteText: clearNote ? null : (noteText ?? this.noteText),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'surahId': surahId,
      'verseNumber': verseNumber,
      'colorHex': colorHex,
      'noteText': noteText,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AyahNote.fromMap(Map<String, dynamic> map) {
    return AyahNote(
      surahId: (map['surahId'] as num).toInt(),
      verseNumber: (map['verseNumber'] as num).toInt(),
      colorHex: map['colorHex'] as String?,
      noteText: map['noteText'] as String?,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AyahNote.fromJson(String source) =>
      AyahNote.fromMap(json.decode(source) as Map<String, dynamic>);
}
