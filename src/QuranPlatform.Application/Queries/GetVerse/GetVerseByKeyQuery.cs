using FluentValidation;
using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.Queries.GetVerse;

public record VerseDto(
    int Id,
    int SurahId,
    int VerseNumber,
    int PageNumber,
    int JuzNumber,
    string TextUthmani,
    string TextSimple,
    string SelectedTranslationText,
    string SelectedTranslationAuthor
);

public record GetVerseByKeyQuery(string AyahKeyString) : IRequest<VerseDto?>, ICacheableQuery
{
    public string CacheKey => $"verse:{AyahKeyString}";
}

public class GetVerseByKeyQueryValidator : AbstractValidator<GetVerseByKeyQuery>
{
    public GetVerseByKeyQueryValidator()
    {
        RuleFor(x => x.AyahKeyString)
            .NotEmpty()
            .Must(key =>
            {
                try
                {
                    AyahKey.Parse(key);
                    return true;
                }
                catch
                {
                    return false;
                }
            })
            .WithMessage("AyahKey must be in the valid format 'SurahId:VerseNumber' (e.g. 2:255).");
    }
}

public class GetVerseByKeyQueryHandler : IRequestHandler<GetVerseByKeyQuery, VerseDto?>
{
    private readonly IQuranRepository _quranRepository;
    private readonly ICultureContext _cultureContext;

    public GetVerseByKeyQueryHandler(IQuranRepository quranRepository, ICultureContext cultureContext)
    {
        _quranRepository = quranRepository;
        _cultureContext = cultureContext;
    }

    public async Task<VerseDto?> Handle(GetVerseByKeyQuery request, CancellationToken cancellationToken)
    {
        var ayahKey = AyahKey.Parse(request.AyahKeyString);
        var verse = await _quranRepository.GetVerseByKeyAsync(ayahKey, cancellationToken);
        if (verse == null) return null;

        var targetLang = _cultureContext.IsPersian ? "fa" : "en";
        var translation = verse.Translations.FirstOrDefault(t => t.LanguageCode.Equals(targetLang, StringComparison.OrdinalIgnoreCase))
                          ?? verse.Translations.FirstOrDefault();

        return new VerseDto(
            verse.Id,
            verse.SurahId,
            verse.VerseNumber,
            verse.PageNumber,
            verse.JuzNumber,
            verse.TextUthmani,
            verse.TextSimple,
            translation?.TranslationText ?? string.Empty,
            translation?.AuthorName ?? string.Empty
        );
    }
}
