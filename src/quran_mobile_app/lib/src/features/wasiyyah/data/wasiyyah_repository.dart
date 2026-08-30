import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wasiyyah_model.dart';

class WasiyyahRepository {
  static const String _key = 'user_islamic_wasiyyah';

  Future<IslamicWasiyyah> getWasiyyah() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return IslamicWasiyyah(lastUpdated: DateTime.now());
    }
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return IslamicWasiyyah.fromMap(map);
    } catch (_) {
      return IslamicWasiyyah(lastUpdated: DateTime.now());
    }
  }

  Future<void> saveWasiyyah(IslamicWasiyyah wasiyyah) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(wasiyyah.toMap());
    await prefs.setString(_key, jsonStr);
  }

  String formatAsText(IslamicWasiyyah w, {bool isPersian = true}) {
    if (isPersian) {
      return '''
بسم الله الرحمن الرحیم
وصیت‌نامه شرعی و معنوی

نام و نام‌خانوادگی: ${w.fullName.isNotEmpty ? w.fullName : '—'}
تاریخ تنظیم/بروزرسانی: ${w.lastUpdated.year}/${w.lastUpdated.month}/${w.lastUpdated.day}

۱. اقرار به عقاید حقه و شهادتین:
${w.spiritualTestimony}

۲. واجبات و دیون شرعی:
- نماز قضا: ${w.prayersToMakeUp} روز/ماه/سال
- روزه قضا: ${w.fastsToMakeUp} روز
- وضعیت خمس و زکات: ${w.khumsZakatStatus}

۳. دیون، مطالبات و امانات مالی:
${w.financialDebtsAndCredits.isNotEmpty ? w.financialDebtsAndCredits : 'فاقد بدهی یا مطالبات معوقه.'}

۴. وصیت درباره ثلث مال:
${w.thirdOfEstateInstructions}

۵. سفارش‌های اخلاقی و معنوی به فرزندان و بازماندگان:
${w.ethicalAdviceToHeirs}

وصی منتخب: ${w.executorName.isNotEmpty ? w.executorName : '—'}
و صلی الله علی محمد و آله الطاهرین.
''';
    } else {
      return '''
In the Name of Allah, the Entirely Merciful, the Especially Merciful
Islamic Spiritual & Legal Will (Wasiyyah)

Full Name: ${w.fullName.isNotEmpty ? w.fullName : '—'}
Date: ${w.lastUpdated.toIso8601String().split('T').first}

1. Spiritual Testimony of Faith:
${w.spiritualTestimony}

2. Religious Obligations to Make Up:
- Missed Prayers: ${w.prayersToMakeUp}
- Missed Fasts: ${w.fastsToMakeUp}
- Khums/Zakat Status: ${w.khumsZakatStatus}

3. Financial Debts & Trusts:
${w.financialDebtsAndCredits.isNotEmpty ? w.financialDebtsAndCredits : 'None.'}

4. Bequests Regarding the One-Third Estate (Thuluth):
${w.thirdOfEstateInstructions}

5. Ethical & Spiritual Advice to Heirs:
${w.ethicalAdviceToHeirs}

Executor (Wasi): ${w.executorName.isNotEmpty ? w.executorName : '—'}
''';
    }
  }
}
