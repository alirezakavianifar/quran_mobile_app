using FluentValidation;
using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.Queries.GetTafsir;

public record TafsirDto(
    int Id,
    int TafsirEditionId,
    int VerseId,
    int VolumeNumber,
    string ContentText
);

public record GetTafsirForVerseQuery(string AyahKeyString, int TafsirEditionId) : IRequest<TafsirDto?>, ICacheableQuery
{
    public string CacheKey => $"tafsir:{AyahKeyString}:{TafsirEditionId}";
}

public class GetTafsirForVerseQueryValidator : AbstractValidator<GetTafsirForVerseQuery>
{
    public GetTafsirForVerseQueryValidator()
    {
        RuleFor(x => x.AyahKeyString).NotEmpty();
        RuleFor(x => x.TafsirEditionId).GreaterThan(0);
    }
}

public class GetTafsirForVerseQueryHandler : IRequestHandler<GetTafsirForVerseQuery, TafsirDto?>
{
    private readonly ITafsirRepository _tafsirRepository;

    public GetTafsirForVerseQueryHandler(ITafsirRepository tafsirRepository)
    {
        _tafsirRepository = tafsirRepository;
    }

    public async Task<TafsirDto?> Handle(GetTafsirForVerseQuery request, CancellationToken cancellationToken)
    {
        var key = AyahKey.Parse(request.AyahKeyString);
        var tafsir = await _tafsirRepository.GetTafsirForVerseAsync(key, request.TafsirEditionId, cancellationToken);
        if (tafsir == null) return null;

        return new TafsirDto(tafsir.Id, tafsir.TafsirEditionId, tafsir.VerseId, tafsir.VolumeNumber, tafsir.ContentText);
    }
}
