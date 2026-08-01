using FluentAssertions;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.ValueObjects;
using Xunit;

namespace QuranPlatform.UnitTests.DomainTests;

public class DomainUnitTests
{
    [Theory]
    [InlineData("2:255", 2, 255)]
    [InlineData("1:1", 1, 1)]
    [InlineData("114:6", 114, 6)]
    public void AyahKey_Parse_ValidString_ReturnsCorrectKey(string input, int expectedSurah, int expectedVerse)
    {
        // Act
        var key = AyahKey.Parse(input);

        // Assert
        key.SurahId.Should().Be(expectedSurah);
        key.VerseNumber.Should().Be(expectedVerse);
        key.ToString().Should().Be(input);
    }

    [Theory]
    [InlineData("invalid")]
    [InlineData("0:1")]
    [InlineData("115:1")]
    [InlineData("2:-1")]
    [InlineData("")]
    public void AyahKey_Parse_InvalidString_ThrowsArgumentException(string input)
    {
        // Act
        var act = () => AyahKey.Parse(input);

        // Assert
        act.Should().Throw<ArgumentException>();
    }

    [Fact]
    public void PreferredCulture_Persian_Default_Properties()
    {
        // Act
        var culture = PreferredCulture.Persian;

        // Assert
        culture.CultureCode.Should().Be("fa-IR");
        culture.IsPersian.Should().BeTrue();
        culture.TextDirection.Should().Be("rtl");
    }

    [Fact]
    public void PreferredCulture_English_Properties()
    {
        // Act
        var culture = PreferredCulture.English;

        // Assert
        culture.CultureCode.Should().Be("en-US");
        culture.IsPersian.Should().BeFalse();
        culture.TextDirection.Should().Be("ltr");
    }

    [Fact]
    public void Verse_Entity_Initialization()
    {
        // Arrange & Act
        var verse = new Verse
        {
            Id = 255,
            SurahId = 2,
            VerseNumber = 255,
            PageNumber = 42,
            JuzNumber = 3,
            TextUthmani = "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ",
            TextSimple = "الله لا إله إلا هو الحي القيوم"
        };

        // Assert
        verse.SurahId.Should().Be(2);
        verse.VerseNumber.Should().Be(255);
        verse.Translations.Should().BeEmpty();
    }
}
