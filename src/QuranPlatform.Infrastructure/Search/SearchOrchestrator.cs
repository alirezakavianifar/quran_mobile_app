using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Application.Search;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.Search;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.Search;

public class SearchOrchestrator : ISearchOrchestrator
{
    private readonly ISearchIndexRepository _lexicalSearchRepo;
    private readonly IVectorSearchService _vectorSearchService;
    private readonly IQuranRepository _quranRepository;

    public SearchOrchestrator(
        ISearchIndexRepository lexicalSearchRepo,
        IVectorSearchService vectorSearchService,
        IQuranRepository quranRepository)
    {
        _lexicalSearchRepo = lexicalSearchRepo;
        _vectorSearchService = vectorSearchService;
        _quranRepository = quranRepository;
    }

    public async Task<SearchResultPayload> SearchAsync(SearchQuery query, CancellationToken ct = default)
    {
        var fetchLimit = Math.Max(50, query.Page * query.PageSize * 2);

        // 1. Execute Lexical Search & Vector Search in parallel
        var lexicalTask = _lexicalSearchRepo.SearchLexicalAsync(query.QueryText, query.Culture, fetchLimit, ct);
        var vectorTask = _vectorSearchService.SearchVectorAsync(query.QueryText, query.Culture, fetchLimit, ct);

        await Task.WhenAll(lexicalTask, vectorTask);

        var lexicalResults = await lexicalTask;
        var vectorResults = await vectorTask;

        // 2. Combine results using Reciprocal Rank Fusion (RRF)
        var rankedKeys = ReciprocalRankFusion.Combine(new[] { lexicalResults, vectorResults });

        // 3. Paginate
        var totalHits = rankedKeys.Count;
        var pageKeys = rankedKeys
            .Skip((query.Page - 1) * query.PageSize)
            .Take(query.PageSize)
            .ToList();

        // 4. Hydrate verses with localized translations & Surah metadata from PostgreSQL
        var hits = new List<SearchHit>();
        var langCode = query.Culture.IsPersian ? "fa" : "en";

        foreach (var ranked in pageKeys)
        {
            var verse = await _quranRepository.GetVerseByKeyAsync(ranked.Key, ct);
            if (verse != null)
            {
                var surah = await _quranRepository.GetSurahByIdAsync(verse.SurahId, ct);
                var surahName = query.Culture.IsPersian ? surah?.NamePersian ?? "" : surah?.NameEnglish ?? "";

                var translation = verse.Translations.FirstOrDefault(t => t.LanguageCode.Equals(langCode, StringComparison.OrdinalIgnoreCase))
                                  ?? verse.Translations.FirstOrDefault();

                hits.Add(new SearchHit(
                    ranked.Key,
                    verse.SurahId,
                    verse.VerseNumber,
                    surahName,
                    verse.TextUthmani,
                    translation?.TranslationText ?? string.Empty,
                    ranked.Score,
                    new[] { query.QueryText }
                ));
            }
        }

        return new SearchResultPayload(
            hits,
            totalHits,
            query.Page,
            query.PageSize,
            query.QueryText,
            query.Culture.CultureCode
        );
    }
}
