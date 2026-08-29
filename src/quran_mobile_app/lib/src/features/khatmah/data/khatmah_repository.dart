import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/khatmah_model.dart';

class KhatmahRepository {
  static const String _activeKhatmahKey = 'quran_active_khatmah_v1';
  static const String _allKhatmahsKey = 'quran_all_khatmahs_v1';

  Future<KhatmahPlan?> loadActiveKhatmah() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_activeKhatmahKey);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      return KhatmahPlan.fromJson(jsonStr);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveKhatmah(KhatmahPlan plan) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeKhatmahKey, plan.toJson());

    // Also update in all khatmahs list
    final all = await loadAllKhatmahs();
    final index = all.indexWhere((k) => k.id == plan.id);
    if (index >= 0) {
      all[index] = plan;
    } else {
      all.add(plan);
    }
    await prefs.setString(
      _allKhatmahsKey,
      json.encode(all.map((e) => e.toMap()).toList()),
    );
  }

  Future<List<KhatmahPlan>> loadAllKhatmahs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_allKhatmahsKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = json.decode(jsonStr) as List;
      return list.map((e) => KhatmahPlan.fromMap(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> deleteActiveKhatmah() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_activeKhatmahKey);
  }
}

final khatmahRepositoryProvider = Provider<KhatmahRepository>((ref) {
  return KhatmahRepository();
});
