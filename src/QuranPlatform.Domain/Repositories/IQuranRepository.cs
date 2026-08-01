using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Domain.Repositories;

public interface IQuranRepository
{
    Task<Surah?> GetSurahByIdAsync(int surahId, CancellationToken ct = default);
    Task<IEnumerable<Surah>> GetAllSurahsAsync(CancellationToken ct = default);
    Task<Verse?> GetVerseByKeyAsync(AyahKey key, CancellationToken ct = default);
    Task<IEnumerable<Verse>> GetVersesBySurahIdAsync(int surahId, CancellationToken ct = default);
}
