using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.Infrastructure.AI;

public class EmbeddingServiceAdapter : IEmbeddingService
{
    public Task<float[]> GenerateEmbeddingAsync(string text, CancellationToken ct = default)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return Task.FromResult(new float[1536]);
        }

        // Generate deterministic pseudo-random float vector based on text hash for testing / mock embedding
        var hash = text.GetHashCode();
        var random = new Random(hash);
        var vector = new float[1536];

        for (int i = 0; i < vector.Length; i++)
        {
            vector[i] = (float)(random.NextDouble() * 2.0 - 1.0);
        }

        return Task.FromResult(vector);
    }
}
