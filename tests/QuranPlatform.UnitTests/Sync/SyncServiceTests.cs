using QuranPlatform.Application.Sync.Commands;
using QuranPlatform.Application.Sync.DTOs;
using QuranPlatform.Application.Sync.Queries;
using Xunit;

namespace QuranPlatform.UnitTests.Sync;

public class SyncServiceTests
{
    [Fact]
    public async Task Handle_SyncUserDataCommand_SavesAndMergesPayloadCorrectly()
    {
        // Arrange
        var userId = "user-test-123";
        var payload = new SyncPayloadDto(
            UserId: userId,
            Bookmarks: new List<SyncBookmarkDto>
            {
                new SyncBookmarkDto("2:255", DateTime.UtcNow, "Favorites")
            },
            Highlights: new List<SyncHighlightDto>
            {
                new SyncHighlightDto("2:255", "#FFD700", DateTime.UtcNow)
            },
            Notes: new List<SyncNoteDto>
            {
                new SyncNoteDto("2:255", "Ayat al-Kursi reflection", DateTime.UtcNow)
            }
        );

        var command = new SyncUserDataCommand(payload);
        var handler = new SyncUserDataCommandHandler();

        // Act
        var result = await handler.Handle(command, CancellationToken.None);

        // Assert
        Assert.True(result.Success);
        Assert.Equal(userId, result.UserId);
        Assert.Equal(3, result.ItemsProcessed);

        // Verify state via GetUserDataQuery
        var queryHandler = new GetUserDataQueryHandler();
        var savedData = await queryHandler.Handle(new GetUserDataQuery(userId), CancellationToken.None);

        Assert.NotNull(savedData);
        Assert.Single(savedData.Bookmarks!);
        Assert.Equal("2:255", savedData.Bookmarks![0].VerseKey);
    }
}
