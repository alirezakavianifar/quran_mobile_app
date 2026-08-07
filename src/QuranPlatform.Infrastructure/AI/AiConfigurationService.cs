using Microsoft.Extensions.Configuration;
using QuranPlatform.Application.Common.Interfaces;

namespace QuranPlatform.Infrastructure.AI;

public class AiConfigurationService : IAiConfigurationService
{
    private static readonly string[] SupportedProviders = { "Gemini", "Grok", "Mock" };
    private readonly IConfiguration _configuration;
    private string _activeProvider;
    private readonly object _lock = new();

    public AiConfigurationService(IConfiguration configuration)
    {
        _configuration = configuration;
        var initialProvider = _configuration["AI:Provider"] ?? "Gemini";
        _activeProvider = NormalizeProvider(initialProvider);
    }

    public string GetActiveProvider()
    {
        lock (_lock)
        {
            return _activeProvider;
        }
    }

    public bool SetActiveProvider(string provider)
    {
        if (string.IsNullOrWhiteSpace(provider)) return false;

        var normalized = NormalizeProvider(provider);
        if (!SupportedProviders.Contains(normalized, StringComparer.OrdinalIgnoreCase))
        {
            return false;
        }

        lock (_lock)
        {
            _activeProvider = normalized;
        }

        return true;
    }

    public IReadOnlyList<string> GetAvailableProviders() => SupportedProviders;

    public AiProviderStatusDto GetProviderStatus()
    {
        string active;
        lock (_lock)
        {
            active = _activeProvider;
        }

        var geminiKey = _configuration["AI:Gemini:ApiKey"];
        var geminiModel = _configuration["AI:Gemini:Model"] ?? "gemini-2.5-flash";

        var grokKey = _configuration["AI:Grok:ApiKey"];
        var grokModel = _configuration["AI:Grok:Model"] ?? "grok-2-1212";

        return new AiProviderStatusDto(
            ActiveProvider: active,
            AvailableProviders: SupportedProviders,
            GeminiKeyConfigured: !string.IsNullOrWhiteSpace(geminiKey),
            GeminiModel: geminiModel,
            GrokKeyConfigured: !string.IsNullOrWhiteSpace(grokKey),
            GrokModel: grokModel
        );
    }

    private static string NormalizeProvider(string provider)
    {
        if (provider.Equals("Gemini", StringComparison.OrdinalIgnoreCase)) return "Gemini";
        if (provider.Equals("Grok", StringComparison.OrdinalIgnoreCase) || provider.Equals("Groq", StringComparison.OrdinalIgnoreCase)) return "Grok";
        if (provider.Equals("Mock", StringComparison.OrdinalIgnoreCase)) return "Mock";
        return provider;
    }
}
