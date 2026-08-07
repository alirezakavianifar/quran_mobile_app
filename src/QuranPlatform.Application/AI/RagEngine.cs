using System.Runtime.CompilerServices;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.AI;

public class RagEngine : IRagEngine
{
    private readonly IEmbeddingService _embeddingService;
    private readonly IVectorSearchService _vectorSearchService;
    private readonly IQuranRepository _quranRepository;
    private readonly ITafsirRepository _tafsirRepository;
    private readonly ILLMProvider _llmProvider;

    public RagEngine(
        IEmbeddingService embeddingService,
        IVectorSearchService vectorSearchService,
        IQuranRepository quranRepository,
        ITafsirRepository tafsirRepository,
        ILLMProvider llmProvider)
    {
        _embeddingService = embeddingService;
        _vectorSearchService = vectorSearchService;
        _quranRepository = quranRepository;
        _tafsirRepository = tafsirRepository;
        _llmProvider = llmProvider;
    }

    public async Task<GroundedAnswer> AnswerQuestionAsync(
        string question,
        string cultureCode = "fa-IR",
        CancellationToken ct = default)
    {
        var culture = new PreferredCulture(cultureCode);
        var retrievedItems = await HydrateContextAsync(question, culture, ct);

        if (retrievedItems.Count == 0)
        {
            var fallbackMessage = culture.IsPersian
                ? RagPromptBuilder.PersianInsufficientContextMessage
                : RagPromptBuilder.EnglishInsufficientContextMessage;

            return new GroundedAnswer(
                Question: question,
                AnswerText: fallbackMessage,
                Citations: Array.Empty<GroundedCitation>(),
                CultureCode: culture.CultureCode,
                HasSufficientContext: false);
        }

        var systemInstruction = RagPromptBuilder.GetSystemInstruction(cultureCode);
        var formattedPrompt = RagPromptBuilder.BuildPromptWithContext(question, retrievedItems, cultureCode);

        var rawAnswer = await _llmProvider.GenerateGroundedAnswerAsync(formattedPrompt, systemInstruction, ct);

        var citations = retrievedItems.Select(item => new GroundedCitation(
            SurahId: item.Verse.SurahId,
            VerseNumber: item.Verse.VerseNumber,
            SurahName: $"Surah {item.Verse.SurahId}",
            TextSnippet: item.Verse.TextUthmani
        )).ToList();

        return new GroundedAnswer(
            Question: question,
            AnswerText: rawAnswer,
            Citations: citations,
            CultureCode: culture.CultureCode,
            HasSufficientContext: true);
    }

    public async IAsyncEnumerable<string> StreamAnswerAsync(
        string question,
        string cultureCode = "fa-IR",
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        var culture = new PreferredCulture(cultureCode);
        var retrievedItems = await HydrateContextAsync(question, culture, ct);

        if (retrievedItems.Count == 0)
        {
            var fallbackMessage = culture.IsPersian
                ? RagPromptBuilder.PersianInsufficientContextMessage
                : RagPromptBuilder.EnglishInsufficientContextMessage;

            yield return fallbackMessage;
            yield break;
        }

        var systemInstruction = RagPromptBuilder.GetSystemInstruction(cultureCode);
        var formattedPrompt = RagPromptBuilder.BuildPromptWithContext(question, retrievedItems, cultureCode);

        await foreach (var token in _llmProvider.StreamResponseAsync(formattedPrompt, systemInstruction, ct))
        {
            yield return token;
        }
    }

    private async Task<List<(Verse Verse, Translation? Translation, Tafsir? Tafsir)>> HydrateContextAsync(
        string question,
        PreferredCulture culture,
        CancellationToken ct)
    {
        // 1. Check if question directly targets a specific Surah number or ordinal
        var detectedSurah = SurahQueryDetector.DetectSurahNumber(question);
        List<AyahKey> candidateKeys;

        if (detectedSurah.HasValue)
        {
            var surahId = detectedSurah.Value;
            candidateKeys = new List<AyahKey>
            {
                new(surahId, 1),
                new(surahId, 2),
                new(surahId, 3),
                new(surahId, 4),
                new(surahId, 5)
            };
        }
        else
        {
            // Generate embedding vector & retrieve semantically matching AyahKeys
            await _embeddingService.GenerateEmbeddingAsync(question, ct);
            candidateKeys = (await _vectorSearchService.SearchVectorAsync(question, culture, limit: 5, ct)).ToList();
        }

        var hydratedList = new List<(Verse Verse, Translation? Translation, Tafsir? Tafsir)>();

        foreach (var key in candidateKeys)
        {
            var verse = await _quranRepository.GetVerseByKeyAsync(key, ct);
            if (verse == null) continue;

            // Fetch default translation & Tafsir (Nemoneh=1 for fa, Ibn Kathir=2 for en)
            var tafsirEditionId = culture.IsPersian ? 1 : 2;
            var tafsir = await _tafsirRepository.GetTafsirForVerseAsync(key, tafsirEditionId, ct);

            hydratedList.Add((verse, null, tafsir));
        }

        return hydratedList;
    }
}
