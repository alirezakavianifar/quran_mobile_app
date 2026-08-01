using System.Net;
using System.Net.Http.Json;
using FluentAssertions;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace QuranPlatform.IntegrationTests;

public class SearchIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public SearchIntegrationTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task SearchEndpoint_PersianCulture_ReturnsSuccessfulSearchResultPayload()
    {
        // Act
        var response = await _client.GetAsync("/api/v1/search?q=صبر&page=1&pageSize=10");

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadFromJsonAsync<SearchResponseDto>();
        body.Should().NotBeNull();
        body!.QueryText.Should().Be("صبر");
        body.CultureCode.Should().Be("fa-IR");
    }

    [Fact]
    public async Task SearchEndpoint_EnglishCulture_ReturnsSuccessfulSearchResultPayload()
    {
        // Arrange
        var request = new HttpRequestMessage(HttpMethod.Get, "/api/v1/search?q=patience&page=1&pageSize=10");
        request.Headers.Add("Accept-Language", "en-US");

        // Act
        var response = await _client.SendAsync(request);

        // Assert
        response.StatusCode.Should().Be(HttpStatusCode.OK);
        var body = await response.Content.ReadFromJsonAsync<SearchResponseDto>();
        body.Should().NotBeNull();
        body!.QueryText.Should().Be("patience");
        body.CultureCode.Should().Be("en-US");
    }

    private record SearchResponseDto(
        object[] Hits,
        int TotalHits,
        int Page,
        int PageSize,
        string QueryText,
        string CultureCode
    );
}
