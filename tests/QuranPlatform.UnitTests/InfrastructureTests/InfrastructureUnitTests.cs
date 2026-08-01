using FluentAssertions;
using QuranPlatform.Domain.ValueObjects;
using QuranPlatform.Infrastructure.AI;
using Xunit;

namespace QuranPlatform.UnitTests.InfrastructureTests;

public class InfrastructureUnitTests
{
    [Fact]
    public async Task LLMProviderAdapter_PersianCulture_ReturnsPersianPromptResponse()
    {
        // Arrange
        var adapter = new LLMProviderAdapter();

        // Act
        var result = await adapter.GenerateGroundedAnswerAsync("صبر", PreferredCulture.Persian);

        // Assert
        result.Should().Contain("[پاسخ هوشمند با منبع تفسیر نمونه]");
    }

    [Fact]
    public async Task LLMProviderAdapter_EnglishCulture_ReturnsEnglishPromptResponse()
    {
        // Arrange
        var adapter = new LLMProviderAdapter();

        // Act
        var result = await adapter.GenerateGroundedAnswerAsync("Patience", PreferredCulture.English);

        // Assert
        result.Should().Contain("[Grounded AI Response with Tafsir Citation]");
    }
}
