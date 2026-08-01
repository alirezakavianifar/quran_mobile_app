using FluentAssertions;
using Moq;
using QuranPlatform.Application.Admin.Queries;
using QuranPlatform.Domain.Repositories;
using Xunit;

namespace QuranPlatform.UnitTests.Admin;

public class AdminQueryTests
{
    private readonly Mock<IAdminRepository> _adminRepositoryMock;

    public AdminQueryTests()
    {
        _adminRepositoryMock = new Mock<IAdminRepository>();
    }

    [Fact]
    public async Task GetSystemStatsQueryHandler_ReturnsSystemStats()
    {
        // Arrange
        var expectedStats = new SystemStatsDto(114, 6236, 2, 2, 10, "Healthy", "Healthy", "Healthy");
        _adminRepositoryMock.Setup(r => r.GetSystemStatsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedStats);

        var handler = new GetSystemStatsQueryHandler(_adminRepositoryMock.Object);

        // Act
        var result = await handler.Handle(new GetSystemStatsQuery(), CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.TotalSurahs.Should().Be(114);
        result.TotalVerses.Should().Be(6236);
        result.DatabaseStatus.Should().Be("Healthy");
    }

    [Fact]
    public async Task GetSearchAnalyticsQueryHandler_ReturnsSearchAnalytics()
    {
        // Arrange
        var expectedAnalytics = new SearchAnalyticsDto(
            100,
            70,
            30,
            new List<SearchQueryStatDto> { new("صبر", 40, 10.0) }
        );
        _adminRepositoryMock.Setup(r => r.GetSearchAnalyticsAsync(It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedAnalytics);

        var handler = new GetSearchAnalyticsQueryHandler(_adminRepositoryMock.Object);

        // Act
        var result = await handler.Handle(new GetSearchAnalyticsQuery(), CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.TotalSearchQueries.Should().Be(100);
        result.TopQueries.Should().HaveCount(1);
    }

    [Fact]
    public async Task GetAiConversationLogsQueryHandler_ReturnsLogs()
    {
        // Arrange
        var expectedLogs = new List<AiConversationLogDto>
        {
            new(Guid.NewGuid(), Guid.NewGuid(), "صبر در قرآن", "آیه ۲:۱۵۳", "fa", DateTime.UtcNow)
        };
        _adminRepositoryMock.Setup(r => r.GetAiConversationLogsAsync(50, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expectedLogs);

        var handler = new GetAiConversationLogsQueryHandler(_adminRepositoryMock.Object);

        // Act
        var result = await handler.Handle(new GetAiConversationLogsQuery(50), CancellationToken.None);

        // Assert
        result.Should().NotBeNull();
        result.Should().HaveCount(1);
    }
}
