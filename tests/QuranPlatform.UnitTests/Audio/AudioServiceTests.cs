using QuranPlatform.Application.Audio.Queries;
using Xunit;

namespace QuranPlatform.UnitTests.Audio;

public class AudioServiceTests
{
    [Fact]
    public async Task Handle_GetRecitersQuery_ReturnsAllConfiguredReciters()
    {
        // Arrange
        var handler = new GetRecitersQueryHandler();

        // Act
        var reciters = await handler.Handle(new GetRecitersQuery(), CancellationToken.None);

        // Assert
        Assert.NotNull(reciters);
        Assert.True(reciters.Count >= 4);
        Assert.Contains(reciters, r => r.Id == "alafasy");
        Assert.Contains(reciters, r => r.Id == "husary");
    }

    [Fact]
    public async Task Handle_GetAyahAudioQuery_FormatsAudioUrlAndWordTimings()
    {
        // Arrange
        var handler = new GetAyahAudioQueryHandler();
        var query = new GetAyahAudioQuery("alafasy", 2, 255);

        // Act
        var result = await handler.Handle(query, CancellationToken.None);

        // Assert
        Assert.NotNull(result);
        Assert.Equal("alafasy", result.ReciterId);
        Assert.Equal(2, result.SurahId);
        Assert.Equal(255, result.VerseNumber);
        Assert.Equal("https://everyayah.com/data/Alafasy_128kbps/002255.mp3", result.AudioUrl);
        Assert.NotNull(result.WordTimings);
        Assert.NotEmpty(result.WordTimings);
    }
}
