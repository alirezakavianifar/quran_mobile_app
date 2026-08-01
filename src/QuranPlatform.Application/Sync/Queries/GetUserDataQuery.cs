using MediatR;
using QuranPlatform.Application.Sync.Commands;
using QuranPlatform.Application.Sync.DTOs;

namespace QuranPlatform.Application.Sync.Queries;

public record GetUserDataQuery(string UserId) : IRequest<SyncPayloadDto?>;

public class GetUserDataQueryHandler : IRequestHandler<GetUserDataQuery, SyncPayloadDto?>
{
    public Task<SyncPayloadDto?> Handle(GetUserDataQuery request, CancellationToken cancellationToken)
    {
        var data = SyncUserDataCommandHandler.GetUserPayload(request.UserId);
        return Task.FromResult(data);
    }
}
