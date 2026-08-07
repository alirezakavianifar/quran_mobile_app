using System.Text.RegularExpressions;

namespace QuranPlatform.Application.AI;

public static class SurahQueryDetector
{
    private static readonly Dictionary<string, int> SurahNamesMap = new(StringComparer.OrdinalIgnoreCase)
    {
        { "فاتحه", 1 }, { "الفاتحه", 1 }, { "الفاتحة", 1 }, { "حمد", 1 }, { "ام الکتاب", 1 },
        { "بقره", 2 }, { "البقره", 2 }, { "البقرة", 2 },
        { "آل عمران", 3 }, { "عمران", 3 },
        { "نساء", 4 }, { "النساء", 4 },
        { "مائده", 5 }, { "المائده", 5 }, { "المائدة", 5 },
        { "انعام", 6 }, { "الانعام", 6 }, { "الأنعام", 6 },
        { "اعراف", 7 }, { "الاعراف", 7 }, { "الأعراف", 7 },
        { "انفال", 8 }, { "الانفال", 8 }, { "الأنفال", 8 },
        { "توبه", 9 }, { "التوبه", 9 }, { "التوبة", 9 }, { "برائت", 9 },
        { "یونس", 10 }, { "يونس", 10 },
        { "هود", 11 },
        { "یوسف", 12 }, { "يوسف", 12 },
        { "رعد", 13 }, { "الرعد", 13 },
        { "ابراهیم", 14 }, { "إبراهيم", 14 },
        { "حجر", 15 }, { "الحجر", 15 },
        { "نحل", 16 }, { "النحل", 16 },
        { "اسراء", 17 }, { "الاسراء", 17 }, { "الإسراء", 17 }, { "بنی اسرائیل", 17 },
        { "کهف", 18 }, { "الکهف", 18 }, { "الكهف", 18 },
        { "مریم", 19 }, { "مريم", 19 },
        { "طه", 20 }, { "taha", 20 }, { "ta-ha", 20 },
        { "انبیاء", 21 }, { "الانبیاء", 21 }, { "الأنبياء", 21 },
        { "حج", 22 }, { "الحج", 22 },
        { "مؤمنون", 23 }, { "المؤمنون", 23 }, { "مومنون", 23 },
        { "نور", 24 }, { "النور", 24 },
        { "فرقان", 25 }, { "الفرقان", 25 },
        { "شعراء", 26 }, { "الشعراء", 26 },
        { "نمل", 27 }, { "النمل", 27 },
        { "قصص", 28 }, { "القصص", 28 },
        { "عنکبوت", 29 }, { "العنکبوت", 29 }, { "العنكبوت", 29 },
        { "روم", 30 }, { "الروم", 30 },
        { "لقمان", 31 },
        { "سجده", 32 }, { "السجده", 32 }, { "السجدة", 32 },
        { "احزاب", 33 }, { "الاحزاب", 33 }, { "الأحزاب", 33 },
        { "سبأ", 34 }, { "سبا", 34 },
        { "فاطر", 35 },
        { "یس", 36 }, { "يس", 36 }, { "یاسین", 36 }, { "yasin", 36 }, { "ya-sin", 36 },
        { "صافات", 37 }, { "الصافات", 37 }, { "saaffat", 37 }, { "as-saaffat", 37 },
        { "ص", 38 },
        { "زمر", 39 }, { "الزمر", 39 },
        { "غافر", 40 }, { "مؤمن", 40 },
        { "فصلت", 41 },
        { "شوری", 42 }, { "الشوری", 42 },
        { "زخرف", 43 }, { "الزخرف", 43 },
        { "دخان", 44 }, { "الدخان", 44 },
        { "جاثیه", 45 }, { "الجاثیه", 45 },
        { "احقاف", 46 }, { "الاحقاف", 46 },
        { "محمد", 47 },
        { "فتح", 48 }, { "الفتح", 48 },
        { "حجرات", 49 }, { "الحجرات", 49 },
        { "ق", 50 },
        { "ذاریات", 51 }, { "الذاریات", 51 },
        { "طور", 52 }, { "الطور", 52 },
        { "نجم", 53 }, { "النجم", 53 },
        { "قمر", 54 }, { "القمر", 54 },
        { "رحمن", 55 }, { "الرحمن", 55 },
        { "واقعه", 56 }, { "الواقعه", 56 }, { "الواقعة", 56 },
        { "حدید", 57 }, { "الحدید", 57 },
        { "مجادله", 58 }, { "المجادله", 58 },
        { "حشر", 59 }, { "الحشر", 59 },
        { "ممتحنه", 60 }, { "الممتحنه", 60 },
        { "صف", 61 }, { "الصف", 61 },
        { "جمعه", 62 }, { "الجمعه", 62 }, { "الجمعة", 62 },
        { "منافقون", 63 }, { "المنافقون", 63 },
        { "تغابن", 64 }, { "التغابن", 64 },
        { "طلاق", 65 }, { "الطلاق", 65 },
        { "تحریم", 66 }, { "التحریم", 66 },
        { "ملک", 67 }, { "الملک", 67 },
        { "قلم", 68 }, { "القلم", 68 },
        { "حاقه", 69 }, { "الحاقه", 69 }, { "الحاقة", 69 },
        { "معارج", 70 }, { "المعارج", 70 },
        { "نوح", 71 },
        { "جن", 72 }, { "الجن", 72 },
        { "مزمل", 73 }, { "المزمل", 73 },
        { "مدثر", 74 }, { "المدثر", 74 },
        { "قیامه", 75 }, { "القیامه", 75 }, { "القيامة", 75 },
        { "انسان", 76 }, { "الانسان", 76 }, { "دهر", 76 },
        { "مرسلات", 77 }, { "المرسلات", 77 },
        { "نبا", 78 }, { "النبا", 78 }, { "النبأ", 78 },
        { "نازعات", 79 }, { "النازعات", 79 },
        { "عبس", 80 },
        { "تکویر", 81 }, { "التکویر", 81 },
        { "انفطار", 82 }, { "الانفطار", 82 },
        { "مطففین", 83 }, { "المطففین", 83 },
        { "انشقاق", 84 }, { "الانشقاق", 84 },
        { "بروج", 85 }, { "البروج", 85 },
        { "طارق", 86 }, { "الطارق", 86 },
        { "اعلی", 87 }, { "الاعلی", 87 }, { "الأعلى", 87 },
        { "غاشیه", 88 }, { "الغاشیه", 88 }, { "الغاشية", 88 },
        { "فجر", 89 }, { "الفجر", 89 },
        { "بلد", 90 }, { "البلد", 90 },
        { "شمس", 91 }, { "الشمس", 91 },
        { "لیل", 92 }, { "اللیل", 92 }, { "الليل", 92 },
        { "ضحی", 93 }, { "الضحی", 93 }, { "الضحى", 93 },
        { "شرح", 94 }, { "انشراح", 94 },
        { "تین", 95 }, { "التین", 95 },
        { "علق", 96 }, { "العلق", 96 },
        { "قدر", 97 }, { "القدر", 97 },
        { "بینه", 98 }, { "البینه", 98 }, { "البينة", 98 },
        { "زلزله", 99 }, { "الزلزله", 99 }, { "الزلزلة", 99 }, { "زتزال", 99 },
        { "عادیات", 100 }, { "العادیات", 100 },
        { "قارعه", 101 }, { "القارعه", 101 }, { "القارعة", 101 },
        { "تکاثر", 102 }, { "التکاثر", 102 },
        { "عصر", 103 }, { "العصر", 103 },
        { "همزه", 104 }, { "الهمزه", 104 },
        { "فیل", 105 }, { "الفیل", 105 },
        { "قریش", 106 }, { "القریش", 106 },
        { "ماعون", 107 }, { "الماعون", 107 },
        { "کوثر", 108 }, { "الکوثر", 108 },
        { "کافرون", 109 }, { "الکافرون", 109 },
        { "نصر", 110 }, { "النصر", 110 },
        { "مسد", 111 }, { "المسد", 111 }, { "لهب", 111 },
        { "اخلاص", 112 }, { "توحید", 112 },
        { "فلق", 113 }, { "الفلق", 113 },
        { "ناس", 114 }, { "الناس", 114 }
    };

    private static readonly Dictionary<string, int> OrdinalsMap = new(StringComparer.OrdinalIgnoreCase)
    {
        { "اول", 1 }, { "نخست", 1 }, { "یکم", 1 },
        { "دوم", 2 },
        { "سوم", 3 },
        { "چهارم", 4 },
        { "پنجم", 5 },
        { "ششم", 6 },
        { "هفتم", 7 },
        { "هشتم", 8 },
        { "نهم", 9 },
        { "دهم", 10 },
        { "یازدهم", 11 },
        { "دوازدهم", 12 },
        { "سیزدهم", 13 },
        { "چهاردهم", 14 },
        { "پانزدهم", 15 },
        { "شانزدهم", 16 },
        { "هفدهم", 17 },
        { "هجدهم", 18 },
        { "نوزدهم", 19 },
        { "بیستم", 20 },
        { "سی ام", 30 }, { "سی‌ام", 30 },
        { "سی و ششم", 36 }, { "سی و ششمین", 36 },
        { "چهلم", 40 },
        { "پنجاهم", 50 },
        { "شصتم", 60 },
        { "هفتادم", 70 },
        { "هشتادم", 80 },
        { "نودم", 90 },
        { "صدم", 100 },
        { "صد و چهاردهم", 114 }
    };

    private static readonly List<KeyValuePair<string, int>> SortedSurahNames = SurahNamesMap
        .OrderByDescending(kvp => kvp.Key.Length)
        .ToList();

    private static readonly List<KeyValuePair<string, int>> SortedOrdinals = OrdinalsMap
        .OrderByDescending(kvp => kvp.Key.Length)
        .ToList();

    public static int? DetectSurahNumber(string query)
    {
        if (string.IsNullOrWhiteSpace(query)) return null;

        var normalized = NormalizeQuery(query);

        // 1. First priority: Direct Surah Name matching (e.g. "صافات", "سوره صافات", "بقره", "طه", "کوثر")
        foreach (var kvp in SortedSurahNames)
        {
            var pattern = $@"(?:\b|^){Regex.Escape(kvp.Key)}(?:\b|$)";
            if (Regex.IsMatch(normalized, pattern, RegexOptions.IgnoreCase))
            {
                return kvp.Value;
            }
        }

        // 2. Second priority: Explicit digit after or before "سوره" / "surah" / "chapter" (e.g. "سوره 20", "سوره ۲۰", "surah 37")
        var digitMatch = Regex.Match(normalized, @"(?:سوره|surah|chapter)\s*([0-9۰-۹]{1,3})", RegexOptions.IgnoreCase);
        if (!digitMatch.Success)
        {
            digitMatch = Regex.Match(normalized, @"([0-9۰-۹]{1,3})\s*(?:سوره|surah|chapter)", RegexOptions.IgnoreCase);
        }

        if (digitMatch.Success && int.TryParse(ToWesternDigits(digitMatch.Groups[1].Value), out var digitSurah))
        {
            if (digitSurah >= 1 && digitSurah <= 114) return digitSurah;
        }

        // 3. Third priority: Ordinal word immediately after "سوره" / "surah" / "chapter" (e.g. "سوره بیستم", "سوره اول", "سوره سی و ششم")
        var ordinalMatch = Regex.Match(normalized, @"(?:سوره|surah|chapter)\s+([آ-ی\s‌]+)", RegexOptions.IgnoreCase);
        if (ordinalMatch.Success)
        {
            var word = ordinalMatch.Groups[1].Value.Trim();
            foreach (var kvp in SortedOrdinals)
            {
                if (word.StartsWith(kvp.Key, StringComparison.OrdinalIgnoreCase) ||
                    word.Equals(kvp.Key, StringComparison.OrdinalIgnoreCase))
                {
                    return kvp.Value;
                }
            }
        }

        // 4. Fallback scan for standalone ordinal phrases if "سوره" was mentioned in query
        if (normalized.Contains("سوره") || normalized.Contains("surah") || normalized.Contains("chapter"))
        {
            foreach (var kvp in SortedOrdinals)
            {
                if (kvp.Key.Length > 2 && Regex.IsMatch(normalized, $@"(?:\b|^){Regex.Escape(kvp.Key)}(?:\b|$)"))
                {
                    return kvp.Value;
                }
            }
        }

        return null;
    }

    private static string NormalizeQuery(string query)
    {
        return query.Trim()
            .Replace("‌", " ") // replace zero-width non-joiner
            .Replace("  ", " ");
    }

    private static string ToWesternDigits(string input)
    {
        return input
            .Replace('۰', '0')
            .Replace('۱', '1')
            .Replace('۲', '2')
            .Replace('۳', '3')
            .Replace('۴', '4')
            .Replace('۵', '5')
            .Replace('۶', '6')
            .Replace('۷', '7')
            .Replace('۸', '8')
            .Replace('۹', '9');
    }
}
