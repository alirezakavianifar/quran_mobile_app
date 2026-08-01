using FluentValidation;
using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Queries.GetSurah;

public record SurahDto(
    int Id,
    int Number,
    string NameArabic,
    string LocalizedName,
    string RevelationType,
    int VerseCount
);

public record GetSurahByIdQuery(int SurahId) : IRequest<SurahDto?>, ICacheableQuery
{
    public string CacheKey => $"surah:{SurahId}";
}

public class GetSurahByIdQueryValidator : AbstractValidator<GetSurahByIdQuery>
{
    public GetSurahByIdQueryValidator()
    {
        RuleFor(x => x.SurahId)
            .InclusiveBetween(1, 114)
            .WithMessage("Surah ID must be between 1 and 114.");
    }
}

public class GetSurahByIdQueryHandler : IRequestHandler<GetSurahByIdQuery, SurahDto?>
{
    private readonly IQuranRepository _quranRepository;
    private readonly ICultureContext _cultureContext;

    public GetSurahByIdQueryHandler(IQuranRepository quranRepository, ICultureContext cultureContext)
    {
        _quranRepository = quranRepository;
        _cultureContext = cultureContext;
    }

    public async Task<SurahDto?> Handle(GetSurahByIdQuery request, CancellationToken cancellationToken)
    {
        var surah = await _quranRepository.GetSurahByIdAsync(request.SurahId, cancellationToken);
        if (surah == null) return null;

        var localizedName = _cultureContext.IsPersian ? surah.NamePersian : surah.NameEnglish;
        return new SurahDto(surah.Id, surah.Number, surah.NameArabic, localizedName, surah.RevelationType, surah.VerseCount);
    }
}
