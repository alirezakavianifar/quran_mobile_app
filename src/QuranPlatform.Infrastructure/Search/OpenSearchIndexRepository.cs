using OpenSearch.Client;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Infrastructure.Search;

public class OpenSearchIndexRepository : ISearchIndexRepository
{
    private readonly IOpenSearchClient? _client;

    public OpenSearchIndexRepository(IOpenSearchClient? client = null)
    {
        _client = client;
    }

    public async Task IndexVerseAsync(Verse verse, CancellationToken ct = default)
    {
        if (_client == null) return;
        var indexName = "quran_verses";
        await _client.IndexAsync(verse, idx => idx.Index(indexName), ct);
    }

    public async Task<IEnumerable<AyahKey>> SearchLexicalAsync(string query, PreferredCulture culture, int limit = 20, CancellationToken ct = default)
    {
        if (_client == null || string.IsNullOrWhiteSpace(query))
        {
            return Enumerable.Empty<AyahKey>();
        }

        var indexName = culture.IsPersian ? "quran_verses_fa" : "quran_verses_en";
        var searchResponse = await _client.SearchAsync<Verse>(s => s
            .Index(indexName)
            .From(0)
            .Size(limit)
            .Query(q => q
                .Match(m => m
                    .Field(f => f.TextSimple)
                    .Query(query)
                )
            ), ct);

        if (!searchResponse.IsValid)
        {
            return Enumerable.Empty<AyahKey>();
        }

        return searchResponse.Documents.Select(v => new AyahKey(v.SurahId, v.VerseNumber));
    }
}
