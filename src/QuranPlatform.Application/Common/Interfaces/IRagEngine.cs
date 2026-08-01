namespace QuranPlatform.Application.Common.Interfaces;

public record GroundedCitation(int SurahId, int VerseNumber, string SurahName, string TextSnippet);

public record GroundedAnswer(
    string Question,
    string AnswerText,
    IReadOnlyList<GroundedCitation> Citations,
    string CultureCode,
    bool HasSufficientContext);

public interface IRagEngine
{
    Task<GroundedAnswer> AnswerQuestionAsync(
        string question,
        string cultureCode = "fa-IR",
        CancellationToken ct = default);

    IAsyncEnumerable<string> StreamAnswerAsync(
        string question,
        string cultureCode = "fa-IR",
        CancellationToken ct = default);
}
