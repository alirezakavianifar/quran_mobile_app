using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Moq;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Infrastructure.AI;
using Xunit;

namespace QuranPlatform.UnitTests.InfrastructureTests;

public class InfrastructureUnitTests
{
    [Fact]
    public async Task LLMProviderAdapter_PersianCulture_ReturnsPersianPromptResponse()
    {
        // Arrange
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["AI:Provider"]).Returns("Mock");

        var adapter = new LLMProviderAdapter(configMock.Object, new HttpClient());
        var instruction = new SystemInstruction("دستورالعمل سیستم", "fa-IR");

        // Act
        var result = await adapter.GenerateGroundedAnswerAsync("صبر", instruction);

        // Assert
        result.Should().Contain("[پاسخ مستند بر اساس تفسیر نمونه و المیزان]");
    }

    [Fact]
    public async Task LLMProviderAdapter_EnglishCulture_ReturnsEnglishPromptResponse()
    {
        // Arrange
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["AI:Provider"]).Returns("Mock");

        var adapter = new LLMProviderAdapter(configMock.Object, new HttpClient());
        var instruction = new SystemInstruction("System instruction", "en-US");

        // Act
        var result = await adapter.GenerateGroundedAnswerAsync("Patience", instruction);

        // Assert
        result.Should().Contain("[Grounded Answer based on Ibn Kathir Commentary]");
    }
}
