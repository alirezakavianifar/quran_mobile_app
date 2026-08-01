using System.Text;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Entities;

namespace QuranPlatform.Application.AI;

public static class RagPromptBuilder
{
    public const string PersianSystemPrompt =
        "شما یک دستیار هوشمند مطالعه قرآن هستید. پاسخ‌های شما باید صرفاً بر اساس آیات مستخرج و تفاسیر معتبر ارائه شده (مانند تفسیر نمونه و المیزان) باشد. پاسخ‌ها باید به زبان فارسی روان، محترمانه و دقیق همراه با ارجاع دقیق به سوره و آیه (مانند [سوره البقرة ۲:۲۵۵]) و منبع تفسیر باشد. اگر اطلاعات کافی در متن موجود نیست، صریحاً اعلام کنید: 'در منابع موجود اطلاعات کافی برای پاسخ دقیق یافت نشد.'";

    public const string EnglishSystemPrompt =
        "You are an intelligent Quran study assistant. Your answers must strictly rely on the provided retrieved verses and authentic tafsir extracts (such as Ibn Kathir). Provide accurate, respectful answers in English with explicit citations (e.g., [Surah Al-Baqarah 2:255]). If information is insufficient, respond: 'The available sources do not contain enough information to answer this question accurately.'";

    public const string PersianInsufficientContextMessage = "در منابع موجود اطلاعات کافی برای پاسخ دقیق یافت نشد.";
    public const string EnglishInsufficientContextMessage = "The available sources do not contain enough information to answer this question accurately.";

    public static SystemInstruction GetSystemInstruction(string cultureCode)
    {
        var isPersian = cultureCode.StartsWith("fa", StringComparison.OrdinalIgnoreCase);
        return new SystemInstruction(
            isPersian ? PersianSystemPrompt : EnglishSystemPrompt,
            isPersian ? "fa-IR" : "en-US");
    }

    public static string BuildPromptWithContext(
        string question,
        IEnumerable<(Verse Verse, Translation? Translation, Tafsir? Tafsir)> retrievedItems,
        string cultureCode)
    {
        var isPersian = cultureCode.StartsWith("fa", StringComparison.OrdinalIgnoreCase);
        var sb = new StringBuilder();

        sb.AppendLine(isPersian ? "### منابع مستخرج قرآن و تفسیر:" : "### Retrieved Quran & Tafsir Sources:");

        foreach (var item in retrievedItems)
        {
            sb.AppendLine("---");
            sb.AppendLine($"Surah {item.Verse.SurahId}, Ayah {item.Verse.VerseNumber}:");
            sb.AppendLine($"Arabic Text: {item.Verse.TextUthmani}");

            if (item.Translation != null)
            {
                sb.AppendLine($"Translation ({item.Translation.AuthorName}): {item.Translation.TranslationText}");
            }

            if (item.Tafsir != null)
            {
                sb.AppendLine($"Tafsir (Edition #{item.Tafsir.TafsirEditionId}): {item.Tafsir.ContentText}");
            }
        }

        sb.AppendLine("---");
        sb.AppendLine(isPersian
            ? $"سوال کاربر: {question}\nلطفاً بر اساس منابع فوق پاسخ دهید:"
            : $"User Question: {question}\nPlease answer strictly based on the above sources:");

        return sb.ToString();
    }
}
