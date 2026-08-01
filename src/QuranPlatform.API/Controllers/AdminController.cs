using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Admin.Queries;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.API.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class AdminController : ControllerBase
{
    private readonly ISender _mediator;

    public AdminController(ISender mediator)
    {
        _mediator = mediator;
    }

    /// <summary>
    /// Returns high-level platform statistics including verse counts, user count, and subsystem statuses.
    /// </summary>
    [HttpGet("stats")]
    public async Task<ActionResult<SystemStatsDto>> GetSystemStats(CancellationToken ct)
    {
        var result = await _mediator.Send(new GetSystemStatsQuery(), ct);
        return Ok(result);
    }

    /// <summary>
    /// Returns search query analytics and top search trends across Persian and English queries.
    /// </summary>
    [HttpGet("search-analytics")]
    public async Task<ActionResult<SearchAnalyticsDto>> GetSearchAnalytics(CancellationToken ct)
    {
        var result = await _mediator.Send(new GetSearchAnalyticsQuery(), ct);
        return Ok(result);
    }

    /// <summary>
    /// Returns recent AI assistant interactions and moderation logs.
    /// </summary>
    [HttpGet("ai-logs")]
    public async Task<ActionResult<IEnumerable<AiConversationLogDto>>> GetAiLogs([FromQuery] int limit = 50, CancellationToken ct = default)
    {
        var result = await _mediator.Send(new GetAiConversationLogsQuery(limit), ct);
        return Ok(result);
    }
}
