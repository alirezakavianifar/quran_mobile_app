using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.Search;

public record RankedKey(AyahKey Key, double Score);

public static class ReciprocalRankFusion
{
    public const int DefaultKConstant = 60;

    /// <summary>
    /// Combines multiple ranked candidate lists into a single unified ranked list using Reciprocal Rank Fusion (RRF).
    /// Formula: RRF_Score(d) = sum( 1 / (k + rank_m(d)) ) for each list m where d appears.
    /// </summary>
    public static IReadOnlyList<RankedKey> Combine(
        IEnumerable<IEnumerable<AyahKey>> rankedLists,
        int k = DefaultKConstant)
    {
        var scores = new Dictionary<AyahKey, double>();

        foreach (var list in rankedLists)
        {
            var rank = 1;
            foreach (var key in list)
            {
                var score = 1.0 / (k + rank);
                if (scores.TryGetValue(key, out var currentScore))
                {
                    scores[key] = currentScore + score;
                }
                else
                {
                    scores[key] = score;
                }
                rank++;
            }
        }

        return scores
            .OrderByDescending(kvp => kvp.Value)
            .Select(kvp => new RankedKey(kvp.Key, kvp.Value))
            .ToList();
    }
}
