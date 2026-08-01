namespace QuranPlatform.Application.Common.Interfaces;

public record SystemInstruction(string Instructions, string CultureCode);

public interface ILLMProvider
{
    IAsyncEnumerable<string> StreamResponseAsync(
        string prompt,
        SystemInstruction instruction,
        CancellationToken ct = default);

    Task<string> GenerateGroundedAnswerAsync(
        string prompt,
        SystemInstruction instruction,
        CancellationToken ct = default);
}
