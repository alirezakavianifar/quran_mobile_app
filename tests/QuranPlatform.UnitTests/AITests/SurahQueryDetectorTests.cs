using FluentAssertions;
using QuranPlatform.Application.AI;
using Xunit;

namespace QuranPlatform.UnitTests.AITests;

public class SurahQueryDetectorTests
{
    [Theory]
    [InlineData("سوره بیستم قرآن", 20)]
    [InlineData("سوره 20", 20)]
    [InlineData("سوره ۲۰", 20)]
    [InlineData("سوره اول", 1)]
    [InlineData("سوره ۳۶", 36)]
    [InlineData("سوره سی و ششم", 36)]
    [InlineData("سوره 114", 114)]
    [InlineData("Surah 20", 20)]
    [InlineData("Chapter 20", 20)]
    [InlineData("آیه اول تا پنجم سوره صافات را تفسیر کن", 37)]
    public void DetectSurahNumber_WithSurahQueries_ShouldReturnCorrectSurahId(string query, int expectedSurahId)
    {
        var result = SurahQueryDetector.DetectSurahNumber(query);
        result.Should().Be(expectedSurahId);
    }

    [Theory]
    [InlineData("نظر قرآن درباره صبر چیست؟")]
    [InlineData("چگونه دیگران را ببخشم؟")]
    [InlineData("What is the Quranic view on justice?")]
    public void DetectSurahNumber_WithGeneralQueries_ShouldReturnNull(string query)
    {
        var result = SurahQueryDetector.DetectSurahNumber(query);
        result.Should().BeNull();
    }
}
