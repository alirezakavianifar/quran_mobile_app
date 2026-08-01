namespace QuranPlatform.Domain.Repositories;

public record SystemStatsDto(
    int TotalSurahs,
    int TotalVerses,
    int TotalTranslations,
    int TotalTafsirEntries,
    int TotalUsers,
    string DatabaseStatus,
    string SearchEngineStatus,
    string AiEngineStatus
);

public record SearchQueryStatDto(
    string QueryText,
    int Count,
    double AverageResponseTimeMs
);

public record SearchAnalyticsDto(
    int TotalSearchQueries,
    int PersianQueriesCount,
    int EnglishQueriesCount,
    IEnumerable<SearchQueryStatDto> TopQueries
);

public record AiConversationLogDto(
    Guid Id,
    Guid UserId,
    string UserQuestion,
    string AiResponse,
    string LanguageCode,
    DateTime CreatedAt
);

public interface IAdminRepository
{
    Task<SystemStatsDto> GetSystemStatsAsync(CancellationToken ct = default);
    Task<SearchAnalyticsDto> GetSearchAnalyticsAsync(CancellationToken ct = default);
    Task<IEnumerable<AiConversationLogDto>> GetAiConversationLogsAsync(int limit = 50, CancellationToken ct = default);
}
