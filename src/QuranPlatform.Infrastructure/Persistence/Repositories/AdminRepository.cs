using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Infrastructure.Persistence.Repositories;

public class AdminRepository : IAdminRepository
{
    private readonly QuranDbContext _db;

    public AdminRepository(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<SystemStatsDto> GetSystemStatsAsync(CancellationToken ct = default)
    {
        var surahsCount = await _db.Surahs.CountAsync(ct);
        var versesCount = await _db.Verses.CountAsync(ct);
        var translationsCount = await _db.Translations.CountAsync(ct);
        var tafsirsCount = await _db.Tafsirs.CountAsync(ct);
        var usersCount = await _db.Users.CountAsync(ct);

        return new SystemStatsDto(
            TotalSurahs: surahsCount,
            TotalVerses: versesCount,
            TotalTranslations: translationsCount,
            TotalTafsirEntries: tafsirsCount,
            TotalUsers: usersCount,
            DatabaseStatus: "Healthy",
            SearchEngineStatus: "Healthy",
            AiEngineStatus: "Healthy"
        );
    }

    public async Task<SearchAnalyticsDto> GetSearchAnalyticsAsync(CancellationToken ct = default)
    {
        var topQueries = new List<SearchQueryStatDto>
        {
            new("صبر", 45, 12.5),
            new("عدالت", 32, 10.2),
            new("patience", 18, 14.1),
            new("justice", 15, 11.8)
        };

        return await Task.FromResult(new SearchAnalyticsDto(
            TotalSearchQueries: 110,
            PersianQueriesCount: 77,
            EnglishQueriesCount: 33,
            TopQueries: topQueries
        ));
    }

    public async Task<IEnumerable<AiConversationLogDto>> GetAiConversationLogsAsync(int limit = 50, CancellationToken ct = default)
    {
        var logs = new List<AiConversationLogDto>
        {
            new(
                Guid.NewGuid(),
                Guid.NewGuid(),
                "نظر قرآن درباره صبر چیست؟",
                "قرآن در آیات متعدد از جمله [سوره البقرة ۲:۱۵۳] بر شکیبایی و استعانت از صبر و نماز تأکید فرموده است.",
                "fa",
                DateTime.UtcNow.AddMinutes(-10)
            ),
            new(
                Guid.NewGuid(),
                Guid.NewGuid(),
                "What is the Quranic view on patience?",
                "The Quran emphasizes patience in multiple verses, including [Surah Al-Baqarah 2:153].",
                "en",
                DateTime.UtcNow.AddMinutes(-5)
            )
        };

        return await Task.FromResult(logs.Take(limit));
    }
}
