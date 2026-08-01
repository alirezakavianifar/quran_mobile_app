using System.Globalization;
using FluentAssertions;
using MediatR;
using Moq;
using QuranPlatform.Application.Behaviors;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Application.Queries.GetSurah;
using QuranPlatform.Application.Queries.GetVerse;
using QuranPlatform.Domain.Entities;
using QuranPlatform.Domain.Repositories;
using Xunit;

namespace QuranPlatform.UnitTests.ApplicationTests;

public class ApplicationUnitTests
{
    private readonly Mock<IQuranRepository> _quranRepositoryMock;
    private readonly Mock<ICultureContext> _cultureContextMock;

    public ApplicationUnitTests()
    {
        _quranRepositoryMock = new Mock<IQuranRepository>();
        _cultureContextMock = new Mock<ICultureContext>();
    }

    [Fact]
    public async Task CultureContextBehavior_PersianCulture_SetsCurrentThreadCultureToPersian()
    {
        // Arrange
        _cultureContextMock.Setup(c => c.CurrentCultureName).Returns("fa-IR");
        _cultureContextMock.Setup(c => c.IsPersian).Returns(true);

        var behavior = new CultureContextBehavior<GetSurahByIdQuery, SurahDto?>(_cultureContextMock.Object);
        string capturedCulture = string.Empty;
        RequestHandlerDelegate<SurahDto?> next = _ =>
        {
            capturedCulture = CultureInfo.CurrentCulture.Name;
            return Task.FromResult<SurahDto?>(null);
        };

        // Act
        await behavior.Handle(new GetSurahByIdQuery(1), next, CancellationToken.None);

        // Assert
        capturedCulture.Should().Be("fa-IR");
    }

    [Fact]
    public async Task CultureContextBehavior_EnglishCulture_SetsCurrentThreadCultureToEnglish()
    {
        // Arrange
        _cultureContextMock.Setup(c => c.CurrentCultureName).Returns("en-US");
        _cultureContextMock.Setup(c => c.IsPersian).Returns(false);

        var behavior = new CultureContextBehavior<GetSurahByIdQuery, SurahDto?>(_cultureContextMock.Object);
        string capturedCulture = string.Empty;
        RequestHandlerDelegate<SurahDto?> next = _ =>
        {
            capturedCulture = CultureInfo.CurrentCulture.Name;
            return Task.FromResult<SurahDto?>(null);
        };

        // Act
        await behavior.Handle(new GetSurahByIdQuery(1), next, CancellationToken.None);

        // Assert
        capturedCulture.Should().Be("en-US");
    }

    [Fact]
    public async Task GetSurahByIdQueryHandler_PersianCulture_ReturnsPersianName()
    {
        // Arrange
        var sampleSurah = new Surah
        {
            Id = 1,
            Number = 1,
            NameArabic = "الفاتحة",
            NamePersian = "فاتحه",
            NameEnglish = "Al-Fatihah",
            RevelationType = "Makki",
            VerseCount = 7
        };

        _quranRepositoryMock.Setup(r => r.GetSurahByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(sampleSurah);

        _cultureContextMock.Setup(c => c.IsPersian).Returns(true);

        var handler = new GetSurahByIdQueryHandler(_quranRepositoryMock.Object, _cultureContextMock.Object);

        // Act
        var result = await handler.Handle(new GetSurahByIdQuery(1), CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result!.LocalizedName.Should().Be("فاتحه");
        result.NameArabic.Should().Be("الفاتحة");
    }

    [Fact]
    public async Task GetSurahByIdQueryHandler_EnglishCulture_ReturnsEnglishName()
    {
        // Arrange
        var sampleSurah = new Surah
        {
            Id = 1,
            Number = 1,
            NameArabic = "الفاتحة",
            NamePersian = "فاتحه",
            NameEnglish = "Al-Fatihah",
            RevelationType = "Makki",
            VerseCount = 7
        };

        _quranRepositoryMock.Setup(r => r.GetSurahByIdAsync(1, It.IsAny<CancellationToken>()))
            .ReturnsAsync(sampleSurah);

        _cultureContextMock.Setup(c => c.IsPersian).Returns(false);

        var handler = new GetSurahByIdQueryHandler(_quranRepositoryMock.Object, _cultureContextMock.Object);

        // Act
        var result = await handler.Handle(new GetSurahByIdQuery(1), CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result!.LocalizedName.Should().Be("Al-Fatihah");
    }

    [Theory]
    [InlineData("2:255", true)]
    [InlineData("invalid", false)]
    public void GetVerseByKeyQueryValidator_ValidatesAyahKeyFormat(string inputKey, bool expectedValid)
    {
        // Arrange
        var validator = new GetVerseByKeyQueryValidator();
        var query = new GetVerseByKeyQuery(inputKey);

        // Act
        var result = validator.Validate(query);

        // Assert
        result.IsValid.Should().Be(expectedValid);
    }
}
