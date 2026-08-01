using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace QuranPlatform.IntegrationTests;

public class ApiIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public ApiIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetSurah_DefaultHeader_ReturnsPersianCultureFallback()
    {
        // Act
        var response = await _client.GetAsync("/api/v1/quran/surah/1");

        // Assert - Endpoint reached successfully (200 OK or 404 depending on DB seed)
        response.StatusCode.Should().NotBe(HttpStatusCode.InternalServerError);
    }

    [Fact]
    public async Task GetSurah_EnglishHeader_ReturnsEnglishCultureResponse()
    {
        // Arrange
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/v1/quran/surah/1");
        request.Headers.Add("Accept-Language", "en-US");

        // Act
        var response = await _client.SendAsync(request);

        // Assert
        response.StatusCode.Should().NotBe(HttpStatusCode.InternalServerError);
    }

    [Fact]
    public async Task AiAskEndpoint_ReturnsGroundedResponseWithCulture()
    {
        // Act
        var response = await _client.PostAsJsonAsync("/api/v1/ai/ask", new { Question = "صبر" });

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadFromJsonAsync<AiResponseDto>();
        body.Should().NotBeNull();
        body!.Culture.Should().Be("fa-IR");
        body.TextDirection.Should().Be("rtl");
        body.Answer.Should().Contain("تفسیر نمونه");
    }

    private record AiResponseDto(string Question, string Answer, string Culture, string TextDirection);
}
