using Microsoft.EntityFrameworkCore;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.Persistence.Repositories;

public class QuranRepository : IQuranRepository
{
    private readonly QuranDbContext _db;

    public QuranRepository(QuranDbContext db)
    {
        _db = db;
    }

    public async Task<Surah?> GetSurahByIdAsync(int surahId, CancellationToken ct = default)
    {
        return await _db.Surahs.AsNoTracking().FirstOrDefaultAsync(s => s.Id == surahId, ct);
    }

    public async Task<IEnumerable<Surah>> GetAllSurahsAsync(CancellationToken ct = default)
    {
        return await _db.Surahs.AsNoTracking().OrderBy(s => s.Number).ToListAsync(ct);
    }

    public async Task<Verse?> GetVerseByKeyAsync(AyahKey key, CancellationToken ct = default)
    {
        return await _db.Verses
            .AsNoTracking()
            .Include(v => v.Translations)
            .FirstOrDefaultAsync(v => v.SurahId == key.SurahId && v.VerseNumber == key.VerseNumber, ct);
    }

    public async Task<IEnumerable<Verse>> GetVersesBySurahIdAsync(int surahId, CancellationToken ct = default)
    {
        return await _db.Verses
            .AsNoTracking()
            .Include(v => v.Translations)
            .Where(v => v.SurahId == surahId)
            .OrderBy(v => v.VerseNumber)
            .ToListAsync(ct);
    }
}
