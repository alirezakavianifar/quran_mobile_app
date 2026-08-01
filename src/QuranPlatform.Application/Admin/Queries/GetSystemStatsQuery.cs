using MediatR;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Admin.Queries;

public record GetSystemStatsQuery : IRequest<SystemStatsDto>;

public class GetSystemStatsQueryHandler : IRequestHandler<GetSystemStatsQuery, SystemStatsDto>
{
    private readonly IAdminRepository _adminRepository;

    public GetSystemStatsQueryHandler(IAdminRepository adminRepository)
    {
        _adminRepository = adminRepository;
    }

    public async Task<SystemStatsDto> Handle(GetSystemStatsQuery request, CancellationToken cancellationToken)
    {
        return await _adminRepository.GetSystemStatsAsync(cancellationToken);
    }
}
