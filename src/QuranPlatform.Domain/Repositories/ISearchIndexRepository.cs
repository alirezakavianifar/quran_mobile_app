using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Domain.Repositories;

public interface ISearchIndexRepository
{
    Task IndexVerseAsync(Verse verse, CancellationToken ct = default);
    Task<IEnumerable<AyahKey>> SearchLexicalAsync(string query, PreferredCulture culture, int limit = 20, CancellationToken ct = default);
}
