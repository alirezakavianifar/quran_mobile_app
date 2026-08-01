using System.Runtime.CompilerServices;
using System.Text;
using System.Text.Json;
using Microsoft.Extensions.Configuration;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.Infrastructure.AI;

public class LLMProviderAdapter : ILLMProvider
{
    private readonly IConfiguration _configuration;
    private readonly HttpClient _httpClient;

    public LLMProviderAdapter(IConfiguration configuration, HttpClient httpClient)
    {
        _configuration = configuration;
        _httpClient = httpClient;
    }

    public async Task<string> GenerateGroundedAnswerAsync(
        string prompt,
        SystemInstruction instruction,
        CancellationToken ct = default)
    {
        var provider = _configuration["AI:Provider"] ?? "Mock";

        if (provider.Equals("Gemini", StringComparison.OrdinalIgnoreCase))
        {
            var apiKey = _configuration["AI:Gemini:ApiKey"];
            if (!string.IsNullOrWhiteSpace(apiKey))
            {
                var geminiAnswer = await CallGeminiApiAsync(prompt, instruction, apiKey, ct);
                if (!string.IsNullOrWhiteSpace(geminiAnswer)) return geminiAnswer;
            }
        }
        else if (provider.Equals("Grok", StringComparison.OrdinalIgnoreCase))
        {
            var apiKey = _configuration["AI:Grok:ApiKey"];
            if (!string.IsNullOrWhiteSpace(apiKey))
            {
                var grokAnswer = await CallGrokApiAsync(prompt, instruction, apiKey, ct);
                if (!string.IsNullOrWhiteSpace(grokAnswer)) return grokAnswer;
            }
        }

        // Mock Fallback
        var isPersian = instruction.CultureCode.StartsWith("fa", StringComparison.OrdinalIgnoreCase);
        return isPersian
            ? $"[پاسخ مستند بر اساس تفسیر نمونه و المیزان]: {prompt.Split('\n').LastOrDefault()}"
            : $"[Grounded Answer based on Ibn Kathir Commentary]: {prompt.Split('\n').LastOrDefault()}";
    }

    public async IAsyncEnumerable<string> StreamResponseAsync(
        string prompt,
        SystemInstruction instruction,
        [EnumeratorCancellation] CancellationToken ct = default)
    {
        var fullAnswer = await GenerateGroundedAnswerAsync(prompt, instruction, ct);
        var tokens = fullAnswer.Split(' ');

        foreach (var token in tokens)
        {
            if (ct.IsCancellationRequested) yield break;
            yield return token + " ";
            await Task.Delay(30, ct);
        }
    }

    private async Task<string?> CallGeminiApiAsync(
        string prompt,
        SystemInstruction instruction,
        string apiKey,
        CancellationToken ct)
    {
        try
        {
            var url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={apiKey}";
            var requestBody = new
            {
                system_instruction = new
                {
                    parts = new[] { new { text = instruction.Instructions } }
                },
                contents = new[]
                {
                    new
                    {
                        parts = new[] { new { text = prompt } }
                    }
                }
            };

            var jsonJson = JsonSerializer.Serialize(requestBody);
            using var content = new StringContent(jsonJson, Encoding.UTF8, "application/json");
            var response = await _httpClient.PostAsync(url, content, ct);

            if (response.IsSuccessStatusCode)
            {
                var responseJson = await response.Content.ReadAsStringAsync(ct);
                using var doc = JsonDocument.Parse(responseJson);
                var text = doc.RootElement
                    .GetProperty("candidates")[0]
                    .GetProperty("content")
                    .GetProperty("parts")[0]
                    .GetProperty("text")
                    .GetString();

                return text;
            }
        }
        catch
        {
            // Graceful fallback to mock response if offline or key error
        }

        return null;
    }

    private async Task<string?> CallGrokApiAsync(
        string prompt,
        SystemInstruction instruction,
        string apiKey,
        CancellationToken ct)
    {
        try
        {
            var baseUrl = _configuration["AI:Grok:BaseUrl"] ?? "https://api.x.ai/v1";
            var url = $"{baseUrl.TrimEnd('/')}/chat/completions";

            using var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Headers.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", apiKey);

            var requestBody = new
            {
                model = _configuration["AI:Grok:Model"] ?? "grok-beta",
                messages = new[]
                {
                    new { role = "system", content = instruction.Instructions },
                    new { role = "user", content = prompt }
                }
            };

            request.Content = new StringContent(JsonSerializer.Serialize(requestBody), Encoding.UTF8, "application/json");
            var response = await _httpClient.SendAsync(request, ct);

            if (response.IsSuccessStatusCode)
            {
                var responseJson = await response.Content.ReadAsStringAsync(ct);
                using var doc = JsonDocument.Parse(responseJson);
                var text = doc.RootElement
                    .GetProperty("choices")[0]
                    .GetProperty("message")
                    .GetProperty("content")
                    .GetString();

                return text;
            }
        }
        catch
        {
            // Graceful fallback to mock response if API call fails
        }

        return null;
    }
}
