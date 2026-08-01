using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.AI;

public interface ILLMProvider
{
    Task<string> GenerateGroundedAnswerAsync(string prompt, PreferredCulture culture, CancellationToken ct = default);
}

public class LLMProviderAdapter : ILLMProvider
{
    private const string PersianSystemPrompt = 
        "شما یک دستیار هوشمند مطالعه قرآن هستید. پاسخ‌های شما باید صرفاً بر اساس آیات مستخرج و تفاسیر معتبر ارائه شده (مانند تفسیر نمونه و المیزان) باشد.";

    private const string EnglishSystemPrompt = 
        "You are an intelligent Quran study assistant. Your answers must strictly rely on the provided retrieved verses and authentic tafsir extracts (such as Ibn Kathir).";

    public Task<string> GenerateGroundedAnswerAsync(string prompt, PreferredCulture culture, CancellationToken ct = default)
    {
        var systemPrompt = culture.IsPersian ? PersianSystemPrompt : EnglishSystemPrompt;
        // Plug in OpenAI / Gemini / Ollama SDK calls here
        var mockResponse = culture.IsPersian
            ? $"[پاسخ هوشمند با منبع تفسیر نمونه]: {prompt}"
            : $"[Grounded AI Response with Tafsir Citation]: {prompt}";

        return Task.FromResult(mockResponse);
    }
}
