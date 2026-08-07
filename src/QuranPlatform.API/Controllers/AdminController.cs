using MediatR;
using Microsoft.AspNetCore.Mvc;
using QuranPlatform.Application.Admin.Queries;
using QuranPlatform.Application.Common.Interfaces;
using QuranPlatform.Domain.Repositories;

namespace QuranPlatform.API.Controllers;

public record UpdateAiProviderRequest(string Provider);

[ApiController]
[Route("api/v1/[controller]")]
public class AdminController : ControllerBase
{
    private readonly ISender _mediator;
    private readonly IAiConfigurationService _aiConfigService;

    public AdminController(ISender mediator, IAiConfigurationService aiConfigService)
    {
        _mediator = mediator;
        _aiConfigService = aiConfigService;
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

    /// <summary>
    /// Returns current active AI provider configuration and available providers.
    /// </summary>
    [HttpGet("ai-provider")]
    public ActionResult<AiProviderStatusDto> GetAiProviderStatus()
    {
        var status = _aiConfigService.GetProviderStatus();
        return Ok(status);
    }

    /// <summary>
    /// Dynamically switches active AI provider (e.g. "Gemini", "Grok", "Mock") at runtime.
    /// </summary>
    [HttpPost("ai-provider")]
    public IActionResult SetAiProvider([FromBody] UpdateAiProviderRequest request)
    {
        if (request == null || string.IsNullOrWhiteSpace(request.Provider))
        {
            return BadRequest(new { message = "Provider field cannot be empty." });
        }

        var success = _aiConfigService.SetActiveProvider(request.Provider);
        if (!success)
        {
            return BadRequest(new
            {
                message = $"Invalid provider '{request.Provider}'. Supported providers are: {string.Join(", ", _aiConfigService.GetAvailableProviders())}"
            });
        }

        var updatedStatus = _aiConfigService.GetProviderStatus();
        return Ok(new
        {
            message = $"Active AI provider successfully updated to '{updatedStatus.ActiveProvider}'.",
            status = updatedStatus
        });
    }
}
