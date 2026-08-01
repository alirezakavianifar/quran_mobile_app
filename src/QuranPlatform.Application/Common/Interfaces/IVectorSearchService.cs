using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.Common.Interfaces;

public interface IVectorSearchService
{
    Task<IEnumerable<AyahKey>> SearchVectorAsync(
        string queryText,
        PreferredCulture culture,
        int limit = 50,
        CancellationToken ct = default);
}
