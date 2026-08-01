using FluentValidation;
using MediatR;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Search;
using QuranPlatform.Domain.ValueObjects;

namespace QuranPlatform.Application.Queries.Search;

public record SearchVersesQuery(
    string QueryText,
    int Page = 1,
    int PageSize = 20
) : IRequest<SearchResultPayload>, ICacheableQuery
{
    public string CacheKey => $"search:{QueryText}:{Page}:{PageSize}";
}

public class SearchVersesQueryValidator : AbstractValidator<SearchVersesQuery>
{
    public SearchVersesQueryValidator()
    {
        RuleFor(x => x.QueryText)
            .NotEmpty()
            .WithMessage("Search query text cannot be empty.")
            .MaximumLength(500)
            .WithMessage("Search query text cannot exceed 500 characters.");

        RuleFor(x => x.Page)
            .GreaterThanOrEqualTo(1)
            .WithMessage("Page must be greater than or equal to 1.");

        RuleFor(x => x.PageSize)
            .InclusiveBetween(1, 100)
            .WithMessage("PageSize must be between 1 and 100.");
    }
}

public class SearchVersesQueryHandler : IRequestHandler<SearchVersesQuery, SearchResultPayload>
{
    private readonly ISearchOrchestrator _searchOrchestrator;
    private readonly ICultureContext _cultureContext;

    public SearchVersesQueryHandler(ISearchOrchestrator searchOrchestrator, ICultureContext cultureContext)
    {
        _searchOrchestrator = searchOrchestrator;
        _cultureContext = cultureContext;
    }

    public async Task<SearchResultPayload> Handle(SearchVersesQuery request, CancellationToken cancellationToken)
    {
        var culture = new PreferredCulture(_cultureContext.CurrentCultureName);
        var searchQuery = new SearchQuery(request.QueryText, culture, request.Page, request.PageSize);
        return await _searchOrchestrator.SearchAsync(searchQuery, cancellationToken);
    }
}
