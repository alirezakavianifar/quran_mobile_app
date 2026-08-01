using MediatR;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Admin.Queries;

public record GetSearchAnalyticsQuery : IRequest<SearchAnalyticsDto>;

public class GetSearchAnalyticsQueryHandler : IRequestHandler<GetSearchAnalyticsQuery, SearchAnalyticsDto>
{
    private readonly IAdminRepository _adminRepository;

    public GetSearchAnalyticsQueryHandler(IAdminRepository adminRepository)
    {
        _adminRepository = adminRepository;
    }

    public async Task<SearchAnalyticsDto> Handle(GetSearchAnalyticsQuery request, CancellationToken cancellationToken)
    {
        return await _adminRepository.GetSearchAnalyticsAsync(cancellationToken);
    }
}
