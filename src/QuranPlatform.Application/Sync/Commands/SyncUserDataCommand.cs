using MediatR;
using QuranPlatform.Application.Sync.DTOs;

namespace QuranPlatform.Application.Sync.Commands;

public record SyncUserDataCommand(SyncPayloadDto Payload) : IRequest<SyncResultDto>;

public class SyncUserDataCommandHandler : IRequestHandler<SyncUserDataCommand, SyncResultDto>
{
    private static readonly Dictionary<string, SyncPayloadDto> _inMemorySyncStore = new();

    public Task<SyncResultDto> Handle(SyncUserDataCommand request, CancellationToken cancellationToken)
    {
        var payload = request.Payload;
        var userId = payload.UserId;
        var now = DateTime.UtcNow;

        if (_inMemorySyncStore.TryGetValue(userId, out var existing))
        {
            // Merge payloads with timestamp-based conflict resolution (latest wins)
            var mergedBookmarks = (existing.Bookmarks ?? new())
                .Concat(payload.Bookmarks ?? new())
                .GroupBy(b => b.VerseKey)
                .Select(g => g.OrderByDescending(b => b.Timestamp).First())
                .ToList();

            var mergedHighlights = (existing.Highlights ?? new())
                .Concat(payload.Highlights ?? new())
                .GroupBy(h => h.VerseKey)
                .Select(g => g.OrderByDescending(h => h.Timestamp).First())
                .ToList();

            var mergedNotes = (existing.Notes ?? new())
                .Concat(payload.Notes ?? new())
                .GroupBy(n => n.VerseKey)
                .Select(g => g.OrderByDescending(n => n.Timestamp).First())
                .ToList();

            var mergedHistory = (existing.ReadingHistory ?? new())
                .Concat(payload.ReadingHistory ?? new())
                .GroupBy(r => r.VerseKey)
                .Select(g => g.OrderByDescending(r => r.Timestamp).First())
                .ToList();

            var mergedPayload = new SyncPayloadDto(
                userId,
                mergedBookmarks,
                mergedHighlights,
                mergedNotes,
                mergedHistory,
                now
            );

            _inMemorySyncStore[userId] = mergedPayload;
        }
        else
        {
            _inMemorySyncStore[userId] = payload with { LastSyncedAt = now };
        }

        var totalItems = (payload.Bookmarks?.Count ?? 0) +
                         (payload.Highlights?.Count ?? 0) +
                         (payload.Notes?.Count ?? 0) +
                         (payload.ReadingHistory?.Count ?? 0);

        return Task.FromResult(new SyncResultDto(
            Success: true,
            UserId: userId,
            SyncedAt: now,
            ItemsProcessed: totalItems,
            Message: "Data synchronized successfully"
        ));
    }

    public static SyncPayloadDto? GetUserPayload(string userId)
    {
        return _inMemorySyncStore.TryGetValue(userId, out var payload) ? payload : null;
    }
}
