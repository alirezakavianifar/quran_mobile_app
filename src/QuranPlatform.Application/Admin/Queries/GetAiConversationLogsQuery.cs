using MediatR;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.Application.Admin.Queries;

public record GetAiConversationLogsQuery(int Limit = 50) : IRequest<IEnumerable<AiConversationLogDto>>;

public class GetAiConversationLogsQueryHandler : IRequestHandler<GetAiConversationLogsQuery, IEnumerable<AiConversationLogDto>>
{
    private readonly IAdminRepository _adminRepository;

    public GetAiConversationLogsQueryHandler(IAdminRepository adminRepository)
    {
        _adminRepository = adminRepository;
    }

    public async Task<IEnumerable<AiConversationLogDto>> Handle(GetAiConversationLogsQuery request, CancellationToken cancellationToken)
    {
        return await _adminRepository.GetAiConversationLogsAsync(request.Limit, cancellationToken);
    }
}
