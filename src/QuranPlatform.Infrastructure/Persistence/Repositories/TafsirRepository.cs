using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.Persistence.Repositories;

public class TafsirRepository : ITafsirRepository
{
    private readonly QuranDbContext _db;

    public TafsirRepository(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<Tafsir?> GetTafsirForVerseAsync(AyahKey key, int tafsirEditionId, CancellationToken ct = default)
    {
        return await _db.Tafsirs
            .AsNoTracking()
            .Include(t => t.Verse)
            .FirstOrDefaultAsync(t => t.TafsirEditionId == tafsirEditionId 
                                   && t.Verse != null 
                                   && t.Verse.SurahId == key.SurahId 
                                   && t.Verse.VerseNumber == key.VerseNumber, ct);
    }

    public async Task<IEnumerable<Tafsir>> GetTafsirsByEditionAsync(int tafsirEditionId, CancellationToken ct = default)
    {
        return await _db.Tafsirs
            .AsNoTracking()
            .Where(t => t.TafsirEditionId == tafsirEditionId)
            .ToListAsync(ct);
    }
}
