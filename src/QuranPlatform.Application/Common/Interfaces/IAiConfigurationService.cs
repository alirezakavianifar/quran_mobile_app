namespace QuranPlatform.Application.Common.Interfaces;

public record AiProviderStatusDto(
    string ActiveProvider,
    IReadOnlyList<string> AvailableProviders,
    bool GeminiKeyConfigured,
    string GeminiModel,
    bool GrokKeyConfigured,
    string GrokModel
);

public interface IAiConfigurationService
{
    string GetActiveProvider();
    bool SetActiveProvider(string provider);
    IReadOnlyList<string> GetAvailableProviders();
    AiProviderStatusDto GetProviderStatus();
}
