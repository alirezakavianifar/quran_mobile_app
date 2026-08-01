using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Domain.Repositories;

public interface ITafsirRepository
{
    Task<Tafsir?> GetTafsirForVerseAsync(AyahKey key, int tafsirEditionId, CancellationToken ct = default);
    Task<IEnumerable<Tafsir>> GetTafsirsByEditionAsync(int tafsirEditionId, CancellationToken ct = default);
}
