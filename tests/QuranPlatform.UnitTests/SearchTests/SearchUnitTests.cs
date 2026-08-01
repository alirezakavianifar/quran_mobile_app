using FluentAssertions;
using QuranPlatform.Application.Queries.Search;
using QuranPlatform.Application.Search;
using QuranPlatform.Domain.ValueObjects;
using Xunit;

namespace QuranPlatform.UnitTests.SearchTests;

public class SearchUnitTests
{
    [Fact]
    public void ReciprocalRankFusion_CombinesMultipleRankedLists_CorrectlyRanksDocuments()
    {
        // Arrange: Candidate lists with overlapping AyahKeys
        var keyA = new AyahKey(2, 255); // Surah 2 Verse 255
        var keyB = new AyahKey(1, 1);   // Surah 1 Verse 1
        var keyC = new AyahKey(114, 6); // Surah 114 Verse 6

        var lexicalList = new[] { keyA, keyB }; // Rank 1: A, Rank 2: B
        var vectorList = new[] { keyB, keyC };  // Rank 1: B, Rank 2: C

        // Act: k = 60
        // RRF(A) = 1/(60+1) = 1/61 = 0.016393
        // RRF(B) = 1/(60+2) + 1/(60+1) = 1/62 + 1/61 = 0.016129 + 0.016393 = 0.032522
        // RRF(C) = 1/(60+2) = 1/62 = 0.016129
        var combined = ReciprocalRankFusion.Combine(new[] { lexicalList, vectorList });

        // Assert: B must be #1 because it appeared in both lists
        combined.Should().HaveCount(3);
        combined[0].Key.Should().Be(keyB);
        combined[1].Key.Should().Be(keyA);
        combined[2].Key.Should().Be(keyC);

        combined[0].Score.Should().BeGreaterThan(combined[1].Score);
        combined[1].Score.Should().BeGreaterThan(combined[2].Score);
    }

    [Theory]
    [InlineData("عدالت", 1, 20, true)]
    [InlineData("", 1, 20, false)]
    [InlineData("صبر", 0, 20, false)]
    [InlineData("صبر", 1, 150, false)]
    public void SearchVersesQueryValidator_ValidatesParameters(string query, int page, int pageSize, bool expectedValid)
    {
        // Arrange
        var validator = new SearchVersesQueryValidator();
        var request = new SearchVersesQuery(query, page, pageSize);

        // Act
        var result = validator.Validate(request);

        // Assert
        result.IsValid.Should().Be(expectedValid);
    }
}
