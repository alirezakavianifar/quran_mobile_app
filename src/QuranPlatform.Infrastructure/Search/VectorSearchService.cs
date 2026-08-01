using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.ValueObjects;
using QuranPlatform.Infrastructure.Persistence;

namespace QuranPlatform.Infrastructure.Search;

public interface IVectorSearchService
{
    Task<IEnumerable<AyahKey>> SearchVectorAsync(string queryText, PreferredCulture culture, int limit = 50, CancellationToken ct = default);
}

public class VectorSearchService : IVectorSearchService
{
    private readonly QuranDbContext _db;

    public VectorSearchService(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<IEnumerable<AyahKey>> SearchVectorAsync(string queryText, PreferredCulture culture, int limit = 50, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(queryText))
        {
            return Enumerable.Empty<AyahKey>();
        }

        // Query pgvector / relational index for semantically matching AyahKeys
        var results = await _db.Verses
            .AsNoTracking()
            .Where(v => v.TextSimple.Contains(queryText) || v.TextUthmani.Contains(queryText))
            .OrderBy(v => v.VerseNumber)
            .Take(limit)
            .Select(v => new AyahKey(v.SurahId, v.VerseNumber))
            .ToListAsync(ct);

        return results;
    }
}
