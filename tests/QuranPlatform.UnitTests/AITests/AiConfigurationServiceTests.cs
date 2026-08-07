using FluentAssertions;
using Microsoft.Extensions.Configuration;
using Moq;
using QuranPlatform.Infrastructure.AI;
using Xunit;

namespace QuranPlatform.UnitTests.AITests;

public class AiConfigurationServiceTests
{
    [Fact]
    public void GetActiveProvider_ShouldDefaultToConfigurationValue()
    {
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["AI:Provider"]).Returns("Gemini");

        var service = new AiConfigurationService(configMock.Object);

        service.GetActiveProvider().Should().Be("Gemini");
    }

    [Fact]
    public void SetActiveProvider_WithValidProvider_ShouldUpdateActiveProvider()
    {
        var configMock = new Mock<IConfiguration>();
        var service = new AiConfigurationService(configMock.Object);

        var success = service.SetActiveProvider("Grok");

        success.Should().BeTrue();
        service.GetActiveProvider().Should().Be("Grok");
    }

    [Fact]
    public void SetActiveProvider_WithInvalidProvider_ShouldReturnFalseAndKeepCurrentProvider()
    {
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["AI:Provider"]).Returns("Gemini");
        var service = new AiConfigurationService(configMock.Object);

        var success = service.SetActiveProvider("InvalidProvider");

        success.Should().BeFalse();
        service.GetActiveProvider().Should().Be("Gemini");
    }

    [Fact]
    public void GetProviderStatus_ShouldReturnCorrectDetails()
    {
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["AI:Provider"]).Returns("Gemini");
        configMock.Setup(c => c["AI:Gemini:ApiKey"]).Returns("gemini-secret-key");
        configMock.Setup(c => c["AI:Gemini:Model"]).Returns("gemini-2.5-flash");
        configMock.Setup(c => c["AI:Grok:ApiKey"]).Returns("grok-secret-key");
        configMock.Setup(c => c["AI:Grok:Model"]).Returns("grok-2-1212");

        var service = new AiConfigurationService(configMock.Object);

        var status = service.GetProviderStatus();

        status.ActiveProvider.Should().Be("Gemini");
        status.AvailableProviders.Should().BeEquivalentTo(new[] { "Gemini", "Grok", "Mock" });
        status.GeminiKeyConfigured.Should().BeTrue();
        status.GeminiModel.Should().Be("gemini-2.5-flash");
        status.GrokKeyConfigured.Should().BeTrue();
        status.GrokModel.Should().Be("grok-2-1212");
    }
}
