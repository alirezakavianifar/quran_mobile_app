using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Infrastructure.AI;
using Xunit;

namespace QuranPlatform.IntegrationTests;

public class AdminAiProviderTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient _client;

    public AdminAiProviderTests(WebApplicationFactory<Program> factory)
    {
        _client = factory.CreateClient();
    }

    [Fact]
    public async Task GetAiProvider_ShouldReturnCurrentStatus()
    {
        var response = await _client.GetAsync("/api/v1/admin/ai-provider");
        response.EnsureSuccessStatusCode();

        var json = await response.Content.ReadAsStringAsync();
        using var doc = JsonDocument.Parse(json);

        var activeProvider = doc.RootElement.GetProperty("activeProvider").GetString();
        Assert.NotNull(activeProvider);
    }

    [Fact]
    public async Task PostAiProvider_ShouldSwitchActiveProvider()
    {
        // 1. Switch to Mock
        var postResponse = await _client.PostAsJsonAsync("/api/v1/admin/ai-provider", new { provider = "Mock" });
        postResponse.EnsureSuccessStatusCode();

        // 2. Verify GET reflects Mock
        var getResponse = await _client.GetAsync("/api/v1/admin/ai-provider");
        var json = await getResponse.Content.ReadAsStringAsync();
        using var doc = JsonDocument.Parse(json);

        Assert.Equal("Mock", doc.RootElement.GetProperty("activeProvider").GetString());

        // 3. Switch back to Gemini
        await _client.PostAsJsonAsync("/api/v1/admin/ai-provider", new { provider = "Gemini" });
    }
}
