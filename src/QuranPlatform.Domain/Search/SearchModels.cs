using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Domain.Search;

public record SearchQuery(
    string QueryText,
    PreferredCulture Culture,
    int Page = 1,
    int PageSize = 20,
    double LexicalWeight = 0.5,
    double VectorWeight = 0.5
);

public record SearchHit(
    AyahKey Key,
    int SurahId,
    int VerseNumber,
    string SurahName,
    string TextUthmani,
    string TranslationText,
    double Score,
    IReadOnlyList<string> Highlights
);

public record SearchResultPayload(
    IReadOnlyList<SearchHit> Hits,
    int TotalHits,
    int Page,
    int PageSize,
    string QueryText,
    string CultureCode
);

public interface ISearchOrchestrator
{
    Task<SearchResultPayload> SearchAsync(SearchQuery query, CancellationToken ct = default);
}
