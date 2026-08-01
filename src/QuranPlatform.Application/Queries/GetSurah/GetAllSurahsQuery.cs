using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Queries.GetSurah;

public record GetAllSurahsQuery : IRequest<IEnumerable<SurahDto>>, ICacheableQuery
{
    public string CacheKey => "surahs:all";
}

public class GetAllSurahsQueryHandler : IRequestHandler<GetAllSurahsQuery, IEnumerable<SurahDto>>
{
    private readonly IQuranRepository _quranRepository;
    private readonly ICultureContext _cultureContext;

    public GetAllSurahsQueryHandler(IQuranRepository quranRepository, ICultureContext cultureContext)
    {
        _quranRepository = quranRepository;
        _cultureContext = cultureContext;
    }

    public async Task<IEnumerable<SurahDto>> Handle(GetAllSurahsQuery request, CancellationToken cancellationToken)
    {
        var surahs = await _quranRepository.GetAllSurahsAsync(cancellationToken);
        return surahs.Select(s => new SurahDto(
            s.Id,
            s.Number,
            s.NameArabic,
            _cultureContext.IsPersian ? s.NamePersian : s.NameEnglish,
            s.RevelationType,
            s.VerseCount
        ));
    }
}
