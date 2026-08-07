using System.Text;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Entities;

namespace QuranPlatform.Application.AI;

public static class RagPromptBuilder
{
    public const string PersianSystemPrompt =
        "شما یک دستیار هوشمند، دانا و دقیق در حوزه علوم و معارف قرآن کریم هستید. از منابع مستخرج قرآن و تفاسیر ارائه شده به عنوان مستندات اصلی و ارجاعات دقیق (مانند [سوره طه ۲۰:۱-۵]) استفاده کنید و با ترکیب این مستندات و دانش جامع قرآنی خود، پاسخی کامل، دقیق، روان و آموزنده به کاربر ارائه دهید.";

    public const string EnglishSystemPrompt =
        "You are an intelligent, knowledgeable, and precise assistant for Quranic studies. Use the provided retrieved Quranic verses and tafsir extracts as primary authoritative references with explicit citations (e.g., [Surah Ta-Ha 20:1-5]), and combine them with your comprehensive Quranic knowledge to deliver complete, insightful, and well-structured answers.";

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
